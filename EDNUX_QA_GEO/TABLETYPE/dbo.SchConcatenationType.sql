/****** Object:  UserDefinedTableType [dbo].[SchConcatenationType]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[SchConcatenationType]
GO
/****** Object:  UserDefinedTableType [dbo].[SchConcatenationType]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[SchConcatenationType] AS TABLE(
	[SchemeId] [varchar](50) NULL,
	[SchemeTitle] [varchar](50) NULL,
	[UniqueCode] [nvarchar](500) NULL,
	[Name] [nvarchar](500) NULL,
	[SchConcatentionID] [int] NULL,
	[DeleteStatus] [int] NULL
)
GO
