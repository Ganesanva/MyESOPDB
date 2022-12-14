/****** Object:  Table [dbo].[ShTransactionDetails_back]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails_back]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShTransactionDetails_back](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Cheque_DDNo] [varchar](20) NULL,
	[BankName] [varchar](200) NULL,
	[DrawnOn] [datetime] NULL,
	[WriteTransferNo] [varchar](20) NULL,
	[PANNumber] [varchar](15) NULL,
	[ITCircle_WardNo] [varchar](15) NULL,
	[ResidentialStatus] [varchar](20) NULL,
	[DematACType] [varchar](15) NULL,
	[DepositoryName] [varchar](200) NULL,
	[DPIDNo] [varchar](20) NULL,
	[DepositoryParticipantName] [varchar](200) NULL,
	[ClientNo] [varchar](20) NULL,
	[AmountPaid] [numeric](18, 2) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[Cheque_DDNo_FBT] [varchar](20) NULL,
	[BankName_FBT] [varchar](50) NULL,
	[DrawnOn_FBT] [datetime] NULL,
	[DPRecord] [varchar](50) NULL,
	[PaymentNameEX] [varchar](100) NULL,
	[PaymentNamePQ] [varchar](100) NULL,
	[Nationality] [varchar](100) NULL,
	[Location] [varchar](100) NULL,
	[IBANNo] [varchar](100) NULL,
	[Mobile] [varchar](100) NULL,
	[IBANNoPQ] [varchar](100) NULL,
	[CountryCode] [varchar](10) NULL,
	[ActionType] [varchar](1) NULL,
	[PerqAmt_ChequeNo] [varchar](50) NULL,
	[PerqAmt_DrownOndate] [datetime] NULL,
	[PerqAmt_WireTransfer] [varchar](50) NULL,
	[PerqAmt_BankName] [varchar](50) NULL,
	[PerqAmt_Branch] [varchar](50) NULL,
	[PerqAmt_BankAccountNumber] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[AccountNo] [varchar](50) NULL
) ON [PRIMARY]
END
GO
