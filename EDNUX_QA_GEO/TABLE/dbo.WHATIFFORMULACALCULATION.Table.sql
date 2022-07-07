/****** Object:  Table [dbo].[WHATIFFORMULACALCULATION]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WHATIFFORMULACALCULATION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WHATIFFORMULACALCULATION](
	[MITID] [int] NULL,
	[NUMBEROFEQUISHARE] [nvarchar](200) NULL,
	[MARKETPRICE] [nvarchar](200) NULL,
	[FAIRMARKETVALUE] [nvarchar](200) NULL,
	[GAINPRETAX] [nvarchar](200) NULL,
	[EXERCISEAMOUNT] [nvarchar](200) NULL,
	[PERQUISITETAX] [nvarchar](200) NULL,
	[TOTALOPTIONPRICE] [nvarchar](200) NULL,
	[NETBENEFIT] [nvarchar](200) NULL,
	[TIMETOEXPIRY] [nvarchar](200) NULL
) ON [PRIMARY]
END
GO
