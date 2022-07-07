/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PUP_PARAMETER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_PUP_PARAMETER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PUP_PARAMETER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_CRUD_PUP_PARAMETER]

		@TYPE							VARCHAR(20),
		@VESTING_ALERT_IN_DAYS			SMALLINT	= 0,
		@EXPIRY_ALERT_IN_DAYS			SMALLINT	= 0,
		@IS_SEND_VEST_ALERT_REQUIRED	BIT			= 0,
		@IS_SEND_EXPIRY_ALERT_REQUIRED	BIT			= 0,
		@VESTING_ALERT_REMINDER_IN_DAYS	CHAR		= NULL,
		@EXPIRY_ALERT_REMINDER_IN_DAYS	CHAR 		= NULL,
		@IS_BEFORE_VEST_DATE_REQUIRED	BIT			= 0,
		@IS_PREQ_TAX_CALN_REQUIRED		BIT			= 0,
		@IS_PERQ_VAL_CALN_REQUIRED		BIT			= 0,
		@IS_MULTIPLE_GRANT_EX_REQUIRED	BIT			= 1,
		@IS_EX_COMPLETE_VEST_REQUIRED	BIT			= 0,
		@IS_MULTIPLE_VEST_EX_REQUIRED	BIT			= 1,
		@MIN_NO_OF_EX_OPTIONS			NVARCHAR(5)	= NULL,
		@MULTIPLE_NO_OF_EX_OPTIONS		NVARCHAR(5)	= NULL,
		@EX_AT_ONE_GO_IN_LAST_TRN		BIT		 	= 0,
		@IS_EX_SEPARATELY				BIT		 	= 0,
		@RESIDENTAIL_STATUS_PUP			VARCHAR		= NULL,
		@EXERCISE_FORM_TEXT_1			VARCHAR(MAX)= NULL,
		@EXERCISE_FORM_TEXT_2			VARCHAR(MAX)= NULL,
		@EXERCISE_FORM_TEXT_3			VARCHAR(MAX)= NULL,
		@MSG_NOTE_ON_EXNOW_SCREEN		VARCHAR(MAX)= NULL,
		@LAST_UPDATED_BY				VARCHAR(50) = NULL,
		@LAST_UPDATED_ON				DATETIME	= NULL

AS

