/****** Object:  Table [dbo].[BuyBackOptions]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BuyBackOptions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BuyBackOptions](
	[BBOID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NULL,
	[EmployeeID] [varchar](100) NULL,
	[EmployeeStatus] [varchar](50) NULL,
	[ApplicationDate] [datetime] NULL,
	[NoOfOptionsApplied] [int] NULL,
	[SettlementPrice] [numeric](18, 9) NULL,
	[GrossValuePayable] [numeric](18, 0) NULL,
	[NameInBankRecord] [varchar](100) NULL,
	[BankName] [varchar](100) NULL,
	[BankAddress] [varchar](200) NULL,
	[BankAccountNumber] [varchar](100) NULL,
	[BankIFSCCode] [varchar](100) NULL,
	[PANNumber] [varchar](100) NULL,
	[AadhaarNumber] [varchar](100) NULL,
	[IsFileUploaded] [bit] NULL,
	[CreatedBy] [varchar](100) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [varchar](100) NULL,
	[UpdatedOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BBOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__BuyBackOp__IsFil__78BFA819]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BuyBackOptions] ADD  DEFAULT ((0)) FOR [IsFileUploaded]
END
GO
/****** Object:  Trigger [dbo].[TRG_AUDIT_BuyBackOptions]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRG_AUDIT_BuyBackOptions]'))
EXEC dbo.sp_executesql @statement = N'
CREATE TRIGGER [dbo].[TRG_AUDIT_BuyBackOptions]
   ON  [dbo].[BuyBackOptions]
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
	
	SELECT ROW_NUMBER() OVER(ORDER BY SYSCOL.NAME) AS SR_NO, SYSCOL.NAME AS COLUMN_NAME INTO #TEMP FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''BuyBackOptions''
	SET @SR_NO = 1
	SELECT @TOTAL_ROWS = COUNT(SR_NO) FROM #TEMP
	
	IF NOT EXISTS(SELECT NAME FROM SYS.TABLES WHERE NAME =''AUDIT_BuyBackOptions'')
	BEGIN
		CREATE TABLE AUDIT_BuyBackOptions
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
	
	----This section is used to find all the columns from BuyBackOptions and add it in Audit_Company_Paramters table if they doesn''t exists.
	--WHILE @SR_NO <= @TOTAL_ROWS
	--BEGIN
	--	SELECT @COLUMN_NAME = ''OLD_'' + COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--	IF NOT EXISTS(SELECT SYSCOL.NAME AS COLUMN_NAME FROM SYS.COLUMNS SYSCOL INNER JOIN SYS.TABLES SYSTAB ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = ''AUDIT_BuyBackOptions'' AND SYSCOL.NAME = @COLUMN_NAME)
	--	BEGIN
	--		SELECT @COLUMN_NAME = COLUMN_NAME FROM #TEMP WHERE SR_NO = @SR_NO
	--		EXECUTE(''ALTER TABLE AUDIT_BuyBackOptions ADD OLD_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
	--		EXECUTE(''ALTER TABLE AUDIT_BuyBackOptions ADD NEW_'' + @COLUMN_NAME + '' NVARCHAR(150) '')
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
				INSERT INTO	AUDIT_BuyBackOptions 
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
		--			@subject = ''Alert : Unable to execute the trigger - TRG_AUDIT_BuyBackOptions'',
		--			@from_address = ''noreply@esopdirect.com'' ;
	END CATCH
    SET NOCOUNT OFF;
END
' 
GO
ALTER TABLE [dbo].[BuyBackOptions] ENABLE TRIGGER [TRG_AUDIT_BuyBackOptions]
GO
