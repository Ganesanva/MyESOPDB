/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_MOBILITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_GET_MOBILITY_DATA]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_MOBILITY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_MOBILITY_DATA] AS TABLE(
	[EMPLOYEE_ID] [nvarchar](100) NULL,
	[FIELD_MASTER] [nvarchar](50) NULL,
	[DATE_OF_MOVEMENT] [date] NULL
)
GO
