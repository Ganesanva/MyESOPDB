/****** Object:  StoredProcedure [dbo].[GetReport192IndianEmployeesDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetReport192IndianEmployeesDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetReport192IndianEmployeesDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************************************************************
Created By    : Omprakash katre
Created Date  : 19-Aug-2013
Description   : Get details for Income tax u/s 192 (For Indian Employees)
EXEC GetReport192IndianEmployeesDetails  'RANBAXY', 'Trust412',NULL,NULL,NULL,NULL,'5000009670'
EXEC GetReport192IndianEmployeesDetails  'RANBAXY', 'Trust412',NULL,NULL,NULL,NULL,NULL
Modified Date : 02-Dec-2013
Description   : 
1. Build Where Clause
2. As discussed with Neha, Reports 195,192,194J all reports shows the after allotment data. Hence we have modified the reports(i.e fetch data from Exercised table).
3. Report 192 is display only 'Indian Employee' data.

Modified By		: Santosh P
Description		: Ranbaxy 192 and 195 report change. 
********************************************************************/

CREATE PROC [dbo].[GetReport192IndianEmployeesDetails]
@CompanyID			 VARCHAR(100),                    -- Company ID  
@TrustCompanyID      VARCHAR(100),                    -- Trust Company name             
@ExFromDate          DATETIME     =NULL,              -- Exercise From Date
@ExToDate            DATETIME     =NULL,              -- Exercise To Date
@SaleFromDate        DATETIME     =NULL,              -- Date of sale From
@SaleToDate          DATETIME     =NULL,              -- Date of sale To
@EmpID               VARCHAR(200) =NULL              -- Employee Id
AS 
BEGIN
SET NOCOUNT ON;

DECLARE @STARTDATE AS DATE
DECLARE @ENDDATE AS DATE

SET @STARTDATE = '1990-01-01'
SET @ENDDATE = CONVERT(DATE, GETDATE())

