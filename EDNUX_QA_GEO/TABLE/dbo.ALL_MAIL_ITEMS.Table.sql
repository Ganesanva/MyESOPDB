/****** Object:  Table [dbo].[ALL_MAIL_ITEMS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ALL_MAIL_ITEMS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ALL_MAIL_ITEMS](
	[SR_NO] [int] IDENTITY(1,1) NOT NULL,
	[COMPANY_NAME] [varchar](150) NULL,
	[MAIL_FOR] [varchar](500) NULL,
	[MAIL_SUBJECT] [varchar](max) NULL,
	[MAIL_BODY] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
