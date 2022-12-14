/****** Object:  Table [dbo].[OnlineGrantAccMailConfigAuditTrail]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OnlineGrantAccMailConfigAuditTrail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OnlineGrantAccMailConfigAuditTrail](
	[OGAMCATID] [int] IDENTITY(1,1) NOT NULL,
	[IsReminderMail] [bit] NOT NULL,
	[DaysBefore] [varchar](5) NOT NULL,
	[IsTillLastDate] [bit] NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[LastUpdatedBy] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OGAMCATID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__OnlineGra__DaysB__0ADD8CFD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OnlineGrantAccMailConfigAuditTrail] ADD  DEFAULT ((0)) FOR [DaysBefore]
END
GO
