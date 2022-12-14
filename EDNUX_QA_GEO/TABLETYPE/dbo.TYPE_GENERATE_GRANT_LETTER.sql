/****** Object:  UserDefinedTableType [dbo].[TYPE_GENERATE_GRANT_LETTER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP TYPE IF EXISTS [dbo].[TYPE_GENERATE_GRANT_LETTER]
GO
/****** Object:  UserDefinedTableType [dbo].[TYPE_GENERATE_GRANT_LETTER]    Script Date: 7/6/2022 1:40:54 PM ******/
CREATE TYPE [dbo].[TYPE_GENERATE_GRANT_LETTER] AS TABLE(
	[TEMPLATE_NAME] [varchar](50) NULL,
	[GAMUID] [int] NULL,
	[ACTION] [int] NULL,
	[ISPROCESSD] [int] NULL,
	[ISPROCESSEDON] [datetime] NULL,
	[TEXT_MAIL_TO] [varchar](250) NULL,
	[TEXT_MAIL_CC] [varchar](500) NULL,
	[TEXT_MAIL_BCC] [varchar](250) NULL,
	[CREATED_BY] [nvarchar](100) NULL,
	[CREATED_ON] [datetime] NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL,
	[ISATTACHMENT] [int] NULL
)
GO
