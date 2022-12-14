/****** Object:  UserDefinedTableType [dbo].[TYPE_DELETE_MOBILITY_DATA_TABLE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_DELETE_MOBILITY_DATA_TABLE]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_DELETE_MOBILITY_DATA_TABLE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_DELETE_MOBILITY_DATA_TABLE] AS TABLE(
	[Field] [varchar](50) NULL,
	[EmployeeId] [varchar](50) NULL,
	[EmployeeName] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[EntityName] [varchar](50) NULL,
	[FromDate] [varchar](50) NULL,
	[ToDelete] [varchar](50) NULL,
	[ReasonForDeletion] [varchar](50) NULL,
	[RecordID] [varchar](50) NULL
)
GO
