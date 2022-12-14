/****** Object:  Table [dbo].[MenuSubMenu]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MenuSubMenu]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MenuSubMenu](
	[Menu_id] [int] IDENTITY(1,1) NOT NULL,
	[Submenu_id] [int] NULL,
	[MenuName] [nvarchar](128) NULL,
	[DisplayName] [nvarchar](128) NULL,
	[MenuUrl] [nvarchar](500) NULL,
	[MenuSequence] [int] NULL,
	[IsActive] [bit] NULL,
	[UserTypeId] [int] NULL,
	[Position] [nvarchar](50) NOT NULL,
	[IsShownOnDashboard] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__MenuSubMe__Posit__2DBD803D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MenuSubMenu] ADD  DEFAULT ('Top') FOR [Position]
END
GO
