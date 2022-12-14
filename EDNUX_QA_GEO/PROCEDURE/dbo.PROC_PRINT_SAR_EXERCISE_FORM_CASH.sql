/****** Object:  StoredProcedure [dbo].[PROC_PRINT_SAR_EXERCISE_FORM_CASH]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PRINT_SAR_EXERCISE_FORM_CASH]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PRINT_SAR_EXERCISE_FORM_CASH]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PRINT_SAR_EXERCISE_FORM_CASH]
(
	@USER_ID		VARCHAR(20),
	@Exercise_No	VARCHAR(10)	
)
 AS
 BEGIN
	SET NOCOUNT ON;
	SELECT PANNumber,employeename,employeeid, employeeaddress, employeephone, employeeemail, lwd,AccountNo, payrollcountry,
	Tax_slab
	FROM 
		employeemaster 
	WHERE  LoginId = @USER_ID AND DELETED = 0	; 
    DECLARE @FaceValue VARCHAR(10)
	Declare @RoundFMV as integer,@RoundTax as integer,@RoundTaxable as integer,@Query as varchar(4500) 
	SELECT @RoundFMV=cp.RoundupPlace_FMV,@RoundTax=cp.RoundupPlace_TaxAmt,@RoundTaxable=cp.RoundupPlace_TaxableVal ,@FaceValue=FaceVaue
	from 
		CompanyParameters cp  

	SET @Query='SELECT GR.SCHEMEID AS SCHEMENAME,GR.GRANTDATE AS GRANTDATE,
	(SELECT 
	       SUM(GL.GRANTEDOPTIONS) 
	 FROM  
	     GRANTLEG GL 
	 WHERE  GL.GRANTOPTIONID = GL.GRANTOPTIONID) AS OPTIONSGRANTED, 

	 SUM(SH.EXERCISEDQUANTITY) AS OPTIONSEXERCISED, GR.EXERCISEPRICE AS EXERCISEPRICE, 
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SH.TentativeFMVPrice AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))ELSE CAST(SH.FMVPRICE AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))END AS FMV,      
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SH.TentativeSettlmentPrice AS NUMERIC(18,2))ELSE CAST(SH.SETTLMENTPRICE AS NUMERIC(18,2))END AS SETTLMENTPRICE,      
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SH.TentativePerqstValue) AS NUMERIC(18,0)) ELSE CAST(SUM(SH.PERQSTVALUE) AS NUMERIC(18,0)) END AS PERQVALUE, 
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SH.TentativePerqstPayable)  AS NUMERIC(18,'+CONVERT(VARCHAR,+@RoundTax)+')) ELSE CAST(SUM(SH.PERQSTPAYABLE)  AS NUMERIC(18,'+CONVERT(VARCHAR,+@RoundTax)+')) END AS PERQTAX,
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SH.TentativeStockApprValue)  AS NUMERIC(18,2)) ELSE CAST(SUM(SH.StockApprValue)  AS NUMERIC(18,2)) END AS StockApprValue, 
	 SH.EXERCISENO,
	 CASE WHEN SH.MIT_ID = 6 AND SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN SUM(ISNULL(SH.TentShareAriseApprValue,SH.ShareAriseApprValue) * '+@FaceValue+' )
				   WHEN SH.MIT_ID = 6 AND SH.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(ISNULL(SH.ShareAriseApprValue,0) * '+@FaceValue+' )	ELSE
	 SUM(SH.EXERCISEDQUANTITY) * GR.EXERCISEPRICE END AS EXERCISEAMOUNT,
	 MAX(SH.EXERCISEDATE)   AS EXERCISEDATE,   
	 CASE WHEN SH.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SH.TENTATIVECASHPAYOUTVALUE) AS NUMERIC(18,2)) ELSE CAST(SUM(SH.CashPayoutValue) AS NUMERIC(18,2)) END  AS PAYOUTAMOUNT,  0 AS GROSSPAYOUTAMOUNT, 
	 CASE WHEN SH.CALCULATE_TAX = ''rdoActualTax'' THEN CAST(SUM(SH.SHAREARISEAPPRVALUE) AS NUMERIC(18,0)) ELSE CAST(SUM(SH.TENTSHAREARISEAPPRVALUE) AS NUMERIC(18,0)) END AS TENTSHAREARISEAPPRVALUE,
	 CASE WHEN SH.CALCULATE_TAX = ''rdoActualTax'' THEN CAST(SUM(SH.PERQSTVALUE) AS NUMERIC(18,2)) ELSE CAST(SUM(SH.TENTATIVEPERQSTVALUE) AS NUMERIC(18,2)) END AS TENTATIVEPERQSTVALUE,
	 CASE WHEN SH.CALCULATE_TAX = ''rdoActualTax'' THEN CAST(SUM(SH.PERQSTPAYABLE) AS NUMERIC(18,2)) ELSE CAST(SUM(SH.TENTATIVEPERQSTPAYABLE) AS NUMERIC(18,2)) END AS TENTATIVEPERQSTPAYABLE,
     CAST(SUM(SH.CASHPAYOUTVALUE) AS NUMERIC(18,2)) AS CASHPAYOUTVALUE
	 FROM	
	 	 SHEXERCISEDOPTIONS AS SH
		 INNER JOIN GRANTLEG AS GL ON GL.ID = SH.GRANTLEGSERIALNUMBER
		 INNER JOIN GRANTREGISTRATION AS GR ON GL.GRANTREGISTRATIONID = GR.GRANTREGISTRATIONID  
		 INNER JOIN SCHEME AS SCHE ON GL.SCHEMEID=SCHE.SCHEMEID
	 WHERE  ( SH.EXERCISENO = '+@Exercise_No+' )  
	 GROUP  BY SH.MIT_ID,GR.GRANTREGISTRATIONID, GR.SCHEMEID, GR.GRANTDATE,GR.EXERCISEPRICE,SH.FMVPRICE,SH.TentativeSettlmentPrice,SH.SETTLMENTPRICE,  
	 SH.EXERCISENO, GL.GRANTOPTIONID,SH.CALCULATE_TAX,
	 SH.TentativeFMVPrice' 

	 /*PRINT (@Query)*/
	 EXEC (@Query); 
	SELECT 
		  residentialpaymentmode.exerciseformtext1, residentialpaymentmode.exerciseformtext2 ,residentialpaymentmode.exerciseformtext3 
	FROM  
		  residentialpaymentmode 
		  INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  
	      INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id 
	WHERE  
	      paymentmaster.paymentmode = 
		  (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions 
	 		WHERE shexercisedoptions.exerciseno = @Exercise_No  ) 
		  	AND residentialpaymentmode.MIT_ID = (SELECT distinct shexercisedoptions.MIT_ID FROM   shexercisedoptions 
	 		WHERE shexercisedoptions.exerciseno = @Exercise_No  ) 
	SET NOCOUNT OFF;
END

GO
