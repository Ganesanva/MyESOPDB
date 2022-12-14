/****** Object:  Table [dbo].[NotificationSchedule]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificationSchedule]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NotificationSchedule](
	[NTF_SCH_ID] [int] IDENTITY(1,1) NOT NULL,
	[MIT_NTF_ID] [int] NOT NULL,
	[NTF_EVT_ID] [int] NOT NULL,
	[NTF_SCH_ON_DAYS] [numeric](18, 0) NULL,
	[NTF_EVT_START_DATE] [datetime] NULL,
	[NTF_EVT_END_DATE] [datetime] NULL,
	[NTF_SCH_FREQUENCE] [nvarchar](50) NULL,
	[CREATED_BY] [nvarchar](100) NOT NULL,
	[CREATED_ON] [datetime] NOT NULL,
	[UPDATED_BY] [nvarchar](100) NULL,
	[UPDATED_ON] [datetime] NULL
) ON [PRIMARY]
END
GO
