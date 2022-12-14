/****** Object:  Table [dbo].[UserMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserMaster](
	[UserId] [varchar](20) NOT NULL,
	[UserName] [varchar](75) NULL,
	[EmployeeId] [varchar](20) NOT NULL,
	[RoleId] [varchar](30) NOT NULL,
	[Grade] [varchar](100) NULL,
	[Department] [varchar](200) NULL,
	[Address] [varchar](500) NULL,
	[PhoneNo] [varchar](20) NULL,
	[EmailId] [varchar](100) NULL,
	[DateofJoining] [datetime] NULL,
	[ShowPopUps] [char](1) NULL,
	[ForcePwdChange] [char](1) NOT NULL,
	[InvalidLoginAttempt] [numeric](18, 0) NULL,
	[LockedDate] [datetime] NULL,
	[IsUserLocked] [char](1) NOT NULL,
	[IsUserActive] [char](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ISFUNDINGCCR] [bit] NOT NULL,
 CONSTRAINT [PK_UserMaster] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__UserMaste__ISFUN__0E391C95]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserMaster] ADD  DEFAULT ((0)) FOR [ISFUNDINGCCR]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserMaster_RoleMaster1]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserMaster]'))
ALTER TABLE [dbo].[UserMaster]  WITH CHECK ADD  CONSTRAINT [FK_UserMaster_RoleMaster1] FOREIGN KEY([RoleId])
REFERENCES [dbo].[RoleMaster] ([RoleId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserMaster_RoleMaster1]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserMaster]'))
ALTER TABLE [dbo].[UserMaster] CHECK CONSTRAINT [FK_UserMaster_RoleMaster1]
GO
/****** Object:  Trigger [dbo].[AfterInsertUserMaster]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[AfterInsertUserMaster]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[AfterInsertUserMaster] ON [dbo].[UserMaster]
AFTER INSERT,UPDATE
AS
BEGIN
---Variable For Inserted Record
DECLARE @IUserLoginID NVARCHAR(100)
DECLARE @IUserEmailID NVARCHAR(100)



---Variable For Update Record
DECLARE @UUserEmailID NVARCHAR(100)



----Retrive Current DBName
DECLARE @CompanyID NVARCHAR(100)
SET @CompanyID=(SELECT DB_NAME() );



--------Retrive New Record
SELECT @IUserLoginID=Ins.UserId,@IUserEmailID=Ins.EmailId FROM INSERTED Ins



---------Retrive Update Record
SELECT @IUserLoginID=del.UserId,@UUserEmailID=Del.EmailId FROM DELETED Del



IF (@IUserEmailID IS NOT NULL AND @UUserEmailID IS NULL)
BEGIN
------Insert New User
INSERT INTO ESOPManager..AllClientUsersMaster
([LoginID]
,[CompanyID]
,[EmailID]
,[CreatedBy]
,[CreatedOn]
,[IsActive]) VALUES
( @IUserLoginID
, @CompanyID
, @IUserEmailID ,''ADMIN'',Convert(nvarchar(100) ,Getdate()) ,1)
END
ELSE if(@UUserEmailID != @IUserEmailID)
BEGIN
-------Update Email Id
UPDATE ESOPManager..AllClientUsersMaster
SET EmailID = @IUserEmailID
WHERE LoginID = @IUserLoginID
AND CompanyID =@CompanyID


END
END' 
GO
ALTER TABLE [dbo].[UserMaster] ENABLE TRIGGER [AfterInsertUserMaster]
GO
/****** Object:  Trigger [dbo].[UPDATE_IN_USER_MASTER]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[UPDATE_IN_USER_MASTER]'))
EXEC dbo.sp_executesql @statement = N'

Create TRIGGER [dbo].[UPDATE_IN_USER_MASTER] 
ON 
	[dbo].[UserMaster]
AFTER INSERT, UPDATE

AS
BEGIN
	DECLARE 
			@ForcePwdChange CHAR(1),
			@RoleId VARCHAR(100)

	SELECT 
		@ForcePwdChange =ForcePwdChange,
		@RoleId = RoleId
	FROM 
		INSERTED 
	
	IF (@RoleId = ''EMPLOYEE'')
	BEGIN
		IF ((SELECT IsSSOActivated FROM CompanyMaster) = 1)
		BEGIN
			UPDATE UM SET UM.ForcePwdChange = ''N'' FROM UserMaster UM INNER JOIN INSERTED ON INSERTED.UserId = UM.UserId
		END
	END
END
' 
GO
ALTER TABLE [dbo].[UserMaster] ENABLE TRIGGER [UPDATE_IN_USER_MASTER]
GO
