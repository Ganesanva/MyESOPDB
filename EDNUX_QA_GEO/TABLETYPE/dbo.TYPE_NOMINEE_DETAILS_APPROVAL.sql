/****** Object:  UserDefinedTableType [dbo].[TYPE_NOMINEE_DETAILS_APPROVAL]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_NOMINEE_DETAILS_APPROVAL]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_NOMINEE_DETAILS_APPROVAL]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_NOMINEE_DETAILS_APPROVAL] AS TABLE(
	[EmployeeID] [nvarchar](50) NULL,
	[DateofApproval] [datetime] NULL
)
GO
