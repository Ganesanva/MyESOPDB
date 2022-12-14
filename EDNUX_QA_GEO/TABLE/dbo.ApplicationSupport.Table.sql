/****** Object:  Table [dbo].[ApplicationSupport]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationSupport]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ApplicationSupport](
	[Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[Cash] [varchar](50) NULL,
	[ISIN] [varchar](50) NULL,
	[ISNonTradingDay] [varchar](1) NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Applicati__ISNon__795DFB40]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ApplicationSupport] ADD  DEFAULT ('N') FOR [ISNonTradingDay]
END
GO
