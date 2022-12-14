/****** Object:  StoredProcedure [dbo].[PROC_GetCookieStatus]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCookieStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCookieStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[PROC_GetCookieStatus] 
	@UserId		VARCHAR(20),
	@CookieName	NVARCHAR(500) = NULL,
	@IsNew		BIT,
	@ParamValue NVARCHAR (500) = NULL,
	@Token NVARCHAR(max)=NULL,
	@RetMsg		VARCHAR (500) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	Declare @ExpiryTime int
	SEt @ExpiryTime='01'
	DECLARE @NewCookieName NVARCHAR(500) = CONVERT(VARCHAR(100), NEWID()) + '~' + (SELECT UPPER(DATENAME(dw,GETDATE())))
	
	IF UPPER(@ParamValue) = 'LOGOUT'
	BEGIN
	    --print 'Logout'
		DELETE FROM UserSessions WHERE UserId = @UserId
	END
	ELSE
	IF UPPER(@ParamValue) = 'EMPLOGIN'
	BEGIN
			IF NOT EXISTS (SELECT UserId FROM UserSessions WHERE UserId = @UserId AND CONVERT(CHAR(26), EXPIREON,120) > CONVERT(CHAR(28), GETDATE(),120))
			BEGIN
			
				DELETE FROM UserSessions WHERE UserId = @UserId
				INSERT INTO UserSessions VALUES (@UserId,@NewCookieName,(select DATEADD(MINUTE,@ExpiryTime, GETDATE())),@Token) 
			END
			ELSE
			IF EXISTS (SELECT UserId FROM UserSessions WHERE UserId = @UserId AND CONVERT(CHAR(26), EXPIREON,120) > CONVERT(CHAR(28), GETDATE(),120)) AND @IsNew <> 1
			BEGIN
				UPDATE  UserSessions  SET 
				CookieName = @NewCookieName,
				Jwt_Token=@Token,
				ExpireOn = (select DATEADD(MINUTE,@ExpiryTime, GETDATE()))
			    WHERE 
				UserId = @UserId			
			END
			ELSE
			BEGIN
				SET @RetMsg = 'Your previous session was not properly closed. Please login after '+ convert(nvarchar(10),@ExpiryTime)+' minutes.'
				SELECT 'F' AS [STATUS], @RetMsg AS [MESSAGE]
			END
	END
	ELSE
	BEGIN /*Main*/
		IF(@IsNew = 1)
		BEGIN
			IF NOT EXISTS (SELECT UserId FROM UserSessions WHERE UserId = @UserId)
			BEGIN
				INSERT INTO UserSessions VALUES (@UserId,@NewCookieName,(select DATEADD(MINUTE,20, GETDATE())),@Token) 
			END
			ELSE
			BEGIN
				SET @RetMsg = 'Your previous session was not properly closed. Please login after 20 minutes.'
				/*
				Declare @MAIL_BODY varchar(200)
				set @MAIL_BODY = 'UserID=' + @UserId 
				set @MAIL_BODY = @MAIL_BODY + 'Company Name=' + (select DB_NAME())
				EXEC msdb.dbo.sp_send_dbmail
				@recipients = 'vivek.hedau@esopdirect.com',
				@body = @MAIL_BODY,
				@body_format = 'HTML',
				@subject = 'Alert : PROC_GetCookieStatus',
				@from_address = 'noreply@esopdirect.com';
				*/
				PRINT @RetMsg
				Return 1
			END
			
		END
		ELSE
		BEGIN
			--Print 'For existing user'
			UPDATE 
				UserSessions 
			SET 
				CookieName = @NewCookieName,
				--@NewCookieName,
				ExpireOn = (select DATEADD(MINUTE,20, GETDATE()))
			WHERE 
				UserId = @UserId AND CookieName = @CookieName
			END
		
			SELECT TOP 1 * FROM UserSessions WHERE UserId = @UserId and CookieName = @NewCookieName ORDER BY EXPIREON DESC
		
		END  /*Main*/
	
	SET NOCOUNT OFF
	
END
GO
