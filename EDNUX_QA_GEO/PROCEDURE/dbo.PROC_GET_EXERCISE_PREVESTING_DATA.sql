/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_PREVESTING_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_PREVESTING_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_PREVESTING_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EXERCISE_PREVESTING_DATA]
(
	@USER_ID		VARCHAR(20)
)
 AS
  BEGIN    
 SET NOCOUNT ON;    
    
 BEGIN /* CREATE TEMP TABLE */    
 DECLARE @DisplayAs CHAR(1),@DisplaySplit CHAR(1)
    CREATE TABLE #TEMP_PREVESTING_DATA    
  (      
       Apply_SAR VARCHAR (1), TrustType CHAR (10), SchemeType VARCHAR (18), VestingDate DATETIME, GrantRegistrationId VARCHAR (20), GrantedOptions NUMERIC (38, 0), ExercisableQuantity NUMERIC (38, 0)    
      , UnapprovedExerciseQuantity NUMERIC (38, 0), FinalVestingDate DATETIME, FinalExpirayDate DATETIME, ExercisePrice NUMERIC (18, 2), GrantDate DATETIME, LockInPeriodStartsFrom VARCHAR (1)    
      , LockInPeriod NUMERIC (18, 0), OptionRatioMultiplier NUMERIC (18, 0), OptionRatioDivisor NUMERIC (18, 0), ExercisedQuantity NUMERIC (38, 0), FBTValue NUMERIC (10, 2)    
      , FBTPayable NUMERIC (34, 8), GrantOptionId VARCHAR (100), GrantLegId DECIMAL (10, 0), GrantLegSerialNumber NUMERIC (18, 0), SchemeTitle VARCHAR (50), OptionTimePercentage NUMERIC (5, 2)    
      , IsPaymentModeRequired TINYINT, PaymentModeEffectiveDate NVARCHAR (10), IS_ADS_SCHEME BIT, IS_ADS_EX_OPTS_ALLOWED BIT, CurrencySymbol NTEXT, CurrencyAlias VARCHAR (50)    
			, SchemeId VARCHAR (50), VestingFormulaDate DATETIME, GrantFormulaDate DATETIME, show INT, PaymentMode BIGINT, ExerciseAmountPayable NUMERIC (18, 6), TentativeFMVPrice VARCHAR(100)
      , TentativePerqstValue NUMERIC (18, 6), TentativePerqstPayable NUMERIC (18, 6), EPPS_ID NUMERIC (18, 0), PREVESTING_AUTOEXERCISE INT, POSTVESTING_AUTOEXERCISE INT    
      , IS_PAYMENT_MODE_SELECTED TINYINT, EXERCISEID NUMERIC (18, 0), PaymentModeName CHAR (1), IS_UPLOAD_EXERCISE_FORM INT,Entity VARCHAR(100),ExerciseINRFlag  Bit,GroupNumber int ,EXERCISE_NUMBER NUMERIC (18, 0) ,EntityBaseOn nvarchar(250),IsFormGenerate INT,ISActivedforEntity BIT,CALCULATE_TAX VARCHAR(100),CALCUALTE_TAX_PRIOR_DAYS INT, CALCUALTE_TAX_PRIOR_DAYS_SCHEME INT,IS_UPLOAD_EXERCISE_FORM_ON DATETIME, CODE_NAME NVARCHAR(100)
      ,Note VARCHAR(50) NULL,BonusSplitPolicy varchar(50), ResidentialStatus char(1)
	  , MIT_ID INT , INSTRUMENT_NAME NVARCHAR (500), IS_PaymentWindow_Enabled TINYINT,PAYMENT_CLOSURE_MSG VARCHAR(1000)
	  , OnlineTransactionPaid char(1)
	 )    
	 Select @DisplayAs = DisplayAs,@DisplaySplit = DisplaySplit From BonusSplitPolicy
    
 END     
     
 BEGIN    
     
	 IF(@DisplayAs = 'C' AND @DisplaySplit = 'C')
	 BEGIN 
	     INSERT INTO #TEMP_PREVESTING_DATA     
			(Apply_SAR, TrustType, SchemeType, VestingDate, GrantRegistrationId, GrantedOptions, ExercisableQuantity, UnapprovedExerciseQuantity, FinalVestingDate,    
		FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, ExercisedQuantity, FBTValue,    
		FBTPayable, GrantOptionId, GrantLegId, GrantLegSerialNumber, SchemeTitle, OptionTimePercentage, IsPaymentModeRequired, PaymentModeEffectiveDate, IS_ADS_SCHEME,     
		IS_ADS_EX_OPTS_ALLOWED, CurrencySymbol, CurrencyAlias, SchemeId, VestingFormulaDate, GrantFormulaDate, show, PaymentMode, ExerciseAmountPayable,    
		TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, EPPS_ID, PREVESTING_AUTOEXERCISE, POSTVESTING_AUTOEXERCISE, IS_PAYMENT_MODE_SELECTED,     
		EXERCISEID, PaymentModeName, IS_UPLOAD_EXERCISE_FORM,ExerciseINRFlag,GroupNumber,EXERCISE_NUMBER, Entity,EntityBaseOn,IsFormGenerate,ISActivedforEntity,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_SCHEME,IS_UPLOAD_EXERCISE_FORM_ON
		,Note
		,BonusSplitPolicy, ResidentialStatus
		, MIT_ID, INSTRUMENT_NAME, IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG, OnlineTransactionPaid)     

		SELECT     
		CASE WHEN  GR.Apply_SAR IS NULL THEN 'N' ELSE GR.Apply_SAR END AS Apply_SAR,     
		SCH.TrustType, case when (SCH.trusttype='TC' OR SCH.trusttype='TCLSA' or SCH.trusttype='TCLSP'     
			OR SCH.TrustType='TCLB' or SCH.trusttype='TCOnly' OR SCH.trusttype='TCandCLSA'     
			OR SCH.TrustType='TCandCLSP' or SCH.trusttype='TCandCLB' OR SCH.trusttype='CCSA'     
			OR SCH.TrustType='CCSP' or SCH.trusttype='CCB' or SCH.trusttype='CCNonTCCSA'     
		OR SCH.TrustType='CCNonTCCB' or SCH.trusttype='CCNonTCCSP')      
			THEN 'Trust Scheme' ELSE 'Non - Trust Scheme' END AS SchemeType,     
		MIN(GL.VestingDate) AS VestingDate, GL.GrantRegistrationId,  
		SUM(GL.GrantedOptions) AS GrantedOptions,
		 SUM(ISNULL( SHE.ExercisedQuantity,GL.ExercisableQuantity) )   AS ExercisableQuantity,
		--CASE WHEN SHE.ExercisedQuantity IS NULL THEN  SUM(GL.ExercisableQuantity) ELSE SHE.ExercisedQuantity  END  AS ExercisableQuantity,    
			SUM(GL.UnapprovedExerciseQuantity) AS UnapprovedExerciseQuantity,      
			MIN(GL.FinalVestingDate) AS FinalVestingDate, MAX(GL.FinalExpirayDate) AS FinalExpirayDate,      
			ISNULL(MAX(SHE.ExercisePriceINR),MAX(SHE.ExercisePrice)) AS ExercisePrice, MAX(GR.GrantDate) AS GrantDate,     
			MAX(SCH.LockInPeriodStartsFrom) AS LockInPeriodStartsFrom, MAX(SCH.LockInPeriod) AS LockInPeriod,    
			MAX(SCH.OptionRatioMultiplier) AS OptionRatioMultiplier, MAX(SCH.OptionRatioDivisor) AS OptionRatioDivisor,      
			SUM(GL.ExercisedQuantity) AS ExercisedQuantity, ISNULL(VP.FBTValue,0) AS FBTValue,     
			ROUND(((VP.FBTValue - MAX(SHE.ExercisePrice)) * (SELECT FBTax FROM companyparameters)/100),2) AS FBTPayable,      
			GP.GrantOptionId , GL.GrantLegId,0 AS GrantLegSerialNumber,SCH.SchemeTitle,VP.OptionTimePercentage AS OptionTimePercentage,     
			SCH.IsPaymentModeRequired, SCH.PaymentModeEffectiveDate, SCH.IS_ADS_SCHEME, SCH.IS_ADS_EX_OPTS_ALLOWED,      
			CONVERT(NVARCHAR(MAX), CR.currencysymbol) AS CurrencySymbol,CR.CurrencyAlias AS CurrencyAlias,     
			SCH.SchemeId,dateadd(day,AE.EXERCISE_AFTER_DAYS-SCH.CALCUALTE_TAX_PRIOR_DAYS,MIN(GL.VestingDate)) AS VestingFormulaDate,           
			dateadd(day,-SCH.CALCUALTE_TAX_PRIOR_DAYS,MAX(GR.GrantDate)) AS GrantFormulaDate,     
			CASE WHEN MIN(GL.VestingDate) BETWEEN  getdate() AND DATEADD(day,AT.BEFORE_VESTING_DATE,getdate()) THEN 1 ELSE 0 END AS show,    
			ISNULL(PM.ID,0) AS PaymentMode,Sum((Isnull(SHE.ExercisedQuantity,0)* Isnull(SHE.ExercisePrice,0))) AS ExerciseAmountPayable,
			dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SHE.TentativeFMVPrice,0),'FMV') AS TentativeFMVPrice,
			 sum( ISNULL( SHE.TentativePerqstValue,0)) AS TentativePerqstValue,
                 sum(dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SHE.TentativePerqstPayable,0),'TAXVALUE') )AS TentativePerqstPayable ,
			--ISNULL(SHE.TentativePerqstValue,0) AS TentativePerqstValue,dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SHE.TentativePerqstPayable,0),'TAXVALUE') AS TentativePerqstPayable ,
			'0' AS EPPS_ID,AT.PREVESTING_AUTOEXERCISE,AT.POSTVESTING_AUTOEXERCISE,AT.IS_PAYMENT_MODE_SELECTED,
			CASE WHEN (GMEN.GroupNumber IS NULL) THEN 0 ELSE MIN(ISNULL(SHE.EXERCISEID,0) ) END AS EXERCISEID,ISNULL(PM.PaymentMode,'') AS PaymentModeName,    
			ISNULL(SHE.IS_UPLOAD_EXERCISE_FORM,0) AS IS_UPLOAD_EXERCISE_FORM,CASE WHEN GR.ExercisePriceINR IS NULL THEN 0 ELSE 1 END AS  ExerciseINRFlag          
  			,GMEN.GroupNumber ,SHE.ExerciseNo,SHE.Entity,SHE.EntityBaseOn,IsFormGenerate,ISActivedforEntity,SHE.CALCULATE_TAX,SHE.CALCUALTE_TAX_PRIOR_DAYS, SCH.CALCUALTE_TAX_PRIOR_DAYS AS CALCUALTE_TAX_PRIOR_DAYS_SCHEME,SHE.IS_UPLOAD_EXERCISE_FORM_ON,
		'' AS Note		
		,'C', EM.ResidentialStatus, MIT.MIT_ID, CIM.INS_DISPLY_NAME,
		CASE WHEN ISNULL(IS_PaymentWindow_Enabled,'P')='L' AND CONVERT(Date,DATEADD(day, ISNULL(CIM.NumberOfDays,0),SHE.EXERCISEDATE))<= CONVERT(Date,GETDATE()) THEN 1 ELSE 0 END AS IS_PaymentWindow_Enabled,ISNULL(PAYMENT_CLOSURE_MSG,'''') AS PAYMENT_CLOSURE_MSG
	    ,CASE WHEN (ISNULL(SHE.PaymentMode ,'')='N') THEN (Select  CASE WHEN( COUNT(MerchantreferenceNo)>0) THEN '1' ELSE '0' END  FROM Transaction_Details WHERE Sh_ExerciseNo=SHE.ExerciseNo AND BankReferenceNo IS Not Null) END as OnlineTransactionPaid 
		FROM     
			GrantOptions AS GP    
		INNER JOIN VestingPeriod  AS VP ON GP.grantregistrationid=VP.grantregistrationid      
		INNER JOIN GrantLeg    AS GL ON GL.GrantOptionId = GP.GrantOptionId and GL.GrantLegId = VP.vestingperiodno     
			INNER JOIN GrantLeg AS GL1 ON GL1.ID = GL.ID
		INNER JOIN EmployeeMaster AS EM ON GP.EmployeeId = EM.EmployeeId      
		INNER JOIN GrantRegistration AS GR  ON GL.GrantRegistrationId = GR.GrantRegistrationId      
		INNER JOIN SCHEME        AS SCH ON GL.SchemeId = SCH.SchemeId      
		INNER JOIN COMPANY_INSTRUMENT_MAPPING   AS CIM ON CIM.MIT_ID = SCH.MIT_ID      
		INNER JOIN CURRENCYMASTER           AS CR ON CR.CurrencyID = CIM.CurrencyID      
		INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AT ON AT.SCHEME_ID = SCH.SchemeId    
		INNER JOIN AUTO_EXERCISE_CONFIG     AS AE ON AE.AEC_ID = AT.AEC_ID  AND AE.IS_APPROVE=1  
		INNER JOIN ShExercisedOptions       AS SHE ON GL.ID = she.GrantLegSerialNumber    
		LEFT JOIN PaymentMaster            AS PM  ON PM.PaymentMode = SHE.PaymentMode  
		LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GL.GrantRegistrationId 
		INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID = CIM.MIT_ID         
		AND GMEN.GrantOptionId = GL.GrantOptionId         
		WHERE     
		EM.LoginId = @USER_ID    
		AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE,GL.FinalVestingDate+AT.POSTVESTING_DAYS)    
		AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE,GL.FinalExpirayDate+AT.POSTVESTING_DAYS)     
		AND (GL.GrantedOptions - GL.UnapprovedExerciseQuantity >= 0 OR AT.POSTVESTING_AUTOEXERCISE=1)    
		AND GL.Status = 'A'     
		AND (GL.ExercisableQuantity > 0  OR GL.UnapprovedExerciseQuantity > 0 OR AT.POSTVESTING_AUTOEXERCISE=1)     
		AND SCH.IsPUPEnabled <> 1   AND SCH.IS_AUTO_EXERCISE_ALLOWED = 1    
		AND AT.IS_PAYMENT_MODE_SELECTED = 1 AND SCH.CALCULATE_TAX_PREVESTING = 'rdoTentativeTax'    

		GROUP BY    GL.GrantRegistrationId, 
		GP.GrantOptionId,GL.GrantLegId
		,SCH.TrustType, GR.Apply_SAR, GR.ExercisePriceINR,    
		SCH.SchemeTitle,VP.FBTValue,VP.OptionTimePercentage, SCH.IsPaymentModeRequired,     
		SCH.PaymentModeEffectiveDate, SCH.IS_ADS_SCHEME, SCH.IS_ADS_EX_OPTS_ALLOWED,PM.ID     
		,CONVERT(NVARCHAR(MAX), CR.CurrencySymbol), CR.CurrencyAlias, SCH.SchemeId,AT.BEFORE_VESTING_DATE,SCH.CALCUALTE_TAX_PRIOR_DAYS,  AE.EXERCISE_AFTER_DAYS  
		, SHE.TentativeFMVPrice  
		,AT.PREVESTING_AUTOEXERCISE,AT.POSTVESTING_AUTOEXERCISE,AT.IS_PAYMENT_MODE_SELECTED, AT.POSTVESTING_DAYS
		,PM.PaymentMode,SHE.IS_UPLOAD_EXERCISE_FORM, GMEN.GroupNumber, SHE.ExerciseNo ,SHE.Entity,SHE.EntityBaseOn,SHE.isFormGenerate,CIM.ISActivedforEntity,SHE.CALCULATE_TAX
		,SHE.CALCUALTE_TAX_PRIOR_DAYS,SHE.IS_UPLOAD_EXERCISE_FORM_ON,SHE.PaymentMode, EM.ResidentialStatus,  MIT.MIT_ID,CIM.INS_DISPLY_NAME, IS_PaymentWindow_Enabled, NUMBEROFDAYS, ExerciseDate, PAYMENT_CLOSURE_MSG
      HAVING      
			CASE WHEN MIN(GL.VestingDate+AT.POSTVESTING_DAYS) BETWEEN  GETDATE() AND DATEADD(day,AT.BEFORE_VESTING_DATE+AT.POSTVESTING_DAYS,GETDATE()) THEN 1 ELSE 0 END >0
		    ORDER BY GrantLegId asc ,ExercisePrice desc  


	 END
	 ELSE
	 BEGIN
		INSERT INTO #TEMP_PREVESTING_DATA     
			(Apply_SAR, TrustType, SchemeType, VestingDate, GrantRegistrationId, GrantedOptions, ExercisableQuantity, UnapprovedExerciseQuantity, FinalVestingDate,    
		FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, ExercisedQuantity, FBTValue,    
		FBTPayable, GrantOptionId, GrantLegId, GrantLegSerialNumber, SchemeTitle, OptionTimePercentage, IsPaymentModeRequired, PaymentModeEffectiveDate, IS_ADS_SCHEME,     
		IS_ADS_EX_OPTS_ALLOWED, CurrencySymbol, CurrencyAlias, SchemeId, VestingFormulaDate, GrantFormulaDate, show, PaymentMode, ExerciseAmountPayable,    
		TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, EPPS_ID, PREVESTING_AUTOEXERCISE, POSTVESTING_AUTOEXERCISE, IS_PAYMENT_MODE_SELECTED,     
		EXERCISEID, PaymentModeName, IS_UPLOAD_EXERCISE_FORM,ExerciseINRFlag,GroupNumber,EXERCISE_NUMBER, Entity,EntityBaseOn,IsFormGenerate,ISActivedforEntity,CALCULATE_TAX,
		CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_SCHEME,IS_UPLOAD_EXERCISE_FORM_ON,Note
		,BonusSplitPolicy, ResidentialStatus, MIT_ID, INSTRUMENT_NAME,  IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG, OnlineTransactionPaid)     

  
        
		SELECT     
		CASE WHEN  GR.Apply_SAR IS NULL THEN 'N' ELSE GR.Apply_SAR END AS Apply_SAR,     
		SCH.TrustType, case when (SCH.trusttype='TC' OR SCH.trusttype='TCLSA' or SCH.trusttype='TCLSP'     
			OR SCH.TrustType='TCLB' or SCH.trusttype='TCOnly' OR SCH.trusttype='TCandCLSA'     
			OR SCH.TrustType='TCandCLSP' or SCH.trusttype='TCandCLB' OR SCH.trusttype='CCSA'     
			OR SCH.TrustType='CCSP' or SCH.trusttype='CCB' or SCH.trusttype='CCNonTCCSA'     
		OR SCH.TrustType='CCNonTCCB' or SCH.trusttype='CCNonTCCSP')      
			THEN 'Trust Scheme' ELSE 'Non - Trust Scheme' END AS SchemeType,     
		MIN(GL.VestingDate) AS VestingDate, MIN(GL.GrantRegistrationId) AS GrantRegistrationId,     
		SUM(GL.GrantedOptions) AS GrantedOptions,CASE WHEN SHE.ExercisedQuantity IS NULL THEN  SUM(GL.ExercisableQuantity) ELSE SHE.ExercisedQuantity  END  AS ExercisableQuantity,    
			SUM(GL.UnapprovedExerciseQuantity) AS UnapprovedExerciseQuantity,      
			MIN(GL.FinalVestingDate) AS FinalVestingDate, MAX(GL.FinalExpirayDate) AS FinalExpirayDate,      
			ISNULL(MAX(SHE.ExercisePriceINR),MAX(SHE.ExercisePrice)) AS ExercisePrice, MAX(GR.GrantDate) AS GrantDate,     
			MAX(SCH.LockInPeriodStartsFrom) AS LockInPeriodStartsFrom, MAX(SCH.LockInPeriod) AS LockInPeriod,    
			MAX(SCH.OptionRatioMultiplier) AS OptionRatioMultiplier, MAX(SCH.OptionRatioDivisor) AS OptionRatioDivisor,      
			SUM(GL.ExercisedQuantity) AS ExercisedQuantity, ISNULL(VP.FBTValue,0) AS FBTValue,     
			ROUND(((VP.FBTValue - MAX(SHE.ExercisePrice)) * (SELECT FBTax FROM companyparameters)/100),2) AS FBTPayable,      
			GP.GrantOptionId , GL.GrantLegId,GL.ID AS GrantLegSerialNumber,SCH.SchemeTitle,VP.OptionTimePercentage AS OptionTimePercentage,     
			SCH.IsPaymentModeRequired, SCH.PaymentModeEffectiveDate, SCH.IS_ADS_SCHEME, SCH.IS_ADS_EX_OPTS_ALLOWED,      
			CONVERT(NVARCHAR(MAX), CR.currencysymbol) AS CurrencySymbol,CR.CurrencyAlias AS CurrencyAlias,     
			SCH.SchemeId,dateadd(day,AE.EXERCISE_AFTER_DAYS-SCH.CALCUALTE_TAX_PRIOR_DAYS,MIN(GL.VestingDate)) AS VestingFormulaDate,           
			dateadd(day,-SCH.CALCUALTE_TAX_PRIOR_DAYS,MAX(GR.GrantDate)) AS GrantFormulaDate,     
			CASE WHEN MIN(GL.VestingDate) BETWEEN  getdate() AND DATEADD(day,AT.BEFORE_VESTING_DATE,getdate()) THEN 1 ELSE 0 END AS show,    
			ISNULL(PM.ID,0) AS PaymentMode,Sum((Isnull(SHE.ExercisedQuantity,0)* Isnull(SHE.ExercisePrice,0))) AS ExerciseAmountPayable,
			dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SHE.TentativeFMVPrice,0),'FMV') AS TentativeFMVPrice,
			ISNULL(SHE.TentativePerqstValue,0) AS TentativePerqstValue,dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SHE.TentativePerqstPayable,0),'TAXVALUE') AS TentativePerqstPayable ,
			'0' AS EPPS_ID,AT.PREVESTING_AUTOEXERCISE,AT.POSTVESTING_AUTOEXERCISE,AT.IS_PAYMENT_MODE_SELECTED,ISNULL(SHE.EXERCISEID,0) AS EXERCISEID,ISNULL(PM.PaymentMode,'') AS PaymentModeName,    
			ISNULL(SHE.IS_UPLOAD_EXERCISE_FORM,0) AS IS_UPLOAD_EXERCISE_FORM,CASE WHEN GR.ExercisePriceINR IS NULL THEN 0 ELSE 1 END AS  ExerciseINRFlag          
  			,GMEN.GroupNumber ,SHE.ExerciseNo,SHE.Entity,SHE.EntityBaseOn,IsFormGenerate,ISActivedforEntity,SHE.CALCULATE_TAX,SHE.CALCUALTE_TAX_PRIOR_DAYS, SCH.CALCUALTE_TAX_PRIOR_DAYS AS CALCUALTE_TAX_PRIOR_DAYS_SCHEME,SHE.IS_UPLOAD_EXERCISE_FORM_ON,
		
		CASE WHEN (@DisplayAs ='S' AND @DisplaySplit = 'S') THEN
		CASE WHEN GL.Parent = 'N'THEN 'Normal'
		WHEN GL.Parent = 'B'THEN 'Bonus'
		WHEN GL.Parent = 'S'THEN 'Split' END ELSE '' END AS Note
		
		,CASE WHEN (@DisplayAs ='S' AND @DisplaySplit = 'S') THEN
		'S' else 'C'END , EM.ResidentialStatus,  MIT.MIT_ID, CIM.INS_DISPLY_NAME,
		CASE WHEN ISNULL(IS_PaymentWindow_Enabled,'P')='L' AND CONVERT(Date,DATEADD(day, ISNULL(CIM.NumberOfDays,0),SHE.EXERCISEDATE))<= CONVERT(Date,GETDATE()) THEN 1 ELSE 0 END AS IS_PaymentWindow_Enabled,ISNULL(PAYMENT_CLOSURE_MSG,'''') AS PAYMENT_CLOSURE_MSG
		,CASE WHEN (ISNULL(SHE.PaymentMode ,'')='N') THEN (Select  CASE WHEN( COUNT(MerchantreferenceNo)>0) THEN '1' ELSE '0' END  FROM Transaction_Details WHERE Sh_ExerciseNo=SHE.ExerciseNo AND BankReferenceNo IS Not Null) END as OnlineTransactionPaid 
		FROM     
			GrantOptions AS GP    
		INNER JOIN VestingPeriod  AS VP ON GP.grantregistrationid=VP.grantregistrationid      
		INNER JOIN GrantLeg    AS GL ON GL.GrantOptionId = GP.GrantOptionId and GL.GrantLegId = VP.vestingperiodno     
		INNER JOIN EmployeeMaster AS EM ON GP.EmployeeId = EM.EmployeeId      
		INNER JOIN GrantRegistration AS GR  ON GL.GrantRegistrationId = GR.GrantRegistrationId      
		INNER JOIN SCHEME        AS SCH ON GL.SchemeId = SCH.SchemeId      
		INNER JOIN COMPANY_INSTRUMENT_MAPPING   AS CIM ON CIM.MIT_ID = SCH.MIT_ID      
		INNER JOIN CURRENCYMASTER           AS CR ON CR.CurrencyID = CIM.CurrencyID      
		INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AT ON AT.SCHEME_ID = SCH.SchemeId    
		INNER JOIN AUTO_EXERCISE_CONFIG     AS AE ON AE.AEC_ID = AT.AEC_ID  AND AE.IS_APPROVE=1  
		INNER JOIN ShExercisedOptions       AS SHE ON GL.ID = she.GrantLegSerialNumber    
		LEFT JOIN PaymentMaster            AS PM  ON PM.PaymentMode = SHE.PaymentMode  
		LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GL.GrantRegistrationId 
		INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID = CIM.MIT_ID       
		AND GMEN.GrantOptionId = GL.GrantOptionId         
		WHERE     
		EM.LoginId = @USER_ID    
		AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE,GL.FinalVestingDate+AT.POSTVESTING_DAYS)    
		AND CONVERT(DATE, GETDATE()) <= CONVERT(DATE,GL.FinalExpirayDate+AT.POSTVESTING_DAYS)     
		AND (GL.GrantedOptions - GL.UnapprovedExerciseQuantity >= 0 OR AT.POSTVESTING_AUTOEXERCISE=1)    
		AND GL.Status = 'A'     
			AND (GL.ExercisableQuantity > 0  OR GL.UnapprovedExerciseQuantity > 0 OR AT.POSTVESTING_AUTOEXERCISE=1)     
		AND SCH.IsPUPEnabled <> 1 AND SCH.IS_AUTO_EXERCISE_ALLOWED = 1    
		AND AT.IS_PAYMENT_MODE_SELECTED = 1 AND SCH.CALCULATE_TAX_PREVESTING = 'rdoTentativeTax'    
		GROUP BY     
		GP.GrantOptionId,SCH.TrustType, GR.Apply_SAR, GL.GrantLegId,GL.ID,GR.ExercisePriceINR,    
		SCH.SchemeTitle,VP.FBTValue,VP.OptionTimePercentage, SCH.IsPaymentModeRequired,     
		SCH.PaymentModeEffectiveDate, SCH.IS_ADS_SCHEME, SCH.IS_ADS_EX_OPTS_ALLOWED,PM.ID,     
		CONVERT(NVARCHAR(MAX), CR.CurrencySymbol), CR.CurrencyAlias, SCH.SchemeId,AT.BEFORE_VESTING_DATE,SCH.CALCUALTE_TAX_PRIOR_DAYS,    
		SHE.TentativeFMVPrice,SHE.TentativePerqstValue,SHE.TentativePerqstPayable,    
		AT.PREVESTING_AUTOEXERCISE,AT.POSTVESTING_AUTOEXERCISE,AT.IS_PAYMENT_MODE_SELECTED,AE.EXERCISE_AFTER_DAYS ,AT.POSTVESTING_DAYS,SHE.EXERCISEID ,PM.PaymentMode,SHE.ExercisedQuantity,SHE.IS_UPLOAD_EXERCISE_FORM,GMEN.GroupNumber,SHE.ExerciseNo ,SHE.Entity,SHE.EntityBaseOn,SHE.isFormGenerate,CIM.ISActivedforEntity,SHE.CALCULATE_TAX,SHE.CALCUALTE_TAX_PRIOR_DAYS,SHE.IS_UPLOAD_EXERCISE_FORM_ON,SHE.PaymentMode
		, GL.Parent,SHE.ExerciseNO,  EM.ResidentialStatus,  MIT.MIT_ID, CIM.INS_DISPLY_NAME, IS_PaymentWindow_Enabled, NUMBEROFDAYS, ExerciseDate, PAYMENT_CLOSURE_MSG
		HAVING      
			CASE WHEN MIN(GL.VestingDate+AT.POSTVESTING_DAYS) BETWEEN  GETDATE() AND DATEADD(day,AT.BEFORE_VESTING_DATE+AT.POSTVESTING_DAYS,GETDATE()) THEN 1 ELSE 0 END >0
		ORDER BY GrantLegId asc ,ExercisePrice desc  
	END
 END      
          
      
