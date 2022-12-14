/****** Object:  StoredProcedure [dbo].[PROC_TRANS_REVERSAL_ALERT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TRANS_REVERSAL_ALERT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TRANS_REVERSAL_ALERT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_TRANS_REVERSAL_ALERT]
	@MAIL_TO			NVARCHAR(100),  
	@MAIL_SUBJECT		NVARCHAR(100),  
	@MAIL_BODY			NVARCHAR(MAX),
	@Result				INT OUT 
AS
BEGIN
	BEGIN TRY	 
		
		DECLARE @MAXMSGID BIGINT, @MAIL_FROM NVARCHAR(50)

		SET @MAXMSGID = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)

		SET @MAIL_FROM= (SELECT CompanyEmailID FROM CompanyParameters)
		
		INSERT INTO MailerDB..[MailSpool]
		(
			[MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], 
			[Bcc], [FailureSendMailAttempt], [CreatedOn]
		)
		VALUES
		(
			@MAXMSGID, @MAIL_FROM, @MAIL_TO, @MAIL_SUBJECT, @MAIL_BODY, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() 
		)	
		SET @Result = 1				
					
	END TRY
	BEGIN CATCH
		SET @Result = 0				
	END CATCH     
END       
GO
