/****** Object:  UserDefinedTableType [dbo].[TRACK_EMP_MOVE_UPLOAD_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TRACK_EMP_MOVE_UPLOAD_TYPE]
GO
/****** Object:  UserDefinedTableType [dbo].[TRACK_EMP_MOVE_UPLOAD_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TRACK_EMP_MOVE_UPLOAD_TYPE] AS TABLE(
	[Field] [varchar](200) NULL,
	[EmployeeId] [varchar](200) NULL,
	[EmployeeName] [varchar](200) NULL,
	[Status] [varchar](200) NULL,
	[CurrentDetails] [varchar](200) NULL,
	[FromDate] [date] NULL,
	[Moved To] [varchar](200) NULL,
	[From Date of Movement] [date] NULL,
	[IsError] [bit] NULL,
	[ErrorMessage] [nvarchar](1000) NULL
)
GO
