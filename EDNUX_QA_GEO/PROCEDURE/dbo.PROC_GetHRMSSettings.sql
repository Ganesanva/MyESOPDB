/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSSettings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetHRMSSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetHRMSSettings]
AS
BEGIN
	SELECT 
		CM.CompanyID AS DBList, HS.[UniqueIdentifier], HS.IsEmpRegEnabled, HS.AlertBeforeNoOfDaysForPerfVesting, HS.UserIDListForPerfVesting, HS.SFTPPathForPerfVesting,
		HS.FileNameForPerfVesting, HS.UserIDListForSchemeDet, HS.SFTPPathForSchemeDet, HS.FileNameForSchemeDet, HS.UserIDListForGrantDet,
		HS.SFTPPathForGrantDet, HS.FileNameForGrantDet, HS.IsSecureFile, HS.PublicKey, HS.SFTPPath, HS.SFTPFileName, HS.WriteToFileLogPath,   
		HS.ProcessedFilePath, HS.IsIncrementalData, HS.IsSecureFile, HS.TakeDatabaseBackUp, HS.ShowDetailsLog,  HS.MailSubject, HS.MailFrom, HS.MailFromDisplayName,   
		HS.MailTo, HS.MailCC, HS.MailBCC, HS.IsMailSentToClient, HS.ClientMailId AS ClientMailId, HS.MAIL_SUBJECT_FOR_CLIENT  
	FROM 
		HRMSSettings AS HS
		CROSS JOIN CompanyMaster AS CM
END
GO
