/****** Object:  Table [dbo].[ScreenMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScreenMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ScreenMaster](
	[ScreenId] [numeric](18, 0) NOT NULL,
	[MainMenuId] [numeric](18, 0) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[ScreenURL] [varchar](255) NOT NULL,
	[MenuSequence] [numeric](10, 0) NOT NULL,
	[UserTypeId] [numeric](10, 0) NULL,
 CONSTRAINT [PK_ScreenMaster] PRIMARY KEY CLUSTERED 
(
	[ScreenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [CK_ScreenMaster_Insert] UNIQUE NONCLUSTERED 
(
	[MainMenuId] ASC,
	[Name] ASC,
	[ScreenURL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenMaster_MainManuMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenMaster]'))
ALTER TABLE [dbo].[ScreenMaster]  WITH CHECK ADD  CONSTRAINT [FK_ScreenMaster_MainManuMaster] FOREIGN KEY([MainMenuId])
REFERENCES [dbo].[MainMenuMaster] ([MainMenuId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScreenMaster_MainManuMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScreenMaster]'))
ALTER TABLE [dbo].[ScreenMaster] CHECK CONSTRAINT [FK_ScreenMaster_MainManuMaster]
GO
