/****** Object:  Table [dbo].[Bonus]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bonus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Bonus](
	[BonusId] [varchar](60) NOT NULL,
	[Note] [varchar](100) NOT NULL,
	[RatioMultiplier] [numeric](18, 0) NOT NULL,
	[RatioDivisor] [numeric](18, 0) NOT NULL,
	[BonusGrantDate] [datetime] NOT NULL,
	[ApplicableFor] [varchar](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_Bonus] PRIMARY KEY CLUSTERED 
(
	[BonusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
