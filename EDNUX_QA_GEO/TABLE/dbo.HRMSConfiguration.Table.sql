/****** Object:  Table [dbo].[HRMSConfiguration]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSConfiguration](
	[HRMSConfigurationID] [int] IDENTITY(1,1) NOT NULL,
	[SFTPPath] [varchar](500) NULL,
	[SFTPFileName] [varchar](500) NULL,
	[WriteToFileLogPath] [varchar](500) NULL,
	[ProcessedFilePath] [varchar](500) NULL,
	[IsIncrementalData] [bit] NULL,
	[IsSecureFile] [bit] NULL,
	[TakeDatabaseBackUp] [bit] NULL,
	[ShowDetailsLog] [bit] NULL,
	[Password] [varchar](100) NULL,
	[PublicKey] [varchar](200) NULL,
	[PrivateKey] [varchar](200) NULL,
	[MailSubject] [varchar](500) NULL,
	[MailFrom] [varchar](500) NULL,
	[MailFromDisplayName] [varchar](500) NULL,
	[MailTo] [varchar](500) NULL,
	[MailCC] [varchar](500) NULL,
	[MailBCC] [varchar](500) NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[HRMSConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSConfi__IsInc__1A3FCC1E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSConfiguration] ADD  DEFAULT ((0)) FOR [IsIncrementalData]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSConfi__IsSec__1B33F057]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSConfiguration] ADD  DEFAULT ((0)) FOR [IsSecureFile]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSConfi__TakeD__1C281490]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSConfiguration] ADD  DEFAULT ((0)) FOR [TakeDatabaseBackUp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSConfi__ShowD__1D1C38C9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSConfiguration] ADD  DEFAULT ((0)) FOR [ShowDetailsLog]
END
GO
