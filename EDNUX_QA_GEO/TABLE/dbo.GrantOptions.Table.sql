/****** Object:  Table [dbo].[GrantOptions]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GrantOptions](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NULL,
	[GrantApprovalId] [varchar](20) NOT NULL,
	[GrantRegistrationId] [varchar](20) NOT NULL,
	[GrantDistributionId] [varchar](20) NOT NULL,
	[MassUploadId] [numeric](18, 0) NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[GrantedOptions] [numeric](18, 0) NOT NULL,
	[EmployeeId] [varchar](20) NOT NULL,
	[GrantedShares] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_GrantOptions] PRIMARY KEY CLUSTERED 
(
	[GrantOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [<NonCIndesx, GopIDEmpD>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptions]') AND name = N'<NonCIndesx, GopIDEmpD>')
CREATE NONCLUSTERED INDEX [<NonCIndesx, GopIDEmpD>] ON [dbo].[GrantOptions]
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantOptions_GrantOptionId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptions]') AND name = N'GrantOptions_GrantOptionId')
CREATE NONCLUSTERED INDEX [GrantOptions_GrantOptionId] ON [dbo].[GrantOptions]
(
	[GrantOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantOptions_GrantRegistrationId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptions]') AND name = N'GrantOptions_GrantRegistrationId')
CREATE NONCLUSTERED INDEX [GrantOptions_GrantRegistrationId] ON [dbo].[GrantOptions]
(
	[GrantRegistrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [GrantOptions_SchemeId]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[GrantOptions]') AND name = N'GrantOptions_SchemeId')
CREATE NONCLUSTERED INDEX [GrantOptions_SchemeId] ON [dbo].[GrantOptions]
(
	[SchemeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantOptions_GrantApproval] FOREIGN KEY([GrantApprovalId])
REFERENCES [dbo].[GrantApproval] ([GrantApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_GrantApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions] CHECK CONSTRAINT [FK_GrantOptions_GrantApproval]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_MassUpload]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantOptions_MassUpload] FOREIGN KEY([MassUploadId])
REFERENCES [dbo].[MassUpload] ([MassUploadID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_MassUpload]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions] CHECK CONSTRAINT [FK_GrantOptions_MassUpload]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantOptions_Scheme] FOREIGN KEY([SchemeId])
REFERENCES [dbo].[Scheme] ([SchemeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_Scheme]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions] CHECK CONSTRAINT [FK_GrantOptions_Scheme]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions]  WITH NOCHECK ADD  CONSTRAINT [FK_GrantOptions_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GrantOptions_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[GrantOptions]'))
ALTER TABLE [dbo].[GrantOptions] CHECK CONSTRAINT [FK_GrantOptions_ShareHolderApproval]
GO
