/****** Object:  UserDefinedTableType [dbo].[TYPE_FORTENTATIVE_SCHEME]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_FORTENTATIVE_SCHEME]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_FORTENTATIVE_SCHEME]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_FORTENTATIVE_SCHEME] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[TEMP_TAXFLAG] [varchar](50) NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[OPTION_VESTED] [numeric](18, 9) NULL,
	[GRANTED_OPTIONS] [numeric](18, 9) NULL,
	[OPTION_EXERCISED] [numeric](18, 9) NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[SCHEME_TYPE] [varchar](50) NULL,
	[EXERCISEID] [bigint] NULL
)
GO
