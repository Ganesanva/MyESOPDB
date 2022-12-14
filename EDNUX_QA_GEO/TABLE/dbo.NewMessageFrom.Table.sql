/****** Object:  Table [dbo].[NewMessageFrom]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NewMessageFrom]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NewMessageFrom](
	[MessageID] [numeric](18, 0) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[MessageDate] [datetime] NULL,
	[Subject] [varchar](250) NULL,
	[Description] [varchar](4000) NULL,
	[ReadDateTime] [datetime] NULL,
	[CategoryID] [numeric](18, 0) NOT NULL,
	[IsReplySent] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[IsDeleted] [char](1) NULL,
 CONSTRAINT [PK_NewMessageFrom] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NewMessageFrom_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[NewMessageFrom]'))
ALTER TABLE [dbo].[NewMessageFrom]  WITH CHECK ADD  CONSTRAINT [FK_NewMessageFrom_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_NewMessageFrom_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[NewMessageFrom]'))
ALTER TABLE [dbo].[NewMessageFrom] CHECK CONSTRAINT [FK_NewMessageFrom_EmployeeMaster]
GO
