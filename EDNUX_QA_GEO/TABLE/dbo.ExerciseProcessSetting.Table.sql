/****** Object:  Table [dbo].[ExerciseProcessSetting]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ExerciseProcessSetting]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ExerciseProcessSetting](
	[ExerciseProcessId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[PaymentMode] [char](1) NOT NULL,
	[TrustRecOfEXeForm] [char](1) NULL,
	[NTrustsRecOfEXeForm] [char](1) NULL,
	[TrustDepositOfPayInstrument] [char](1) NULL,
	[NTrustDepositOfPayInstrument] [char](1) NULL,
	[TrustPayRecConfirmation] [char](1) NULL,
	[NTrustPayRecConfirmation] [char](1) NULL,
	[TrustGenShareTransList] [char](1) NULL,
	[NTrustGenShareTransList] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[MIT_ID] [int] NOT NULL,
 CONSTRAINT [PK_ ExerciseProcessSetting] PRIMARY KEY CLUSTERED 
(
	[ExerciseProcessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__Trust__740F363E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [TrustRecOfEXeForm]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__NTrus__75035A77]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [NTrustsRecOfEXeForm]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__Trust__75F77EB0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [TrustDepositOfPayInstrument]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__NTrus__76EBA2E9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [NTrustDepositOfPayInstrument]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__Trust__77DFC722]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [TrustPayRecConfirmation]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__NTrus__78D3EB5B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [NTrustPayRecConfirmation]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__Trust__79C80F94]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [TrustGenShareTransList]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__NTrus__7ABC33CD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ('N') FOR [NTrustGenShareTransList]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__ExerciseP__MIT_I__2F05DEDA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ExerciseProcessSetting] ADD  DEFAULT ((1)) FOR [MIT_ID]
END
GO
