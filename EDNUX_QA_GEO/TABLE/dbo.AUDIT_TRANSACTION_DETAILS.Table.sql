/****** Object:  Table [dbo].[AUDIT_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_TRANSACTION_DETAILS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_TRANSACTION_DETAILS](
	[MerchantreferenceNo] [numeric](18, 0) NOT NULL,
	[OpreationStatus] [char](1) NULL,
	[BankReferenceNo] [varchar](100) NULL,
	[Merchant_Code] [varchar](50) NULL,
	[Sh_ExerciseNo] [numeric](18, 0) NULL,
	[TransactionType] [varchar](10) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Item_Code] [varchar](50) NULL,
	[Payment_status] [varchar](25) NULL,
	[Transaction_Status] [varchar](25) NULL,
	[Transaction_Date] [datetime] NULL,
	[Tax_Amount] [numeric](18, 2) NULL,
	[Failure Reson] [varchar](50) NULL,
	[ErrorCode] [varchar](50) NULL,
	[transactionfees] [numeric](18, 2) NULL,
	[FailureReson] [varchar](500) NULL,
	[ExerciseNo] [int] NULL,
	[BankAccountNo] [int] NULL,
	[DPRecord] [varchar](50) NULL,
	[DepositoryName] [varchar](50) NULL,
	[DematAcType] [varchar](50) NULL,
	[DPName] [varchar](50) NULL,
	[DPId] [varchar](50) NULL,
	[ClientId] [varchar](50) NULL,
	[PanNumber] [varchar](50) NULL,
	[Nationality] [varchar](50) NULL,
	[ResidentialStatus] [char](1) NULL,
	[Location] [varchar](50) NULL,
	[MobileNumber] [varchar](50) NULL,
	[CountryCode] [varchar](10) NULL,
	[STATUS] [char](1) NULL,
	[ActionType] [varchar](5) NULL,
	[bankid] [varchar](10) NULL,
	[TPSLTransID] [varchar](50) NULL,
	[UniqueTransactionNo] [varchar](30) NULL,
	[LastUpdatedBy] [varchar](25) NULL,
	[LastUpdated] [datetime] NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[IS_MAIL_SENT] [tinyint] NULL,
	[COST_CENTER] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL
) ON [PRIMARY]
END
GO
