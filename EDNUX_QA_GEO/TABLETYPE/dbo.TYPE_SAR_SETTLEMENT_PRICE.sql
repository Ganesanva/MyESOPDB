/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_SETTLEMENT_PRICE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SAR_SETTLEMENT_PRICE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_SETTLEMENT_PRICE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SAR_SETTLEMENT_PRICE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[SCHEME_ID] [nvarchar](100) NULL,
	[GRANTOPTIONID] [nvarchar](100) NULL
)
GO
