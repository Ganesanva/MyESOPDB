/****** Object:  Table [dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD_AUDIT]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD_AUDIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DELETE_EMPLOYEE_MOBILITY_MASSUPLOAD_AUDIT](
	[SrID] [bigint] IDENTITY(1,1) NOT NULL,
	[SrNo] [bigint] NULL,
	[Field] [nvarchar](50) NOT NULL,
	[EmployeeId] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[CurrentDetails] [nvarchar](50) NULL,
	[FromDate] [date] NULL,
	[MoveTo] [nvarchar](150) NULL,
	[FromDateOfMovement] [date] NULL,
	[ISERROR] [bit] NULL,
	[ErrorMessage] [varchar](200) NULL,
	[ToDelete] [char](1) NULL,
	[ReasonForDeletion] [varchar](200) NULL,
	[Created_By] [nvarchar](100) NOT NULL,
	[Created_On] [datetime] NOT NULL,
	[Updated_By] [nvarchar](100) NULL,
	[Updated_On] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
