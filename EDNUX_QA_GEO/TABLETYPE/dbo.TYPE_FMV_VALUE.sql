/****** Object:  UserDefinedTableType [dbo].[TYPE_FMV_VALUE]    Script Date: 7/8/2022 3:00:42 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_FMV_VALUE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_FMV_VALUE]    Script Date: 7/8/2022 3:00:42 PM ******/
CREATE TYPE [dbo].[TYPE_FMV_VALUE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTOPTIONID] [varchar](100) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[TEMP_TAXFLAG] [varchar](50) NULL
)
GO
