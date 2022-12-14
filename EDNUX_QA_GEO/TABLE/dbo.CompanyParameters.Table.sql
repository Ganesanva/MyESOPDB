/****** Object:  Table [dbo].[CompanyParameters]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompanyParameters]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompanyParameters](
	[CompanyID] [varchar](20) NOT NULL,
	[CompanyEmailID] [varchar](50) NOT NULL,
	[ShortTermCGTax] [numeric](18, 0) NOT NULL,
	[LongTermCGTax] [numeric](18, 0) NOT NULL,
	[VestingAlertNotice] [numeric](18, 0) NOT NULL,
	[ExpiryAlertNotice] [numeric](18, 0) NOT NULL,
	[ExpiryTime] [numeric](18, 0) NOT NULL,
	[ExcersiseFormText1] [nvarchar](max) NULL,
	[ExcersiseFormText2] [nvarchar](max) NULL,
	[ListingDate] [datetime] NULL,
	[ListedYN] [char](1) NULL,
	[Apply_Fifo] [char](1) NULL,
	[ExerciseFormPrequisitionText1] [varchar](max) NULL,
	[ExerciseFormPrequisitionText2] [varchar](max) NULL,
	[PreqTax_ExchangeType] [char](1) NULL,
	[PreqTax_Shareprice] [int] NULL,
	[PreqTax_Calculateon] [char](1) NULL,
	[prqustcalcon] [char](1) NULL,
	[prequisiteTax] [numeric](18, 6) NULL,
	[SendPrqstMailAfter] [numeric](18, 0) NULL,
	[SendPrqstMailOn] [numeric](18, 0) NULL,
	[PerqTax_ApplyCash] [char](1) NULL,
	[CalcPerqtaxYN] [char](1) NULL,
	[Calc_PerqDt_From] [datetime] NULL,
	[Apply_Emp_taxslab] [char](1) NULL,
	[SendVestAlertYN] [varchar](1) NULL,
	[SendExpiryAlertYN] [varchar](1) NULL,
	[SendPerqMail] [char](1) NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[ReminderVestingAlert] [numeric](18, 0) NULL,
	[ReminderExpiryAlert] [numeric](18, 0) NULL,
	[FBTax] [numeric](10, 2) NOT NULL,
	[FBTPayBy] [varchar](20) NULL,
	[FBTTravelInfoYN] [char](1) NULL,
	[BeforeVestDateYN] [char](1) NULL,
	[BeforeExpirtyDateYN] [char](1) NULL,
	[Is_PaymentGateway_Integrate] [char](1) NOT NULL,
	[RoundupPlace_ExercisePrice] [numeric](18, 0) NOT NULL,
	[RoundupPlace_ExerciseAmount] [numeric](18, 0) NOT NULL,
	[RoundupPlace_FMV] [numeric](18, 0) NOT NULL,
	[RoundupPlace_TaxAmt] [numeric](18, 0) NOT NULL,
	[RoundupPlace_TaxableVal] [numeric](18, 0) NOT NULL,
	[RoundupPalce_Gain] [numeric](18, 0) NOT NULL,
	[Multiple_Grant_Exercise] [char](1) NOT NULL,
	[Exercise_Complete_Vest] [char](1) NOT NULL,
	[DematDetails_check] [char](1) NOT NULL,
	[TaxRate_ResignedEmp] [numeric](18, 6) NULL,
	[FaceVaue] [numeric](18, 2) NULL,
	[DematDtls_Required] [char](1) NULL,
	[rounding_param] [varchar](1) NOT NULL,
	[ApplySAYE] [char](10) NULL,
	[SourceDPID] [varchar](50) NULL,
	[SourceDPAccount] [varchar](50) NULL,
	[ISIN] [varchar](50) NULL,
	[SecurityName] [varchar](50) NULL,
	[TransactionType] [varchar](50) NULL,
	[Theme] [varchar](20) NULL,
	[SupportText] [varchar](max) NULL,
	[Multiple_Vest_Exercise] [char](1) NOT NULL,
	[CheckUnderWater] [varchar](10) NOT NULL,
	[RIPerqValue] [char](1) NOT NULL,
	[RIPerqTax] [char](1) NOT NULL,
	[NRIPerqValue] [char](1) NOT NULL,
	[NRIPerqTax] [char](1) NOT NULL,
	[FNPerqValue] [char](1) NOT NULL,
	[FNPerqTax] [char](1) NOT NULL,
	[ConfirmExerciseMailSent] [char](1) NULL,
	[RoundingParam_ExercisePrice] [char](1) NULL,
	[RoundingParam_ExerciseAmount] [char](1) NULL,
	[RoundingParam_FMV] [char](1) NULL,
	[RoundingParam_Taxamt] [char](1) NULL,
	[RoundingParam_TaxableVal] [char](1) NULL,
	[RoundingParam_Gain] [char](1) NULL,
	[IsReminderForPaymentModeSelection] [char](1) NULL,
	[PayModeReminderDays] [int] NULL,
	[MailFrom] [varchar](100) NULL,
	[IncludeAcSlipOnExFrm] [bit] NOT NULL,
	[HeaderForExerciseAmount] [varchar](1000) NULL,
	[AccountNoForExerciseAmount] [varchar](20) NULL,
	[HeaderForPerquisiteTax] [varchar](1000) NULL,
	[AccountNoForPerquisiteTax] [varchar](20) NULL,
	[NominationTextNote] [varchar](max) NULL,
	[NominationAddress] [varchar](max) NULL,
	[EnableNominee] [char](1) NULL,
	[EmpEditNominee] [char](1) NULL,
	[SendMailToEmp] [char](1) NULL,
	[NominationText] [varchar](max) NULL,
	[CDSLSettings] [tinyint] NOT NULL,
	[IsSAPayModeAllowed] [bit] NULL,
	[IsSPPayModeAllowed] [bit] NULL,
	[IsSinglePayModeAllowed] [bit] NULL,
	[BypassBankSelection] [bit] NOT NULL,
	[AutoRevForOnlineEx] [bit] NOT NULL,
	[AutoRevMinutes] [int] NOT NULL,
	[MinNoOfExeOpt] [varchar](10) NULL,
	[MultipleForExeOpt] [varchar](10) NULL,
	[isExeriseAtOneGo] [char](1) NULL,
	[isExeSeparately] [char](1) NULL,
	[ReminderPerformanceVestingAlert] [numeric](18, 0) NULL,
	[BeforePerfVestDateYN] [char](1) NULL,
	[SendPerfVestAlertYN] [varchar](1) NULL,
	[ISDOWNTIMESET] [char](1) NOT NULL,
	[DOWNTIMEMESSAGE] [varchar](1000) NULL,
	[DOWNTIMEACCESS] [varchar](10) NOT NULL,
	[PFUTPDate] [datetime] NULL,
	[PFUTPchkValue] [bit] NOT NULL,
	[CompanyEmailDisplayName] [varchar](20) NULL,
	[IS_SHOW_SHAREALLOTED] [tinyint] NULL,
	[IS_SHOW_CASHPAYOUT] [tinyint] NULL,
	[PERF_OPT_CAN_TREAT_APP_DT] [datetime] NULL,
	[PERF_OPT_CAN_TREAT_ON] [varchar](20) NULL,
	[IS_COMPANY_WITH_FMV] [bit] NULL,
	[SessionTimeOut] [int] NOT NULL,
	[FMV_BASEDON] [char](1) NULL,
	[IS_COMPANY_WITH_CLOSED_PRICES] [bit] NULL,
	[IsPrimaryEmailIDForLive] [bit] NULL,
	[IsSecondaryEmailIDForLive] [bit] NULL,
	[IsPrimaryEmailIDForSep] [bit] NULL,
	[IsSecondaryEmailIDForSep] [bit] NULL,
	[AllowMaxNominee] [int] NULL,
	[EnableRelationWithEmp] [bit] NULL,
	[EnableNomineePANNo] [bit] NULL,
	[EnableNomineeEmailId] [bit] NULL,
	[EnableNomineeContactNo] [bit] NULL,
	[EnableNomineeAdharNo] [bit] NULL,
	[EnableNomineeSIDNo] [bit] NULL,
	[EnableNomineeOther1] [bit] NULL,
	[EnableNomineeOther2] [bit] NULL,
	[EnableNomineeOther3] [bit] NULL,
	[EnableNomineeOther4] [bit] NULL,
	[EnableGuardianRelation] [bit] NULL,
	[EnableGUardianPANNo] [bit] NULL,
	[EnableGuardianEmailId] [bit] NULL,
	[EnableGuardianContactNo] [bit] NULL,
	[EnableGuardianAdharNo] [bit] NULL,
	[EnableGuardianSIDNo] [bit] NULL,
	[EnableGuardianOther1] [bit] NULL,
	[EnableGuardianOther2] [bit] NULL,
	[EnableGuardianOther3] [bit] NULL,
	[EnableGuardianOther4] [bit] NULL,
	[IsNomineeAutoApproval] [bit] NULL,
 CONSTRAINT [PK_CompanyParameters] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__CalcP__267ABA7A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [CalcPerqtaxYN]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__FBTax__634EBE90]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [FBTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Is_Pa__65370702]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [Is_PaymentGateway_Integrate]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__662B2B3B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPlace_ExercisePrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__671F4F74]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPlace_ExerciseAmount]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__681373AD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPlace_FMV]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__690797E6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPlace_TaxAmt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__69FBBC1F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPlace_TaxableVal]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__6AEFE058]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((2)) FOR [RoundupPalce_Gain]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Multi__6BE40491]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [Multiple_Grant_Exercise]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Exerc__6CD828CA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [Exercise_Complete_Vest]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Demat__6DCC4D03]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [DematDetails_check]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__round__6EC0713C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [rounding_param]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Theme__6442E2C9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('none') FOR [Theme]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Multi__6FB49575]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [Multiple_Vest_Exercise]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Check__70A8B9AE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Yes') FOR [CheckUnderWater]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__RIPer__719CDDE7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [RIPerqValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__RIPer__72910220]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [RIPerqTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__NRIPe__73852659]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [NRIPerqValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__NRIPe__74794A92]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [NRIPerqTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__FNPer__756D6ECB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [FNPerqValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__FNPer__76619304]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('Y') FOR [FNPerqTax]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Confi__0E04126B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [ConfirmExerciseMailSent]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__0FEC5ADD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_ExercisePrice]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__10E07F16]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_ExerciseAmount]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__11D4A34F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_FMV]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__12C8C788]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_Taxamt]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__13BCEBC1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_TaxableVal]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Round__14B10FFA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N') FOR [RoundingParam_Gain]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Inclu__7E8CC4B1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((1)) FOR [IncludeAcSlipOnExFrm]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Enabl__3118447E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [EnableNominee]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__EmpEd__320C68B7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [EmpEditNominee]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__SendM__33008CF0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [SendMailToEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__CDSLS__60C757A0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((1)) FOR [CDSLSettings]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__IsSin__5303482E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((1)) FOR [IsSinglePayModeAllowed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Bypas__4850AF91]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [BypassBankSelection]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__AutoR__08362A7C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [AutoRevForOnlineEx]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__AutoR__092A4EB5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [AutoRevMinutes]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__ISDOW__188C8DD6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [ISDOWNTIMESET]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__DOWNT__1980B20F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ('N|N|N') FOR [DOWNTIMEACCESS]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__PFUTP__27CED166]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [PFUTPchkValue]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__IS_CO__4496F5BE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [IS_COMPANY_WITH_FMV]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__Sessi__4C60047D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((20)) FOR [SessionTimeOut]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__CompanyPa__IS_CO__080D3C35]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CompanyParameters] ADD  DEFAULT ((0)) FOR [IS_COMPANY_WITH_CLOSED_PRICES]
END
GO
/****** Object:  Trigger [dbo].[TRG_AUDIT_COMPANY_PARAMETERS]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRG_AUDIT_COMPANY_PARAMETERS]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[TRG_AUDIT_COMPANY_PARAMETERS] 
   ON  [dbo].[CompanyParameters]
   AFTER UPDATE 
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE
			@TOTAL_ROWS		AS INT,
			@SR_NO			AS INT,
			@COLUMN_NAME	AS VARCHAR(MAX),
			@OLD_VALUE		AS VARCHAR(150),
			@NEW_VALUE		AS VARCHAR(150),
			@UPDATED_BY		AS VARCHAR(150)
	
	SELECT ROW_NUMBER() OVER(ORDER BY SYSCOL.NAME) AS SR_NO, SYSCOL.NAME AS COLUMN_NAME INTO #TEMP FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''COMPANYPARAMETERS''
	SET @SR_NO = 1
	SELECT @TOTAL_ROWS = COUNT(SR_NO) FROM #TEMP
	
	IF NOT EXISTS(SELECT NAME FROM SYS.TABLES WHERE NAME =''AUDIT_COMPANY_PARAMETERS'')
	BEGIN
		CREATE TABLE AUDIT_COMPANY_PARAMETERS
		(
			ACP_ID		INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
			COLUMN_NAME	NVARCHAR(MAX),
			OLD_VALUE	VARCHAR(150),
			NEW_VALUE	VARCHAR(150),
			UPDATED_BY	VARCHAR(150),
			UNDATED_ON	DATETIME
		)
	END
	
	CREATE TABLE #TEMP_DELETED 
	(
		OLD_VALUE VARCHAR(MAX)
	)
	
	CREATE TABLE #TEMP_INSERTED 
	(
		NEW_VALUE		VARCHAR(MAX),
		LastUpdatedBy	VARCHAR(150)
	)
	
	----This section is used to find all the columns from CompanyParameters and add it in Audit_Company_Paramters table if they doesn''t exists.
	--WHILE @SR_NO <= @TOTAL_ROWS
	--BEGIN
	--	SELECT @COLUMN_NAME = ''OLD_'' + COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--	IF NOT EXISTS(SELECT SYSCOL.NAME AS COLUMN_NAME FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''AUDIT_COMPANY_PARAMETERS'' AND SYSCOL.NAME = @COLUMN_NAME)
	--	BEGIN
	--		SELECT @COLUMN_NAME = COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--		EXECUTE(''ALTER TABLE AUDIT_COMPANY_PARAMETERS ADD OLD_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
	--		EXECUTE(''ALTER TABLE AUDIT_COMPANY_PARAMETERS ADD NEW_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
	--	END
		
	--	SET @SR_NO = @SR_NO + 1
	--END
	
	SELECT * INTO #TempInserted FROM INSERTED
	SELECT * INTO #TempDeleted FROM DELETED

	WHILE @SR_NO <= @TOTAL_ROWS
	BEGIN
		SELECT @COLUMN_NAME = COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO			
		
		IF(@COLUMN_NAME = ''LASTUPDATEDBY'' OR @COLUMN_NAME = ''LASTUPDATEDON'')
		BEGIN
			PRINT ''DO NOTHING''
		END
		ELSE
		BEGIN
		
			INSERT INTO #TEMP_DELETED EXEC(''SELECT '' + @COLUMN_NAME + '' FROM #TempDeleted'')
			INSERT INTO #TEMP_INSERTED EXEC(''SELECT '' + @COLUMN_NAME + '', LastUpdatedBy FROM #TempInserted'')
			
			SELECT @OLD_VALUE = OLD_VALUE FROM #TEMP_DELETED
			SELECT @NEW_VALUE = NEW_VALUE, @UPDATED_BY = LastUpdatedBy FROM #TEMP_INSERTED
			
			IF(@OLD_VALUE <> @NEW_VALUE)
			BEGIN
				INSERT INTO	AUDIT_COMPANY_PARAMETERS 
					(COLUMN_NAME, OLD_VALUE, NEW_VALUE, UPDATED_BY, UNDATED_ON)
				VALUES
					(@COLUMN_NAME, @OLD_VALUE, @NEW_VALUE, @UPDATED_BY, GETDATE())
			END 
		END
		
		
		SET @SR_NO = @SR_NO + 1
	END
	
	DROP TABLE #TEMP
	DROP TABLE #TEMP_DELETED
	DROP TABLE #TEMP_INSERTED
	DROP TABLE #TempInserted
	DROP TABLE #TempDeleted
	
	END TRY
	
	BEGIN CATCH
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''CompanyName: '' +  (SELECT DB_NAME()) + ''\n   '' +  ERROR_MESSAGE()
		EXEC msdb.dbo.sp_send_dbmail 
					@recipients = ''amin.mutawlli@esopdirect.com'',
					@body = @ERROR_MESSAGE,
					@body_format = ''HTML'',
					@subject = ''Alert : Unable to execute the trigger - TRG_AUDIT_COMPANY_PARAMETERS'',
					@from_address = ''noreply@esopdirect.com'' ;
	END CATCH
    SET NOCOUNT OFF;
END
' 
GO
ALTER TABLE [dbo].[CompanyParameters] ENABLE TRIGGER [TRG_AUDIT_COMPANY_PARAMETERS]
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'CompanyParameters', N'COLUMN',N'CDSLSettings'))
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:Default Settings CDSL 16 Digit | 1 : Practically Move i.e. is CDSL is 16 digit then copy first 8 digit to NDSL and Remaing 8 digit to CDSL | 2: Practically Copy i.e. if from 16 digit CSLS nuber copy first 8 to NDSL and CDSL is 16 Digit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CompanyParameters', @level2type=N'COLUMN',@level2name=N'CDSLSettings'
GO
