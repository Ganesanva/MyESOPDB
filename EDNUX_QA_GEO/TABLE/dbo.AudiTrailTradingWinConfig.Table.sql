/****** Object:  Table [dbo].[AudiTrailTradingWinConfig]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AudiTrailTradingWinConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AudiTrailTradingWinConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [varchar](1000) NULL,
	[COLUMN_NAME] [varchar](20) NULL,
	[CURRENT_VALUE] [varchar](1000) NULL,
	[PREVIOUS_VALUE] [varchar](1000) NULL,
	[LAST_UPDATED_BY] [varchar](20) NULL,
	[LAST_UPDATED_ON] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
