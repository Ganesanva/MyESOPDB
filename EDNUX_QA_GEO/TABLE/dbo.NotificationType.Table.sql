/****** Object:  Table [dbo].[NotificationType]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationType](
	[NTF_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
	[NTF_TYPE] [varchar](50) NOT NULL,
	[IsActive] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
