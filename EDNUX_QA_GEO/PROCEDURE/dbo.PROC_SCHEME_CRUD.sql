/****** Object:  StoredProcedure [dbo].[PROC_SCHEME_CRUD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SCHEME_CRUD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SCHEME_CRUD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SCHEME_CRUD]
         @ApprovalId VARCHAR(20) = NULL, @SchemeId VARCHAR(50)= NULL, @Status VARCHAR (1) = NULL, @SchemeTitle VARCHAR(20) = NULL,
         @AdjustResidueOptionsIn VARCHAR(1) = NULL, @VestingOverPeriodOffset NUMERIC(9,0) = NULL, @VestingStartOffset NUMERIC(9,0) = NULL,
         @VestingFrequency NUMERIC(9,0) = NULL, @LockInPeriod NUMERIC(9,0)= NULL, @LockInPeriodStartsFrom VARCHAR(1) = NULL,
         @OptionRatioMultiplier NUMERIC(9,0) = NULL, @OptionRatioDivisor NUMERIC(9,0) = NULL, @ExercisePeriodOffset NUMERIC(9,0) = NULL,
         @ExercisePeriodStartsAfter VARCHAR(1)= NULL, @LastUpdatedBy VARCHAR(20)= NULL, @LastUpdatedOn DATETIME = NULL,  
         @PeriodUnit CHAR(1) = NULL, @UnVestedCancelledOptions VARCHAR(1) = NULL, @VestedCancelledOptions VARCHAR(1) = NULL,
         @LapsedOptions VARCHAR(1) = NULL, @IsPUPEnabled BIT = NULL, @DisplayExPrice BIT = NULL, @DisplayExpDate BIT = NULL, 
         @DisplayPerqVal BIT = NULL, @DisplayPerqTax BIT = NULL, @PUPExedPayoutProcess BIT = NULL, @PUPFORMULAID INT = NULL, 
         @IS_ADS_SCHEME BIT = NULL, @IS_ADS_EX_OPTS_ALLOWED BIT = NULL, @MIT_ID INT = NULL, @IS_AUTO_EXERCISE_ALLOWED CHAR(1) = NULL,
         @ACTION VARCHAR(20) = Null, @EXERCISE_ON NVARCHAR(100) = NULL, @EXERCISE_AFTER_DAYS INT = NULL, @COUNTRY_ID NVARCHAR(MAX) = NULL,
         @IS_EXCEPTION_ENABLED TINYINT = NULL, @EXECPTION_FOR NVARCHAR(100) = NULL, @EXECPTION_LIST NVARCHAR(MAX) = NULL,
         @CALCULATE_TAX NVARCHAR(100) = NULL, @CALCUALTE_TAX_PRIOR_DAYS INT = NULL, @IS_MAIL_ENABLE TINYINT  = NULL, 
         @MAIL_BEFORE_DAYS INT  = NULL, @MAIL_REMINDER_DAYS INT = NULL,@CALCULATE_TAX_PREVESTING VARCHAR(100)=NULL,@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING INT=NULL, @MESSAGE_OUT INT OUTPUT
AS
BEGIN

	SET NOCOUNT ON;   			
	DECLARE @IsApproveFlag TINYINT, @Old_Value NVARCHAR(250), @New_Value NVARCHAR(250), @Isupdated TINYINT,
			@i INT, @Temp_Field VARCHAR(100), @SqlString NVARCHAR(MAX), @RowCount INT ,@AEC_ID INT, @EXPCOUNT INT,
			@EXPCOUNT2 VARCHAR(50),@EXPFOROLD VARCHAR(50),@EXPFORNEW VARCHAR(50),@IS_UPDATE INT

	/* Create Temp Table */
	CREATE TABLE #TEMP_AUTO_EXERCISE_OLD
	(
	    ID INT IDENTITY(1,1), AEC_ID INT,SchemeId NVARCHAR(100),    
	    EXERCISE_ON NVARCHAR(100), EXERCISE_AFTER_DAYS INT, COUNTRY_ID NVARCHAR(MAX), IS_EXCEPTION_ENABLED TINYINT, EXECPTION_FOR NVARCHAR(100),
	    EXECPTION_LIST NVARCHAR(MAX), CALCULATE_TAX NVARCHAR(100), CALCUALTE_TAX_PRIOR_DAYS INT, IS_APPROVE TINYINT,
	    IS_MAIL_ENABLE TINYINT, MAIL_BEFORE_DAYS INT, MAIL_REMINDER_DAYS INT,
	    CREATED_BY NVARCHAR(100), CREATED_ON DATETIME,UPDATED_BY NVARCHAR(100),UPDATED_ON DATETIME
	)
	
	CREATE TABLE #TEMP_AUTO_EXERCISE_NEW
	(
		ID INT IDENTITY(1,1), AEC_ID INT, SchemeId NVARCHAR(100), EXERCISE_ON NVARCHAR(100), EXERCISE_AFTER_DAYS INT,
		COUNTRY_ID NVARCHAR(MAX), IS_EXCEPTION_ENABLED TINYINT, EXECPTION_FOR NVARCHAR(100), EXECPTION_LIST NVARCHAR(MAX), CALCULATE_TAX NVARCHAR(100),
		CALCUALTE_TAX_PRIOR_DAYS INT, IS_APPROVE TINYINT,IS_MAIL_ENABLE TINYINT, MAIL_BEFORE_DAYS INT,MAIL_REMINDER_DAYS INT, 
		CREATED_BY NVARCHAR(100), CREATED_ON DATETIME, UPDATED_BY NVARCHAR(100), UPDATED_ON DATETIME
	)

	CREATE TABLE #TEMP_FIELD_NAMES
	(
		F_ID INT IDENTITY(1,1), FIELD_NAME NVARCHAR(100), OLD_VALUE NVARCHAR(100), NEW_VALUE NVARCHAR(100), IS_UPDATE TINYINT DEFAULT(0), CREATED_BY VARCHAR(100) NULL, CREATED_ON VARCHAR(100)
	)

	BEGIN TRY		
		
		BEGIN TRANSACTION
		
		IF(UPPER(@ACTION)='ADD')
		BEGIN
			/*IF MIT_ID = 3,4 THEN INSERT IS_ADS_SCHEME = 1 */
		    SELECT 
				@IS_ADS_SCHEME = CASE WHEN(UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END,
				@IS_ADS_EX_OPTS_ALLOWED = CASE WHEN (UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0)END
			FROM 
				MST_INSTRUMENT_TYPE MIT INNER JOIN MST_COM_CODE MCC ON
				MCC.MCC_ID=MIT.INSTRUMENT_GROUP AND MIT.MIT_ID=@MIT_ID
				
			INSERT INTO Scheme 
			(	
				ApprovalId, SchemeId, Status, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset,
				VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, 
				ExercisePeriodOffset, ExercisePeriodStartsAfter, LastUpdatedBy, LastUpdatedOn, PeriodUnit, UnVestedCancelledOptions,
				VestedCancelledOptions, LapsedOptions, IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, 
				PUPExedPayoutProcess, PUPFORMULAID, IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED, MIT_ID,IS_AUTO_EXERCISE_ALLOWED
				,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCULATE_TAX_PREVESTING,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
			)
			VALUES
			(
				 @ApprovalId, @SchemeId, @Status, @SchemeTitle, @AdjustResidueOptionsIn, @VestingOverPeriodOffset, @VestingStartOffset,
				 @VestingFrequency, @LockInPeriod, @LockInPeriodStartsFrom, @OptionRatioMultiplier, @OptionRatioDivisor,
				 @ExercisePeriodOffset, @ExercisePeriodStartsAfter, @LastUpdatedBy, @LastUpdatedOn, @PeriodUnit, 
				 @UnVestedCancelledOptions, @VestedCancelledOptions, @LapsedOptions, @IsPUPEnabled, @DisplayExPrice, @DisplayExpDate, 
				 @DisplayPerqVal, @DisplayPerqTax, @PUPExedPayoutProcess, @PUPFORMULAID, @IS_ADS_SCHEME, @IS_ADS_EX_OPTS_ALLOWED,
				 @MIT_ID,@IS_AUTO_EXERCISE_ALLOWED,@CALCULATE_TAX,@CALCUALTE_TAX_PRIOR_DAYS,@CALCULATE_TAX_PREVESTING,@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
			)
			INSERT INTO SchemeSeperationRule 
			(
				ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor, 
				LastUpdatedBy,LastUpdatedOn,Status,OthersReason,VestedOptionsLiveTillExercisePeriod,PeriodUnit,IsRuleBypassed
			) 
			SELECT 
				ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor, 
				LastUpdatedBy, LastUpdatedOn, 'A', OthersReason, VestedOptionsLiveTillExercisePeriod, PeriodUnit, IsRuleBypassed 
			FROM 
				ShSchemeSeparationRule  
			WHERE 
				ApprovalId = @ApprovalId AND SchemeId = @SchemeId
			DELETE FROM ShSchemeSeparationRule WHERE ApprovalId= @ApprovalId AND SchemeId=@SchemeId
			DELETE FROM ShScheme  WHERE SchemeId = @SchemeId
			UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 1 WHERE  SchemeId = @SchemeId
			SET @MESSAGE_OUT =(select IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))			
		END   
		ELSE IF(UPPER(@ACTION)='APPROVE')
		BEGIN
			SET @RowCount = (SELECT COUNT(AEC_ID) FROM AUTO_EXERCISE_CONFIG  WHERE SchemeId = @SchemeId)		   
			SET @IsApproveFlag = (SELECT TOP 1( IS_APPROVE) FROM AUTO_EXERCISE_CONFIG  WHERE SchemeId = @SchemeId)
			IF(@IsApproveFlag != 0)	
			BEGIN			
				--Deleteting the old record and keeping new modified entry
				IF(@RowCount >= 1)
				BEGIN									
					DELETE FROM AUTO_EXERCISE_CONFIG WHERE IS_APPROVE = 1 AND SchemeId = @SchemeId
					UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 1  WHERE IS_APPROVE = 2 AND SchemeId = @SchemeId
					UPDATE AUDIT_TRAIL_SCHEMEAUTOEXERCISE SET IS_Update=1 WHERE SchemeId=@SchemeId
				END
			END
			IF(@IsApproveFlag = 0)
			BEGIN
				DELETE FROM ShSchemeSeparationRule WHERE ApprovalId= @ApprovalId and SchemeId=@SchemeId
				DELETE FROM ShScheme  WHERE SchemeId = @SchemeId
				UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 1  WHERE SchemeId = @SchemeId
			END
			ELSE IF(@IsApproveFlag = 3)
			BEGIN
				DELETE FROM ShSchemeSeparationRule WHERE ApprovalId= @ApprovalId and SchemeId=@SchemeId
				DELETE FROM ShScheme  WHERE SchemeId = @SchemeId
				DELETE FROM AUTO_EXERCISE_CONFIG WHERE SchemeId = @SchemeId				
			END
			ELSE IF(@IsApproveFlag = 2)
			BEGIN
				DELETE FROM ShScheme  WHERE SchemeId = @SchemeId
			END		
			DELETE FROM ShSchemeSeparationRule WHERE ApprovalId = @ApprovalId and SchemeId=@SchemeId
			DELETE FROM ShScheme  WHERE SchemeId = @SchemeId			
			SET @MESSAGE_OUT =(select IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))
		END
		ELSE IF(UPPER(@ACTION)='DISAPRROVE')
		BEGIN
			SET @RowCount = (SELECT COUNT(AEC_ID) FROM AUTO_EXERCISE_CONFIG  WHERE SchemeId = @SchemeId)		   
			SET @IsApproveFlag = (SELECT TOP 1(IS_APPROVE) FROM AUTO_EXERCISE_CONFIG  WHERE SchemeId = @SchemeId)
			
			IF(@IsApproveFlag != 0)	
			BEGIN			
				--Deleteting the New Modified record and keeping old entry
				IF(@RowCount >1)
				BEGIN
					DELETE FROM AUTO_EXERCISE_CONFIG WHERE IS_APPROVE =2 AND SchemeId=@SchemeId
					UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 1  WHERE IS_APPROVE=1 AND SchemeId=@SchemeId					
				END
			END
			
			DELETE FROM ShSchemeSeparationRule WHERE ApprovalId= @ApprovalId and SchemeId=@SchemeId
			DELETE FROM ShScheme  WHERE SchemeId = @SchemeId
						
			IF(@RowCount = 1)
			BEGIN			
				--DISAPPROVE RECORD AT FIRST TIME RECORD INSERTED OR REJECTED
				UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 0 WHERE  SchemeId = @SchemeId
								
				IF(@IsApproveFlag=0)
					DELETE FROM AUTO_EXERCISE_CONFIG WHERE SchemeId=@SchemeId AND IS_APPROVE=0
			END
			SET @MESSAGE_OUT =(select IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))			
	    END
		ELSE IF(UPPER(@ACTION)='EDIT')
		BEGIN
			/*IF MIT_ID =3,4 THEN UPDATE IS_ADS_SCHEME = 1 */
		    SELECT 
				@IS_ADS_SCHEME = CASE WHEN(UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END,
				@IS_ADS_EX_OPTS_ALLOWED = CASE WHEN (UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0)END
			FROM 
				MST_INSTRUMENT_TYPE MIT INNER JOIN MST_COM_CODE MCC ON
				MCC.MCC_ID=MIT.INSTRUMENT_GROUP AND MIT.MIT_ID=@MIT_ID
				
			SET @RowCount = (SELECT COUNT(AEC_ID) FROM AUTO_EXERCISE_CONFIG WHERE SchemeId = @SchemeId)
			IF(@RowCount <=2)
			BEGIN
			
				IF EXISTS (SELECT * FROM AUTO_EXERCISE_CONFIG WHERE SCHEMEID = @SCHEMEID AND IS_APPROVE = 2)
				BEGIN
					DELETE FROM AUTO_EXERCISE_CONFIG WHERE IS_APPROVE = 2 AND SCHEMEID = @SCHEMEID
				END
				
				INSERT INTO AUTO_EXERCISE_CONFIG
				(
					SchemeId, EXERCISE_ON, EXERCISE_AFTER_DAYS, COUNTRY_ID, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, 
					CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_APPROVE, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON,
					IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS 
				)
				VALUES
				(
					@SchemeId, @EXERCISE_ON ,@EXERCISE_AFTER_DAYS, @COUNTRY_ID, @IS_EXCEPTION_ENABLED, @EXECPTION_FOR, @EXECPTION_LIST,
					@CALCULATE_TAX, @CALCUALTE_TAX_PRIOR_DAYS, 2, @LastUpdatedBy, @LastUpdatedOn, @LastUpdatedBy,
					@LastUpdatedOn, @IS_MAIL_ENABLE, @MAIL_BEFORE_DAYS, @MAIL_REMINDER_DAYS 
				)				
			END
	       
			INSERT INTO ShScheme 
			(
				ApprovalId, SchemeId, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset,
				VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset,
				ExercisePeriodStartsAfter, LastUpdatedBy, LastUpdatedOn, Action, PeriodUnit, UnVestedCancelledOptions, 
				VestedCancelledOptions, LapsedOptions, IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, 
				PUPExedPayoutProcess, PUPFORMULAID, IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED, MIT_ID, IS_AUTO_EXERCISE_ALLOWED, 
				CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS,CALCULATE_TAX_PREVESTING,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
			)
			VALUES
			(
				@ApprovalId, @SchemeId, @SchemeTitle, @AdjustResidueOptionsIn, @VestingOverPeriodOffset, @VestingStartOffset,
				@VestingFrequency, @LockInPeriod, @LockInPeriodStartsFrom, @OptionRatioMultiplier, @OptionRatioDivisor, 
				@ExercisePeriodOffset, @ExercisePeriodStartsAfter, @LastUpdatedBy, @LastUpdatedOn, 'U', @PeriodUnit, 
				@UnVestedCancelledOptions, @VestedCancelledOptions, @LapsedOptions, @IsPUPEnabled, @DisplayExPrice, @DisplayExpDate,
				@DisplayPerqVal, @DisplayPerqTax, @PUPExedPayoutProcess, @PUPFORMULAID, @IS_ADS_SCHEME, @IS_ADS_EX_OPTS_ALLOWED,
				@MIT_ID, @IS_AUTO_EXERCISE_ALLOWED, @CALCULATE_TAX, @CALCUALTE_TAX_PRIOR_DAYS,@CALCULATE_TAX_PREVESTING,@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
			)
					    
			INSERT INTO #TEMP_AUTO_EXERCISE_OLD
			SELECT 
				AEC_ID ,SchemeId, EXERCISE_ON, EXERCISE_AFTER_DAYS, COUNTRY_ID, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, CALCULATE_TAX,
				CALCUALTE_TAX_PRIOR_DAYS, IS_APPROVE, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, CREATED_BY, CREATED_ON,
				UPDATED_BY, UPDATED_ON				
			FROM 
				AUTO_EXERCISE_CONFIG  
			WHERE  
				SchemeId = @SchemeId AND IS_APPROVE=1
			INSERT INTO #TEMP_AUTO_EXERCISE_NEW
			SELECT 
				AEC_ID, SchemeId, EXERCISE_ON, EXERCISE_AFTER_DAYS, COUNTRY_ID, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST,
				CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_APPROVE, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS,
				CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON 
			FROM 
				AUTO_EXERCISE_CONFIG  
			WHERE 
				SchemeId = @SchemeId AND IS_APPROVE=2
			INSERT INTO #TEMP_FIELD_NAMES
			SELECT
				SYSCOL.NAME COLUMN_NAME, SYSTYP.NAME DATA_TYPE, SYSTYP.NAME, 0, NULL, NULL
			FROM
				SYS.COLUMNS SYSCOL
			INNER JOIN SYS.TABLES SYSTAB ON SYSCOL.OBJECT_ID = SYSTAB.OBJECT_ID 
			INNER JOIN SYS.TYPES SYSTYP ON SYSTYP.SYSTEM_TYPE_ID = SYSCOL.SYSTEM_TYPE_ID
			WHERE 
				SYSTAB.NAME = 'AUTO_EXERCISE_CONFIG' AND SYSCOL.NAME NOT IN('CREATED_BY','UPDATED_BY','CREATED_ON','UPDATED_ON','AEC_ID','SchemeId','IS_APPROVE')
				AND SYSTYP.NAME NOT IN('sysname')
					
			SET @i = 1

			WHILE (@i <= (SELECT MAX(F_ID) FROM #TEMP_FIELD_NAMES))
						
			BEGIN
				SET @Temp_Field =( SELECT FIELD_NAME FROM #TEMP_FIELD_NAMES WHERE F_ID = @i)	
				SET @SqlString ='SELECT @Old_Value='+@Temp_Field+' FROM #TEMP_AUTO_EXERCISE_OLD '	
						
				EXEC sp_executesql @SqlString, N'@Old_Value nvarchar(max) output', @Old_Value OUTPUT						 
				SET @SqlString ='SELECT @New_Value='+@Temp_Field+' FROM #TEMP_AUTO_EXERCISE_NEW '
				EXEC sp_executesql @SqlString, N'@New_Value nvarchar(max) output', @New_Value OUTPUT
				
				IF(@Old_Value <> @New_Value)
					BEGIN				
						IF (@Old_Value  = 'NA')
							BEGIN				
								SET @Isupdated = 2	
							END
						ELSE
							BEGIN
								SET @Isupdated = 1	
							END
            		END
				ELSE
					BEGIN				
						SET @Isupdated = 2	
					END
				
				--THIS IS FOR RESIDENT/COUNTRY SOLUTION
				BEGIN TRY					
					SET @IS_UPDATE = CONVERT(INT, (SELECT IS_UPDATE FROM #TEMP_FIELD_NAMES WHERE F_ID = 10))
					IF(@IS_UPDATE = 1)
					UPDATE #TEMP_FIELD_NAMES SET IS_UPDATE = 1 WHERE  F_ID = 9
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION		
				END CATCH
				--END FOR THE COUNTRY/RESIDENT 
				
				UPDATE #TEMP_FIELD_NAMES SET 
					OLD_VALUE =  @Old_Value, NEW_VALUE = @New_Value, IS_UPDATE = @Isupdated, 
					CREATED_BY = @LastUpdatedBy, CREATED_ON = @LastUpdatedOn
				WHERE F_ID = @i  
				
				SET @i=@i+1      
			END         						
			SET @AEC_ID=(SELECT IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))	     			
			INSERT INTO AUDIT_TRAIL_SCHEMEAUTOEXERCISE
			(
				AEC_ID, SchemeId, Field_Name, Old_value, New_Value, IS_UpDate, Created_By, Created_On, Updated_By, Updated_On
			)
			SELECT 
				@AEC_ID, @SchemeId, FIELD_NAME, OLD_VALUE, NEW_VALUE, 2, CREATED_BY, CREATED_ON, CREATED_BY, CREATED_ON 
			FROM 
				#TEMP_FIELD_NAMES 
			WHERE 
				IS_UPDATE = 1		
			
			DROP TABLE #TEMP_AUTO_EXERCISE_OLD
			DROP TABLE #TEMP_AUTO_EXERCISE_NEW
			DROP TABLE #TEMP_FIELD_NAMES
			SET @MESSAGE_OUT =(SELECT IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))
			SELECT @MESSAGE_OUT,@SchemeId			
		END
		ELSE IF(UPPER(@ACTION)='DELETE') 
		BEGIN
			INSERT INTO ShScheme 
			(
				 ApprovalId, SchemeId, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset, VestingFrequency,
				 LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset, ExercisePeriodStartsAfter, 
				 LastUpdatedBy, LastUpdatedOn, Action, PeriodUnit, UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions,
				 IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPExedPayoutProcess, PUPFORMULAID, 
				 IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED, MIT_ID, IS_AUTO_EXERCISE_ALLOWED,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCULATE_TAX_PREVESTING,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING		
			)
			VALUES
			(
				@ApprovalId, @SchemeId, @SchemeTitle, @AdjustResidueOptionsIn, @VestingOverPeriodOffset, @VestingStartOffset, 
				@VestingFrequency, @LockInPeriod, @LockInPeriodStartsFrom, @OptionRatioMultiplier, @OptionRatioDivisor, 
				@ExercisePeriodOffset, @ExercisePeriodStartsAfter, @LastUpdatedBy, @LastUpdatedOn, 'D', @PeriodUnit, 
				@UnVestedCancelledOptions, @VestedCancelledOptions, @LapsedOptions, @IsPUPEnabled, @DisplayExPrice, 
				@DisplayExpDate, @DisplayPerqVal, @DisplayPerqTax, @PUPExedPayoutProcess, @PUPFORMULAID, @IS_ADS_SCHEME, 
				@IS_ADS_EX_OPTS_ALLOWED, @MIT_ID, @IS_AUTO_EXERCISE_ALLOWED,@CALCULATE_TAX,@CALCUALTE_TAX_PRIOR_DAYS,@CALCULATE_TAX_PREVESTING,@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
			)
					
			INSERT INTO ShSchemeSeparationRule 
			(
				ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor,
				LastUpdatedBy, LastUpdatedOn, OthersReason, PeriodUnit, IsRuleBypassed
			)
			SELECT 
				ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor,
				LastUpdatedBy,LastUpdatedOn,OthersReason,PeriodUnit,IsRuleBypassed 
			FROM SchemeSeperationRule 
			WHERE ApprovalId = @ApprovalId AND SchemeId = @SchemeId
								
			UPDATE AUTO_EXERCISE_CONFIG SET IS_APPROVE = 3 WHERE  SchemeId = @SchemeId
			UPDATE Scheme SET Status = 'N', LastUpdatedBy = @LastUpdatedBy, LastUpdatedOn = @LastUpdatedOn WHERE SchemeId =@SchemeId			
			SET @MESSAGE_OUT =(select IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))
		END
			SET @MESSAGE_OUT =(SELECT IDENT_CURRENT('AUTO_EXERCISE_CONFIG'))
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION		
	END CATCH
	
	SET NOCOUNT OFF;	
END
GO
