/****** Object:  StoredProcedure [dbo].[PROC_SAVE_USER_LOGIN_OTP_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_USER_LOGIN_OTP_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_USER_LOGIN_OTP_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SAVE_USER_LOGIN_OTP_DETAILS]
@OTPConfigurationSettingMasterID INT,
@EmployeeID NVARCHAR(100),
@MobileNo NVARCHAR(40)=NULL,
@EmailID NVARCHAR(200),
@OTPCode NVARCHAR(40),
@OTPExpirationTimeInSeconds INT
AS
BEGIN
	  
      IF EXISTS(SELECT * FROM UserLoginOTPDetails WHERE EmployeeID=@EmployeeID AND OTPConfigurationSettingMasterID=@OTPConfigurationSettingMasterID)
	  BEGIN
			UPDATE UserLoginOTPDetails
			SET OTPCode=@OTPCode,
			OTPSentOn=GETDATE(),
			OTPExpiredOn=DATEADD(ss,@OTPExpirationTimeInSeconds,GETDATE()),
			IsValidated=0,
			UPDATED_BY=@EmployeeID,
			UPDATED_ON=GETDATE()
			WHERE EmployeeID=@EmployeeID 
			AND OTPConfigurationSettingMasterID=@OTPConfigurationSettingMasterID
	  END
	  ELSE
	  BEGIN
			INSERT INTO UserLoginOTPDetails(OTPConfigurationSettingMasterID,
											EmployeeID,
											MobileNo,
											EmailID,
											OTPCode,
											OTPSentOn,
											OTPExpiredOn,
											IsValidated,
											CREATED_BY,
											CREATED_ON,
											UPDATED_BY,
											UPDATED_ON
											)
			VALUES(@OTPConfigurationSettingMasterID,
					@EmployeeID,
					@MobileNo,
					@EmailID,
					@OTPCode,
					GETDATE(),
					DATEADD(ss,@OTPExpirationTimeInSeconds,GETDATE()),
					0,
					@EmployeeID,
					GETDATE(),
					@EmployeeID,
					GETDATE()
					)
	  END
END  

GO
