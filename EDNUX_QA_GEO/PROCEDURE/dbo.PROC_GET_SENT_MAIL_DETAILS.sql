/****** Object:  StoredProcedure [dbo].[PROC_GET_SENT_MAIL_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SENT_MAIL_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SENT_MAIL_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SENT_MAIL_DETAILS]
	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT [To], [Cc], [Bcc],  
	REPLACE([Subject], 'Data and Report Exchange - ','') AS [Subject],
	REPLACE(REPLACE(CONVERT(NVARCHAR(MAX), [DESCRIPTION]),'<', '&lt;'),'>', '&gt;') MailBody, 
	CONVERT(VARCHAR(12), REPLACE(CONVERT(NVARCHAR, CreatedOn, 106), ' ', '/'))  + ' ' + CONVERT(VARCHAR(8), CreatedOn, 108) + ' ' + RIGHT(CONVERT(VARCHAR(30), CreatedOn, 9), 2) AS MailSentOn
	FROM MailerDB..MailSpool
	WHERE [Subject] like '%Data and Report Exchange - %' ORDER BY CreatedOn DESC
	
	SET NOCOUNT OFF;
END
GO