---BUILD WHERE CLAUSE
DECLARE @BUILD_WHERE_CLAUSE AS VARCHAR(MAX)
SET @BUILD_WHERE_CLAUSE = ''
BEGIN
	---Filter for Exercise From Date
	IF (@ExFromDate IS NOT NULL AND @ExFromDate <> '')
		BEGIN			
			SET @STARTDATE = @ExFromDate
		END
		
	---Filter for Exercise To Date
	IF (@ExToDate IS NOT NULL AND @ExToDate <> '')
		BEGIN
			IF(@ExFromDate IS NULL OR @ExFromDate = '')
				BEGIN
					RETURN
				END
			ELSE
				BEGIN
					SET @ENDDATE = @ExToDate
				END
		END	
	ELSE
		IF (@ExFromDate IS NOT NULL AND @ExFromDate <> '')
				BEGIN
					RETURN
				END
				
	--Filter for Employee ID
	IF (@EmpID IS NOT NULL AND @EmpID <> '---ALL---')
		BEGIN
			SET @BUILD_WHERE_CLAUSE = ' AND CONVERT(VARCHAR,EmployeeID) = ''' + @EmpID + ''''
		END
END


PRINT @BUILD_WHERE_CLAUSE

 
SELECT * 
INTO   #temp 
FROM   (SELECT emp.employeeid 
                      AS 
                      EmployeeID, 
               CM.countryname 
                      AS CountryName, 
               Sum(Isnull(ex.sharesarised, 0)) 
                      AS SharesArised, 
               Sum(Isnull(ex.sarexerciseamount, 0)) 
                      AS SARExerciseAmount, 
               ex.exercisedid 
                      AS ExercisedId, 
               Max(emp.employeename) 
                      AS EmployeeName, 
               Max(gr.grantregistrationid) 
                      AS GrantRegistrationId, 
               gop.grantoptionid, 
               Max(gr.grantdate) 
                      AS GrantDate, 
               Sum(ex.bonussplitexercisedquantity) 
                      AS ExercisedQuantity, 
               Isnull((SELECT sharesissued 
                       FROM   exercisesardetails 
                       WHERE  exercisesardetails.exercisesarid = 
                              ex.exercisesarid), 
               Sum(ex.bonussplitexercisedquantity)) 
                      AS SharesAlloted, 
               ex.exerciseddate 
                      AS ExercisedDate, 
               ex.exercisedprice 
                      AS ExercisedPrice, 
               Max(sch.schemetitle) 
                      AS SchemeTitle, 
               Max(sch.optionratiomultiplier) 
                      AS OptionRatioMultiplier, 
               sch.schemeid, 
               Max(sch.optionratiodivisor) 
                      AS OptionRatioDivisor, 
               ex.sharesissueddate 
                      AS SharesIssuedDate, 
               CASE 
                 WHEN ( Max(ex.drawnon) = '1900-01-01 00:00:00.000' ) THEN NULL 
                 ELSE Max(ex.drawnon) 
               END 
                      AS DateOfPayment, 
               CASE 
                 WHEN (SELECT displayas 
                       FROM   bonussplitpolicy) = 'S' THEN 
                   CASE 
                     WHEN Max(gl.parent) = 'N' THEN 'Original' 
                     ELSE 'Bonus' 
                   END 
                 ELSE '---' 
               END 
                      AS Parent, 
               gl.finalvestingdate 
                      AS VestingDate, 
               gl.grantlegid 
                      AS GrantLegId, 
               Sum(Isnull(ex.fbtpayable, 0)) 
                      AS FBTValue, 
               ex.cash 
                      AS Cash, 
               (SELECT Sum(perqvalue) 
                FROM   exercisesardetails 
                WHERE  exercisesardetails.exercisesarid = ex.exercisesarid) 
                      AS SAR_PerqValue, 
               (SELECT facevalue 
                FROM   exercisesardetails ESD 
                WHERE  ESD.exercisesarid = ex.exercisesarid) 
                      AS FaceValue, 
               Isnull (CONVERT(VARCHAR, Sum(CONVERT(NUMERIC(18, 2), 
                                        CU.perquisitevalue))), 
               Isnull (CONVERT(VARCHAR, Sum(CONVERT(NUMERIC(18, 2), 
                                            ex.perqstvalue))), 
               '')) AS 
               PerqstValue, 
               Convert(Varchar,Isnull (Sum(CONVERT(NUMERIC(18, 2), CU.perquisitetaxpaid)), 
               Isnull (Sum(CONVERT(NUMERIC(18, 2), ex.perqstpayable)), 0))) AS PerqstPayable, 
               Isnull (CONVERT(VARCHAR, Sum(CONVERT(NUMERIC(18, 2), 
                                        ex.fmvprice))), '0' 
                      )    AS 
               FMVPrice, 
               'FBTdays'= CASE 
                            WHEN ( ex.traveldays > 0 ) THEN 
                            Isnull(ex.fbtdays, 0) 
                            ELSE Max(Datediff(d, gr.grantdate, 
                                     gl.finalvestingdate)) 
                          END, 
               Isnull (ex.traveldays, 0) 
                      AS TravelDays, 
               Pm.paymodename 
                      AS PaymentMode, 
               Isnull(CU.perqtax, Max(ex.perq_tax_rate)) 
                      AS PerqTaxRate, 
               ex.exerciseno 
                      AS ExerciseNo, 
               CASE 
                 WHEN (SELECT facevalue 
                       FROM   exercisesardetails ESD 
                       WHERE  ESD.exercisesarid = ex.exercisesarid) > 0 THEN 
                 Isnull((SELECT sharesissued 
                       FROM   exercisesardetails 
                       WHERE  exercisesardetails.exercisesarid = 
                              ex.exercisesarid), 
                 Sum(ex.bonussplitexercisedquantity)) * (SELECT facevalue 
                                                         FROM 
                 exercisesardetails ESD 
                                                         WHERE 
                 ESD.exercisesarid = ex.exercisesarid) 
                 ELSE Isnull((SELECT sharesissued 
                              FROM   exercisesardetails 
                              WHERE  exercisesardetails.exercisesarid = 
                                     ex.exercisesarid), 
                             Sum(ex.bonussplitexercisedquantity)) * 
                      ex.exercisedprice 
               END 
                      AS Exercise_Amount, 
               (SELECT TOP 1 * 
                FROM   (SELECT CASE 
                                 WHEN ( SHEX.paymentmode = 'D' 
                                         OR SHEX.paymentmode = 'Q' 
                                         OR SHEX.paymentmode = 'R' 
                                         OR SHEX.paymentmode = 'W' ) THEN 
                                 SHOFF.drawnon 
                                 WHEN ( SHEX.paymentmode = 'A' 
                                         OR SHEX.paymentmode = 'P' ) THEN NULL 
                                 WHEN ( SHEX.paymentmode = 'F' ) THEN 
                                 SHFUND.dddate 
                                 WHEN ( SHEX.paymentmode = 'N' ) THEN 
                                 SHON.transaction_date 
                                 ELSE NULL 
                               END AS paymentdate 
                        FROM   shexercisedoptions SHEX 
                               INNER JOIN employeemaster EMPInner 
                                       ON SHEX.employeeid = EMPInner.employeeid 
                               LEFT OUTER JOIN shtransactiondetails SHOFF 
                                            ON SHEX.exerciseno = 
                                               SHOFF.exerciseno 
                               LEFT OUTER JOIN transactiondetails_funding SHFUND 
                                            ON SHEX.exerciseno = 
                                               SHFUND.exerciseno 
                               LEFT OUTER JOIN transaction_details SHON 
                                            ON SHEX.exerciseno = SHON.exerciseno 
                               LEFT OUTER JOIN transactiondetails_cashless 
                                               SHCASH 
                                            ON SHEX.exerciseno = 
                                               SHCASH.exerciseno 
                        WHERE  ( CONVERT(DATE, shex.exercisedate) BETWEEN 
                                        CONVERT(DATE, @STARTDATE) AND 
                                        CONVERT(DATE, @ENDDATE) ) 
                               AND EMPInner.loginid = emp.loginid 
                               AND SHEX.exerciseid = ex.exercisedid 
                               AND SHEX.exerciseno = ex.exerciseno 
                               AND SHEX.exercisedate = ex.exerciseddate 
                               AND SHEX.paymentmode = ex.paymentmode 
                        UNION 
                        SELECT CASE 
                                 WHEN ( EXER.paymentmode = 'D' 
                                         OR EXER.paymentmode = 'Q' 
                                         OR EXER.paymentmode = 'R' 
                                         OR EXER.paymentmode = 'W' ) THEN 
                                 SHOFF.drawnon 
                                 WHEN ( EXER.paymentmode = 'A' 
                                         OR EXER.paymentmode = 'P' ) THEN NULL 
                                 WHEN ( EXER.paymentmode = 'F' ) THEN 
                                 SHFUND.dddate 
                                 WHEN ( EXER.paymentmode = 'N' ) THEN 
                                 SHON.transaction_date 
                                 ELSE NULL 
                               END AS paymentdate 
                        FROM   exercised EXER 
                               INNER JOIN grantleg GL 
                                       ON EXER.grantlegserialnumber = GL.id 
                               INNER JOIN grantoptions GRO 
                                       ON GL.grantoptionid = GRO.grantoptionid 
                               LEFT OUTER JOIN shtransactiondetails SHOFF 
                                            ON EXER.exerciseno = 
                                               SHOFF.exerciseno 
                               LEFT OUTER JOIN transactiondetails_funding SHFUND 
                                            ON EXER.exerciseno = 
                                               SHFUND.exerciseno 
                               LEFT OUTER JOIN transaction_details SHON 
                                            ON EXER.exerciseno = SHON.exerciseno 
                               LEFT OUTER JOIN transactiondetails_cashless 
                                               SHCASH 
                                            ON EXER.exerciseno = 
                                               SHCASH.exerciseno 
                        WHERE  ( CONVERT(DATE, exer.exerciseddate) BETWEEN 
                                        CONVERT(DATE, @STARTDATE) AND 
                                        CONVERT(DATE, @ENDDATE) ) 
                               AND GRO.employeeid = emp.employeeid 
                               AND EXER.exercisedid = ex.exercisedid 
                               AND EXER.exerciseno = ex.exerciseno 
                               AND EXER.exerciseddate = ex.exerciseddate 
                               AND EXER.paymentmode = ex.paymentmode) AS 
                       employee_DOP) 
                      AS 
               [Date of Payment], 
               emp.accountno 
                      AS [Account number], 
               emp.confstatus 
                      AS ConfStatus, 
               emp.dateofjoining, 
               emp.dateoftermination, 
               emp.department, 
               emp.employeedesignation, 
               emp.entity 
                      AS Entity, 
               emp.grade 
                      AS Grade, 
               emp.insider 
                      AS Insider, 
               rft.reason 
                      AS ReasonForTermination, 
               emp.sbu 
                      AS SBU, 
               DematDetails.residentialstatus, 
               DematDetails.itcircle_wardnumber, 
               DematDetails.depositoryname, 
               DematDetails.depositoryparticipatoryname, 
               DematDetails.confirmationdate, 
               DematDetails.nameasperdprecord, 
               DematDetails.employeeaddress, 
               DematDetails.employeeemail, 
               DematDetails.employeephone, 
               DematDetails.pan_girnumber, 
               DematDetails.dematactype, 
               DematDetails.dpidnumber, 
               DematDetails.clientidnumber, 
               DematDetails.location 
        FROM   employeemaster emp 
               INNER JOIN grantoptions gop 
                       ON emp.employeeid = gop.employeeid 
               INNER JOIN grantregistration gr 
                       ON gr.grantregistrationid = gop.grantregistrationid 
               INNER JOIN grantleg gl 
                       ON gop.grantoptionid = gl.grantoptionid 
               INNER JOIN exercised ex 
                       ON ex.grantlegserialnumber = gl.id 
               LEFT OUTER JOIN reasonfortermination rft 
                            ON emp.reasonfortermination = rft.id 
               INNER JOIN scheme sch 
                       ON gop.schemeid = sch.schemeid 
               LEFT OUTER JOIN paymentmaster PM 
                            ON Pm.paymentmode = Ex.paymentmode 
               RIGHT OUTER JOIN Funemployeedematdetails(CONVERT(DATE, @STARTDATE 
                                                        ), 
                                CONVERT(DATE, @ENDDATE)) 
                                DematDetails 
                             ON ex.exercisedid = DematDetails.exercisedid 
               LEFT OUTER JOIN countrymaster CM 
                            ON emp.countryname = CM.countryaliasname 
               LEFT OUTER JOIN cashlessexceptionalchargesupdation CU 
                            ON ex.exercisedid = CU.exerciseid        
        WHERE  ( CONVERT(DATE, ex.exerciseddate) BETWEEN 
                         CONVERT(DATE, @STARTDATE) AND CONVERT(DATE, @ENDDATE) ) 
        GROUP  BY emp.loginid, 
                  ex.paymentmode, 
                  sch.schemeid, 
                  emp.employeeid, 
                  CM.countryname, 
                  ex.sharesarised, 
                  ex.sarexerciseamount, 
                  ex.exercisedid, 
                  gop.grantoptionid, 
                  ex.exerciseddate, 
                  ex.sharesissueddate, 
                  ex.exercisedprice, 
                  gl.finalvestingdate, 
                  gl.grantlegid, 
                  ex.cash, 
                  ex.fbtdays, 
                  ex.traveldays, 
                  Pm.paymodename, 
                  ex.exerciseno, 
                  emp.accountno, 
                  emp.confstatus, 
                  emp.dateofjoining, 
                  emp.dateoftermination, 
                  emp.department, 
                  emp.employeedesignation, 
                  emp.entity, 
                  emp.grade, 
                  emp.insider, 
                  rft.reason, 
                  emp.sbu, 
                  ex.exercisesarid, 
                  DematDetails.residentialstatus, 
                  DematDetails.itcircle_wardnumber, 
                  DematDetails.depositoryname, 
                  DematDetails.depositoryparticipatoryname, 
                  DematDetails.confirmationdate, 
                  DematDetails.nameasperdprecord, 
                  DematDetails.employeeaddress, 
                  DematDetails.employeeemail, 
                  DematDetails.employeephone, 
                  DematDetails.pan_girnumber, 
                  DematDetails.dematactype, 
                  DematDetails.dpidnumber, 
                  DematDetails.clientidnumber, 
                  DematDetails.location, 
                  CU.perquisitevalue, 
                  CU.perqtax, 
                  CU.perquisitetaxpaid) AS FINAL_OUTPUT 

--Update Perquisite Value and Perquisite Tax columns fetch the value from CashExercisedData Table.
UPDATE #TEMP SET 
      PerqstValue = CONVERT(VARCHAR, CED.Perquisite_Value),
      PerqstPayable = CASE WHEN CED.Perquisite_Tax = '' THEN NULL ELSE CONVERT(VARCHAR, CED.Perquisite_Tax) END
FROM  
	#TEMP TM
	INNER JOIN CashExercisedData AS CED ON CONVERT(VARCHAR, TM.EmployeeID)  = CONVERT(VARCHAR, CED.Employee_ID) 
	WHERE 
		CONVERT(VARCHAR, TM.ExercisedId) = CONVERT(VARCHAR, CED.Exercise_ID)



EXECUTE
(
'SELECT ExercisedID as ExerciseID,EmployeeID,EmployeeName,ResidentialStatus,CONVERT(DECIMAL(18,6),FMVPrice) as fmv, PerqstValue AS PerquisteValue,
        CONVERT(DECIMAL(18,6),PerqstPayable) AS PerquisiteTaxpayable, PerqTaxRate as Perq_Tax_rate, PAN_GIRNumber as PAN,CONVERT(DATE,ExercisedDate) AS ExerciseDate,
  CASE 
     WHEN Paymentmode IN (''Sell-all'',''Sell Partial'') THEN ''Cashless'' 
     WHEN Paymentmode IS NULL THEN '' '' 
     ELSE ''Cash'' END AS ExerciseType, 
  CASE 
     WHEN Paymentmode IN (''Sell-all'',''Sell Partial'') THEN (SELECT CONVERT(DECIMAL(18,6),ISNULL(SharesSold,0))AS SharesSold from ' + @TrustCompanyID + '..GetDateOfSaleShareSoldUDF('''+ @CompanyID +''',ExercisedID))
     WHEN Paymentmode is null THEN ''0'' 
     ELSE ExercisedQuantity END AS ShareSold,
   CASE 
     WHEN Paymentmode IN (''Sell-all'',''Sell Partial'') THEN (SELECT DateofSale from ' + @TrustCompanyID + '..GetDateOfSaleShareSoldUDF('''+@CompanyID +''',ExercisedID))
     ELSE SharesIssuedDate END AS DateOfSale
  
 FROM #TEMP WHERE ResidentialStatus NOT IN (''Foreign National'')
' + @BUILD_WHERE_CLAUSE
)
 
 DROP TABLE #TEMP 
 
END
GO
