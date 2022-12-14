/****** Object:  Table [dbo].[VestingPeriod]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VestingPeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VestingPeriod](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[VestingPeriodId] [numeric](18, 0) NOT NULL,
	[VestingDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[OptionTimePercentage] [numeric](5, 2) NOT NULL,
	[OptionPerformancePercentage] [numeric](5, 2) NOT NULL,
	[VestingPeriodNo] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[FBTValue] [numeric](10, 2) NOT NULL,
	[AdjustResidueInTimeOrPerformance] [char](1) NOT NULL,
 CONSTRAINT [PK_VestingPeriod] PRIMARY KEY CLUSTERED 
(
	[VestingPeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__VestingPe__FBTVa__0F2D40CE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VestingPeriod] ADD  DEFAULT ((0)) FOR [FBTValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__VestingPe__Adjus__3E3D3572]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[VestingPeriod] ADD  DEFAULT ('T') FOR [AdjustResidueInTimeOrPerformance]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod]  WITH CHECK ADD  CONSTRAINT [FK_VestingPeriod_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod] CHECK CONSTRAINT [FK_VestingPeriod_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod]  WITH CHECK ADD  CONSTRAINT [FK_VestingPeriod_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod] CHECK CONSTRAINT [FK_VestingPeriod_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod]  WITH CHECK ADD  CONSTRAINT [FK_VestingPeriod_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_VestingPeriod_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[VestingPeriod]'))
ALTER TABLE [dbo].[VestingPeriod] CHECK CONSTRAINT [FK_VestingPeriod_ShareHolderApproval]
GO
