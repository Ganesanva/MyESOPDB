/****** Object:  StoredProcedure [dbo].[PROC_GET_OTP_CONFIGURATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OTP_CONFIGURATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OTP_CONFIGURATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PROC_GET_OTP_CONFIGURATION]
@OTPConfigurationTypeID INT,
@OTPConfigurationFieldID INT=Null
AS
BEGIN
      SELECT OCSM.*,
	  (SELECT TOP 1 ISNULL(EM.IsActivatedOTPviaEmailFor,0) FROM CompanyMaster EM) AS IsActivatedOTPviaEmailFor,
	  (SELECT TOP 1 ISNULL(EM.OTPAuthApplicableUserType,0) FROM CompanyMaster EM) AS OTPAuthApplicableUserType,
	  (SELECT TOP 1 ISNULL(EM.AuthenticationModeID,0) FROM CompanyMaster EM) AS AuthenticationModeID,
	  ISNULL(IsChkOTPForSecondary,0) as IsChkOTPForSecondary
	  FROM OTPConfigurationSettingMaster OCSM
	  WHERE OCSM.OTPConfigurationTypeID=@OTPConfigurationTypeID 
	  AND ISNULL(OCSM.IsActive,0)=1 AND  OTPConfigurationFieldID = @OTPConfigurationFieldID
END  
GO
