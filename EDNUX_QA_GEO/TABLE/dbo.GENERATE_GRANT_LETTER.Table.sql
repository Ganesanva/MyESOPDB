/****** Object:  Table [dbo].[GENERATE_GRANT_LETTER]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GENERATE_GRANT_LETTER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GENERATE_GRANT_LETTER](
	[GRANTLETTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[TEMPLATE_NAME] [varchar](100) NULL,
	[GAMUID] [int] NULL,
	[ACTION] [int] NULL,
	[ISPROCESSD] [int] NULL,
	[ISPROCESSEDON] [datetime] NULL,
	[TEXT_MAIL_TO] [varchar](100) NULL,
	[TEXT_MAIL_CC] [varchar](100) NULL,
	[TEXT_MAIL_BCC] [varchar](100) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
	[ISATTACHMENT] [int] NULL
) ON [PRIMARY]
END
GO
