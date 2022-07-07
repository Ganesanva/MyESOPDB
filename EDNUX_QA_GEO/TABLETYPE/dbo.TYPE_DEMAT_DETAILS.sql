/****** Object:  UserDefinedTableType [dbo].[TYPE_DEMAT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_DEMAT_DETAILS]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_DEMAT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_DEMAT_DETAILS] AS TABLE(
	[EmployeeDematId] [bigint] NULL,
	[EmployeeID] [varchar](20) NULL,
	[Validate] [bit] NULL,
	[ApproveStatus] [varchar](5) NULL
)
GO
