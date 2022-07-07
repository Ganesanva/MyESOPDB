/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_GRNAT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_GET_GRNAT_EXPIRY_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_GRNAT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_GRNAT_EXPIRY_DETAILS] AS TABLE(
	[GRANT_OPTION_ID] [nvarchar](100) NULL,
	[GRANT_LEG_ID] [nvarchar](10) NULL,
	[GRANT_VESTING_TYPE] [nvarchar](1) NULL,
	[GRANT_EXPIRY_DATE] [date] NULL
)
GO
