/****** Object:  Table [dbo].[ShExercisedOptions]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShExercisedOptions](
	[ExerciseId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[SplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[ExercisePrice] [numeric](18, 2) NOT NULL,
	[ExerciseDate] [datetime] NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[LockedInTill] [datetime] NULL,
	[ExercisableQuantity] [numeric](18, 0) NOT NULL,
	[ValidationStatus] [char](1) NOT NULL,
	[Action] [char](1) NOT NULL,
	[GrantLegId] [numeric](18, 0) NOT NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[LotNumber] [varchar](20) NULL,
	[DiscrepancyInformation] [varchar](200) NULL,
	[SharesIssuedDate] [datetime] NULL,
	[DrawnOn] [datetime] NULL,
	[IsMassUpload] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Cash] [varchar](50) NULL,
	[FBTValue] [numeric](10, 2) NULL,
	[FBTPayable] [numeric](10, 2) NULL,
	[FBTPayBy] [varchar](20) NULL,
	[FBTDays] [int] NULL,
	[TravelDays] [int] NULL,
	[FBTTravelInfoYN] [char](1) NULL,
	[PerqstValue] [numeric](18, 6) NULL,
	[PerqstPayable] [numeric](18, 6) NULL,
	[FMVPrice] [numeric](18, 6) NULL,
	[isExerciseMailSent] [varchar](1) NULL,
	[payrollcountry] [varchar](50) NULL,
	[Perq_Tax_rate] [numeric](18, 6) NULL,
	[SharesArised] [numeric](18, 0) NULL,
	[FaceValue] [numeric](18, 2) NULL,
	[SARExerciseAmount] [numeric](18, 2) NULL,
	[StockApperciationAmt] [numeric](18, 2) NULL,
	[FMV_SAR] [numeric](18, 2) NULL,
	[Cheque_received_deposited] [char](1) NULL,
	[PaymentMode] [varchar](1) NULL,
	[CapitalGainTax] [numeric](18, 6) NULL,
	[ExerciseFormReceived] [varchar](10) NOT NULL,
	[ReceivedDate] [datetime] NULL,
	[TaxRule] [varchar](5) NULL,
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
	[MIT_ID] [int] NULL,
	[TAX_SEQUENCENO] [int] NULL,
	[StockApprValue] [numeric](18, 6) NULL,
	[TentativeStockApprValue] [numeric](18, 6) NULL,
	[CashPayoutValue] [numeric](18, 6) NULL,
	[TentativeCashPayoutValue] [numeric](18, 6) NULL,
	[SettlmentPrice] [numeric](18, 6) NULL,
	[TentativeSettlmentPrice] [numeric](18, 6) NULL,
	[IS_UPLOAD_EXERCISE_FORM] [int] NULL,
	[IS_UPLOAD_EXERCISE_FORM_ON] [datetime] NULL,
	[TentativeFMVPrice] [numeric](18, 6) NULL,
	[TentativePerqstValue] [numeric](18, 6) NULL,
	[TentativePerqstPayable] [numeric](18, 6) NULL,
	[IsAutoExercised] [tinyint] NULL,
	[PerPayModeSelected] [nvarchar](5) NULL,
	[Entity] [bigint] NULL,
	[EntityBaseOn] [bigint] NULL,
	[IsPrevestExercised] [tinyint] NOT NULL,
	[ExercisePriceINR] [numeric](18, 2) NULL,
	[ShareAriseApprValue] [numeric](18, 6) NULL,
	[TentShareAriseApprValue] [numeric](18, 6) NULL,
	[CALCULATE_TAX] [nvarchar](100) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS] [int] NULL,
	[CALCUALTE_TAX_PRIOR_DAYS_PREVESTING] [int] NULL,
	[IsAccepted] [int] NULL,
	[IsAcceptedOn] [datetime] NULL,
	[IsOneProcessFlow] [bit] NULL,
 CONSTRAINT [PK_ShExerciseOptions] PRIMARY KEY CLUSTERED 
(
	[ExerciseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [<NonShindxIndex, Shexindex,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'<NonShindxIndex, Shexindex,>')
CREATE NONCLUSTERED INDEX [<NonShindxIndex, Shexindex,>] ON [dbo].[ShExercisedOptions]
(
	[IsMassUpload] ASC,
	[Action] ASC,
	[Cash] ASC
)
INCLUDE([GrantLegSerialNumber],[ExercisedQuantity],[ExercisePrice],[ExerciseDate],[ExerciseNo],[PerqstValue],[PerqstPayable],[FMVPrice],[PaymentMode],[isFormGenerate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IndexShEx, ShIndex,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'IndexShEx, ShIndex,>')
CREATE NONCLUSTERED INDEX [IndexShEx, ShIndex,>] ON [dbo].[ShExercisedOptions]
(
	[GrantLegSerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonCIndexShEx, ShExIndx,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonCIndexShEx, ShExIndx,>')
CREATE NONCLUSTERED INDEX [NonCIndexShEx, ShExIndx,>] ON [dbo].[ShExercisedOptions]
(
	[GrantLegId] ASC
)
INCLUDE([GrantLegSerialNumber],[ExercisedQuantity]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonShExerciseIndex, Shexindex1,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonShExerciseIndex, Shexindex1,>')
CREATE NONCLUSTERED INDEX [NonShExerciseIndex, Shexindex1,>] ON [dbo].[ShExercisedOptions]
(
	[GrantLegId] ASC
)
INCLUDE([GrantLegSerialNumber],[ExercisedQuantity]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonShexIndex2, ShexerIndexExNo,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonShexIndex2, ShexerIndexExNo,>')
CREATE NONCLUSTERED INDEX [NonShexIndex2, ShexerIndexExNo,>] ON [dbo].[ShExercisedOptions]
(
	[ExerciseNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonShexIndex3, ShExerciedIndex,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonShexIndex3, ShExerciedIndex,>')
CREATE NONCLUSTERED INDEX [NonShexIndex3, ShExerciedIndex,>] ON [dbo].[ShExercisedOptions]
(
	[GrantLegSerialNumber] ASC
)
INCLUDE([ExercisedQuantity],[SplitExercisedQuantity],[ExercisePrice],[ExerciseDate],[EmployeeID],[ValidationStatus],[Action],[ExerciseNo],[LotNumber],[PerqstValue],[PerqstPayable],[FMVPrice],[Perq_Tax_rate],[PaymentMode],[ExerciseFormReceived],[ReceivedDate],[ExerciseSARid],[IsPaymentDeposited],[PaymentDepositedDate],[IsPaymentConfirmed],[PaymentConfirmedDate],[IsExerciseAllotted],[ExerciseAllotedDate],[IsAllotmentGenerated],[AllotmentGenerateDate],[IsAllotmentGeneratedReversed],[AllotmentGeneratedReversedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonShexIndex3, ShGrantLegSIndx,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonShexIndex3, ShGrantLegSIndx,>')
CREATE NONCLUSTERED INDEX [NonShexIndex3, ShGrantLegSIndx,>] ON [dbo].[ShExercisedOptions]
(
	[GrantLegId] ASC
)
INCLUDE([GrantLegSerialNumber],[ExercisedQuantity]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonShexIndexExNo, ExerNoIndex,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]') AND name = N'NonShexIndexExNo, ExerNoIndex,>')
CREATE NONCLUSTERED INDEX [NonShexIndexExNo, ExerNoIndex,>] ON [dbo].[ShExercisedOptions]
(
	[EmployeeID] ASC,
	[ExerciseNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Exerc__15A53433]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ('N') FOR [ExerciseFormReceived]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsPay__0DCF0841]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsPaymentDeposited]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Payme__0EC32C7A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [PaymentDepositedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsPay__0FB750B3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsPaymentConfirmed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Payme__10AB74EC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [PaymentConfirmedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsExe__119F9925]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsExerciseAllotted]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Exerc__1293BD5E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [ExerciseAllotedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsAll__1387E197]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsAllotmentGenerated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Allot__147C05D0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [AllotmentGenerateDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsAll__15702A09]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsAllotmentGeneratedReversed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Allot__16644E42]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [AllotmentGeneratedReversedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Gener__1758727B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [GenerateAllotListUniqueId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Gener__184C96B4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [GenerateAllotListUniqueIdDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsPay__1940BAED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsPayInSlipGenerated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__PayIn__1A34DF26]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [PayInSlipGeneratedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__PayIn__1B29035F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [PayInSlipGeneratedUniqueId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsTRC__636EBA21]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsTRCFormReceived]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__TRCFo__5DB5E0CB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [TRCFormReceivedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__TRCFo__5EAA0504]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [TRCFormReceivedUpdatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__TRCFo__5F9E293D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [TRCFormReceivedUpdatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsFor__60924D76]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsForm10FReceived]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__Form1__618671AF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (NULL) FOR [Form10FReceivedDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__isFor__0E591826]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [isFormGenerate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsPre__3C4ACB5F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsPrevestExercised]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsAcc__1C5EB568]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT ((0)) FOR [IsAccepted]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShExercis__IsAcc__1D52D9A1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShExercisedOptions] ADD  DEFAULT (getdate()) FOR [IsAcceptedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExercisedSARDetails_ShExerciseOptions]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]'))
ALTER TABLE [dbo].[ShExercisedOptions]  WITH CHECK ADD  CONSTRAINT [FK_ExercisedSARDetails_ShExerciseOptions] FOREIGN KEY([ExerciseSARid])
REFERENCES [dbo].[ExerciseSARDetails] ([ExerciseSARid])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ExercisedSARDetails_ShExerciseOptions]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]'))
ALTER TABLE [dbo].[ShExercisedOptions] CHECK CONSTRAINT [FK_ExercisedSARDetails_ShExerciseOptions]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLegSerialNumber]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]'))
ALTER TABLE [dbo].[ShExercisedOptions]  WITH CHECK ADD  CONSTRAINT [FK_GrantLegSerialNumber] FOREIGN KEY([GrantLegSerialNumber])
REFERENCES [dbo].[GrantLeg] ([ID])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLegSerialNumber]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShExercisedOptions]'))
ALTER TABLE [dbo].[ShExercisedOptions] CHECK CONSTRAINT [FK_GrantLegSerialNumber]
GO
