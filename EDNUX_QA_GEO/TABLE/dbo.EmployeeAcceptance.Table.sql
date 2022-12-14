/****** Object:  Table [dbo].[EmployeeAcceptance]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeAcceptance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmployeeAcceptance](
	[EmpAcceptanceID] [varchar](20) NOT NULL,
	[EmployeeID] [varchar](20) NOT NULL,
	[Location] [varchar](40) NOT NULL,
	[Status] [varchar](30) NOT NULL,
	[GrantDate] [datetime] NOT NULL,
	[GrantedOption] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_EmployeeAcceptance] PRIMARY KEY CLUSTERED 
(
	[EmpAcceptanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EmployeeAcceptance]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EmployeeAcceptance]') AND name = N'IX_EmployeeAcceptance')
CREATE NONCLUSTERED INDEX [IX_EmployeeAcceptance] ON [dbo].[EmployeeAcceptance]
(
	[EmpAcceptanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeAcceptance_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeAcceptance]'))
ALTER TABLE [dbo].[EmployeeAcceptance]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeAcceptance_EmployeeMaster] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[EmployeeMaster] ([EmployeeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EmployeeAcceptance_EmployeeMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[EmployeeAcceptance]'))
ALTER TABLE [dbo].[EmployeeAcceptance] CHECK CONSTRAINT [FK_EmployeeAcceptance_EmployeeMaster]
GO
