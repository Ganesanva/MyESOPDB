/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_OPTIONS_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_OPTIONS_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_OPTIONS_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[PROC_GET_EXERCISE_OPTIONS_DETAILS]	
	
	@EMPLOYEEID VARCHAR(50) = NULL,
	@DISPLAYAS CHAR(1) = NULL,
	@DISPLAYSPLIT CHAR(1) = NULL,
	@DYNAMICCONDITION  VARCHAR(MAX)= NULL,
	@MIT_ID VARCHAR(50) = NULL 
	
AS
BEGIN

   	DECLARE @STR_SQL VARCHAR(MAX),@CurrentDate VARCHAR(50),@STR_GROUPBYCONDITION VARCHAR(MAX),
			@ANDCONDITION VARCHAR(MAX),@SELECT_QRY1 VARCHAR (MAX),@WHERE_QRY1 VARCHAR(MAX),@GROUP_QRY1 VARCHAR(MAX)
			,@SELECT_QRY2 VARCHAR (MAX),@WHERE_QRY2 VARCHAR(MAX),@GROUP_QRY2 VARCHAR(MAX)
	
	SET NOCOUNT ON;	
	
     CREATE TABLE #TEMP_ENTITY_DATA
	(
		SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
		EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE,
		ENTITY_ID BIGINT NULL
	)


	 CREATE TABLE #TEMP_FILTER_DATA
	(		
		ENTITY_ID BIGINT NULL,FIELD NVARCHAR(100),MLFN_ID BIGINT
	)

	CREATE TABLE #TEMP_EXERCISE_DATA
 	(
		  Apply_SAR VARCHAR (10)
		, TrustType VARCHAR (50)
		, SchemeType VARCHAR (50)		
		, VestingDate DATETIME
		, GrantRegistrationId VARCHAR (50)
		, GrantedOptions NUMERIC (38, 0)
		, ExercisableQuantity NUMERIC (38, 0)
		, UnapprovedExerciseQuantity NUMERIC (38, 0)
		, FinalVestingDate DATETIME		
		, FinalExpirayDate DATETIME
		, ExercisePrice NUMERIC (18, 2)		
		, GrantDate DATETIME		
		, LockInPeriodStartsFrom VARCHAR (1)
		, LockInPeriod NUMERIC (18, 0)
		, OptionRatioMultiplier NUMERIC (18, 0)		
		, OptionRatioDivisor NUMERIC (18, 0)
		, ExercisedQuantity NUMERIC (38, 0)
		, FBTValue NUMERIC (10, 2)
		, FBTPayable NUMERIC (34, 8)
		, GrantOptionId VARCHAR (100)
		, GrantLegId DECIMAL (10, 0)		
		, SchemeTitle VARCHAR (50)		
		, OptionTimePercentage NUMERIC (5, 2)		
		, IsPaymentModeRequired TINYINT
		, PaymentModeEffectiveDate NVARCHAR (10)		
		, IS_ADS_SCHEME BIT
		, IS_ADS_EX_OPTS_ALLOWED BIT
		, CurrencySymbol VARCHAR(50)
		, CurrencyAlias VARCHAR (50)
		, SchemeId VARCHAR (50)
		, Id VARCHAR (201)
		, CALCULATE_TAX NVARCHAR (200)
		, TempCounter NUMERIC (18, 0) NULL
        , VestingType VARCHAR(50)   NULL    
        , Parent VARCHAR(50)    NULL
        , ExpirayDate DATETIME NULL
        ,Entity_ID BIGINT NULL
        ,ExercisePriceINR NUMERIC (18, 2)NULL
        ,Entity_BasedON BIGINT NULL,
         Entity VARCHAR (50) NULL,
         ROUNDING_UP TINYINT NULL,
         FRACTION_PAID_CASH  TINYINT NULL,
         GROUPNUMBER BIGINT,
         TAXCALCULATION_BASEDON VARCHAR(50) NULL,
		 CALCUALTE_TAX_PRIOR_DAYS INT NULL,
		 CALCUALTE_TAX_PRIOR_DAYS_PREVESTING INT NULL,
         EXCEPT_FOR_TAXRATE_EMPLOYEE VARCHAR(50) NULL,
		 IS_MANDATORY_STATE BIT,
		 SchemeTCNONTCType VARCHAR(100)
	 )
	
	SET @CurrentDate = (SELECT GETDATE())
	IF (@DISPLAYAS = 'S' AND @DISPLAYSPLIT = 'S')
	BEGIN	
    SET @STR_SQL ='select CASE WHEN  GrantRegistration.Apply_SAR IS NULL THEN ''N'' ELSE GrantRegistration.Apply_SAR 
             END AS Apply_SAR, scheme.TrustType,  case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP'')
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeType,  GrantLeg.Id, GrantLeg.Counter, GrantLeg.VestingType, GrantLeg.GrantLegId, GrantLeg.Parent, 
             GrantLeg.VestingDate, GrantLeg.ExpirayDate,GrantLeg.GrantedOptions, 
             GrantLeg.ExercisableQuantity,GrantLeg.UnapprovedExerciseQuantity,GrantLeg.ExercisedQuantity, 
             GrantLeg.FinalVestingDate, GrantLeg.FinalExpirayDate,
             GrantRegistration.ExercisePrice, GrantRegistration.GrantDate, GrantLeg.GrantRegistrationId, Scheme.LockInPeriodStartsFrom, 
             Scheme.LockInPeriod,Scheme.OptionRatioMultiplier,  Scheme.OptionRatioDivisor,Scheme.SchemeTitle, 
             GrantOptions.GrantOptionId,VestingPeriod.OptionTimePercentage as  OptionTimePercentage, 
             isnull(VestingPeriod.FBTValue,0) as FBTValue,round(((FBTValue-ExercisePrice) * (select FBTax from companyparameters)/100),2) as FBTPayable, 
             Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME,
             Scheme.IS_ADS_EX_OPTS_ALLOWED, 
             convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId,Scheme.CALCULATE_TAX 
             ,GrantRegistration.ExercisePriceINR,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, ISNULL(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,IS_MANDATORY_STATE
             ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
			 FROM GrantOptions INNER JOIN VestingPeriod 
             ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid
             INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno
             INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId 
             INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
             LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = '''+@MIT_ID+'''
             LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID 
             INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId 
             LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId 
             AND GMEN.GrantOptionId = GrantLeg.GrantOptionId 
			 LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on Scheme.SchemeId=AEPC.Scheme_Id and AEPC.IS_APPROVE=1 and 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End)
             WHERE EM.LoginId = '''+ @EMPLOYEEID+''' 
             AND CONVERT(DATE,'''+@CurrentDate+''') >= GrantLeg.FinalVestingDate and CONVERT(DATE,'''+@CurrentDate+''')<= GrantLeg.FinalExpirayDate 
             AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
			 AND GrantLeg.ExercisableQuantity >  0 
             AND GrantLeg.Status = ''A'' AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
			 AND Scheme.IsPUPEnabled <> 1 
              AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		   '
           IF(ISNULL(@MIT_ID,'') !='') 
			  BEGIN
				SET @STR_SQL=@STR_SQL+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
	            
			END
            SET @STR_GROUPBYCONDITION = ' ORDER BY Scheme.SchemeId'
           /* Print @STR_SQL*/
 
	END
	ELSE IF(@DISPLAYAS = 'C' AND @DISPLAYSPLIT = 'C')
	BEGIN
	SET @STR_SQL ='select CASE WHEN  GrantRegistration.Apply_SAR IS NULL THEN ''N'' ELSE GrantRegistration.Apply_SAR  
           END AS Apply_SAR, scheme.TrustType,  case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP''  ) 
           then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme''	END as SchemeType, min(GrantLeg.VestingDate) as VestingDate,min(GrantLeg.GrantRegistrationId) as GrantRegistrationId, sum(GrantLeg.GrantedOptions) as GrantedOptions, 
           sum(GrantLeg.ExercisableQuantity) as ExercisableQuantity,sum(GrantLeg.UnapprovedExerciseQuantity) as UnapprovedExerciseQuantity, 
           min(GrantLeg.FinalVestingDate) as FinalVestingDate, max(GrantLeg.FinalExpirayDate) as FinalExpirayDate, 
           max(GrantRegistration.ExercisePrice) as ExercisePrice,max(GrantRegistration.GrantDate) as GrantDate, max(Scheme.LockInPeriodStartsFrom) as LockInPeriodStartsFrom, 
           max(Scheme.LockInPeriod) as LockInPeriod,max(Scheme.OptionRatioMultiplier) as OptionRatioMultiplier, max(Scheme.OptionRatioDivisor) as  OptionRatioDivisor, 
           sum(GrantLeg.ExercisedQuantity) as ExercisedQuantity, 
           isnull(VestingPeriod.FBTValue,0) as FBTValue,round(((FBTValue-max(ExercisePrice)) * (select FBTax from companyparameters)/100),2) as FBTPayable, 
           GrantOptions.GrantOptionId , GrantLeg.GrantLegId,Scheme.SchemeTitle,VestingPeriod.OptionTimePercentage  as  OptionTimePercentage, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED, 
           convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId,
           CASE WHEN (CONVERT(VARCHAR(100), MIN(GrantLeg.ID)) = CONVERT(VARCHAR(100),MAX(GL1.ID) )) THEN CONVERT(VARCHAR(100), MIN(GrantLeg.ID)) ELSE CONVERT(VARCHAR(100), MIN(GrantLeg.ID)) + ''|'' + CONVERT(VARCHAR(100), MAX(GL1.ID))  END AS Id,Scheme.CALCULATE_TAX
           ,MAX(GrantRegistration.ExercisePriceINR) AS ExercisePriceINR ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, ISNULL(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
          ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
		  FROM GrantOptions INNER JOIN VestingPeriod 
           ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid 
           INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno 
           INNER JOIN GrantLeg AS GL1 ON GL1.ID = GrantLeg.ID
           INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId 
           INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
           INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId 
           LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId 
           AND GMEN.GrantOptionId = GrantLeg.GrantOptionId 
           LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = Scheme.MIT_ID 
           LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID 
		   LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on Scheme.SchemeId=AEPC.Scheme_Id  and AEPC.IS_APPROVE=1 and 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End)
           WHERE EM.LoginId = '''+@EMPLOYEEID+''' 
           AND convert(date,'''+@CurrentDate+''')>= GrantLeg.FinalVestingDate and convert(date,'''+@CurrentDate+''') <= GrantLeg.FinalExpirayDate 
           AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity > = 0 
		   AND GrantLeg.ExercisableQuantity >  0
           AND GrantLeg.Status = ''A'' AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
           AND Scheme.IsPUPEnabled <> 1 
		    AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		   '
          IF(ISNULL(@MIT_ID,'') !='') 
          BEGIN
			Print 'MitID'
			SET @STR_SQL=@STR_SQL+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
            
          END
         SET @STR_GROUPBYCONDITION ='GROUP BY  GrantOptions.GrantOptionId,scheme.TrustType, GrantRegistration.Apply_SAR, 
           GrantLeg.GrantLegId, Scheme.SchemeTitle,VestingPeriod.FBTValue,VestingPeriod.OptionTimePercentage, 
          Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED, CONVERT(nvarchar(max), CURRENCYMASTER.CurrencySymbol),CURRENCYMASTER.CurrencyAlias, Scheme.SchemeId,Scheme.CALCULATE_TAX,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH ,GMEN.GroupNumber,TAXCALCULATION_BASEDON , Scheme.CALCUALTE_TAX_PRIOR_DAYS, Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
            ORDER BY Scheme.SchemeTitle, GrantDate,FinalVestingDate, GrantLeg.GrantLegId asc, ExercisePrice desc' 
  		 print @STR_SQL + ' '+ @STR_GROUPBYCONDITION

		 

	END
	ELSE IF(@DISPLAYAS = 'C' AND @DISPLAYSPLIT = 'S')
	BEGIN
	  
     SET @SELECT_QRY1 = 'SELECT CASE WHEN  GrantRegistration.Apply_SAR IS NULL THEN ''N'' ELSE GrantRegistration.Apply_SAR 
           END AS Apply_SAR, scheme.TrustType,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP'')
           THEN  ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme''END as SchemeType,min(GrantLeg.VestingDate) as VestingDate, sum(GrantLeg.GrantedOptions) as GrantedOptions,
           sum(GrantLeg.ExercisableQuantity) as ExercisableQuantity,sum(GrantLeg.UnapprovedExerciseQuantity) as UnapprovedExerciseQuantity,
           min(GrantLeg.FinalVestingDate) as FinalVestingDate, max(GrantLeg.FinalExpirayDate) as FinalExpirayDate,
           max(GrantRegistration.ExercisePrice) as ExercisePrice,max(GrantRegistration.GrantDate) as GrantDate, max(Scheme.LockInPeriodStartsFrom) as LockInPeriodStartsFrom,
           max(Scheme.LockInPeriod) as LockInPeriod,max(Scheme.OptionRatioMultiplier) as OptionRatioMultiplier, max(Scheme.OptionRatioDivisor) as OptionRatioDivisor,
           sum(GrantLeg.ExercisedQuantity) as ExercisedQuantity,
           isnull(VestingPeriod.FBTValue,0) as FBTValue,round(((FBTValue-max(ExercisePrice)) * (select FBTax from companyparameters)/100),2) as FBTPayable,
           GrantOptions.GrantOptionId , GrantLeg.Id,GrantLeg.GrantLegId,GrantLeg.GrantRegistrationId,Scheme.SchemeTitle,''OB'' as Parent,VestingPeriod.OptionTimePercentage  as  OptionTimePercentage, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED,
           convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId,Scheme.CALCULATE_TAX
          ,MAX(GrantRegistration.ExercisePriceINR) AS ExercisePriceINR,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, ISNULL(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING ,EXCEPT_FOR_TAXRATE_EMPLOYEE
           ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
		   FROM GrantOptions INNER JOIN VestingPeriod
           ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid
           INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno
           INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
           INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
           INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
           LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId
           AND GMEN.GrantOptionId = GrantLeg.GrantOptionId 
           LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = '''+@MIT_ID+'''
           LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID
		   LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on Scheme.SchemeId=AEPC.Scheme_Id  and AEPC.IS_APPROVE=1 and 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End)
           WHERE EM.LoginId =  '''+ @EMPLOYEEID+''' 
           AND  convert(date,'''+@CurrentDate+''') >= GrantLeg.FinalVestingDate and  convert(date,'''+@CurrentDate+''') <= GrantLeg.FinalExpirayDate
           AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
           AND GrantLeg.Status = ''A'' AND GrantLeg.Parent in (''N'',''B'') AND GrantLeg.IsOriginal = ''Y'' 
           AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0) 
           AND Scheme.IsPUPEnabled <> 1 
		    AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		   '
           
		   IF(ISNULL(@MIT_ID,'') !='') 
            BEGIN
          
			 SET @SELECT_QRY1=@SELECT_QRY1+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
            
            END
             
           SET @GROUP_QRY1 = 'GROUP BY  GrantOptions.GrantOptionId, GrantLeg.Id,
              GrantLeg.GrantRegistrationId,GrantLeg.GrantLegId,Scheme.SchemeTitle,VestingPeriod.FBTValue,
              VestingPeriod.OptionTimePercentage,GrantRegistration.Apply_SAR, scheme.TrustType, 
              Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, 
              Scheme.IS_ADS_EX_OPTS_ALLOWED, CONVERT(nvarchar(max), CURRENCYMASTER.CurrencySymbol),CURRENCYMASTER.CurrencyAlias, Scheme.SchemeId ,scheme.CALCULATE_TAX,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, Scheme.CALCUALTE_TAX_PRIOR_DAYS, Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
              ORDER BY Scheme.SchemeTitle, GrantDate,FinalVestingDate, GrantLeg.GrantLegId asc, ExercisePrice desc'
         
                  
    SET @SELECT_QRY2 = 'SELECT GrantRegistration.Apply_SAR,scheme.TrustType,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP''  )
           THEN ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeType,min(GrantLeg.VestingDate) as VestingDate, sum(GrantLeg.GrantedOptions) as GrantedOptions,
           sum(GrantLeg.ExercisableQuantity) as ExercisableQuantity,sum(GrantLeg.UnapprovedExerciseQuantity) as UnapprovedExerciseQuantity,
           min(GrantLeg.FinalVestingDate) as FinalVestingDate, max(GrantLeg.FinalExpirayDate) as FinalExpirayDate,
           max(GrantRegistration.ExercisePrice) as ExercisePrice,max(GrantRegistration.GrantDate) as GrantDate, max(Scheme.LockInPeriodStartsFrom) as LockInPeriodStartsFrom,
           max(Scheme.LockInPeriod) as LockInPeriod,max(Scheme.OptionRatioMultiplier) as OptionRatioMultiplier, max(Scheme.OptionRatioDivisor) as OptionRatioDivisor,
           sum(GrantLeg.ExercisedQuantity) as ExercisedQuantity,
           VestingPeriod.FBTValue as FBTValue,round(((FBTValue-max(ExercisePrice)) * (select FBTax from companyparameters)/100),2) as FBTPayable,
           GrantOptions.GrantOptionId , GrantLeg.Id,GrantLeg.GrantLegId,  GrantLeg.GrantRegistrationId,Scheme.SchemeTitle,''SB'' as Parent,VestingPeriod.OptionTimePercentage  as  OptionTimePercentage, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED,
           convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId ,Scheme.CALCULATE_TAX
           ,MAX(GrantRegistration.ExercisePriceINR) AS ExercisePriceINR ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, isnull(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
           ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
		   FROM GrantOptions INNER JOIN VestingPeriod
           ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid
           INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno
           INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
           INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
           INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
           LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId
           AND GMEN.GrantOptionId = GrantLeg.GrantOptionId 
           LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = '''+@MIT_ID+'''
           LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID
		   LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on Scheme.SchemeId=AEPC.Scheme_Id  and AEPC.IS_APPROVE=1  and 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End)
           WHERE EM.LoginId = '''+ @EMPLOYEEID+''' 
           AND  convert(date,'''+@CurrentDate+''') >= GrantLeg.FinalVestingDate and  convert(date,'''+@CurrentDate+''') <= GrantLeg.FinalExpirayDate
           AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
		   AND GrantLeg.ExercisableQuantity >  0
           AND GrantLeg.Status = ''A'' AND GrantLeg.Parent in (''S'',''B'') AND GrantLeg.IsSplit = ''Y'' 
           AND (GrantLeg.ExercisableQuantity > 0  or GrantLeg.UnapprovedExerciseQuantity >0)  AND Scheme.IsPUPEnabled <> 1 
            AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		   '
			IF(ISNULL(@MIT_ID,'') !='') 
            BEGIN
          
			 SET @SELECT_QRY2=@SELECT_QRY2+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
            
            END
           SET @GROUP_QRY2 ='GROUP BY   GrantOptions.GrantOptionId, GrantLeg.Id,GrantLeg.GrantRegistrationId, GrantLeg.GrantLegId,
          Scheme.SchemeTitle,VestingPeriod.FBTValue,VestingPeriod.OptionTimePercentage,GrantRegistration.Apply_SAR, scheme.TrustType, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED, CONVERT(nvarchar(max), CURRENCYMASTER.CurrencySymbol),
          CURRENCYMASTER.CurrencyAlias, Scheme.SchemeId,Scheme.CALCULATE_TAX,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH ,GMEN.GroupNumber,TAXCALCULATION_BASEDON , Scheme.CALCUALTE_TAX_PRIOR_DAYS, Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
          ORDER BY Scheme.SchemeTitle, GrantDate,FinalVestingDate, GrantLeg.GrantLegId asc, ExercisePrice desc' 

	END
	ELSE IF(@DISPLAYAS = 'S' AND @DISPLAYSPLIT = 'C')
	BEGIN
	    
	      SET @SELECT_QRY1 =' SELECT  CASE WHEN  GrantRegistration.Apply_SAR IS NULL THEN ''N'' ELSE GrantRegistration.Apply_SAR 
           END AS Apply_SAR, scheme.TrustType,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP''  )
           THEN ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeType,min(GrantLeg.VestingDate) as VestingDate, sum(GrantLeg.GrantedOptions) as GrantedOptions,
           sum(GrantLeg.ExercisableQuantity) as ExercisableQuantity,sum(GrantLeg.UnapprovedExerciseQuantity) as UnapprovedExerciseQuantity,
           min(GrantLeg.FinalVestingDate) as FinalVestingDate, max(GrantLeg.FinalExpirayDate) as FinalExpirayDate,
           max(GrantRegistration.ExercisePrice) as ExercisePrice,max(GrantRegistration.GrantDate) as GrantDate, max(Scheme.LockInPeriodStartsFrom) as LockInPeriodStartsFrom,
           max(Scheme.LockInPeriod) as LockInPeriod,max(Scheme.OptionRatioMultiplier) as OptionRatioMultiplier, max(Scheme.OptionRatioDivisor) as OptionRatioDivisor,
           sum(GrantLeg.ExercisedQuantity) as ExercisedQuantity,
           isnull(VestingPeriod.FBTValue,0) as FBTValue,round(((FBTValue-max(ExercisePrice)) * (select FBTax from companyparameters)/100),2) as FBTPayable,
           GrantOptions.GrantOptionId , GrantLeg.Id,GrantLeg.GrantLegId,GrantLeg.GrantRegistrationId,Scheme.SchemeTitle,''OS'' as Parent,VestingPeriod.OptionTimePercentage  as  OptionTimePercentage, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED,
           convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId,Scheme.CALCULATE_TAX
          ,MAX(GrantRegistration.ExercisePriceINR) AS ExercisePriceINR ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, ISNULL(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
           ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
		   FROM GrantOptions INNER JOIN VestingPeriod
           ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid
           INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno
           INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
           INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
           INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
           LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId 
           AND GMEN.GrantOptionId = GrantLeg.GrantOptionId 
           LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID ='''+@MIT_ID+'''
           LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID
		   LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on Scheme.SchemeId=AEPC.Scheme_Id and AEPC.IS_APPROVE=1 and 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End)
           WHERE EM.LoginId = '''+ @EMPLOYEEID+''' 
           AND GETDATE() >= GrantLeg.FinalVestingDate and GETDATE() <= GrantLeg.FinalExpirayDate
           AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
		   AND GrantLeg.ExercisableQuantity >  0
           AND GrantLeg.Status = ''A'' AND GrantLeg.Parent in (''N'',''S'') AND GrantLeg.IsOriginal = ''Y'' 
           AND (GrantLeg.ExercisableQuantity >0  or GrantLeg.UnapprovedExerciseQuantity >0)  
           AND Scheme.IsPUPEnabled <> 1 
		   AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		   '
           
			IF(ISNULL(@MIT_ID,'') !='') 
            BEGIN          
			 SET @SELECT_QRY1=@SELECT_QRY1+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
            
            END

            SET @GROUP_QRY1 ='GROUP BY  GrantOptions.GrantOptionId, GrantLeg.Id, GrantLeg.GrantRegistrationId, GrantLeg.GrantLegId,Scheme.SchemeTitle,VestingPeriod.FBTValue,VestingPeriod.OptionTimePercentage
            ,GrantRegistration.Apply_SAR, scheme.TrustType, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED, CONVERT(nvarchar(max), CURRENCYMASTER.CurrencySymbol),CURRENCYMASTER.CurrencyAlias, Scheme.SchemeId ,scheme.CALCULATE_TAX ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON , Scheme.CALCUALTE_TAX_PRIOR_DAYS, Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
             ORDER BY Scheme.SchemeTitle, GrantDate,FinalVestingDate, GrantLeg.GrantLegId asc, ExercisePrice desc' 
         
         
          
           SET @SELECT_QRY2 = ' select GrantRegistration.Apply_SAR,scheme.TrustType,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' or Scheme.trusttype=''CCSA'' or Scheme.trusttype=''CCSP'' or Scheme.trusttype=''CCB'' or Scheme.trusttype=''CCNonTCCSA'' or Scheme.trusttype=''CCNonTCCB'' or Scheme.trusttype=''CCNonTCCSP''  )
           THEN ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeType,min(GrantLeg.VestingDate) as VestingDate, sum(GrantLeg.GrantedOptions) as GrantedOptions,
           sum(GrantLeg.ExercisableQuantity) as ExercisableQuantity,sum(GrantLeg.UnapprovedExerciseQuantity) as UnapprovedExerciseQuantity,
           min(GrantLeg.FinalVestingDate) as FinalVestingDate, max(GrantLeg.FinalExpirayDate) as FinalExpirayDate,
           max(GrantRegistration.ExercisePrice) as ExercisePrice,max(GrantRegistration.GrantDate) as GrantDate, max(Scheme.LockInPeriodStartsFrom) as LockInPeriodStartsFrom,
           max(Scheme.LockInPeriod) as LockInPeriod,max(Scheme.OptionRatioMultiplier) as OptionRatioMultiplier, max(Scheme.OptionRatioDivisor) as OptionRatioDivisor,
           sum(GrantLeg.ExercisedQuantity) as ExercisedQuantity,
           VestingPeriod.FBTValue as FBTValue,round(((FBTValue-max(ExercisePrice)) * (select FBTax from companyparameters)/100),2) as FBTPayable,
           GrantOptions.GrantOptionId , GrantLeg.Id,GrantLeg.GrantLegId,  GrantLeg.GrantRegistrationId,Scheme.SchemeTitle,''BS'' as Parent,VestingPeriod.OptionTimePercentage  as  OptionTimePercentage, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED,
           convert(nvarchar(max), currencymaster.currencysymbol) as CurrencySymbol,currencymaster.CurrencyAlias as CurrencyAlias, Scheme.SchemeId ,Scheme.CALCULATE_TAX
           ,MAX(GrantRegistration.ExercisePriceINR) AS ExercisePriceINR ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, ISNULL(Scheme.CALCUALTE_TAX_PRIOR_DAYS,0), Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
          ,case when (scheme.trusttype=''TC'' or Scheme.trusttype=''TCLSA'' or Scheme.trusttype=''TCLSP'' or Scheme.trusttype=''TCLB'' or Scheme.trusttype=''TCOnly'' or Scheme.trusttype=''TCandCLSA'' or Scheme.trusttype=''TCandCLSP'' or Scheme.trusttype=''TCandCLB'' )
             then ''Trust Scheme'' else ''Non '+'-'+'  Trust Scheme'' END as SchemeTCNONTCType
		  FROM GrantOptions INNER JOIN VestingPeriod
          ON GrantOptions.grantregistrationid=VestingPeriod.grantregistrationid
          INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId=vestingperiod.vestingperiodno
          INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
          INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
          INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
          LEFT OUTER JOIN GrantMappingOnExNow GMEN ON GMEN.GrantRegistrationId = GrantLeg.GrantRegistrationId 
          AND GMEN.GrantOptionId = GrantLeg.GrantOptionId
          LEFT JOIN COMPANY_INSTRUMENT_MAPPING on COMPANY_INSTRUMENT_MAPPING.MIT_ID = '''+@MIT_ID+'''
          LEFT JOIN CURRENCYMASTER on CurrencyMaster.CurrencyID = COMPANY_INSTRUMENT_MAPPING.CurrencyID
          WHERE EM.LoginId = '''+ @EMPLOYEEID+''' 
          AND GETDATE() >= GrantLeg.FinalVestingDate and GETDATE() <= GrantLeg.FinalExpirayDate
          AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
		  AND GrantLeg.ExercisableQuantity >  0
          AND GrantLeg.Status = ''A'' AND GrantLeg.Parent in (''B'',''S'') AND GrantLeg.IsBonus = ''Y'' 
          AND (GrantLeg.ExercisableQuantity > 0  or GrantLeg.UnapprovedExerciseQuantity >0)  AND Scheme.IsPUPEnabled <> 1 
          AND 1<>(Case 
			WHEN ((ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1 AND ISNULL(IS_Applicable_ForModifyQty, 0)=1)) Then 0 
			WHEN (ISNULL(Scheme.IS_AUTO_EXERCISE_ALLOWED,0)=1) THEN Scheme.IS_AUTO_EXERCISE_ALLOWED Else 0  End) 
		  '
		  IF(ISNULL(@MIT_ID,'') !='') 
		  BEGIN
			 SET @SELECT_QRY2=@SELECT_QRY2+' AND Scheme.MIT_ID = '''+@MIT_ID+''' '
          END
 
          SET @GROUP_QRY2 ='GROUP BY GrantOptions.GrantOptionId, GrantLeg.Id,  GrantLeg.GrantRegistrationId,  GrantLeg.GrantLegId, Scheme.SchemeTitle,VestingPeriod.FBTValue,VestingPeriod.OptionTimePercentage,GrantRegistration.Apply_SAR, scheme.TrustType, Scheme.IsPaymentModeRequired, Scheme.PaymentModeEffectiveDate, Scheme.IS_ADS_SCHEME, Scheme.IS_ADS_EX_OPTS_ALLOWED, 
          CONVERT(nvarchar(max), CURRENCYMASTER.CurrencySymbol),CURRENCYMASTER.CurrencyAlias,
          Scheme.SchemeId,Scheme.CALCULATE_TAX ,Scheme.ROUNDING_UP,Scheme.FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON , Scheme.CALCUALTE_TAX_PRIOR_DAYS, Scheme.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE
          ORDER BY Scheme.SchemeTitle, GrantDate,FinalVestingDate, GrantLeg.GrantLegId asc, ExercisePrice desc' 

	END
	--Print (@STR_SQL + @STR_GROUPBYCONDITION)
	IF(@DYNAMICCONDITION IS NULL  OR @DYNAMICCONDITION = '')
	BEGIN		
	IF (@DISPLAYAS = 'S' AND @DISPLAYSPLIT = 'S')
	BEGIN		
			INSERT INTO #TEMP_EXERCISE_DATA
			(Apply_SAR,TrustType,SchemeType	,Id,TempCounter,VestingType,GrantLegId,Parent,VestingDate,
			ExpirayDate,GrantedOptions,ExercisableQuantity,UnapprovedExerciseQuantity,
			ExercisedQuantity,FinalVestingDate,FinalExpirayDate,ExercisePrice,GrantDate,GrantRegistrationId,
			LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,
			SchemeTitle,GrantOptionId,OptionTimePercentage,FBTValue	,FBTPayable	,IsPaymentModeRequired,PaymentModeEffectiveDate	
		   ,IS_ADS_SCHEME,IS_ADS_EX_OPTS_ALLOWED,CurrencySymbol,CurrencyAlias,SchemeId,CALCULATE_TAX,ExercisePriceINR,ROUNDING_UP,FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON, CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)
			Exec( @STR_SQL + @STR_GROUPBYCONDITION);
	END
	ELSE IF (@DISPLAYAS = 'C' AND @DISPLAYSPLIT = 'C')
	BEGIN		
             INSERT INTO #TEMP_EXERCISE_DATA(Apply_SAR,TrustType	,SchemeType	,VestingDate,GrantRegistrationId,GrantedOptions,ExercisableQuantity	
			,UnapprovedExerciseQuantity,FinalVestingDate,FinalExpirayDate,	ExercisePrice,GrantDate,LockInPeriodStartsFrom,
			LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,ExercisedQuantity,FBTValue	,FBTPayable	,GrantOptionId	
			,GrantLegId	,SchemeTitle,OptionTimePercentage,IsPaymentModeRequired	,PaymentModeEffectiveDate,IS_ADS_SCHEME	
			,IS_ADS_EX_OPTS_ALLOWED	,CurrencySymbol,CurrencyAlias,SchemeId,Id,CALCULATE_TAX,ExercisePriceINR,ROUNDING_UP,FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON,  CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)
			Exec(@STR_SQL + @STR_GROUPBYCONDITION);

		END
		ELSE 
		BEGIN       
			INSERT INTO #TEMP_EXERCISE_DATA
			(Apply_SAR,TrustType,SchemeType,VestingDate,
			GrantedOptions,ExercisableQuantity,UnapprovedExerciseQuantity,FinalVestingDate,FinalExpirayDate,
			ExercisePrice,GrantDate,LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,ExercisedQuantity,FBTValue	
			,FBTPayable	,GrantOptionId,Id,GrantLegId,GrantRegistrationId,SchemeTitle,Parent,OptionTimePercentage,IsPaymentModeRequired	
			,PaymentModeEffectiveDate,IS_ADS_SCHEME	,IS_ADS_EX_OPTS_ALLOWED	,CurrencySymbol,CurrencyAlias,SchemeId,CALCULATE_TAX,ExercisePriceINR,ROUNDING_UP,FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON,  CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)
			EXEC(@SELECT_QRY1 +' '+ @GROUP_QRY1 +' '+ 'UNION ALL' +' '+ @SELECT_QRY2 +' '+ @GROUP_QRY2 )
		END
	END
	ELSE	
	IF (@DISPLAYAS = 'S' AND @DISPLAYSPLIT = 'S')
		BEGIN
			INSERT INTO #TEMP_EXERCISE_DATA
			(Apply_SAR,TrustType,SchemeType	,Id,TempCounter,VestingType,GrantLegId,Parent,VestingDate,
			ExpirayDate,GrantedOptions,ExercisableQuantity,UnapprovedExerciseQuantity,
			ExercisedQuantity,FinalVestingDate,FinalExpirayDate,ExercisePrice,GrantDate,GrantRegistrationId,
			LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,
			SchemeTitle,GrantOptionId,OptionTimePercentage,FBTValue	,FBTPayable	,IsPaymentModeRequired,PaymentModeEffectiveDate	
			,IS_ADS_SCHEME	,IS_ADS_EX_OPTS_ALLOWED	,CurrencySymbol,CurrencyAlias,SchemeId,CALCULATE_TAX,ExercisePriceINR,ROUNDING_UP,FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON,  CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)
			Exec(@STR_SQL + @DYNAMICCONDITION +@STR_GROUPBYCONDITION);
		END
		ELSE IF (@DISPLAYAS = 'C' AND @DISPLAYSPLIT = 'C')
		BEGIN
			INSERT INTO #TEMP_EXERCISE_DATA(Apply_SAR,TrustType	,SchemeType	,VestingDate,GrantRegistrationId,GrantedOptions,ExercisableQuantity	
			,UnapprovedExerciseQuantity,FinalVestingDate,FinalExpirayDate,	ExercisePrice,GrantDate,LockInPeriodStartsFrom,
			LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,ExercisedQuantity,FBTValue	,FBTPayable	,GrantOptionId	
			,GrantLegId	,SchemeTitle,OptionTimePercentage,IsPaymentModeRequired	,PaymentModeEffectiveDate,IS_ADS_SCHEME	
			,IS_ADS_EX_OPTS_ALLOWED	,CurrencySymbol,CurrencyAlias,SchemeId,Id,CALCULATE_TAX,ExercisePriceINR,ROUNDING_UP,FRACTION_PAID_CASH,GMEN.GroupNumber,TAXCALCULATION_BASEDON,  CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)
			
			Exec(@STR_SQL + @DYNAMICCONDITION +@STR_GROUPBYCONDITION);

		END
		ELSE 
		BEGIN
		
			INSERT INTO #TEMP_EXERCISE_DATA
			(Apply_SAR,TrustType,SchemeType,VestingDate,
			GrantedOptions,ExercisableQuantity	,UnapprovedExerciseQuantity,FinalVestingDate,FinalExpirayDate,
			ExercisePrice,GrantDate,LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,ExercisedQuantity,FBTValue	
			,FBTPayable	,GrantOptionId,Id,GrantLegId,GrantRegistrationId,SchemeTitle,Parent,OptionTimePercentage,IsPaymentModeRequired	
			,PaymentModeEffectiveDate,IS_ADS_SCHEME	,IS_ADS_EX_OPTS_ALLOWED	,CurrencySymbol,CurrencyAlias,SchemeId,CALCULATE_TAX,ExercisePriceINR,GroupNumber,TAXCALCULATION_BASEDON,  CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,EXCEPT_FOR_TAXRATE_EMPLOYEE,SchemeTCNONTCType)		
		
			EXEC(@SELECT_QRY1 + @DYNAMICCONDITION +@GROUP_QRY1 + 'UNION ALL' + @SELECT_QRY2 +@DYNAMICCONDITION+ @GROUP_QRY2  )
		END			
		
		-- INSERT ENTITY DATA --		
	INSERT INTO #TEMP_ENTITY_DATA
	(
		SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON 
	)	
	EXEC PROC_EMP_MOVEMENT_TRANSFER 'Entity',@EMPLOYEEID
	
	INSERT INTO #TEMP_FILTER_DATA(ENTITY_ID,FIELD,MLFN_ID)
	SELECT MLFL.MLFV_ID ,MLFL.FIELD_VALUE ,MLFL.MLFN_ID
    FROM MASTER_LIST_FLD_NAME AS MLFN
    INNER JOIN   MASTER_LIST_FLD_VALUE AS MLFL
    ON MLFN.MLFN_ID = MLFL.MLFN_ID
    WHERE MLFN.FIELD_NAME = 'Entity' 
   
    
   
	 DECLARE @ENTITY_BASEDON  BIGINT	, @ISACTIVEDFORENTITY  BIGINT
     SELECT @ISACTIVEDFORENTITY = ISNULL(ISActivedforEntity,'0') , @ENTITY_BASEDON = ISNULL(EntityBaseOn,'0') FROM COMPANY_INSTRUMENT_MAPPING  WHERE MIT_ID =  @MIT_ID
	 
	 

	IF(@ISACTIVEDFORENTITY = 1 AND @ENTITY_BASEDON IS NOT NULL )
	BEGIN

	    --FOR VESTING DATE --
	     IF((@ENTITY_BASEDON)  = 1001) 
	     BEGIN
	        UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = @ENTITY_BASEDON,ED.Entity = TFD.FIELD
			FROM  #TEMP_EXERCISE_DATA AS ED
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON (CONVERT(DATE,ED.VestingDate)) >= CONVERT(DATE,TED.FROMDATE)
				  AND (CONVERT(DATE,ED.VestingDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE())))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
			WHERE TED.EMPLOYEEID=@EMPLOYEEID
	     END
	      --FOR EXERCISE DATE --
	     ELSE IF((@ENTITY_BASEDON)  = 1002)
	     BEGIN
	        UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = @ENTITY_BASEDON,ED.Entity = TFD.FIELD
			FROM  #TEMP_EXERCISE_DATA AS ED
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON (CONVERT(DATE,@CurrentDate)) >= CONVERT(DATE,TED.FROMDATE)
				  AND (CONVERT(DATE,@CurrentDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE())))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
			WHERE TED.EMPLOYEEID=@EMPLOYEEID
	     END
	       --FOR GRANT DATE --
	     ELSE IF(@ENTITY_BASEDON  = 1003)
	     BEGIN
			UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = @ENTITY_BASEDON,ED.Entity = TFD.FIELD
			FROM  #TEMP_EXERCISE_DATA AS ED
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON (CONVERT(DATE,ED.GRANTDATE)) >= CONVERT(DATE,TED.FROMDATE)
				  AND (CONVERT(DATE,ED.GRANTDATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE())))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
			WHERE TED.EMPLOYEEID=@EMPLOYEEID
	     END		
			   
		
	END
    SELECT * FROM #TEMP_EXERCISE_DATA    	

    DROP TABLE #TEMP_ENTITY_DATA
    DROP TABLE #TEMP_EXERCISE_DATA
    DROP TABLE #TEMP_FILTER_DATA
	SET NOCOUNT OFF;		
END
GO
