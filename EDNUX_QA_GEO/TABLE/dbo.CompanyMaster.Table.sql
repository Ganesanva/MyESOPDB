/****** Object:  Table [dbo].[CompanyMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyMaster](
	[CompanyID] [varchar](20) NOT NULL,
	[CompanyName] [varchar](100) NOT NULL,
	[CompanyAddress] [nvarchar](max) NULL,
	[CompanyURL] [varchar](50) NULL,
	[CompanyEmailID] [varchar](50) NOT NULL,
	[AdminEmailID] [varchar](50) NOT NULL,
	[AdminUserID] [varchar](20) NOT NULL,
	[AdminPassword] [varchar](20) NOT NULL,
	[StockExchangeType] [char](1) NULL,
	[StockExchangeCode] [varchar](20) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[SMPTServerIp] [nvarchar](50) NULL,
	[SMPTServerPort] [char](15) NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[MaxLoginAttempts] [numeric](18, 0) NOT NULL,
	[ISFUNDINGALLOWED] [bit] NOT NULL,
	[IsSSOActivated] [bit] NOT NULL,
	[SITEURL] [varchar](500) NULL,
	[DMSetting_Note] [varchar](max) NULL,
	[IsNominationEnabled] [tinyint] NOT NULL,
	[FMVCalculation_Note] [varchar](max) NULL,
	[IsPUPEnabled] [bit] NOT NULL,
	[DisplayAs] [varchar](50) NOT NULL,
	[BaseCurrencyID] [int] NOT NULL,
	[VwMenuForGrpCompany] [varchar](10) NULL,
	[VersionNumber] [varchar](10) NULL,
	[BROKER_SETTING_NOTE] [varchar](max) NULL,
	[IS_ADS_ENABLED] [bit] NOT NULL,
	[IsListingEnabled] [bit] NULL,
	[IsHRMSEnabled] [bit] NOT NULL,
	[AlertExEmployees] [bit] NOT NULL,
	[Is_PFUTP_Setting] [bit] NOT NULL,
	[IS_EGRANTS_ENABLED] [bit] NOT NULL,
	[IS_SCHWISE_DOC_UPLOAD] [bit] NOT NULL,
	[IS_CONSENT_SET] [bit] NOT NULL,
	[CONSENT_MESSAGE] [varchar](max) NULL,
	[AuthenticationModeID] [tinyint] NOT NULL,
	[IsSSOAPIActivated] [tinyint] NOT NULL,
	[SSOAPIParams] [varchar](200) NULL,
	[SSOAPIURL] [varchar](200) NULL,
	[LogoutURL] [varchar](500) NULL,
	[IS_EULA_SET] [bit] NULL,
	[IsActivatedOTPviaEmailFor] [varchar](15) NULL,
	[OTPAuthApplicableUserType] [int] NULL,
	[IS_VALIDATE_IP_CONFIG_ENABLED] [bit] NULL,
	[IS_FUTURE_SEPRATION_ALLOW] [bit] NULL,
	[UserColorTheme] [varchar](50) NULL,
 CONSTRAINT [PK_CompanyMaster] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__ISFUN__7E02B4CC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [ISFUNDINGALLOWED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsSSO__6BAEFA67]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsSSOActivated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__SITEU__6CA31EA0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT (NULL) FOR [SITEURL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsNom__2F2FFC0C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsNominationEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsPUP__10416098]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsPUPEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__Displ__1229A90A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ('PUP Scheme') FOR [DisplayAs]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__BaseC__03A67F89]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((1)) FOR [BaseCurrencyID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IS_AD__5DD5DC5C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IS_ADS_ENABLED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsLis__3B4BBA2E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsListingEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsHRM__03C67B1A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsHRMSEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__Alert__04BA9F53]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [AlertExEmployees]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__Is_PF__26DAAD2D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [Is_PFUTP_Setting]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IS_EG__2F6FF32E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IS_EGRANTS_ENABLED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IS_SC__54A177DD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IS_SCHWISE_DOC_UPLOAD]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IS_CO__6D6D25A7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IS_CONSENT_SET]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__Authe__2A7633E7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [AuthenticationModeID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsSSO__0E990F48]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsSSOAPIActivated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IsAct__24CD0B93]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT ((0)) FOR [IsActivatedOTPviaEmailFor]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyMa__IS_FU__037795EF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyMaster] ADD  DEFAULT (NULL) FOR [IS_FUTURE_SEPRATION_ALLOW]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_CM_BaseCurrency]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyMaster]'))
ALTER TABLE [dbo].[CompanyMaster]  WITH CHECK ADD  CONSTRAINT [fk_CM_BaseCurrency] FOREIGN KEY([BaseCurrencyID])
REFERENCES [dbo].[CurrencyMaster] ([CurrencyID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_CM_BaseCurrency]') AND parent_object_id = OBJECT_ID(N'[dbo].[CompanyMaster]'))
ALTER TABLE [dbo].[CompanyMaster] CHECK CONSTRAINT [fk_CM_BaseCurrency]
GO
