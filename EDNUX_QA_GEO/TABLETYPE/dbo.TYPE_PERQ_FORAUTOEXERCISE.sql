/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_FORAUTOEXERCISE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PERQ_FORAUTOEXERCISE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_FORAUTOEXERCISE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_PERQ_FORAUTOEXERCISE] AS TABLE(
	[MIT_ID] [int] NULL,
	[EmployeeID] [varchar](50) NULL,
	[FMV] [numeric](18, 9) NULL,
	[Total_Perk_Value] [numeric](18, 9) NULL,
	[EVENT_OF_INCIDENCE] [int] NULL,
	[GRANT_DATE] [datetime] NULL,
	[VESTING_DATE] [datetime] NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[TEMP_EXERCISEID] [bigint] NULL,
	[STOCK_VALUE] [numeric](18, 9) NULL
)
GO
