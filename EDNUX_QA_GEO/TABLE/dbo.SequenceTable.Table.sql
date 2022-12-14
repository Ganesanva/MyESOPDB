/****** Object:  Table [dbo].[SequenceTable]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SequenceTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SequenceTable](
	[Seq1] [varchar](25) NOT NULL,
	[Seq2] [varchar](20) NULL,
	[Seq3] [varchar](20) NULL,
	[Seq4] [varchar](20) NULL,
	[Seq5] [varchar](20) NULL,
	[SequenceNo] [numeric](18, 0) NOT NULL
) ON [PRIMARY]
END
GO
