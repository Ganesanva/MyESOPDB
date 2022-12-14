/****** Object:  Table [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION](
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUDIT_TRI__Is_Au__5D8BC399]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION] ADD  DEFAULT ('0') FOR [Is_AutoExercised]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUDIT_TRI__Exerc__5E7FE7D2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION] ADD  DEFAULT ((0)) FOR [ExerciseAmountPayable]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUDIT_TRI__Tenta__5F740C0B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION] ADD  DEFAULT ((0)) FOR [TentativeFMVPrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUDIT_TRI__Tenta__60683044]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION] ADD  DEFAULT (NULL) FOR [TentativePerqstValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__AUDIT_TRI__Tenta__615C547D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AUDIT_TRIAL_EMPPREPAYSELECTION] ADD  DEFAULT ((0)) FOR [TentativePerqstPayable]
END
GO
