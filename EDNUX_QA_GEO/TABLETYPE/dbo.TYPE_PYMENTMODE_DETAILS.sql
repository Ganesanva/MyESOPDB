/****** Object:  UserDefinedTableType [dbo].[TYPE_PYMENTMODE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_PYMENTMODE_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_PYMENTMODE_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_PYMENTMODE_DETAILS] AS TABLE(
	[LOGIN_ID] [nvarchar](100) NULL,
	[MIT_ID] [bigint] NULL,
	[PAYMENTTYPE] [nvarchar](max) NULL,
	[RESIDENTTYPE] [nvarchar](max) NULL,
	[GRANT_DATE] [datetime] NULL,
	[VESTING_DATE] [datetime] NULL,
	[EXERCISE_DATE] [datetime] NULL
)
GO
