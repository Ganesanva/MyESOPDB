/****** Object:  UserDefinedTableType [dbo].[TYPE_CASHPAYOUT_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_CASHPAYOUT_VALUE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_CASHPAYOUT_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_CASHPAYOUT_VALUE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[SETTLEMENT_PRICE] [numeric](18, 9) NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[SCHEME_ID] [nvarchar](100) NULL,
	[FMV_VALUE] [numeric](18, 9) NULL,
	[FACE_VALUE] [numeric](18, 9) NULL,
	[SARS_EXERCISED] [numeric](18, 9) NULL,
	[SHARES_ARISINGOUTOF_APPR] [numeric](18, 9) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GrantLegId] [varchar](100) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[TEMP_EXERCISEID] [bigint] NULL
)
GO
