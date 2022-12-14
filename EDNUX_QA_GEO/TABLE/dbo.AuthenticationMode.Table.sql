/****** Object:  Table [dbo].[AuthenticationMode]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AuthenticationMode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AuthenticationMode](
	[AuthenticationModeID] [tinyint] NOT NULL,
	[AuthenticationModeName] [nvarchar](50) NOT NULL,
	[AuthenticationModeDesc] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthenticationModeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
