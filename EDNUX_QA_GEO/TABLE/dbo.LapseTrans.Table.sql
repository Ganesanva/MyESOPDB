/****** Object:  Table [dbo].[LapseTrans]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LapseTrans]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LapseTrans](
	[LapseTransID] [varchar](20) NOT NULL,
	[ApprovalStatus] [varchar](1) NOT NULL,
	[GrantOptionID] [varchar](100) NOT NULL,
	[GrantLegID] [decimal](10, 0) NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[LapsedQuantity] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[LapseDate] [datetime] NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_LapseTrans] PRIMARY KEY CLUSTERED 
(
	[LapseTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [<NonClusterIndx, GrantOptionIDLapseDate>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[LapseTrans]') AND name = N'<NonClusterIndx, GrantOptionIDLapseDate>')
CREATE NONCLUSTERED INDEX [<NonClusterIndx, GrantOptionIDLapseDate>] ON [dbo].[LapseTrans]
(
	[GrantLegID] ASC
)
INCLUDE([GrantOptionID],[LapseDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LapseTrans_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[LapseTrans]'))
ALTER TABLE [dbo].[LapseTrans]  WITH CHECK ADD  CONSTRAINT [FK_LapseTrans_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LapseTrans_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[LapseTrans]'))
ALTER TABLE [dbo].[LapseTrans] CHECK CONSTRAINT [FK_LapseTrans_EmployeeMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LapseTrans_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[LapseTrans]'))
ALTER TABLE [dbo].[LapseTrans]  WITH CHECK ADD  CONSTRAINT [FK_LapseTrans_GrantLeg] FOREIGN KEY([GrantLegSerialNumber])
REFERENCES [dbo].[GrantLeg] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_LapseTrans_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[LapseTrans]'))
ALTER TABLE [dbo].[LapseTrans] CHECK CONSTRAINT [FK_LapseTrans_GrantLeg]
GO
