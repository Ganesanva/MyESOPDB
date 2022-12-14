/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PREVESTING_EXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_PREVESTING_EXERCISED_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_PREVESTING_EXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SAVE_PREVESTING_EXERCISED_DETAILS] 

AS
BEGIN	

	SET NOCOUNT ON;

	DECLARE
		@CompanyID VARCHAR(20), @IsPaymentModeRequired TINYINT, @PaymentModeEffectiveDate DATE,	@FaceVaue NUMERIC(18, 2), 
		@SARFMV NUMERIC(18, 2), @IsSingleModeEnabled BIT, @Payment_Mode CHAR(1), @CalculateDays VARCHAR(20), @DaysOut VARCHAR(20), 
		@FBTemployeetravelledYN VARCHAR(20), @FBTPayBy VARCHAR(20), @RoundupPlace_TaxableVal VARCHAR(5),	
		@RoundingParam_TaxableVal VARCHAR(5), @RoundingParam_FMV VARCHAR(5), @RoundupPlace_FMV VARCHAR(5), @ExerciseId NUMERIC(18,0),
		@TRANSACTION_SUCCESSFUL INT = 0,@AttachmentPath NVARCHAR(200)
		
	SELECT @CompanyID = CompanyID FROM CompanyParameters
	
	BEGIN /* CREATE TEMP TABLE */
	
		CREATE TABLE #TEMP_AUTO_EXERCISED_DETAILS
		(   
			ExerciseId INT IDENTITY (1, 1) NOT NULL,  ID BIGINT,EPPS_ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100), 
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
			TentativeCashPayoutValue NUMERIC(18,6), SettlmentPrice NUMERIC(18,6), TentativeSettlmentPrice NUMERIC(18,6)	
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
		 ID, ApprovalId,EPPS_ID, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
		[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
		FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
		LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID,  EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, EXERCISABLE_QUANTITY,PaymentMode,
		TentativeFMVPrice,TentativePerqstValue,TentativePerqstPayable			
	)
	--EXEC PROC_GET_AUTOEXERCISED_DETAILS   	
	SELECT
		   GL.ID,GL.ApprovalId,EMP.EPPS_ID,GL.schemeid,GL.GrantApprovalId,GL.GrantRegistrationId, GL.GrantOptionId, EMP.GrantLegId,[Counter], VestingType, GrantedQuantity, SplitQuantity,
		   BonusSplitQuantity, Parent,FinalVestingDate, FinalExpirayDate, EMP.ExercisePrice, GrantDate,LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor,	SchemeTitle, IsPaymentModeRequired, 
		   PaymentModeEffectiveDate, EMP.MIT_ID,  EMP.EmployeeId, EMP.EmployeeId,
	       ResidentialStatus,TAX_IDENTIFIER_COUNTRY, EMP.ExercisedQuantity,PM.PaymentMode,
	       EMP.TentativeFMVPrice AS TentativeFMVPrice,emp.TentativePerqstValue AS TentativePerqstValue,EMP.TentativePerqstPayable as TentativePerqstPayable
    FROM
		   EMPPREPAYSELECTION AS EMP
		   INNER JOIN GrantLeg AS GL ON EMP.GrantLegSerialNumber = GL.id 
		   INNER JOIN GrantRegistration AS GR ON GL.GrantRegistrationId = GR.GrantRegistrationId
		   INNER JOIN SCHEME AS SCH ON SCH.SchemeId = GL.SchemeId
		   INNER JOIN GrantOptions AS GP ON GL.GrantOptionId = GP.GrantOptionId 
		   INNER JOIN EmployeeMaster AS EM ON GP.EmployeeId = EM.EmployeeId 
		   INNER JOIN PaymentMaster AS PM ON EMP.PaymentMode = PM.Id
	WHERE EMP.Is_AutoExercised = 0 AND GL.ExercisableQuantity <> 0 AND EMP.EPPS_ID NOT IN 
		  (SELECT 
				EPPS_ID 
		   FROM
				EMPPREPAYSELECTION AS  EMP
				INNER JOIN ShExercisedOptions AS SH ON emp.GrantLegSerialNumber = sh.GrantLegSerialNumber
		   )

	     
	/* Get Prevesting data */
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
	
	BEGIN /* ===== CALCULATE FMV ===== */
	
		SELECT 
			@RoundupPlace_TaxableVal = RoundupPlace_TaxableVal, @RoundingParam_TaxableVal = RoundingParam_TaxableVal, 
			@RoundingParam_FMV = RoundingParam_FMV, @RoundupPlace_FMV = RoundupPlace_FMV 
		FROM 
			CompanyParameters

		DECLARE @FMV_VALUE_TYPE dbo.TYPE_FMV_VALUE
		
		INSERT INTO @FMV_VALUE_TYPE 
		SELECT 
			MIT_ID , EmployeeId, GrantOptionId , GrantDate, FinalVestingDate, FinalVestingDate 
		FROM 
			#TEMP_AUTO_EXERCISED_DETAILS
		
		EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @FMV_VALUE_TYPE		    
		 
		
	END		
	
	BEGIN /* ===== CALCULATE PERQUISITE VALUE ===== */
	   
		DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE
		
		INSERT INTO @PERQ_VALUE_TYPE 
		SELECT 
			MIT_ID, EmployeeId, ExercisePrice, EXERCISABLE_QUANTITY, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END, 
			EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY , FinalVestingDate, GrantOptionId, GrantDate, FinalVestingDate, ID, NULL, NULL, ExerciseId  
		FROM 
			#TEMP_AUTO_EXERCISED_DETAILS
				
		EXEC PROC_GET_PERQUISITE_VALUE @EMPLOYEE_DETAILS = @PERQ_VALUE_TYPE	
	   
		/* ADD DATA TO TYPE */
		DECLARE @PERQ_VALUE_RESULT dbo.TYPE_PERQ_FORAUTOEXERCISE
		
		INSERT INTO @PERQ_VALUE_RESULT
		SELECT 
			INSTRUMENT_ID, EMPLOYEE_ID, FMV_VALUE, PERQ_VALUE, EVENTOFINCIDENCE, GRANTDATE, VESTINGDATE, 
			EXERCISE_DATE, GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID							
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
			MIT_ID, EmployeeId, ExercisePrice, EXERCISABLE_QUANTITY, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END, 
			EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, FinalVestingDate, GrantOptionId, GrantDate, FinalVestingDate, ID, NULL, NULL, ExerciseId
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
			TAED.Perq_Tax_rate = (SELECT dbo.FN_PQ_TAX_ROUNDING(TTP.Perq_Tax_rate))
			
		FROM 
			#TEMP_AUTO_EXERCISED_DETAILS AS TAED 
		INNER JOIN #TEMP_TAX_PAYBLE TTP ON TAED.ExerciseId = TTP.EXERCISE_ID					
	END	   	
			
	
	
   	BEGIN TRY
		
		BEGIN TRANSACTION
		
		BEGIN 
			
		 	INSERT INTO ShExercisedOptions 
			(
				GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisePrice, 
				ExercisableQuantity, Action, LastUpdatedBy, LastUpdatedOn, GrantLegId, ExerciseDate, ValidationStatus, EmployeeID, 
				ExerciseNo, Cash, IsMassUpload, PerqstValue, PerqstPayable, FMVPrice, perq_tax_rate, TaxRule, PaymentMode, 
				TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, IsAutoExercised, MIT_ID, PerPayModeSelected,
				StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice
			) 
			SELECT
				Id, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, EXERCISABLE_QUANTITY, ExercisePrice, 
				0, 'P', 'ADMIN', GETDATE(), GrantLegId, FinalVestingDate, 'N', EmployeeId, 
				ExerciseId, Cash, 'N', PerqstValue, PerqstPayable, FMVPrice, Perq_Tax_rate, NULL, PaymentMode, 
				TentativeFMVPrice, TentativePerqstValue, TentativePerqstPayable, 1, MIT_ID, PerPayModeSelected,
				StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice
			FROM 
				#TEMP_AUTO_EXERCISED_DETAILS 
			

							  
		END		
		
		BEGIN 

	  		UPDATE GL SET 
				GL.ExercisableQuantity = GL.ExercisableQuantity - TAD.EXERCISABLE_QUANTITY, 
				GL.UnapprovedExerciseQuantity = GL.UnapprovedExerciseQuantity + TAD.EXERCISABLE_QUANTITY
			FROM 
				Grantleg AS GL
			INNER JOIN #TEMP_AUTO_EXERCISED_DETAILS TAD ON TAD.Id = GL.ID	 


		END
		
		BEGIN 

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

		END
		
		
		BEGIN 
		
		   	INSERT INTO AuditData
			(
				ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt
			)
			SELECT 
				ExerciseId, ExerciseId, TentativeFMVPrice,
				FinalVestingDate + CAST(GETDATE() AS TIME), ExercisePrice * EXERCISABLE_QUANTITY, 
				Perq_Tax_rate,TentativePerqstValue ,
				TentativePerqstPayable, 
				(SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),
				PaymentMode, 0, (SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, FinalVestingDate, MIT_ID, EXERCISABLE_QUANTITY))
			FROM 
				#TEMP_AUTO_EXERCISED_DETAILS WHERE (LEN(ISNULL(PaymentMode, '')) <> 0)
		END
			
		COMMIT TRANSACTION  
		
		SET @TRANSACTION_SUCCESSFUL = 1
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION	
		SET @TRANSACTION_SUCCESSFUL = 0	  

	END CATCH
	
	
	IF(@TRANSACTION_SUCCESSFUL = 1)
	BEGIN
	
		PRINT 'Suceesses'
		/*
		BEGIN 
						
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
		END
				
		BEGIN 
	
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
		
		BEGIN 
				
			SET @MaxNewMsgToId = (SELECT ISNULL(MAX(MessageID),0)+ 1	AS MessageID FROM NewMessageTo)		
			BEGIN
				DBCC CHECKIDENT(#New_Message_To, RESEED, @MaxNewMsgToId) 
			END	

			INSERT INTO #New_Message_To
			(
				EmployeeID,	MessageDate, MailSubject, MailBody
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
				
		BEGIN 

			SET @MaxNewMsgFromId = (SELECT ISNULL(MAX(MessageID),0)+ 1	AS MessageID FROM NewMessageFrom)		
			
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
		
		BEGIN 

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
		   */		
	END	

	/* ================ FINAL OUTPUT ================== */
	SELECT
		ExerciseId,  ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter], 
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
		TaxFlag, FaceVaue, SARFMV, ExType, Cash, PaymentMode, PerPayModeSelected, EXERCISE_DATE,
		StockApprValue, TentativeStockApprValue, CashPayoutValue, TentativeCashPayoutValue, SettlmentPrice, TentativeSettlmentPrice
	FROM 
		#TEMP_AUTO_EXERCISED_DETAILS
   		  
					
	DROP TABLE #TEMP_AUTO_EXERCISED_DETAILS


	DROP TABLE #TAX_CALCULATION

			
	SET NOCOUNT OFF;
END
GO
