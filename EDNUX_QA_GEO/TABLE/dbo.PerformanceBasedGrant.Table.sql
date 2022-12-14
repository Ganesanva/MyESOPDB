/****** Object:  Table [dbo].[PerformanceBasedGrant]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PerformanceBasedGrant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PerformanceBasedGrant](
	[PerformanceBasedGrantID] [varchar](20) NOT NULL,
	[SchemeID] [varchar](50) NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[GrantOptionID] [varchar](100) NOT NULL,
	[GrantLegID] [numeric](18, 0) NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[CancellationDate] [datetime] NOT NULL,
	[CancelledOptions] [numeric](18, 0) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[CancelledPercentage] [numeric](18, 0) NOT NULL,
	[CancellationReason] [varchar](100) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Counter] [char](1) NOT NULL,
	[AvailableOptionsPer] [numeric](18, 2) NULL,
	[NumberOfOptionsAvailable] [numeric](18, 0) NOT NULL,
	[NumberOfOptionsGranted] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[NumberOfOptionsTransferred] [numeric](18, 0) NULL,
	[TransferToGrantLegId] [numeric](18, 0) NULL,
 CONSTRAINT [PK_PerformanceBasedGrant] PRIMARY KEY CLUSTERED 
(
	[PerformanceBasedGrantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Performan__Numbe__6B0FDBE9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PerformanceBasedGrant] ADD  DEFAULT (NULL) FOR [NumberOfOptionsTransferred]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Performan__Trans__6C040022]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PerformanceBasedGrant] ADD  DEFAULT (NULL) FOR [TransferToGrantLegId]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceBasedGrant_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerformanceBasedGrant]'))
ALTER TABLE [dbo].[PerformanceBasedGrant]  WITH NOCHECK ADD  CONSTRAINT [FK_PerformanceBasedGrant_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceBasedGrant_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerformanceBasedGrant]'))
ALTER TABLE [dbo].[PerformanceBasedGrant] CHECK CONSTRAINT [FK_PerformanceBasedGrant_EmployeeMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceBasedGrant_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerformanceBasedGrant]'))
ALTER TABLE [dbo].[PerformanceBasedGrant]  WITH NOCHECK ADD  CONSTRAINT [FK_PerformanceBasedGrant_Scheme] FOREIGN KEY([SchemeID])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceBasedGrant_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[PerformanceBasedGrant]'))
ALTER TABLE [dbo].[PerformanceBasedGrant] CHECK CONSTRAINT [FK_PerformanceBasedGrant_Scheme]
GO
