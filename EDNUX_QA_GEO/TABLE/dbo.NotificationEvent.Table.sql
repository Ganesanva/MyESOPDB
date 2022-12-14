/****** Object:  Table [dbo].[NotificationEvent]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationEvent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationEvent](
	[NTF_EVT_ID] [int] IDENTITY(1,1) NOT NULL,
	[NTF_EVENT] [nvarchar](100) NOT NULL,
	[IS_ACTIVE] [tinyint] NOT NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
