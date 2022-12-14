/****** Object:  Table [dbo].[ApprovedAccleratedVesting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApprovedAccleratedVesting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ApprovedAccleratedVesting](
	[ApproveAcceleratedVestingId] [numeric](18, 0) NOT NULL,
	[LegId] [numeric](18, 0) NOT NULL,
	[GrantOptionId] [varchar](100) NOT NULL,
	[AcceleratedVestingId] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_ApproveAccleratedVesting] PRIMARY KEY CLUSTERED 
(
	[ApproveAcceleratedVestingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ApproveAccleratedVesting_AcceleratedVesting]') AND parent_object_id = OBJECT_ID(N'[dbo].[ApprovedAccleratedVesting]'))
ALTER TABLE [dbo].[ApprovedAccleratedVesting]  WITH NOCHECK ADD  CONSTRAINT [FK_ApproveAccleratedVesting_AcceleratedVesting] FOREIGN KEY([AcceleratedVestingId])
REFERENCES [dbo].[AcceleratedVesting] ([AcceleratedVestingId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ApproveAccleratedVesting_AcceleratedVesting]') AND parent_object_id = OBJECT_ID(N'[dbo].[ApprovedAccleratedVesting]'))
ALTER TABLE [dbo].[ApprovedAccleratedVesting] CHECK CONSTRAINT [FK_ApproveAccleratedVesting_AcceleratedVesting]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ApproveAccleratedVesting_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[ApprovedAccleratedVesting]'))
ALTER TABLE [dbo].[ApprovedAccleratedVesting]  WITH NOCHECK ADD  CONSTRAINT [FK_ApproveAccleratedVesting_GrantLeg] FOREIGN KEY([LegId])
REFERENCES [dbo].[GrantLeg] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ApproveAccleratedVesting_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[ApprovedAccleratedVesting]'))
ALTER TABLE [dbo].[ApprovedAccleratedVesting] CHECK CONSTRAINT [FK_ApproveAccleratedVesting_GrantLeg]
GO
