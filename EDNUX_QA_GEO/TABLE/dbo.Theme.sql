/****** Object:  Table [dbo].[Theme]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Theme]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Theme](
	[ThemeID] [int] IDENTITY(1,1) NOT NULL,
	[ThemeName] [varchar](50) NULL,
	[Name] [varchar](50) NULL
) ON [PRIMARY]
END
GO
