/****** Object:  Table [dbo].[UserSecurityQuestion]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserSecurityQuestion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserSecurityQuestion](
	[UserId] [varchar](20) NOT NULL,
	[SecurityQuestionId] [numeric](18, 0) NOT NULL,
	[SecurityAnswer] [varchar](255) NOT NULL,
	[IsAuthenticationModeSet] [bit] NOT NULL,
	[AuthenticationModeID] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[SecurityQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__UserSecur__IsAut__76C185B7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserSecurityQuestion] ADD  DEFAULT ((0)) FOR [IsAuthenticationModeSet]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__UserSecur__Authe__77B5A9F0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserSecurityQuestion] ADD  DEFAULT ((0)) FOR [AuthenticationModeID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserSecurityQuestion_SecurityQuestionMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserSecurityQuestion]'))
ALTER TABLE [dbo].[UserSecurityQuestion]  WITH CHECK ADD  CONSTRAINT [FK_UserSecurityQuestion_SecurityQuestionMaster] FOREIGN KEY([SecurityQuestionId])
REFERENCES [dbo].[SecurityQuestionMaster] ([SecurityQuestionId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserSecurityQuestion_SecurityQuestionMaster]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserSecurityQuestion]'))
ALTER TABLE [dbo].[UserSecurityQuestion] CHECK CONSTRAINT [FK_UserSecurityQuestion_SecurityQuestionMaster]
GO
