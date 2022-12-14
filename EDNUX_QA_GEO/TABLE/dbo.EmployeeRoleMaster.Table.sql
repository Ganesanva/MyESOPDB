/****** Object:  Table [dbo].[EmployeeRoleMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeRoleMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeRoleMaster](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[URL] [varchar](150) NULL,
	[Show] [varchar](20) NULL,
	[MainMenuID] [int] NULL,
	[DisplayAs] [varchar](200) NULL,
	[ViewOnDashboard] [bit] NULL
) ON [PRIMARY]
END
GO
