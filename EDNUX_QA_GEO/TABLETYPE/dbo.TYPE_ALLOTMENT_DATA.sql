/****** Object:  UserDefinedTableType [dbo].[TYPE_ALLOTMENT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_ALLOTMENT_DATA]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_ALLOTMENT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_ALLOTMENT_DATA] AS TABLE(
	[EXERCISE_NO] [nvarchar](100) NULL,
	[EXERCISE_ID] [nvarchar](100) NULL,
	[EMPLOYEE_ID] [nvarchar](100) NULL,
	[GRANT_REG_ID] [nvarchar](200) NULL,
	[GRANT_DATE] [datetime] NULL,
	[GRANT_OPTION_ID] [nvarchar](100) NULL,
	[GRANT_LEG_ID] [nvarchar](10) NULL
)
GO
