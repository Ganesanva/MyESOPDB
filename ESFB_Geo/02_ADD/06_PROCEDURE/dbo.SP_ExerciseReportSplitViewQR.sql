IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_ExerciseReportSplitViewQR')
BEGIN
DROP PROCEDURE SP_ExerciseReportSplitViewQR
END
GO

create   PROCEDURE [dbo].[SP_ExerciseReportSplitViewQR]
(
	@START_DATE DATETIME,
	@END_DATE DATETIME,
	@EMPLOYEE_ID VARCHAR(50) = '---All Employees---'
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @QUERY_1 AS VARCHAR(MAX)
	DECLARE @QUERY_2 AS VARCHAR(MAX)
	DECLARE @QUERY_3 AS VARCHAR(MAX)
	DECLARE @QUERY_4 AS VARCHAR(MAX)
	DECLARE @QUERY_5 AS VARCHAR(MAX)
	
	DECLARE @STARTDATE AS VARCHAR(50)
	DECLARE @ENDDATE AS VARCHAR(50)
	DECLARE @STR_EMPLOYEEID VARCHAR(500)
	DECLARE @FACE_VALUE AS VARCHAR (50)
	SELECT @FACE_VALUE=FaceVaue FROM  companyparameters cp 
	
		
	SET @STARTDATE = CONVERT(DATE,@START_DATE)
	SET @ENDDATE = CONVERT(DATE,@END_DATE)
		
	SET @STR_EMPLOYEEID = ''	
	IF(@EMPLOYEE_ID IS NOT NULL)
	BEGIN
		IF(@EMPLOYEE_ID <> '---All Employees---')
			SET @STR_EMPLOYEEID = ' AND emp.employeeid = '''+@EMPLOYEE_ID+''''	
	END
	
	SET @QUERY_1 =
		
		'		
		SELECT
			emp.employeeid AS EmployeeID,
			CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
			CM.countryname AS CountryName,ex.exercisedprice as ExercisePrice,CUM.CurrencyName, SUM(ISNULL(ex.sharesarised, 0)) AS SharesArised, SUM(ISNULL(ex.sarexerciseamount, 0)) AS SARExerciseAmount, 
			ex.exercisedid AS ExercisedId, MAX(emp.employeename) AS EmployeeName, MAX(gr.grantregistrationid) AS GrantRegistrationId, go.grantoptionid, MAX(gr.grantdate) AS GrantDate, 
			SUM(ex.bonussplitexercisedquantity) AS ExercisedQuantity, 
			ISNULL((SELECT sharesissued FROM exercisesardetails WITH (NOLOCK) WHERE exercisesardetails.exercisesarid = ex.exercisesarid), 
			
			SUM(ex.bonussplitexercisedquantity)) AS SharesAlloted,
			
			ex.exerciseddate AS ExercisedDate, ex.exercisedprice AS ExercisedPrice, MAX(sch.schemetitle)  AS SchemeTitle, 

			--CONVERT(INT,CEILING(((SUM(ex.bonussplitexercisedquantity)* MAX(sch.optionratiomultiplier)) / MAX(sch.optionratiodivisor)) )) AS EquivalentShares,
			
			
			MAX(sch.optionratiomultiplier)  AS OptionRatioMultiplier, sch.schemeid, MAX(sch.optionratiodivisor)  AS OptionRatioDivisor, ex.sharesissueddate  AS SharesIssuedDate, 
			CASE 
				WHEN (MAX(ex.drawnon) = ''1900-01-01 00:00:00.000'') THEN NULL 
				ELSE MAX(ex.drawnon) 
			END AS DateOfPayment, 
			CASE WHEN MAX(gl.parent) = ''N'' THEN ''Original'' ELSE ''Bonus'' END  AS Parent, 
			gl.finalvestingdate  AS VestingDate, gl.grantlegid  AS GrantLegId, SUM(ISNULL(ex.fbtpayable, 0)) AS FBTValue, ex.cash  AS Cash, 
			(SELECT Sum(perqvalue) FROM exercisesardetails WITH (NOLOCK) WHERE exercisesardetails.exercisesarid = ex.exercisesarid) AS SAR_PerqValue, 
			(SELECT facevalue FROM exercisesardetails ESD WITH (NOLOCK) WHERE ESD.exercisesarid = ex.exercisesarid) AS FaceValue, 
			'+@FACE_VALUE+' AS FACE_VALUE,
			ISNULL(CONVERT(VARCHAR, SUM(CONVERT(NUMERIC(18,2), CU.perquisitevalue))), 
			
			CONVERT(NUMERIC(18,2), ISNULL(CASE sch.CALCULATE_TAX WHEN ''rdoActualTax'' THEN SUM(ex.perqstvalue) WHEN ''rdoTentativeTax'' THEN SUM(ISNULL(ex.TentativePerqstValue, 0)) END,0))) AS  PerqstValue,
			ISNULL(SUM(CONVERT(NUMERIC(18,2), CU.perquisitetaxpaid)), 
			
			CONVERT(NUMERIC(18,2), ISNULL(CASE sch.CALCULATE_TAX WHEN ''rdoActualTax'' THEN SUM(ex.PerqstPayable) WHEN ''rdoTentativeTax'' THEN SUM(ISNULL(ex.TentativePerqstPayable, 0)) END,0))) AS  PerqstPayable,
			CONVERT(NUMERIC(18,2), ISNULL(CASE sch.CALCULATE_TAX WHEN ''rdoActualTax'' THEN SUM(ex.fmvprice) WHEN ''rdoTentativeTax'' THEN SUM(ISNULL(ex.TentativeFMVPrice, 0)) END,0)) AS  FMVPrice,		
			''FBTdays''= CASE 	
						WHEN (ex.traveldays > 0 ) THEN ISNULL(ex.fbtdays, 0) 
						ELSE Max(Datediff(d, gr.grantdate, gl.finalvestingdate)) 
					END, 
			ISNULL(ex.traveldays,0) AS TravelDays, Pm.paymodename  AS PaymentMode, ISNULL(CU.perqtax, Max(ex.perq_tax_rate)) AS PerqTaxRate, ex.exerciseno AS ExerciseNo, 
			CASE 
				WHEN (SELECT facevalue FROM exercisesardetails ESD WITH (NOLOCK) WHERE  ESD.exercisesarid = ex.exercisesarid) > 0 
				THEN ISNULL((SELECT sharesissued FROM exercisesardetails WITH (NOLOCK) WHERE exercisesardetails.exercisesarid = ex.exercisesarid), SUM(ex.bonussplitexercisedquantity)) * (SELECT facevalue FROM exercisesardetails ESD WITH (NOLOCK) WHERE ESD.exercisesarid = ex.exercisesarid) 
			ELSE Isnull((SELECT sharesissued FROM exercisesardetails WITH (NOLOCK) WHERE exercisesardetails.exercisesarid = ex.exercisesarid), Sum(ex.bonussplitexercisedquantity)) * ex.exercisedprice 
				END  AS Exercise_Amount, '
				
				Set @QUERY_2 ='( SELECT TOP 1 * FROM 
				(SELECT 
						CASE	WHEN (SHEX.paymentmode = ''D'' OR SHEX.paymentmode = ''Q'' OR SHEX.paymentmode = ''R'' OR SHEX.paymentmode = ''W'') THEN SHOFF.drawnon 
							WHEN (SHEX.paymentmode = ''A'' OR SHEX.paymentmode = ''P'' ) THEN NULL 
							WHEN (SHEX.paymentmode = ''F'' ) THEN SHFUND.dddate 
							WHEN (SHEX.paymentmode = ''N'' ) THEN SHON.transaction_date 
								 ELSE NULL 
						END AS paymentdate
						
				FROM shexercisedoptions SHEX WITH (NOLOCK)
				INNER JOIN employeemaster EMPInner WITH (NOLOCK) ON SHEX.employeeid = EMPInner.employeeid 
				LEFT OUTER JOIN shtransactiondetails SHOFF WITH (NOLOCK) ON SHEX.exerciseno = SHOFF.exerciseno 
				LEFT OUTER JOIN transactiondetails_funding SHFUND WITH (NOLOCK) ON SHEX.exerciseno = SHFUND.exerciseno 
				LEFT OUTER JOIN transaction_details SHON WITH (NOLOCK) ON SHEX.exerciseno = SHON.exerciseno 
				LEFT OUTER JOIN transactiondetails_cashless SHCASH WITH (NOLOCK) ON SHEX.exerciseno = SHCASH.exerciseno 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT WITH (NOLOCK) ON sch.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM WITH (NOLOCK) ON sch.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CUM WITH (NOLOCK) ON CIM.CurrencyID=CUM.CurrencyID		
				WHERE (CONVERT(DATE, shex.exercisedate) BETWEEN CONVERT(DATE,'''+@STARTDATE+''') AND CONVERT(DATE,'''+@ENDDATE+''')) AND EMPInner.loginid = emp.loginid 
				AND SHEX.exerciseid = ex.exercisedid AND SHEX.exerciseno = ex.exerciseno AND SHEX.exercisedate = ex.exerciseddate AND SHEX.paymentmode = ex.paymentmode 
				UNION 
				SELECT 
					CASE
						WHEN (EXER.paymentmode = ''D'' OR EXER.paymentmode = ''Q'' OR EXER.paymentmode = ''R'' OR EXER.paymentmode = ''W'') THEN SHOFF.drawnon 
						WHEN (EXER.paymentmode = ''A'' OR EXER.paymentmode = ''P'' ) THEN NULL 
						WHEN (EXER.paymentmode = ''F'' ) THEN SHFUND.dddate 
						WHEN (EXER.paymentmode = ''N'' ) THEN SHON.transaction_date 
					ELSE NULL 
						END AS paymentdate
				FROM exercised EXER  WITH (NOLOCK)
				INNER JOIN grantleg GL WITH (NOLOCK) ON EXER.grantlegserialnumber = GL.id 
				INNER JOIN grantoptions GRO WITH (NOLOCK) ON GL.grantoptionid = GRO.grantoptionid 
				LEFT OUTER JOIN shtransactiondetails SHOFF WITH (NOLOCK) ON EXER.exerciseno = SHOFF.exerciseno 
				LEFT OUTER JOIN transactiondetails_funding SHFUND WITH (NOLOCK) ON EXER.exerciseno = SHFUND.exerciseno 
				LEFT OUTER JOIN transaction_details SHON WITH (NOLOCK) ON EXER.exerciseno = SHON.exerciseno 
				LEFT OUTER JOIN transactiondetails_cashless SHCASH WITH (NOLOCK) ON EXER.exerciseno = SHCASH.exerciseno 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT WITH (NOLOCK) ON sch.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM WITH (NOLOCK) ON sch.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CUM WITH (NOLOCK) ON CIM.CurrencyID=CUM.CurrencyID		
				WHERE (CONVERT(DATE, exer.exerciseddate) BETWEEN CONVERT(DATE,'''+@STARTDATE+''') AND CONVERT(DATE,'''+@ENDDATE+''')) AND GRO.employeeid = emp.employeeid 
							   AND EXER.exercisedid = ex.exercisedid AND EXER.exerciseno = ex.exerciseno AND EXER.exerciseddate = ex.exerciseddate 
							   AND EXER.paymentmode = ex.paymentmode
			) AS employee_DOP
		)  AS Date_of_Payment
		 '				
				
		SET @QUERY_3 =', emp.accountno AS [Account number], emp.confstatus AS ConfStatus, emp.dateofjoining, emp.dateoftermination, emp.department, 	
		emp.employeedesignation, emp.entity  AS Entity, emp.grade   AS Grade, emp.insider AS Insider, rft.reason  AS ReasonForTermination, emp.sbu  AS SBU, 
		DematDetails.residentialstatus, DematDetails.itcircle_wardnumber, DematDetails.depositoryname, DematDetails.depositoryparticipatoryname, DematDetails.confirmationdate, 
		DematDetails.nameasperdprecord, DematDetails.employeeaddress, DematDetails.employeeemail, DematDetails.employeephone, DematDetails.pan_girnumber, 
		DematDetails.dematactype, DematDetails.dpidnumber, DematDetails.clientidnumber, DematDetails.location, ex.LotNumber, CUM.CurrencyAlias, MIT.MIT_ID,
		(CASE WHEN (UPPER(sch.CALCULATE_TAX) = ''RDOTENTATIVETAX'') THEN ISNULL(ex.TentativeSettlmentPrice, 0) ELSE ISNULL(ex.SettlmentPrice,0) END) AS SettlmentPrice,
		(CASE WHEN (UPPER(sch.CALCULATE_TAX) = ''RDOTENTATIVETAX'') THEN ISNULL(ex.TentativeStockApprValue, 0) ELSE ISNULL(ex.StockApprValue,0) END) AS StockApprValue,
		(CASE WHEN (UPPER(sch.CALCULATE_TAX) = ''RDOTENTATIVETAX'') THEN ISNULL(ex.TentativeCashPayoutValue, 0) ELSE ISNULL(ex.CashPayoutValue,0) END) AS CashPayoutValue,
		(CASE WHEN (UPPER (sch.CALCULATE_TAX) = ''RDOTENTATIVETAX'') THEN ISNULL(ex.TentShareAriseApprValue, 0) ELSE ISNULL(ex.ShareAriseApprValue,0) END) AS ShareAriseApprValue,
		emp.LWD, emp.COST_CENTER, emp.status, emp.BROKER_DEP_TRUST_CMP_ID,emp.BROKER_DEP_TRUST_CMP_NAME,emp.BROKER_ELECT_ACC_NUM,CM.CountryName AS Country,MS.STATE_NAME AS State,
		CEILING(((SUM(ex.bonussplitexercisedquantity)* MAX(sch.optionratiomultiplier)) / MAX(sch.optionratiodivisor)) ) AS EquivalentShares
		
		FROM
			employeemaster emp  WITH (NOLOCK)
			INNER JOIN grantoptions [GO] WITH (NOLOCK) ON emp.employeeid = [GO].employeeid 
			INNER JOIN grantregistration gr WITH (NOLOCK) ON gr.grantregistrationid = [GO].grantregistrationid 
			INNER JOIN grantleg gl WITH (NOLOCK) ON [GO].grantoptionid = gl.grantoptionid 
			INNER JOIN exercised ex WITH (NOLOCK) ON ex.grantlegserialnumber = gl.id 
			LEFT OUTER JOIN reasonfortermination rft WITH (NOLOCK) ON emp.reasonfortermination = rft.id 
			INNER JOIN scheme sch WITH (NOLOCK) ON [GO].schemeid = sch.schemeid 
			LEFT OUTER JOIN paymentmaster PM WITH (NOLOCK) ON Pm.paymentmode = Ex.paymentmode 
			RIGHT OUTER JOIN Funemployeedematdetails (CONVERT(DATE,'''+@STARTDATE+'''), CONVERT(DATE,'''+@ENDDATE+''')) DematDetails ON ex.exercisedid = DematDetails.exercisedid 
			LEFT OUTER JOIN countrymaster CM WITH (NOLOCK) ON emp.countryname = CM.countryaliasname 
			LEFT OUTER JOIN cashlessexceptionalchargesupdation CU WITH (NOLOCK) ON ex.exercisedid = CU.exerciseid 
			LEFT OUTER JOIN MST_INSTRUMENT_TYPE AS MIT WITH (NOLOCK) ON sch.MIT_ID = MIT.MIT_ID
			LEFT OUTER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM WITH (NOLOCK) ON sch.MIT_ID=CIM.MIT_ID
			LEFT OUTER JOIN CurrencyMaster AS CUM WITH (NOLOCK) ON CIM.CurrencyID=CUM.CurrencyID 
			LEFT OUTER JOIN MST_STATES MS WITH (NOLOCK) ON emp.TAX_IDENTIFIER_STATE = MS.MS_ID '
	SET @QUERY_4 =
		' 
		WHERE
			(CONVERT(DATE,ex.exerciseddate) BETWEEN CONVERT(DATE,'''+@STARTDATE+''') AND CONVERT(DATE,'''+@ENDDATE+''')) AND (sch.IsPUPEnabled <> 1)'
	 	
	 SET @QUERY_5= ' GROUP BY
			emp.loginid, ex.paymentmode,sch.MIT_ID, sch.schemeid, emp.employeeid,MIT.INSTRUMENT_NAME, CM.countryname,CUM.CurrencyName, ex.sharesarised, ex.sarexerciseamount, ex.exercisedid, 
			[GO].grantoptionid, ex.exerciseddate, ex.sharesissueddate, ex.exercisedprice, gl.finalvestingdate, gl.grantlegid, ex.cash, ex.fbtdays, 
			ex.traveldays, Pm.paymodename, ex.exerciseno, emp.accountno, emp.confstatus, emp.dateofjoining, emp.dateoftermination, emp.department, 
			emp.employeedesignation, emp.entity, emp.grade, emp.insider, rft.reason, emp.sbu, ex.exercisesarid, DematDetails.residentialstatus, 
			DematDetails.itcircle_wardnumber, DematDetails.depositoryname, DematDetails.depositoryparticipatoryname, DematDetails.confirmationdate, 
			DematDetails.nameasperdprecord, DematDetails.employeeaddress, DematDetails.employeeemail, DematDetails.employeephone, DematDetails.pan_girnumber, 
			DematDetails.dematactype, DematDetails.dpidnumber, DematDetails.clientidnumber, DematDetails.location, CU.perquisitevalue, CU.perqtax, CU.perquisitetaxpaid, ex.lotnumber, CUM.CurrencyAlias, MIT.MIT_ID, CIM.INS_DISPLY_NAME, sch.CALCULATE_TAX,
			ex.SettlmentPrice, ex.TentativeSettlmentPrice, ex.StockApprValue, ex.TentativeStockApprValue, ex.CashPayoutValue, ex.TentativeCashPayoutValue,
			emp.LWD, emp.COST_CENTER,emp.status, emp.BROKER_DEP_TRUST_CMP_ID,emp.BROKER_DEP_TRUST_CMP_NAME,emp.BROKER_ELECT_ACC_NUM,emp.TAX_IDENTIFIER_COUNTRY,CM.CountryName,MS.STATE_NAME, ex.TentShareAriseApprValue, ex.ShareAriseApprValue
			
		ORDER BY
			MIT_ID,sch.schemeid, emp.employeeid ASC'

	EXEC (@QUERY_1 + @QUERY_2 +@QUERY_3+@QUERY_4+ @STR_EMPLOYEEID + @QUERY_5)
	SET NOCOUNT OFF
END
GO

