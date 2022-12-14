/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_VALUE_AUTO_EXE]    Script Date: 7/8/2022 3:00:42 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PERQ_VALUE_AUTO_EXE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_VALUE_AUTO_EXE]    Script Date: 7/8/2022 3:00:42 PM ******/
CREATE TYPE [dbo].[TYPE_PERQ_VALUE_AUTO_EXE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[OPTION_VESTED] [numeric](18, 9) NULL,
	[FMV_VALUE] [numeric](18, 9) NULL,
	[OPTION_EXERCISED] [numeric](18, 9) NULL,
	[GRANTED_OPTIONS] [numeric](18, 9) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[GRANTOPTIONID] [varchar](100) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[FROM_DATE] [datetime] NULL,
	[TO_DATE] [datetime] NULL,
	[TEMP_EXERCISEID] [bigint] NULL
)
GO
