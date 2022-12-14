/****** Object:  Table [dbo].[ShGrantDistribution]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShGrantDistribution](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDistributionId] [varchar](20) NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[GrantDistributionQuantity] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastModifiedOn] [datetime] NOT NULL,
	[VestingPeriodId] [numeric](18, 0) NOT NULL,
	[Action] [char](1) NOT NULL,
 CONSTRAINT [PK_ShGrantDistribution] PRIMARY KEY CLUSTERED 
(
	[GrantDistributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantDistribution_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution] CHECK CONSTRAINT [FK_ShGrantDistribution_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantDistribution_GrantRegistration] FOREIGN KEY([GrantRegistrationId])
REFERENCES [dbo].[GrantRegistration] ([GrantRegistrationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_GrantRegistration]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution] CHECK CONSTRAINT [FK_ShGrantDistribution_GrantRegistration]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantDistribution_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution] CHECK CONSTRAINT [FK_ShGrantDistribution_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantDistribution_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantDistribution_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantDistribution]'))
ALTER TABLE [dbo].[ShGrantDistribution] CHECK CONSTRAINT [FK_ShGrantDistribution_ShareHolderApproval]
GO
