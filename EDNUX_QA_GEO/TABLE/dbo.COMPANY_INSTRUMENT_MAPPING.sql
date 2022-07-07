/****** Object:  Table [dbo].[COMPANY_INSTRUMENT_MAPPING]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPANY_INSTRUMENT_MAPPING]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING](
	[CIM_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MIT_ID] [int] NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[MSE_ID] [nvarchar](100) NULL,
	[SEM_VAL_RPT_ID] [int] NULL,
	[IS_ENABLED] [tinyint] NULL,
	[INS_DISPLY_NAME] [nvarchar](500) NULL,
	[CAL_PERQUSITE_VAL] [tinyint] NOT NULL,
	[EXCEPT_FOR_PERQ_VAL] [tinyint] NOT NULL,
	[CAL_PROPORTIONATE_VAL] [tinyint] NOT NULL,
	[EXCEPT_FOR_PROPORT_VAL] [tinyint] NOT NULL,
	[EXCEPT_FOR_FMV_VAL] [tinyint] NOT NULL,
	[EXCEPT_FOR_FMV] [nvarchar](10) NULL,
	[EXCEPT_FOR_PERQUISITE] [nvarchar](10) NULL,
	[EXCEPT_FOR_PROPORTIONATE] [nvarchar](10) NULL,
	[COUNTRY_CATEGORY_PROPORT] [nvarchar](50) NULL,
	[PAYMENTMODE_BASED_ON] [varchar](20) NULL,
	[EXCEPT_FOR_TAXRATE_VAL] [tinyint] NULL,
	[EXCEPT_FOR_TAXRATE] [nvarchar](10) NULL,
	[IS_TAXRATE_ACTIVE] [tinyint] NULL,
	[IS_TAXRATEEXCEPTION_ACTIVE] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[IS_PAYMENTWINDOW_ENABLED] [char](1) NULL,
	[NUMBEROFDAYS] [int] NULL,
	[PAYMENT_CLOSURE_MSG] [varchar](1000) NULL,
	[EXCEPT_FOR_TAXRATE_EMPLOYEE] [nchar](3) NULL,
	[TAXCALCULATION_BASEDON] [varchar](50) NULL,
	[ISActivedforEntity] [bigint] NULL,
	[EntityBaseOn] [bigint] NULL,
	[IsApplicableForCashless] [bit] NULL,
	[IsActivatedAccount] [varchar](1) NULL,
	[ISPaymentReminder] [varchar](1) NULL,
	[IsResident] [int] NULL,
	[IsNonResident] [int] NULL,
	[IsForeignNational] [int] NULL,
	[IsTaxApplicable] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[CIM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__IS_EN__6C0EED1A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [IS_ENABLED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__CAL_P__6D031153]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [CAL_PERQUSITE_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__EXCEP__6DF7358C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [EXCEPT_FOR_PERQ_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__CAL_P__6EEB59C5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [CAL_PROPORTIONATE_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__EXCEP__6FDF7DFE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [EXCEPT_FOR_PROPORT_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__EXCEP__70D3A237]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [EXCEPT_FOR_FMV_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__EXCEP__71C7C670]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [EXCEPT_FOR_TAXRATE_VAL]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__IS_TA__72BBEAA9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [IS_TAXRATE_ACTIVE]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__COMPANY_I__IS_TA__73B00EE2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[COMPANY_INSTRUMENT_MAPPING] ADD  DEFAULT ((0)) FOR [IS_TAXRATEEXCEPTION_ACTIVE]
END
GO
