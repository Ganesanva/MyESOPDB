/****** Object:  Table [dbo].[SentExercised]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SentExercised]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SentExercised](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExNo] [int] NULL,
	[ExId] [int] NULL,
	[TrancheName] [varchar](100) NULL,
	[SentDate] [datetime] NULL,
	[CompanyName] [varchar](100) NULL,
	[CashlessType] [char](2) NULL,
	[UniqueId] [varchar](50) NULL,
	[ExerciseDate] [datetime] NULL,
	[LastInsertedBy] [varchar](75) NULL,
	[MIT_ID] [int] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__SentExerc__MIT_I__30EE274C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SentExercised] ADD  DEFAULT ((1)) FOR [MIT_ID]
END
GO
