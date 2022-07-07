/****** Object:  Table [dbo].[ApplicationSupport_Employee]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationSupport_Employee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ApplicationSupport_Employee](
	[UserID] [varchar](20) NOT NULL,
	[FromDate] [char](15) NOT NULL,
	[ToDate] [char](15) NOT NULL
) ON [PRIMARY]
END
GO
