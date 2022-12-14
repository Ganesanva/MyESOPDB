/****** Object:  Table [dbo].[NotificationDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationDetails](
	[NTF_ID] [int] IDENTITY(1,1) NOT NULL,
	[NTF_TITLE] [nvarchar](100) NOT NULL,
	[NTF_DESCRIPTION] [nvarchar](max) NULL,
	[NTF_TYPE_ID] [int] NOT NULL,
	[NTF_ACTIVE] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
