/****** Object:  StoredProcedure [dbo].[PROC_INSERT_MAILS_SPOOLS]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_MAILS_SPOOLS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_MAILS_SPOOLS]    Script Date: 7/8/2022 3:00:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   PROCEDURE [dbo].[PROC_INSERT_MAILS_SPOOLS]
@TO VARCHAR(100),
@FROM VARCHAR(50),
@CC VARCHAR(50),
@SUBJECT nvarchar(max),
@DESCRIPTION NVARCHAR(MAX),
@ATTACHMENT VARCHAR(50)
AS
BEGIN

Declare @MessageID VARCHAR(50)
SET @MessageID=(Select ISNULL(max(messageid),0)+1 as messageid from MailerDB..MailSpool)
INSERT INTO MailerDB..MailSpool ([MessageID],[From],[To],[Subject],[Description],[deliveryNotify], [MailSentOn],[Cc],[Bcc])
VALUES(@MessageID,@FROM,@TO,@SUBJECT,@DESCRIPTION,'S',null,@cc,null)

END

