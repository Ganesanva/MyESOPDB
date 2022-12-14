/****** Object:  Table [dbo].[EmployeeTravelInfo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeTravelInfo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeTravelInfo](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[employeeid] [varchar](50) NOT NULL,
	[LoginId] [varchar](20) NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NOT NULL,
	[Comments] [varchar](50) NULL,
	[Status] [char](1) NOT NULL,
	[IsDeletedYN] [char](1) NOT NULL,
	[Createdby] [varchar](50) NOT NULL,
	[Createdon] [datetime] NOT NULL,
	[LastUpdatedon] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
