/****** Object:  Table [dbo].[FMVSharePrices]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FMVSharePrices]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FMVSharePrices](
	[FMVPriceID] [numeric](18, 0) NOT NULL,
	[StockExchange] [char](1) NOT NULL,
	[StockExchangeCode] [varchar](max) NULL,
	[TransactionDate] [datetime] NULL,
	[OpenPrice] [numeric](18, 2) NULL,
	[HighPrice] [numeric](18, 2) NULL,
	[LowPrice] [numeric](18, 2) NULL,
	[PriceDate] [datetime] NOT NULL,
	[ClosePrice] [numeric](18, 2) NULL,
	[Volume] [numeric](18, 2) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_FMVSharePrices] PRIMARY KEY CLUSTERED 
(
	[FMVPriceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
