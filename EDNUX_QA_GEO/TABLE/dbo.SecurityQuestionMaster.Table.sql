/****** Object:  Table [dbo].[SecurityQuestionMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SecurityQuestionMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SecurityQuestionMaster](
	[SecurityQuestionId] [numeric](18, 0) NOT NULL,
	[Question] [varchar](255) NOT NULL,
 CONSTRAINT [PK_SecurityQuestionMaster] PRIMARY KEY CLUSTERED 
(
	[SecurityQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
