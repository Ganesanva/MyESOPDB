/****** Object:  UserDefinedTableType [dbo].[GrpCompDetailType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[GrpCompDetailType]
GO
/****** Object:  UserDefinedTableType [dbo].[GrpCompDetailType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[GrpCompDetailType] AS TABLE(
	[CompanyName] [varchar](100) NULL,
	[IsActive] [bit] NULL,
	[GroupName] [varchar](100) NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ViewOn] [bit] NULL
)
GO
