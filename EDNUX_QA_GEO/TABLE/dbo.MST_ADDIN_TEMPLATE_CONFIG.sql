/****** Object:  Table [dbo].[MST_ADDIN_TEMPLATE_CONFIG]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_ADDIN_TEMPLATE_CONFIG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_ADDIN_TEMPLATE_CONFIG](
	[MATC_ID] [int] IDENTITY(1,1) NOT NULL,
	[CWPM_ID] [int] NOT NULL,
	[MAIP_ID] [int] NOT NULL,
	[MIT_ID] [int] NOT NULL,
	[TEMPLATE_NAME] [nvarchar](100) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MATC_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
