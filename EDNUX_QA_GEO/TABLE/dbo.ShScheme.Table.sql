/****** Object:  Table [dbo].[ShScheme]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShScheme]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShScheme](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[SchemeTitle] [varchar](50) NOT NULL,
	[AdjustResidueOptionsIn] [varchar](1) NOT NULL,
	[VestingOverPeriodOffset] [numeric](18, 0) NOT NULL,
	[VestingStartOffset] [numeric](18, 0) NOT NULL,
	[VestingFrequency] [numeric](18, 0) NOT NULL,
	[LockInPeriod] [numeric](18, 0) NULL,
	[LockInPeriodStartsFrom] [varchar](1) NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NOT NULL,
	[OptionRatioDivisor] [numeric](18, 0) NOT NULL,
	[ExercisePeriodOffset] [numeric](18, 0) NOT NULL,
	[ExercisePeriodStartsAfter] [varchar](1) NOT NULL,
	[PeriodUnit] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
	[TrustType] [char](10) NOT NULL,
	[IsPaymentModeRequired] [tinyint] NOT NULL,
	[PaymentModeEffectiveDate] [date] NOT NULL,
	[UnVestedCancelledOptions] [varchar](1) NOT NULL,
	[VestedCancelledOptions] [varchar](1) NOT NULL,
	[LapsedOptions] [varchar](1) NOT NULL,
	[IsPUPEnabled] [bit] NOT NULL,
	[DisplayExPrice] [bit] NOT NULL,
	[DisplayExpDate] [bit] NOT NULL,
	[DisplayPerqVal] [bit] NOT NULL,
	[DisplayPerqTax] [bit] NOT NULL,
	[PUPExedPayoutProcess] [bit] NOT NULL,
	[PUPFORMULAID] [int] NOT NULL,
	[IS_ADS_SCHEME] [bit] NOT NULL,
	[IS_ADS_EX_OPTS_ALLOWED] [bit] NOT NULL,
	[MIT_ID] [int] NULL,
	[IS_AUTO_EXERCISE_ALLOWED] [char](1) NULL,
	[CALCULATE_TAX] [nvarchar](200) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS] [int] NULL,
	[CALCULATE_TAX_PREVESTING] [nvarchar](100) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS_PREVESTING] [int] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__TrustT__1699586C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ('N') FOR [TrustType]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__IsPaym__5D2BD0E6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((1)) FOR [IsPaymentModeRequired]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Paymen__5E1FF51F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT (getdate()) FOR [PaymentModeEffectiveDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__UnVest__420DC656]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ('Y') FOR [UnVestedCancelledOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Vested__4301EA8F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ('Y') FOR [VestedCancelledOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Lapsed__43F60EC8]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ('Y') FOR [LapsedOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__IsPUPE__1ABEEF0B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [IsPUPEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Displa__1BB31344]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [DisplayExPrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Displa__1CA7377D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [DisplayExpDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Displa__1D9B5BB6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [DisplayPerqVal]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__Displa__1E8F7FEF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [DisplayPerqTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__PUPExe__2962141D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [PUPExedPayoutProcess]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__PUPFOR__2A563856]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [PUPFORMULAID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__IS_ADS__61A66D40]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [IS_ADS_SCHEME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShScheme__IS_ADS__629A9179]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShScheme] ADD  DEFAULT ((0)) FOR [IS_ADS_EX_OPTS_ALLOWED]
END
GO
