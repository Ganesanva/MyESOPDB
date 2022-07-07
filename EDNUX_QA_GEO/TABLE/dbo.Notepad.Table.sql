/****** Object:  Table [dbo].[Notepad]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notepad]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Notepad](
	[UserId] [varchar](50) NOT NULL,
	[Text] [varchar](300) NOT NULL
) ON [PRIMARY]
END
GO
