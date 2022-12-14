/****** Object:  Table [dbo].[MenuSubMenuUI_UX]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuSubMenuUI_UX]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MenuSubMenuUI_UX](
	[Menu_id] [int] IDENTITY(1,1) NOT NULL,
	[Submenu_id] [int] NOT NULL,
	[MenuName] [varchar](100) NOT NULL,
	[DisplayName] [varchar](1000) NULL,
	[MenuUrl] [varchar](1000) NULL,
	[MenuSequence] [int] NOT NULL,
	[ISActive] [bit] NULL,
	[UserTypeId] [int] NOT NULL,
	[Position] [varchar](100) NULL,
	[IsShownOnDashboard] [bit] NULL,
	[root] [bit] NULL,
	[icon] [varchar](100) NULL,
	[bullet] [varchar](100) NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL
) ON [PRIMARY]
END
GO
