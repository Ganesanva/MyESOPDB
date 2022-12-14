/****** Object:  Table [dbo].[NewMessageFrom_back]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NewMessageFrom_back]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NewMessageFrom_back](
	[MessageID] [numeric](18, 0) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[MessageDate] [datetime] NULL,
	[Subject] [varchar](50) NULL,
	[Description] [varchar](4000) NULL,
	[ReadDateTime] [datetime] NULL,
	[CategoryID] [numeric](18, 0) NOT NULL,
	[IsReplySent] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[IsDeleted] [char](1) NULL
) ON [PRIMARY]
END
GO
