/****** Object:  StoredProcedure [dbo].[PROC_SAVE_AUTOEXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_AUTOEXERCISED_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_AUTOEXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SAVE_AUTOEXERCISED_DETAILS] 
(  
 @TrustCompanyName VARCHAR(20) = NULL,  
 @AttachmentPath VARCHAR(500) = NULL  
)  
AS  
BEGIN   
  
 SET NOCOUNT ON;  
  
 DECLARE  
  @CompanyID VARCHAR(20), @IsPaymentModeRequired TINYINT, @PaymentModeEffectiveDate DATE, @FaceVaue NUMERIC(18, 2),   
  @SARFMV NUMERIC(18, 2), @IsSingleModeEnabled BIT, @Payment_Mode CHAR(1), @CalculateDays VARCHAR(20), @DaysOut VARCHAR(20),   
  @FBTemployeetravelledYN VARCHAR(20), @FBTPayBy VARCHAR(20), @RoundupPlace_TaxableVal VARCHAR(5),   
  @RoundingParam_TaxableVal VARCHAR(5), @RoundingParam_FMV VARCHAR(5), @RoundupPlace_FMV VARCHAR(5), @ExerciseId NUMERIC(18,0),  
  @TRANSACTION_SUCCESSFUL INT = 0  
    
 SELECT @CompanyID = CompanyID FROM CompanyParameters  
   
 BEGIN /* CREATE TEMP TABLE */  
   
  CREATE TABLE #TEMP_AUTO_EXERCISED_DETAILS  
  (     
   ExerciseId INT IDENTITY (1, 1) NOT NULL, ROW_ID BIGINT, ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100),   
   GrantRegistrationId NVARCHAR(100), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(10), [Counter] NVARCHAR(10), VestingType NVARCHAR(2),   
   GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), Parent NVARCHAR(2),   
   FinalVestingDate DATETIME, FinalExpirayDate DATETIME, ExercisePrice NUMERIC(18,6), GrantDate DATETIME, LockInPeriodStartsFrom NVARCHAR(2),   
   LockInPeriod NUMERIC(18,0), OptionRatioMultiplier NUMERIC(18,2), OptionRatioDivisor NUMERIC(18,2), SchemeTitle NVARCHAR(100),   
   IsPaymentModeRequired NVARCHAR(2), PaymentModeEffectiveDate DATETIME, MIT_ID BIGINT, OptionTimePercentage NUMERIC(18,2),   
   EmployeeId NVARCHAR(100), LoginID NVARCHAR(100), ResidentialStatus NVARCHAR(2), TAX_IDENTIFIER_COUNTRY NVARCHAR(10),   
   A_GrantedQuantity NUMERIC(18,0), A_SplitQuantity NUMERIC(18,0), A_BonusSplitQuantity NUMERIC(18,0),   
   A_ExercisedQuantity NUMERIC(18,0), A_SplitExercisedQuantity NUMERIC(18,0), A_BonusSplitExercisedQuantity NUMERIC(18,0),   
   A_CancelledQuantity NUMERIC(18,0), A_SplitCancelledQuantity NUMERIC(18,0), A_BonusSplitCancelledQuantity NUMERIC(18,0),   
   A_UnapprovedExerciseQuantity NUMERIC(18,0), T_LapsedQuantity NUMERIC(18,0), A_ExercisableQuantity NUMERIC(18,0),   
   EXERCISABLE_QUANTITY NUMERIC(18,0),  
   AEC_ID BIGINT, EXERCISE_ON NVARCHAR(200), EXERCISE_AFTER_DAYS BIGINT, IS_EXCEPTION_ENABLED TINYINT, EXECPTION_FOR NVARCHAR(200),   
   EXECPTION_LIST NVARCHAR(MAX), CALCULATE_TAX NVARCHAR(200), CALCUALTE_TAX_PRIOR_DAYS BIGINT, IS_MAIL_ENABLE TINYINT,   
   MAIL_BEFORE_DAYS BIGINT, MAIL_REMINDER_DAYS BIGINT,   
   FMVPrice NUMERIC(18,6), PerqstValue NUMERIC(18,6), PerqstPayable NUMERIC(18,6), Perq_Tax_rate numeric(18,6),   
   TentativeFMVPrice NUMERIC(18,6), TentativePerqstValue NUMERIC(18,6), TentativePerqstPayable NUMERIC(18,6),   
   TaxFlag CHAR(1), FaceVaue NUMERIC(18, 2), SARFMV NUMERIC(18, 2), ExType VARCHAR(10), Cash VARCHAR(10), PaymentMode VARCHAR,  
   PerPayModeSelected NVARCHAR(5), EXERCISE_DATE DATETIME,  
   StockApprValue NUMERIC(18,6), TentativeStockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6),   
   TentativeCashPayoutValue NUMERIC(18,6), SettlmentPrice NUMERIC(18,6), TentativeSettlmentPrice NUMERIC(18,6) ,  
   ShareAppriciation NUMERIC(18,6), TentativeShareAppriciation NUMERIC(18,6),ExerciseAmountPayble NUMERIC(18,6), TentativeExerciseAmountPayble NUMERIC(18,6)  
   ,Old_ShareAriseApprValue  NUMERIC(18,6), Entity NVARCHAR(100), Entity_BasedON BIGINT , Entity_ID BIGINT,EntityBaseON_Date NVARCHAR(50),
   EntityConfigurationBaseOn BIGINT, IsActiveEntity int   
  
  )  
  
  CREATE TABLE #TEMP_AUTOEXERCISED_DETAILS_MAIL  
  (  
   Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL,   
   EmployeeName VARCHAR(200), EmployeeEmail VARCHAR(200), ExerciseID VARCHAR(5000), ExercisedQuantity VARCHAR(5000),   
   ExerciseDate VARCHAR(5000), SchemeName VARCHAR(50), EmployeeID VARCHAR(20)  
  )  
    
  CREATE TABLE #New_Message_To  
  (  
   Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, EmployeeID NVARCHAR(20), MessageDate DATE,  
   MailSubject NVARCHAR(250), MailBody NVARCHAR(MAX)       
  )  
  
  CREATE TABLE #New_Message_From  
  (  
   Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, EmployeeID NVARCHAR(20), MessageDate DATE,   
   MailSubject NVARCHAR(250), MailBody NVARCHAR(MAX)       
  )  
        CREATE TABLE #STOCK_APPRECIATION_DETAILS_TEMP_1  
    (  
  ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,9),OPTION_VESTED NUMERIC(18,9),  
  EXERCISE_DATE DATETIME,STOCK_APPRECIATION_VALUE NUMERIC(18,9) NULL,EVENTOFINCIDENCE INT,OPTION_EXERCISED NUMERIC(18,9),GRANTOPTIONID VARCHAR(50) NULL,  
  GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NULL, TAXFLAG CHAR(1),TAXFLAG_HEADER CHAR(1) NULL   
    )  
  
 END  
   
 SELECT   
  @ExerciseId = (ISNULL(CONVERT(VARCHAR, LAST_VALUE),0) + 1)   
 FROM   
  SYS.IDENTITY_COLUMNS   
  INNER JOIN SYS.tables ON SYS.tables.OBJECT_ID = SYS.IDENTITY_COLUMNS.object_id   
 WHERE   
  UPPER(SYS.tables.NAME) = 'SHEXERCISEDOPTIONS' AND UPPER(SYS.IDENTITY_COLUMNS.NAME) = 'EXERCISEID'  
       
 IF (@ExerciseId IS NOT NULL)  
 BEGIN   
  DBCC CHECKIDENT(#TEMP_AUTO_EXERCISED_DETAILS, RESEED, @ExerciseId)   
 END  
    
 INSERT INTO #TEMP_AUTO_EXERCISED_DETAILS   
 (   
  ROW_ID, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId,   
  [Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent,   
  FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom,   
  LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired,   
  PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,  
  ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity,   
  A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity,   
  A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity,   
  A_ExercisableQuantity, EXERCISABLE_QUANTITY,  
  AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST,   
  CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, EXERCISE_DATE    
 )  
 EXEC PROC_GET_AUTOEXERCISED_DETAILS      
  
 BEGIN /* ===== CASH ===== */  
   
  UPDATE #TEMP_AUTO_EXERCISED_DETAILS   
   SET Cash =          
      CASE WHEN ExType != '' THEN   
       CASE ExType   
        WHEN 'PUP' THEN 'PUP'  
        WHEN 'ADS' THEN 'ADS'      
        ELSE 'CASH'   
      END  
      ELSE 'CASH'    
    END     
    END      
      
    BEGIN /* ===== FACE VALUE  ===== */  
  
  SELECT @FaceVaue = MAX(CP.FaceVaue) FROM CompanyParameters CP  
  
  UPDATE #TEMP_AUTO_EXERCISED_DETAILS SET FaceVaue = @FaceVaue  
 END  
   
 BEGIN /* ===== DEFAULT PAYMENT MODE ===== */   
   
  /* PAYMENT MODE SELECTED BY EMPLOYEE */  
  UPDATE TAED_EMP_PAY_UPDATE   
   SET TAED_EMP_PAY_UPDATE.PaymentMode = PM.PaymentMode, TAED_EMP_PAY_UPDATE.PerPayModeSelected = 'EMP'  
  FROM #TEMP_AUTO_EXERCISED_DETAILS AS TAED_EMP_PAY_UPDATE  
   INNER JOIN EmpPrePaySelection AS EPPS ON EPPS.GrantLegSerialNumber = TAED_EMP_PAY_UPDATE.ID  
   INNER JOIN PaymentMaster AS PM ON PM.Id = EPPS.PaymentMode  
   INNER JOIN Scheme AS SC ON SC.SchemeId = TAED_EMP_PAY_UPDATE.SchemeId  
   INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = TAED_EMP_PAY_UPDATE.SchemeId  
  WHERE  
   (SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1)  
    
  /* PAYMENT MODE IF EMPLOYEE NOT SELECTED BY EMPLOYEE THEN SELECT PAYMENT MODE SET BY CR*/  
    
  UPDATE TAED_CR_PAY_UPDATE   
   SET TAED_CR_PAY_UPDATE.PaymentMode = PM.PaymentMode, TAED_CR_PAY_UPDATE.PerPayModeSelected = 'CR'  
  FROM #TEMP_AUTO_EXERCISED_DETAILS AS TAED_CR_PAY_UPDATE  
   INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = TAED_CR_PAY_UPDATE.SchemeId  
   INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID  
   INNER JOIN Scheme AS SC ON SC.SchemeId = AEC.SchemeId  
   INNER JOIN PaymentMaster AS PM ON PM.Id = AEPC.DEFAULT_PAYMENT_MODE     
  WHERE  
   (SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND  
   (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) =  'RDODEFAULTPAYMENTMODE') AND   
   (LEN(ISNULL(TAED_CR_PAY_UPDATE.PaymentMode, '')) = 0)    
 END      
      
 BEGIN /* ===== CALCULATE FMV ===== */  
   
  SELECT   
   @RoundupPlace_TaxableVal = RoundupPlace_TaxableVal, @RoundingParam_TaxableVal = RoundingParam_TaxableVal,   
   @RoundingParam_FMV = RoundingParam_FMV, @RoundupPlace_FMV = RoundupPlace_FMV   
  FROM   
   CompanyParameters  
  
  DECLARE @FMV_VALUE_TYPE dbo.TYPE_FMV_VALUE  
    
  INSERT INTO @FMV_VALUE_TYPE   
  SELECT   
   MIT_ID , LoginID, GrantOptionId , GrantDate, FinalVestingDate, EXERCISE_DATE ,'T'  
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS  
    
  EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @FMV_VALUE_TYPE        
     
  UPDATE TAED SET   
     TAED.FMVPrice = CASE TFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,  
     TAED.TentativeFMVPrice = CASE TFD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,         
     TAED.TaxFlag = TFD.TAXFLAG  
  FROM #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
  INNER JOIN TEMP_FMV_DETAILS TFD ON TFD.INSTRUMENT_ID = TAED.MIT_ID  
  WHERE  
   (TFD.EMPLOYEE_ID = TAED.EmployeeId) AND (TFD.GRANTOPTIONID = TAED.GrantOptionId)   
   AND (CONVERT(DATE, TFD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND (CONVERT(DATE, TFD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate))   
   AND (CONVERT(DATE, TFD.EXERCISE_DATE) =  CONVERT(DATE, TAED.EXERCISE_DATE))    
        
 END    
     
 BEGIN /* ===== CALCULATE PERQUISITE VALUE ===== */  
      
        CREATE TABLE #TEMP_FMV_DETAILS  
  (    
   ID INT NOT NULL, INSTRUMENT_ID BIGINT, EMPLOYEE_ID  VARCHAR(50), GRANTOPTIONID VARCHAR(50), GRANTDATE VARCHAR(200),  
   VESTINGDATE VARCHAR(200), EXERCISE_DATE DATETIME,FMV_VALUE DECIMAL(18,4) NULL,TAXFLAG CHAR(1) NULL,TAXFLAG_HEADER CHAR(1) NULL  
  )  
    
     INSERT INTO #TEMP_FMV_DETAILS (ID ,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG )  
     SELECT ID,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG   FROM TEMP_FMV_DETAILS  
  
  DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE  
    
  INSERT INTO @PERQ_VALUE_TYPE   
  SELECT   
   MIT_ID, LoginID, ExercisePrice, EXERCISABLE_QUANTITY, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END,   
   EXERCISABLE_QUANTITY, A_GrantedQuantity , EXERCISE_DATE, GrantOptionId, GrantDate, FinalVestingDate, ID, NULL, NULL, ExerciseId    
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS  
      
  EXEC PROC_GET_PERQUISITE_VALUE @EMPLOYEE_DETAILS = @PERQ_VALUE_TYPE   
    
  UPDATE TAED SET   
   TAED.PerqstValue = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
   TAED.PerqstPayable = CASE TAED.TAXFLAG WHEN 'A' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18,6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.FinalVestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END,  
   TAED.TentativePerqstValue = CASE TAED.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
   TAED.TentativePerqstPayable = CASE TAED.TAXFLAG WHEN 'T' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18,6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.FinalVestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END  
       
       
      --,TAED.ShareAppriciation = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
           -- , TAED.TentativeShareAppriciation = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
              
              
             ,TAED.ExerciseAmountPayble = CASE TAED.TAXFLAG WHEN 'A' THEN EXERCISE_AMOUNT_PAYABLE ELSE NULL END,  
             TAED.TentativeExerciseAmountPayble = CASE TAED.TAXFLAG WHEN 'A' THEN EXERCISE_AMOUNT_PAYABLE ELSE NULL END,  
  
        --,TAED.ShareAppriciation = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
  
             TAED.ShareAppriciation =   
              CASE TAED.TAXFLAG WHEN 'A' THEN              
               CASE  
     WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN  ISNULL(CEILING( dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)          
     WHEN (SH.ROUNDING_UP = 1) THEN ISNULL(CEILING( dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)                 
        WHEN SH.ROUNDING_UP = 0  THEN ISNULL(FLOOR(  dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)         
     ELSE ISNULL(TPD.SHARE_APPRECIATION_VALUE,0) END  
     ELSE NULL END ,  
               
             TAED.TentativeShareAppriciation =  CASE TAED.TAXFLAG WHEN 'T' THEN              
               CASE  
     WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN  ISNULL(CEILING( dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)          
     WHEN (SH.ROUNDING_UP = 1) THEN ISNULL(CEILING( dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)                 
        WHEN SH.ROUNDING_UP = 0  THEN ISNULL(FLOOR(  dbo.FN_ROUND_VALUE(TPD.SHARE_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)),0)         
     ELSE ISNULL(TPD.SHARE_APPRECIATION_VALUE,0) END  
     ELSE NULL END ,  
               
               
              TAED.Old_ShareAriseApprValue = dbo.[FN_GET_DECIMAL_SETTING_SHARE_VALUE]( TPD.SHARE_APPRECIATION_VALUE)  
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
  INNER JOIN TEMP_PERQUISITE_DETAILS TPD ON TPD.INSTRUMENT_ID = TAED.MIT_ID   
  INNER JOIN  Scheme as SH on SH.SchemeId = TAED.SchemeId  
  WHERE   
   (TPD.EMPLOYEE_ID = TAED.EmployeeId) AND (TPD.EXERCISE_PRICE = TAED.ExercisePrice) AND   
   (TPD.OPTION_VESTED = TAED.EXERCISABLE_QUANTITY) AND (TPD.OPTION_EXERCISED = TAED.EXERCISABLE_QUANTITY) AND   
   (TPD.GRANTED_OPTIONS = TAED.A_GrantedQuantity) AND (CONVERT(DATE, TPD.EXERCISE_DATE) = CONVERT(DATE, TAED.EXERCISE_DATE)) AND   
   (TPD.GRANTOPTIONID = TAED.GrantOptionId) AND (CONVERT(DATE, TPD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND   
   CONVERT(DATE, TPD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate)  
  
  /* ADD DATA TO TYPE */  
  DECLARE @PERQ_VALUE_RESULT dbo.TYPE_PERQ_FORAUTOEXERCISE  
    
  INSERT INTO @PERQ_VALUE_RESULT  
  SELECT   
   INSTRUMENT_ID, EMPLOYEE_ID, FMV_VALUE, PERQ_VALUE, EVENTOFINCIDENCE, GRANTDATE, VESTINGDATE,   
   EXERCISE_DATE, GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID,STOCK_VALUE         
  FROM   
   TEMP_PERQUISITE_DETAILS  
    
  IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')  
  BEGIN  
   DROP TABLE TEMP_PERQUISITE_DETAILS    
  END  
   
 END  
   
 BEGIN /* ===== CALCULATE PROPORTIONATE TAX ===== */  
      
  CREATE TABLE #TAX_CALCULATION   
  (   
   TAX_HEADING NVARCHAR(50), TAX_RATE FLOAT, RESIDENT_STATUS NVARCHAR(250), TAX_AMOUNT FLOAT, Country NVARCHAR(250),  
   [STATE] NVARCHAR(250), BASISOFTAXATION NVARCHAR(250), FMV NVARCHAR(250), TOTAL_PERK_VALUE FLOAT, COUNTRY_ID INT,   
   MIT_ID INT, EmployeeID VARCHAR(50), GRANTOPTIONID VARCHAR(50), VESTING_DATE DATETIME,  
   GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TAX_FLAG NCHAR(1), EXERCISE_ID BIGINT  
  )  
    
  DECLARE @PERQ_VALUE_TYPE_AUTO_EXE dbo.TYPE_PERQ_VALUE_AUTO_EXE  
    
  INSERT INTO @PERQ_VALUE_TYPE_AUTO_EXE   
  SELECT   
   MIT_ID, LoginID, ExercisePrice, EXERCISABLE_QUANTITY, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END,   
   EXERCISABLE_QUANTITY, A_GrantedQuantity, EXERCISE_DATE, GrantOptionId, GrantDate, FinalVestingDate, ID, NULL, NULL, ExerciseId  
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS  
    
  EXEC PROC_GET_TAXFORAUTOEXERCISE @PERQ_DETAILS = @PERQ_VALUE_TYPE_AUTO_EXE, @PERQ_RESULT = @PERQ_VALUE_RESULT, @ISTEMPLATE = 1  
    
  INSERT INTO #TAX_CALCULATION  
  (  
   TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID,   
   MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, EXERCISE_ID   
  )  
  SELECT   
   TGTD.TAX_HEADING, TGTD.TAX_RATE, TGTD.RESIDENT_STATUS, TGTD.TAX_AMOUNT, TGTD.Country, TGTD.[STATE],   
   TGTD.BASISOFTAXATION, TGTD.FMV, TGTD.TOTAL_PERK_VALUE, TGTD.COUNTRY_ID, TGTD.MIT_ID, TGTD.EmployeeID, TGTD.GRANTOPTIONID,   
   TGTD.VESTING_DATE, TGTD.GRANTLEGSERIALNO, TGTD.FROM_DATE, TGTD.TO_DATE, TGTD.TEMP_EXERCISEID    
  FROM   
   TEMP_GET_TAXDETAILS AS TGTD       
    
  /* UPDATE TAX FLAG */  
  UPDATE   
   TC SET TC.TAX_FLAG = TFD.TAXFLAG  
  FROM #TAX_CALCULATION AS TC  
   INNER JOIN #TEMP_FMV_DETAILS AS TFD ON TC.MIT_ID = TFD.INSTRUMENT_ID  
  WHERE  
   TC.EmployeeID = TFD.EMPLOYEE_ID AND TC.GRANTOPTIONID = TFD.GRANTOPTIONID AND CONVERT(DATE,TC.VESTING_DATE) =  CONVERT(DATE,TFD.VESTINGDATE)  
    
  SELECT  
   TAX_HEADING, TAX_RATE, RESIDENT_STATUS , TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID ,   
   MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID  
  FROM   
   #TAX_CALCULATION  
      
  IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_FMV_DETAILS')  
  BEGIN  
   DROP TABLE TEMP_FMV_DETAILS  
  END  
 END     
     
 BEGIN /* ===== UPDATE PERQ PAYABLE IN SH EXERCISE FOR AUTO EXERCISE ===== */  
     
  CREATE TABLE #TEMP_TAX_PAYBLE   
  (   
   EXERCISE_ID BIGINT, TAX_FLAG NCHAR(1), Perq_Tax_rate NUMERIC(18,6),   
   PerqstPayable NUMERIC(18,6), TentativePerqstPayable NUMERIC(18,6)  
  )  
    
  INSERT INTO #TEMP_TAX_PAYBLE  
  (  
   EXERCISE_ID, TAX_FLAG, Perq_Tax_rate, PerqstPayable, TentativePerqstPayable  
  )  
  SELECT  
   EXERCISE_ID, TAX_FLAG, SUM(TAX_RATE),  
   CASE WHEN TAX_FLAG = 'A' THEN SUM(TAX_AMOUNT) ELSE NULL END AS PaybleTax,  
   CASE WHEN TAX_FLAG ='T' THEN SUM(TAX_AMOUNT) ELSE NULL END AS TentativePaybleTax        
  FROM   
   #TAX_CALCULATION   
  GROUP BY EXERCISE_ID, TAX_FLAG  
            
  UPDATE TAED SET   
   TAED.Perq_Tax_rate = (SELECT dbo.FN_PQ_TAX_ROUNDING(TTP.Perq_Tax_rate)),   
   TAED.TentativePerqstPayable = TTP.TentativePerqstPayable,   
   TAED.PerqstPayable = TTP.PerqstPayable  
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED   
  INNER JOIN #TEMP_TAX_PAYBLE TTP ON TAED.ExerciseId = TTP.EXERCISE_ID       
 END       
   
 BEGIN /* ===== SAR CALCULATION ===== */  
   
  DECLARE @SAR_SETTLEMENT_PRICE dbo.TYPE_SAR_SETTLEMENT_PRICE   
    
  INSERT INTO @SAR_SETTLEMENT_PRICE   
  SELECT   
   TAED.MIT_ID, TAED.EmployeeId, TAED.GrantDate, TAED.FinalVestingDate, TAED.EXERCISE_DATE, TAED.ExercisePrice,   
   TAED.SchemeId, TAED.GrantOptionId  
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID  
  WHERE   
   (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)  
    
  EXEC PROC_GET_SAR_SETTELEMENT_PRICCE @EMPLOYEE_SAR_DETAILS = @SAR_SETTLEMENT_PRICE  
    
  /* UPDATE SAR SETTLEMENT PRICES */  
  UPDATE TAED SET   
   TAED.SettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
   TAED.TentativeSettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END     
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
   INNER JOIN TEMP_SAR_SETTLEMENT_FINAL_DETAILS AS TSSFD ON TSSFD.INSTRUMENT_ID = TAED.MIT_ID   
  WHERE   
   (TSSFD.EMPLOYEE_ID = TAED.EmployeeId) AND (CONVERT(DATE, TSSFD.EXERCISE_DATE) = CONVERT(DATE, TAED.EXERCISE_DATE)) AND   
   (TSSFD.GRANTOPTIONID = TAED.GrantOptionId) AND (CONVERT(DATE, TSSFD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND   
   (CONVERT(DATE, TSSFD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate))   
    
  DECLARE @SAR_STOCK_APPRECIATION dbo.TYPE_SAR_STOCK_APPRECIATION   
    
  INSERT INTO @SAR_STOCK_APPRECIATION   
  SELECT   
   TAED.MIT_ID, TAED.EmployeeId, TAED.ExercisePrice, TAED.A_ExercisableQuantity, TAED.EXERCISABLE_QUANTITY,   
   TAED.EXERCISE_DATE, TAED.GrantOptionId, TAED.GrantDate, TAED.FinalVestingDate ,TAED.ExerciseId 
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID  
  WHERE (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)  
  IF EXISTS (SELECT COUNT(*) from @SAR_STOCK_APPRECIATION)  
  BEGIN  
  
  EXEC PROC_GET_SAR_STOCK_APPRECIATION @EMPLOYEE_SAR_APPRECIATION = @SAR_STOCK_APPRECIATION  
    
  INSERT INTO #STOCK_APPRECIATION_DETAILS_TEMP_1  
  (  
   INSTRUMENT_ID, EMPLOYEE_ID,EXERCISE_PRICE ,OPTION_VESTED,EXERCISE_DATE,EVENTOFINCIDENCE,OPTION_EXERCISED,GRANTOPTIONID, GRANTDATE ,VESTINGDATE,  
   STOCK_APPRECIATION_VALUE,TAXFLAG,TAXFLAG_HEADER   
  )    
  SELECT INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, EVENTOFINCIDENCE,OPTION_EXERCISED,  
   GRANTOPTIONID, GRANTDATE, VESTINGDATE,ISNULL( STOCK_APPRECIATION_VALUE,0),TAXFLAG,TAXFLAG_HEADER FROM TEMP_STOCK_APPRECIATION_DETAILS  
  
  /* UPDATE SAR STOCK APPRECIATION PRICES */  
    
  UPDATE TAED SET   
   TAED.StockApprValue = CASE TSAD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,  
   TAED.TentativeStockApprValue = CASE TSAD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END     
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
   INNER JOIN #STOCK_APPRECIATION_DETAILS_TEMP_1 AS TSAD ON TSAD.INSTRUMENT_ID = TAED.MIT_ID   
  WHERE   
   (TSAD.EMPLOYEE_ID = TAED.EmployeeId) AND (TSAD.OPTION_VESTED = TAED.EXERCISABLE_QUANTITY) AND   
   (TSAD.OPTION_EXERCISED = TAED.EXERCISABLE_QUANTITY) AND   
   (CONVERT(DATE, TSAD.EXERCISE_DATE) = CONVERT(DATE, TAED.EXERCISE_DATE)) AND (TSAD.GRANTOPTIONID = TAED.GrantOptionId) AND   
   (CONVERT(DATE, TSAD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND (CONVERT(DATE, TSAD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate))   
   
  UPDATE TAED SET  
   TAED.CashPayoutValue =  
     
   CASE WHEN TAED.MIT_ID = 6 THEN       
        
      CASE  
      WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN 0         
         WHEN (SH.ROUNDING_UP = 1) THEN 0         
         WHEN SH.ROUNDING_UP = 0  THEN CASE WHEN  SH.FRACTION_PAID_CASH = 1 THEN  
       (ISNULL(TAED.SettlmentPrice,0) - ISNULL(TAED.ExercisePrice,0)) * (ISNULL(TAED.Old_ShareAriseApprValue,0) -  ISNULL(FLOOR(TAED.Old_ShareAriseApprValue),0))  
        ELSE 0 END END    
        ELSE ISNULL(TAED.StockApprValue,0) - ISNULL(TAED.PerqstPayable,0) END   
   
   ,TAED.TentativeCashPayoutValue =   
   CASE WHEN TAED.MIT_ID = 6 THEN       
        
      CASE  
      WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN 0         
         WHEN (SH.ROUNDING_UP = 1) THEN 0         
         WHEN SH.ROUNDING_UP = 0  THEN CASE WHEN  SH.FRACTION_PAID_CASH = 1 THEN  
       (ISNULL(TAED.SettlmentPrice,0) - ISNULL(TAED.ExercisePrice,0)) * (ISNULL(TAED.Old_ShareAriseApprValue,0) -  ISNULL(FLOOR(TAED.Old_ShareAriseApprValue),0))  
        ELSE 0 END END  
    
      ELSE ISNULL(TAED.TentativeStockApprValue,0) - ISNULL(TAED.TentativePerqstPayable,0) END   
  FROM   
   #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID  
   INNER JOIN  Scheme as SH on SH.SchemeId = TAED.SchemeId  
  WHERE   
   (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)  
  
  END  
  IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_FINAL_DETAILS')  
  BEGIN  
   DROP TABLE TEMP_SAR_SETTLEMENT_FINAL_DETAILS  
  END  
    
 END 
 -- INSERT ENTITY DATA --	
	DECLARE  @CurrentDate NVARCHAR(50)
		
	 UPDATE ED SET ED.EntityConfigurationBaseOn = CIM.EntityBaseOn,ED.IsActiveEntity =CIM.ISActivedforEntity 
	 FROM #TEMP_AUTO_EXERCISED_DETAILS AS ED
     INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON ED.MIT_ID=CIM.MIT_ID
 IF EXISTS (SELECT COUNT(ISACTIVEENTITY) FROM #TEMP_AUTO_EXERCISED_DETAILS WHERE ISACTIVEENTITY=1)	
   BEGIN 
   BEGIN TRY
	  DECLARE @EMP_ID dbo.TYPE_EMPLOYEE_DATA_ENTITY
	  INSERT INTO @EMP_ID   
	  SELECT   
			 TAED.EmployeeID
	  FROM   
		  #TEMP_AUTO_EXERCISED_DETAILS AS TAED  
		  INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID	  
          WHERE TAED.IsActiveEntity='1'

		 CREATE TABLE #TEMP_ENTITY_DATA
		(
			SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
			EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE,
			ENTITY_ID BIGINT NULL
		)

		INSERT INTO #TEMP_ENTITY_DATA
		(
			SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
		)	
		EXEC PROC_EMP_MOVEMENT_TRANSFER_REPORT_SCHEDULAR 'Entity',@EMP_ID
	   
	   
	    CREATE TABLE #TEMP_FILTER_DATA
		(		
			ENTITY_ID BIGINT NULL,FIELD NVARCHAR(100),MLFN_ID BIGINT
		)
		INSERT INTO #TEMP_FILTER_DATA(ENTITY_ID,FIELD,MLFN_ID)
		SELECT MLFL.MLFV_ID ,MLFL.FIELD_VALUE ,MLFL.MLFN_ID
		FROM MASTER_LIST_FLD_NAME AS MLFN
		INNER JOIN   MASTER_LIST_FLD_VALUE AS MLFL
		ON MLFN.MLFN_ID = MLFL.MLFN_ID
		WHERE MLFN.FIELD_NAME = 'Entity' 
   
	    SET @CurrentDate=GETDATE()
				
			--FOR VESTING DATE --			
			      UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='VESTINGDATE'
				  FROM #TEMP_AUTO_EXERCISED_DETAILS AS ED				
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,ED.FinalVestingDate)) >= CONVERT(DATE,TED.FROMDATE)
				  AND (CONVERT(DATE,ED.FinalVestingDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY	
			      WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1001' 
			  --FOR EXERCISE DATE --			 
			    UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='EXERCISEDATE'
				FROM #TEMP_AUTO_EXERCISED_DETAILS AS ED
				INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,@CurrentDate)) >= CONVERT(DATE,TED.FROMDATE)
				AND (CONVERT(DATE,@CurrentDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
				WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1002' 
			   --FOR GRANT DATE --			 
			    UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='GRANTDATE'
				FROM #TEMP_AUTO_EXERCISED_DETAILS AS ED
				INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,ED.GRANTDATE)) >= CONVERT(DATE,TED.FROMDATE)
				AND (CONVERT(DATE,ED.GRANTDATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
				WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1003'					
			         
		 END TRY  
   		 BEGIN CATCH  
		   -- ROLLBACK TRANSACTION  
		    SELECT  ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
		       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
		 END CATCH 
	END 
          

	        
 BEGIN TRY  
    
  BEGIN TRANSACTION  
    
  BEGIN /* ===== SAVE INTO SHEXERCISEOPTIONS TABLE ===== */  
    INSERT INTO ShExercisedOptions   
   (  
    GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisePrice,   
    ExercisableQuantity, Action, LastUpdatedBy, LastUpdatedOn, GrantLegId, ExerciseDate, ValidationStatus, EmployeeID,   
    ExerciseNo, Cash, IsMassUpload, PerqstValue, PerqstPayable, FMVPrice, perq_tax_rate, TaxRule, PaymentMode,   
    TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, IsAutoExercised, MIT_ID, PerPayModeSelected,  
    StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice  
          ,ShareAriseApprValue,TentShareAriseApprValue, Entity,EntityBaseOn,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS 
   )   
   SELECT  
    Id, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, ExercisePrice,   
    0, 'A', 'ADMIN', GETDATE(), GrantLegId, EXERCISE_DATE + CAST(GETDATE() AS TIME), 'N', EmployeeId,   
    ExerciseId, Cash, 'N', PerqstValue, PerqstPayable, FMVPrice, Perq_Tax_rate, NULL, 
	case when MIT_ID in ( 7,5) then  'X' else PaymentMode end  , 
    TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, 1, MIT_ID, PerPayModeSelected,  
    StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice  
          ,ShareAppriciation,TentativeShareAppriciation ,Entity_ID,Entity_BasedON,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS
   FROM   
    #TEMP_AUTO_EXERCISED_DETAILS
	ORDER BY ExerciseId	
  END    
    
  BEGIN /* ===== ADD DATA TO AuditData FOR AUTO PAYMENT MODE SELECTION ===== */  
   BEGIN TRY  
    INSERT INTO AuditData  
    (  
     ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt  
    )  
    SELECT  
     ExerciseId, ExerciseId, CASE WHEN (UPPER(TaxFlag) = 'A') THEN FMVPrice ELSE TentativeFMVPrice END,  
     EXERCISE_DATE + CAST(GETDATE() AS TIME), ExercisePrice * EXERCISABLE_QUANTITY,  
     Perq_Tax_rate, CASE WHEN (UPPER(TaxFlag) = 'A') THEN PerqstValue ELSE TentativePerqstValue END,  
     CASE WHEN (UPPER(TaxFlag) = 'A') THEN PerqstPayable ELSE TentativePerqstPayable END,  
     (SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),  
      case when MIT_ID in ( 7,5) then  'X' else PaymentMode end, 0, (SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, EXERCISE_DATE, MIT_ID, EXERCISABLE_QUANTITY))  
    FROM  
     #TEMP_AUTO_EXERCISED_DETAILS WHERE (LEN(ISNULL(PaymentMode, '')) <> 0)  
	 
      
   END TRY  
   BEGIN CATCH  
    ROLLBACK TRANSACTION  
    SELECT 'AuditData' AS ReturnMessage, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
   END CATCH    
  END  
    
  BEGIN /* ===== UPDATE GRANT LEG TABLE ===== */  
   BEGIN TRY  
    UPDATE GL SET   
     GL.ExercisableQuantity = GL.ExercisableQuantity - TAD.EXERCISABLE_QUANTITY,   
     GL.UnapprovedExerciseQuantity = GL.UnapprovedExerciseQuantity + TAD.EXERCISABLE_QUANTITY  
    FROM   
     Grantleg AS GL  
    INNER JOIN #TEMP_AUTO_EXERCISED_DETAILS TAD ON TAD.Id = GL.ID   
   END TRY  
   BEGIN CATCH  
    ROLLBACK TRANSACTION  
    SELECT 'GRANT LEG' AS ReturnMessage, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;    
   END CATCH      
  END  
    
  BEGIN /* ===== SAVE INTO EMPDET_WITH_EXERCISE TABLE ===== */  
   BEGIN TRY  
     
   INSERT INTO EMPDET_With_EXERCISE   
   (  
    ExerciseNo, DateOfJoining, Grade, EmployeeDesignation, EmployeePhone, EmployeeEmail, EmployeeAddress,   
    PANNumber, ResidentialStatus, Insider, WardNumber, Department, Location, SBU, Entity, DPRecord,   
    DepositoryName, DematAccountType, DepositoryParticipantNo, DepositoryIDNumber, ClientIDNumber,   
    LastUpdatedby, Mobile, SecondaryEmailID, CountryName, COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,   
    BROKER_ELECT_ACC_NUM   
   )  
   SELECT   
    TAD.ExerciseId, EM.DateOfJoining, EM.Grade, EM.EmployeeDesignation, EM.EmployeePhone, EM.EmployeeEmail, EM.EmployeeAddress,  
    EM.PANNumber, EM.ResidentialStatus, EM.Insider, EM.WardNumber, EM.Department, EM.Location, EM.SBU, EM.Entity, EM.DPRecord,   
    EM.DepositoryName, EM.DematAccountType, EM.DepositoryParticipantNo, EM.DepositoryIDNumber, EM.ClientIDNumber,   
    'ADMIN', EM.Mobile, EM.SecondaryEmailID, EM.CountryName, EM.COST_CENTER, EM.BROKER_DEP_TRUST_CMP_NAME, EM.BROKER_DEP_TRUST_CMP_ID,   
    EM.BROKER_ELECT_ACC_NUM    
   FROM   
    EmployeeMaster AS EM   
    INNER JOIN #TEMP_AUTO_EXERCISED_DETAILS AS TAD ON EM.LoginID = TAD.LoginID  
   WHERE   
    DELETED = 0 AND EXISTS (SELECT PMD_ID FROM PAYMENT_MASTER_DETAILS WHERE Exerciseform_Submit ='N' AND MIT_ID = TAD.MIT_ID)  
   END TRY  
   BEGIN CATCH  
     
    ROLLBACK TRANSACTION  
    SELECT 'EMPDET_With_EXERCISE' AS ReturnMessage, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
   END CATCH  
  END  
    
  /* UPDATE IN TAX TABLE */  
  BEGIN  
    
  BEGIN TRY  
    
   INSERT INTO [EXERCISE_TAXRATE_DETAILS]  
   (  
    EXERCISE_NO, COUNTRY_ID, RESIDENT_ID, Tax_Title, BASISOFTAXATION, TAX_RATE, TAX_AMOUNT, TENTATIVETAXAMOUNT,   
    GRANTLEGSERIALNO, FMVVALUE, TENTATIVEFMVVALUE, PERQVALUE, TENTATIVEPERQVALUE, FROM_DATE, TO_DATE,   
    CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON  
   )  
   SELECT  
    EXERCISE_ID, COUNTRY_ID, RESIDENT_STATUS, TAX_HEADING, BASISOFTAXATION, TAX_RATE,   
    CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TAX_AMOUNT ELSE NULL END, CASE WHEN (UPPER(TAX_FLAG) = 'T') THEN TAX_AMOUNT ELSE NULL END,  
    GRANTLEGSERIALNO,       
    CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN FMV ELSE NULL END, CASE WHEN (UPPER(TAX_FLAG) = 'T') THEN FMV ELSE NULL END,  
    CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TOTAL_PERK_VALUE ELSE NULL END, CASE WHEN (UPPER(TAX_FLAG) = 'T') THEN TOTAL_PERK_VALUE ELSE NULL END,  
    FROM_DATE, TO_DATE,   
    'ADMIN', GETDATE(), 'ADMIN', GETDATE()      
   FROM   
    #TAX_CALCULATION  
	ORDER BY EXERCISE_ID	
      
  END TRY  
  BEGIN CATCH  
   ROLLBACK TRANSACTION  
   SELECT 'EXERCISE_TAXRATE_DETAILS' AS ReturnMessage, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
  END CATCH          
  END    
    
  COMMIT TRANSACTION    
    
		SET @TRANSACTION_SUCCESSFUL = 1
    
 END TRY  
 BEGIN CATCH  
  ROLLBACK TRANSACTION   
  SET @TRANSACTION_SUCCESSFUL = 0     
 END CATCH  
   SET @TRANSACTION_SUCCESSFUL = 0     
 IF(@TRANSACTION_SUCCESSFUL = 1)  
 BEGIN  
    
  BEGIN /* ===== INSERT INTO MAILER DB ===== */  
        
   DECLARE   
    @MailSubjectToEmp NVARCHAR(500), @MailBodyToEmp NVARCHAR(MAX), @MailSubjectToCR NVARCHAR(500), @MailBodyToCR NVARCHAR(MAX),  
    @MaxMsgId BIGINT, @CompanyEmailID NVARCHAR(200), @MaxMessageID BIGINT, @MaxNewMsgToId BIGINT, @MaxNewMsgFromId BIGINT  
  
   SELECT @CompanyEmailID = CompanyEmailID FROM CompanyParameters  
  
   SELECT @MailSubjectToEmp = MailSubject, @MailBodyToEmp = MailBody FROM MailMessages WHERE UPPER(Formats) = 'AUTOEXERCISEPOSTMAILTOEMPLOYEE'  
   SELECT @MailSubjectToCR = MailSubject, @MailBodyToCR = MailBody FROM MailMessages WHERE UPPER(Formats) = 'AUTOEXERCISEPOSTMAILTOCR'  
  
   SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)  
           
   BEGIN  
    DBCC CHECKIDENT(#TEMP_AUTOEXERCISED_DETAILS_MAIL, RESEED, @MaxMsgId)  
   END  
  
   INSERT INTO #TEMP_AUTOEXERCISED_DETAILS_MAIL   
   (    
      EmployeeName, EmployeeEmail, ExerciseID, ExercisedQuantity,   
      ExerciseDate, SchemeName, EmployeeID  
   )  
   SELECT   
    EM.EmployeeName, EM.EmployeeEmail, TAD.ExerciseId, TAD.EXERCISABLE_QUANTITY,   
    GETDATE(), (SELECT TOP 1 SC.SchemeTitle from GrantLeg GL INNER JOIN Scheme SC ON GL.SchemeId = SC.SchemeId WHERE ID = TAD.Id), EM.EmployeeID  
   FROM   
    EmployeeMaster AS EM   
    INNER JOIN #TEMP_AUTO_EXERCISED_DETAILS AS TAD ON EM.LoginID = TAD.LoginID  
   WHERE (EM.DELETED = 0)  
  END  
      
  BEGIN /* ===== EMPLOYEE EMAIL ALERT ===== */  
   
   INSERT INTO [MailerDB].[dbo].[MailSpool]  
   (  
    [MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn],   
    [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn]  
   )  
   SELECT   
    Message_ID, @CompanyEmailID, EmployeeEmail, REPLACE(REPLACE(@MailSubjectToEmp,'{0}',SchemeName),'{1}', CONVERT(date, GETDATE())),  
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MailBodyToEmp,'{0}', EmployeeName),'{1}', ExerciseID),'{2}', SchemeName),'{3}', ExercisedQuantity),'{4}', @CompanyEmailID),  
    NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE()  
   FROM   
    #TEMP_AUTOEXERCISED_DETAILS_MAIL  
   WHERE   
    (@MailBodyToEmp IS NOT NULL)   
  END   
    
  BEGIN /* ===== NEWMESSAGETO TABLE ===== */  
      
   SET @MaxNewMsgToId = (SELECT ISNULL(MAX(MessageID),0)+ 1 AS MessageID FROM NewMessageTo)    
   BEGIN  
    DBCC CHECKIDENT(#New_Message_To, RESEED, @MaxNewMsgToId)   
   END   
  
   INSERT INTO #New_Message_To  
   (  
    EmployeeID, MessageDate, MailSubject, MailBody  
   )  
   SELECT   
    EmployeeID, ExerciseDate,      
    REPLACE(REPLACE(@MailSubjectToEmp,'{0}',SchemeName),'{1}', CONVERT(date, GETDATE())),  
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MailBodyToEmp,'{0}', EmployeeName),'{1}', ExerciseID),'{2}', SchemeName),'{3}', ExercisedQuantity),'{4}', @CompanyEmailID)  
   FROM   
    #TEMP_AUTOEXERCISED_DETAILS_MAIL  
   WHERE   
    (@MailBodyToEmp IS NOT NULL)  
            
   INSERT INTO NewMessageTo  
   (  
    MessageID, EmployeeID, MessageDate, [Subject], [Description], ReadDateTime, CategoryID, IsReplySent,  
    LastUpdatedBy, LastUpdatedOn, IsDeleted  
   )  
   SELECT   
    Message_ID, EmployeeID, MessageDate, NMT.MailSubject, NMT.MailBody, NULL, 2, 0,   
    'Admin', GETDATE(), 0   
   FROM   
    #New_Message_To NMT  
   WHERE   
    (NMT.MailBody IS NOT NULL)   
  END  
      
  BEGIN /* ===== NEW MESSAGEFROM TABLE ===== */  
  
   SET @MaxNewMsgFromId = (SELECT ISNULL(MAX(MessageID),0)+ 1 AS MessageID FROM NewMessageFrom)    
     
   BEGIN  
    DBCC CHECKIDENT(#New_Message_From, RESEED, @MaxNewMsgFromId)   
   END   
  
   INSERT INTO #New_Message_From  
   (  
    EmployeeID, MessageDate, MailSubject, MailBody  
   )  
   SELECT   
    EmployeeID, ExerciseDate,      
    REPLACE(REPLACE(@MailSubjectToEmp,'{0}',SchemeName),'{1}', CONVERT(date, GETDATE())),  
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MailBodyToEmp,'{0}', EmployeeName),'{1}', ExerciseID),'{2}', SchemeName),'{3}', ExercisedQuantity),'{4}', @CompanyEmailID)  
   FROM   
    #TEMP_AUTOEXERCISED_DETAILS_MAIL  
   WHERE   
    (@MailBodyToEmp IS NOT NULL)  
  
   INSERT INTO NewMessageFrom  
   (  
    MessageID, EmployeeID, MessageDate, [Subject], [Description], ReadDateTime, CategoryID,  
    IsReplySent, LastUpdatedBy, LastUpdatedOn, IsDeleted  
   )  
   SELECT   
    Message_ID, EmployeeID, MessageDate, NMT.MailSubject, NMT.MailBody, NULL, 2, 0,  
    'Admin', GETDATE(), 0   
   FROM   
    #New_Message_From NMT  
   WHERE   
    (NMT.MailBody IS NOT NULL)   
  END  
    
  BEGIN /* ===== CR EMAIL ALERT ===== */  
  
   DECLARE @RowCount INT, @SchemeName VARCHAR(50), @SchemeNames VARCHAR(MAX);  
     
   SELECT @RowCount = Count(distinct SchemeName) FROM #TEMP_AUTOEXERCISED_DETAILS_MAIL WHERE (@MailBodyToEmp IS NOT NULL)  
  
   WHILE (@RowCount > 0)  
   BEGIN  
        
    SELECT   
     @SchemeName = TADM.SchemeName FROM (SELECT ROW_NUMBER() OVER (ORDER BY SchemeName DESC) AS ROW_ID, SchemeName   
    FROM (SELECT DISTINCT SchemeName FROM #TEMP_AUTOEXERCISED_DETAILS_MAIL) AS SchemeName) TADM  
    WHERE   
     TADM.ROW_ID = @RowCount           
        
    SET @SchemeNames = ISNULL(@SchemeNames,'') + ',' + @SchemeName  
        
    SET @RowCount = @RowCount - 1;  
  
   END  
  
   DECLARE @RCount INT, @UserName VARCHAR(75), @UserNames VARCHAR(MAX), @UserEmailId VARCHAR(75), @UserEmailIds VARCHAR(MAX)  
  
   SELECT   
    @RCount = COUNT(*)   
   FROM   
    UserMaster UM  
    INNER JOIN RoleMaster Rm ON UM.RoleId = Rm.RoleId  
    INNER JOIN UserType UT ON UT.UserTypeId = Rm.UserTypeId  
   WHERE   
    UM.IsUserActive = 'Y' AND UT.UserTypeId = 2  
         
   WHILE (@RCount > 0)  
   BEGIN          
        
    SELECT   
     @UserName = UserMaster.UserName, @UserEmailId = UserMaster.EmailId   
    FROM   
     (  
      SELECT   
       ROW_NUMBER() OVER (ORDER BY UM.UserName DESC) AS ROW_ID, UM.UserName, UM.EmailId   
      FROM   
       UserMaster UM  
       INNER JOIN RoleMaster  Rm ON UM.RoleId = Rm.RoleId  
       INNER JOIN UserType UT ON UT.UserTypeId = Rm.UserTypeId  
      WHERE   
       UM.IsUserActive = 'Y' AND UT.UserTypeId = 2  
     ) UserMaster  
    WHERE   
     UserMaster.ROW_ID = @RCount   
         
    SET @UserEmailIds = ISNULL(@UserEmailIds,'') + ',' + @UserEmailId  
    SET @UserNames = ISNULL(@UserNames,'') + '/ ' + @UserName  
  
    SET @RCount = @RCount - 1;  
  
   END                
  
   SELECT @MaxMessageID = MAX(Message_ID) + 1 FROM #TEMP_AUTOEXERCISED_DETAILS_MAIL WHERE (@MailBodyToEmp IS NOT NULL)  
  
   INSERT INTO [MailerDB].[dbo].[MailSpool]  
   (  
    [MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4],   
    [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn]  
   )  
   SELECT   
    @MaxMessageID, @CompanyEmailID, SUBSTRING(@UserEmailIds, 2, (len(@UserEmailIds))),  
    REPLACE(REPLACE(@MailSubjectToCR,'{0}',SUBSTRING(@SchemeNames, 2, (len(@SchemeNames)))),'{1}', CONVERT(date, GETDATE())),  
    REPLACE(REPLACE(REPLACE(@MailBodyToCR,'{0}', ISNULL(SUBSTRING(@UserNames, 2, (len(@UserNames))),'')),'{1}', CONVERT(date, GETDATE())),'{2}', ISNULL(@CompanyEmailID,'')),  
    @AttachmentPath, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE()   
   WHERE   
    @MaxMessageID IS NOT NULL   
  END  
      
 END   
  
 /* ================ FINAL OUTPUT ================== */  
 SELECT  
  ExerciseId, ROW_ID, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter],   
  VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, FinalVestingDate, FinalExpirayDate,   
  ExercisePrice, GrantDate, LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle,   
  IsPaymentModeRequired, PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage,   
  EmployeeId, LoginID, ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity,   
  A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity,   
  A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, A_ExercisableQuantity,   
  EXERCISABLE_QUANTITY,  
  AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, CALCULATE_TAX,   
  CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS,   
  FMVPrice, PerqstValue, PerqstPayable, Perq_Tax_rate, TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable,   
  TaxFlag, FaceVaue, SARFMV, ExType, Cash,   case when MIT_ID in ( 7,5) then  'X' else PaymentMode end, PerPayModeSelected, EXERCISE_DATE + CAST(GETDATE() AS TIME),  
  StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice  
  ,ShareAppriciation , TentativeShareAppriciation ,Entity_ID,Entity_BasedON,Entity,EntityBaseON_Date 
 FROM   
  #TEMP_AUTO_EXERCISED_DETAILS  
    
 DROP TABLE #TEMP_AUTO_EXERCISED_DETAILS  
 DROP TABLE  #TEMP_TAX_PAYBLE  
 DROP TABLE #TEMP_AUTOEXERCISED_DETAILS_MAIL  
 DROP TABLE #New_Message_To  
 DROP TABLE #New_Message_From  
 DROP table #TEMP_FMV_DETAILS  
     
 SET NOCOUNT OFF;  
END  
GO
