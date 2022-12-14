/****** Object:  Table [dbo].[CashlessExceptionalChargesUpdation]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CashlessExceptionalChargesUpdation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CashlessExceptionalChargesUpdation](
	[UpdationChargesID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ExerciseId] [varchar](50) NULL,
	[EmployeeId] [varchar](50) NULL,
	[PerquisiteValue] [decimal](18, 6) NULL,
	[PerqTax] [numeric](18, 6) NULL,
	[PerquisiteTaxPaid] [decimal](18, 6) NULL,
	[CashlessCharges] [decimal](18, 2) NULL,
	[CAFilling] [decimal](18, 2) NULL,
	[ServiceTaxOnCAFilling] [decimal](18, 2) NULL,
	[CessOnCAFillingFees] [decimal](18, 2) NULL,
	[BankCharges] [decimal](18, 2) NULL,
	[ServiceTaxOnBankCharges] [decimal](18, 2) NULL,
	[CessOnBankChargesFillingFees] [decimal](18, 2) NULL,
	[CapitalGainValue] [decimal](18, 2) NULL,
	[CapitalTaxRateApplicable] [decimal](18, 2) NULL,
	[CapitalGainTax] [decimal](18, 2) NULL,
	[SaleDate] [datetime] NULL,
	[IdStatus] [char](1) NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[TrancheNo] [int] NULL,
	[EmployeeName] [varchar](100) NULL,
	[ExerciseNo] [int] NULL,
	[SharesSold] [decimal](18, 2) NULL,
	[TransactionCharges] [decimal](18, 2) NULL,
	[ServiceTaxOnTransactionCharges] [decimal](18, 2) NULL,
	[CessOnTransactionCharges] [decimal](18, 2) NULL,
	[BrokerageCharges] [decimal](18, 2) NULL,
	[ServiceTaxOnBrokerageCharges] [decimal](18, 2) NULL,
	[CessOnBrokerageCharges] [decimal](18, 2) NULL,
	[STT] [decimal](18, 2) NULL,
	[SEBIFee] [decimal](18, 2) NULL,
	[StampDuty] [decimal](18, 2) NULL,
	[CashBalanceAvailableInBrokerAccount] [decimal](18, 2) NULL,
	[SellingPrice] [decimal](18, 2) NULL,
	[Field1Filling] [decimal](18, 2) NULL,
	[Field2Filling] [decimal](18, 2) NULL,
	[Field3Filling] [decimal](18, 2) NULL,
	[Field4Filling] [decimal](18, 2) NULL,
	[Field5Filling] [decimal](18, 2) NULL,
	[BrokerField1] [decimal](18, 2) NULL,
	[BrokerField2] [decimal](18, 2) NULL,
	[BrokerField3] [decimal](18, 2) NULL,
	[BrokerField4] [decimal](18, 2) NULL,
	[BrokerField5] [decimal](18, 2) NULL
) ON [PRIMARY]
END
GO
