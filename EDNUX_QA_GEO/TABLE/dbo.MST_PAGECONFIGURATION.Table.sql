/****** Object:  Table [dbo].[MST_PAGECONFIGURATION]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MST_PAGECONFIGURATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MST_PAGECONFIGURATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DISPLAYMESSAGEON] [nvarchar](100) NOT NULL,
	[PAGENAME] [nvarchar](100) NULL,
	[SECTIONNAME] [nvarchar](100) NOT NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
