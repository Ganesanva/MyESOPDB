/****** Object:  Table [dbo].[TempGrantLeg]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempGrantLeg]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TempGrantLeg](
	[ID] [numeric](18, 0) NOT NULL,
	[VestingDate] [datetime] NOT NULL,
	[GrantedOptions] [numeric](18, 0) NOT NULL,
	[ExercisableQuantity] [numeric](18, 0) NOT NULL,
	[UnapprovedExerciseQuantity] [numeric](18, 0) NOT NULL,
	[FinalVestingDate] [datetime] NULL,
	[FinalExpirayDate] [datetime] NULL,
	[ExercisePrice] [numeric](18, 2) NOT NULL,
	[GrantDate] [datetime] NULL,
	[LockInPeriodStartsFrom] [varchar](1) NULL,
	[LockInPeriod] [numeric](18, 0) NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NULL,
	[OptionRatioDivisor] [numeric](18, 0) NULL,
	[ExercisedQuantity] [numeric](18, 0) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantLegId] [decimal](10, 0) NOT NULL,
	[SchemeTitle] [varchar](50) NULL,
	[Counter] [numeric](18, 0) NULL,
	[Parent] [char](1) NULL
) ON [PRIMARY]
END
GO
