/****** Object:  Table [dbo].[WidgetQuicklinks]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WidgetQuicklinks]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WidgetQuicklinks](
	[QID] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
	[URL] [nvarchar](max) NULL,
	[Widget_Sequence] [int] NULL,
	[ACTIVE] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
