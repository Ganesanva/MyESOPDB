/****** Object:  Table [dbo].[RoleMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RoleMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RoleMaster](
	[RoleId] [varchar](30) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[UserTypeId] [numeric](18, 0) NOT NULL,
	[Description] [varchar](255) NULL,
	[LastUpdatedBy] [varchar](255) NOT NULL,
	[LastUpdatedon] [datetime] NOT NULL,
 CONSTRAINT [PK_RoleMaster] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleMaster_UserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleMaster]'))
ALTER TABLE [dbo].[RoleMaster]  WITH CHECK ADD  CONSTRAINT [FK_RoleMaster_UserType] FOREIGN KEY([UserTypeId])
REFERENCES [dbo].[UserType] ([UserTypeId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RoleMaster_UserType]') AND parent_object_id = OBJECT_ID(N'[dbo].[RoleMaster]'))
ALTER TABLE [dbo].[RoleMaster] CHECK CONSTRAINT [FK_RoleMaster_UserType]
GO
