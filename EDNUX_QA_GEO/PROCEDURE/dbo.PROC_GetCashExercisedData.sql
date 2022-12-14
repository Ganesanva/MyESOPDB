/****** Object:  StoredProcedure [dbo].[PROC_GetCashExercisedData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCashExercisedData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCashExercisedData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetCashExercisedData] 
	-- Add the parameters for the stored procedure here
	@STARTDATE AS VARCHAR(10), 
	@ENDDATE AS VARCHAR(10),
	@SendData AS BIT = 0,
	@Updated_By AS VARCHAR(100) = ''
		
AS
BEGIN
	DECLARE @SQL1 VARCHAR(MAX), @SQL2 VARCHAR(MAX), @SQL3 VARCHAR(MAX), @Date_of_transfer_of_Shares VARCHAR(500)
	
	IF @SendData = 0
		BEGIN
			SET @Date_of_transfer_of_Shares  =  'NULL AS [Date of transfer of Shares]'
			SET @Updated_By = 'NULL AS UPDATED_BY, NULL AS UPDATED_ON '
		END
	ELSE
		BEGIN
			SET @Date_of_transfer_of_Shares = 'GETDATE() AS [Date of transfer of Shares]'
			SET @Updated_By = CHAR(39) + @Updated_By + CHAR(39) + ' AS UPDATED_BY, GETDATE() AS UPDATED_ON '
		END
	
	
	--PRINT @Date_of_transfer_of_Shares
	
SET @SQL1 = 'SELECT	
			EmployeeID as [Employee ID],	EmployeeName as [Employee Name], ResidentialStatus AS [Residential Status of employee],	CASE WHEN Country = NULL THEN COUNTRY ELSE (SELECT CountryName FROM CountryMaster WHERE CountryAliasName = COUNTRY) END AS COUNTRY, [FORM10 Status] AS [FORM 10 F Status], [TRC Status],	
			[PAN Details],	REPLACE(CONVERT(VARCHAR(11),ExercisedDate,106),'' '', ''-'') AS [Date of Exercise], REPLACE(CONVERT(VARCHAR(11),GrantDate,106),'' '', ''-'') AS [Date of Grant],	ExercisedQuantity AS [Options Exercised],	
			ExercisedPrice AS [Exercise Price (Rs.)], FMVPrice AS [FMV (Rs.)],	[Exercise Amount Payable (Rs.)],	[Perquisite Value (Rs.)],
			[Perquisite Tax (Rs.)], [Capital Gain Value (Rs.)],	[Capital Gain Tax (Rs.)], ([Perquisite Tax (Rs.)] + [Capital Gain Tax (Rs.)] + [Total Amount Payable (Rs.)]) AS  [Total Amount Payable (Rs.)],	PaymentMode AS [Mode of payment],'
			
IF(@SendData = 1)
	SET @SQL1 = @SQL1 + '[Date of transfer of Shares], UPDATED_BY, UPDATED_ON, '
			
SET @SQL1 = @SQL1 + 'ExerciseNo AS [Exercise Number], ExercisedId AS [Exercise ID], Perq_Tax_rate AS [Perq Tax Rate],SharesIssuedDate AS [SharesIssuedDate]
			FROM 
	(
	SELECT EMP.EMPLOYEEID as EmployeeID, SUM(ISNULL(EX.SHARESARISED,0)) AS SharesArised, SUM(ISNULL(EX.SAREXERCISEAMOUNT,0)) as SARExerciseAmount,	EX.EXERCISEDID as ExercisedId, MAX(EMP.EMPLOYEENAME) as EmployeeName,  
			MAX(GR.GRANTREGISTRATIONID) as GrantRegistrationId, GO.GRANTOPTIONID,  MAX(GR.GRANTDATE) as GrantDate,   SUM(EX.BONUSSPLITEXERCISEDQUANTITY) as ExercisedQuantity , 
			ISNULL((SELECT SHARESISSUED FROM EXERCISESARDETAILS WHERE EXERCISESARDETAILS.EXERCISESARID = EX.EXERCISESARID) , SUM(EX.BONUSSPLITEXERCISEDQUANTITY)) as SharesAlloted, 
			EX.EXERCISEDDATE as ExercisedDate, EX.EXERCISEDPRICE as ExercisedPrice,  MAX(SCH.SCHEMETITLE) as SchemeTitle, MAX(SCH.OPTIONRATIOMULTIPLIER) as OptionRatioMultiplier, 
			SCH.SCHEMEID, MAX(SCH.OPTIONRATIODIVISOR) as OptionRatioDivisor, EX.SHARESISSUEDDATE as SharesIssuedDate, 
			CASE WHEN (MAX(EX.DRAWNON)=''1900-01-01 00:00:00.000'') THEN NULL ELSE MAX(EX.DRAWNON) END AS DateOfPayment, 
			CASE WHEN (SELECT DISPLAYAS FROM BONUSSPLITPOLICY) = ''S'' THEN CASE WHEN MAX(GL.PARENT) = ''N'' THEN ''Original'' ELSE ''Bonus'' END  ELSE ''---'' END AS Parent,
			GL.FINALVESTINGDATE as VestingDate,	GL.GRANTLEGID as GrantLegId, SUM(ISNULL(EX.FBTPAYABLE,0)) AS FBTValue, EX.CASH as Cash , 
			(SELECT SUM(PERQVALUE)  FROM EXERCISESARDETAILS WHERE EXERCISESARDETAILS.EXERCISESARID = EX.EXERCISESARID) AS SAR_PerqValue, 
			(SELECT FACEVALUE FROM EXERCISESARDETAILS ESD WHERE ESD.EXERCISESARID = EX.EXERCISESARID) AS FaceValue, 
			
			CASE WHEN UPPER(DematDetails.ResidentialStatus) = ''INDIAN RESIDENT'' THEN 
				ISNULL(CONVERT(VARCHAR, SUM(CONVERT(NUMERIC(18,2),ISNULL(EX.PERQSTVALUE,0)))),'''') 
			ELSE
				'''' 
			END AS [Perquisite Value (Rs.)],
			
			CASE WHEN UPPER(DematDetails.ResidentialStatus) = ''INDIAN RESIDENT'' THEN
				ISNULL( CONVERT(VARCHAR,SUM(CONVERT(NUMERIC(18,2),ISNULL(EX.PERQSTPAYABLE,0)))),'''')  
			ELSE
				'''' 
			END AS [Perquisite Tax (Rs.)], 
			
			CASE WHEN UPPER(DematDetails.ResidentialStatus) = ''NON RESIDENT INDIAN'' OR UPPER(DematDetails.ResidentialStatus) = ''FOREIGN NATIONAL'' THEN
				ISNULL(CONVERT(VARCHAR, SUM(CONVERT(NUMERIC(18,2),ISNULL(EX.PERQSTVALUE,0)))),'''') 
			ELSE
				'''' 
			END AS [Capital Gain Value (Rs.)],
			
			CASE WHEN UPPER(DematDetails.ResidentialStatus) = ''NON RESIDENT INDIAN'' OR UPPER(DematDetails.ResidentialStatus) = ''FOREIGN NATIONAL'' THEN
				ISNULL( CONVERT(VARCHAR,SUM(CONVERT(NUMERIC(18,2),ISNULL(EX.PERQSTPAYABLE,0)))),'''')  
			ELSE
				'''' 
			END AS [Capital Gain Tax (Rs.)], 
			
			
			ISNULL(CONVERT(VARCHAR, SUM(CONVERT(NUMERIC(18,2),EX.FMVPRICE))),'''')  AS FMVPrice  , 
			CASE   WHEN (EX.TRAVELDAYS >0) THEN  ISNULL(EX.FBTDAYS,0) ELSE 	MAX(DATEDIFF(D,GR.GRANTDATE,GL.FINALVESTINGDATE))  END AS FBTdays,
			ISNULL(EX.TRAVELDAYS,0) as  TravelDays, PM.PAYMODENAME as PaymentMode, MAX(EX.PERQ_TAX_RATE) AS PerqTaxRate, EX.EXERCISENO as ExerciseNo, 
			CASE WHEN (SELECT FaceValue from ExerciseSARDetails ESD where ESD.ExerciseSARid = ex.ExerciseSARid) > 0 THEN
				isnull((select SharesIssued from ExerciseSARDetails where ExerciseSARDetails.ExerciseSARid = ex.ExerciseSARid),sum(ex.BonusSplitExercisedQuantity)) * (SELECT FaceValue from ExerciseSARDetails ESD where ESD.ExerciseSARid = ex.ExerciseSARid)
			ELSE
				isnull((select SharesIssued from ExerciseSARDetails where ExerciseSARDetails.ExerciseSARid = ex.ExerciseSARid),sum(ex.BonusSplitExercisedQuantity)) * ex.exercisedprice
			END AS Exercise_Amount , '
		
SET @SQL2 ='
			(
			SELECT top 1 * FROM 
				(
					SELECT CASE  
								WHEN (SHEX.paymentmode = ''D'' OR SHEX.paymentmode = ''Q'' OR SHEX.paymentmode = ''R'' OR SHEX.paymentmode = ''W'') THEN SHOFF.DrawnOn  
								WHEN (SHEX.paymentmode = ''A'' OR SHEX.paymentmode = ''P'') THEN NULL  
								WHEN (SHEX.paymentmode = ''F'') THEN SHFUND.DDDate  
								WHEN (SHEX.paymentmode = ''N'') THEN SHON.Transaction_Date  
								ELSE NULL  
								END AS paymentdate  
							FROM   shexercisedoptions SHEX INNER JOIN employeemaster EMPInner ON SHEX.employeeid = EMPInner.employeeid  
								LEFT OUTER JOIN shtransactiondetails SHOFF ON SHEX.ExerciseNo = SHOFF.ExerciseNo  
								LEFT OUTER JOIN transactiondetails_funding SHFUND ON SHEX.exerciseno = SHFUND.exerciseno   
								LEFT OUTER JOIN transaction_details SHON ON SHEX.exerciseno = SHON.exerciseno   
								LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SHEX.ExerciseNo = SHCASH.ExerciseNo   
							WHERE   
								CONVERT(DATE,shex.exercisedate) between CONVERT(DATE,''' + @STARTDATE + ''') and CONVERT(DATE,''' + @ENDDATE + ''')
								AND 
								EMPInner.loginid = EMP.LoginID 
								AND SHEX.ExerciseId = ex.ExercisedId
								and  SHEX.ExerciseNo = ex.ExerciseNo
								and SHEX.ExerciseDate = ex.ExercisedDate
								and SHEX.PaymentMode = ex.PaymentMode
								
								
					UNION  
					SELECT CASE   
							WHEN (EXER.paymentmode = ''D'' OR EXER.paymentmode = ''Q'' OR EXER.paymentmode = ''R'' OR EXER.paymentmode = ''W'') THEN SHOFF.DrawnOn  
							WHEN (EXER.paymentmode = ''A'' OR EXER.paymentmode = ''P'') THEN NULL  
							WHEN (EXER.paymentmode = ''F'') THEN SHFUND.DDDate  
							WHEN (EXER.paymentmode = ''N'') THEN SHON.Transaction_Date  
							ELSE NULL END  AS paymentdate   
							FROM   exercised EXER INNER JOIN grantleg GL ON EXER.grantlegserialnumber = GL.id   
							INNER JOIN grantoptions GRO ON GL.grantoptionid = GRO.grantoptionid  
							LEFT OUTER JOIN shtransactiondetails SHOFF ON EXER.ExerciseNo = SHOFF.ExerciseNo  
							LEFT OUTER JOIN transactiondetails_funding SHFUND ON EXER.exerciseno = SHFUND.exerciseno   
							LEFT OUTER JOIN transaction_details SHON ON EXER.exerciseno = SHON.exerciseno   
							LEFT OUTER JOIN transactiondetails_cashless SHCASH ON EXER.ExerciseNo = SHCASH.ExerciseNo   
							WHERE 
						   CONVERT(DATE,exer.exerciseddate) between CONVERT(DATE,''' + @STARTDATE + ''') and CONVERT(DATE,''' + @ENDDATE + ''')
							AND  
							GRO.employeeid = EMP.EmployeeID  
							AND EXER.ExercisedId = ex.ExercisedId
							and  EXER.ExerciseNo = ex.ExerciseNo
							and EXER.ExercisedDate = ex.ExercisedDate
							and EXER.PaymentMode = ex.PaymentMode
					        
					) AS employee_DOP
				) AS [Date of Payment],
				
				(
				SELECT top 1 * FROM 
				(
					SELECT CASE  
								WHEN (SHEX.paymentmode = ''D'' OR SHEX.paymentmode = ''Q'' OR SHEX.paymentmode = ''R'' OR SHEX.paymentmode = ''W'') THEN SHOFF.CountryName  
								WHEN (SHEX.paymentmode = ''A'' OR SHEX.paymentmode = ''P'') THEN SHCASH.CountryName
								WHEN (SHEX.paymentmode = ''F'') THEN SHFUND.CountryName  
								WHEN (SHEX.paymentmode = ''N'') THEN SHON.CountryName  
								ELSE NULL  
								END AS Country  
							FROM   shexercisedoptions SHEX INNER JOIN employeemaster EMPInner ON SHEX.employeeid = EMPInner.employeeid  
								LEFT OUTER JOIN shtransactiondetails SHOFF ON SHEX.ExerciseNo = SHOFF.ExerciseNo  
								LEFT OUTER JOIN transactiondetails_funding SHFUND ON SHEX.exerciseno = SHFUND.exerciseno   
								LEFT OUTER JOIN transaction_details SHON ON SHEX.exerciseno = SHON.exerciseno   
								LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SHEX.ExerciseNo = SHCASH.ExerciseNo   
							WHERE   
								CONVERT(DATE,shex.exercisedate) between CONVERT(DATE,''' + @STARTDATE + ''') and CONVERT(DATE,''' + @ENDDATE + ''')
								AND 
								 EMPInner.loginid = EMP.LoginID 
								AND SHEX.ExerciseId = ex.ExercisedId
								and  SHEX.ExerciseNo = ex.ExerciseNo
								and SHEX.ExerciseDate = ex.ExercisedDate
								and SHEX.PaymentMode = ex.PaymentMode
								
								
					UNION  
					SELECT CASE   
							WHEN (EXER.paymentmode = ''D'' OR EXER.paymentmode = ''Q'' OR EXER.paymentmode = ''R'' OR EXER.paymentmode = ''W'') THEN SHOFF.CountryName  
							WHEN (EXER.paymentmode = ''A'' OR EXER.paymentmode = ''P'') THEN SHCASH.CountryName  
							WHEN (EXER.paymentmode = ''F'') THEN SHFUND.CountryName  
							WHEN (EXER.paymentmode = ''N'') THEN SHON.CountryName  
							ELSE NULL END  AS Country   
							FROM   exercised EXER INNER JOIN grantleg GL ON EXER.grantlegserialnumber = GL.id   
							INNER JOIN grantoptions GRO ON GL.grantoptionid = GRO.grantoptionid  
							LEFT OUTER JOIN shtransactiondetails SHOFF ON EXER.ExerciseNo = SHOFF.ExerciseNo  
							LEFT OUTER JOIN transactiondetails_funding SHFUND ON EXER.exerciseno = SHFUND.exerciseno   
							LEFT OUTER JOIN transaction_details SHON ON EXER.exerciseno = SHON.exerciseno   
							LEFT OUTER JOIN transactiondetails_cashless SHCASH ON EXER.ExerciseNo = SHCASH.ExerciseNo   
							WHERE 
						   CONVERT(DATE,exer.exerciseddate) between CONVERT(DATE,''' + @STARTDATE + ''') and CONVERT(DATE,''' + @ENDDATE + ''')
							AND  
							GRO.employeeid = EMP.EmployeeID  
							AND EXER.ExercisedId = ex.ExercisedId
							and  EXER.ExerciseNo = ex.ExerciseNo
							and EXER.ExercisedDate = ex.ExercisedDate
							and EXER.PaymentMode = ex.PaymentMode
					        
					) AS Country
				) AS Country,'
SET @SQL3 ='				
				EMP.AccountNo AS [Account number], EMP.ConfStatus AS ConfStatus, EMP.DateOfJoining, EMP.DateOfTermination, EMP.Department, EMP.EmployeeDesignation,
				EMP.Entity AS Entity, EMP.Grade AS Grade, EMP.Insider AS Insider, RFT.reason AS ReasonForTermination, EMP.SBU AS SBU,
				DematDetails.ResidentialStatus,DematDetails.ITCircle_WardNumber,DematDetails.DepositoryName,DematDetails.DepositoryParticipatoryName,
				DematDetails.ConfirmationDate,DematDetails.NameAsPerDPrecord,DematDetails.EmployeeAddress,DematDetails.EmployeeEmail,DematDetails.EmployeePhone,
				DematDetails.PAN_GIRNumber AS [PAN Details],DematDetails.DematACType,DematDetails.DPIDNumber,DematDetails.ClientIDNumber,DematDetails.Location,
				(CASE WHEN EX.IsForm10FReceived = 0 THEN ''No'' WHEN EX.IsForm10FReceived = 1 THEN ''Yes'' WHEN EX.IsForm10FReceived = 2 THEN ''Deemed to be received'' END) AS [FORM10 Status],
				(CASE WHEN EX.IsTRCFormReceived = 0 THEN ''No'' WHEN EX.IsTRCFormReceived = 1 THEN ''Yes'' WHEN EX.IsTRCFormReceived = 2 THEN ''Deemed to be received'' END) AS [TRC Status],
				(SUM(EX.BONUSSPLITEXERCISEDQUANTITY) * EX.ExercisedPrice) AS [Exercise Amount Payable (Rs.)],
				(SUM(EX.BONUSSPLITEXERCISEDQUANTITY) * EX.ExercisedPrice) AS [Total Amount Payable (Rs.)],
				'+ @Date_of_transfer_of_Shares +',
				'+ @Updated_By +', EX.Perq_Tax_rate
		
	FROM  EMPLOYEEMASTER EMP 
			INNER JOIN GrantOptions go on EMP.EmployeeId = GO.EmployeeId  
			INNER JOIN GrantRegistration GR  on GR.GrantRegistrationId = GO.GrantRegistrationId  
			INNER JOIN GrantLeg GL on GO.GrantOptionId = GL.GrantOptionId  
			INNER JOIN Exercised EX on  ex.GrantLegSerialNumber = GL.ID 
			LEFT OUTER JOIN ReasonForTermination RFT on EMP.ReasonForTermination = RFT.id
			INNER JOIN Scheme SCH  on GO.SchemeId = SCH.SchemeId  
			LEFT OUTER JOIN PaymentMaster PM on Pm.PaymentMode=Ex.PaymentMode 
			RIGHT OUTER JOIN FunEmployeeDematDetails(CONVERT(DATE,''' + @STARTDATE + '''),CONVERT(DATE,''' + @ENDDATE + ''')) DematDetails ON ex.ExercisedID=DematDetails.ExercisedID 			
		
	WHERE	CONVERT(DATE,ex.ExercisedDate) between CONVERT(DATE,''' + @STARTDATE + ''') and CONVERT(DATE,''' + @ENDDATE + ''')
			AND UPPER(PM.PAYMODENAME) NOT IN  (''SELL-ALL'',''SELL PARTIAL'')
			AND EX.ExercisedId NOT IN (SELECT Exercise_ID FROM CashExercisedData)
						
	GROUP BY EMP.LOGINID,EX.PAYMENTMODE,SCH.SCHEMEID,EMP.EMPLOYEEID ,EX.SHARESARISED,EX.SAREXERCISEAMOUNT,EX.EXERCISEDID,GO.GRANTOPTIONID, EX.EXERCISEDDATE,EX.SHARESISSUEDDATE,EX.EXERCISEDPRICE,GL.FINALVESTINGDATE,GL.GRANTLEGID,EX.CASH,EX.FBTDAYS,EX.TRAVELDAYS,PM.PAYMODENAME,EX.EXERCISENO,
	EMP.ACCOUNTNO , EMP.CONFSTATUS , EMP.DATEOFJOINING , EMP.DATEOFTERMINATION,EMP.DEPARTMENT , EMP.EMPLOYEEDESIGNATION ,
	EMP.ENTITY , EMP.GRADE , EMP.INSIDER , RFT.REASON , EMP.SBU,EX.EXERCISESARID,
	DEMATDETAILS.RESIDENTIALSTATUS,DEMATDETAILS.ITCIRCLE_WARDNUMBER,DEMATDETAILS.DEPOSITORYNAME,DEMATDETAILS.DEPOSITORYPARTICIPATORYNAME,
	DEMATDETAILS.CONFIRMATIONDATE,DEMATDETAILS.NAMEASPERDPRECORD,DEMATDETAILS.EMPLOYEEADDRESS,DEMATDETAILS.EMPLOYEEEMAIL,DEMATDETAILS.EMPLOYEEPHONE,
	DEMATDETAILS.PAN_GIRNUMBER,DEMATDETAILS.DEMATACTYPE,DEMATDETAILS.DPIDNUMBER,DEMATDETAILS.CLIENTIDNUMBER,DEMATDETAILS.LOCATION,
	EX.ISTRCFORMRECEIVED, EX.ISFORM10FRECEIVED, EX.Perq_Tax_rate
	)
	AS SQL_OUTPUT
	ORDER BY SCHEMEID,EMPLOYEEID ASC
	'
	
--PRINT @SQL1
--PRINT @SQL2
--PRINT @SQL3
EXEC (@SQL1 + @SQL2 + @SQL3)
END
GO
