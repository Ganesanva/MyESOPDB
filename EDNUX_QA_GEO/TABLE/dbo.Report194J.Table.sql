/****** Object:  Table [dbo].[Report194J]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Report194J]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Report194J](
	[DeducteeSerialNo] [int] IDENTITY(1,1) NOT NULL,
	[DeducteeName] [varchar](100) NOT NULL,
	[DeducteePAN] [varchar](15) NOT NULL,
	[DeducteeAddress] [varchar](500) NOT NULL,
	[DeducteePIN] [numeric](10, 0) NULL,
	[VendorID] [int] NULL,
	[AmtPaidCreaditedID] [int] NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[DeducteeSerialNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
