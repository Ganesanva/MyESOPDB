/****** Object:  Table [dbo].[HRMSSettings]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HRMSSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[HRMSSettings](
	[HRMSSettingsID] [int] IDENTITY(1,1) NOT NULL,
	[UniqueIdentifier] [varchar](10) NULL,
	[IsEmpRegEnabled] [bit] NULL,
	[AlertBeforeNoOfDaysForPerfVesting] [varchar](10) NULL,
	[UserIDListForPerfVesting] [varchar](500) NULL,
	[SFTPPathForPerfVesting] [varchar](500) NULL,
	[FileNameForPerfVesting] [varchar](50) NULL,
	[IsProcAutomatedForPerfVesting] [bit] NULL,
	[TempNameForPerfVesting] [varchar](50) NULL,
	[UserIDListForSchemeDet] [varchar](500) NULL,
	[SFTPPathForSchemeDet] [varchar](500) NULL,
	[FileNameForSchemeDet] [varchar](50) NULL,
	[IsProcAutomatedForSchemeDet] [bit] NULL,
	[TempNameForSchemeDet] [varchar](50) NULL,
	[UserIDListForGrantDet] [varchar](500) NULL,
	[SFTPPathForGrantDet] [varchar](500) NULL,
	[FileNameForGrantDet] [varchar](50) NULL,
	[IsProcAutomatedForGrantDet] [bit] NULL,
	[TempNameForGrantDet] [varchar](50) NULL,
	[UserIDListForCtryTxTemp] [varchar](500) NULL,
	[SFTPPathForCtryTxTemp] [varchar](500) NULL,
	[FileNameForCtryTxTemp] [varchar](50) NULL,
	[IsProcAutomatedForCtryTxTemp] [bit] NULL,
	[TempNameForCtryTxTemp] [varchar](50) NULL,
	[UserIDListForEmpVestRpt] [varchar](500) NULL,
	[SFTPPathForEmpVestRpt] [varchar](500) NULL,
	[FileNameForEmpVestRpt] [varchar](50) NULL,
	[IsProcAutomatedForEmpVestRpt] [bit] NULL,
	[TempNameForEmpVestRpt] [varchar](50) NULL,
	[NoOfDaysForEmpVestRpt] [varchar](10) NULL,
	[UserIDListTenFMVTxInpRptA] [varchar](500) NULL,
	[SFTPPathForTenFMVTxInpRptA] [varchar](500) NULL,
	[FileNameForTenFMVTxInpRptA] [varchar](50) NULL,
	[IsProcAutomatedForTenFMVTxInpRptA] [bit] NULL,
	[TempNameForTenFMVTxInpRptA] [varchar](50) NULL,
	[NoOfDaysForTenFMVTxInpRptA] [varchar](10) NULL,
	[UserIDListTenFMVTxInpRptB] [varchar](500) NULL,
	[SFTPPathForTenFMVTxInpRptB] [varchar](500) NULL,
	[FileNameForTenFMVTxInpRptB] [varchar](50) NULL,
	[IsProcAutomatedForTenFMVTxInpRptB] [bit] NULL,
	[TempNameForTenFMVTxInpRptB] [varchar](50) NULL,
	[NoOfDaysForTenFMVTxInpRptB] [varchar](10) NULL,
	[UserIDListForEmpTaxTemp] [varchar](500) NULL,
	[SFTPPathForEmpTaxTemp] [varchar](500) NULL,
	[FileNameForEmpTaxTemp] [varchar](50) NULL,
	[IsProcAutomatedForEmpTaxTemp] [bit] NULL,
	[TempNameForEmpTaxTemp] [varchar](50) NULL,
	[NoOfDaysForEmpTxTemp] [varchar](10) NULL,
	[UserIDListForActFMVTxPaidRpt] [varchar](500) NULL,
	[SFTPPathForActFMVTxPaidRpt] [varchar](500) NULL,
	[FileNameForActFMVTxPaidRpt] [varchar](50) NULL,
	[IsProcAutomatedForActFMVTxPaidRpt] [bit] NULL,
	[TempNameForActFMVTxPaidRpt] [varchar](50) NULL,
	[NoOfDaysForActFMVTxPaidRpt] [varchar](10) NULL,
	[UserIDListForTxDiffTemp] [varchar](500) NULL,
	[SFTPPathForTxDiffTemp] [varchar](500) NULL,
	[FileNameForTxDiffTemp] [varchar](50) NULL,
	[IsProcAutomatedForTxDiffTemp] [bit] NULL,
	[TempNameForTxDiffTemp] [varchar](50) NULL,
	[NoOfDaysForTxDiffTemp] [varchar](10) NULL,
	[UserIDListForEmpBroDtls] [varchar](500) NULL,
	[SFTPPathForEmpBroDtls] [varchar](500) NULL,
	[FileNameForEmpBroDtls] [varchar](50) NULL,
	[IsProcAutomatedForEmpBroDtls] [bit] NULL,
	[TempNameForEmpBroDtls] [varchar](50) NULL,
	[UserIDListForSleOdrMSSB] [varchar](500) NULL,
	[SFTPPathForSleOdrMSSB] [varchar](500) NULL,
	[FileNameForSleOdrMSSB] [varchar](50) NULL,
	[IsProcAutomatedForSleOdrMSSB] [bit] NULL,
	[TempNameForSleOdrMSSB] [varchar](50) NULL,
	[UserIDListForSleCfirmDtls] [varchar](500) NULL,
	[SFTPPathForSleCfirmDtls] [varchar](500) NULL,
	[FileNameForSleCfirmDtls] [varchar](50) NULL,
	[IsProcAutomatedForSleCfirmDtls] [bit] NULL,
	[TempNameForSleCfirmDtls] [varchar](50) NULL,
	[UserIDListForADRAllotMandate] [varchar](500) NULL,
	[SFTPPathForADRAllotMandate] [varchar](500) NULL,
	[FileNameForADRAllotMandate] [varchar](50) NULL,
	[IsProcAutomatedADRAllotMandate] [bit] NULL,
	[TempNameForADRAllotMandate] [varchar](50) NULL,
	[UserIDListForNonExCaseDtls] [varchar](500) NULL,
	[SFTPPathForNonExCaseDtls] [varchar](500) NULL,
	[FileNameForNonExCaseDtls] [varchar](50) NULL,
	[IsProcAutomatedNonExCaseDtls] [bit] NULL,
	[TempNameForNonExCaseDtls] [varchar](50) NULL,
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
	[IsMailSentToClient] [bit] NULL,
	[ClientMailId] [varchar](500) NULL,
	[MAIL_SUBJECT_FOR_CLIENT] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[HRMSSettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsEmp__18D771F0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsEmpRegEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__19CB9629]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForPerfVesting]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1ABFBA62]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForSchemeDet]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1BB3DE9B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForGrantDet]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1CA802D4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForCtryTxTemp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1D9C270D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForEmpVestRpt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1E904B46]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForTenFMVTxInpRptA]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__1F846F7F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForTenFMVTxInpRptB]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__207893B8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForEmpTaxTemp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__216CB7F1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForActFMVTxPaidRpt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__2260DC2A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForTxDiffTemp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__23550063]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForEmpBroDtls]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__2449249C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForSleOdrMSSB]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__253D48D5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedForSleCfirmDtls]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__26316D0E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedADRAllotMandate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsPro__27259147]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsProcAutomatedNonExCaseDtls]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsInc__2819B580]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsIncrementalData]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsSec__290DD9B9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsSecureFile]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__TakeD__2A01FDF2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [TakeDatabaseBackUp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__ShowD__2AF6222B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [ShowDetailsLog]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__HRMSSetti__IsMai__17C5B42B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[HRMSSettings] ADD  DEFAULT ((0)) FOR [IsMailSentToClient]
END
GO
