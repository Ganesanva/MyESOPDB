/****** Object:  Table [dbo].[GrantAccMassUpload]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantAccMassUpload]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantAccMassUpload](
	[GAMUID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [varchar](50) NOT NULL,
	[SchemeName] [varchar](100) NULL,
	[LetterCode] [varchar](100) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[GrantType] [varchar](100) NULL,
	[NoOfOptions] [numeric](18, 0) NOT NULL,
	[Currency] [varchar](50) NULL,
	[ExercisePrice] [numeric](18, 2) NOT NULL,
	[FirstVestDate] [datetime] NOT NULL,
	[NoOfVests] [numeric](18, 0) NOT NULL,
	[VestingFrequency] [numeric](18, 0) NOT NULL,
	[VestingPercentage] [varchar](1000) NULL,
	[Adjustment] [char](1) NOT NULL,
	[CompanyName] [varchar](100) NULL,
	[CompanyAddress] [varchar](500) NULL,
	[LotNumber] [varchar](10) NOT NULL,
	[LastAcceptanceDate] [datetime] NOT NULL,
	[LetterAcceptanceStatus] [char](1) NULL,
	[LetterAcceptanceDate] [datetime] NULL,
	[GrantLetterName] [varchar](100) NULL,
	[GrantLetterPath] [varchar](500) NULL,
	[MailSentStatus] [bit] NULL,
	[MailSentDate] [datetime] NULL,
	[IsGlGenerated] [bit] NOT NULL,
	[GlGeneratedDate] [datetime] NULL,
	[NoActionTill] [int] NOT NULL,
	[Field1] [varchar](max) NULL,
	[Field2] [varchar](max) NULL,
	[Field3] [varchar](max) NULL,
	[Field4] [varchar](max) NULL,
	[Field5] [varchar](max) NULL,
	[Field6] [varchar](max) NULL,
	[Field7] [varchar](max) NULL,
	[Field8] [varchar](max) NULL,
	[Field9] [varchar](max) NULL,
	[Field10] [varchar](max) NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[VestingType] [varchar](2) NULL,
	[ISATTACHMENT] [int] NULL,
	[TEMPLATE_NAME] [nvarchar](500) NULL,
 CONSTRAINT [PK_GrantAccMassUpload] PRIMARY KEY CLUSTERED 
(
	[GAMUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GrantAccM__IsGlG__18227982]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GrantAccMassUpload] ADD  DEFAULT ((0)) FOR [IsGlGenerated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GrantAccM__GlGen__19169DBB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GrantAccMassUpload] ADD  DEFAULT (NULL) FOR [GlGeneratedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__GrantAccM__NoAct__1A0AC1F4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[GrantAccMassUpload] ADD  DEFAULT ((0)) FOR [NoActionTill]
END
GO
