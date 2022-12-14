/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PRE_VESTING_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_PRE_VESTING_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PRE_VESTING_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SAVE_PRE_VESTING_DETAILS] 
(
	@TrustCompanyName VARCHAR(20) = NULL,
	@AttachmentPath VARCHAR(500) = NULL
)
AS
BEGIN	

	SET NOCOUNT ON;

	DECLARE
		@CompanyID VARCHAR(20), @IsPaymentModeRequired TINYINT, @PaymentModeEffectiveDate DATE,	@FaceVaue NUMERIC(18, 2), 
		@SARFMV NUMERIC(18, 2), @IsSingleModeEnabled BIT, @Payment_Mode CHAR(1), @CalculateDays VARCHAR(20), @DaysOut VARCHAR(20), 
		@FBTemployeetravelledYN VARCHAR(20), @FBTPayBy VARCHAR(20), @RoundupPlace_TaxableVal VARCHAR(5),	
		@RoundingParam_TaxableVal VARCHAR(5), @RoundingParam_FMV VARCHAR(5), @RoundupPlace_FMV VARCHAR(5), @ExerciseId NUMERIC(18,0),
		@TRANSACTION_SUCCESSFUL INT = 0
		
	SELECT @CompanyID = CompanyID FROM CompanyParameters
	
	BEGIN /* CREATE TEMP TABLE */
	
		CREATE TABLE #TEMP_PRE_EXERCISED_DETAILS
		(   
			ExerciseId INT IDENTITY (1, 1) NOT NULL, ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100), 
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
			EXERCISABLE_QUANTITY NUMERIC(18,0), AEC_ID BIGINT, EXERCISE_ON NVARCHAR(200), 
			FMVPrice NUMERIC(18,6), PerqstValue NUMERIC(18,6), PerqstPayable NUMERIC(18,6), Perq_Tax_rate numeric(18,6), 
			TentativeFMVPrice NUMERIC(18,6), TentativePerqstValue NUMERIC(18,6), TentativePerqstPayable NUMERIC(18,6), 
			TaxFlag CHAR(1), FaceVaue NUMERIC(18, 2), SARFMV NUMERIC(18, 2), ExType VARCHAR(10), Cash VARCHAR(10), PaymentMode VARCHAR,
			PerPayModeSelected NVARCHAR(5), EXERCISE_DATE DATETIME,
			StockApprValue NUMERIC(18,6), TentativeStockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6), 
			TentativeCashPayoutValue NUMERIC(18,6), SettlmentPrice NUMERIC(18,6), TentativeSettlmentPrice NUMERIC(18,6)	
			,ShareAppriciation NUMERIC(18,6), TentativeShareAppriciation NUMERIC(18,6),Entity NVARCHAR(100), Entity_BasedON BIGINT , Entity_ID BIGINT,EntityBaseON_Date NVARCHAR(50),
			EntityConfigurationBaseOn BIGINT, IsActiveEntity int ,CALCULATE_TAX NVARCHAR(100),CALCUALTE_TAX_PRIOR_DAYS INT, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING INT
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
		DBCC CHECKIDENT(#TEMP_PRE_EXERCISED_DETAILS, RESEED, @ExerciseId) 
	END
  
	INSERT INTO #TEMP_PRE_EXERCISED_DETAILS 
	( 
		ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
		[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
		FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
		LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY, EXERCISE_DATE, CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING		
	)
	EXEC PROC_GET_PRE_VESTING_DETAILS   	

	BEGIN /* ===== CASH ===== */
	
		UPDATE #TEMP_PRE_EXERCISED_DETAILS 
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

		UPDATE #TEMP_PRE_EXERCISED_DETAILS SET FaceVaue = @FaceVaue
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
			#TEMP_PRE_EXERCISED_DETAILS
		
		EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @FMV_VALUE_TYPE		    
		 
		UPDATE TAED SET 
			  TAED.FMVPrice = CASE TFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,
			  TAED.TentativeFMVPrice = CASE TFD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,							
			  TAED.TaxFlag = TFD.TAXFLAG
		FROM #TEMP_PRE_EXERCISED_DETAILS AS TAED
		INNER JOIN TEMP_FMV_DETAILS TFD ON TFD.INSTRUMENT_ID = TAED.MIT_ID
		WHERE
			(TFD.EMPLOYEE_ID = TAED.EmployeeId) AND (TFD.GRANTOPTIONID = TAED.GrantOptionId) 
			AND (CONVERT(DATE, TFD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND (CONVERT(DATE, TFD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate)) 
			AND (CONVERT(DATE, TFD.EXERCISE_DATE) =  CONVERT(DATE, TAED.EXERCISE_DATE))		
						
	END		
			
	BEGIN /* ===== CALCULATE PERQUISITE VALUE ===== */
	   
		DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE
		
		INSERT INTO @PERQ_VALUE_TYPE 
		SELECT 
			MIT_ID, LoginID, ExercisePrice, EXERCISABLE_QUANTITY, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END, 
			EXERCISABLE_QUANTITY, A_GrantedQuantity , EXERCISE_DATE, GrantOptionId, GrantDate, FinalVestingDate, ID, NULL, NULL, ExerciseId  
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS
				
		EXEC PROC_GET_PERQUISITE_VALUE @EMPLOYEE_DETAILS = @PERQ_VALUE_TYPE	
		
		UPDATE TAED SET 
			TAED.PerqstValue = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
			TAED.PerqstPayable = CASE TAED.TAXFLAG WHEN 'A' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18,6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.FinalVestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END,
			TAED.TentativePerqstValue = CASE TAED.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
			TAED.TentativePerqstPayable = CASE TAED.TAXFLAG WHEN 'T' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18,6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.FinalVestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END,
	         TAED.ShareAppriciation = CASE TAED.TAXFLAG WHEN 'A' THEN ShareAppriciation ELSE NULL END,
	         TAED.TentativeShareAppriciation = CASE TAED.TAXFLAG WHEN 'A' THEN ShareAppriciation ELSE NULL END
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
		INNER JOIN TEMP_PERQUISITE_DETAILS TPD ON TPD.INSTRUMENT_ID = TAED.MIT_ID 
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
			EXERCISE_DATE, GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID	,STOCK_VALUE						
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
			#TEMP_PRE_EXERCISED_DETAILS
		
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
			INNER JOIN TEMP_FMV_DETAILS AS TFD ON TC.MIT_ID = TFD.INSTRUMENT_ID
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
			#TEMP_PRE_EXERCISED_DETAILS AS TAED 
		INNER JOIN #TEMP_TAX_PAYBLE TTP ON TAED.ExerciseId = TTP.EXERCISE_ID					
	END	   	
	
	BEGIN /* ===== SAR CALCULATION ===== */
	
		DECLARE @SAR_SETTLEMENT_PRICE dbo.TYPE_SAR_SETTLEMENT_PRICE 
		
		INSERT INTO @SAR_SETTLEMENT_PRICE 
		SELECT 
			TAED.MIT_ID, TAED.EmployeeId, TAED.GrantDate, TAED.FinalVestingDate, TAED.EXERCISE_DATE, TAED.ExercisePrice, 
			TAED.SchemeId, TAED.GrantOptionId
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID
		WHERE 
			(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
		
		EXEC PROC_GET_SAR_SETTELEMENT_PRICCE @EMPLOYEE_SAR_DETAILS = @SAR_SETTLEMENT_PRICE
		
		/* UPDATE SAR SETTLEMENT PRICES */
		UPDATE TAED SET 
			TAED.SettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
			TAED.TentativeSettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END			
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
			INNER JOIN TEMP_SAR_SETTLEMENT_FINAL_DETAILS AS TSSFD ON TSSFD.INSTRUMENT_ID = TAED.MIT_ID 
		WHERE 
			(TSSFD.EMPLOYEE_ID = TAED.EmployeeId) AND (CONVERT(DATE, TSSFD.EXERCISE_DATE) = CONVERT(DATE, TAED.EXERCISE_DATE)) AND 
			(TSSFD.GRANTOPTIONID = TAED.GrantOptionId) AND (CONVERT(DATE, TSSFD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND 
			(CONVERT(DATE, TSSFD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate)) 
		
		DECLARE @SAR_STOCK_APPRECIATION dbo.TYPE_SAR_STOCK_APPRECIATION	
		
		INSERT INTO @SAR_STOCK_APPRECIATION 
		SELECT 
			TAED.MIT_ID, TAED.EmployeeId, TAED.ExercisePrice, TAED.A_ExercisableQuantity, TAED.EXERCISABLE_QUANTITY, 
			TAED.EXERCISE_DATE, TAED.GrantOptionId, TAED.GrantDate, TAED.FinalVestingDate,TAED.ExerciseId
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID
		WHERE (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
		
		EXEC PROC_GET_SAR_STOCK_APPRECIATION @EMPLOYEE_SAR_APPRECIATION = @SAR_STOCK_APPRECIATION		
		
		/* UPDATE SAR STOCK APPRECIATION PRICES */
		
		UPDATE TAED SET 
			TAED.StockApprValue = CASE TSAD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
			TAED.TentativeStockApprValue = CASE TSAD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END			
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
			INNER JOIN TEMP_STOCK_APPRECIATION_DETAILS AS TSAD ON TSAD.INSTRUMENT_ID = TAED.MIT_ID 
		WHERE 
			(TSAD.EMPLOYEE_ID = TAED.EmployeeId) AND (TSAD.OPTION_VESTED = TAED.EXERCISABLE_QUANTITY) AND 
			(TSAD.OPTION_EXERCISED = TAED.EXERCISABLE_QUANTITY) AND 
			(CONVERT(DATE, TSAD.EXERCISE_DATE) = CONVERT(DATE, TAED.EXERCISE_DATE)) AND (TSAD.GRANTOPTIONID = TAED.GrantOptionId) AND 
			(CONVERT(DATE, TSAD.GRANTDATE) = CONVERT(DATE, TAED.GrantDate)) AND (CONVERT(DATE, TSAD.VESTINGDATE) = CONVERT(DATE, TAED.FinalVestingDate)) 
		
		UPDATE TAED SET
			TAED.CashPayoutValue = ISNULL(TAED.StockApprValue,0) - ISNULL(TAED.PerqstPayable,0),
			TAED.TentativeCashPayoutValue = ISNULL(TAED.TentativeStockApprValue,0) - ISNULL(TAED.TentativePerqstPayable,0)
		FROM 
			#TEMP_PRE_EXERCISED_DETAILS AS TAED
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID
		WHERE 
			(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
		
		IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_FINAL_DETAILS')
		BEGIN
			DROP TABLE TEMP_SAR_SETTLEMENT_FINAL_DETAILS
		END
		
		IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_STOCK_APPRECIATION_DETAILS')
		BEGIN
			DROP TABLE TEMP_STOCK_APPRECIATION_DETAILS
		END
	END
		
	-- INSERT ENTITY DATA --

	 DECLARE  @CurrentDate VARCHAR(50)
			 
	 UPDATE ED SET ED.EntityConfigurationBaseOn = CIM.EntityBaseOn,ED.IsActiveEntity =CIM.ISActivedforEntity 
	 FROM #TEMP_PRE_EXERCISED_DETAILS AS ED
     INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON ED.MIT_ID=CIM.MIT_ID
	 
IF EXISTS (SELECT COUNT(ISACTIVEENTITY) FROM #TEMP_PRE_EXERCISED_DETAILS WHERE ISACTIVEENTITY=1)	
 
  BEGIN
	BEGIN TRY
  DECLARE @EMP_ID dbo.TYPE_EMPLOYEE_DATA_ENTITY
   
  INSERT INTO @EMP_ID   
  SELECT   
		 TAED.EmployeeID
  FROM   
	  #TEMP_PRE_EXERCISED_DETAILS AS TAED  
	  INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID
	  WHERE TAED.IsActiveEntity='1'
	   
    
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
			
	INSERT INTO #TEMP_ENTITY_DATA
	(
		SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
	)	
	EXEC PROC_EMP_MOVEMENT_TRANSFER_REPORT_SCHEDULAR 'Entity',@EMP_ID

	
	INSERT INTO #TEMP_FILTER_DATA(ENTITY_ID,FIELD,MLFN_ID)
	SELECT MLFL.MLFV_ID ,MLFL.FIELD_VALUE ,MLFL.MLFN_ID
    FROM MASTER_LIST_FLD_NAME AS MLFN
    INNER JOIN   MASTER_LIST_FLD_VALUE AS MLFL
    ON MLFN.MLFN_ID = MLFL.MLFN_ID
    WHERE MLFN.FIELD_NAME = 'Entity' 

	SET @CurrentDate=GETDATE()
	BEGIN
	    --FOR VESTING DATE --	   
			  UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='VESTINGDATE'
			  FROM #TEMP_PRE_EXERCISED_DETAILS AS ED
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeId AND ((CONVERT(DATE,ED.FinalVestingDate)) >= CONVERT(DATE,TED.FROMDATE)
				  AND (CONVERT(DATE,ED.FinalVestingDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
				  WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1001' 

	      --FOR EXERCISE DATE --
				UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='EXERCISEDATE'
				FROM #TEMP_PRE_EXERCISED_DETAILS AS ED
				  INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,EXERCISE_DATE)) >= CONVERT(DATE, ISNULL(TED.FROMDATE,TED.TODATE))
				  AND (CONVERT(DATE,EXERCISE_DATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, EXERCISE_DATE))))
				  INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
				  WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1002' 
			
	    
	       --FOR GRANT DATE --	   
				UPDATE ED SET ED.Entity_ID = TFD.ENTITY_ID,ED.Entity_BasedON = ED.EntityConfigurationBaseOn,ED.Entity = TFD.FIELD,ED.EntityBaseON_Date='GRANTDATE'
				FROM #TEMP_PRE_EXERCISED_DETAILS AS ED			
				INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeId AND((CONVERT(DATE,ED.GRANTDATE)) >= CONVERT(DATE,TED.FROMDATE)
				AND (CONVERT(DATE,ED.GRANTDATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY	
				WHERE ED.IsActiveEntity='1' AND ED.EntityConfigurationBaseOn='1003' 		
	     END		
	END TRY  
   	BEGIN CATCH  
   -- ROLLBACK TRANSACTION  
    SELECT  ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
       ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
   	END CATCH
 END
   
   

   
-----END-------
	BEGIN TRY
		
		BEGIN TRANSACTION
		
		BEGIN /* ===== SAVE INTO SHEXERCISEOPTIONS TABLE ===== */
 			INSERT INTO ShExercisedOptions 
			(
				GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisePrice, 
				ExercisableQuantity, Action, LastUpdatedBy, LastUpdatedOn, GrantLegId, ExerciseDate, ValidationStatus, EmployeeID, 
				ExerciseNo, Cash, IsMassUpload, PerqstValue, PerqstPayable, FMVPrice, perq_tax_rate, TaxRule, PaymentMode, 
				TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, IsAutoExercised, MIT_ID, PerPayModeSelected,
				StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice,
				IsPrevestExercised,ShareAriseApprValue,TentShareAriseApprValue, Entity , EntityBaseOn,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING  
			) 
			SELECT
				Id, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, ExercisePrice, 
				0, 'A', 'ADMIN', GETDATE(), GrantLegId, EXERCISE_DATE + CAST(GETDATE() AS TIME), 'N', EmployeeId, 
				ExerciseId, Cash, 'N', PerqstValue, PerqstPayable, FMVPrice, Perq_Tax_rate, NULL, PaymentMode, 
				TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, 2, MIT_ID, PerPayModeSelected,
				StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice,
				1,ShareAppriciation,TentativeShareAppriciation , Entity_ID,Entity_BasedON,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING      
			FROM 
				#TEMP_PRE_EXERCISED_DETAILS 
			ORDER BY ExerciseId
		END						
		
		BEGIN /* ===== SAVE INTO EMPDET_WITH_EXERCISE TABLE ===== */

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
				INNER JOIN #TEMP_PRE_EXERCISED_DETAILS AS TAD ON EM.LoginID = TAD.LoginID
			WHERE 
				(EM.DELETED = 0) AND EXISTS (SELECT PMD_ID FROM PAYMENT_MASTER_DETAILS WHERE Exerciseform_Submit ='N' AND MIT_ID = TAD.MIT_ID)
			Order by TAD.ExerciseId
		END
		
		BEGIN /* ===== UPDATE GRANT LEG TABLE ===== */
			UPDATE GL SET 
				GL.PerVestingQuantity = TAD.EXERCISABLE_QUANTITY,
				GL.ExercisableQuantity = GL.ExercisableQuantity - TAD.EXERCISABLE_QUANTITY,
				GL.UnapprovedExerciseQuantity = GL.UnapprovedExerciseQuantity + TAD.EXERCISABLE_QUANTITY 				
			FROM 
				Grantleg AS GL
			INNER JOIN #TEMP_PRE_EXERCISED_DETAILS TAD ON TAD.Id = GL.ID			
		END
		
		/* UPDATE IN TAX TABLE */
		BEGIN
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
			ORDER BY #TAX_CALCULATION.EXERCISE_ID
		END		
		
		COMMIT TRANSACTION  
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION	
	END CATCH
	
	/* ================ FINAL OUTPUT ================== */
	SELECT
		ExerciseId, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter], 
		VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, FinalVestingDate, FinalExpirayDate, 
		ExercisePrice, GrantDate, LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, 
		IsPaymentModeRequired, PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, 
		EmployeeId, LoginID, ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, A_ExercisableQuantity, 
		EXERCISABLE_QUANTITY, AEC_ID, EXERCISE_ON, 
		FMVPrice, PerqstValue, PerqstPayable, Perq_Tax_rate, TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, 
		TaxFlag, FaceVaue, SARFMV, ExType, Cash, PaymentMode, PerPayModeSelected, EXERCISE_DATE + CAST(GETDATE() AS TIME),
		StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice
		ShareAppriciation , TentativeShareAppriciation,Entity_ID,Entity,Entity_BasedON,EntityBaseON_Date,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING 
	FROM 
		#TEMP_PRE_EXERCISED_DETAILS
		
	DROP TABLE #TEMP_PRE_EXERCISED_DETAILS
	DROP TABLE  #TEMP_TAX_PAYBLE	
			
	SET NOCOUNT OFF;
END
GO
