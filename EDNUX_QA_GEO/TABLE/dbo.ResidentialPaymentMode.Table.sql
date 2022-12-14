/****** Object:  Table [dbo].[ResidentialPaymentMode]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ResidentialPaymentMode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ResidentialPaymentMode](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ResidentialType_Id] [int] NOT NULL,
	[PaymentMaster_Id] [int] NOT NULL,
	[ProcessNote] [nvarchar](max) NULL,
	[LastUpdatedBy] [varchar](100) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ExerciseFormText1] [nvarchar](max) NULL,
	[ExerciseFormText2] [nvarchar](max) NULL,
	[isActivated] [char](1) NULL,
	[ADS_EX_FORM_TEXT_1] [varchar](max) NULL,
	[ADS_EX_FORM_TEXT_2] [varchar](max) NULL,
	[ExerciseFormText3] [varchar](max) NULL,
	[TemplateName] [varchar](100) NULL,
	[MIT_ID] [int] NULL,
	[DYNAMIC_FORM] [int] NULL,
	[DYNAMIC_FORM_DISPLAY_NAME] [varchar](100) NULL,
	[PAYMENT_MODE_CONFIG_TYPE] [nvarchar](50) NULL,
	[DECLARATION] [nvarchar](max) NULL,
	[IsValidatedDematAcc] [bit] NULL,
	[IsValidatedBankAcc] [bit] NULL,
	[IsOneProcessFlow] [bit] NULL,
	[IsUpdatedDematAcc] [bit] NULL,
	[Acknowledgement] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Residenti__isAct__0EF836A4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ResidentialPaymentMode] ADD  DEFAULT ('N') FOR [isActivated]
END
GO
/****** Object:  Trigger [dbo].[TRIG_UPDATE_PAYMENT_MASTER]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_UPDATE_PAYMENT_MASTER]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[TRIG_UPDATE_PAYMENT_MASTER]
ON [dbo].[ResidentialPaymentMode]
AFTER UPDATE
AS
BEGIN
	DECLARE @OLD_ISACTIVATED CHAR(1),
			@NEW_ISACTIVATED CHAR(1),
			@PAYMENTMASTER_ID INT,
			@EXERCISEFORM_SUBMIT CHAR(1),
			@CNT INT
			
	SELECT @NEW_ISACTIVATED = isActivated, @PAYMENTMASTER_ID = PaymentMaster_Id FROM INSERTED 
	SELECT @OLD_ISACTIVATED = ISACTIVATED FROM DELETED 
	
	SELECT @EXERCISEFORM_SUBMIT = Exerciseform_Submit FROM PaymentMaster WHERE Id = @PAYMENTMASTER_ID
	
	IF (@NEW_ISACTIVATED <> @OLD_ISACTIVATED)
	BEGIN
		IF (@NEW_ISACTIVATED = ''Y'' AND @OLD_ISACTIVATED = ''N'' AND @EXERCISEFORM_SUBMIT = ''N'')
		BEGIN
			UPDATE PaymentMaster SET Exerciseform_Submit = ''Y'' WHERE Id = @PAYMENTMASTER_ID
		END
		ELSE IF (@NEW_ISACTIVATED = ''N'' AND @OLD_ISACTIVATED = ''Y'' AND @EXERCISEFORM_SUBMIT = ''Y'')
		BEGIN
			SELECT @CNT = COUNT(*) FROM RESIDENTIALPAYMENTMODE WHERE PaymentMaster_Id = @PAYMENTMASTER_ID AND ISACTIVATED = ''Y''
			IF @CNT =0
			BEGIN
				UPDATE PaymentMaster SET Exerciseform_Submit = ''N'' WHERE Id = @PAYMENTMASTER_ID
			END
		END
	END
END


' 
GO
ALTER TABLE [dbo].[ResidentialPaymentMode] ENABLE TRIGGER [TRIG_UPDATE_PAYMENT_MASTER]
GO
