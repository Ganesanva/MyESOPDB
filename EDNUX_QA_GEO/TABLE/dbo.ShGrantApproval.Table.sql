/****** Object:  Table [dbo].[ShGrantApproval]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShGrantApproval]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShGrantApproval](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[ApprovalDate] [datetime] NOT NULL,
	[Description] [varchar](100) NULL,
	[NumberOfShares] [varchar](50) NOT NULL,
	[ValidUpToDate] [datetime] NOT NULL,
	[AddtionalShares] [numeric](18, 0) NULL,
	[AvailableShares] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
 CONSTRAINT [PK_ShGrantApproval] PRIMARY KEY CLUSTERED 
(
	[GrantApprovalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantApproval_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantApproval]'))
ALTER TABLE [dbo].[ShGrantApproval]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantApproval_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantApproval_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantApproval]'))
ALTER TABLE [dbo].[ShGrantApproval] CHECK CONSTRAINT [FK_ShGrantApproval_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantApproval_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantApproval]'))
ALTER TABLE [dbo].[ShGrantApproval]  WITH CHECK ADD  CONSTRAINT [FK_ShGrantApproval_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantApproval_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantApproval]'))
ALTER TABLE [dbo].[ShGrantApproval] CHECK CONSTRAINT [FK_ShGrantApproval_ShareHolderApproval]
GO
