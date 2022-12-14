/****** Object:  Table [dbo].[UserPassword]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserPassword]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserPassword](
	[UserId] [varchar](20) NOT NULL,
	[UserPassword] [varchar](1000) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_UserPassword] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserPassword_UserMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPassword]'))
ALTER TABLE [dbo].[UserPassword]  WITH CHECK ADD  CONSTRAINT [FK_UserPassword_UserMaster] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserPassword_UserMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserPassword]'))
ALTER TABLE [dbo].[UserPassword] CHECK CONSTRAINT [FK_UserPassword_UserMaster]
GO
