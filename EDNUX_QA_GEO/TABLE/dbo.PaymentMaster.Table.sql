/****** Object:  Table [dbo].[PaymentMaster]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PayModeName] [varchar](20) NOT NULL,
	[Description] [varchar](20) NULL,
	[PaymentMode] [char](1) NOT NULL,
	[IsEnable] [char](1) NULL,
	[ConfirmPaymentMailSent] [char](1) NULL,
	[Exerciseform_Submit] [char](1) NULL,
	[Exerciseform_Submit_SndMail] [char](1) NULL,
	[ExerciseReversal_SendMail] [char](1) NULL,
	[Allow_Without_PT] [char](1) NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[Parentid] [int] NULL,
	[seqno] [int] NULL,
	[IsBankAccNoActivated] [bit] NOT NULL,
	[IsTypeOfBnkAccActivated] [bit] NOT NULL,
	[IsBnkBrnhAddActivated] [bit] NOT NULL,
UNIQUE NONCLUSTERED 
(
	[PaymentMode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__IsEna__503BEA1C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [IsEnable]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Confi__51300E55]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [ConfirmPaymentMailSent]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Exerc__5224328E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [Exerciseform_Submit]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Exerc__531856C7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [Exerciseform_Submit_SndMail]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Exerc__540C7B00]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [ExerciseReversal_SendMail]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Allow__55009F39]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('N') FOR [Allow_Without_PT]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Creat__55F4C372]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('Admin') FOR [CreatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Creat__56E8E7AB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT (getdate()) FOR [CreatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__LastU__57DD0BE4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ('Admin') FOR [LastUpdatedBy]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__LastU__58D1301D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT (getdate()) FOR [LastUpdatedOn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__Paren__59C55456]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ((0)) FOR [Parentid]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__IsBan__7F80E8EA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ((0)) FOR [IsBankAccNoActivated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__IsTyp__00750D23]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ((0)) FOR [IsTypeOfBnkAccActivated]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__PaymentMa__IsBnk__0169315C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentMaster] ADD  DEFAULT ((0)) FOR [IsBnkBrnhAddActivated]
END
GO
/****** Object:  Trigger [dbo].[TrigUpdatePaymentMaster]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TrigUpdatePaymentMaster]'))
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author :	Chetan Chopkar
-- Create date : 10 June 2013
-- Description : For manits id 0004362, 0004363
-- Implement code for Mahindra customization on 21 Aug 2013
-- =============================================

CREATE TRIGGER [dbo].[TrigUpdatePaymentMaster]
   ON  [dbo].[PaymentMaster]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	DECLARE 
	@OldIsEnable CHAR(1),
	@NewIsEnable CHAR(1),
	@OldExerciseFormSubmit CHAR(1),	
	@NewExerciseFormSubmit CHAR(1),
	@PaymentMode CHAR(1),
	@NewLastUpdatedBy VARCHAR(50),
	@Id INT
	
	SELECT @NewIsEnable = IsEnable, @Id = Id FROM INSERTED 
	SELECT @OldIsEnable = IsEnable FROM DELETED 
	
	IF (@NewIsEnable <> @OldIsEnable)
	BEGIN
		UPDATE residentialpaymentmode SET isActivated = @NewIsEnable, LastUpdatedBy =''Admin'', LastUpdatedOn = GETDATE() 
		WHERE PaymentMaster_Id IN (SELECT id FROM PaymentMaster WHERE Parentid = @Id)
				
		UPDATE PaymentMaster Set Exerciseform_Submit = @NewIsEnable WHERE (Parentid = @Id) OR (Id = @Id)			
	END
	
	-- Added for Mahindra customization
	SELECT @NewExerciseFormSubmit = Exerciseform_Submit, @PaymentMode = PaymentMode, @NewLastUpdatedBy = LastUpdatedBy, @Id = Id FROM INSERTED 
	SELECT @OldExerciseFormSubmit = Exerciseform_Submit FROM DELETED 
	
	IF (@NewExerciseFormSubmit <> @OldExerciseFormSubmit)
	BEGIN
		IF (@NewExerciseFormSubmit = ''Y'')
			BEGIN
				UPDATE ExerciseProcessSetting SET TrustRecOfEXeForm = ''Y'',	NTrustsRecOfEXeForm = ''Y'',
				LastUpdatedBy = @NewLastUpdatedBy, LastUpdatedOn = GETDATE()  WHERE PaymentMode = @PaymentMode
			END
		ELSE
			BEGIN
				UPDATE ExerciseProcessSetting SET TrustRecOfEXeForm = ''N'',	NTrustsRecOfEXeForm = ''N'',
				LastUpdatedBy = @NewLastUpdatedBy, LastUpdatedOn = GETDATE() WHERE PaymentMode = @PaymentMode
			END		
	END
	
END
' 
GO
ALTER TABLE [dbo].[PaymentMaster] ENABLE TRIGGER [TrigUpdatePaymentMaster]
GO
