/****** Object:  UserDefinedTableType [dbo].[TYPE_PROP_VALUE_AUTO_EXE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PROP_VALUE_AUTO_EXE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PROP_VALUE_AUTO_EXE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_PROP_VALUE_AUTO_EXE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[PERQ_VALUE] [numeric](18, 9) NULL,
	[EVENTOFINCIDENCE] [int] NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[OPTION_VESTED] [numeric](18, 9) NULL,
	[FMV_VALUE] [numeric](18, 9) NULL,
	[OPTION_EXERCISED] [numeric](18, 9) NULL,
	[GRANTED_OPTIONS] [numeric](18, 9) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[TEMP_EXERCISEID] [bigint] NULL,
	[STOCK_VALUE] [numeric](18, 9) NULL
)
GO
