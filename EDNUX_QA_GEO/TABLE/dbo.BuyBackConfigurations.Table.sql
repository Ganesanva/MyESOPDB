/****** Object:  Table [dbo].[BuyBackConfigurations]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuyBackConfigurations]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BuyBackConfigurations](
	[IsMaxLimitToBBOptionsRequired] [bit] NULL,
	[MaxLimitToBBOptionsType] [char](1) NULL,
	[MaxLimitToBBOptionsTypeDisplayedIn] [char](1) NULL,
	[MaxLimitToBBOptionsForLiveEmp] [numeric](18, 0) NULL,
	[MaxLimitToBBOptionsForSepEmp] [numeric](18, 0) NULL,
	[MaxLimitToBBOptionsCapForAllEmp] [numeric](18, 0) NULL,
	[IsMultipleTransAllowed] [bit] NULL,
	[NoOfMultipleTransAllowedForLiveEmp] [numeric](18, 0) NULL,
	[NoOfMultipleTransAllowedForSepEmp] [numeric](18, 0) NULL,
	[IsSettlementPriceVisible] [bit] NULL,
	[SettlementPrice] [numeric](18, 9) NULL,
	[IsGrossPayableVisible] [bit] NULL,
	[GrossPayableFormula] [varchar](500) NULL,
	[IsBankDetailsVisibleForLiveEmp] [bit] NULL,
	[IsBankDetailsVisibleForSepEmp] [bit] NULL,
	[IsApplnFormDownloadAllowed] [bit] NULL,
	[IsUploadFormAllowed] [bit] NULL,
	[IsBankDetEditablePostSubmission] [bit] NULL,
	[BBWindowOpenFrom] [datetime] NULL,
	[BBWindowOpenTo] [datetime] NULL,
	[BBWindowCloseMessage] [varchar](200) NULL,
	[IsApplnFormDownloadAllowedDuringBBWindow] [bit] NULL,
	[IsUploadFormAllowedDuringBBWindow] [bit] NULL,
	[CutOffDate] [datetime] NULL,
	[IsTnCRequiredForLiveEmp] [bit] NULL,
	[IsTnCRequiredForSepEmp] [bit] NULL,
	[NoteForLiveEmp] [varchar](max) NULL,
	[NoteForSepEmp] [varchar](max) NULL,
	[UpdatedBy] [varchar](100) NULL,
	[UpdatedOn] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsMax__62D066FA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsMaxLimitToBBOptionsRequired]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__MaxLi__63C48B33]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ('P') FOR [MaxLimitToBBOptionsType]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__MaxLi__64B8AF6C]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ('N') FOR [MaxLimitToBBOptionsTypeDisplayedIn]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__MaxLi__65ACD3A5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [MaxLimitToBBOptionsForLiveEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__MaxLi__66A0F7DE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [MaxLimitToBBOptionsForSepEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__MaxLi__67951C17]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [MaxLimitToBBOptionsCapForAllEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsMul__68894050]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsMultipleTransAllowed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__NoOfM__697D6489]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [NoOfMultipleTransAllowedForLiveEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__NoOfM__6A7188C2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [NoOfMultipleTransAllowedForSepEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsSet__6B65ACFB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsSettlementPriceVisible]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsGro__6C59D134]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsGrossPayableVisible]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__Gross__6D4DF56D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ('BuyBackOptions.NoOfOptionsSurrendered * BuyBackConfigurations.SettlementPrice') FOR [GrossPayableFormula]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsBan__6E4219A6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((0)) FOR [IsBankDetailsVisibleForLiveEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsBan__6F363DDF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsBankDetailsVisibleForSepEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsApp__702A6218]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsApplnFormDownloadAllowed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsUpl__711E8651]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsUploadFormAllowed]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsBan__7212AA8A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsBankDetEditablePostSubmission]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsApp__7306CEC3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsApplnFormDownloadAllowedDuringBBWindow]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsUpl__73FAF2FC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsUploadFormAllowedDuringBBWindow]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsTnC__74EF1735]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsTnCRequiredForLiveEmp]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackCo__IsTnC__75E33B6E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackConfigurations] ADD  DEFAULT ((1)) FOR [IsTnCRequiredForSepEmp]
END
GO
/****** Object:  Trigger [dbo].[TRG_AUDIT_BuyBackConfigurations]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRG_AUDIT_BuyBackConfigurations]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[TRG_AUDIT_BuyBackConfigurations]
   ON  [dbo].[BuyBackConfigurations]
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
	
	SELECT ROW_NUMBER() OVER(ORDER BY SYSCOL.NAME) AS SR_NO, SYSCOL.NAME AS COLUMN_NAME INTO #TEMP FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''BuyBackConfigurations''
	SET @SR_NO = 1
	SELECT @TOTAL_ROWS = COUNT(SR_NO) FROM #TEMP
	
	IF NOT EXISTS(SELECT NAME FROM SYS.TABLES WHERE NAME =''AUDIT_BuyBackConfigurations'')
	BEGIN
		CREATE TABLE AUDIT_BuyBackConfigurations
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
		UpdatedBy		VARCHAR(150)
	)
	
	----This section is used to find all the columns from BuyBackConfigurations and add it in Audit_Company_Paramters table if they doesn''t exists.
	--WHILE @SR_NO <= @TOTAL_ROWS
	--BEGIN
	--	SELECT @COLUMN_NAME = ''OLD_'' + COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--	IF NOT EXISTS(SELECT SYSCOL.NAME AS COLUMN_NAME FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''AUDIT_BuyBackConfigurations'' AND SYSCOL.NAME = @COLUMN_NAME)
	--	BEGIN
	--		SELECT @COLUMN_NAME = COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--		EXECUTE(''ALTER TABLE AUDIT_BuyBackConfigurations ADD OLD_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
	--		EXECUTE(''ALTER TABLE AUDIT_BuyBackConfigurations ADD NEW_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
	--	END
		
	--	SET @SR_NO = @SR_NO + 1
	--END
	
	SELECT * INTO #TempInserted FROM INSERTED
	SELECT * INTO #TempDeleted FROM DELETED

	WHILE @SR_NO <= @TOTAL_ROWS
	BEGIN
		SELECT @COLUMN_NAME = COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO			
		
		IF(@COLUMN_NAME = ''UPDATEDBY'' OR @COLUMN_NAME = ''UPDATEDON'')
		BEGIN
			PRINT ''DO NOTHING''
		END
		ELSE
		BEGIN
		
			INSERT INTO #TEMP_DELETED EXEC(''SELECT '' + @COLUMN_NAME + '' FROM #TempDeleted'')
			INSERT INTO #TEMP_INSERTED EXEC(''SELECT '' + @COLUMN_NAME + '', UpdatedBy FROM #TempInserted'')
			
			SELECT @OLD_VALUE = OLD_VALUE FROM #TEMP_DELETED
			SELECT @NEW_VALUE = NEW_VALUE, @UPDATED_BY = UpdatedBy FROM #TEMP_INSERTED
			
			IF(@OLD_VALUE <> @NEW_VALUE)
			BEGIN
				INSERT INTO	AUDIT_BuyBackConfigurations 
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
		SELECT @ERROR_MESSAGE
		--EXEC msdb.dbo.sp_send_dbmail 
		--			@recipients = ''amin.mutawlli@esopdirect.com'',
		--			@body = @ERROR_MESSAGE,
		--			@body_format = ''HTML'',
		--			@subject = ''Alert : Unable to execute the trigger - TRG_AUDIT_BuyBackConfigurations'',
		--			@from_address = ''noreply@esopdirect.com'' ;
	END CATCH
    SET NOCOUNT OFF;
END
' 
GO
ALTER TABLE [dbo].[BuyBackConfigurations] ENABLE TRIGGER [TRG_AUDIT_BuyBackConfigurations]
GO