BEGIN
	
	SET NOCOUNT ON
		IF(@TYPE='R')
		BEGIN
			SELECT	VESTING_ALERT_IN_DAYS,EXPIRY_ALERT_IN_DAYS,IS_SEND_VEST_ALERT_REQUIRED,
					IS_SEND_EXPIRY_ALERT_REQUIRED,VESTING_ALERT_REMINDER_IN_DAYS,EXPIRY_ALERT_REMINDER_IN_DAYS,IS_BEFORE_VEST_DATE_REQUIRED,
					IS_PREQ_TAX_CALN_REQUIRED,IS_PERQ_VAL_CALN_REQUIRED,IS_MULTIPLE_GRANT_EX_REQUIRED,IS_EX_COMPLETE_VEST_REQUIRED,
					IS_MULTIPLE_VEST_EX_REQUIRED,MIN_NO_OF_EX_OPTIONS,MULTIPLE_NO_OF_EX_OPTIONS,EX_AT_ONE_GO_IN_LAST_TRN,IS_EX_SEPARATELY,
					LAST_UPDATED_BY,LAST_UPDATED_ON			
			FROM PUP_PARAMETER
				  
			SELECT id,[Description],ResidentialStatus FROM ResidentialType	
			
			SELECT 
					RPM.ExerciseFormText1,
					RPM.ExerciseFormText2,
					RPM.ExerciseFormText3,
					RPM.ProcessNote,
					PM.ID,					
					PM.PaymentMode
					
			FROM	ResidentialPaymentMode RPM
					INNER JOIN ResidentialType RT
						ON RT.id = RPM.ResidentialType_Id
					INNER JOIN PaymentMaster PM
						ON PM.Id = RPM.PaymentMaster_Id
			WHERE	RT.ResidentialStatus = @RESIDENTAIL_STATUS_PUP
			AND		PM.PaymentMode = 'X'
			
			
		END
		
		IF(@TYPE='U')
		BEGIN
			BEGIN TRY
				-- INSERT RECORD INTO AUDIT TRAIL REPORT
				INSERT INTO AUDIT_TRAIL_PUP_PARAMETER 
						(C_VESTING_ALERT_IN_DAYS,P_VESTING_ALERT_IN_DAYS,C_EXPIRY_ALERT_IN_DAYS,P_EXPIRY_ALERT_IN_DAYS,
						 C_IS_SEND_VEST_ALERT_REQUIRED,P_IS_SEND_VEST_ALERT_REQUIRED,C_IS_SEND_EXPIRY_ALERT_REQUIRED,P_IS_SEND_EXPIRY_ALERT_REQUIRED,
						 C_VESTING_ALERT_REMINDER_IN_DAYS,P_VESTING_ALERT_REMINDER_IN_DAYS,C_EXPIRY_ALERT_REMINDER_IN_DAYS,P_EXPIRY_ALERT_REMINDER_IN_DAYS,
						 C_IS_BEFORE_VEST_DATE_REQUIRED,P_IS_BEFORE_VEST_DATE_REQUIRED,C_IS_PREQ_TAX_CALN_REQUIRED,P_IS_PREQ_TAX_CALN_REQUIRED,C_IS_PERQ_VAL_CALN_REQUIRED,
						 P_IS_PERQ_VAL_CALN_REQUIRED,C_IS_MULTIPLE_GRANT_EX_REQUIRED,P_IS_MULTIPLE_GRANT_EX_REQUIRED,C_IS_EX_COMPLETE_VEST_REQUIRED,P_IS_EX_COMPLETE_VEST_REQUIRED,
						 C_IS_MULTIPLE_VEST_EX_REQUIRED,P_IS_MULTIPLE_VEST_EX_REQUIRED,C_MIN_NO_OF_EX_OPTIONS,P_MIN_NO_OF_EX_OPTIONS,C_MULTIPLE_NO_OF_EX_OPTIONS,P_MULTIPLE_NO_OF_EX_OPTIONS,
						 C_EX_AT_ONE_GO_IN_LAST_TRN,P_EX_AT_ONE_GO_IN_LAST_TRN,C_IS_EX_SEPARATELY,P_IS_EX_SEPARATELY,C_LAST_UPDATED_BY,P_LAST_UPDATED_BY,C_LAST_UPDATED_ON,P_LAST_UPDATED_ON
						)
				SELECT	@VESTING_ALERT_IN_DAYS,VESTING_ALERT_IN_DAYS, @EXPIRY_ALERT_IN_DAYS, EXPIRY_ALERT_IN_DAYS,
						@IS_SEND_VEST_ALERT_REQUIRED, IS_SEND_VEST_ALERT_REQUIRED, @IS_SEND_EXPIRY_ALERT_REQUIRED,IS_SEND_EXPIRY_ALERT_REQUIRED,
						@VESTING_ALERT_REMINDER_IN_DAYS,VESTING_ALERT_REMINDER_IN_DAYS,@EXPIRY_ALERT_REMINDER_IN_DAYS,EXPIRY_ALERT_REMINDER_IN_DAYS,
						@IS_BEFORE_VEST_DATE_REQUIRED,IS_BEFORE_VEST_DATE_REQUIRED,@IS_PREQ_TAX_CALN_REQUIRED,IS_PREQ_TAX_CALN_REQUIRED,
						@IS_PERQ_VAL_CALN_REQUIRED,IS_PERQ_VAL_CALN_REQUIRED,@IS_MULTIPLE_GRANT_EX_REQUIRED,IS_MULTIPLE_GRANT_EX_REQUIRED,
						@IS_EX_COMPLETE_VEST_REQUIRED,IS_EX_COMPLETE_VEST_REQUIRED,@IS_MULTIPLE_VEST_EX_REQUIRED,IS_MULTIPLE_VEST_EX_REQUIRED,
						@MIN_NO_OF_EX_OPTIONS,MIN_NO_OF_EX_OPTIONS,@MULTIPLE_NO_OF_EX_OPTIONS,MULTIPLE_NO_OF_EX_OPTIONS,
						@EX_AT_ONE_GO_IN_LAST_TRN,EX_AT_ONE_GO_IN_LAST_TRN,@IS_EX_SEPARATELY,IS_EX_SEPARATELY,
						@LAST_UPDATED_BY,LAST_UPDATED_BY,@LAST_UPDATED_ON,LAST_UPDATED_ON
				FROM PUP_PARAMETER
				
				--UPDATE PUP_PARAMETER TABLE SETTINGS
				UPDATE PUP_PARAMETER SET 
						VESTING_ALERT_IN_DAYS=@VESTING_ALERT_IN_DAYS,
						EXPIRY_ALERT_IN_DAYS=@EXPIRY_ALERT_IN_DAYS,
						IS_SEND_VEST_ALERT_REQUIRED=@IS_SEND_VEST_ALERT_REQUIRED,
						IS_SEND_EXPIRY_ALERT_REQUIRED=@IS_SEND_EXPIRY_ALERT_REQUIRED,
						VESTING_ALERT_REMINDER_IN_DAYS=@VESTING_ALERT_REMINDER_IN_DAYS,
						EXPIRY_ALERT_REMINDER_IN_DAYS=@EXPIRY_ALERT_REMINDER_IN_DAYS,
						IS_BEFORE_VEST_DATE_REQUIRED=@IS_BEFORE_VEST_DATE_REQUIRED,
						IS_PREQ_TAX_CALN_REQUIRED=@IS_PREQ_TAX_CALN_REQUIRED,
						IS_PERQ_VAL_CALN_REQUIRED=@IS_PERQ_VAL_CALN_REQUIRED,
						IS_MULTIPLE_GRANT_EX_REQUIRED=@IS_MULTIPLE_GRANT_EX_REQUIRED,
						IS_EX_COMPLETE_VEST_REQUIRED=@IS_EX_COMPLETE_VEST_REQUIRED,
						IS_MULTIPLE_VEST_EX_REQUIRED=@IS_MULTIPLE_VEST_EX_REQUIRED,
						MIN_NO_OF_EX_OPTIONS=@MIN_NO_OF_EX_OPTIONS,
						MULTIPLE_NO_OF_EX_OPTIONS=@MULTIPLE_NO_OF_EX_OPTIONS,
						EX_AT_ONE_GO_IN_LAST_TRN=@EX_AT_ONE_GO_IN_LAST_TRN,
						IS_EX_SEPARATELY=@IS_EX_SEPARATELY,
						LAST_UPDATED_BY=@LAST_UPDATED_BY,
						LAST_UPDATED_ON=@LAST_UPDATED_ON
				
				-- UPDATE RESIDENTIAL PAYMENT MODE DETAILS
				UPDATE RPM
				SET		RPM.ExerciseFormText1=@EXERCISE_FORM_TEXT_1,
						RPM.ExerciseFormText2=@EXERCISE_FORM_TEXT_2,
						RPM.ExerciseFormText3=@EXERCISE_FORM_TEXT_3,
						RPM.ProcessNote=@MSG_NOTE_ON_EXNOW_SCREEN			
				FROM   ResidentialPaymentMode RPM 
						INNER JOIN ResidentialType RT 
							ON RT.id = RPM.ResidentialType_Id
						INNER JOIN PaymentMaster PM 
							ON PM.Id = RPM.PaymentMaster_Id
				WHERE	RT.ResidentialStatus=@RESIDENTAIL_STATUS_PUP 
				AND		PM.PaymentMode='X'
								
			END TRY
			BEGIN CATCH
				SELECT ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE(),'Error occured while updating record.' Result
			END CATCH	
		
			IF(@@ERROR = 0)
				SELECT 'Data Updated Successfully.' AS RESULT		
		END
END
GO
