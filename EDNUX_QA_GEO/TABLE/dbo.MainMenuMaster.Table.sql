/****** Object:  Table [dbo].[MainMenuMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MainMenuMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MainMenuMaster](
	[MainMenuId] [numeric](18, 0) NOT NULL,
	[MainMenuName] [varchar](255) NOT NULL,
	[DefaultPage] [varchar](50) NOT NULL,
	[ScreenFor] [varchar](50) NOT NULL,
	[MenuSequence] [numeric](10, 0) NOT NULL,
	[UserTypeId] [numeric](10, 0) NULL,
	[Show] [bit] NOT NULL,
	[MENUGROUPNAME] [varchar](255) NULL,
 CONSTRAINT [PK_MainManuMaster] PRIMARY KEY CLUSTERED 
(
	[MainMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__MainMenuMa__Show__07AC1A97]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MainMenuMaster] ADD  DEFAULT ((1)) FOR [Show]
END
GO
