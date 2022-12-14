/****** Object:  Table [dbo].[ShSplit]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShSplit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ShSplit](
	[SplitId] [varchar](60) NOT NULL,
	[Note] [varchar](100) NOT NULL,
	[RatioMultiplier] [numeric](18, 0) NOT NULL,
	[RatioDivisor] [numeric](18, 0) NOT NULL,
	[SplitDate] [datetime] NOT NULL,
	[SplitFactor] [numeric](18, 2) NULL,
	[ApplicableFor] [varchar](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Action] [char](1) NULL,
 CONSTRAINT [PK_ShSplit] PRIMARY KEY CLUSTERED 
(
	[SplitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
