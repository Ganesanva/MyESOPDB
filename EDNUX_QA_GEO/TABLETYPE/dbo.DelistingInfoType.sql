/****** Object:  UserDefinedTableType [dbo].[DelistingInfoType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[DelistingInfoType]
GO
/****** Object:  UserDefinedTableType [dbo].[DelistingInfoType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[DelistingInfoType] AS TABLE(
	[LstDocDelistingID] [int] NULL,
	[StockExchangesName] [nvarchar](500) NULL,
	[DelistingApprovalDate] [nvarchar](500) NULL,
	[DeleteStatus] [int] NULL
)
GO
