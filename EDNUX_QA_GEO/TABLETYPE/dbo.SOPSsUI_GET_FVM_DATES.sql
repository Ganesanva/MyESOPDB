/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_FVM_DATES]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_GET_FVM_DATES]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_FVM_DATES]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_FVM_DATES] AS TABLE(
	[OLD_FVM_DATE] [datetime] NULL,
	[NEW_FMV_DATE] [datetime] NULL
)
GO
