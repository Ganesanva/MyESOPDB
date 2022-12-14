/****** Object:  Table [dbo].[CompanyInfoHistory]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyInfoHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyInfoHistory](
	[CompanyID] [varchar](20) NOT NULL,
	[CompanyName] [varchar](100) NOT NULL,
	[CompanyAddress] [nvarchar](max) NULL,
	[CompanyURL] [varchar](50) NULL,
	[CompanyEmail] [varchar](50) NOT NULL,
	[AdminEmail] [varchar](50) NOT NULL,
	[StockExchange] [char](1) NULL,
	[StockExchangeCode] [varchar](20) NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[UpdatedTime] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[MaxLoginAttempts] [numeric](18, 0) NOT NULL,
	[ISFUNDINGALLOWED] [bit] NOT NULL,
	[IsNominationEnabled] [tinyint] NOT NULL,
	[IsPUPEnabled] [bit] NOT NULL,
	[DisplayAs] [varchar](50) NOT NULL,
	[VwMenuForGrpCompany] [varchar](10) NULL,
	[IS_ADS_ENABLED] [bit] NOT NULL,
	[IsListingEnabled] [bit] NULL,
	[Is_PFUTP_Setting] [bit] NULL,
	[IS_EGRANTS_ENABLED] [bit] NOT NULL,
	[IS_SCHWISE_DOC_UPLOAD] [bit] NOT NULL,
	[IS_CONSENT_SET] [bit] NOT NULL,
	[CONSENT_MESSAGE] [varchar](max) NULL,
	[AuthenticationModeID] [tinyint] NOT NULL,
	[IS_EULA_SET] [bit] NULL,
	[OTPAuthApplicableUserType] [int] NULL,
	[IS_VALIDATE_IP_CONFIG_ENABLED] [bit] NULL,
	[IS_FUTURE_SEPRATION_ALLOW] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__ISFUN__7EF6D905]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [ISFUNDINGALLOWED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IsNom__2E3BD7D3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IsNominationEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IsPUP__113584D1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IsPUPEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__Displ__131DCD43]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ('PUP Scheme') FOR [DisplayAs]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IS_AD__5ECA0095]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IS_ADS_ENABLED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IsLis__3C3FDE67]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IsListingEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__Is_PF__25E688F4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [Is_PFUTP_Setting]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IS_EG__30641767]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IS_EGRANTS_ENABLED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IS_SC__55959C16]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IS_SCHWISE_DOC_UPLOAD]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IS_CO__6E6149E0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [IS_CONSENT_SET]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__Authe__2B6A5820]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT ((0)) FOR [AuthenticationModeID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyIn__IS_FU__046BBA28]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyInfoHistory] ADD  DEFAULT (NULL) FOR [IS_FUTURE_SEPRATION_ALLOW]
END
GO
