/****** Object:  Table [dbo].[ScreenActions]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScreenActions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ScreenActions](
	[ScreenActionId] [numeric](18, 0) NOT NULL,
	[ScreenId] [numeric](18, 0) NOT NULL,
	[ActionId] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_ScreenActions] PRIMARY KEY CLUSTERED 
(
	[ScreenActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [CK_ScreenMaster_Action] UNIQUE NONCLUSTERED 
(
	[ScreenId] ASC,
	[ActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenActions_ActionMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenActions]'))
ALTER TABLE [dbo].[ScreenActions]  WITH CHECK ADD  CONSTRAINT [FK_ScreenActions_ActionMaster] FOREIGN KEY([ActionId])
REFERENCES [dbo].[ActionMaster] ([ActionId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenActions_ActionMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenActions]'))
ALTER TABLE [dbo].[ScreenActions] CHECK CONSTRAINT [FK_ScreenActions_ActionMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenActions_ScreenMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenActions]'))
ALTER TABLE [dbo].[ScreenActions]  WITH CHECK ADD  CONSTRAINT [FK_ScreenActions_ScreenMaster] FOREIGN KEY([ScreenId])
REFERENCES [dbo].[ScreenMaster] ([ScreenId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenActions_ScreenMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenActions]'))
ALTER TABLE [dbo].[ScreenActions] CHECK CONSTRAINT [FK_ScreenActions_ScreenMaster]
GO
