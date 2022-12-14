/****** Object:  Table [dbo].[Scheme]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Scheme]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Scheme](
	[ApprovalId] [varchar](20) NOT NULL,
	[SchemeId] [varchar](50) NOT NULL,
	[Status] [varchar](1) NOT NULL,
	[SchemeTitle] [varchar](50) NOT NULL,
	[AdjustResidueOptionsIn] [varchar](1) NOT NULL,
	[VestingOverPeriodOffset] [numeric](18, 0) NOT NULL,
	[VestingStartOffset] [numeric](18, 0) NOT NULL,
	[VestingFrequency] [numeric](18, 0) NOT NULL,
	[LockInPeriod] [numeric](18, 0) NULL,
	[LockInPeriodStartsFrom] [varchar](1) NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NOT NULL,
	[OptionRatioDivisor] [numeric](18, 0) NOT NULL,
	[ExercisePeriodOffset] [numeric](18, 0) NOT NULL,
	[ExercisePeriodStartsAfter] [varchar](1) NOT NULL,
	[PeriodUnit] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[TrustType] [char](10) NOT NULL,
	[IsPaymentModeRequired] [tinyint] NOT NULL,
	[PaymentModeEffectiveDate] [date] NOT NULL,
	[UnVestedCancelledOptions] [varchar](1) NOT NULL,
	[VestedCancelledOptions] [varchar](1) NOT NULL,
	[LapsedOptions] [varchar](1) NOT NULL,
	[IsPUPEnabled] [bit] NOT NULL,
	[DisplayExPrice] [bit] NOT NULL,
	[DisplayExpDate] [bit] NOT NULL,
	[DisplayPerqVal] [bit] NOT NULL,
	[DisplayPerqTax] [bit] NOT NULL,
	[PUPEXEDPAYOUTPROCESS] [bit] NOT NULL,
	[PUPFORMULAID] [int] NOT NULL,
	[IS_ADS_SCHEME] [bit] NOT NULL,
	[IS_ADS_EX_OPTS_ALLOWED] [bit] NOT NULL,
	[MIT_ID] [int] NULL,
	[IS_AUTO_EXERCISE_ALLOWED] [char](1) NULL,
	[CALCULATE_TAX] [nvarchar](200) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS] [int] NULL,
	[ROUNDING_UP] [tinyint] NULL,
	[FRACTION_PAID_CASH] [tinyint] NULL,
	[CALCULATE_TAX_PREVESTING] [nvarchar](100) NULL,
	[CALCUALTE_TAX_PRIOR_DAYS_PREVESTING] [int] NULL,
 CONSTRAINT [PK_Scheme] PRIMARY KEY CLUSTERED 
(
	[SchemeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__TrustTyp__178D7CA5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ('N') FOR [TrustType]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__IsPaymen__5B438874]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((1)) FOR [IsPaymentModeRequired]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__PaymentM__5C37ACAD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT (getdate()) FOR [PaymentModeEffectiveDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__UnVested__3F3159AB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ('Y') FOR [UnVestedCancelledOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__VestedCa__40257DE4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ('Y') FOR [VestedCancelledOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__LapsedOp__4119A21D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ('Y') FOR [LapsedOptions]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__IsPUPEna__15FA39EE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [IsPUPEnabled]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__DisplayE__16EE5E27]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [DisplayExPrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__DisplayE__17E28260]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [DisplayExpDate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__DisplayP__18D6A699]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [DisplayPerqVal]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__DisplayP__19CACAD2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [DisplayPerqTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__PUPEXEDP__2779CBAB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [PUPEXEDPAYOUTPROCESS]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__PUPFORMU__286DEFE4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [PUPFORMULAID]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__IS_ADS_S__5FBE24CE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [IS_ADS_SCHEME]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Scheme__IS_ADS_E__60B24907]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Scheme] ADD  DEFAULT ((0)) FOR [IS_ADS_EX_OPTS_ALLOWED]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Scheme_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[Scheme]'))
ALTER TABLE [dbo].[Scheme]  WITH CHECK ADD  CONSTRAINT [FK_Scheme_ShareHolderApproval] FOREIGN KEY([ApprovalId])
REFERENCES [dbo].[ShareHolderApproval] ([ApprovalId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Scheme_ShareHolderApproval]') AND parent_object_id = OBJECT_ID(N'[dbo].[Scheme]'))
ALTER TABLE [dbo].[Scheme] CHECK CONSTRAINT [FK_Scheme_ShareHolderApproval]
GO
/****** Object:  Trigger [dbo].[TrgNAPaymentSetting]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TrgNAPaymentSetting]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[TrgNAPaymentSetting] ON [dbo].[Scheme]
AFTER UPDATE
AS
BEGIN
		DECLARE @SchemeId varchar(50),
				@isPaymentModeReq tinyint,
				@EffectiveDate DATE,
				@audit_action char,
				@LastUpdatedBy VARCHAR(100)
			
				
		SELECT	@SchemeId			= i.SchemeID,
				@isPaymentModeReq	= i.IsPaymentModeRequired,
				@EffectiveDate		= i.PaymentModeEffectiveDate,
				@LastUpdatedBy		= I.LastUpdatedBy
		FROM	INSERTED i
		
		IF((SELECT IsPaymentModeRequired FROM inserted) <> (SELECT IsPaymentModeRequired FROM deleted))
			BEGIN
				INSERT INTO AuditTrailOfSchmePaymentSettings(SchemeId, OldValueOfPaymentModeReq,
							NEWValueOfPaymentModeReq, OldEffectiveDate, NewEffectiveDate, LastUpdatedBy, LastUpdatedOn) 
				SELECT @SchemeId, d.IsPaymentModeRequired, @isPaymentModeReq, d.PaymentModeEffectiveDate, @EffectiveDate, @LastUpdatedBy, GETDATE() FROM deleted d
			END
END


' 
GO
ALTER TABLE [dbo].[Scheme] ENABLE TRIGGER [TrgNAPaymentSetting]
GO
/****** Object:  Trigger [dbo].[TRIG_AUDIT_SCHEME]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_AUDIT_SCHEME]'))
EXEC dbo.sp_executesql @statement = N'    
CREATE TRIGGER [dbo].[TRIG_AUDIT_SCHEME]
ON [dbo].[Scheme]
AFTER INSERT,UPDATE
AS 
BEGIN
DECLARE 
		@SCHEMEID VARCHAR(50),
		@ADDEDBY VARCHAR(50),
		@OLD_UnVestedCancelledOptions CHAR(1),
		@NEW_UnVestedCancelledOptions CHAR(1),
		@OLD_VestedCancelledOptions CHAR(1),
		@NEW_VestedCancelledOptions CHAR(1),
		@OLD_LapsedOptions CHAR(1),
		@NEW_LapsedOptions CHAR(1)
		
		
	
SELECT @SCHEMEID=SCHEMEID,@NEW_UnVestedCancelledOptions= UnVestedCancelledOptions,@NEW_VestedCancelledOptions=VestedCancelledOptions ,@NEW_LapsedOptions=LapsedOptions,@ADDEDBY=LastUpdatedBy FROM inserted
SELECT @OLD_UnVestedCancelledOptions=UnVestedCancelledOptions,@OLD_VestedCancelledOptions=VestedCancelledOptions, @OLD_LapsedOptions=LapsedOptions,@ADDEDBY=LastUpdatedBy  FROM deleted
IF(@SCHEMEID!='''')
BEGIN
INSERT INTO AUDITTRAILOFSCHEME VALUES(@SCHEMEID,@ADDEDBY,GETDATE(),@OLD_UnVestedCancelledOptions,@NEW_UnVestedCancelledOptions,@OLD_VestedCancelledOptions,@NEW_VestedCancelledOptions,@OLD_LapsedOptions,@NEW_LapsedOptions)
END
END



' 
GO
ALTER TABLE [dbo].[Scheme] ENABLE TRIGGER [TRIG_AUDIT_SCHEME]
GO
