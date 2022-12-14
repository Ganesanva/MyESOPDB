/****** Object:  Table [dbo].[ShTransactionDetails]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShTransactionDetails](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Cheque_DDNo] [varchar](20) NULL,
	[BankName] [varchar](200) NULL,
	[DrawnOn] [datetime] NULL,
	[WriteTransferNo] [varchar](20) NULL,
	[PANNumber] [varchar](15) NULL,
	[ITCircle_WardNo] [varchar](15) NULL,
	[ResidentialStatus] [char](1) NULL,
	[DematACType] [varchar](15) NULL,
	[DepositoryName] [varchar](200) NULL,
	[DPIDNo] [varchar](20) NULL,
	[DepositoryParticipantName] [varchar](200) NULL,
	[ClientNo] [varchar](16) NULL,
	[AmountPaid] [numeric](18, 2) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[Cheque_DDNo_FBT] [varchar](20) NULL,
	[BankName_FBT] [varchar](50) NULL,
	[DrawnOn_FBT] [datetime] NULL,
	[DPRecord] [varchar](50) NULL,
	[PerqAmt_ChequeNo] [varchar](50) NULL,
	[PerqAmt_DrownOndate] [datetime] NULL,
	[PerqAmt_WireTransfer] [varchar](50) NULL,
	[PerqAmt_BankName] [varchar](200) NULL,
	[PerqAmt_Branch] [varchar](200) NULL,
	[PerqAmt_BankAccountNumber] [varchar](50) NULL,
	[Branch] [varchar](200) NULL,
	[AccountNo] [varchar](50) NULL,
	[PaymentNameEX] [varchar](100) NULL,
	[PaymentNamePQ] [varchar](100) NULL,
	[Nationality] [varchar](100) NULL,
	[Location] [varchar](100) NULL,
	[IBANNo] [varchar](100) NULL,
	[Mobile] [varchar](20) NULL,
	[IBANNoPQ] [varchar](100) NULL,
	[CountryCode] [varchar](10) NULL,
	[STATUS] [char](1) NOT NULL,
	[ActionType] [varchar](1) NULL,
	[SecondaryEmailID] [varchar](500) NULL,
	[ExerciseBankType] [varchar](20) NULL,
	[PerqBankType] [varchar](20) NULL,
	[ExAmtTypOfBnkAC] [int] NULL,
	[PeqTxTypOfBnkAC] [int] NULL,
	[CountryName] [varchar](50) NULL,
	[COST_CENTER] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShTransac__STATU__220B0B18]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShTransactionDetails] ADD  DEFAULT ('P') FOR [STATUS]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShTransac__COST___675F4696]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShTransactionDetails] ADD  DEFAULT (NULL) FOR [COST_CENTER]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShTransac__BROKE__68536ACF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShTransactionDetails] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_NAME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShTransac__BROKE__69478F08]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShTransactionDetails] ADD  DEFAULT (NULL) FOR [BROKER_DEP_TRUST_CMP_ID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShTransac__BROKE__6A3BB341]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShTransactionDetails] ADD  DEFAULT (NULL) FOR [BROKER_ELECT_ACC_NUM]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ExAmtTypOfBnkAC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails]'))
ALTER TABLE [dbo].[ShTransactionDetails]  WITH CHECK ADD  CONSTRAINT [fk_ExAmtTypOfBnkAC] FOREIGN KEY([ExAmtTypOfBnkAC])
REFERENCES [dbo].[TypeOfBankAc] ([TypeOfBankAcID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ExAmtTypOfBnkAC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails]'))
ALTER TABLE [dbo].[ShTransactionDetails] CHECK CONSTRAINT [fk_ExAmtTypOfBnkAC]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_PeqTxTypOfBnkAC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails]'))
ALTER TABLE [dbo].[ShTransactionDetails]  WITH CHECK ADD  CONSTRAINT [fk_PeqTxTypOfBnkAC] FOREIGN KEY([PeqTxTypOfBnkAC])
REFERENCES [dbo].[TypeOfBankAc] ([TypeOfBankAcID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_PeqTxTypOfBnkAC]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShTransactionDetails]'))
ALTER TABLE [dbo].[ShTransactionDetails] CHECK CONSTRAINT [fk_PeqTxTypOfBnkAC]
GO
