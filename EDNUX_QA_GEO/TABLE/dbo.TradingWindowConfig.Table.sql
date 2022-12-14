/****** Object:  Table [dbo].[TradingWindowConfig]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TradingWindowConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TradingWindowConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FROM_DATE] [datetime] NULL,
	[TO_DATE] [datetime] NULL,
	[TRADING_TEXT] [varchar](1000) NULL,
	[SHOW_POPUP] [bit] NULL,
	[POPUP_MSG] [varchar](1000) NULL,
	[NOTE] [varchar](1000) NULL,
	[LAST_UPDATED_BY] [varchar](20) NULL,
	[LAST_UPDATED_ON] [datetime] NULL,
	[BLOCK_FOR_TRADING_YN] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
