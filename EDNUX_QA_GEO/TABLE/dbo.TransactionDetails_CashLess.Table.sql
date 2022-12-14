/****** Object:  Table [dbo].[TransactionDetails_CashLess]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionDetails_CashLess]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionDetails_CashLess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseNo] [int] NULL,
	[EmployeeName] [varchar](75) NULL,
	[BankName] [varchar](200) NULL,
	[BankBranchName] [varchar](200) NULL,
	[BankBranchAddress] [varchar](200) NULL,
	[BankAccountNo] [varchar](200) NULL,
	[AccountType] [varchar](200) NULL,
	[IFSCCode] [varchar](200) NULL,
	[IBANNo] [varchar](200) NULL,
	[DPRecord] [varchar](50) NULL,
	[DepositoryName] [varchar](50) NULL,
	[DematAcType] [varchar](50) NULL,
	[DPName] [varchar](150) NULL,
	[DPId] [varchar](8) NULL,
	[ClientId] [varchar](16) NULL,
	[PanNumber] [varchar](10) NULL,
	[Nationality] [varchar](50) NULL,
	[ResidentialStatus] [varchar](50) NULL,
	[Location] [varchar](200) NULL,
	[MobileNumber] [varchar](50) NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[lastUpdatedOn] [datetime] NULL,
	[ActionType] [varchar](5) NOT NULL,
	[CountryCode] [varchar](10) NULL,
	[STATUS] [char](1) NOT NULL,
	[CorrespondentBankName] [varchar](50) NULL,
	[CorrespondentBankAddress] [varchar](150) NULL,
	[CorrespondentBankAccNo] [varchar](50) NULL,
	[CorrespondentBankSwiftCodeABA] [varchar](50) NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [nvarchar](100) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [nvarchar](100) NULL,
	[BROKER_ELECT_ACC_NUM] [nvarchar](100) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Transacti__Actio__01D345B0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransactionDetails_CashLess] ADD  DEFAULT ('P') FOR [ActionType]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Transacti__STATU__02C769E9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TransactionDetails_CashLess] ADD  DEFAULT ('P') FOR [STATUS]
END
GO
