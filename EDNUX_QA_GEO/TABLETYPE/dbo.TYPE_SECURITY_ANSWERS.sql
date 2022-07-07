/****** Object:  UserDefinedTableType [dbo].[TYPE_SECURITY_ANSWERS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_SECURITY_ANSWERS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_SECURITY_ANSWERS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_SECURITY_ANSWERS] AS TABLE(
	[TSA_ID] [varchar](2) NULL,
	[TSA_SECURITY_QUESTION] [varchar](255) NULL,
	[TSA_SECURITY_ANSWER] [varchar](255) NULL
)
GO
