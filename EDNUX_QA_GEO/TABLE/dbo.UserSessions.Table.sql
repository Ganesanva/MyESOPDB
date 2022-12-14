/****** Object:  Table [dbo].[UserSessions]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserSessions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserSessions](
	[UserId] [varchar](20) NOT NULL,
	[CookieName] [nvarchar](500) NOT NULL,
	[ExpireOn] [datetime] NOT NULL,
	[Jwt_Token] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
