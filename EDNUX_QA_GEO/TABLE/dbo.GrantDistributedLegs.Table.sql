/****** Object:  Table [dbo].[GrantDistributedLegs]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantDistributedLegs](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDistributionId] [varchar](20) NOT NULL,
	[GrantDistributedLegId] [numeric](18, 0) NOT NULL,
	[OptionTimeQuantity] [numeric](18, 0) NOT NULL,
	[GrantDistributionNo] [numeric](18, 0) NOT NULL,
	[OptionPerformanceQuantity] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_GrantDistributedLegs] PRIMARY KEY CLUSTERED 
(
	[GrantDistributedLegId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistributedLegs_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs] CHECK CONSTRAINT [FK_GrantDistributedLegs_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistributedLegs_GrantRegistration] FOREIGN KEY([GrantRegistrationId])
REFERENCES [dbo].[GrantRegistration] ([GrantRegistrationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs] CHECK CONSTRAINT [FK_GrantDistributedLegs_GrantRegistration]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistributedLegs_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs] CHECK CONSTRAINT [FK_GrantDistributedLegs_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistributedLegs_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistributedLegs_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistributedLegs]'))
ALTER TABLE [dbo].[GrantDistributedLegs] CHECK CONSTRAINT [FK_GrantDistributedLegs_ShareHolderApproval]
GO
