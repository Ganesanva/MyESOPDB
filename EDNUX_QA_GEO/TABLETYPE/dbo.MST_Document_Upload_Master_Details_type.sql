/****** Object:  UserDefinedTableType [dbo].[MST_Document_Upload_Master_Details_type]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[MST_Document_Upload_Master_Details_type]
GO
/****** Object:  UserDefinedTableType [dbo].[MST_Document_Upload_Master_Details_type]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[MST_Document_Upload_Master_Details_type] AS TABLE(
	[LoginId] [nvarchar](500) NULL,
	[FilePath] [nvarchar](500) NULL
)
GO
