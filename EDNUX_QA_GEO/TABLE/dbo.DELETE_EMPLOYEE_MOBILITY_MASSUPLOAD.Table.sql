/****** Object:  Table [dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD](
	[SRNO] [bigint] IDENTITY(1,1) NOT NULL,
	[Field] [nvarchar](50) NOT NULL,
	[RecordID] [int] NULL,
	[EmployeeId] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](300) NULL,
	[Status] [nvarchar](50) NULL,
	[EntityName] [nvarchar](150) NULL,
	[FromDate] [date] NULL,
	[ToDelete] [nvarchar](50) NULL,
	[ReasonForDeletion] [nvarchar](500) NULL,
	[IsActive] [bit] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SRNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
