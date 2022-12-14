/****** Object:  StoredProcedure [dbo].[PROC_PERQUISITE_TAX_CALCULATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PERQUISITE_TAX_CALCULATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PERQUISITE_TAX_CALCULATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PERQUISITE_TAX_CALCULATION] (@CompanyId VARCHAR(50) = NULL)
	-- ADD THE PARAMETERS FOR THE STORED PROCEDURE HERE	
AS
BEGIN

	DECLARE @PRQUSTCALCON VARCHAR(5), @PreqTax_Calculateon VARCHAR(5), @SendPrqstMailAfter VARCHAR(5), @SendPrqstMailOn VARCHAR(5),
			@PrequisiteTax VARCHAR(20), @PerqTax_ApplyCash VARCHAR(5), @PreqTax_ExchangeType VARCHAR(5), @PreqTax_Shareprice VARCHAR(5),
			@ExerciseFormPrequisitionText1 VARCHAR(100), @ExerciseFormPrequisitionText2 VARCHAR(100), @CalcPerqtaxYN VARCHAR(5),
			@Calc_PerqDt_From DATETIME, @SendPerqMail VARCHAR(5), @FaceVaue VARCHAR(5), @RoundupPlace_TaxAmt VARCHAR(5), 
			@RoundupPlace_TaxableVal VARCHAR(5), @TaxRate_ResignedEmp VARCHAR(20), @RoundupPlace_FMV VARCHAR(5), @RoundingParam_FMV VARCHAR(5), 
			@RoundingParam_TaxableVal VARCHAR(5), @RoundingParam_Taxamt VARCHAR(5), @COMPANY_ID VARCHAR(100), @SendPerqTaxMail CHAR(1),
			@COMPANY_EMAIL_ID VARCHAR(200),	 @IS_TASKSCHEDULAR INT 
	
	DECLARE @MailSubject NVARCHAR(500), @MailBody NVARCHAR(MAX), @MaxMsgId BIGINT, @CC_TO VARCHAR(500), 
	@HULMailBody NVARCHAR(MAX), @HULSpecificMailBody NVARCHAR(MAX), @HULSpecificNote1 NVARCHAR(MAX)
					
	DECLARE @CASE_1_#PERQUISITE_TAX_CALCULATION_N_N_CASH CHAR
	DECLARE @CASE_5_#PERQUISITE_TAX_CALCULATION_EXED_N CHAR
	-- CASE 7 : SEND MAIL ONLY FOR HUL COMPANY AFTER CALCULATE FMV
	DECLARE @CASE_7_#PERQUISITE_TAX_CALCULATION_HUL CHAR	
			
	-- IF PARAMETER SET 1 THEN EXECUTE STATEMENT
	SET @CASE_1_#PERQUISITE_TAX_CALCULATION_N_N_CASH = '1'
	SET @CASE_5_#PERQUISITE_TAX_CALCULATION_EXED_N = '1'
	SET @CASE_7_#PERQUISITE_TAX_CALCULATION_HUL = '1'			
	
	SET NOCOUNT ON;
	
	-------------------------------------
	-- GET DETAILS FROM COMPANY PARAMETER
	-------------------------------------
	
	BEGIN		
		SELECT	@PRQUSTCALCON = ISNULL(prqustcalcon, ''), @PreqTax_Calculateon = ISNULL(PreqTax_Calculateon, ''), 
				@SendPrqstMailAfter = ISNULL(SendPrqstMailAfter, 0), @SendPrqstMailOn = ISNULL(SendPrqstMailOn, 0), 
				@PrequisiteTax = CONVERT(VARCHAR(20),ISNULL(prequisiteTax, 0)), @PerqTax_ApplyCash = ISNULL(PerqTax_ApplyCash, 'N'), 
				@PreqTax_ExchangeType = PreqTax_ExchangeType, @PreqTax_Shareprice = PreqTax_Shareprice, 
				@ExerciseFormPrequisitionText1 = ISNULL(ExerciseFormPrequisitionText1, ''), 
				@ExerciseFormPrequisitionText2 = ISNULL(ExerciseFormPrequisitionText2, ''),
				@CalcPerqtaxYN = ISNULL(CalcPerqtaxYN, 'N'), @Calc_PerqDt_From = Calc_PerqDt_From, 
				@SendPerqMail = ISNULL(SendPerqMail, 'N'), @FaceVaue = FaceVaue, 
				@RoundupPlace_FMV = RoundupPlace_FMV, @RoundingParam_FMV = RoundingParam_FMV,
				@RoundupPlace_TaxAmt = RoundupPlace_TaxAmt,  @RoundingParam_Taxamt = RoundingParam_Taxamt,
				@RoundupPlace_TaxableVal = RoundupPlace_TaxableVal, @RoundingParam_TaxableVal = RoundingParam_TaxableVal, 
				@TaxRate_ResignedEmp = CONVERT(VARCHAR(20), TaxRate_ResignedEmp), @COMPANY_ID = CompanyID, @COMPANY_EMAIL_ID = CompanyEmailID
		FROM CompanyParameters

		--PRINT	'@PRQUSTCALCON : '+ @PRQUSTCALCON +', '+ 
		--		'@PreqTax_Calculateon : '+ @PreqTax_Calculateon +', '+ 
		--		'@SendPrqstMailAfter : '+ @SendPrqstMailAfter +', '+ 
		--		'@SendPrqstMailOn : '+ @SendPrqstMailOn +', '+ 
		--		'@PrequisiteTax : '+ @PrequisiteTax +', '+ 
		--		'@PerqTax_ApplyCash : '+ @PerqTax_ApplyCash +', '+ 
		--		'@PreqTax_ExchangeType : '+ @PreqTax_ExchangeType +', '+ 
		--		'@PreqTax_Shareprice : '+ @PreqTax_Shareprice +', '+ 
		--		'@ExerciseFormPrequisitionText1 : '+ @ExerciseFormPrequisitionText1 +', '+ 
		--		'@ExerciseFormPrequisitionText2 : '+ @ExerciseFormPrequisitionText2 +', '+ 
		--		'@CalcPerqtaxYN : '+ @CalcPerqtaxYN +', '+  
		--		'@Calc_PerqDt_From : '+ CONVERT(VARCHAR(50), @Calc_PerqDt_From) +', '+ 
		--		'@SendPerqMail : '+ @SendPerqMail +', '+  
		--		'@FaceVaue : '+ @FaceVaue +', '+  
		--		'@RoundupPlace_FMV : '+ @RoundupPlace_FMV +', '+  
		--		'@RoundingParam_FMV : '+@RoundingParam_FMV +', '+ 
		--		'@RoundupPlace_TaxAmt : '+ @RoundupPlace_TaxAmt +', '+ 
		--		'@RoundingParam_Taxamt : '+ @RoundingParam_Taxamt +', '+ 
		--		'@RoundupPlace_TaxableVal : '+ @RoundupPlace_TaxableVal +', '+  
		--		'@RoundingParam_TaxableVal : '+ @RoundingParam_TaxableVal +', '+ 
		--		'@TaxRate_ResignedEmp : '+ @TaxRate_ResignedEmp +', '+  
		--		'@COMPANY_ID : '+ @COMPANY_ID +', '+  
		--		'@COMPANY_EMAIL_ID : '+ @COMPANY_EMAIL_ID						
	END
	
	--------------------
	-- CREATE TEMP TABLE
	--------------------
		
	BEGIN
	
		--====================================================================================================================
		-- CASE 1 : TEMP TABLE FOR MASSUPLOAD = 'N' AND ISSARAPPLIED = 'N' FROM SHEXERCISEDOPTIONS TABLE
		--====================================================================================================================
		
		IF(@CASE_1_#PERQUISITE_TAX_CALCULATION_N_N_CASH = '1')
		BEGIN	
			CREATE TABLE #PERQUISITE_TAX_CALCULATION_N_N_CASH
			(
				TaxUploadCase VARCHAR(10), ExerciseId VARCHAR(50), ExerciseNo VARCHAR(50), GrantLegSerialNumber VARCHAR(50), 
				SchemeId VARCHAR(100), GrantOptionId VARCHAR(100), EmployeeID VARCHAR(50), ExercisedQuantity NUMERIC(18,6), 
				ExercisePrice NUMERIC(18,2), SharesIssuedDate DATETIME, Cash VARCHAR(50), ExerciseDate DATETIME, GrantDate DATETIME, 
				IsMassUpload CHAR(1), Apply_SAR CHAR (1), ResidentialStatus CHAR(1), Emp_Status CHAR (1), EMP_TAX_SLAB NUMERIC(18,6), 
				PERQTAXRULE CHAR (1), CALCPERQVAL CHAR (1), CALCPERQTAX CHAR (1), PERQTAXRATE NUMERIC(18,6), CALCPERQPARAM CHAR (1), 
				FMVPrice NUMERIC(18,6), Preq_Value NUMERIC(18,6), Preq_Payable NUMERIC(18,6), EmployeeName VARCHAR(200),
				EmployeeEmail VARCHAR(200), ExerciseCost NUMERIC(18,0), EmpTaxSlab CHAR(1), MIT_ID INT, VestedOptions NUMERIC(18,6), 
				GrantedOptions NUMERIC(18,6), VestingDate DATETIME, EventOfIncidence INT, TaxFlag CHAR(1),
				StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6), SettlmentPrice NUMERIC(18,6), LoginID VARCHAR(50),
				ShareAriseApprValue NUMERIC(18,9),CASHPAYOUT_VALUE  NUMERIC(18,9),Entity BIGINT,EntityBaseOn BIGINT,
				EntityConfigurationBaseOn BIGINT, IsActiveEntity int 
			)
			
			CREATE TABLE #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL
			(
				M_TaxUploadCase VARCHAR(10), M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
				M_ExerciseNo VARCHAR(50), M_EmployeeName VARCHAR(200), M_EmployeeEmail VARCHAR(200), M_ExerciseID VARCHAR(5000),
				M_ExercisedQuantity VARCHAR(5000), M_ExercisePrice VARCHAR(5000), M_ExerciseDate VARCHAR(5000), M_GrantDate VARCHAR(5000), 
				M_FMVPrice VARCHAR(5000), M_PERQTAXRATE VARCHAR(5000), M_Preq_Value VARCHAR(5000), M_Preq_Payable VARCHAR(5000), 
				M_ExerciseCost VARCHAR(5000), M_MailSubject VARCHAR(200), M_MailBody VARCHAR(MAX)
			)
		END
					
		--==========================================================================================
		-- CASE 5 : TEMP TABLE FOR OFFLINE MASS UPLOAD WHERE ISSARAPPLIED = 'N' FROM EXERCISED TABLE
		--==========================================================================================
		
		IF(@CASE_5_#PERQUISITE_TAX_CALCULATION_EXED_N = '1')
		BEGIN
			CREATE TABLE #PERQUISITE_TAX_CALCULATION_EXED_N
			(
				TaxUploadCase VARCHAR(10), ExerciseId VARCHAR(50), ExerciseNo VARCHAR(50), GrantLegSerialNumber VARCHAR(50), 
				SchemeId VARCHAR(100), GrantOptionId VARCHAR(100), EmployeeID VARCHAR(50), ExercisedQuantity NUMERIC(18,6), 
				ExercisePrice NUMERIC(18,2), SharesIssuedDate DATETIME, Cash VARCHAR(50), ExerciseDate DATETIME, GrantDate DATETIME, 
				IsMassUpload CHAR(1), Apply_SAR CHAR (1), ResidentialStatus CHAR(1), Emp_Status CHAR (1), EMP_TAX_SLAB NUMERIC(18,6), 
				PERQTAXRULE CHAR (1), CALCPERQVAL CHAR (1), CALCPERQTAX CHAR (1), PERQTAXRATE NUMERIC(18,6), CALCPERQPARAM CHAR (1), 
				FMVPrice NUMERIC(18,6), Preq_Value NUMERIC(18,6), Preq_Payable NUMERIC(18,6), EmployeeName VARCHAR(200),
				EmployeeEmail VARCHAR(200), ExerciseCost NUMERIC(18,0), EmpTaxSlab CHAR(1), MIT_ID INT, VestedOptions NUMERIC(18,6), 
				GrantedOptions NUMERIC(18,6), VestingDate DATETIME, EventOfIncidence INT, TaxFlag CHAR(1), 
				StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6), SettlmentPrice NUMERIC(18,6), LoginID VARCHAR(50),
				ShareAriseApprValue NUMERIC(18,9),CASHPAYOUT_VALUE NUMERIC(18,9)
			)
		END			
					
		--====================================================================================================================
		-- CASE 7 : TEMP TABLE FOR HUL
		--====================================================================================================================
		
		IF(@CASE_7_#PERQUISITE_TAX_CALCULATION_HUL = '1')
		BEGIN					
			CREATE TABLE #PERQUISITE_TAX_CALCULATION_HUL
			(
				H_TaxUploadCase VARCHAR(10), H_ExerciseId VARCHAR(50),H_ExerciseNo VARCHAR(50), H_GrantLegSerialNumber VARCHAR(50),H_SchemeId VARCHAR(100), H_GrantOptionId VARCHAR(100),
				H_EmployeeID VARCHAR(50), H_ExercisedQuantity NUMERIC(18,6), H_ExercisePrice NUMERIC(18,2), H_SharesIssuedDate DATETIME, H_Cash VARCHAR(50), 
				H_ExerciseDate DATETIME,H_GrantDate DATETIME, H_IsMassUpload CHAR(1),H_Apply_SAR CHAR (1), H_ResidentialStatus CHAR(1),H_PERQTAXRATE NUMERIC(18,2),
				H_FMVPrice NUMERIC(18,6), H_Preq_Value NUMERIC(18,6), H_Preq_Payable NUMERIC(18,6),H_EmployeeName VARCHAR(200), H_EmployeeEmail VARCHAR(200), H_ExerciseCost NUMERIC(18,0)
			)
			
			CREATE TABLE #PERQUISITE_TAX_CALCULATION_HUL_MAIL
			(
				H_TaxUploadCase VARCHAR(10), H_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
				H_ExerciseNo VARCHAR(50), H_EmployeeName VARCHAR(200), H_EmployeeEmail VARCHAR(200), H_ExerciseID VARCHAR(5000),
				H_ExercisedQuantity VARCHAR(5000), H_ExercisePrice VARCHAR(5000), H_ExerciseDate VARCHAR(5000), H_GrantDate VARCHAR(5000), 
				H_FMVPrice VARCHAR(5000),H_PERQTAXRATE NUMERIC(18,2), H_Preq_Value VARCHAR(5000), H_Preq_Payable VARCHAR(5000), H_ExerciseCost NUMERIC(18,0),
				H_MailSubject VARCHAR(200), H_MailBody VARCHAR(MAX)
			)
		END
		 CREATE TABLE #TEMP_FMV_DETAILS_NEW
		(  
			ID INT NOT NULL, INSTRUMENT_ID BIGINT, EMPLOYEE_ID  VARCHAR(50), GRANTOPTIONID VARCHAR(50), GRANTDATE VARCHAR(200),
			VESTINGDATE VARCHAR(200), EXERCISE_DATE DATETIME,FMV_VALUE DECIMAL(18,4) NULL,TAXFLAG CHAR(1) NULL,TAXFLAG_HEADER CHAR(1) NULL
		)
		  CREATE TABLE #STOCK_APPRECIATION_DETAILS_TEMP
	   (
		ID INT IDENTITY(1,1) NOT NULL,INSTRUMENT_ID BIGINT ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,9),OPTION_VESTED NUMERIC(18,9),
		EXERCISE_DATE DATETIME,STOCK_APPRECIATION_VALUE NUMERIC(18,9),EVENTOFINCIDENCE INT,OPTION_EXERCISED NUMERIC(18,9),GRANTOPTIONID VARCHAR(50) NULL,
		GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NULL, TAXFLAG CHAR(1),TAXFLAG_HEADER CHAR(1) NULL	
	   )
	   	CREATE TABLE #CASE_1_TAX_CALCULATION_NEW_DATA
		( 
			TAX_HEADING NVARCHAR(50), TAX_RATE FLOAT, RESIDENT_STATUS NVARCHAR(250), TAX_AMOUNT FLOAT, Country NVARCHAR(250),
			[STATE] NVARCHAR(250), BASISOFTAXATION NVARCHAR(250), FMV NVARCHAR(250), TOTAL_PERK_VALUE FLOAT, COUNTRY_ID INT, 
			MIT_ID INT, EmployeeID VARCHAR(50), GRANTOPTIONID VARCHAR(50), VESTING_DATE DATETIME,
			GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TAX_FLAG NCHAR(1), EXERCISE_ID BIGINT
		)
		
		
      CREATE TABLE #TEMP_FILTERED_RECORD
    (
		 INSTRUMENT_ID BIGINT  ,EMPLOYEE_ID  VARCHAR(50),EXERCISE_PRICE NUMERIC(18,9),OPTION_VESTED NUMERIC(18,9),EXERCISE_DATE DATETIME,PERQ_VALUE NUMERIC(18,9),EVENTOFINCIDENCE INT,FMV_VALUE NUMERIC(18,9),OPTION_EXERCISED NUMERIC(18,9),GRANTED_OPTIONS NUMERIC(18,9)
		,GRANTOPTIONID VARCHAR(50)  NUll,GRANTDATE  VARCHAR(200) NUll,VESTINGDATE VARCHAR(200) NUll,OLD_PERQ_VALUE NUMERIC(18,4)NULL,GRANTLEGSERIALNO BIGINT,FROM_DATE DATETIME,TO_DATE DATETIME,TEMP_EXERCISEID BIGINT	,SHARE_APPRECIATION_VALUE NUMERIC(18,9) NULL,EXERCISE_AMOUNT_PAYABLE NUMERIC(18,9)	
		,OLD_SHARE_VALUE NUMERIC(18,9) NULL
		
     )
       
     CREATE TABLE #TEMP_MIN_EXERCISE
    (
	   MIN_EXERCISE_ID BIGINT,ExerciseNo VARCHAR(50)   
	)

      CREATE TABLE #TEMP_MAX_EXERCISE
    (
       MAX_EXERCISE_ID BIGINT,ExerciseNo VARCHAR(50),SHARE_APPRECIATION_VALUE NUMERIC(18,9),OLD_SHARE_VALUE NUMERIC(18,9)
	 )
       

	END
							
	--=============================================================================
	-- PERQUISITE TAX CALCULATE ON SAME DAY
	--=============================================================================
	
	IF (@PreqTax_Calculateon = 'S')
	BEGIN

		-------------------------------------------------------------------------------------------
		-- CASE 1 : GET DETAILS FROM SHEXERCISEDOPTIONS FOR MASSUPLOAD = 'N' AND ISSARAPPLIED = 'N'
		-------------------------------------------------------------------------------------------
		
		IF(@CASE_1_#PERQUISITE_TAX_CALCULATION_N_N_CASH = '1')				
		BEGIN
			
			/*===== CALCULATE FMV =====*/
			IF((SELECT COUNT(ExerciseId) FROM [VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE] AS VW WHERE (UPPER(VW.IsMassUpload) = 'N')) > 0)
			BEGIN

				DECLARE @CASE_1_TYPE_FMV_VALUE dbo.TYPE_FMV_VALUE
			    
				INSERT INTO @CASE_1_TYPE_FMV_VALUE 
				SELECT 
					MIT_ID, LoginID, GrantOptionId, GrantDate, VestingDate, ExerciseDate, 'A' 
				FROM 
					[VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE] VW 
			    
				EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @CASE_1_TYPE_FMV_VALUE
			    
			     INSERT INTO #TEMP_FMV_DETAILS_NEW (ID ,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG,TAXFLAG_HEADER )
		         SELECT ID, INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, 
				 FMV_VALUE, TAXFLAG , TAXFLAG_HEADER FROM TEMP_FMV_DETAILS
			    /*========================*/
				
				INSERT INTO #PERQUISITE_TAX_CALCULATION_N_N_CASH 
				(
					TaxUploadCase, ExerciseId, ExerciseNo, GrantLegSerialNumber, SchemeId, GrantOptionId, EmployeeID, ExercisedQuantity, ExercisePrice, SharesIssuedDate, 
					Cash, ExerciseDate, GrantDate, IsMassUpload, Apply_SAR, ResidentialStatus, Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, PERQTAXRATE, 
					CALCPERQPARAM, EmployeeName, EmployeeEmail, MIT_ID, VestedOptions, GrantedOptions, VestingDate, LoginID
				)
				SELECT 
					'CASE1', ExerciseId, ExerciseNo, GrantLegSerialNumber, SchemeId, VW.GrantOptionId, EmployeeID, ExercisedQuantity, ExercisePrice, SharesIssuedDate, 
					Cash, ExerciseDate, VW.GrantDate, IsMassUpload, Apply_SAR, ResidentialStatus, Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, dbo.FN_PQ_TAX_ROUNDING(PERQTAXRATE), 
					(CASE WHEN (CALCPERQVAL='Y') AND (CALCPERQTAX='Y') THEN 'B'  
							WHEN (CALCPERQVAL='Y') AND (CALCPERQTAX='N' OR CALCPERQTAX IS NULL ) THEN 'V'   
						ELSE 'F'  
					END) AS CALCPERQPARAM,	 		
					EmployeeName, EmployeeEmail, VW.MIT_ID, VW.ExercisableQuantity, GrantedOptions, VW.VestingDate, LoginID
				FROM 
					[VW_PERQUISITE_TAX_CALCULATION_SHEXERCISE] AS VW
																					
				-- UPDATE FMVSHARE PRICE					
				UPDATE PTCN SET 
					PTCN.FMVPrice = CASE WHEN TFD.TAXFLAG = 'A' THEN TFD.FMV_VALUE ELSE NULL END,
					PTCN.TaxFlag = TFD.TAXFLAG
				FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCN
					INNER JOIN #TEMP_FMV_DETAILS_NEW TFD ON TFD.INSTRUMENT_ID = PTCN.MIT_ID 
				WHERE 
					(TFD.EMPLOYEE_ID = PTCN.EmployeeID) AND (TFD.GRANTOPTIONID = PTCN.GrantOptionId) AND 
					(CONVERT(DATE, TFD.GRANTDATE) = CONVERT(DATE, PTCN.GrantDate)) AND (CONVERT(DATE, TFD.VESTINGDATE) = CONVERT(DATE, PTCN.VestingDate)) AND 
					(CONVERT(DATE, TFD.EXERCISE_DATE) = CONVERT(DATE, PTCN.ExerciseDate))										
			END					
		END
							
	END
	
	-------------------------------------------------------------------
	-- CASE 5 : GET DETAILS FROM EXERCISED TABLE FOR ISSARAPPLIED = 'N'
	-------------------------------------------------------------------
	
	IF(@CASE_5_#PERQUISITE_TAX_CALCULATION_EXED_N = '1')
	BEGIN
	
		/*===== CALCULATE FMV =====*/
		
		IF((SELECT COUNT(ExercisedId) FROM [VW_PERQUISITE_TAX_CALCULATION_EXERCISED] AS VW WHERE (UPPER(VW.Apply_SAR) = 'N')) > 0)
		BEGIN
			
			DECLARE @CASE_5_TYPE_FMV_VALUE dbo.TYPE_FMV_VALUE
		    
			INSERT INTO @CASE_5_TYPE_FMV_VALUE 
			SELECT 
				MIT_ID, LoginID, GrantOptionId, GrantDate, VestingDate, ExercisedDate, 'A' 
			FROM 
				[VW_PERQUISITE_TAX_CALCULATION_EXERCISED] VW 
			
			--INSERT INTO #TEMP_FMV_DETAILS_NEW (ID ,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG,TAXFLAG_HEADER )
			EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @CASE_5_TYPE_FMV_VALUE
			

		     INSERT INTO #TEMP_FMV_DETAILS_NEW (ID ,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG,TAXFLAG_HEADER )
	         SELECT ID, INSTRUMENT_ID, EMPLOYEE_ID, GRANTOPTIONID, GRANTDATE, VESTINGDATE, EXERCISE_DATE, 
			 FMV_VALUE, TAXFLAG , TAXFLAG_HEADER FROM TEMP_FMV_DETAILS
			/*======================================================*/

			INSERT INTO #PERQUISITE_TAX_CALCULATION_EXED_N
			(
				TaxUploadCase, ExerciseId, ExerciseNo, GrantLegSerialNumber, SchemeId, GrantOptionId, EmployeeID, ExercisedQuantity, ExercisePrice, SharesIssuedDate, 
				Cash, ExerciseDate, GrantDate, Apply_SAR, ResidentialStatus, Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, PERQTAXRATE, 
				CALCPERQPARAM, EmployeeName, EmployeeEmail, EmpTaxSlab, MIT_ID, VestedOptions, GrantedOptions, VestingDate, LoginID
			)
			SELECT 
				'CASE5', ExercisedId, ExerciseNo, GrantLegSerialNumber, SchemeId, VW.GrantOptionId, EmployeeID, ExercisedQuantity, ExercisedPrice, SharesIssuedDate, 
				Cash, ExercisedDate, VW.GrantDate, Apply_SAR, ResidentialStatus, Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, dbo.FN_PQ_TAX_ROUNDING(PERQTAXRATE), 
				(CASE WHEN (CALCPERQVAL='Y') AND (CALCPERQTAX='Y') THEN 'B'  
						WHEN (CALCPERQVAL='Y') AND (CALCPERQTAX='N' OR CALCPERQTAX IS NULL ) THEN 'V'   
						ELSE 'F'  
				END) AS CALCPERQPARAM, EmployeeName, EmployeeEmail, Apply_Emp_taxslab, VW.MIT_ID, VW.ExercisableQuantity, GrantedOptions, VW.VestingDate, LoginID
			FROM 
				[VW_PERQUISITE_TAX_CALCULATION_EXERCISED] AS VW
							
			-- UPDATE FMVSHARE PRICE					
			UPDATE PTCEN SET 
				PTCEN.FMVPrice = CASE WHEN TFD.TAXFLAG = 'A' THEN TFD.FMV_VALUE ELSE NULL END,
				PTCEN.TaxFlag = TFD.TAXFLAG
			FROM #PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEN
				INNER JOIN #TEMP_FMV_DETAILS_NEW TFD ON TFD.INSTRUMENT_ID = PTCEN.MIT_ID 
			WHERE 
				(TFD.EMPLOYEE_ID = PTCEN.EmployeeID) AND (TFD.GRANTOPTIONID = PTCEN.GrantOptionId) AND 
				(CONVERT(DATE, TFD.GRANTDATE) = CONVERT(DATE, PTCEN.GrantDate)) AND (CONVERT(DATE, TFD.VESTINGDATE) = CONVERT(DATE, PTCEN.VestingDate)) AND 
				(CONVERT(DATE, TFD.EXERCISE_DATE) = CONVERT(DATE, PTCEN.ExerciseDate))	
	END
		
	---------------------------------------------------------------------
	---- CASE 7 : SEND PERQUISITE TAX MAIL AFTER EXERCISE
	---------------------------------------------------------------------
	
	IF((@CASE_7_#PERQUISITE_TAX_CALCULATION_HUL = '1') AND (UPPER(@COMPANY_ID) = 'HUL'))
	BEGIN
		IF ((SELECT COUNT(FMVPrice) FROM ShExercisedOptions WHERE (FMVPrice IS NOT NULL) AND (isExerciseMailSent IS NULL) AND (CONVERT(DATE,ExerciseDate)  = CONVERT(DATE, GETDATE()-1)))>0)
		BEGIN
			INSERT INTO #PERQUISITE_TAX_CALCULATION_HUL 
			(
				H_TaxUploadCase, H_ExerciseId, H_ExerciseNo, H_GrantLegSerialNumber, H_SchemeId, H_GrantOptionId, H_EmployeeID, 
				H_ExercisedQuantity, H_ExercisePrice, H_SharesIssuedDate, H_Cash, H_ExerciseDate, H_GrantDate, H_IsMassUpload, 
				H_Apply_SAR, H_ResidentialStatus, H_PERQTAXRATE, H_FMVPrice, H_Preq_Value, H_Preq_Payable, H_EmployeeName, 
				H_EmployeeEmail, H_ExerciseCost
			)
			SELECT 'CASE7' AS TaxUploadCase, SEO.ExerciseId, SEO.ExerciseNo, SEO.GrantLegSerialNumber, GL.SchemeId, GL.GrantOptionId, SEO.EmployeeID,
					SEO.ExercisedQuantity, SEO.ExercisePrice, SEO.SharesIssuedDate, SEO.Cash, SEO.ExerciseDate, GR.GrantDate, SEO.IsMassUpload,						
					ISNULL(GR.Apply_SAR,'N') AS Apply_SAR, EM.ResidentialStatus, dbo.FN_PQ_TAX_ROUNDING(SEO.Perq_Tax_rate), SEO.FMVPrice,SEO.PerqstValue, SEO.PerqstPayable, EM.EmployeeName,
					EM.EmployeeEmail, (SEO.ExercisedQuantity * SEO.ExercisePrice) AS H_ExerciseCost 						
			FROM ShExercisedOptions SEO 
			INNER JOIN EmployeeMaster EM ON SEO.EMPLOYEEID = EM.EMPLOYEEID
			INNER JOIN GrantLeg AS GL ON SEO.GrantLegSerialNumber = GL.ID
			INNER JOIN GrantRegistration AS GR ON GL.GrantRegistrationId = GR.GrantRegistrationId 
			WHERE (SEO.FMVPrice IS NOT NULL) AND (SEO.isExerciseMailSent IS NULL) AND (CONVERT(DATE,SEO.ExerciseDate)  = CONVERT(DATE, GETDATE()-1))						
		END
		
	END
	
	--======================================================================================================
	-- CALCULATE PERQUISITE VALUE
	--======================================================================================================
	
	BEGIN
	
		--============================================
		-- CASE 1
		--============================================
		
		IF(@CASE_1_#PERQUISITE_TAX_CALCULATION_N_N_CASH = '1')
		BEGIN		
			IF((SELECT COUNT(ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH) > 0)			
			BEGIN
			
				BEGIN /* ===== CALCULATE PERQUISITE VALUE ===== */
					
					
					
					--INSERT INTO #TEMP_FMV_DETAILS_NEW (ID ,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG )
					--SELECT ID,INSTRUMENT_ID ,EMPLOYEE_ID  ,GRANTOPTIONID ,GRANTDATE,VESTINGDATE,EXERCISE_DATE ,FMV_VALUE ,TAXFLAG   FROM #TEMP_FMV_DETAILS_NEW
					
					DECLARE @CASE_1_TYPE_PERQ_VALUE dbo.TYPE_PERQ_VALUE
					
					INSERT INTO @CASE_1_TYPE_PERQ_VALUE 
					SELECT 
						MIT_ID, LoginID, ExercisePrice, VestedOptions, FMVPrice, ExercisedQuantity, GrantedOptions, ExerciseDate, 
						GrantOptionId, GrantDate, VestingDate, GrantLegSerialNumber, NULL, NULL, ExerciseId  
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH				
					EXEC PROC_GET_PERQUISITE_VALUE  @EMPLOYEE_DETAILS = @CASE_1_TYPE_PERQ_VALUE, @CalledFrom =NULL,@IS_TASKSCHEDULAR = 1
					UPDATE PTCN SET 
						PTCN.FMVPrice = dbo.FN_ROUND_VALUE(FMVPrice, @RoundingParam_FMV, @RoundupPlace_FMV),
						PTCN.Preq_Value = dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal),
						PTCN.ExerciseCost = ExercisedQuantity * ExercisePrice,
						PTCN.EventOfIncidence = TPD.EVENTOFINCIDENCE,
						PTCN.ShareAriseApprValue =
						CASE
						WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN  ISNULL(CEILING( TPD.SHARE_APPRECIATION_VALUE),0)					   
					    WHEN (SH.ROUNDING_UP = 1) THEN ISNULL(CEILING( TPD.SHARE_APPRECIATION_VALUE),0)					   
					    WHEN SH.ROUNDING_UP = 0  THEN ISNULL(FLOOR( TPD.SHARE_APPRECIATION_VALUE),0)				   
					    ELSE ISNULL(TPD.SHARE_APPRECIATION_VALUE,0) END 
					   
						,PTCN.CashPayoutValue = TPD.CASHPAYOUT_VALUE					
					FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCN
						INNER JOIN TEMP_PERQUISITE_DETAILS TPD ON TPD.INSTRUMENT_ID = PTCN.MIT_ID
						INNER JOIN  Scheme as SH on SH.SchemeId = PTCN.SchemeId
						--INNER JOIN #TEMP_FILTERED_RECORD AS FR ON FR.INSTRUMENT_ID = PTCN.MIT_ID
					WHERE 
						(TPD.EMPLOYEE_ID = PTCN.EmployeeID) AND (TPD.EXERCISE_PRICE = PTCN.ExercisePrice) AND 
						(TPD.OPTION_VESTED = PTCN.VestedOptions) AND (TPD.FMV_VALUE = PTCN.FMVPrice) AND 
						(TPD.OPTION_EXERCISED = PTCN.ExercisedQuantity) AND (TPD.GRANTED_OPTIONS = PTCN.GrantedOptions) AND 
						(CONVERT(DATE, TPD.EXERCISE_DATE) = CONVERT(DATE, PTCN.ExerciseDate)) AND (PTCN.GrantOptionId = TPD.GRANTOPTIONID) AND 
						(CONVERT(DATE, PTCN.GrantDate) = CONVERT(DATE, TPD.GRANTDATE)) AND (CONVERT(DATE, PTCN.VestingDate) = CONVERT(DATE, TPD.VESTINGDATE))

                  	/* ADD DATA TO TYPE */
					DECLARE @CASE_1_@PERQ_VALUE_RESULT dbo.TYPE_PERQ_FORAUTOEXERCISE
					
					INSERT INTO @CASE_1_@PERQ_VALUE_RESULT
					SELECT 
						INSTRUMENT_ID, EMPLOYEE_ID, FMV_VALUE, PERQ_VALUE, EVENTOFINCIDENCE, CONVERT(date, GRANTDATE), CONVERT(date, VESTINGDATE), 
						CONVERT(date, EXERCISE_DATE), GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID,STOCK_VALUE						
					FROM 
						TEMP_PERQUISITE_DETAILS
					
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')
					BEGIN
						DROP TABLE TEMP_PERQUISITE_DETAILS
					END
					
				END
				
				/* ====================================== */
				
				BEGIN /* ===== CALCULATE PROPORTIONATE TAX ===== */
											
					CREATE TABLE #CASE_1_TAX_CALCULATION
					( 
						TAX_HEADING NVARCHAR(50), TAX_RATE FLOAT, RESIDENT_STATUS NVARCHAR(250), TAX_AMOUNT FLOAT, Country NVARCHAR(250),
						[STATE] NVARCHAR(250), BASISOFTAXATION NVARCHAR(250), FMV NVARCHAR(250), TOTAL_PERK_VALUE FLOAT, COUNTRY_ID INT, 
						MIT_ID INT, EmployeeID VARCHAR(50), GRANTOPTIONID VARCHAR(50), VESTING_DATE DATETIME,
						GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TAX_FLAG NCHAR(1), EXERCISE_ID BIGINT,EXERCISEDATE DATETIME
					)
					
				
					DECLARE @CASE_1_@PERQ_VALUE_TYPE_AUTO_EXE dbo.TYPE_PERQ_VALUE_AUTO_EXE
					
					INSERT INTO @CASE_1_@PERQ_VALUE_TYPE_AUTO_EXE 
					SELECT 
						MIT_ID, LoginID, ExercisePrice, ExercisedQuantity, FMVPrice, ExercisedQuantity, GrantedOptions, 
						ExerciseDate, GrantOptionId, GrantDate, VestingDate, GrantLegSerialNumber, NULL, NULL, ExerciseId
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH
					
					EXEC PROC_GET_TAXFORAUTOEXERCISE @PERQ_DETAILS = @CASE_1_@PERQ_VALUE_TYPE_AUTO_EXE, @PERQ_RESULT = @CASE_1_@PERQ_VALUE_RESULT
					
					INSERT INTO #CASE_1_TAX_CALCULATION
					(
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, EXERCISE_ID ,EXERCISEDATE 
					)
					SELECT 
						TGTD.TAX_HEADING, TGTD.TAX_RATE, TGTD.RESIDENT_STATUS, TGTD.TAX_AMOUNT, TGTD.Country, TGTD.[STATE], 
						TGTD.BASISOFTAXATION, TGTD.FMV, TGTD.TOTAL_PERK_VALUE, TGTD.COUNTRY_ID, TGTD.MIT_ID, TGTD.EmployeeID, TGTD.GRANTOPTIONID, 
						TGTD.VESTING_DATE, TGTD.GRANTLEGSERIALNO, TGTD.FROM_DATE, TGTD.TO_DATE, TGTD.TEMP_EXERCISEID,CPVR.EXERCISE_DATE
					FROM 
						TEMP_GET_TAXDETAILS AS TGTD	INNER JOIN @CASE_1_@PERQ_VALUE_RESULT CPVR ON TGTD.TEMP_EXERCISEID=CPVR.TEMP_EXERCISEID 					
					
					/* UPDATE TAX FLAG */
					UPDATE 
						TC_1 SET TC_1.TAX_FLAG = TFD.TAXFLAG
					FROM #CASE_1_TAX_CALCULATION AS TC_1
						INNER JOIN #TEMP_FMV_DETAILS_NEW AS TFD ON TC_1.MIT_ID = TFD.INSTRUMENT_ID
					WHERE
						TC_1.EmployeeID = TFD.EMPLOYEE_ID AND TC_1.GRANTOPTIONID = TFD.GRANTOPTIONID AND CONVERT(DATE,TC_1.VESTING_DATE) =  CONVERT(DATE,TFD.VESTINGDATE) AND (CONVERT(DATE, TFD.EXERCISE_DATE) = CONVERT(DATE, TC_1.ExerciseDate))
					
					/* SELECT CASE_1_TAX_CALCULATION */
					SELECT
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID 
					FROM 
						#CASE_1_TAX_CALCULATION
					
					-- UPDATE PERQUISITE PAYABLE INTO TAMP TABLE WITH ROUNDING VALUE	
					
					CREATE TABLE #CASE_1_TEMP_CAL_PERQPAYABLE 
					(
						EXERCISE_ID BIGINT, PERQ_PAYABLE NUMERIC (18,6)
					)			
					
					INSERT INTO #CASE_1_TEMP_CAL_PERQPAYABLE (EXERCISE_ID, PERQ_PAYABLE)
					SELECT 
						MAX(EXERCISE_ID), SUM(TAX_AMOUNT)
					FROM 
						#CASE_1_TAX_CALCULATION
					GROUP BY 
						EXERCISE_ID
					
					UPDATE PTCN SET 
						PTCN.Preq_Payable = (SELECT dbo.FN_ROUND_VALUE(TTCP.PERQ_PAYABLE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal))
					FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCN
					INNER JOIN #CASE_1_TEMP_CAL_PERQPAYABLE AS TTCP ON TTCP.EXERCISE_ID = PTCN.ExerciseId 
					
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = '#TEMP_FMV_DETAILS_NEW')
					BEGIN
						DROP TABLE #TEMP_FMV_DETAILS_NEW
					END
					
					DROP TABLE #CASE_1_TEMP_CAL_PERQPAYABLE
					
					/*	
						PROVISION FOR 
						BETWEEN PRE VESTING AND NEXT DAY TAX CALCULATION IF EMPLOYEE MOMENT HAPPENED THEN INSERT TAX FOR 
						NEW RECORDS AND UPDATE FOR EXISTING RECORDS
					*/
					
					
					INSERT INTO #CASE_1_TAX_CALCULATION_NEW_DATA
					(
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID  
					)
					SELECT
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID
					FROM #CASE_1_TAX_CALCULATION
					
					DELETE 
						C1TCND 
					FROM
					#CASE_1_TAX_CALCULATION_NEW_DATA AS C1TCND
					INNER JOIN EXERCISE_TAXRATE_DETAILS AS ETD ON ETD.GRANTLEGSERIALNO = C1TCND.GRANTLEGSERIALNO					
					WHERE 
						(ETD.EXERCISE_NO = C1TCND.EXERCISE_ID) AND (ETD.COUNTRY_ID = C1TCND.COUNTRY_ID) AND
						(UPPER(ETD.Tax_Title)=UPPER(C1TCND.TAX_HEADING)) AND (C1TCND.GRANTLEGSERIALNO IS NOT NULL)	AND						
						(CONVERT(DATE,ISNULL( ETD.FROM_DATE,'')) = CONVERT(DATE,ISNULL(C1TCND.FROM_DATE,'')))
				END
				
				/* ====================================== */				
				
				BEGIN /* ===== SAR CALCULATION ===== */
	
					DECLARE @SAR_SETTLEMENT_PRICE dbo.TYPE_SAR_SETTLEMENT_PRICE 
					
					INSERT INTO @SAR_SETTLEMENT_PRICE 
					SELECT 
						PTCNNC.MIT_ID, PTCNNC.EmployeeId, PTCNNC.GrantDate, PTCNNC.VestingDate, PTCNNC.ExerciseDate, PTCNNC.ExercisePrice, 
						PTCNNC.SchemeId, PTCNNC.GrantOptionId
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC
						INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCNNC.MIT_ID
					WHERE 
						(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
					
					EXEC PROC_GET_SAR_SETTELEMENT_PRICCE @EMPLOYEE_SAR_DETAILS = @SAR_SETTLEMENT_PRICE
					
					/* UPDATE SAR SETTLEMENT PRICES */
					UPDATE PTCNNC SET 
						PTCNNC.SettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END						
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC
						INNER JOIN TEMP_SAR_SETTLEMENT_FINAL_DETAILS AS TSSFD ON TSSFD.INSTRUMENT_ID = PTCNNC.MIT_ID 
					WHERE 
						(TSSFD.EMPLOYEE_ID = PTCNNC.EmployeeId) AND (CONVERT(DATE, TSSFD.EXERCISE_DATE) = CONVERT(DATE, PTCNNC.ExerciseDate)) AND 
						(TSSFD.GRANTOPTIONID = PTCNNC.GrantOptionId) AND (CONVERT(DATE, TSSFD.GRANTDATE) = CONVERT(DATE, PTCNNC.GrantDate)) AND 
						(CONVERT(DATE, TSSFD.VESTINGDATE) = CONVERT(DATE, PTCNNC.VestingDate)) 
				END
				
				/* ====================================== */
				
				BEGIN /* ===== UPDATE SAR STOCK APPRECIATION CALCULATION ===== */
				
					DECLARE @SAR_STOCK_APPRECIATION dbo.TYPE_SAR_STOCK_APPRECIATION	
					
					INSERT INTO @SAR_STOCK_APPRECIATION 
					SELECT 
						PTCNNC.MIT_ID, PTCNNC.EmployeeId, PTCNNC.ExercisePrice, PTCNNC.ExercisedQuantity, PTCNNC.ExercisedQuantity, 
						PTCNNC.ExerciseDate, PTCNNC.GrantOptionId, PTCNNC.GrantDate, PTCNNC.VestingDate,PTCNNC.ExerciseId
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC
						INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCNNC.MIT_ID
					WHERE (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
					IF EXISTS(SELECT COUNT(*) FROM @SAR_STOCK_APPRECIATION)
					BEGIN
						--INSERT INTO #STOCK_APPRECIATION_DETAILS_TEMP
						--(
						--	INSTRUMENT_ID, EMPLOYEE_ID, STOCK_APPRECIATION_VALUE, EVENTOFINCIDENCE, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, 
						--	OPTION_EXERCISED, GRANTOPTIONID, GRANTDATE ,VESTINGDATE, TAXFLAG,TAXFLAG_HEADER 
						--)
						EXEC PROC_GET_SAR_STOCK_APPRECIATION @EMPLOYEE_SAR_APPRECIATION = @SAR_STOCK_APPRECIATION		
					
					     INSERT INTO #STOCK_APPRECIATION_DETAILS_TEMP
					 	(
							INSTRUMENT_ID, EMPLOYEE_ID,EXERCISE_PRICE ,OPTION_VESTED,EXERCISE_DATE,EVENTOFINCIDENCE,OPTION_EXERCISED,GRANTOPTIONID, GRANTDATE ,VESTINGDATE,
							STOCK_APPRECIATION_VALUE,TAXFLAG,TAXFLAG_HEADER 
						)		
						SELECT INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, EVENTOFINCIDENCE,OPTION_EXERCISED,
						GRANTOPTIONID, GRANTDATE, VESTINGDATE,ISNULL( STOCK_APPRECIATION_VALUE,0),TAXFLAG,TAXFLAG_HEADER FROM TEMP_STOCK_APPRECIATION_DETAILS

					
					END
					/* UPDATE SAR STOCK APPRECIATION PRICES */
					
					UPDATE PTCNNC SET 
						PTCNNC.StockApprValue = CASE TSAD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC
						INNER JOIN #STOCK_APPRECIATION_DETAILS_TEMP AS TSAD ON TSAD.INSTRUMENT_ID = PTCNNC.MIT_ID 
					WHERE 
						(TSAD.EMPLOYEE_ID = PTCNNC.EmployeeId) AND (TSAD.OPTION_EXERCISED = PTCNNC.ExercisedQuantity) AND 
						(CONVERT(DATE, TSAD.EXERCISE_DATE) = CONVERT(DATE, PTCNNC.ExerciseDate)) AND (TSAD.GRANTOPTIONID = PTCNNC.GrantOptionId) AND 
						(CONVERT(DATE, TSAD.GRANTDATE) = CONVERT(DATE, PTCNNC.GrantDate)) AND (CONVERT(DATE, TSAD.VESTINGDATE) = CONVERT(DATE, PTCNNC.VestingDate)) 



						DECLARE @TYPE_CASHPAYOUT_VALUE dbo.TYPE_CASHPAYOUT_VALUE
	 DECLARE @CASHPAYOUT NUMERIC(18, 9) 
	 INSERT INTO @TYPE_CASHPAYOUT_VALUE     
		SELECT     
			TAED.MIT_ID, TAED.LoginID, TAED.SettlmentPrice,TAED.ExercisePrice,TAED.SchemeId,TAED.FMVPrice,(SELECT  MAX(CP.FaceVaue) FROM CompanyParameters CP ) ,
			TAED.ExercisedQuantity,TAED.ShareAriseApprValue,
			TAED.GrantOptionId,TAED.GrantLegSerialNumber,TAED.ExerciseDate,TAED.ExerciseId   	    
		FROM     
		#PERQUISITE_TAX_CALCULATION_N_N_CASH AS TAED    
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID    
		 WHERE     
		(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1) 

	/* CASH PAYOUT VALUE */	
	
	CREATE TABLE #TEMP_FINALCASHPAYOUTDETAILS     
	(     
	    ID INT IDENTITY(1,1) NOT NULL,MIT_ID BIGINT, EMPLOYEE_ID  VARCHAR(50), EXERCISE_DATE  DATETIME,CASHPAYOUT_VALUE  NUMERIC(18, 9) NULL, SCHEME_ID NVARCHAR(100), GRANTOPTIONID NVARCHAR(100),TEMP_EXERCISEID BIGINT NULL
	)
	
	INSERT INTO #TEMP_FINALCASHPAYOUTDETAILS
	(
		MIT_ID , EMPLOYEE_ID , EXERCISE_DATE  ,CASHPAYOUT_VALUE  , SCHEME_ID , GRANTOPTIONID,TEMP_EXERCISEID 
	)
	EXEC GET_CASHPAYOUT_VALUE @EMPLOYEE_DETAILS =@TYPE_CASHPAYOUT_VALUE

 --select 'ss' ,* from  #TEMP_FINALCASHPAYOUTDETAILS
	/* Adjustment Stock appreciation End*/
		  
	  UPDATE TAED SET    
	   TAED.CashPayoutValue =     
	   CASE WHEN TAED.MIT_ID = 6 THEN           
		CASE WHEN (SCH.ROUNDING_UP IS NULL and SCH.FRACTION_PAID_CASH IS NULL)  THEN 0 
		WHEN (SCH.FRACTION_PAID_CASH IS NULL)  THEN Null     
		  WHEN (SCH.ROUNDING_UP = 1) THEN 0 WHEN SCH.ROUNDING_UP = 0  THEN     
		 CASE WHEN SCH.FRACTION_PAID_CASH = 1 THEN      
		   FCPD.CASHPAYOUT_VALUE
			--(ISNULL(TAED.SettlmentPrice,0) - ISNULL(TAED.ExercisePrice,0)) * (ISNULL(TAED.StockApprValue,0) - ISNULL(FLOOR(TAED.ShareAppriciation),0))           
		  ELSE     
		   0     
		 END     
		END        
	   ELSE    
		ISNULL(TAED.StockApprValue,0) - ISNULL(TAED.Preq_Payable,0)    
	   END   ,
	   TAED.ShareAriseApprValue =  TAED.ShareAriseApprValue     
	 FROM     
	   #PERQUISITE_TAX_CALCULATION_N_N_CASH AS TAED    
	   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID    
	   INNER JOIN  Scheme AS SCH ON SCH.SchemeId = TAED.SchemeId 
	   INNER JOIN #TEMP_FINALCASHPAYOUTDETAILS AS FCPD ON FCPD.MIT_ID=TAED.MIT_ID 
	   AND FCPD.SCHEME_ID=TAED.SchemeId 
	   AND FCPD.TEMP_EXERCISEID=TAED.ExerciseId 
	   AND FCPD.GRANTOPTIONID=TAED.GrantOptionId
	  WHERE     
	   (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1) 


					--UPDATE PTCNNC SET
					--	PTCNNC.CashPayoutValue =  
					--	CASE WHEN PTCNNC.MIT_ID = 6
					--	 THEN 
					--	 PTCNNC.CashPayoutValue  
					--	 ELSE  
					--	 ISNULL(PTCNNC.StockApprValue,0) - ISNULL(PTCNNC.Preq_Payable,0)	END				
					--FROM 
					--	#PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC
					--	INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCNNC.MIT_ID
					--	INNER JOIN  Scheme as SH on SH.SchemeId = PTCNNC.SchemeId
					--WHERE 
					--	(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
						
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_FINAL_DETAILS')
					BEGIN
						DROP TABLE TEMP_SAR_SETTLEMENT_FINAL_DETAILS
					END
					
					

				END
				
				/* ====================================== */
				
				IF((SELECT COUNT(ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH) > 0)	
				BEGIN
					SELECT 
						TaxUploadCase, ExerciseId, ExerciseNo, GrantLegSerialNumber, SchemeId, GrantOptionId, EmployeeID, ExercisedQuantity, 
						ExercisePrice, SharesIssuedDate, Cash, ExerciseDate, GrantDate, IsMassUpload, Apply_SAR, ResidentialStatus, 
						Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, PERQTAXRATE, CALCPERQPARAM, FMVPrice, Preq_Value, 
						Preq_Payable, EmployeeName, EmployeeEmail, ExerciseCost, EmpTaxSlab, MIT_ID, VestedOptions, GrantedOptions, 
						VestingDate, EventOfIncidence, TaxFlag, StockApprValue, CashPayoutValue, SettlmentPrice
					FROM 
						#PERQUISITE_TAX_CALCULATION_N_N_CASH 
					WHERE 
						(FMVPrice IS NOT NULL) 
				END
			/*=========ENTITY=====================*/
	BEGIN		
			 -- INSERT ENTITY DATA --	
		DECLARE  @CurrentDate NVARCHAR(50)					
		UPDATE ED SET ED.EntityConfigurationBaseOn = CIM.EntityBaseOn,ED.IsActiveEntity =CIM.ISActivedforEntity 
		FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH AS ED
		INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON ED.MIT_ID=CIM.MIT_ID
	IF EXISTS (SELECT COUNT(ISACTIVEENTITY) FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH WHERE ISACTIVEENTITY=1)	
	   BEGIN TRY
	   BEGIN 
  
		  DECLARE @EMP_ID dbo.TYPE_EMPLOYEE_DATA_ENTITY
		  INSERT INTO @EMP_ID   
		  SELECT   
				 TAED.EmployeeID
		  FROM   			 
			  #PERQUISITE_TAX_CALCULATION_N_N_CASH AS TAED
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
			
			BEGIN
				--FOR VESTING DATE --				
					UPDATE ED SET ED.Entity = TFD.ENTITY_ID,ED.EntityBaseOn = ED.EntityConfigurationBaseOn					 
					FROM  #PERQUISITE_TAX_CALCULATION_N_N_CASH	AS ED		
					INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,ED.VestingDate)) >= CONVERT(DATE,TED.FROMDATE)
					AND (CONVERT(DATE,ED.VestingDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
					INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
					WHERE ED.IsActiveEntity='1' and ED.EntityConfigurationBaseOn='1001'
			
				  --FOR EXERCISE DATE --				
				 UPDATE ED SET ED.Entity = TFD.ENTITY_ID,ED.EntityBaseOn = ED.EntityConfigurationBaseOn
					FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH AS ED
					INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,ExerciseDate)) >= CONVERT(DATE, ISNULL(TED.FROMDATE,TED.TODATE))
					AND (CONVERT(DATE,ExerciseDate)) <= (CONVERT(DATE, ISNULL(TED.TODATE, ExerciseDate))))
					INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
					WHERE ED.IsActiveEntity='1' and ED.EntityConfigurationBaseOn='1002'	

				   --FOR GRANT DATE --				
				 UPDATE ED SET ED.Entity = TFD.ENTITY_ID,ED.EntityBaseOn = ED.EntityConfigurationBaseOn
				 FROM  #PERQUISITE_TAX_CALCULATION_N_N_CASH	AS ED
				 INNER JOIN #TEMP_ENTITY_DATA AS TED ON TED.EmployeeId=ED.EmployeeID And ((CONVERT(DATE,ED.GRANTDATE)) >= CONVERT(DATE,TED.FROMDATE)
				 AND (CONVERT(DATE,ED.GRANTDATE)) <= (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))))
				 INNER JOIN #TEMP_FILTER_DATA AS TFD ON TFD.FIELD = TED.ENTITY
				 WHERE ED.IsActiveEntity='1' and ED.EntityConfigurationBaseOn='1003'				
			END
			         
		END 
	  END TRY  
	BEGIN CATCH  
	   -- ROLLBACK TRANSACTION  
		SELECT  ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure,   
		   ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;   
	   END CATCH 
  END
			/*===========END======================*/	
				BEGIN /* ============ UPDATE IN ACTUAL TABLE ============ */
					-- UPDATE DETAILS IN SHEXERCISE OPTION TABLE
					UPDATE SHEO SET 
						SHEO.FMVPrice = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.FMVPrice ELSE NULL END, 
						SHEO.PerqstValue = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.Preq_Value ELSE NULL END,  
						SHEO.PerqstPayable = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.Preq_Payable ELSE NULL END, 
						SHEO.Perq_Tax_rate = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.PERQTAXRATE ELSE NULL END,
						SHEO.StockApprValue = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.StockApprValue ELSE NULL END,
						SHEO.SettlmentPrice = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.SettlmentPrice ELSE NULL END,
						SHEO.CashPayoutValue = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.CashPayoutValue ELSE NULL END,
						SHEO.ShareAriseApprValue = CASE PTCNNC.TaxFlag WHEN 'A' THEN PTCNNC.ShareAriseApprValue ELSE NULL END,
						SHEO.LastUpdatedBy = 'ADMIN', SHEO.LastUpdatedOn = GETDATE(),
					    SHEO.ENTITY=PTCNNC.Entity,SHEO.EntityBaseOn=PTCNNC.EntityBaseOn
					FROM 
						ShExercisedOptions AS SHEO
						INNER JOIN #PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC ON SHEO.ExerciseId = PTCNNC.ExerciseId
					WHERE 
						(PTCNNC.FMVPrice IS NOT NULL)								
					
					-- UPDATE DETAILS IN EXERCISE_TAXRATE_DETAILS
					
					UPDATE ETD SET
						ETD.FMVVALUE = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.FMV ELSE NULL END,
						ETD.TAX_AMOUNT = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.TAX_AMOUNT ELSE NULL END, 
						ETD.PERQVALUE = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.TOTAL_PERK_VALUE ELSE NULL END,
						UPDATED_BY = 'ADMIN', UPDATED_ON = GETDATE()
					FROM 
						EXERCISE_TAXRATE_DETAILS AS ETD
						INNER JOIN #CASE_1_TAX_CALCULATION AS TC ON ETD.GRANTLEGSERIALNO = TC.GRANTLEGSERIALNO					
					WHERE 
						(ETD.EXERCISE_NO = TC.EXERCISE_ID) AND (ETD.COUNTRY_ID = TC.COUNTRY_ID) AND
						(UPPER(ETD.Tax_Title)=UPPER(TC.TAX_HEADING)) AND (TC.GRANTLEGSERIALNO IS NOT NULL) AND
						(CONVERT(DATE,ISNULL( ETD.FROM_DATE,'')) = CONVERT(DATE,ISNULL(TC.FROM_DATE,'')))
					
					/* UPDATE IN TAX TABLE */
					IF((SELECT COUNT(EXERCISE_ID) AS ROW_COUNT FROM #CASE_1_TAX_CALCULATION_NEW_DATA) > 0)
					BEGIN
						INSERT INTO [EXERCISE_TAXRATE_DETAILS]
						(
							EXERCISE_NO, COUNTRY_ID, RESIDENT_ID, Tax_Title, BASISOFTAXATION, TAX_RATE, TAX_AMOUNT, TENTATIVETAXAMOUNT, 
							GRANTLEGSERIALNO, FMVVALUE, TENTATIVEFMVVALUE, PERQVALUE, TENTATIVEPERQVALUE, FROM_DATE, TO_DATE, 
							CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON
						)
						SELECT
							EXERCISE_ID, COUNTRY_ID, RESIDENT_STATUS, TAX_HEADING, BASISOFTAXATION, TAX_RATE, 
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TAX_AMOUNT ELSE NULL END, NULL, GRANTLEGSERIALNO, 				
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN FMV ELSE NULL END, NULL, 
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TOTAL_PERK_VALUE ELSE NULL END, NULL,
							FROM_DATE, TO_DATE, 'ADMIN', GETDATE(), 'ADMIN', GETDATE()						
						FROM 
							#CASE_1_TAX_CALCULATION_NEW_DATA           
					END
				END
				-- PREPARED MAIL BODY AND SUBJECT				
				
				IF((SELECT COUNT(ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH) > 0)	
				BEGIN	
					
					IF (UPPER(@SendPerqMail) = 'Y')
					BEGIN					
						
						-- SELECT QUERY IS USED FOR DESIGN MAIL FORMAT
						SELECT * INTO #OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH 
						WHERE (FMVPrice IS NOT NULL) AND ((LEN(Preq_Value) > 0) AND (LEN(Preq_Payable)>0))
						
						SET @MailSubject = '' 					SET @MailBody = ''
						SET @MaxMsgId = ''						SET @HULMailBody = ''
						
						SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'PERQTAXCASHMAILALERT'
						SELECT @HULMailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'PERQTAXCASHMAILALERTHUL'
						
						-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
						
						SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
						
						BEGIN
							DBCC CHECKIDENT(#PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL, RESEED, @MaxMsgId)
						END
						
						INSERT INTO #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL 
						(	
							M_TaxUploadCase, M_ExerciseNo, M_EmployeeName, M_EmployeeEmail, M_ExerciseID, M_ExercisedQuantity, M_GrantDate, 
							M_ExercisePrice, M_ExerciseDate, M_FMVPrice, M_PERQTAXRATE, M_Preq_Value, M_Preq_Payable, M_ExerciseCost, M_MailSubject, M_MailBody
						)																
						SELECT 'M_CASE1', ExerciseNo, EmployeeName + ' (Emp.ID:'+ EmployeeID + ')' AS EmployeeName, EmployeeEmail,
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), INNER_#TEMP_DATA.ExerciseId) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) ExerciseId,
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), CONVERT(INT,INNER_#TEMP_DATA.ExercisedQuantity)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) ExercisedQuantity,			
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), REPLACE(CONVERT(VARCHAR(11), INNER_#TEMP_DATA.GrantDate, 106), ' ', '/')) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) GrantDate,			
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), INNER_#TEMP_DATA.ExercisePrice) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) ExercisePrice,				
						REPLACE(CONVERT(VARCHAR(11), ExerciseDate, 106), ' ', '/')  AS ExerciseDate,
						CONVERT(NUMERIC(18,2), FMVPrice) AS FMVPrice,
						dbo.FN_PQ_TAX_ROUNDING(CONVERT(NUMERIC(18,6), PERQTAXRATE)) AS PERQTAXRATE,
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), CONVERT(NUMERIC(18,2), INNER_#TEMP_DATA.Preq_Value)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) Preq_Value,
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), ISNULL(CONVERT(NUMERIC(18,2), INNER_#TEMP_DATA.Preq_Payable),0.00)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) Preq_Payable,
						SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), ISNULL(CONVERT(NUMERIC(18,0), INNER_#TEMP_DATA.ExerciseCost),0)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH INNER_#TEMP_DATA 
						WHERE (INNER_#TEMP_DATA.ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo)
						AND ((INNER_#TEMP_DATA.Preq_Payable IS NOT NULL) AND (INNER_#TEMP_DATA.Preq_Value IS NOT NULL))						
						ORDER BY INNER_#TEMP_DATA.Employeeid FOR XML PATH ('')),2,10000) ExerciseCost,
						@MailSubject, @MailBody
						FROM #OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH 			
						GROUP BY OUTER_PERQUISITE_TAX_CALCULATION_N_N_CASH.ExerciseNo, EmployeeName, EmployeeID, EmployeeEmail, ExerciseDate, FMVPrice, PERQTAXRATE
						
						SET @CC_TO = ''
						SET @HULSpecificNote1 = ''
						
						IF (UPPER(@COMPANY_ID) = 'HUL') 
							BEGIN
								SET @CC_TO = 'StockOptions.HLL@unilever.com'							
								SELECT @HULSpecificNote1 = MailBody FROM MailMessages WHERE UPPER(Formats)='PerqTaxMailHULNote1'
							END
						ELSE
							BEGIN
								SET @HULMailBody = ''
								SET @HULSpecificNote1 = ''
							END
						
						IF((SELECT COUNT(M_ExerciseNo) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL) > 0)	
						BEGIN											 
							SELECT M_TaxUploadCase, M_Message_ID, M_ExerciseNo, M_EmployeeName, M_EmployeeEmail, M_ExerciseID, M_ExercisedQuantity, M_GrantDate, M_ExercisePrice, M_ExerciseDate, 
							M_FMVPrice, M_PERQTAXRATE, M_Preq_Value, M_Preq_Payable, M_MailSubject, 
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(M_MailBody,'{0}',M_EmployeeName),'{1}', M_GrantDate),'{2}',M_ExercisedQuantity),'{3}',M_ExercisePrice),'{4}',M_ExerciseDate),'{5}',M_FMVPrice),'{6}',M_PERQTAXRATE),'{7}',M_Preq_Value),'{8}',M_Preq_Payable),'{#}',@HULMailBody),'{10}',M_PERQTAXRATE),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',M_ExerciseCost),'{8}',M_Preq_Payable)
							AS M_MailBody, M_ExerciseCost
							FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL  
							WHERE LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(M_MailBody,'{0}',M_EmployeeName),'{1}', M_GrantDate),'{2}',M_ExercisedQuantity),'{3}',M_ExercisePrice),'{4}',M_ExerciseDate),'{5}',M_FMVPrice),'{6}',M_PERQTAXRATE),'{7}',M_Preq_Value),'{8}',M_Preq_Payable),'{#}',@HULMailBody),'{10}',M_PERQTAXRATE),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',M_ExerciseCost),'{8}',M_Preq_Payable))>0
						END
						
						IF((SELECT COUNT(M_ExerciseNo) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL) > 0)	
						BEGIN
							-- INSSET INTO MAIL SPOOL TABLE
							INSERT INTO [MailerDB].[dbo].[MailSpool]
							([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
							SELECT M_Message_ID, @COMPANY_EMAIL_ID, M_EmployeeEmail, M_MailSubject, 
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(M_MailBody,'{0}',M_EmployeeName),'{1}', M_GrantDate),'{2}',M_ExercisedQuantity),'{3}',M_ExercisePrice),'{4}',M_ExerciseDate),'{5}',M_FMVPrice),'{6}',M_PERQTAXRATE),'{7}',M_Preq_Value),'{8}',M_Preq_Payable),'{#}',@HULMailBody),'{10}',M_PERQTAXRATE),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',M_ExerciseCost),'{8}',M_Preq_Payable)
							AS M_MailBody, NULL, NULL, NULL, NULL, NULL, @CC_TO, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() FROM #PERQUISITE_TAX_CALCULATION_N_N_CASH_MAIL
							WHERE (M_MailBody IS NOT NULL)

							-- UPDATE IS Exercise Mail Sent STATUS INTO SHEXERCISE OPTION TABLE
							UPDATE SHEO SET isExerciseMailSent ='Y' FROM ShExercisedOptions AS SHEO
							INNER JOIN #PERQUISITE_TAX_CALCULATION_N_N_CASH AS PTCNNC ON SHEO.ExerciseId = PTCNNC.ExerciseId																																																							
						END
					END
				END							
			END
		END
		
		--============================================
		-- CASE 5
		--============================================
		
		IF(@CASE_5_#PERQUISITE_TAX_CALCULATION_EXED_N = '1')
		BEGIN
			IF((SELECT COUNT(ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_EXED_N) > 0)
			BEGIN
				
				BEGIN /* ===== CALCULATE PERQUISITE VALUE ===== */
				
					DECLARE @CASE_5_TYPE_PERQ_VALUE dbo.TYPE_PERQ_VALUE
					
					INSERT INTO @CASE_5_TYPE_PERQ_VALUE 
					SELECT 
						MIT_ID, LoginID, ExercisePrice, VestedOptions, FMVPrice, ExercisedQuantity, GrantedOptions ,ExerciseDate, 
						GrantOptionId, GrantDate, VestingDate, GrantLegSerialNumber, NULL, NULL, ExerciseId 
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N
					
					
					EXEC PROC_GET_PERQUISITE_VALUE  @EMPLOYEE_DETAILS = @CASE_5_TYPE_PERQ_VALUE, @CalledFrom =NULL,@IS_TASKSCHEDULAR = 1
			
					
			
					-- UPDATE FMVSHARE PRICE, PERQUISITE VALUE INTO TAMP TABLE WITH ROUNDING VALUE
					UPDATE PTCEXDN SET 
						PTCEXDN.FMVPrice = dbo.FN_ROUND_VALUE(FMVPrice, @RoundingParam_FMV, @RoundupPlace_FMV),
						PTCEXDN.Preq_Value = dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal),
						PTCEXDN.ExerciseCost = ExercisedQuantity * ExercisePrice,
						PTCEXDN.EventOfIncidence = TPD.EVENTOFINCIDENCE,
					   PTCEXDN.ShareAriseApprValue =
					    CASE
						 WHEN (SH.ROUNDING_UP IS NULL and SH.FRACTION_PAID_CASH IS NULL)  THEN  ISNULL(CEILING( TPD.SHARE_APPRECIATION_VALUE),0)					   
					     WHEN (SH.ROUNDING_UP = 1) THEN ISNULL(CEILING( TPD.SHARE_APPRECIATION_VALUE),0)					   
					     WHEN SH.ROUNDING_UP = 0  THEN ISNULL(FLOOR( TPD.SHARE_APPRECIATION_VALUE),0)				   
					     ELSE ISNULL(TPD.SHARE_APPRECIATION_VALUE,0) END ,
						-- PTCEXDN.Old_ShareAriseApprValue =   dbo.[FN_GET_DECIMAL_SETTING_SHARE_VALUE]( TPD.SHARE_DECIMAL_VALUE)
						 PTCEXDN.CashPayoutValue = TPD.CASHPAYOUT_VALUE
						 
					FROM #PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEXDN
					INNER JOIN TEMP_PERQUISITE_DETAILS TPD ON TPD.EMPLOYEE_ID = PTCEXDN.EmployeeID
					INNER JOIN Scheme as SH on SH.SchemeId = PTCEXDN.SchemeId 
					WHERE TPD.INSTRUMENT_ID = PTCEXDN.MIT_ID AND TPD.EXERCISE_PRICE = PTCEXDN.ExercisePrice AND TPD.OPTION_VESTED = PTCEXDN.VestedOptions AND TPD.FMV_VALUE = PTCEXDN.FMVPrice AND TPD.OPTION_EXERCISED = PTCEXDN.ExercisedQuantity AND TPD.GRANTED_OPTIONS = PTCEXDN.GrantedOptions AND CONVERT(DATE, TPD.EXERCISE_DATE) = CONVERT(DATE, PTCEXDN.ExerciseDate)
						  AND PTCEXDN.GrantOptionId = TPD.GRANTOPTIONID AND CONVERT(date, PTCEXDN.GrantDate) = CONVERT(date, TPD.GRANTDATE) AND CONVERT(date, PTCEXDN.VestingDate) = CONVERT(date, TPD.VESTINGDATE)
					
					/* ADD DATA TO TYPE */
					DECLARE @CASE_5_@PERQ_VALUE_RESULT dbo.TYPE_PERQ_FORAUTOEXERCISE
					
					INSERT INTO @CASE_5_@PERQ_VALUE_RESULT
					SELECT 
						INSTRUMENT_ID, EMPLOYEE_ID, FMV_VALUE, PERQ_VALUE, EVENTOFINCIDENCE, CONVERT(date, GRANTDATE), CONVERT(date, VESTINGDATE), 
						CONVERT(date, EXERCISE_DATE), GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID,STOCK_VALUE						
					FROM 
						TEMP_PERQUISITE_DETAILS
									
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')
					BEGIN
						DROP TABLE TEMP_PERQUISITE_DETAILS
					END
				
				END
				/* ====================================== */
				
				BEGIN /* ===== CALCULATE PROPORTIONATE TAX ===== */
											
					CREATE TABLE #CASE_5_TAX_CALCULATION
					( 
						TAX_HEADING NVARCHAR(50), TAX_RATE FLOAT, RESIDENT_STATUS NVARCHAR(250), TAX_AMOUNT FLOAT, Country NVARCHAR(250),
						[STATE] NVARCHAR(250), BASISOFTAXATION NVARCHAR(250), FMV NVARCHAR(250), TOTAL_PERK_VALUE FLOAT, COUNTRY_ID INT, 
						MIT_ID INT, EmployeeID VARCHAR(50), GRANTOPTIONID VARCHAR(50), VESTING_DATE DATETIME,
						GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TAX_FLAG NCHAR(1), EXERCISE_ID BIGINT
					)
					
					CREATE TABLE #CASE_5_TAX_CALCULATION_NEW_DATA
					( 
						TAX_HEADING NVARCHAR(50), TAX_RATE FLOAT, RESIDENT_STATUS NVARCHAR(250), TAX_AMOUNT FLOAT, Country NVARCHAR(250),
						[STATE] NVARCHAR(250), BASISOFTAXATION NVARCHAR(250), FMV NVARCHAR(250), TOTAL_PERK_VALUE FLOAT, COUNTRY_ID INT, 
						MIT_ID INT, EmployeeID VARCHAR(50), GRANTOPTIONID VARCHAR(50), VESTING_DATE DATETIME,
						GRANTLEGSERIALNO BIGINT, FROM_DATE DATETIME, TO_DATE DATETIME, TAX_FLAG NCHAR(1), EXERCISE_ID BIGINT
					)
					
					DECLARE @CASE_5_@PERQ_VALUE_TYPE_AUTO_EXE dbo.TYPE_PERQ_VALUE_AUTO_EXE
					
					INSERT INTO @CASE_5_@PERQ_VALUE_TYPE_AUTO_EXE 
					SELECT 
						MIT_ID, LoginID, ExercisePrice, ExercisedQuantity, FMVPrice, ExercisedQuantity, GrantedOptions, 
						ExerciseDate, GrantOptionId, GrantDate, VestingDate, GrantLegSerialNumber, NULL, NULL, ExerciseId
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N
					
					EXEC PROC_GET_TAXFORAUTOEXERCISE @PERQ_DETAILS = @CASE_5_@PERQ_VALUE_TYPE_AUTO_EXE, @PERQ_RESULT = @CASE_5_@PERQ_VALUE_RESULT
					
					INSERT INTO #CASE_5_TAX_CALCULATION
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
						TC_5 SET TC_5.TAX_FLAG = TFD.TAXFLAG
					FROM #CASE_5_TAX_CALCULATION AS TC_5
						INNER JOIN #TEMP_FMV_DETAILS_NEW AS TFD ON TC_5.MIT_ID = TFD.INSTRUMENT_ID
					WHERE
						TC_5.EmployeeID = TFD.EMPLOYEE_ID AND TC_5.GRANTOPTIONID = TFD.GRANTOPTIONID AND CONVERT(DATE,TC_5.VESTING_DATE) =  CONVERT(DATE,TFD.VESTINGDATE)
					
					SELECT
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID 
					FROM 
						#CASE_5_TAX_CALCULATION

					-- UPDATE PERQUISITE PAYABLE INTO TAMP TABLE WITH ROUNDING VALUE	
					CREATE TABLE #CASE_5_TEMP_CAL_PERQPAYABLE 
					(
						EXERCISE_ID BIGINT, PERQ_PAYABLE NUMERIC (18,6)
					)			
					
					INSERT INTO #CASE_5_TEMP_CAL_PERQPAYABLE (EXERCISE_ID, PERQ_PAYABLE)
					SELECT 
						MAX(EXERCISE_ID), SUM(TAX_AMOUNT)
					FROM 
						#CASE_5_TAX_CALCULATION
					GROUP BY 
						EXERCISE_ID
					
					UPDATE PTCEXEN SET 
						PTCEXEN.Preq_Payable = (SELECT dbo.FN_ROUND_VALUE(TTCP.PERQ_PAYABLE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal))
					FROM #PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEXEN
					INNER JOIN #CASE_5_TEMP_CAL_PERQPAYABLE AS TTCP ON TTCP.EXERCISE_ID = PTCEXEN.ExerciseId 
													
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = '#TEMP_FMV_DETAILS_NEW')
					BEGIN
						DROP TABLE #TEMP_FMV_DETAILS_NEW
					END
					
					DROP TABLE #CASE_5_TEMP_CAL_PERQPAYABLE
					
					/*	
						PROVISION FOR 
						BETWEEN PRE VESTING AND NEXT DAY TAX CALCULATION IF EMPLOYEE MOMENT HAPPENED THEN INSERT TAX FOR 
						NEW RECORDS AND UPDATE FOR EXISTING RECORDS
					*/
					INSERT INTO #CASE_5_TAX_CALCULATION_NEW_DATA
					(
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID
					)
					SELECT
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID 
					FROM 
						#CASE_5_TAX_CALCULATION
				
					DELETE 
						C5TCND 
					FROM
					#CASE_5_TAX_CALCULATION_NEW_DATA AS C5TCND
					INNER JOIN EXERCISE_TAXRATE_DETAILS AS ETD ON ETD.GRANTLEGSERIALNO = C5TCND.GRANTLEGSERIALNO					
					WHERE 
						(ETD.EXERCISE_NO = C5TCND.EXERCISE_ID) AND (ETD.COUNTRY_ID = C5TCND.COUNTRY_ID) AND
						(UPPER(ETD.Tax_Title)=UPPER(C5TCND.TAX_HEADING)) AND (C5TCND.GRANTLEGSERIALNO IS NOT NULL)	AND
						
						 (CONVERT(DATE,ISNULL( ETD.FROM_DATE,'')) = CONVERT(DATE,ISNULL(C5TCND.FROM_DATE,'')))
					
					SELECT 
						TAX_HEADING, TAX_RATE, RESIDENT_STATUS, TAX_AMOUNT, Country, [STATE], BASISOFTAXATION, FMV, TOTAL_PERK_VALUE, COUNTRY_ID, 
						MIT_ID, EmployeeID, GRANTOPTIONID, VESTING_DATE, GRANTLEGSERIALNO, FROM_DATE, TO_DATE, TAX_FLAG, EXERCISE_ID
					FROM
						#CASE_1_TAX_CALCULATION_NEW_DATA
				END
				
				/* ====================================== */
				
				BEGIN /* ===== SAR CALCULATION ===== */

					DECLARE @CASE_5_SAR_SETTLEMENT_PRICE dbo.TYPE_SAR_SETTLEMENT_PRICE 
					
					INSERT INTO @SAR_SETTLEMENT_PRICE 
					SELECT 
						PTCEN.MIT_ID, PTCEN.EmployeeId, PTCEN.GrantDate, PTCEN.VestingDate, PTCEN.ExerciseDate, PTCEN.ExercisePrice, 
						PTCEN.SchemeId, PTCEN.GrantOptionId
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEN
						INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCEN.MIT_ID
					WHERE 
						(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
					
					EXEC PROC_GET_SAR_SETTELEMENT_PRICCE @EMPLOYEE_SAR_DETAILS = @CASE_5_SAR_SETTLEMENT_PRICE
					
					/* UPDATE SAR SETTLEMENT PRICES */
					UPDATE PTCEN SET 
						PTCEN.SettlmentPrice = CASE TSSFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSSFD.SAR_SETTLEMENT_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END						
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEN
						INNER JOIN TEMP_SAR_SETTLEMENT_FINAL_DETAILS AS TSSFD ON TSSFD.INSTRUMENT_ID = PTCEN.MIT_ID 
					WHERE 
						(TSSFD.EMPLOYEE_ID = PTCEN.EmployeeId) AND (CONVERT(DATE, TSSFD.EXERCISE_DATE) = CONVERT(DATE, PTCEN.ExerciseDate)) AND 
						(TSSFD.GRANTOPTIONID = PTCEN.GrantOptionId) AND (CONVERT(DATE, TSSFD.GRANTDATE) = CONVERT(DATE, PTCEN.GrantDate)) AND 
						(CONVERT(DATE, TSSFD.VESTINGDATE) = CONVERT(DATE, PTCEN.VestingDate)) 
				END
				
				/* ====================================== */	
				
				BEGIN /* ===== UPDATE SAR STOCK APPRECIATION CALCULATION ===== */
				
					DECLARE @CASE_5_SAR_STOCK_APPRECIATION dbo.TYPE_SAR_STOCK_APPRECIATION	
					
					INSERT INTO @SAR_STOCK_APPRECIATION 
					SELECT 
						PTCEN.MIT_ID, PTCEN.EmployeeId, PTCEN.ExercisePrice, PTCEN.ExercisedQuantity, PTCEN.ExercisedQuantity, 
						PTCEN.ExerciseDate, PTCEN.GrantOptionId, PTCEN.GrantDate, PTCEN.VestingDate,PTCEN.ExerciseId
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEN
						INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCEN.MIT_ID
					WHERE (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
					
					IF EXISTS(SELECT COUNT(*) FROM @CASE_5_SAR_STOCK_APPRECIATION)
					BEGIN
						-- INSERT INTO #STOCK_APPRECIATION_DETAILS_TEMP
						--(
						--INSTRUMENT_ID, EMPLOYEE_ID, STOCK_APPRECIATION_VALUE, EVENTOFINCIDENCE, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, 
						--OPTION_EXERCISED, GRANTOPTIONID, GRANTDATE ,VESTINGDATE, TAXFLAG,TAXFLAG_HEADER 
						--)
						EXEC PROC_GET_SAR_STOCK_APPRECIATION @EMPLOYEE_SAR_APPRECIATION = @CASE_5_SAR_STOCK_APPRECIATION		
						
						INSERT INTO #STOCK_APPRECIATION_DETAILS_TEMP
						(
							INSTRUMENT_ID, EMPLOYEE_ID,EXERCISE_PRICE ,OPTION_VESTED,EXERCISE_DATE,EVENTOFINCIDENCE,OPTION_EXERCISED,GRANTOPTIONID, GRANTDATE ,VESTINGDATE,
							STOCK_APPRECIATION_VALUE,TAXFLAG,TAXFLAG_HEADER 
						)		
						SELECT INSTRUMENT_ID, EMPLOYEE_ID, EXERCISE_PRICE, OPTION_VESTED, EXERCISE_DATE, EVENTOFINCIDENCE,OPTION_EXERCISED,
						GRANTOPTIONID, GRANTDATE, VESTINGDATE,ISNULL( STOCK_APPRECIATION_VALUE,0),TAXFLAG,TAXFLAG_HEADER FROM TEMP_STOCK_APPRECIATION_DETAILS

					END
					/* UPDATE SAR STOCK APPRECIATION PRICES */
					
					UPDATE PTCEN SET 
						PTCEN.StockApprValue = CASE TSAD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TSAD.STOCK_APPRECIATION_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEN
						INNER JOIN #STOCK_APPRECIATION_DETAILS_TEMP AS TSAD ON TSAD.INSTRUMENT_ID = PTCEN.MIT_ID 
					WHERE 
						(TSAD.EMPLOYEE_ID = PTCEN.EmployeeId) AND (TSAD.OPTION_EXERCISED = PTCEN.ExercisedQuantity) AND 
						(CONVERT(DATE, TSAD.EXERCISE_DATE) = CONVERT(DATE, PTCEN.ExerciseDate)) AND (TSAD.GRANTOPTIONID = PTCEN.GrantOptionId) AND 
						(CONVERT(DATE, TSAD.GRANTDATE) = CONVERT(DATE, PTCEN.GrantDate)) AND (CONVERT(DATE, TSAD.VESTINGDATE) = CONVERT(DATE, PTCEN.VestingDate)) 
					

	 INSERT INTO @TYPE_CASHPAYOUT_VALUE     
		SELECT     
			TAED.MIT_ID, TAED.LoginID, TAED.SettlmentPrice,TAED.ExercisePrice,TAED.SchemeId,TAED.FMVPrice,(SELECT  MAX(CP.FaceVaue) FROM CompanyParameters CP ) ,
			TAED.ExercisedQuantity,TAED.ShareAriseApprValue,
			TAED.GrantOptionId,TAED.GrantLegSerialNumber,TAED.ExerciseDate,TAED.ExerciseId   	    
		FROM     
		#PERQUISITE_TAX_CALCULATION_EXED_N AS TAED    
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID    
		 WHERE     
		(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1) 

	/* CASH PAYOUT VALUE */	
	
	INSERT INTO #TEMP_FINALCASHPAYOUTDETAILS
	(
		MIT_ID , EMPLOYEE_ID , EXERCISE_DATE  ,CASHPAYOUT_VALUE  , SCHEME_ID , GRANTOPTIONID,TEMP_EXERCISEID 
	)
	EXEC GET_CASHPAYOUT_VALUE @EMPLOYEE_DETAILS =@TYPE_CASHPAYOUT_VALUE

 --select 'ss' ,* from  #TEMP_FINALCASHPAYOUTDETAILS
	/* Adjustment Stock appreciation End*/
		  
	  UPDATE TAED SET    
	   TAED.CashPayoutValue =     
	   CASE WHEN TAED.MIT_ID = 6 THEN           
		CASE WHEN (SCH.ROUNDING_UP IS NULL and SCH.FRACTION_PAID_CASH IS NULL)  THEN 0 
		WHEN (SCH.FRACTION_PAID_CASH IS NULL)  THEN Null     
		  WHEN (SCH.ROUNDING_UP = 1) THEN 0 WHEN SCH.ROUNDING_UP = 0  THEN     
		 CASE WHEN SCH.FRACTION_PAID_CASH = 1 THEN      
		   FCPD.CASHPAYOUT_VALUE
			--(ISNULL(TAED.SettlmentPrice,0) - ISNULL(TAED.ExercisePrice,0)) * (ISNULL(TAED.StockApprValue,0) - ISNULL(FLOOR(TAED.ShareAppriciation),0))           
		  ELSE     
		   0     
		 END     
		END       
	   ELSE    
		ISNULL(TAED.StockApprValue,0) - ISNULL(TAED.Preq_Payable,0)    
	   END   ,
	   TAED.ShareAriseApprValue =  TAED.ShareAriseApprValue     
	 FROM     
	   #PERQUISITE_TAX_CALCULATION_EXED_N AS TAED    
	   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = TAED.MIT_ID    
	   INNER JOIN  Scheme AS SCH ON SCH.SchemeId = TAED.SchemeId 
	   INNER JOIN #TEMP_FINALCASHPAYOUTDETAILS AS FCPD ON FCPD.MIT_ID=TAED.MIT_ID 
	   AND FCPD.SCHEME_ID=TAED.SchemeId 
	   AND FCPD.TEMP_EXERCISEID=TAED.ExerciseId 
	   AND FCPD.GRANTOPTIONID=TAED.GrantOptionId
	  WHERE     
	   (MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1) 
					
					--UPDATE PTCNNC SET
					--	PTCNNC.CashPayoutValue =  CASE WHEN PTCNNC.MIT_ID = 6   
					--	 THEN 
					--	 PTCNNC.CashPayoutValue  
					--	 else
	    --     ISNULL(PTCNNC.StockApprValue,0) - ISNULL(PTCNNC.Preq_Payable,0)	END							
					--FROM 
					--	#PERQUISITE_TAX_CALCULATION_EXED_N AS PTCNNC
					--	INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON MIT.MIT_ID = PTCNNC.MIT_ID
					--	INNER JOIN Scheme as SH on SH.SchemeId = PTCNNC.SchemeId
					--WHERE 
					--	(MIT.IS_SAR_ENABLED = 1) AND (MIT.IS_ACTIVE = 1)
					
					IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_SAR_SETTLEMENT_FINAL_DETAILS')
					BEGIN
						DROP TABLE TEMP_SAR_SETTLEMENT_FINAL_DETAILS
					END
					
					
				END				
				
				/* ====================================== */
				
				IF((SELECT COUNT(ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_EXED_N) > 0)
				BEGIN
					SELECT 
						TaxUploadCase, ExerciseId, ExerciseNo, GrantLegSerialNumber, SchemeId, GrantOptionId, EmployeeID, ExercisedQuantity, 
						ExercisePrice, SharesIssuedDate, Cash, ExerciseDate, GrantDate, IsMassUpload, Apply_SAR, ResidentialStatus, 
						Emp_Status, EMP_TAX_SLAB, PERQTAXRULE, CALCPERQVAL, CALCPERQTAX, PERQTAXRATE, CALCPERQPARAM, FMVPrice, Preq_Value, 
						Preq_Payable, EmployeeName, EmployeeEmail, ExerciseCost, EmpTaxSlab, MIT_ID, VestedOptions, GrantedOptions, 
						VestingDate, EventOfIncidence, TaxFlag, StockApprValue, CashPayoutValue, SettlmentPrice
					FROM 
						#PERQUISITE_TAX_CALCULATION_EXED_N 
					WHERE 
						(FMVPrice IS NOT NULL) 
				END
				
				BEGIN /* ============ UPDATE IN ACTUAL TABLE ============ */
					-- UPDATE DETAILS IN SHEXERCISE OPTION TABLE
					UPDATE EXED SET 
						EXED.FMVPrice = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.FMVPrice ELSE NULL END,  
						EXED.PerqstValue = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.Preq_Value ELSE NULL END,  
						EXED.PerqstPayable = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.Preq_Payable ELSE NULL END, 
						EXED.Perq_Tax_rate = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.PERQTAXRATE ELSE NULL END,
						EXED.StockApprValue = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.StockApprValue ELSE NULL END,
						EXED.SettlmentPrice = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.SettlmentPrice ELSE NULL END,
						EXED.CashPayoutValue = CASE PTCEXEN.TaxFlag WHEN 'A' THEN PTCEXEN.CashPayoutValue ELSE NULL END,
						EXED.LastUpdatedBy = 'ADMIN', EXED.LastUpdatedOn = GETDATE()
					FROM 
						EXERCISED AS EXED
						INNER JOIN #PERQUISITE_TAX_CALCULATION_EXED_N AS PTCEXEN ON EXED.ExercisedId = PTCEXEN.ExerciseId
					WHERE 
						(PTCEXEN.FMVPrice IS NOT NULL)
					
					-- UPDATE DETAILS IN EXERCISE_TAXRATE_DETAILS
					
					UPDATE ETD SET
						ETD.FMVVALUE = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.FMV ELSE NULL END,
						ETD.TAX_AMOUNT = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.TAX_AMOUNT ELSE NULL END, 
						ETD.PERQVALUE = CASE WHEN TC.TAX_FLAG = 'A' THEN TC.TOTAL_PERK_VALUE ELSE NULL END,
						UPDATED_BY = 'ADMIN', UPDATED_ON = GETDATE()
					FROM 
						EXERCISE_TAXRATE_DETAILS AS ETD
						INNER JOIN #CASE_5_TAX_CALCULATION AS TC ON ETD.GRANTLEGSERIALNO = TC.GRANTLEGSERIALNO
					WHERE 
						(ETD.EXERCISE_NO = TC.EXERCISE_ID) AND (ETD.COUNTRY_ID = TC.COUNTRY_ID) AND
						(UPPER(ETD.Tax_Title)=UPPER(TC.TAX_HEADING)) AND (TC.GRANTLEGSERIALNO IS NOT NULL)AND
						(CONVERT(DATE,ISNULL( ETD.FROM_DATE,'')) = CONVERT(DATE,ISNULL(TC.FROM_DATE,'')))
						
					/* UPDATE IN TAX TABLE */
					IF((SELECT COUNT(EXERCISE_ID) AS ROW_COUNT FROM #CASE_5_TAX_CALCULATION_NEW_DATA) > 0)
					BEGIN
						INSERT INTO [EXERCISE_TAXRATE_DETAILS]
						(
							EXERCISE_NO, COUNTRY_ID, RESIDENT_ID, Tax_Title, BASISOFTAXATION, TAX_RATE, TAX_AMOUNT, TENTATIVETAXAMOUNT, 
							GRANTLEGSERIALNO, FMVVALUE, TENTATIVEFMVVALUE, PERQVALUE, TENTATIVEPERQVALUE, FROM_DATE, TO_DATE, 
							CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON
						)
						SELECT
							EXERCISE_ID, COUNTRY_ID, RESIDENT_STATUS, TAX_HEADING, BASISOFTAXATION, TAX_RATE, 
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TAX_AMOUNT ELSE NULL END, NULL, GRANTLEGSERIALNO, 				
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN FMV ELSE NULL END, NULL, 
							CASE WHEN (UPPER(TAX_FLAG) = 'A') THEN TOTAL_PERK_VALUE ELSE NULL END, NULL,
							FROM_DATE, TO_DATE, 'ADMIN', GETDATE(), 'ADMIN', GETDATE()						
						FROM 
							#CASE_5_TAX_CALCULATION_NEW_DATA           
					END								
				END
			END
		END
								
		--==============================================
		-- CASE 7
		--==============================================
		IF((@CASE_7_#PERQUISITE_TAX_CALCULATION_HUL = '1') AND (UPPER(@COMPANY_ID) = 'HUL'))
		BEGIN			
			IF((SELECT COUNT(H_ExerciseId) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_HUL) > 0)			
			BEGIN
			
				SELECT * FROM #PERQUISITE_TAX_CALCULATION_HUL
				
				IF (UPPER(@SendPerqMail) = 'Y')
				BEGIN	
					
					SELECT * INTO #OUTER_PERQUISITE_TAX_CALCULATION_HUL FROM #PERQUISITE_TAX_CALCULATION_HUL
					WHERE (H_FMVPrice IS NOT NULL) AND ((LEN(H_Preq_Value) > 0) AND (LEN(H_Preq_Payable)>0))
						
					SET @MailSubject = '' 					SET @MailBody = ''
					SET @MaxMsgId = ''						SET @HULMailBody = ''
						
					SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'PERQTAXCASHMAILALERT'
					SELECT @HULMailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'PERQTAXCASHMAILALERTHUL'
					
					-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
						
					SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
						
					BEGIN
						DBCC CHECKIDENT(#PERQUISITE_TAX_CALCULATION_HUL_MAIL, RESEED, @MaxMsgId)
					END

					INSERT INTO #PERQUISITE_TAX_CALCULATION_HUL_MAIL 
					(	
						H_TaxUploadCase, H_ExerciseNo, H_EmployeeName, H_EmployeeEmail, H_ExerciseID, H_ExercisedQuantity, H_ExercisePrice,
						H_GrantDate, H_ExerciseDate, H_FMVPrice, H_PERQTAXRATE, H_Preq_Value, H_Preq_Payable, H_ExerciseCost, H_MailSubject, H_MailBody 
					)							
					
					SELECT 'M_CASE7', H_ExerciseNo,  H_EmployeeName + ' (Emp.ID:'+ H_EmployeeID + ')' AS H_EmployeeName, H_EmployeeEmail,
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), HUL_#TEMP_DATA.H_ExerciseId) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_ExerciseId,
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), CONVERT(INT,HUL_#TEMP_DATA.H_ExercisedQuantity)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_Employeeid FOR XML PATH ('')),2,10000) H_ExercisedQuantity,						
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), HUL_#TEMP_DATA.H_ExercisePrice) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_ExercisePrice,
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), REPLACE(CONVERT(VARCHAR(11), HUL_#TEMP_DATA.H_GrantDate, 106), ' ', '/')) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_GrantDate,																		
					REPLACE(CONVERT(VARCHAR(11), H_ExerciseDate, 106), ' ', '/')  AS H_ExerciseDate,
					CONVERT(NUMERIC(18,2), H_FMVPrice) AS FMVPrice,	
					dbo.FN_PQ_TAX_ROUNDING(CONVERT(NUMERIC(18,2), H_PERQTAXRATE)) AS H_PERQTAXRATE,					
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), CONVERT(NUMERIC(18,2), HUL_#TEMP_DATA.H_Preq_Value)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_Preq_Value,
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), ISNULL(CONVERT(NUMERIC(18,2), HUL_#TEMP_DATA.H_Preq_Payable),0.00)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_Preq_Payable,
					SUBSTRING((SELECT ', ' +  CONVERT(NVARCHAR(MAX), ISNULL(CONVERT(NUMERIC(18,0), HUL_#TEMP_DATA.H_ExerciseCost),0)) AS [text()] FROM #PERQUISITE_TAX_CALCULATION_HUL HUL_#TEMP_DATA 
					WHERE (HUL_#TEMP_DATA.H_ExerciseNo = OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo)
					AND ((HUL_#TEMP_DATA.H_Preq_Payable IS NOT NULL) AND (HUL_#TEMP_DATA.H_Preq_Value IS NOT NULL))						
					ORDER BY HUL_#TEMP_DATA.H_EmployeeID FOR XML PATH ('')),2,10000) H_ExerciseCost,						
					@MailSubject, @MailBody
					FROM #OUTER_PERQUISITE_TAX_CALCULATION_HUL OUTER_PERQUISITE_TAX_CALCULATION_HUL 			
					GROUP BY OUTER_PERQUISITE_TAX_CALCULATION_HUL.H_ExerciseNo, H_EmployeeName, H_EmployeeID, H_EmployeeEmail, H_ExerciseDate, H_FMVPrice,H_PERQTAXRATE
						
					SET @CC_TO = ''
					SET @HULSpecificNote1 = ''
									
					SET @CC_TO = 'StockOptions.HLL@unilever.com'							
					SELECT @HULSpecificNote1 = MailBody FROM MailMessages WHERE UPPER(Formats)='PerqTaxMailHULNote1'							
					
					IF((SELECT COUNT(H_ExerciseNo) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_HUL_MAIL) > 0)	
					BEGIN											 
						SELECT H_TaxUploadCase, H_Message_ID, H_ExerciseNo, H_EmployeeName, H_EmployeeEmail, H_ExerciseID, H_ExercisedQuantity, H_GrantDate, H_ExercisePrice, H_ExerciseDate, 
						H_FMVPrice, H_Preq_Value, H_Preq_Payable, H_MailSubject, 
						REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(H_MailBody,'{0}',H_EmployeeName),'{1}', H_GrantDate),'{2}',H_ExercisedQuantity),'{3}',H_ExercisePrice),'{4}',H_ExerciseDate),'{5}',H_FMVPrice),'{6}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{7}',H_Preq_Value),'{8}',H_Preq_Payable),'{#}',@HULMailBody),'{10}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',H_ExerciseCost),'{8}',H_Preq_Payable)
						AS H_MailBody, H_ExerciseCost
						FROM #PERQUISITE_TAX_CALCULATION_HUL_MAIL  
						WHERE LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(H_MailBody,'{0}',H_EmployeeName),'{1}', H_GrantDate),'{2}',H_ExercisedQuantity),'{3}',H_ExercisePrice),'{4}',H_ExerciseDate),'{5}',H_FMVPrice),'{6}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{7}',H_Preq_Value),'{8}',H_Preq_Payable),'{#}',@HULMailBody),'{10}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',H_ExerciseCost),'{8}',H_Preq_Payable))>0
					END
				
					IF((SELECT COUNT(H_ExerciseNo) AS ROW_COUNT FROM #PERQUISITE_TAX_CALCULATION_HUL_MAIL) > 0)	
					BEGIN						
						-- INSSET INTO MAIL SPOOL TABLE
						INSERT INTO [MailerDB].[dbo].[MailSpool]
						([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
						SELECT H_Message_ID, @COMPANY_EMAIL_ID, H_EmployeeEmail, H_MailSubject, 
						REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(H_MailBody,'{0}',H_EmployeeName),'{1}', H_GrantDate),'{2}',H_ExercisedQuantity),'{3}',H_ExercisePrice),'{4}',H_ExerciseDate),'{5}',H_FMVPrice),'{6}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{7}',H_Preq_Value),'{8}',H_Preq_Payable),'{#}',@HULMailBody),'{10}',dbo.FN_PQ_TAX_ROUNDING(H_PERQTAXRATE)),'{#HUL_SpecificNote}',@HULSpecificNote1),'{9}',H_ExerciseCost),'{8}',H_Preq_Payable)
						AS M_MailBody, NULL, NULL, NULL, NULL, NULL, @CC_TO, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() FROM #PERQUISITE_TAX_CALCULATION_HUL_MAIL
						WHERE (H_MailBody IS NOT NULL)

						-- UPDATE IS Exercise Mail Sent STATUS INTO SHEXERCISE OPTION TABLE
						UPDATE SHEO SET isExerciseMailSent ='Y' FROM ShExercisedOptions AS SHEO
						INNER JOIN #PERQUISITE_TAX_CALCULATION_HUL_MAIL AS PTCNNC ON SHEO.ExerciseId = PTCNNC.H_ExerciseID																																																							
					END				
				END																						
			END
		END
	END
	END
	
	SET NOCOUNT OFF;
	
END

GO
