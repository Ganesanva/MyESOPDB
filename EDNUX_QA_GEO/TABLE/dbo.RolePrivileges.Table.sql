/****** Object:  Table [dbo].[RolePrivileges]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RolePrivileges]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RolePrivileges](
	[RolePrivilegeId] [numeric](18, 0) NOT NULL,
	[RoleId] [varchar](30) NOT NULL,
	[ScreenActionId] [numeric](18, 0) NOT NULL,
	[LastUpdatedBy] [varchar](30) NOT NULL,
	[LastUpdatedon] [datetime] NOT NULL,
 CONSTRAINT [PK_RolePrivileges] PRIMARY KEY CLUSTERED 
(
	[RolePrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePrivileges_RoleMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePrivileges]'))
ALTER TABLE [dbo].[RolePrivileges]  WITH CHECK ADD  CONSTRAINT [FK_RolePrivileges_RoleMaster] FOREIGN KEY([RoleId])
REFERENCES [dbo].[RoleMaster] ([RoleId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePrivileges_RoleMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePrivileges]'))
ALTER TABLE [dbo].[RolePrivileges] CHECK CONSTRAINT [FK_RolePrivileges_RoleMaster]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePrivileges_ScreenActions]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePrivileges]'))
ALTER TABLE [dbo].[RolePrivileges]  WITH CHECK ADD  CONSTRAINT [FK_RolePrivileges_ScreenActions] FOREIGN KEY([ScreenActionId])
REFERENCES [dbo].[ScreenActions] ([ScreenActionId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RolePrivileges_ScreenActions]') AND parent_object_id = OBJECT_ID(N'[dbo].[RolePrivileges]'))
ALTER TABLE [dbo].[RolePrivileges] CHECK CONSTRAINT [FK_RolePrivileges_ScreenActions]
GO
