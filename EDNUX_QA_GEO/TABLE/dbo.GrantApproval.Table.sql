/****** Object:  Table [dbo].[GrantApproval]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantApproval]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantApproval](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[Description] [varchar](100) NULL,
	[NumberOfShares] [numeric](18, 0) NOT NULL,
	[ValidUptoDate] [datetime] NOT NULL,
	[AddtionalShares] [numeric](18, 0) NULL,
	[AvailableShares] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_GrantApproval] PRIMARY KEY CLUSTERED 
(
	[GrantApprovalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantApproval_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantApproval]'))
ALTER TABLE [dbo].[GrantApproval]  WITH CHECK ADD  CONSTRAINT [FK_GrantApproval_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantApproval_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantApproval]'))
ALTER TABLE [dbo].[GrantApproval] CHECK CONSTRAINT [FK_GrantApproval_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantApproval_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantApproval]'))
ALTER TABLE [dbo].[GrantApproval]  WITH CHECK ADD  CONSTRAINT [FK_GrantApproval_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantApproval_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantApproval]'))
ALTER TABLE [dbo].[GrantApproval] CHECK CONSTRAINT [FK_GrantApproval_ShareHolderApproval]
GO
