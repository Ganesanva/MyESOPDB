/****** Object:  UserDefinedTableType [dbo].[OGA_TYPE_LAST_ACC_DATE_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[OGA_TYPE_LAST_ACC_DATE_STATUS]
GO
/****** Object:  UserDefinedTableType [dbo].[OGA_TYPE_LAST_ACC_DATE_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[OGA_TYPE_LAST_ACC_DATE_STATUS] AS TABLE(
	[EMPLOYEE_ID] [nvarchar](500) NULL,
	[LETTERCODE] [nvarchar](500) NULL,
	[STATUS] [nvarchar](10) NULL,
	[DATEOFACTION] [varchar](100) NULL,
	[LASTACCTDATE] [varchar](100) NULL
)
GO
