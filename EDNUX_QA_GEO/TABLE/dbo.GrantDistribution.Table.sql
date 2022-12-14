/****** Object:  Table [dbo].[GrantDistribution]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantDistribution]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantDistribution](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDistributionId] [varchar](20) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[GrantDistributionQuantity] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[VestingPeriodId] [numeric](18, 0) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_GrantDistribution] PRIMARY KEY CLUSTERED 
(
	[GrantDistributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistribution_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution] CHECK CONSTRAINT [FK_GrantDistribution_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistribution_GrantRegistration] FOREIGN KEY([GrantRegistrationId])
REFERENCES [dbo].[GrantRegistration] ([GrantRegistrationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution] CHECK CONSTRAINT [FK_GrantDistribution_GrantRegistration]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistribution_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution] CHECK CONSTRAINT [FK_GrantDistribution_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_GrantDistribution_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantDistribution_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantDistribution]'))
ALTER TABLE [dbo].[GrantDistribution] CHECK CONSTRAINT [FK_GrantDistribution_ShareHolderApproval]
GO
