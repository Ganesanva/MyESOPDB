/****** Object:  Table [dbo].[ListingDocDelistingInfo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingDocDelistingInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ListingDocDelistingInfo](
	[LstDocDelistingID] [int] IDENTITY(1,1) NOT NULL,
	[StockExchangesName] [nvarchar](500) NULL,
	[DelistingApprovalDate] [nvarchar](500) NULL,
	[CreatedBy] [varchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ListingDocDelistingInfo] PRIMARY KEY CLUSTERED 
(
	[LstDocDelistingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
