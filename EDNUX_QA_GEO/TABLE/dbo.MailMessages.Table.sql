/****** Object:  Table [dbo].[MailMessages]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MailMessages]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MailMessages](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Formats] [varchar](100) NULL,
	[MailSubject] [varchar](500) NULL,
	[MailBody] [varchar](max) NULL,
 CONSTRAINT [PK_MailAlertMessages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
