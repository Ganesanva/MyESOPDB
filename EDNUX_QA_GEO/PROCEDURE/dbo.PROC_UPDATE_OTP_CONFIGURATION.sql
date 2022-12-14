/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_OTP_CONFIGURATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_OTP_CONFIGURATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_OTP_CONFIGURATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UPDATE_OTP_CONFIGURATION]
@OTPExpirationTimeInSeconds INT,
@OTPConfigurationTypeID INT
AS
BEGIN
	  
      IF EXISTS(SELECT 1 FROM OTPConfigurationSettingMaster WHERE OTPConfigurationTypeID=@OTPConfigurationTypeID)
	  BEGIN
			UPDATE OTPConfigurationSettingMaster
			SET OTPExpirationTimeInSeconds=@OTPExpirationTimeInSeconds
			WHERE OTPConfigurationTypeID=@OTPConfigurationTypeID
	  END
END  
GO
