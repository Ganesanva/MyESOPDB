/****** Object:  Table [dbo].[TransferedBalance]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransferedBalance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransferedBalance](
	[TrId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TrGrantlegSerialNo] [numeric](18, 0) NOT NULL,
	[TrGrantOptionId] [varchar](100) NULL,
	[TrGrantLegId] [varchar](20) NOT NULL,
	[TrBalance] [varchar](20) NULL,
	[TrCounter] [numeric](18, 0) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
