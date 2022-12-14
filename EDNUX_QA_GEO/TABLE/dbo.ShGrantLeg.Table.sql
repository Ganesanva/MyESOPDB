/****** Object:  Table [dbo].[ShGrantLeg]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShGrantLeg]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShGrantLeg](
	[ID] [numeric](18, 0) NOT NULL,
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NOT NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[GrantDistributionId] [varchar](20) NULL,
	[GrantOptionId] [varchar](100) NULL,
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
	[TempExercisableQuantity] [numeric](18, 0) NULL,
	[PerVestingQuantity] [numeric](18, 0) NULL,
 CONSTRAINT [PK_ShGrantLeg] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
