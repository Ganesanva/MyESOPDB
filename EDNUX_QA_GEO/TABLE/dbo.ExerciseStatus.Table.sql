/****** Object:  Table [dbo].[ExerciseStatus]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExerciseStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExerciseStatus](
	[ExerciseStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ExcerciseNo] [int] NOT NULL,
	[SelectPayment] [smallint] NULL,
	[DetailUpdated] [smallint] NULL,
	[GenerateForm] [smallint] NULL,
	[UploadForm] [smallint] NULL,
	[AllotmentPending] [bit] NULL,
	[AutoExercise] [bit] NULL,
	[PaymentMode] [nvarchar](256) NULL,
	[UpdatedBy] [nvarchar](256) NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Table_1_IsPayment]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseStatus] ADD  CONSTRAINT [DF_Table_1_IsPayment]  DEFAULT ((0)) FOR [SelectPayment]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Table_1_IsDetailUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseStatus] ADD  CONSTRAINT [DF_Table_1_IsDetailUpdated]  DEFAULT ((0)) FOR [DetailUpdated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Table_1_IsGenerateForm]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseStatus] ADD  CONSTRAINT [DF_Table_1_IsGenerateForm]  DEFAULT ((0)) FOR [GenerateForm]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Table_1_IsUploadForm]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseStatus] ADD  CONSTRAINT [DF_Table_1_IsUploadForm]  DEFAULT ((0)) FOR [UploadForm]
END
GO
