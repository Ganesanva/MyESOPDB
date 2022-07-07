/****** Object:  Table [dbo].[EmployeeHomeBoxes]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeHomeBoxes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeHomeBoxes](
	[BoxID] [int] NOT NULL,
	[Name] [varchar](50) NULL,
	[Show] [bit] NULL,
	[Position] [varchar](10) NULL
) ON [PRIMARY]
END
GO
