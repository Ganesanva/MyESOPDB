/****** Object:  UserDefinedTableType [dbo].[TYPE_EMPLOYEE_DATA_ENTITY]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_EMPLOYEE_DATA_ENTITY]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_EMPLOYEE_DATA_ENTITY]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_EMPLOYEE_DATA_ENTITY] AS TABLE(
	[EmployeeID] [nvarchar](50) NULL
)
GO
