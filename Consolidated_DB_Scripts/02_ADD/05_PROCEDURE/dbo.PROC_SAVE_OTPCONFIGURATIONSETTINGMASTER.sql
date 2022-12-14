/****** Object:  StoredProcedure [dbo].[PROC_SAVE_OTPCONFIGURATIONSETTINGMASTER]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [PROC_SAVE_OTPCONFIGURATIONSETTINGMASTER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_OTPCONFIGURATIONSETTINGMASTER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [PROC_SAVE_OTPCONFIGURATIONSETTINGMASTER]

	@IsChkOTPForSecondary BIT,
	@OTPExpirationTimeInSeconds INT = NULL,	
	@OTPDigits INT = NULL,
	@AttemptAllowed INT = NULL	,
	@IsOTPResendButtonEnable BIT = NULL,	
	@IsActive BIT = NULL,
	@CREATED_BY NVARCHAR(200) =NULL,		
	@UPDATED_BY NVARCHAR(200) = NULL

AS
BEGIN
SET NOCOUNT ON;  	 
	 
      IF EXISTS(SELECT OTPConfigurationSettingMasterID FROM OTPConfigurationSettingMaster  WHERE OTPConfigurationFieldID = 2)
	  BEGIN
			UPDATE OTPConfigurationSettingMaster
			SET OTPExpirationTimeInSeconds = @OTPExpirationTimeInSeconds,
			IsChkOTPForSecondary = @IsChkOTPForSecondary			
			WHERE OTPConfigurationFieldID=2 
			
	  END
SET NOCOUNT OFF;  
END  
GO
