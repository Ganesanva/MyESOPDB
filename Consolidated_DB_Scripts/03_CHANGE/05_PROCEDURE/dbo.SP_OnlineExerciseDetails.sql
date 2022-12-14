/****** Object:  StoredProcedure [dbo].[SP_OnlineExerciseDetails]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_OnlineExerciseDetails]
GO
/****** Object:  StoredProcedure [dbo].[SP_OnlineExerciseDetails]    Script Date: 7/8/2022 3:00:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_OnlineExerciseDetails '1115'
Create PROCEDURE [dbo].[SP_OnlineExerciseDetails](
@Employeeid VARCHAR(50)

	)			 	
AS

BEGIN
 DECLARE @ROUNDTAX INT
 DECLARE @FaceValue VARCHAR(10)
      SELECT @ROUNDTAX = cp.RoundupPlace_TaxAmt,@FaceValue=FaceVaue FROM   companyparameters cp 
      
        DECLARE @QUERY VARCHAR(Max)
        
        
        CREATE TABLE #Temp_Online_Exercise_Details
	(
		ExerciseDate DATETIME, exerciseno NUMERIC (18, 0), AmountPaid NUMERIC (38, 2), GenDisableFlag INT, PerqstPayable NUMERIC (18,6)
		, TotalAmount NUMERIC (19, 4), PayModeName VARCHAR (20), PaymentMode CHAR (1), Apply_SAR VARCHAR (1), Branch VARCHAR (200)
		, AccountNo VARCHAR (50), ExAmtTypOfBnkAc INT, PerqAmt_Branch VARCHAR (200), PerqAmt_BankAccountNumber VARCHAR (50), PeqTxTypOfBnkAc INT
		, INSTRUMENT_NAME NVARCHAR (500),  IS_AUTO_EXERCISE_ALLOWED VARCHAR (16), CurrencyName VARCHAR (50)
		, ExercisedQuantity NUMERIC (38, 0), MIT_ID INT , CurrencyAlias VARCHAR (50), TrustType VARCHAR (15),GRANTDATE DATETIME,IsFormGenerate INT,Entity VARCHAR(100),CurrencyAliasINR  VARCHAR(10),IS_PaymentWindow_Enabled TINYINT,PAYMENT_CLOSURE_MSG VARCHAR(1000),SharesAlloted NUMERIC(18,0),CashPayoutValue NUMERIC(18,2)
	)
      
	 	CREATE TABLE #Temp_AuditData
	( 
		AuditId INT IDENTITY, ExerciseId INT, ExerciseNo INT,NumberOfShares FLOAT, CashPayoutValue FLOAT
	)
	INSERT INTO #Temp_AuditData  
	SELECT ExerciseId, ExerciseNo, SUM(NumberOfShares) AS NumberOfShares, SUM(CashPayoutValue) AS CashPayoutValue FROM AuditData
	Group By ExerciseId,ExerciseNo

SET @QUERY='
	SELECT
		MAX( a.ExerciseDate) AS ExerciseDate, exerciseno,SUM (AmountPaid) AS AmountPaid,		
		MIN(PerqstPayable1) AS GenDisableFlag,
		CONVERT(NVARCHAR(20), CAST(SUM(perqstpayable) AS NUMERIC(18, '+ CONVERT(varchar,@ROUNDTAX)+')))   AS PerqstPayable, 
		CAST(SUM (amountpaid)  AS NUMERIC(18,'+  CONVERT(varchar,@ROUNDTAX)+')) + CAST(SUM(ISNULL(perqstpayable,0)) AS NUMERIC(18,'+  CONVERT(varchar,@ROUNDTAX)+')) AS TotalAmount, 
		PayModeName,PaymentMode ,Apply_SAR, ISNULL(Branch,'''') AS Branch, ISNULL(AccountNo,'''') AS AccountNo,ExAmtTypOfBnkAc ,ISNULL(PerqAmt_Branch,'''') AS PerqAmt_Branch,ISNULL(PerqAmt_BankAccountNumber,'''') AS PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME,
		CASE WHEN ISNULL(IsAutoExercised,0) = 2 THEN ''Pending For Auto''  WHEN ISNULL(IsAutoExercised,0) = 1 THEN ''Auto''   ELSE ''Manual'' END AS IS_AUTO_EXERCISE_ALLOWED, CurrencyName, sum(ExercisedQuantity) as ExercisedQuantity, MIT_ID, CurrencyAlias,
		CASE 
			WHEN TrustType= ''TC'' OR TrustType = ''TCOnly'' THEN ''Cash'' 
			WHEN TrustType= '' TCLSA'' OR TrustType= ''TCLSP'' OR TrustType= ''TCLSA'' OR TrustType= ''TCLB'' OR TrustType= ''CCSA'' OR TrustType=''CCSP'' OR TrustType= ''CCB'' THEN ''CAshless''
			WHEN TrustType= ''TCandCLSA'' OR TrustType=''TCandCLSP'' OR TrustType= ''TCandCLB'' OR TrustType= ''CCNonTC'' OR TrustType= ''CCNonTCCSA'' OR TrustType= ''CCNonTCCSP'' OR TrustType= ''CCNonTCCB'' THEN ''CashANDCashless''
			ELSE ''None'' END AS TrustType,GRANTDATE,IsFormGenerate	,CurrencyAliasINR,ISNULL(IS_PaymentWindow_Enabled,0) AS IS_PaymentWindow_Enabled,PAYMENT_CLOSURE_MSG,	CASE WHEN MIT_ID = 3 OR MIT_ID = 4 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN SUM(CashPayValue) ELSE ISNULL(SUM(CashPayoutValue),0) END AS CashPayoutValue,
			CASE WHEN MIT_ID = 5 OR MIT_ID = 7 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN ISNULL(SUM(NumOfShares),0) WHEN MIT_ID = 6 THEN ISNULL(SUM(ShareAriseApprValue),0) ELSE CAST(ISNULL(SUM(EXERCISEDQUANTITY),0) AS NUMERIC(18,0)) END AS SharesAlloted
	FROM (
			SELECT GR.grantdate , SHEX.IsFormGenerate,
				  CASE  WHEN  GR.Apply_SAR IS NULL THEN ''N''  ELSE  GR.Apply_SAR  END AS Apply_SAR ,
				   SCH.schemetitle, 
				   GOP.grantoptionid, 
				   ISNULL(GR.exercisepriceINR,SHEX.exerciseprice) as exerciseprice, 
				   SHEX.exercisedate, 
				   GOP.grantedoptions, 
				   SHEX.exerciseno, 
				   SHEX.action,
				   SHEX.exercisedquantity,

				   ( ( SHEX.exercisedquantity * SCH.optionratiodivisor ) / 
					 ( SCH.optionratiomultiplier ) ) AS exercisablequantity, 
				   SHEX.exerciseid,
				   CASE WHEN (CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
				   when SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN  SHEX.PerqstPayable else 0 end) IS NULL THEN 0 ELSE 1 END as PerqstPayable1,	
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
                   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SHEX.PerqstPayable ELSE 0 END AS PerqstPayable,
				   PM.PayModeName,PM.PaymentMode, CASE WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN (ISNULL(SUM(SHEX.TentShareAriseApprValue),SUM(SHEX.ShareAriseApprValue)) * '+@FaceValue+' )
				   WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN (ISNULL(SUM(SHEX.ShareAriseApprValue),0) * '+@FaceValue+' )	 ELSE 			   
				   (SHEX.ExercisedQuantity * ISNULL(GR.exercisepriceINR,SHEX.exerciseprice)) END AS AmountPaid,
				   ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc,				   
				   CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
				   SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, SHEX.TentativePerqstPayable, MIT.MIT_ID, SCH.TrustType, CM.CurrencyAlias,CASE WHEN GR.ExercisePriceINR IS NULL THEN CM.CurrencyAlias ELSE ''INR'' END AS  CurrencyAliasINR,
				   CASE WHEN ISNULL(IS_PaymentWindow_Enabled,''P'')=''L'' AND CONVERT(Date,DATEADD(day, ISNULL(CIM.NumberOfDays,0),SHEX.EXERCISEDATE))<= CONVERT(Date,GETDATE()) THEN 1 ELSE 0 END AS IS_PaymentWindow_Enabled,ISNULL(PAYMENT_CLOSURE_MSG,'''') AS PAYMENT_CLOSURE_MSG,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SUM(SHEX.TentativeCashPayoutValue),SUM(SHEX.CashPayoutValue))
				   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(SHEX.CashPayoutValue) ELSE 0 END AS CashPayoutValue,SUM(AU.NumberOfShares) AS NumOfShares,SUM(AU.CashPayoutValue) AS CashPayValue,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SUM(SHEX.TentShareAriseApprValue),0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(SHEX.ShareAriseApprValue) ELSE 0 END AS ShareAriseApprValue
				   
			FROM   shexercisedoptions SHEX 
					LEFT JOIN PaymentMaster PM
					 ON SHEX.PaymentMode = PM.PaymentMode 
				   JOIN grantleg GL 
					 ON shex.grantlegserialnumber = GL.id 
				   JOIN scheme SCH 
					 ON GL.schemeid = SCH.schemeid 
				   JOIN grantregistration GR 
					 ON GL.grantregistrationid = GR.grantregistrationid 
				   JOIN grantoptions GOP 
					 ON GL.grantoptionid = GOP.grantoptionid 
				   JOIN employeemaster EM 
					 ON GOP.employeeid = EM.employeeid        
					 AND EM.loginid ='''+ @Employeeid +
						''' AND SHEX.ismassupload = ''N'' AND SHEX.Action <> ''R''  AND SHEX.Cash <> ''PUP''
				   	LEFT JOIN ShTransactionDetails ST ON ST.ExerciseNo = SHEX.ExerciseNo	
				   	LEFT OUTER JOIN MST_INSTRUMENT_TYPE MIT ON SCH.MIT_ID=MIT.MIT_ID
					LEFT OUTER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON MIT.MIT_ID = CIM.MIT_ID
					LEFT OUTER JOIN CurrencyMaster CM ON CIM.CurrencyID = CM.CurrencyID						
					LEFT OUTER JOIN #Temp_AuditData AU ON AU.ExerciseId = SHEX.ExerciseId
				   	WHERE (ISNULL(IsPrevestExercised,0) = 0) OR (ISNULL(IsPrevestExercised,0) = 1 AND SHEX.PaymentMode IS NOT NULL AND SHEX.PaymentMode!='''')
					GROUP BY  SHEX.CALCULATE_TAX,CIM.PAYMENT_CLOSURE_MSG,CIM.IS_PaymentWindow_Enabled,CIM.NumberOfDays,GR.exercisepriceINR,GR.grantdate,SHEX.IsFormGenerate , GR.Apply_SAR ,SHEX.action,
					SCH.schemetitle, GOP.grantoptionid, SHEX.exerciseprice, SHEX.exercisedate, GOP.grantedoptions, SHEX.exerciseno, SHEX.exercisedquantity,
					SCH.optionratiodivisor, SCH.optionratiomultiplier, SHEX.exerciseid,CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
				        WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN  SHEX.PerqstPayable ELSE 0 end , SHEX.PerqstPayable, PM.PayModeName, PM.PaymentMode,
					ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc, SHEX.TentativePerqstPayable,MIT.INSTRUMENT_NAME, SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, MIT.MIT_ID, sch.TrustType, CM.CurrencyAlias, CIM.INS_DISPLY_NAME
				   )a 
       GROUP BY PAYMENT_CLOSURE_MSG,IS_PaymentWindow_Enabled,exerciseno,grantdate,IsFormGenerate,action,PayModeName,PaymentMode ,Apply_SAR, Branch,AccountNo,ExAmtTypOfBnkAc,PerqAmt_Branch,PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME, IsAutoExercised, CurrencyName, MIT_ID,TrustType, CurrencyAlias,CurrencyAliasINR
       ORDER BY exerciseno DESC '
       
       
		/*PRINT @QUERY   */
	INSERT INTO #Temp_Online_Exercise_Details  
	(
		ExerciseDate, exerciseno, AmountPaid, GenDisableFlag, PerqstPayable, TotalAmount, PayModeName, 
		PaymentMode, Apply_SAR, Branch, AccountNo, ExAmtTypOfBnkAc, PerqAmt_Branch, PerqAmt_BankAccountNumber, 
		PeqTxTypOfBnkAc, INSTRUMENT_NAME,  IS_AUTO_EXERCISE_ALLOWED, CurrencyName, ExercisedQuantity, 
		MIT_ID, CurrencyAlias, TrustType,GRANTDATE,IsFormGenerate,CurrencyAliasINR,IS_PaymentWindow_Enabled,PAYMENT_CLOSURE_MSG,CashPayoutValue,SharesAlloted
	)     
	EXECUTE(@QUERY)
	
   	CREATE TABLE #TEMP_ENTITY_DATA
	(
		SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
		EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE
	)
	
	INSERT INTO #TEMP_ENTITY_DATA
	(
		SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
	)	
	EXEC PROC_EMP_MOVEMENT_TRANSFER 'Entity',@Employeeid
 
   
    UPDATE 
		 PRE SET PRE.Entity = TED.ENTITY
	FROM #Temp_Online_Exercise_Details AS PRE
   		INNER JOIN #TEMP_ENTITY_DATA AS TED ON (CONVERT(DATE,PRE.GRANTDATE)) >= CONVERT(DATE,TED.FROMDATE)
   		AND (CONVERT(DATE,PRE.GRANTDATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE())))
   	WHERE TED.EMPLOYEEID=@Employeeid
	

 	SELECT 
 		 ExerciseDate, exerciseno, SUM(AmountPaid) AS AmountPaid, GenDisableFlag,SUM(PerqstPayable) AS PerqstPayable, 
 		 SUM(TotalAmount) AS TotalAmount, PayModeName, PaymentMode, Apply_SAR, Branch, AccountNo, ExAmtTypOfBnkAc, 
 		 PerqAmt_Branch, PerqAmt_BankAccountNumber, PeqTxTypOfBnkAc, INSTRUMENT_NAME, IS_AUTO_EXERCISE_ALLOWED, 
 		 CurrencyName, SUM(ExercisedQuantity) AS ExercisedQuantity, MIT_ID, CurrencyAlias, TrustType,  IsFormGenerate, 
 		 Entity, CurrencyAliasINR, IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG, SUM(SharesAlloted) AS SharesAlloted, 
 		 Sum(CashPayoutValue) AS CashPayoutValue
   	FROM  
    	 #Temp_Online_Exercise_Details
   	GROUP BY 
   		 ExerciseDate, exerciseno,GenDisableFlag,PayModeName,PaymentMode,Apply_SAR,Branch, AccountNo, ExAmtTypOfBnkAc,
   		 PerqAmt_Branch, PerqAmt_BankAccountNumber, PeqTxTypOfBnkAc, INSTRUMENT_NAME, IS_AUTO_EXERCISE_ALLOWED, 
   		 CurrencyName, MIT_ID, CurrencyAlias, TrustType,  IsFormGenerate, Entity, CurrencyAliasINR, 
   		 IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG

	DROP TABLE #Temp_Online_Exercise_Details
   	DROP TABLE #TEMP_ENTITY_DATA
END
GO
