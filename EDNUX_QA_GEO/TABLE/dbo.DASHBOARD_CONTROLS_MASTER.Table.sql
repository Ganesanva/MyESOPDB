/****** Object:  Table [dbo].[DASHBOARD_CONTROLS_MASTER]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DASHBOARD_CONTROLS_MASTER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DASHBOARD_CONTROLS_MASTER](
	[CONTROL_MASTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[CONTROL_ID] [varchar](100) NULL,
	[WIDGET_ID] [int] NULL,
	[MIT_ID] [int] NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[WIDGET_HTML_CONTENT] [varchar](max) NULL,
	[DASHBOARD_TYPE] [int] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[WidgetSequence] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CONTROL_MASTER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__DASHBOARD__Widge__41EAC2A6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[DASHBOARD_CONTROLS_MASTER] ADD  DEFAULT ((0)) FOR [WidgetSequence]
END
GO
