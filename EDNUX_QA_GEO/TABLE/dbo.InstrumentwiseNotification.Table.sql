/****** Object:  Table [dbo].[InstrumentwiseNotification]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstrumentwiseNotification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[InstrumentwiseNotification](
	[MIT_NTF_ID] [int] IDENTITY(1,1) NOT NULL,
	[NTF_ID] [int] NOT NULL,
	[MIT_ID] [int] NULL,
	[IS_ACTIVE] [tinyint] NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
