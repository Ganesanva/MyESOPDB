/****** Object:  Table [dbo].[Exercised]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exercised]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Exercised](
	[ExercisedId] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[SplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[ExercisedDate] [datetime] NOT NULL,
	[ExercisedPrice] [numeric](10, 2) NOT NULL,
	[BSEOriginalPrice] [numeric](18, 2) NULL,
	[LockedInTill] [datetime] NULL,
	[SharesIssuedStatus] [char](1) NOT NULL,
	[SharesIssuedDate] [datetime] NULL,
	[ExercisableQuantity] [numeric](18, 0) NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[LotNumber] [varchar](20) NULL,
	[DrawnOn] [datetime] NULL,
	[ValidationStatus] [char](1) NOT NULL,
	[Status] [char](1) NOT NULL,
	[PerqstValue] [numeric](18, 6) NULL,
	[PerqstPayable] [numeric](18, 6) NULL,
	[FMVPrice] [numeric](18, 6) NULL,
	[payrollcountry] [varchar](100) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Cash] [varchar](50) NULL,
	[FBTValue] [numeric](10, 2) NOT NULL,
	[FBTPayable] [numeric](10, 2) NOT NULL,
	[FBTPayBy] [varchar](20) NULL,
	[FBTDays] [int] NULL,
	[TravelDays] [int] NULL,
	[FBTTravelInfoYN] [char](1) NULL,
	[Perq_Tax_rate] [numeric](18, 6) NULL,
	[SharesArised] [numeric](18, 0) NULL,
	[FaceValue] [numeric](18, 2) NULL,
	[SARExerciseAmount] [numeric](18, 2) NULL,
	[StockApperciationAmt] [numeric](18, 2) NULL,
	[FMV_SAR] [numeric](18, 2) NULL,
	[PaymentMode] [varchar](1) NULL,
	[CapitalGainTax] [numeric](18, 6) NULL,
	[isExerciseMailSent] [char](1) NULL,
	[ExerciseSARid] [int] NULL,
	[CGTformulaID] [int] NULL,
	[PANStatus] [varchar](20) NULL,
	[CGTRateLT] [decimal](18, 9) NULL,
	[CGTUpdatedDate] [datetime] NULL,
	[IsPaymentDeposited] [bit] NOT NULL,
	[PaymentDepositedDate] [datetime] NULL,
	[IsPaymentConfirmed] [bit] NOT NULL,
	[PaymentConfirmedDate] [datetime] NULL,
	[IsExerciseAllotted] [bit] NOT NULL,
	[ExerciseAllotedDate] [datetime] NULL,
	[IsAllotmentGenerated] [bit] NOT NULL,
	[AllotmentGenerateDate] [datetime] NULL,
	[IsAllotmentGeneratedReversed] [bit] NOT NULL,
	[AllotmentGeneratedReversedDate] [datetime] NULL,
	[GenerateAllotListUniqueId] [varchar](50) NULL,
	[GenerateAllotListUniqueIdDate] [datetime] NULL,
	[IsPayInSlipGenerated] [bit] NOT NULL,
	[PayInSlipGeneratedDate] [datetime] NULL,
	[PayInSlipGeneratedUniqueId] [varchar](50) NULL,
	[IsTRCFormReceived] [tinyint] NULL,
	[TRCFormReceivedDate] [datetime] NULL,
	[TRCFormReceivedUpdatedBy] [varchar](100) NULL,
	[TRCFormReceivedUpdatedOn] [datetime] NULL,
	[IsForm10FReceived] [tinyint] NOT NULL,
	[Form10FReceivedDate] [datetime] NULL,
	[isFormGenerate] [tinyint] NOT NULL,
	[TransID_BankRefNo] [varchar](50) NULL,
	[MIT_ID] [bigint] NULL,
	[TAX_SEQUENCENO] [int] NULL,
	[StockApprValue] [numeric](18, 6) NULL,
	[TentativeStockApprValue] [numeric](18, 6) NULL,
	[CashPayoutValue] [numeric](18, 6) NULL,
	[TentativeCashPayoutValue] [numeric](18, 6) NULL,
	[SettlmentPrice] [numeric](18, 6) NULL,
	[TentativeSettlmentPrice] [numeric](18, 6) NULL,
	[TentativeFMVPrice] [numeric](18, 6) NULL,
	[TentativePerqstValue] [numeric](18, 6) NULL,
	[TentativePerqstPayable] [numeric](18, 6) NULL,
	[PerPayModeSelected] [nvarchar](5) NULL,
	[Entity] [bigint] NULL,
	[EntityBaseOn] [bigint] NULL,
	[IsAutoExercised] [tinyint] NULL,
	[IsPrevestExercised] [tinyint] NOT NULL,
	[ShareAriseApprValue] [numeric](18, 6) NULL,
	[TentShareAriseApprValue] [numeric](18, 6) NULL,
	[CALCULATE_TAX] [nvarchar](100) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS] [int] NULL,
	[CALCUALTE_TAX_PRIOR_DAYS_PREVESTING] [int] NULL,
	[IsAccepted] [int] NULL,
	[IsAcceptedOn] [datetime] NULL,
 CONSTRAINT [PK_Exercise] PRIMARY KEY CLUSTERED 
(
	[ExercisedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__FBTVa__10216507]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [FBTValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__FBTPa__11158940]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [FBTPayable]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsPay__1C1D2798]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsPaymentDeposited]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Payme__1D114BD1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [PaymentDepositedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsPay__1E05700A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsPaymentConfirmed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Payme__1EF99443]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [PaymentConfirmedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsExe__1FEDB87C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsExerciseAllotted]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Exerc__20E1DCB5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [ExerciseAllotedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsAll__21D600EE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsAllotmentGenerated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Allot__22CA2527]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [AllotmentGenerateDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsAll__23BE4960]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsAllotmentGeneratedReversed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Allot__24B26D99]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [AllotmentGeneratedReversedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Gener__25A691D2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [GenerateAllotListUniqueId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Gener__269AB60B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [GenerateAllotListUniqueIdDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsPay__278EDA44]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsPayInSlipGenerated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__PayIn__2882FE7D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [PayInSlipGeneratedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__PayIn__297722B6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [PayInSlipGeneratedUniqueId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsTRC__6462DE5A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsTRCFormReceived]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__TRCFo__65570293]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [TRCFormReceivedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__TRCFo__664B26CC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [TRCFormReceivedUpdatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__TRCFo__673F4B05]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [TRCFormReceivedUpdatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsFor__68336F3E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsForm10FReceived]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__Form1__69279377]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (NULL) FOR [Form10FReceivedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__isFor__0F4D3C5F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [isFormGenerate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsPre__3D3EEF98]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsPrevestExercised]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsAcc__1E46FDDA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT ((0)) FOR [IsAccepted]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Exercised__IsAcc__1F3B2213]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Exercised] ADD  DEFAULT (getdate()) FOR [IsAcceptedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Exercise_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[Exercised]'))
ALTER TABLE [dbo].[Exercised]  WITH CHECK ADD  CONSTRAINT [FK_Exercise_GrantLeg] FOREIGN KEY([GrantLegSerialNumber])
REFERENCES [dbo].[GrantLeg] ([ID])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Exercise_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[Exercised]'))
ALTER TABLE [dbo].[Exercised] CHECK CONSTRAINT [FK_Exercise_GrantLeg]
GO
