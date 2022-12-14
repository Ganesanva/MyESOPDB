/****** Object:  Table [dbo].[GrantLeg]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantLeg](
	[ID] [numeric](18, 0) NOT NULL,
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[GrantDistributionId] [varchar](20) NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[VestingPeriodId] [numeric](18, 0) NULL,
	[GrantDistributedLegId] [numeric](18, 0) NULL,
	[GrantLegId] [decimal](10, 0) NOT NULL,
	[Counter] [numeric](18, 0) NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[VestingDate] [datetime] NOT NULL,
	[ExpirayDate] [datetime] NOT NULL,
	[GrantedOptions] [numeric](18, 0) NOT NULL,
	[GrantedQuantity] [numeric](18, 0) NOT NULL,
	[SplitQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitQuantity] [numeric](18, 0) NOT NULL,
	[Parent] [char](1) NOT NULL,
	[AcceleratedVestingDate] [datetime] NULL,
	[AcceleratedExpirayDate] [datetime] NULL,
	[SeperatingVestingDate] [datetime] NOT NULL,
	[SeperationCancellationDate] [datetime] NOT NULL,
	[FinalVestingDate] [datetime] NULL,
	[FinalExpirayDate] [datetime] NULL,
	[CancellationDate] [datetime] NULL,
	[CancellationReason] [varchar](100) NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[SplitCancelledQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitCancelledQuantity] [numeric](18, 0) NOT NULL,
	[UnapprovedExerciseQuantity] [numeric](18, 0) NOT NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[SplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitExercisedQuantity] [numeric](18, 0) NOT NULL,
	[ExercisableQuantity] [numeric](18, 0) NOT NULL,
	[UnvestedQuantity] [numeric](18, 0) NOT NULL,
	[Status] [char](1) NOT NULL,
	[ParentID] [varchar](20) NULL,
	[LapsedQuantity] [numeric](18, 0) NOT NULL,
	[IsPerfBased] [char](1) NOT NULL,
	[SeparationPerformed] [char](1) NULL,
	[ExpiryPerformed] [char](1) NULL,
	[VestMailSent] [char](1) NULL,
	[ExpiredMailSent] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[IsOriginal] [char](1) NULL,
	[IsBonus] [char](1) NULL,
	[IsSplit] [char](1) NULL,
	[TEMPEXERCISABLEQUANTITY] [numeric](18, 0) NULL,
	[PerVestingQuantity] [numeric](18, 0) NULL,
 CONSTRAINT [PK_GrantLeg] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [GrantLeg_FinalVestingDate]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_FinalVestingDate')
CREATE NONCLUSTERED INDEX [GrantLeg_FinalVestingDate] ON [dbo].[GrantLeg]
(
	[FinalVestingDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [GrantLeg_GrantLegId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_GrantLegId')
CREATE NONCLUSTERED INDEX [GrantLeg_GrantLegId] ON [dbo].[GrantLeg]
(
	[GrantLegId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantLeg_GrantOptionId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_GrantOptionId')
CREATE NONCLUSTERED INDEX [GrantLeg_GrantOptionId] ON [dbo].[GrantLeg]
(
	[GrantOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantLeg_GrantRegistrationId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_GrantRegistrationId')
CREATE NONCLUSTERED INDEX [GrantLeg_GrantRegistrationId] ON [dbo].[GrantLeg]
(
	[GrantRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantLeg_SchemeId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_SchemeId')
CREATE NONCLUSTERED INDEX [GrantLeg_SchemeId] ON [dbo].[GrantLeg]
(
	[SchemeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantLeg_VestingType]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'GrantLeg_VestingType')
CREATE NONCLUSTERED INDEX [GrantLeg_VestingType] ON [dbo].[GrantLeg]
(
	[VestingType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ON_GRNAT_LEG]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantLeg]') AND name = N'ON_GRNAT_LEG')
CREATE NONCLUSTERED INDEX [ON_GRNAT_LEG] ON [dbo].[GrantLeg]
(
	[GrantRegistrationId] ASC,
	[GrantOptionId] ASC,
	[GrantLegId] ASC,
	[VestingType] ASC
)
INCLUDE([GrantedQuantity],[FinalVestingDate],[CancelledQuantity],[UnapprovedExerciseQuantity],[ExercisedQuantity],[LapsedQuantity],[IsPerfBased]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantLeg_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [FK_GrantLeg_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_GrantDistributedLegs]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantLeg_GrantDistributedLegs] FOREIGN KEY([GrantDistributedLegId])
REFERENCES [dbo].[GrantDistributedLegs] ([GrantDistributedLegId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_GrantDistributedLegs]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [FK_GrantLeg_GrantDistributedLegs]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantLeg_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [FK_GrantLeg_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantLeg_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantLeg_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [FK_GrantLeg_ShareHolderApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitCancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_BonusSplitCancelledQuantity] CHECK  (([BonusSplitCancelledQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitCancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_BonusSplitCancelledQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_BonusSplitExercisedQuantity] CHECK  (([BonusSplitExercisedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_BonusSplitExercisedQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_BonusSplitQuantity] CHECK  (([BonusSplitQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_BonusSplitQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_BonusSplitQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_CancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_CancelledQuantity] CHECK  (([CancelledQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_CancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_CancelledQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_ExercisableQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_ExercisableQuantity] CHECK  (([ExercisableQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_ExercisableQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_ExercisableQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_ExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_ExercisedQuantity] CHECK  (([ExercisedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_ExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_ExercisedQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_GrantedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_GrantedQuantity] CHECK  (([GrantedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_GrantedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_GrantedQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_LapsedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_LapsedQuantity] CHECK  (([LapsedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_LapsedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_LapsedQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitCancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_SplitCancelledQuantity] CHECK  (([SplitCancelledQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitCancelledQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_SplitCancelledQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_SplitExercisedQuantity] CHECK  (([SplitExercisedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitExercisedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_SplitExercisedQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_SplitQuantity] CHECK  (([SplitQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_SplitQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_SplitQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UnapprovedExerciseQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_UnapprovedExerciseQuantity] CHECK  (([UnapprovedExerciseQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UnapprovedExerciseQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_UnapprovedExerciseQuantity]
GO
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UnvestedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg]  WITH NOCHECK ADD  CONSTRAINT [chk_UnvestedQuantity] CHECK  (([UnvestedQuantity]>=(0)))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[chk_UnvestedQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantLeg]'))
ALTER TABLE [dbo].[GrantLeg] CHECK CONSTRAINT [chk_UnvestedQuantity]
GO
/****** Object:  Trigger [dbo].[TrgDeleteDynamicTables]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TrgDeleteDynamicTables]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[TrgDeleteDynamicTables]
   ON  [dbo].[GrantLeg]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON
	
	DECLARE 
	@TOTAL_ROWS AS INT, 
	@ROW_NUNMER AS INT,
	@TABLE_NAME AS VARCHAR(100)
	
	SELECT ROW_NUMBER()OVER (ORDER BY NAME) AS SR_NO, NAME INTO #DYNAMIC_REPORT FROM SYS.TABLES WHERE NAME LIKE ''DYNAMIC_REPORT%''
	 
	SET @ROW_NUNMER = 1
	SELECT @TOTAL_ROWS = COUNT(NAME) FROM #DYNAMIC_REPORT

	WHILE @ROW_NUNMER <= @TOTAL_ROWS
	BEGIN
		SELECT @TABLE_NAME = NAME FROM #DYNAMIC_REPORT WHERE SR_NO = @ROW_NUNMER
		
		EXEC (''DROP TABLE '' + @TABLE_NAME)
		          
		SET @ROW_NUNMER = @ROW_NUNMER + 1
	END
	
	SET NOCOUNT OFF;

END
' 
GO
ALTER TABLE [dbo].[GrantLeg] ENABLE TRIGGER [TrgDeleteDynamicTables]
GO
