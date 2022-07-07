/****** Object:  Table [dbo].[TRANSACTION_COST_METHOD_MASTER]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TRANSACTION_COST_METHOD_MASTER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TRANSACTION_COST_METHOD_MASTER](
	[TCMID] [int] IDENTITY(1,1) NOT NULL,
	[TRN_COST_METHOD_NAME] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[TCMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
