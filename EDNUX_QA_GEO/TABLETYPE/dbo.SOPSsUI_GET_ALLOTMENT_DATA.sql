/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_ALLOTMENT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_GET_ALLOTMENT_DATA]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_ALLOTMENT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_ALLOTMENT_DATA] AS TABLE(
	[EXERCISED_ID] [nvarchar](200) NULL,
	[ALLOTMENT_DATE] [datetime] NULL
)
GO
