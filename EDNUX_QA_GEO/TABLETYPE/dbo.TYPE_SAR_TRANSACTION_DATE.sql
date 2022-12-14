/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_TRANSACTION_DATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SAR_TRANSACTION_DATE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SAR_TRANSACTION_DATE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SAR_TRANSACTION_DATE] AS TABLE(
	[INSTRUMENT_ID] [bigint] NULL,
	[EMPLOYEE_ID] [varchar](50) NULL,
	[GRANTOPTIONID] [varchar](50) NULL,
	[GRANTDATE] [varchar](200) NULL,
	[VESTINGDATE] [varchar](200) NULL,
	[EXERCISE_DATE] [datetime] NULL,
	[SAR_TRANS_DATE_ID] [bigint] NULL
)
GO
