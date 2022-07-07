/****** Object:  Table [dbo].[NonTradingDays]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NonTradingDays]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NonTradingDays](
	[NonTradDay] [datetime] NULL,
	[Exchangetype] [varchar](20) NULL,
	[Reason] [varchar](100) NULL
) ON [PRIMARY]
END
GO
