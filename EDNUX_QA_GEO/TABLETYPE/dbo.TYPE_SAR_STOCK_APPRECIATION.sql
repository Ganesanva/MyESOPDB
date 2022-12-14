/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_STOCK_APPRECIATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SAR_STOCK_APPRECIATION]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_STOCK_APPRECIATION]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SAR_STOCK_APPRECIATION] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[OPTION_VESTED] [numeric](18, 9) NULL,
	[OPTION_EXERCISED] [numeric](18, 9) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[TEMP_EXERCISEID] [bigint] NULL
)
GO
