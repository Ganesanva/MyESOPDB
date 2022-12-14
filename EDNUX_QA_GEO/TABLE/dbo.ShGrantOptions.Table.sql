/****** Object:  Table [dbo].[ShGrantOptions]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShGrantOptions](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDistributionId] [varchar](20) NOT NULL,
	[MassUploadId] [numeric](18, 0) NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[GrantedOptions] [numeric](18, 0) NOT NULL,
	[EmployeeId] [varchar](20) NOT NULL,
	[GrantedShares] [numeric](18, 0) NOT NULL,
	[IsMassUpload] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NOT NULL,
 CONSTRAINT [PK_ShGrantOptions] PRIMARY KEY CLUSTERED 
(
	[GrantOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_ShGrantOptions_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions] CHECK CONSTRAINT [FK_ShGrantOptions_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_MassUpload]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_ShGrantOptions_MassUpload] FOREIGN KEY([MassUploadId])
REFERENCES [dbo].[MassUpload] ([MassUploadID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_MassUpload]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions] CHECK CONSTRAINT [FK_ShGrantOptions_MassUpload]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_ShGrantOptions_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions] CHECK CONSTRAINT [FK_ShGrantOptions_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_ShGrantOptions_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ShGrantOptions_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[ShGrantOptions]'))
ALTER TABLE [dbo].[ShGrantOptions] CHECK CONSTRAINT [FK_ShGrantOptions_ShareHolderApproval]
GO
