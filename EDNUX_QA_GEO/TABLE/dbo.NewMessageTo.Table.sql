/****** Object:  Table [dbo].[NewMessageTo]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NewMessageTo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NewMessageTo](
	[MessageID] [numeric](18, 0) NOT NULL,
	[EmployeeID] [varchar](20) NULL,
	[MessageDate] [datetime] NULL,
	[Subject] [varchar](250) NULL,
	[Description] [varchar](max) NULL,
	[ReadDateTime] [datetime] NULL,
	[CategoryID] [numeric](18, 0) NOT NULL,
	[IsReplySent] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[IsDeleted] [char](1) NULL,
 CONSTRAINT [PK_NewMessageTo] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NewMessageTo_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[NewMessageTo]'))
ALTER TABLE [dbo].[NewMessageTo]  WITH CHECK ADD  CONSTRAINT [FK_NewMessageTo_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NewMessageTo_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[NewMessageTo]'))
ALTER TABLE [dbo].[NewMessageTo] CHECK CONSTRAINT [FK_NewMessageTo_EmployeeMaster]
GO
