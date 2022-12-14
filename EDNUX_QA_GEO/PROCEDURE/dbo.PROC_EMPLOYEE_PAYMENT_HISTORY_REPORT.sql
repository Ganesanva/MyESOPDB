/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_PAYMENT_HISTORY_REPORT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_PAYMENT_HISTORY_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_PAYMENT_HISTORY_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_PAYMENT_HISTORY_REPORT]
(
	@EmployeeId varchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT 
		SHEX.exerciseno, MAX(SHEX.exercisedate) AS exercisedate,   
		SUM(SHEX.exercisedquantity) AS exercisedquantity,   
		CASE   
			 WHEN GR.apply_sar IS NULL THEN 'N'   
			 ELSE GR.apply_sar   
		END                         AS Apply_SAR,   
		CASE   
			WHEN SHEX.paymentmode = 'D' THEN 'DD'   
			WHEN SHEX.paymentmode = 'Q' THEN 'CHEQUE'   
			WHEN SHEX.paymentmode = 'R' THEN 'RTGS'   
			WHEN SHEX.paymentmode = 'W' THEN 'WireTransfer'   
			WHEN SHEX.paymentmode = 'A' THEN 'CASHLESS SELL ALL'   
			WHEN SHEX.paymentmode = 'P' THEN 'CASHLESS SELL TO COVER'   
			WHEN SHEX.paymentmode = 'F' THEN 'FUNDING'   
			WHEN SHEX.paymentmode = 'N' THEN 'ONLINE'   
			WHEN SHEX.paymentmode = 'I' THEN 'Direct Debit'   
			WHEN SHEX.paymentmode = 'X' THEN 'Not Applicable'   
			ELSE 'Payment Pending'   
		END                         AS paymentmode,   
		SUM(SHEX.exerciseprice)     AS exerciseprice,   
		CASE   
			WHEN ( GR.apply_sar = 'Y'   
                AND MAX(SHEX.exercisesarid) IS NULL ) THEN NULL   
			ELSE SUM(( SHEX.exerciseprice * SHEX.exercisedquantity ) +   
                         ISNULL(SHEX.perqstpayable, 0))   
		END                         AS amountpaid,   
		CASE   
			WHEN ( SHEX.paymentmode = 'D' OR SHEX.paymentmode = 'Q'  OR SHEX.paymentmode = 'R' OR SHEX.paymentmode = 'W' OR SHEX.paymentmode = 'I' ) THEN SHOFF.drawnon   
			WHEN ( SHEX.paymentmode = 'A' OR SHEX.paymentmode = 'P' ) THEN NULL   
			WHEN ( SHEX.paymentmode = 'F' ) THEN SHFUND.dddate   
			WHEN ( SHEX.paymentmode = 'N' ) THEN SHON.transaction_date   
			ELSE NULL   
		END                         AS paymentdate ,  
		CASE 
			WHEN ISNULL(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
			CM.CurrencyName,CM.CurrencyAlias ,SH.SchemeTitle  
	FROM   shexercisedoptions SHEX   
		INNER JOIN grantleg GL ON SHEX.grantlegserialnumber = GL.id   
		INNER JOIN grantregistration GR ON GR.grantregistrationid = GL.grantregistrationid   
		INNER JOIN employeemaster EMP ON SHEX.employeeid = EMP.employeeid   
		INNER JOIN Scheme SH ON GL.SchemeId=SH.SchemeId  
		INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID=SH.MIT_ID  
		INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID=CIM.MIT_ID  
		INNER JOIN CurrencyMaster CM ON CIM.CurrencyID=CM.CurrencyID  
		LEFT OUTER JOIN shtransactiondetails SHOFF ON SHEX.exerciseno = SHOFF.exerciseno   
		LEFT OUTER JOIN transactiondetails_funding SHFUND ON SHEX.exerciseno = SHFUND.exerciseno   
		LEFT OUTER JOIN transaction_details SHON ON SHEX.exerciseno = SHON.exerciseno   
		LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SHEX.exerciseno = SHCASH.exerciseno   
	WHERE  EMP.loginid = @EmployeeId
	GROUP  BY   
  		  MIT.INSTRUMENT_NAME, CIM.INS_DISPLY_NAME, SH.SchemeTitle, CM.CurrencyName,CM.CurrencyAlias, SHEX.exerciseno, SHEX.paymentmode, SHOFF.drawnon,   
          SHON.transaction_date, SHFUND.dddate, GR.apply_sar   
            
	UNION   
  
	SELECT EXER.exerciseno,   
       MAX(EXER.exerciseddate)    AS ExercisedDate,   
       SUM(EXER.exercisedquantity)AS ExercisedQuantity,   
       CASE   
			WHEN GR.apply_sar IS NULL THEN 'N'   
			ELSE GR.apply_sar   
       END                        AS Apply_SAR,   
       CASE   
			WHEN EXER.paymentmode = 'D' THEN 'DD'   
			WHEN EXER.paymentmode = 'Q' THEN 'CHEQUE'   
			WHEN EXER.paymentmode = 'R' THEN 'RTGS'   
			WHEN EXER.paymentmode = 'W' THEN 'WireTransfer'   
			WHEN EXER.paymentmode = 'A' THEN 'CASHLESS SELL ALL'   
			WHEN EXER.paymentmode = 'P' THEN 'CASHLESS SELL TO COVER'   
			WHEN EXER.paymentmode = 'F' THEN 'FUNDING'   
			WHEN EXER.paymentmode = 'N' THEN 'ONLINE'   
			WHEN EXER.paymentmode = 'I' THEN 'Direct Debit'   
			WHEN EXER.paymentmode = 'X' THEN 'Not Applicable'   
			ELSE 'Payment Pending'   
       END                        AS paymentmode,   
       SUM(EXER.exercisedprice)   AS ExercisedPrice,   
       CASE   
         WHEN ( GR.apply_sar = 'Y' AND MAX(EXER.exercisesarid) IS NULL ) THEN NULL   
         ELSE SUM(( EXER.exercisedprice * EXER.exercisedquantity ) +  ISNULL(exer.perqstpayable, 0))   
       END                        AS amountpaid,   
       CASE   
			WHEN ( EXER.paymentmode = 'D' OR EXER.paymentmode = 'Q'  OR EXER.paymentmode = 'R' OR EXER.paymentmode = 'W'   OR EXER.paymentmode = 'I' ) THEN SHOFF.drawnon   
			WHEN ( EXER.paymentmode = 'A' OR EXER.paymentmode = 'P' ) THEN NULL   
			WHEN ( EXER.paymentmode = 'F' ) THEN SHFUND.dddate   
			WHEN ( EXER.paymentmode = 'N' ) THEN SHON.transaction_date   
			ELSE NULL   
       END                    
		AS paymentdate ,  
	  CASE
			WHEN ISNULL(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
      CM.CurrencyName,CM.CurrencyAlias,SH.SchemeTitle  
	FROM   exercised EXER   
		INNER JOIN grantleg GL ON EXER.grantlegserialnumber = GL.id   
		INNER JOIN grantregistration GR ON GR.grantregistrationid = GL.grantregistrationid   
		LEFT OUTER JOIN grantoptions GRO ON GL.grantoptionid = GRO.grantoptionid   
		INNER JOIN employeemaster em ON gro.employeeid = em.employeeid AND em.loginid = @EmployeeId
		INNER JOIN Scheme SH ON GL.SchemeId=SH.SchemeId   
		INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID=SH.MIT_ID  
		INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID=CIM.MIT_ID  
		INNER JOIN CurrencyMaster CM ON CIM.CurrencyID=CM.CurrencyID  
		LEFT OUTER JOIN shtransactiondetails SHOFF ON EXER.exerciseno = SHOFF.exerciseno   
		LEFT OUTER JOIN transactiondetails_funding SHFUND ON EXER.exerciseno = SHFUND.exerciseno   
		LEFT OUTER JOIN transaction_details SHON ON EXER.exerciseno = SHON.exerciseno   
		LEFT OUTER JOIN transactiondetails_cashless SHCASH ON EXER.exerciseno = SHCASH.exerciseno   
	GROUP  BY   
          MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME, SH.SchemeTitle, CM.CurrencyName, CM.CurrencyAlias, EXER.exerciseno, EXER.paymentmode, SHOFF.drawnon,   
          SHON.transaction_date, SHFUND.dddate, GR.apply_sar              
	ORDER  BY exercisedate DESC   
	
SET NOCOUNT OFF;  
END
GO
