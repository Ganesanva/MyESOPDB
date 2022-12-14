/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_TAX_AUTOEXERC]    Script Date: 7/8/2022 3:00:42 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PERQ_TAX_AUTOEXERC]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PERQ_TAX_AUTOEXERC]    Script Date: 7/8/2022 3:00:42 PM ******/
CREATE TYPE [dbo].[TYPE_PERQ_TAX_AUTOEXERC] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[COUNTRY_ID] [int] NULL,
	[GRANTOPTIONID] [varchar](100) NULL,
	[TOT_DAYS] [float] NULL,
	[VESTING_DATE] [datetime] NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[FROM_DATE] [datetime] NULL,
	[TO_DATE] [datetime] NULL,
	[TEMP_EXERCISEID] [bigint] NULL,
	[STOCK_VALUE] [numeric](18, 9) NULL
)
GO
