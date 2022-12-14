/****** Object:  Table [dbo].[AuditData]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuditData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuditData](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[ExerciseId] [int] NULL,
	[ExerciseNo] [int] NULL,
	[FMV] [float] NULL,
	[PaymentDateTime] [datetime] NULL,
	[ExerciseAmount] [float] NULL,
	[TaxRate] [float] NULL,
	[PerqVal] [float] NULL,
	[PerqTax] [float] NULL,
	[MarketPrice] [float] NULL,
	[PaymentMode] [varchar](1) NULL,
	[TransactionChanges] [float] NULL,
	[BrokerageCharges] [float] NULL,
	[LoginDateTime] [datetime] NULL,
	[LogoutDateTime] [datetime] NULL,
	[CashlessChgsAmt] [float] NULL,
	[STTChgs] [float] NULL,
	[STChgs] [float] NULL,
	[LoginHistoryId] [int] NULL,
	[TransChargesPaid] [float] NULL,
	[ServiceTaxTransactionChargespaid] [float] NULL,
	[BrokerChargesPaid] [float] NULL,
	[SerTaxOnBrokerageChargesPaid] [float] NULL,
	[STTPaid] [float] NULL,
	[SEBIFeePaid] [float] NULL,
	[StampDutyPaid] [float] NULL,
	[CAFillings] [float] NULL,
	[ServiceTaxOnCAFillingFees] [float] NULL,
	[BankCharges] [float] NULL,
	[ServiceTaxOnBankCharges] [float] NULL,
	[NumberOfShares] [float] NULL,
	[CashPayoutValue] [float] NULL
) ON [PRIMARY]
END
GO
