/****** Object:  UserDefinedTableType [dbo].[TYPE_SHARE_APPR_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SHARE_APPR_VALUE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SHARE_APPR_VALUE]    Script Date: 7/6/2022 1:40:55 PM ******/
CREATE TYPE [dbo].[TYPE_SHARE_APPR_VALUE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[EXERCISE_PRICE] [numeric](18, 9) NULL,
	[SCHEME_ID] [nvarchar](100) NULL,
	[GRANTOPTIONID] [nvarchar](100) NULL,
	[SAR_PRICE] [numeric](18, 9) NULL,
	[SARS_EXERCISED] [numeric](18, 9) NULL,
	[SARS_VESTED] [numeric](18, 9) NULL,
	[FACE_VALUE] [numeric](18, 9) NULL,
	[FMV_PRICE] [numeric](18, 9) NULL
)
GO
