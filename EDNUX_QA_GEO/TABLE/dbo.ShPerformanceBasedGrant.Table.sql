/****** Object:  Table [dbo].[ShPerformanceBasedGrant]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShPerformanceBasedGrant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShPerformanceBasedGrant](
	[SchemeId] [varchar](50) NULL,
	[EmployeeId] [varchar](20) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantLegId] [numeric](18, 0) NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[CancellationDate] [datetime] NOT NULL,
	[CancelledOptions] [numeric](18, 0) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[CancelledPercentage] [numeric](18, 0) NOT NULL,
	[CancellationReason] [varchar](100) NOT NULL,
	[Action] [char](1) NOT NULL,
	[Counter] [char](1) NOT NULL,
	[AvailableOptionsPer] [numeric](18, 2) NULL,
	[NumberOfOptionsAvailable] [numeric](18, 0) NOT NULL,
	[NumberOfOptionsGranted] [numeric](18, 0) NOT NULL,
	[IsMassUpload] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[NumberOfOptionsTransferred] [numeric](18, 0) NULL,
	[TransferToGrantLegId] [numeric](18, 0) NULL,
	[IsApproved] [bit] NULL,
	[FutureVestImpExec] [varchar](10) NULL,
 CONSTRAINT [PK_ShPerformanceBasedGrant] PRIMARY KEY CLUSTERED 
(
	[GrantOptionId] ASC,
	[GrantLegId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShPerform__Numbe__6CF8245B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShPerformanceBasedGrant] ADD  DEFAULT (NULL) FOR [NumberOfOptionsTransferred]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ShPerform__Trans__6DEC4894]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ShPerformanceBasedGrant] ADD  DEFAULT (NULL) FOR [TransferToGrantLegId]
END
GO
