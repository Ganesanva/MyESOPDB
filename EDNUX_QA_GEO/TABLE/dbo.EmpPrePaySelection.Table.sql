/****** Object:  Table [dbo].[EmpPrePaySelection]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmpPrePaySelection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmpPrePaySelection](
	[EPPS_ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NULL,
	[ExercisedQuantity] [numeric](18, 0) NULL,
	[ExercisePrice] [numeric](18, 2) NULL,
	[EmployeeID] [varchar](20) NULL,
	[ExercisableQuantity] [numeric](18, 0) NULL,
	[GrantLegId] [numeric](18, 0) NULL,
	[PaymentMode] [bigint] NULL,
	[MIT_ID] [int] NULL,
	[Is_AutoExercised] [tinyint] NULL,
	[AutoExercisedDate] [datetime] NULL,
	[ExerciseAmountPayable] [numeric](18, 6) NULL,
	[TentativeFMVPrice] [numeric](18, 6) NULL,
	[TentativePerqstValue] [numeric](18, 6) NULL,
	[TentativePerqstPayable] [numeric](18, 6) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[CREATEDBY] [varchar](20) NULL,
	[CREATEDON] [datetime] NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmpPrePay__Is_Au__4B6D135E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmpPrePaySelection] ADD  DEFAULT ('0') FOR [Is_AutoExercised]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmpPrePay__Exerc__4C613797]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmpPrePaySelection] ADD  DEFAULT ((0)) FOR [ExerciseAmountPayable]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmpPrePay__Tenta__4D555BD0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmpPrePaySelection] ADD  DEFAULT ((0)) FOR [TentativeFMVPrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmpPrePay__Tenta__4E498009]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmpPrePaySelection] ADD  DEFAULT (NULL) FOR [TentativePerqstValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__EmpPrePay__Tenta__4F3DA442]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EmpPrePaySelection] ADD  DEFAULT ((0)) FOR [TentativePerqstPayable]
END
GO