/* Update Entity Data*/

	UPDATE PRE SET PRE.ENTITY = MLFV.FIELD_VALUE
	FROM #TEMP_PREVESTING_DATA AS PRE
	INNER JOIN MASTER_LIST_FLD_VALUE MLFV ON MLFV.MLFV_ID=PRE.ENTITY


	SELECT 
		Apply_SAR,TrustType,SchemeType,replace(convert(NVARCHAR, VestingDate, 106), ' ', '-') as VestingDate,GrantRegistrationId,GrantedOptions,ExercisableQuantity,UnapprovedExerciseQuantity,FinalVestingDate,
		FinalExpirayDate, ExercisePrice,replace(convert(NVARCHAR, GrantDate, 106), ' ', '-')as GrantDate,LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor, ExercisedQuantity ,FBTValue,FBTPayable,
		GrantOptionId,GrantLegId,GrantLegSerialNumber,SchemeTitle,OptionTimePercentage,IsPaymentModeRequired,PaymentModeEffectiveDate,IS_ADS_SCHEME,IS_ADS_EX_OPTS_ALLOWED,CurrencySymbol,CurrencyAlias,SchemeId,
		VestingFormulaDate,GrantFormulaDate,show,PaymentMode, ExerciseAmountPayable,TentativeFMVPrice,TentativePerqstValue, TentativePerqstPayable,EPPS_ID,PREVESTING_AUTOEXERCISE,POSTVESTING_AUTOEXERCISE,
		IS_PAYMENT_MODE_SELECTED,EXERCISEID,PaymentModeName,IS_UPLOAD_EXERCISE_FORM,ISNULL(Entity,'') as Entity,ExerciseINRFlag ,GroupNumber,EXERCISE_NUMBER,IsFormGenerate,ISActivedforEntity,CALCULATE_TAX,ISNULL(CALCUALTE_TAX_PRIOR_DAYS,0) AS CALCUALTE_TAX_PRIOR_DAYS, ISNULL(CALCUALTE_TAX_PRIOR_DAYS_SCHEME,0) AS CALCUALTE_TAX_PRIOR_DAYS_SCHEME,
		CASE WHEN IS_UPLOAD_EXERCISE_FORM_ON IS NULL THEN CONVERT(VARCHAR(20),'') 
			ELSE CONVERT(VARCHAR(20),FORMAT(IS_UPLOAD_EXERCISE_FORM_ON, 'dd-MMM-yyyy '+'''at'''+' hh:mm tt', 'en-US')) 
		END AS IS_UPLOAD_EXERCISE_FORM_ON, Note, ResidentialStatus, MIT_ID, INSTRUMENT_NAME,
		ISNULL((SELECT TOP 1 EXERCISE_STEPID FROM TRANSACTIONS_EXERCISE_STEP TES WHERE TES.EXERCISE_NO = #TEMP_PREVESTING_DATA.EXERCISE_NUMBER AND ISNULL(TES.IS_ATTEMPTED,0)=0  ),-1) AS ExerciseStep,
		ISNULL((SELECT TOP 1 DISPLAY_NAME FROM TRANSACTIONS_EXERCISE_STEP TES WHERE TES.EXERCISE_NO = #TEMP_PREVESTING_DATA.EXERCISE_NUMBER AND ISNULL(TES.IS_ATTEMPTED,0)=0  ),'Allotment') AS ExerciseStepName,
		IS_PaymentWindow_Enabled, PAYMENT_CLOSURE_MSG, OnlineTransactionPaid
	FROM
		#TEMP_PREVESTING_DATA
     
 DROP TABLE #TEMP_PREVESTING_DATA    
       
 SET NOCOUNT OFF;    
END
GO
