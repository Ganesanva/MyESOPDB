/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_DEMAT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SOPSsUI_GET_DEMAT_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[SOPSsUI_GET_DEMAT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SOPSsUI_GET_DEMAT_DETAILS] AS TABLE(
	[EXERCISE_NUMBER] [nvarchar](100) NULL,
	[PAYMENT_MODE] [nvarchar](1) NULL,
	[DEPOSITORY_NAME] [nvarchar](1) NULL,
	[DEMAT_TYPE] [nvarchar](1) NULL,
	[DEPOSITORY_PARTICIPATORY_NAME] [nvarchar](100) NULL,
	[DP_ID_NUMBER] [nvarchar](10) NULL,
	[CLIENT_ID_NUMBER] [nvarchar](20) NULL,
	[NAME_AS_PER_DP_RECORD] [nvarchar](100) NULL
)
GO
