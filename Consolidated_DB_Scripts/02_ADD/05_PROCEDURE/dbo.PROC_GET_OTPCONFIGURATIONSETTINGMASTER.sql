/****** Object:  StoredProcedure [dbo].[PROC_GET_OTPCONFIGURATIONSETTINGMASTER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [PROC_GET_OTPCONFIGURATIONSETTINGMASTER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OTPCONFIGURATIONSETTINGMASTER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [PROC_GET_OTPCONFIGURATIONSETTINGMASTER]


AS
BEGIN

SET NOCOUNT ON;  

	  SELECT 
			OTPConfigurationSettingMasterID,
			OTPConfigurationTypeID,
			OTPExpirationTimeInSeconds,
			OTPDigits,
			AttemptAllowed,
			IsOTPResendButtonEnable,
			IsAlphaNumeric
			IsActive,
			CREATED_BY,
			CREATED_ON,
			UPDATED_BY,
			UPDATED_ON,
			IsChkOTPForSecondary,
			OTPConfigurationFieldID 
FROM OTPConfigurationSettingMaster where OTPConfigurationFieldID = 2

SET NOCOUNT OFF;  
END  
GO
