/****** Object:  Table [dbo].[MST_EXERCISE_STEPS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_EXERCISE_STEPS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_EXERCISE_STEPS](
	[MES_ID] [int] IDENTITY(1,1) NOT NULL,
	[MST_EX_STEP_ID] [int] NULL,
	[TITLE] [nvarchar](200) NULL,
	[DISPLAY_NAME] [nvarchar](200) NULL,
	[IS_ACTIVE] [bit] NULL,
	[IS_SELECTED] [bit] NULL,
	[DISPLAY_SEQUENCE] [int] NULL,
	[MIT_ID] [int] NULL,
	[UPLOAD_TYPE] [nvarchar](50) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MES_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
