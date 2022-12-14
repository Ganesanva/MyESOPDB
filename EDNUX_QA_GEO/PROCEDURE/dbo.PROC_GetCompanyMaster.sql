/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyMaster]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCompanyMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[PROC_GetCompanyMaster]
AS
BEGIN
     SELECT 
		CM.CompanyID, CM.CompanyName, CM.CompanyAddress, CM.CompanyURL, CM.CompanyEmailID, CM.AdminEmailID, CM.AdminUserID, CM.AdminPassword, 
		CM.StockExchangeType, CM.StockExchangeCode, CM.LastUpdatedBy, CM.SMPTServerIp, CM.SMPTServerPort, CM.LastUpdatedOn, CM.MaxLoginAttempts,
		CM.ISFUNDINGALLOWED, CM.IsNominationEnabled, CM.DMSetting_Note, CM.IsSSOActivated, CM.SITEURL, CM.FMVCalculation_Note, CM.IsPUPEnabled,
		CM.DisplayAs, CM.BaseCurrencyID, CM.VwMenuForGrpCompany, CM.IS_ADS_ENABLED, CM.IsListingEnabled, CM.IS_EGRANTS_ENABLED, CM.IS_SCHWISE_DOC_UPLOAD,
		CM.IS_CONSENT_SET, CM.CONSENT_MESSAGE, ISNULL(CM.AuthenticationModeID,0) AS AuthenticationModeID,CP.ListedYN, CM.IS_EULA_SET, 
		ISNULL(OTPAuthApplicableUserType,0) AS OTPAuthApplicableUserType,
		ISNULL(IS_VALIDATE_IP_CONFIG_ENABLED,0) as IS_VALIDATE_IP_CONFIG_ENABLED,ISNULL(CM.IS_FUTURE_SEPRATION_ALLOW,0) AS IS_FUTURE_SEPRATION_ALLOW
	FROM 
		CompanyMaster AS CM
		INNER JOIN CompanyParameters AS CP ON CP.CompanyID = CM.CompanyID	
END  
GO
