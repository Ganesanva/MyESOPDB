/****** Object:  UserDefinedTableType [dbo].[TYPE_GOP_ASSOCIATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_GOP_ASSOCIATION]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_GOP_ASSOCIATION]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_GOP_ASSOCIATION] AS TABLE(
	[Base Grant Option Id] [varchar](250) NULL,
	[Associated Grant Option Id] [varchar](250) NULL,
	[Association To Vest Id] [int] NULL,
	[Additional Quantity] [int] NULL,
	[Share Price As On Date Of Grant] [numeric](18, 9) NULL
)
GO
