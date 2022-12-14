/****** Object:  StoredProcedure [dbo].[Proc_GET_INProcesses_Exercise]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_GET_INProcesses_Exercise]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GET_INProcesses_Exercise]    Script Date: 7/8/2022 3:00:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[Proc_GET_INProcesses_Exercise] --'4566165'
(
@Employeeid VARCHAR(50)
	)			 	
AS
BEGIN
 DECLARE @ROUNDTAX INT
 DECLARE @FaceValue VARCHAR(10)

      SELECT @ROUNDTAX = cp.RoundupPlace_TaxAmt,@FaceValue=FaceVaue FROM   companyparameters cp 
       DECLARE @DisplayAs CHAR(1),@DisplaySplit CHAR(1)
        DECLARE @QUERY NVARCHAR(Max)
        DECLARE @SELECTQUERY NVARCHAR(Max)
		DECLARE @FROMQUERY NVARCHAR(Max)
		DECLARE @WHEREQUERY NVARCHAR(Max)

		 Select @DisplayAs = DisplayAs,@DisplaySplit = DisplaySplit From BonusSplitPolicy
        
        CREATE TABLE #Temp_Online_Exercise_Details
	(
		ExerciseDate DATETIME, exerciseno NUMERIC (18, 0), AmountPaid NUMERIC (38, 2), GenDisableFlag INT, PerqstPayable NUMERIC (18,6)
		, TotalAmount NUMERIC (38, 2), PayModeName VARCHAR (20), PaymentMode CHAR (1), Apply_SAR VARCHAR (1), Branch VARCHAR (200)
		, AccountNo VARCHAR (50), ExAmtTypOfBnkAc INT, PerqAmt_Branch VARCHAR (200), PerqAmt_BankAccountNumber VARCHAR (50), PeqTxTypOfBnkAc INT
		, INSTRUMENT_NAME NVARCHAR (500),  IS_AUTO_EXERCISE_ALLOWED VARCHAR (16), CurrencyName VARCHAR (50)
		, ExercisedQuantity NUMERIC (38, 0), MIT_ID INT , CurrencyAlias VARCHAR (50), TrustType VARCHAR (15),GRANTDATE DATETIME,IsFormGenerate INT,Entity VARCHAR(100),CurrencyAliasINR  VARCHAR(10),IS_PaymentWindow_Enabled TINYINT,PAYMENT_CLOSURE_MSG VARCHAR(1000),SharesAlloted NUMERIC(18,0),CashPayoutValue NUMERIC(18,2),schemetitle NVARCHAR(250),VestingDate DATETIME,PerqstValue NUMERIC(18,6),IS_UPLOAD_EXERCISE_FORM TINYINT
		, GRANTOPTIONID nvarchar(250) ,ExerciseId nvarchar(250),EntityBaseOn nvarchar(250),StockApprValue NUMERIC(18,6),
		SettlmentPrice NUMERIC(18,6),ISActivedforEntity TINYINT,DYNAMIC_FORM bigint,TEMPLATE_NAME VARCHAR (50), 
		CALCULATE_TAX NVARCHAR(200),TAX_SEQUENCENO  VARCHAR (50),Parent varchar(50) NULL,IsAccepted TINYINT,
		FRACTION_PAID_CASH INT,
		EXCEPT_FOR_TAXRATE_EMPLOYEE VARCHAR(10),ExercisePrice NUMERIC (18,6)
	)      
	 	CREATE TABLE #Temp_AuditData
	( 
		AuditId INT IDENTITY, ExerciseId INT, ExerciseNo INT,NumberOfShares FLOAT, CashPayoutValue FLOAT
	)
	INSERT INTO #Temp_AuditData  
	SELECT ExerciseId, ExerciseNo, SUM(NumberOfShares) AS NumberOfShares, SUM(CashPayoutValue) AS CashPayoutValue FROM AuditData
	Group By ExerciseId,ExerciseNo

	 IF(@DisplayAs = 'S' AND @DisplaySplit = 'S')
	 BEGIN 
	     SET @SELECTQUERY='SELECT 
		MAX( a.ExerciseDate) AS ExerciseDate, exerciseno,SUM (AmountPaid) AS AmountPaid,MIN(PerqstPayable1) AS GenDisableFlag,CONVERT(NVARCHAR(20), CAST(SUM(perqstpayable) AS NUMERIC(18, '+ CONVERT(varchar,@ROUNDTAX)+')))   AS PerqstPayable, 
		CAST(SUM (amountpaid)  AS NUMERIC(18,2)) + CAST(SUM(ISNULL(perqstpayable,0)) AS NUMERIC(18,2)) AS TotalAmount, 
		PayModeName,PaymentMode ,Apply_SAR, ISNULL(Branch,'''') AS Branch, ISNULL(AccountNo,'''') AS AccountNo,ExAmtTypOfBnkAc ,ISNULL(PerqAmt_Branch,'''') AS PerqAmt_Branch,ISNULL(PerqAmt_BankAccountNumber,'''') AS PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME,
		CASE WHEN ISNULL(IsAutoExercised,0) = 2 THEN ''Pending For Auto''  WHEN ISNULL(IsAutoExercised,0) = 1 THEN ''Auto''   ELSE ''Manual'' END AS IS_AUTO_EXERCISE_ALLOWED, CurrencyName, sum(ExercisedQuantity) as ExercisedQuantity, MIT_ID, CurrencyAlias,
		CASE WHEN TrustType= ''TC'' OR TrustType = ''TCOnly'' THEN ''Cash''  WHEN TrustType= '' TCLSA'' OR TrustType= ''TCLSP'' OR TrustType= ''TCLSA'' OR TrustType= ''TCLB'' OR TrustType= ''CCSA'' OR TrustType=''CCSP'' OR TrustType= ''CCB'' THEN ''CAshless''
			WHEN TrustType= ''TCandCLSA'' OR TrustType=''TCandCLSP'' OR TrustType= ''TCandCLB'' OR TrustType= ''CCNonTC'' OR TrustType= ''CCNonTCCSA'' OR TrustType= ''CCNonTCCSP'' OR TrustType= ''CCNonTCCB'' THEN ''CashANDCashless''
			ELSE ''None'' END AS TrustType,GRANTDATE,IsFormGenerate	,CurrencyAliasINR,ISNULL(IS_PaymentWindow_Enabled,0) AS IS_PaymentWindow_Enabled,PAYMENT_CLOSURE_MSG,	CASE WHEN MIT_ID = 3 OR MIT_ID = 4 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN SUM(CashPayValue) ELSE ISNULL(SUM(CashPayoutValue),0) END AS CashPayoutValue,
			CASE WHEN MIT_ID = 5 OR MIT_ID = 7 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN ISNULL(SUM(NumOfShares),0) WHEN MIT_ID = 6 THEN ISNULL(SUM(ShareAriseApprValue),0) ELSE CAST(ISNULL(SUM(EXERCISEDQUANTITY),0) AS NUMERIC(18,0)) END AS SharesAlloted,schemetitle,VestingDate,PerqstValue,
			IS_UPLOAD_EXERCISE_FORM, GRANTOPTIONID, ExerciseId,Entity,EntityBaseOn ,StockApprValue,SettlmentPrice,ISActivedforEntity,TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,
			TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,
			CASE WHEN ParentValue = ''N'' THEN ''Original''
			WHEN ParentValue = ''B'' THEN ''Bonus'' END AS ParentValue,IsAccepted,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,exerciseprice
			
	FROM (		SELECT distinct  GL.Parent as ParentValue, GR.grantdate , SHEX.IsFormGenerate, CASE  WHEN  GR.Apply_SAR IS NULL THEN ''N''  ELSE  GR.Apply_SAR  END AS Apply_SAR ,
				   SCH.schemetitle,   GOP.grantoptionid, 
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstValue,0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN ISNULL(SHEX.TentativePerqstValue,0)
                   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN SHEX.PerqstValue ELSE 0 END As PerqstValue,
				   --SHEX.PerqstValue,
				   ISNULL(GR.exercisepriceINR,SHEX.exerciseprice) as exerciseprice, 
				   SHEX.exercisedate,  GOP.grantedoptions,  SHEX.exerciseno,  SHEX.action, SHEX.exercisedquantity, SHEX.IS_UPLOAD_EXERCISE_FORM,
				   ( ( SHEX.exercisedquantity * SCH.optionratiodivisor ) /  ( SCH.optionratiomultiplier ) ) AS exercisablequantity, 
				   SHEX.exerciseid,  CASE WHEN (CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
				   when SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN  SHEX.PerqstPayable else ''0'' end) IS NULL THEN 0 ELSE 1 END as PerqstPayable1,	
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0)= ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
                   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN SHEX.PerqstPayable ELSE NULL END AS PerqstPayable,
				   PM.PayModeName,PM.PaymentMode, CASE WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN (ISNULL((SHEX.TentShareAriseApprValue),(SHEX.ShareAriseApprValue)) * '+@FaceValue+' )
				   WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN (ISNULL((SHEX.ShareAriseApprValue),0) * '+@FaceValue+' )	 ELSE 			   
				   (SHEX.ExercisedQuantity * ISNULL(GR.exercisepriceINR,SHEX.exerciseprice)) END AS AmountPaid,
				   ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc,				   
				   CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
				   SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, SHEX.TentativePerqstPayable, MIT.MIT_ID, SCH.TrustType, CM.CurrencyAlias,CASE WHEN GR.ExercisePriceINR IS NULL THEN CM.CurrencyAlias ELSE ''INR'' END AS  CurrencyAliasINR,
				   CASE WHEN ISNULL(IS_PaymentWindow_Enabled,''P'')=''L'' AND CONVERT(Date,DATEADD(day, ISNULL(CIM.NumberOfDays,0),SHEX.EXERCISEDATE))<= CONVERT(Date,GETDATE()) THEN 1 ELSE 0 END AS IS_PaymentWindow_Enabled,ISNULL(PAYMENT_CLOSURE_MSG,'''') AS PAYMENT_CLOSURE_MSG,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SUM(SHEX.TentativeCashPayoutValue),SUM(SHEX.CashPayoutValue))
				   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(SHEX.CashPayoutValue) ELSE 0 END AS CashPayoutValue,SUM(AU.NumberOfShares) AS NumOfShares,SUM(AU.CashPayoutValue) AS CashPayValue,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SUM(SHEX.TentShareAriseApprValue),0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(SHEX.ShareAriseApprValue) ELSE 0 END AS ShareAriseApprValue,
				   GL.FinalVestingDate As VestingDate,SHEX.Entity,SHEX.EntityBaseOn ,SHEX.StockApprValue,SHEX.SettlmentPrice,CIM.ISActivedforEntity,CWPM.TEMPLATE_NAME,SHEX.CALCULATE_TAX,SHEX.TAX_SEQUENCENO,GL.Parent,
				   SHEX.IsAccepted,SCH.FRACTION_PAID_CASH,CIM.EXCEPT_FOR_TAXRATE_EMPLOYEE as EXCEPT_FOR_TAXRATE_EMPLOYEE'

 SET @FROMQUERY=' FROM   shexercisedoptions SHEX 
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
					LEFT OUTER JOIN COUNTRY_WISE_PAYMENT_MODE CWPM ON CWPM.PAYMENTMASTER_ID = PM.Id AND CWPM.MIT_ID=MIT.MIT_ID'
 SET @WHEREQUERY=' WHERE (ISNULL(IsPrevestExercised,0) = 0) OR (ISNULL(IsPrevestExercised,0) = 1 AND SHEX.PaymentMode IS NOT NULL AND SHEX.PaymentMode!='''')
					GROUP BY  SHEX.CALCULATE_TAX,CIM.PAYMENT_CLOSURE_MSG,CIM.IS_PaymentWindow_Enabled,CIM.NumberOfDays,GR.exercisepriceINR,GR.grantdate,SHEX.IsFormGenerate , GR.Apply_SAR ,SHEX.action,
					SCH.schemetitle,CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
						WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN  ISNULL(SHEX.TentativePerqstValue,0)
				        WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN  SHEX.PerqstValue ELSE 0 end, GOP.grantoptionid, SHEX.exerciseprice, SHEX.exercisedate, GOP.grantedoptions, SHEX.exerciseno, SHEX.exercisedquantity,
					SCH.optionratiodivisor, SCH.optionratiomultiplier, SHEX.exerciseid,
					CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
					WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
					WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN  SHEX.PerqstPayable ELSE NULL end , SHEX.PerqstPayable, PM.PayModeName, PM.PaymentMode,
					ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc, SHEX.TentativePerqstPayable,MIT.INSTRUMENT_NAME, SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, MIT.MIT_ID, sch.TrustType, CM.CurrencyAlias, CIM.INS_DISPLY_NAME,GL.FinalVestingDate,SHEX.IS_UPLOAD_EXERCISE_FORM,SHEX.Entity,SHEX.EntityBaseOn,SHEX.StockApprValue,SHEX.SettlmentPrice,CIM.ISActivedforEntity,CWPM.TEMPLATE_NAME,SCH.CALCUALTE_TAX_PRIOR_DAYS,SHEX.FMVPrice,SHEX.PaymentMode,SHEX.CALCUALTE_TAX_PRIOR_DAYS,SHEX.TentativePerqstValue,SHEX.PerqstValue,SHEX.CALCULATE_TAX,SHEX.TAX_SEQUENCENO,GL.Parent,SHEX.IsAccepted,SCH.FRACTION_PAID_CASH,CIM.EXCEPT_FOR_TAXRATE_EMPLOYEE,
					 ,shex.TentShareAriseApprValue,shex.ShareAriseApprValue
				   )a 
       GROUP BY VestingDate,schemetitle,PerqstValue,PAYMENT_CLOSURE_MSG,IS_PaymentWindow_Enabled,exerciseno,grantdate,IsFormGenerate,action,PayModeName,PaymentMode ,Apply_SAR, Branch,AccountNo,ExAmtTypOfBnkAc,PerqAmt_Branch,PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME, IsAutoExercised, CurrencyName, MIT_ID,TrustType, CurrencyAlias,CurrencyAliasINR,IS_UPLOAD_EXERCISE_FORM, GRANTOPTIONID,ExerciseId ,Entity,EntityBaseOn , StockApprValue, SettlmentPrice,ISActivedforEntity,TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,ParentValue,IsAccepted,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE
       ORDER BY ExerciseDate DESC '
	 END
	 ELSE
	 BEGIN 
	       SET @SELECTQUERY='SELECT 
		MAX( a.ExerciseDate) AS ExerciseDate, exerciseno,SUM (AmountPaid) AS AmountPaid,MIN(PerqstPayable1) AS GenDisableFlag,CONVERT(NVARCHAR(100), CAST(SUM(perqstpayable) AS NUMERIC(18, '+ CONVERT(varchar,@ROUNDTAX)+')))   AS PerqstPayable, 
		CAST(SUM (amountpaid)  AS NUMERIC(18,2)) + CAST(SUM(ISNULL(perqstpayable,0)) AS NUMERIC(18,2)) AS TotalAmount, 
		PayModeName,PaymentMode ,Apply_SAR, ISNULL(Branch,'''') AS Branch, ISNULL(AccountNo,'''') AS AccountNo,ExAmtTypOfBnkAc ,ISNULL(PerqAmt_Branch,'''') AS PerqAmt_Branch,ISNULL(PerqAmt_BankAccountNumber,'''') AS PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME,
		CASE WHEN ISNULL(IsAutoExercised,0) = 2 THEN ''Pending For Auto''  WHEN ISNULL(IsAutoExercised,0) = 1 THEN ''Auto''   ELSE ''Manual'' END AS IS_AUTO_EXERCISE_ALLOWED, CurrencyName, sum(ExercisedQuantity) as ExercisedQuantity, MIT_ID, CurrencyAlias,
		CASE WHEN TrustType= ''TC'' OR TrustType = ''TCOnly'' THEN ''Cash''  WHEN TrustType= '' TCLSA'' OR TrustType= ''TCLSP'' OR TrustType= ''TCLSA'' OR TrustType= ''TCLB'' OR TrustType= ''CCSA'' OR TrustType=''CCSP'' OR TrustType= ''CCB'' THEN ''CAshless''
			WHEN TrustType= ''TCandCLSA'' OR TrustType=''TCandCLSP'' OR TrustType= ''TCandCLB'' OR TrustType= ''CCNonTC'' OR TrustType= ''CCNonTCCSA'' OR TrustType= ''CCNonTCCSP'' OR TrustType= ''CCNonTCCB'' THEN ''CashANDCashless''
			ELSE ''None'' END AS TrustType,GRANTDATE,IsFormGenerate	,CurrencyAliasINR,ISNULL(IS_PaymentWindow_Enabled,0) AS IS_PaymentWindow_Enabled,PAYMENT_CLOSURE_MSG,	CASE WHEN MIT_ID = 3 OR MIT_ID = 4 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN SUM(CashPayValue) ELSE ISNULL(SUM(CashPayoutValue),0) END AS CashPayoutValue,
			CASE WHEN MIT_ID = 5 OR MIT_ID = 7 THEN ''0'' WHEN (MIT_ID = 1 OR MIT_ID = 2) AND (PaymentMode = ''A'' OR PaymentMode = ''P'') THEN ISNULL(SUM(NumOfShares),0) WHEN MIT_ID = 6 THEN ISNULL(SUM(ShareAriseApprValue),0) ELSE CAST(ISNULL(SUM(EXERCISEDQUANTITY),0) AS NUMERIC(18,0)) END AS SharesAlloted,schemetitle,VestingDate,PerqstValue,
			IS_UPLOAD_EXERCISE_FORM, GRANTOPTIONID, ExerciseId,Entity,EntityBaseOn ,ISNULL(StockApprValue,0) AS StockApprValue,ISNULL(SettlmentPrice,0) AS SettlmentPrice,ISActivedforEntity,TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,'' ''  AS ParentValue, IsAccepted,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,exerciseprice
	FROM (		SELECT  distinct GR.grantdate , SHEX.IsFormGenerate, CASE  WHEN  GR.Apply_SAR IS NULL THEN ''N''  ELSE  GR.Apply_SAR  END AS Apply_SAR ,
				   SCH.schemetitle,   GOP.grantoptionid, 
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstValue,0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN ISNULL(SHEX.TentativePerqstValue,0)
                   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN SHEX.PerqstValue ELSE 0 END As PerqstValue,
				   --SHEX.PerqstValue,  
				   ISNULL(GR.exercisepriceINR,SHEX.exerciseprice) as exerciseprice, 
				   SHEX.exercisedate,  GOP.grantedoptions,  SHEX.exerciseno,  SHEX.action, SHEX.exercisedquantity, SHEX.IS_UPLOAD_EXERCISE_FORM,
				   ( ( SHEX.exercisedquantity * SCH.optionratiodivisor ) /  ( SCH.optionratiomultiplier ) ) AS exercisablequantity, 
				   SHEX.exerciseid,  CASE WHEN (CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
				   when SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN  SHEX.PerqstPayable else ''0'' end) IS NULL THEN 0 ELSE 1 END as PerqstPayable1,	
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0)= ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN CASE WHEN ISNULL(SHEX.TentativePerqstPayable,0) < 0 THEN 0 ELSE SHEX.TentativePerqstPayable END
                   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN CASE WHEN ISNULL(SHEX.PerqstPayable,0) < 0 THEN 0 ELSE SHEX.PerqstPayable END ELSE NULL END AS PerqstPayable,
				   PM.PayModeName,PM.PaymentMode, CASE WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN (ISNULL((SHEX.TentShareAriseApprValue),(SHEX.ShareAriseApprValue)) * '+@FaceValue+' )
				   WHEN MIT.MIT_ID = 6 AND SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN (ISNULL((SHEX.ShareAriseApprValue),0) * '+@FaceValue+' )	 ELSE 			   
				   (SHEX.ExercisedQuantity * ISNULL(GR.exercisepriceINR,SHEX.exerciseprice)) END AS AmountPaid,
				   ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc,				   
				   CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
				   SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, SHEX.TentativePerqstPayable, MIT.MIT_ID, SCH.TrustType, CM.CurrencyAlias,CASE WHEN GR.ExercisePriceINR IS NULL THEN CM.CurrencyAlias ELSE ''INR'' END AS  CurrencyAliasINR,
				   CASE WHEN ISNULL(IS_PaymentWindow_Enabled,''P'')=''L'' AND CONVERT(Date,DATEADD(day, ISNULL(CIM.NumberOfDays,0),SHEX.EXERCISEDATE))<= CONVERT(Date,GETDATE()) THEN 1 ELSE 0 END AS IS_PaymentWindow_Enabled,ISNULL(PAYMENT_CLOSURE_MSG,'''') AS PAYMENT_CLOSURE_MSG,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN (CASE WHEN ISNULL(SHEX.TentativeCashPayoutValue,0)<0 THEN 0 ELSE SHEX.TentativeCashPayoutValue END)
				        WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN (CASE WHEN ISNULL(SHEX.CashPayoutValue,0)<0 THEN 0 ELSE SHEX.CashPayoutValue END) ELSE 0 END AS CashPayoutValue,SUM(AU.NumberOfShares) AS NumOfShares,SUM(AU.CashPayoutValue) AS CashPayValue,
				   CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(SUM(SHEX.TentShareAriseApprValue),0)
				   WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(SHEX.ShareAriseApprValue) ELSE 0 END AS ShareAriseApprValue,
				   GL.FinalVestingDate As VestingDate,SHEX.Entity,SHEX.EntityBaseOn ,
				   CASE WHEN ISNULL(SHEX.StockApprValue,0)<0 THEN 0 ELSE SHEX.StockApprValue END AS StockApprValue,
				   CASE WHEN ISNULL(SHEX.SettlmentPrice,0)<0 THEN 0 ELSE SHEX.SettlmentPrice END AS SettlmentPrice,CIM.ISActivedforEntity,CWPM.TEMPLATE_NAME,SHEX.CALCULATE_TAX,SHEX.TAX_SEQUENCENO,'' '' as ParentValue, SHEX.IsAccepted,SCH.FRACTION_PAID_CASH,CIM.EXCEPT_FOR_TAXRATE_EMPLOYEE AS EXCEPT_FOR_TAXRATE_EMPLOYEE'

 SET @FROMQUERY=' FROM   shexercisedoptions SHEX 
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
					LEFT OUTER JOIN COUNTRY_WISE_PAYMENT_MODE CWPM ON CWPM.PAYMENTMASTER_ID = PM.Id AND CWPM.MIT_ID=MIT.MIT_ID'
 SET @WHEREQUERY=' WHERE (ISNULL(IsPrevestExercised,0) = 0) OR (ISNULL(IsPrevestExercised,0) = 1 AND SHEX.PaymentMode IS NOT NULL AND SHEX.PaymentMode!='''')
					GROUP BY  SHEX.CALCULATE_TAX,CIM.PAYMENT_CLOSURE_MSG,CIM.IS_PaymentWindow_Enabled,CIM.NumberOfDays,GR.exercisepriceINR,GR.grantdate,SHEX.IsFormGenerate , GR.Apply_SAR ,SHEX.action,
					SCH.schemetitle,SHEX.CashPayoutValue,SHEX.TentativeCashPayoutValue,CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
						WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.TentativeFMVPrice IS NOT NULL THEN  ISNULL(SHEX.TentativePerqstValue,0)
				        WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN  SHEX.PerqstValue ELSE 0 end, GOP.grantoptionid, SHEX.exerciseprice, SHEX.exercisedate, GOP.grantedoptions, SHEX.exerciseno, SHEX.exercisedquantity,
					SCH.optionratiodivisor, SCH.optionratiomultiplier, SHEX.exerciseid,
					CASE WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND (SHEX.PaymentMode = ''A'' OR SHEX.PaymentMode = ''P'' OR SHEX.PaymentMode = ''W'') AND SHEX.IsAutoExercised=2 AND ISNULL(SCH.CALCUALTE_TAX_PRIOR_DAYS,0) = ISNULL(SHEX.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHEX.TentativePerqstPayable,0)
					WHEN SHEX.CALCULATE_TAX = ''rdoTentativeTax'' AND SHEX.FMVPrice IS NOT NULL THEN  ISNULL(SHEX.TentativePerqstPayable,SHEX.PerqstPayable)
					WHEN SHEX.CALCULATE_TAX = ''rdoActualTax'' AND SHEX.FMVPrice IS NOT NULL THEN  SHEX.PerqstPayable ELSE NULL end , SHEX.PerqstPayable, PM.PayModeName, PM.PaymentMode,
					ST.Branch, ST.AccountNo, ST.ExAmtTypOfBnkAc, ST.PerqAmt_Branch, ST.PerqAmt_BankAccountNumber, ST.PeqTxTypOfBnkAc, SHEX.TentativePerqstPayable,MIT.INSTRUMENT_NAME, SHEX.IsAutoExercised, CM.CurrencyName, SHEX.TentativeFMVPrice, MIT.MIT_ID, sch.TrustType, CM.CurrencyAlias, CIM.INS_DISPLY_NAME,GL.FinalVestingDate,SHEX.IS_UPLOAD_EXERCISE_FORM,SHEX.Entity,SHEX.EntityBaseOn,SHEX.StockApprValue,SHEX.SettlmentPrice,CIM.ISActivedforEntity,CWPM.TEMPLATE_NAME,SCH.CALCUALTE_TAX_PRIOR_DAYS,SHEX.FMVPrice,SHEX.PaymentMode,SHEX.CALCUALTE_TAX_PRIOR_DAYS,SHEX.TentativePerqstValue,SHEX.PerqstValue,SHEX.CALCULATE_TAX,SHEX.TAX_SEQUENCENO,SHEX.IsAccepted,SCH.FRACTION_PAID_CASH,CIM.EXCEPT_FOR_TAXRATE_EMPLOYEE
					,shex.TentShareAriseApprValue,shex.ShareAriseApprValue
				   )a 
       GROUP BY VestingDate,schemetitle,PerqstValue,PAYMENT_CLOSURE_MSG,IS_PaymentWindow_Enabled,exerciseno,grantdate,IsFormGenerate,action,PayModeName,PaymentMode ,Apply_SAR, Branch,AccountNo,ExAmtTypOfBnkAc,PerqAmt_Branch,PerqAmt_BankAccountNumber,PeqTxTypOfBnkAc, INSTRUMENT_NAME, IsAutoExercised, CurrencyName, MIT_ID,TrustType, CurrencyAlias,CurrencyAliasINR,IS_UPLOAD_EXERCISE_FORM, GRANTOPTIONID,ExerciseId ,Entity,EntityBaseOn , StockApprValue, SettlmentPrice,ISActivedforEntity,TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,IsAccepted,ParentValue,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,exerciseprice
       ORDER BY ExerciseDate DESC '
	END

       
    
		
	Print @SELECTQUERY Print @FROMQUERY Print @WHEREQUERY
	
	INSERT INTO #Temp_Online_Exercise_Details  
	(
		ExerciseDate, exerciseno, AmountPaid, GenDisableFlag, PerqstPayable, TotalAmount, PayModeName, 
		PaymentMode, Apply_SAR, Branch, AccountNo, ExAmtTypOfBnkAc, PerqAmt_Branch, PerqAmt_BankAccountNumber, 
		PeqTxTypOfBnkAc, INSTRUMENT_NAME,  IS_AUTO_EXERCISE_ALLOWED, CurrencyName, ExercisedQuantity, 
		MIT_ID, CurrencyAlias, TrustType,GRANTDATE,IsFormGenerate,CurrencyAliasINR,IS_PaymentWindow_Enabled,
                PAYMENT_CLOSURE_MSG,CashPayoutValue,SharesAlloted,schemetitle,VestingDate,PerqstValue,IS_UPLOAD_EXERCISE_FORM, 
                GRANTOPTIONID,ExerciseId ,Entity, EntityBaseOn ,StockApprValue, SettlmentPrice,ISActivedforEntity,
		TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,Parent,IsAccepted,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,exerciseprice
	)
	EXECUTE(@SELECTQUERY+@FROMQUERY+@WHEREQUERY)	

	print 'test1'


	UPDATE TOED 
	set TOED.DYNAMIC_FORM=isnull(rm.DYNAMIC_FORM,0)
	FROM  ResidentialPaymentMode rm 
	INNER JOIN PaymentMaster pm on rm.PaymentMaster_Id=pm.Id
	INNER join MST_COM_CODE mcc on mcc.MCC_ID=rm.DYNAMIC_FORM 
	INNER JOIN #Temp_Online_Exercise_Details TOED ON TOED.MIT_ID=rm.MIT_ID
	INNER join COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID=TOED.MIT_ID
	AND CIM.PAYMENTMODE_BASED_ON=(CASE WHEN rm.PAYMENT_MODE_CONFIG_TYPE ='Company' THEN 'rdoCompanyLevel'
	WHEN rm.PAYMENT_MODE_CONFIG_TYPE ='Resident' THEN 'rdoResidentLevel'
	WHEN rm.PAYMENT_MODE_CONFIG_TYPE ='Country' THEN 'rdoCountryLevel' else '-' END)

	--select 'temp',MIT_ID, * from #Temp_Online_Exercise_Details
	--print 'test2'
			
 	UPDATE PRE SET PRE.ENTITY  = isnull( MLFV.FIELD_VALUE,0)
	         FROM #TEMP_ONLINE_EXERCISE_DETAILS AS PRE
		     INNER JOIN MASTER_LIST_FLD_VALUE MLFV ON MLFV.MLFV_ID=PRE.ENTITY
   
 	SELECT 
 		 ExerciseDate, exerciseno, SUM(AmountPaid) AS AmountPaid, exerciseprice,GenDisableFlag,SUM(PerqstPayable) AS PerqstPayable, 
 		 SUM(TotalAmount) AS TotalAmount, 
		 --PayModeName, 
		  CASE WHEN (select isnull(count(Sh_ExerciseNo),0) from Transaction_Details where Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and isnull(TPSLTransID,0) is not null)=1
		THEN 'Online' else PayModeName END AS PayModeName,
		 CASE WHEN (select isnull(count(Sh_ExerciseNo),0) from Transaction_Details where Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and isnull(TPSLTransID,0) is not null)=1
		THEN 'N' else PaymentMode END AS PaymentMode,
		 --PaymentMode, 
		 Apply_SAR, Branch, AccountNo, ExAmtTypOfBnkAc, 
 		 PerqAmt_Branch, PerqAmt_BankAccountNumber, PeqTxTypOfBnkAc, INSTRUMENT_NAME, IS_AUTO_EXERCISE_ALLOWED, 
 		 CurrencyName, SUM(ExercisedQuantity) AS ExercisedQuantity, MIT_ID, CurrencyAlias, TrustType,  IsFormGenerate, 
 		 Entity,EntityBaseOn, CurrencyAliasINR, IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG, SUM(SharesAlloted) AS SharesAlloted, 
 		 Sum(CashPayoutValue) AS CashPayoutValue,schemetitle ,VestingDate ,PerqstValue,
		 CASE when isNull(PaymentMode ,'')='' THen '1' 
		 WHEN (isNull(PaymentMode ,'')!='' AND ISNULL(IsFormGenerate,0)=0 )  THEN 
			CASE WHEN (ISNULL(PaymentMode ,'')='N') THEN (Select  CASE WHEN( COUNT(MerchantreferenceNo)>0) THEN '2' ELSE '1' END  FROM Transaction_Details 
			WHERE Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo
			 --and Payment_status='S' and Transaction_Status='Y'
			  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and TPSLTransID is not null)  
			WHEN (ISNULL(PaymentMode ,'')='Q' OR ISNULL(PaymentMode ,'')='D' OR ISNULL(PaymentMode ,'')='W' OR ISNULL(PaymentMode ,'')='R' OR ISNULL(PaymentMode ,'')='I' )
			--THEN (SELECT CASE WHEN( COUNT(ID)>0) THEN '2' ELSE '1' END FROM ShTransactionDetails WHERE ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo) ELSE '1' 
			THEN '2'
			ELSE '1'
			END
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=0)  THen '2' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)<>1)  THen '3' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)=1 And isnull(IsAccepted,0)<>1)  THen '4' 
		 when (ISNULL(PaymentMode ,'')<>'' AND ISNULL(IsFormGenerate,0)=1 And isnull(IS_UPLOAD_EXERCISE_FORM,0)=1 And isnull(IsAccepted,0)=1) THen '5'

		 ELse '0' END AS Status, 
		  (SELECT case when EXERCISE_STEPID=5 then -1 else EXERCISE_STEPID end  FROM FN_GET_EXERCISE_STEP_STATUS(#Temp_Online_Exercise_Details.ExerciseNo )) AS ExerciseStep,
		 --ISNULL((SELECT TOP 1 EXERCISE_STEPID FROM TRANSACTIONS_EXERCISE_STEP TES WHERE TES.EXERCISE_NO = #Temp_Online_Exercise_Details.ExerciseNo AND ISNULL(TES.IS_ATTEMPTED,0)=0  ),-1) AS ExerciseStep,
		 --ISNULL((SELECT TOP 1 DISPLAY_NAME FROM TRANSACTIONS_EXERCISE_STEP TES WHERE TES.EXERCISE_NO = #Temp_Online_Exercise_Details.ExerciseNo AND ISNULL(TES.IS_ATTEMPTED,0)=0  ),'Acknowledgement') AS ExerciseStepName,
		 (SELECT DISPLAY_NAME  FROM FN_GET_EXERCISE_STEP_STATUS(#Temp_Online_Exercise_Details.ExerciseNo )) AS ExerciseStepName,
		 GRANTOPTIONID,ExerciseId,StockApprValue,SettlmentPrice,ISActivedforEntity, DYNAMIC_FORM,TEMPLATE_NAME,
		 CALCULATE_TAX,TAX_SEQUENCENO ,Parent,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,

		 CASE WHEN( (ISNULL(PaymentMode ,'')='N') OR(select isnull(count(Sh_ExerciseNo),0) from Transaction_Details where Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and isnull(TPSLTransID,0) is not null)=1) THEN
		  ( Select  CASE When ( Convert(datetime,GetDate())< DateAdd(hh,02,Transaction_Date)) THEN 1 ELSE 0 END  
		  FROM Transaction_Details WHERE Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo 
		  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and isnull(TPSLTransID,0) is not null)
			else 0 END IsOnlineEnable,
			 CASE WHEN( (ISNULL(PaymentMode ,'')='N') OR(select isnull(count(Sh_ExerciseNo),0) from Transaction_Details where Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
			and isnull(TPSLTransID,0) is not null )=1) THEN
		  ( Select  CASE When ( Convert(datetime,GetDate())< DateAdd(hh,02,Transaction_Date)) 
		  THEN 'Your previous transcation is in under processes.Please wait for 2 hrs.' ELSE '' 
		  END  FROM Transaction_Details WHERE Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo 
		  and ISNULL(Payment_status,'S')='S' and ISNULL( Transaction_Status,'Y')='Y'
and isnull(TPSLTransID,0) is not null)
			else '' END MsgForOnlinePayment
--		   CASE WHEN (ISNULL(PaymentMode ,'')='N') THEN
--		  ( Select  CASE When ( Convert(datetime,GetDate())< DateAdd(hh,03,Transaction_Date)) THEN 1 ELSE 0 END  
--		  FROM Transaction_Details WHERE Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo and Payment_status='S' and Transaction_Status='Y'
--			and TPSLTransID is not null)
--			else 0 END IsOnlineEnable,
--			CASE WHEN (ISNULL(PaymentMode ,'')='N') THEN
--		  ( Select  CASE When ( Convert(datetime,GetDate())< DateAdd(hh,03,Transaction_Date)) THEN 'Your previous transcation is in under processes.Please wait for 2 hrs.' ELSE '' END  FROM Transaction_Details WHERE Sh_ExerciseNo=#Temp_Online_Exercise_Details.ExerciseNo and Payment_status='S' and Transaction_Status='Y'
--and TPSLTransID is not null)
--			else '' END MsgForOnlinePayment

   	FROM  
    	 #Temp_Online_Exercise_Details
   	GROUP BY 
   		 ExerciseDate, exerciseno,GenDisableFlag,PayModeName,PaymentMode,Apply_SAR,Branch, AccountNo, ExAmtTypOfBnkAc,
   		 PerqAmt_Branch, PerqAmt_BankAccountNumber, PeqTxTypOfBnkAc, INSTRUMENT_NAME, IS_AUTO_EXERCISE_ALLOWED, 
   		 CurrencyName, MIT_ID, CurrencyAlias, TrustType,  IsFormGenerate, Entity, EntityBaseOn, CurrencyAliasINR, 
   		 IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG,schemetitle ,VestingDate,PerqstValue ,IS_UPLOAD_EXERCISE_FORM, grantoptionid,ExerciseId,StockApprValue,SettlmentPrice,ISActivedforEntity,DYNAMIC_FORM,TEMPLATE_NAME,CALCULATE_TAX,TAX_SEQUENCENO,Parent,IsAccepted,FRACTION_PAID_CASH,EXCEPT_FOR_TAXRATE_EMPLOYEE,exerciseprice
	    ORDER BY ExerciseDate DESC
	

	IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'TRANSACTIONS_EXERCISE_STEP')
	BEGIN
	     SELECT distinct EXERCISE_NO, EXERCISE_STEPID, DISPLAY_NAME, IS_ATTEMPTED, UPLOAD_TYPE FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN #Temp_Online_Exercise_Details TED ON  TES.EXERCISE_NO = TED.exerciseno
	END
    DROP TABLE #Temp_Online_Exercise_Details
END
GO
