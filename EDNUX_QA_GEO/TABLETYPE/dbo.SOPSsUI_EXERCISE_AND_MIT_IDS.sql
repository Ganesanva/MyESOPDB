/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_EXERCISE_AND_MIT_IDS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_EXERCISE_AND_MIT_IDS]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_EXERCISE_AND_MIT_IDS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_EXERCISE_AND_MIT_IDS] AS TABLE(
	[STEP_IDs] [nvarchar](200) NULL,
	[MIT_IDs] [nvarchar](200) NULL
)
GO
