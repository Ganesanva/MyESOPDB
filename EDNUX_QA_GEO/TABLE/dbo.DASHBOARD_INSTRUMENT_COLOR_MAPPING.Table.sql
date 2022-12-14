/****** Object:  Table [dbo].[DASHBOARD_INSTRUMENT_COLOR_MAPPING]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DASHBOARD_INSTRUMENT_COLOR_MAPPING]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DASHBOARD_INSTRUMENT_COLOR_MAPPING](
	[INST_COLOR_MAPP_ID] [int] IDENTITY(1,1) NOT NULL,
	[MIT_ID] [int] NULL,
	[BackgroundColor] [nvarchar](100) NULL,
	[HoverBackgroundColor] [nvarchar](100) NULL,
	[Label] [nvarchar](100) NULL,
	[DisplayOrder] [int] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[INST_COLOR_MAPP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
