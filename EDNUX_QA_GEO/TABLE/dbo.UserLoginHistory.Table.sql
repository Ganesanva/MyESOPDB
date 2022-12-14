/****** Object:  Table [dbo].[UserLoginHistory]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserLoginHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserLoginHistory](
	[Idt] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](20) NULL,
	[LoginDate] [datetime] NULL,
	[LogOutDate] [datetime] NULL,
	[OldLoginAttempt] [tinyint] NULL,
	[NewLoginAttempt] [tinyint] NULL,
	[IP_ADDRESS] [varchar](50) NULL,
	[CONTINENT_CODE] [varchar](10) NULL,
	[CONTINENT_NAME] [varchar](100) NULL,
	[COUNTRY_NAME] [varchar](150) NULL,
	[REGION_CODE] [varchar](100) NULL,
	[REGION_NAME] [varchar](100) NULL,
	[CITY] [varchar](100) NULL,
	[POSTAL_CODE] [varchar](50) NULL,
	[METRO_CODE] [varchar](100) NULL,
	[AREA_CODE] [varchar](100) NULL,
	[LATITUDE] [varchar](100) NULL,
	[LONGITUDE] [varchar](100) NULL,
	[ISP] [varchar](100) NULL,
	[ORGANIZATION] [varchar](100) NULL,
	[RESPONSE_ID] [varchar](100) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Trigger [dbo].[AUDIT_CR_LOGIN]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_CR_LOGIN]'))
EXEC dbo.sp_executesql @statement = N'
Create TRIGGER [dbo].[AUDIT_CR_LOGIN] 
ON [dbo].[UserLoginHistory]
AFTER INSERT 
AS
BEGIN
	DECLARE @ROLEID VARCHAR(100),
			@USERID VARCHAR(100),
			@USERNAME VARCHAR(100),
			@LOGINDATE DATETIME,
			@MAILSUBJECT VARCHAR(1000),
			@MAILBODY VARCHAR(4000),
			@MAX_MSG_ID NUMERIC(18,0),
			@CompanyEmailID varchar(300)

				
	SELECT @LOGINDATE= LOGINDATE, @USERID = USERID FROM INSERTED
	SELECT @USERNAME =  UserName FROM UserMaster WHERE UserId = @USERID
	
	IF ( DATEPART(HOUR,@LOGINDATE) BETWEEN 20 AND 24)
	 or ( DATEPART(HOUR,@LOGINDATE) BETWEEN 00 AND 07)
	BEGIN		  
		SELECT @ROLEID = USERTYPEID 
		FROM ROLEMASTER RM INNER JOIN USERMASTER UM ON RM.RoleId = UM.RoleId
		WHERE UM.USERID = @USERID
	
		IF (@ROLEID=''1'' OR @ROLEID=''2'')
		BEGIN
			--INSERT INTO ESOPMANAGER..CR_ADMIN_LOGIN_AUDIT select userid,@ROLEID,logindate from inserted
			SET @MAILSUBJECT = ''Login by User - '' + @USERNAME + '' With ID - '' + @USERID 
			SET @MAILBODY = ''This is to inform that user - <b>'' + @USERNAME + ''</b> has logged in to the database - <b>'' + DB_NAME() + ''</b> using login - <b>'' + @USERID + ''</b> on <b>'' + CONVERT(VARCHAR, @LOGINDATE) + ''</b> ''
			SELECT @MAX_MSG_ID= MAX(MESSAGEID) FROM MailerDB..MailSpool
			select @CompanyEmailID = CompanyEmailID from CompanyMaster
			INSERT INTO MailerDB..MailSpool
				(MessageID ,[From] ,[To] ,[Subject] ,[Description], Cc ,CreatedOn)
			VALUES
			(@MAX_MSG_ID+1,@CompanyEmailID,''walter@esopdirect.com,nehat@esopdirect.com'',@MAILSUBJECT,@MAILBODY,null,GETDATE())

		END
	END
END
' 
GO
ALTER TABLE [dbo].[UserLoginHistory] ENABLE TRIGGER [AUDIT_CR_LOGIN]
GO
