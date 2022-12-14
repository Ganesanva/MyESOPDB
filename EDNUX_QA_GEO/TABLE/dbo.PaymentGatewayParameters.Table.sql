/****** Object:  Table [dbo].[PaymentGatewayParameters]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentGatewayParameters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentGatewayParameters](
	[Merchant_Code] [varchar](50) NULL,
	[Merchant_Code_PerqTax] [varchar](50) NULL,
	[GatewayURL] [varchar](500) NULL,
	[Payment_Gateway_Name] [varchar](50) NULL,
	[ModeOfOperation] [varchar](10) NULL,
	[Currency] [varchar](10) NULL,
	[ReturnURL] [varchar](100) NULL,
	[Verify_Prgm] [varchar](50) NULL,
	[Response_Type] [varchar](50) NULL,
	[Merchantcode_Param] [varchar](50) NULL,
	[Merchant_reference_No_Param] [varchar](50) NULL,
	[Amount_Param] [varchar](50) NULL,
	[Mode_Opernt_Param] [varchar](50) NULL,
	[Currency_Param] [varchar](50) NULL,
	[ReturnURL_Param] [varchar](50) NULL,
	[Item_Code_Param] [varchar](50) NULL,
	[Item_Code_len] [int] NULL,
	[Merchant_reference_No_len] [int] NULL,
	[Verify_Prgm_Param] [varchar](50) NULL,
	[ResponseType_Param] [varchar](50) NULL,
	[Transaction_Status_Param] [varchar](50) NULL,
	[Bank_Ref_No_Param] [varchar](50) NULL,
	[BalanacePayPeriod] [int] NULL,
	[Pay_Immediately] [varchar](10) NULL,
	[Transaction_FeeType] [varchar](50) NULL,
	[SendMail_ExerciseReversal_Reminder] [int] NULL,
	[Genrate_ExerciseForm] [char](1) NULL,
	[Transacion_Fees] [numeric](18, 2) NULL,
	[Genrate_ExerciseId] [char](1) NULL,
	[LastUpdatedBy] [varchar](25) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Tax_AmountParam] [varchar](50) NULL,
	[IsDebugSet] [tinyint] NULL,
	[ReqVerificationURL] [varchar](255) NULL,
	[ReturnURLAfterVerification] [varchar](255) NULL,
	[IsDualVerificationRequired] [tinyint] NOT NULL,
	[DVUserName] [varchar](100) NULL,
	[DVPassword] [varchar](100) NULL,
	[Based_On_Event] [nvarchar](50) NULL,
	[IsProd2Dynamic] [bit] NOT NULL,
	[IsSingleURLActivated] [bit] NULL,
	[EncryptionKey] [varchar](100) NULL,
	[EncryptionIV] [varchar](100) NULL,
	[DeviceId] [varchar](20) NULL,
	[PayModeType] [varchar](20) NULL,
	[EncryptionAlogorithmType] [varchar](20) NULL,
	[BLOCK_HRS] [int] NULL,
	[IS_TRANS_REVERSAL_MAIL_ENABLED] [char](1) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__IsDua__02133CD2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [IsDualVerificationRequired]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__IsPro__168F36CB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [IsProd2Dynamic]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__IsSin__25083EAB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [IsSingleURLActivated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__Encry__25FC62E4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT (NULL) FOR [EncryptionKey]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__Encry__26F0871D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT (NULL) FOR [EncryptionIV]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__BLOCK__0BD6CC47]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [BLOCK_HRS]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentGa__IS_TR__0CCAF080]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentGatewayParameters] ADD  DEFAULT ((0)) FOR [IS_TRANS_REVERSAL_MAIL_ENABLED]
END
GO
