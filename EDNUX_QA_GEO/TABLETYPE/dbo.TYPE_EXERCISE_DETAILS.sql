/****** Object:  UserDefinedTableType [dbo].[TYPE_EXERCISE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_EXERCISE_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_EXERCISE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_EXERCISE_DETAILS] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[OPTION_EXERCISED] [numeric](18, 9) NULL,
	[PERQUSITEVALUE] [numeric](18, 9) NULL,
	[PERQSTPAYABLE] [numeric](18, 9) NULL,
	[SETTLMENTPRICE] [numeric](18, 9) NULL,
	[SHAREARISEAPPRVALUE] [numeric](18, 9) NULL,
	[CASHPAYOUTVALUE] [numeric](18, 9) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[EXERCISEBLEQTY] [int] NULL,
	[GRANTLEGSERIALNO] [bigint] NULL,
	[EXERCISEID] [bigint] NULL,
	[EXERCISENO] [bigint] NULL,
	[PAYMENTMODE] [bigint] NULL,
	[TEMP_TAXFLAG] [varchar](50) NULL
)
GO
