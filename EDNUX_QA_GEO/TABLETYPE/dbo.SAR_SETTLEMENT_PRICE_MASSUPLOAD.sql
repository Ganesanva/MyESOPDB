/****** Object:  UserDefinedTableType [dbo].[SAR_SETTLEMENT_PRICE_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SAR_SETTLEMENT_PRICE_MASSUPLOAD]
GO
/****** Object:  UserDefinedTableType [dbo].[SAR_SETTLEMENT_PRICE_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SAR_SETTLEMENT_PRICE_MASSUPLOAD] AS TABLE(
	[SCHEME_ID] [nvarchar](100) NULL,
	[GRANTREGISTRATION_ID] [nvarchar](100) NULL,
	[SAR_PRICE] [nvarchar](50) NULL,
	[INSTRUMENT_NAME] [nvarchar](200) NULL
)
GO
