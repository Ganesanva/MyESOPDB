/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_OTP_DETAILS_BY_USERID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_VALIDATE_OTP_DETAILS_BY_USERID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_OTP_DETAILS_BY_USERID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_VALIDATE_OTP_DETAILS_BY_USERID]
@OTPConfigurationSettingMasterID INT,
@EmployeeID NVARCHAR(100),
@OTPCode NVARCHAR(40)
AS
BEGIN
	DECLARE @CorrectOTPCode NVARCHAR(40);
	DECLARE @OTPExpiredOn DATETIME;
	DECLARE @IsAlreadyValidation BIT;

	SELECT @CorrectOTPCode= OTPCode  COLLATE Latin1_General_CS_AS, @OTPExpiredOn=OTPExpiredOn, @IsAlreadyValidation=ISNULL(IsValidated,0)
	FROM UserLoginOTPDetails  
	WHERE EmployeeID=@EmployeeID 
	AND OTPConfigurationSettingMasterID=@OTPConfigurationSettingMasterID 
	 
	--select @OTPExpiredOn,GETDATE()
	---Status 0 indicates OTP Already Validated.
	IF @IsAlreadyValidation=1
	BEGIN
		SELECT 0 AS ValidationStatus
	END
	---Status 1 indicates Validated Successfully.
	ELSE IF  ((@OTPCode) COLLATE Latin1_General_CS_AS = (@CorrectOTPCode) COLLATE Latin1_General_CS_AS ) AND CONVERT(DATETIME,@OTPExpiredOn) > CONVERT(DATETIME,GETDATE())
	BEGIN
		SELECT 1 AS ValidationStatus;
		UPDATE UserLoginOTPDetails
		SET IsValidated=1
		WHERE EmployeeID=@EmployeeID 
		AND OTPConfigurationSettingMasterID=@OTPConfigurationSettingMasterID
	END
	---Status 2 indicates OTP is Correct but time expired.
	ELSE IF (@OTPCode) COLLATE Latin1_General_CS_AS = (@CorrectOTPCode) COLLATE Latin1_General_CS_AS AND CONVERT(DATETIME,@OTPExpiredOn) < CONVERT(DATETIME,GETDATE())
	BEGIN
		SELECT 2 AS ValidationStatus
	END
	---Status 3 indicates OTP is InCorrect.
	ELSE IF (@OTPCode) COLLATE Latin1_General_CS_AS <> (@CorrectOTPCode) COLLATE Latin1_General_CS_AS 
	BEGIN
		SELECT 3 AS ValidationStatus
	END
	ELSE
	BEGIN
		SELECT -1 AS ValidationStatus
	END

END  

GO
