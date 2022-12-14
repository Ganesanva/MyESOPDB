/****** Object:  Table [dbo].[PasswordHistory]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PasswordHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PasswordHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[LastUpdatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL
) ON [PRIMARY]
END
GO
