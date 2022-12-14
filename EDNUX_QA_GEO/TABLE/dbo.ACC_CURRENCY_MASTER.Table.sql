/****** Object:  Table [dbo].[ACC_CURRENCY_MASTER]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACC_CURRENCY_MASTER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACC_CURRENCY_MASTER](
	[CRMID] [int] IDENTITY(1,1) NOT NULL,
	[CURRENCY_NAME] [varchar](200) NULL,
	[CURRENCY_ALIAS] [nvarchar](150) NULL,
	[IS_DEFAULT] [bit] NULL,
	[IS_DELETED] [bit] NOT NULL,
	[CREATED_BY] [int] NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [int] NOT NULL,
	[UPDATED_ON] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CRMID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CURRENCY_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[CURRENCY_ALIAS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ACC_CURRE__IS_DE__282F8F70]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ACC_CURRENCY_MASTER] ADD  DEFAULT ((0)) FOR [IS_DELETED]
END
GO
