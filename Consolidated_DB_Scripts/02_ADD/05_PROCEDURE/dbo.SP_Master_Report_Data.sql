-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-01
-- Description:	Data from SP_REPORT_DATA is dumped into a temporary table and then 3 different tables are created from that.
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_Master_Report_Data')
BEGIN
DROP PROCEDURE SP_Master_Report_Data
END
GO

create    PROCEDURE [dbo].[SP_Master_Report_Data] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@FromDate DateTime,
	@ToDate DateTime,
	@ReportName VARCHAR(50) = 'All', 
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
	DECLARE @TEMPTABLENAME VARCHAR(50);
	SET @TEMPTABLENAME = '#MASTER_TEMP_DATA_MyESOPs';

	IF(@ESOPVersion = 'Global')
	BEGIN
		CREATE TABLE #MASTER_TEMP_DATA (
			OptionsGranted             NUMERIC (18, 0),
			OptionsVested              NUMERIC (18, 0),
			OptionsExercised           NUMERIC (18, 0),
			OptionsCancelled           NUMERIC (18, 0),
			OptionsLapsed              NUMERIC (18, 0),
			OptionsUnVested            NUMERIC (18, 0),
			PendingForApproval         NUMERIC (18, 0),
			GrantOptionId              NVARCHAR (100) ,
			GrantLegId                 NUMERIC (18, 0),
			SchemeId                   NVARCHAR (150) ,
			GrantRegistrationId        NVARCHAR (150) ,
			Employeeid                 NVARCHAR (150) ,
			EmployeeName               NVARCHAR (250) ,
			SBU                        NVARCHAR (100)  NULL,
			AccountNo                  NVARCHAR (100)  NULL,
			PANNumber                  NVARCHAR (50)   NULL,
			Entity                     NVARCHAR (100)  NULL,
			[Status]                   NVARCHAR (100) ,
			GrantDate                  DATETIME       ,
			VestingType                NVARCHAR (100) ,
			ExercisePrice              NUMERIC (10, 2),
			VestingDate                DATETIME       ,
			ExpiryDate                 DATETIME       ,
			Parent_Note                NVARCHAR (10)  ,
			VestingFrequency           VARCHAR (5)    ,
			LapseDate                  DATETIME       ,
			CancelledDate              DATETIME       ,
			CancelledReasion           NVARCHAR (200) ,
			MarketPrice                NUMERIC (18, 2),
			UnvestedOptionsLiveFor     NUMERIC (18, 0),
			VestedOptionsLiveFor       NUMERIC (18, 0),
			IsVestingOfUnvestedOptions NVARCHAR (10)  ,
			PeriodUnit                 NVARCHAR (10)  ,
			AmountPayableOnExercise    NUMERIC (18, 2),
			LastDateToExercise         DATETIME       ,
			UnvestedCancellationDate   DATETIME       ,
			ValueOfGrantedOptions      NUMERIC (18, 2),
			ValueOfVestedOptions       NUMERIC (18, 2),
			ValueOfUnvestedOptions     NUMERIC (18, 2),
			UnvestedCancelled          NUMERIC (18, 2),
			VestedCancelled            NUMERIC (18, 2),
			IsGlGenerated              BIT            ,
			IsEGrantsEnabled           BIT            ,
			INSTRUMENT_NAME            NVARCHAR (100) ,
			CurrencyName               NVARCHAR (100) ,
			COST_CENTER                VARCHAR (50)   ,
			Department                 VARCHAR (50)   ,
			Location                   VARCHAR (100)  ,
			EmployeeDesignation        VARCHAR (100)  ,
			Grade                      VARCHAR (50)   ,
			ResidentialStatus          VARCHAR (50)   ,
			CountryName                VARCHAR (100)  ,
			CurrencyAlias              VARCHAR (20)   ,
			MIT_ID                     INT            ,
			LetterAcceptanceStatus     NCHAR (1)      ,
			CancellationReason         NVARCHAR (500) 
		);
	
		SET @StrInsertQuery = 'INSERT INTO #MASTER_TEMP_DATA (OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber, Entity, [Status], GrantDate, VestingType, ExercisePrice, VestingDate, ExpiryDate, Parent_Note, UnvestedCancelled, VestedCancelled, INSTRUMENT_NAME, CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus, CountryName, CurrencyAlias, MIT_ID, CancellationReason)
		EXECUTE SP_REPORT_DATA ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''' ,''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
    
		EXECUTE (@StrInsertQuery);
	END
	ELSE
	BEGIN
		CREATE TABLE #MASTER_TEMP_DATA_MyESOPs (
			OptionsGranted             NUMERIC (18, 0),
			OptionsVested              NUMERIC (18, 0),
			OptionsExercised           NUMERIC (18, 0),
			OptionsCancelled           NUMERIC (18, 0),
			OptionsLapsed              NUMERIC (18, 0),
			OptionsUnVested            NUMERIC (18, 0),
			[Pending For Approval]         NUMERIC (18, 0),
			GrantOptionId              NVARCHAR (100) ,
			GrantLegId                 NUMERIC (18, 0),
			SchemeId                   NVARCHAR (150) ,
			GrantRegistrationId        NVARCHAR (150) ,
			Employeeid                 NVARCHAR (150) ,
			EmployeeName               NVARCHAR (250) ,
			SBU                        NVARCHAR (100) ,
			AccountNo                  NVARCHAR (100) ,
			PANNumber                  NVARCHAR (50)  ,
			Entity                     NVARCHAR (100) ,
			[Status]                   NVARCHAR (100) ,
			GrantDate                  DATETIME       ,
			VestingType                NVARCHAR (100) ,
			ExercisePrice              NUMERIC (10, 2),
			VestingDate                DATETIME       ,
			ExpirayDate                 DATETIME       ,
			Parent_Note                NVARCHAR (10)  ,
			UnvestedCancelled          NUMERIC (18, 2),
			VestedCancelled            NUMERIC (18, 2)
		);
		PRINT 'TEMP TABLE CREATED';
		SET @StrInsertQuery = 'INSERT INTO #MASTER_TEMP_DATA_MyESOPs (OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, [Pending For Approval], GrantOptionId,
				GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber, Entity, [Status], GrantDate,
				VestingType, ExercisePrice, VestingDate, ExpirayDate, Parent_Note, UnvestedCancelled, VestedCancelled)
				EXECUTE SP_REPORT_DATA ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''' ,''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
		PRINT @StrInsertQuery;
		EXECUTE (@StrInsertQuery);
	END
	DECLARE @ClearDataQuery AS VARCHAR (MAX);
	DECLARE @StrUpdateQuery AS VARCHAR (MAX);
    
	IF(@ESOPVersion = 'Global')
	BEGIN
			IF (@ReportName = 'GrantConsolidatedReport'
				OR @ReportName = 'All')
				BEGIN
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport](SchemeName, GrantRegistrationId,
							GrantDate, ExercisePrice, ParentNote, OptionsGranted, OptionsVested, OptionsUnVested, OptionsExercised, OptionsCancelled,
							OptionsLapsed)
						(SELECT SchemeId, GrantRegistrationId, GrantDate, ExercisePrice, Parent_Note, SUM(OptionsGranted), SUM(OptionsVested)  + SUM(PendingForApproval),
						SUM(OptionsUnVested), SUM(OptionsExercised), SUM(OptionsCancelled), SUM(OptionsLapsed)
						FROM #MASTER_TEMP_DATA GROUP BY SchemeId, GrantRegistrationId, GrantDate, Parent_Note, ExercisePrice)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
			IF (@ReportName = 'GrantSummaryReport'
				OR @ReportName = 'All')
				BEGIN
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport] ( SchemeName, GrantRegistrationId,
					EmployeeId, EmployeeName, GrantOptionId, ParentNote, GrantDate, ExercisePrice, Status, OptionsGranted, OptionsVested, OptionsUnVested,
					OptionsExercised, OptionsCancelled, OptionsLapsed, SBU, Entity, AccountNo)
					(SELECT SchemeId, GrantRegistrationId, EmployeeId,	EmployeeName, GrantOptionId, Parent_Note, GrantDate, ExercisePrice, Status,
					SUM(OptionsGranted), SUM(OptionsVested)  + SUM(PendingForApproval), SUM(OptionsUnVested), SUM(OptionsExercised), SUM(OptionsCancelled),
					SUM(OptionsLapsed), SBU, Entity, AccountNo FROM #MASTER_TEMP_DATA
					GROUP BY SchemeId, GrantRegistrationId,EmployeeId, EmployeeName, GrantOptionId, Parent_Note, GrantDate, ExercisePrice, Status, SBU, Entity, AccountNo)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
			IF (@ReportName = 'VestwiseReport'
				OR @ReportName = 'All')
				BEGIN
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport] (SchemeName, EmployeeId, EmployeeName, Status, GrantDate, GrantLegId, GrantRegistrationId,
							GrantOptionId, ParentNote, OptionsGranted, VestingType, VestingDate, ExpiryDate, ExercisePrice, OptionsVested, PendingForApproval,
							OptionsUnVested, OptionsExercised, OptionsCancelled, OptionsLapsed, UnvestedCancelled, VestedCancelled)
						(SELECT SchemeId, EmployeeId, EmployeeName,	Status, GrantDate, GrantLegId, GrantRegistrationId, GrantOptionId, Parent_Note, SUM(OptionsGranted),
						VestingType, VestingDate, ExpiryDate, ExercisePrice, SUM(OptionsVested), SUM(PendingForApproval), SUM(OptionsUnVested), SUM(OptionsExercised),
						SUM(OptionsCancelled), SUM(OptionsLapsed), SUM(UnvestedCancelled), SUM(VestedCancelled) FROM #MASTER_TEMP_DATA
						GROUP BY SchemeId, EmployeeId, EmployeeName, Status, GrantDate, GrantLegId, GrantRegistrationId, GrantOptionId, Parent_Note, VestingType, VestingDate, ExpiryDate, ExercisePrice)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
	END
	ELSE
	BEGIN
	PRINT 'IN MYESOPS';
		IF (@ReportName = 'GrantConsolidatedReport'
				OR @ReportName = 'All')
				BEGIN
				PRINT 'GCR';
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport](SchemeName, GrantRegistrationId,
							GrantDate, ExercisePrice, ParentNote, OptionsGranted, OptionsVested, OptionsUnVested, OptionsExercised, OptionsCancelled,
							OptionsLapsed)
						(SELECT SchemeId, GrantRegistrationId, GrantDate, ExercisePrice, Parent_Note, SUM(OptionsGranted), SUM(OptionsVested)  + SUM([Pending For Approval]),
						SUM(OptionsUnVested), SUM(OptionsExercised), SUM(OptionsCancelled), SUM(OptionsLapsed)
						FROM #MASTER_TEMP_DATA_MyESOPs GROUP BY SchemeId, GrantRegistrationId, GrantDate, Parent_Note, ExercisePrice)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantConsolidatedReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
			IF (@ReportName = 'GrantSummaryReport'
				OR @ReportName = 'All')
				BEGIN
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport] ( SchemeName, GrantRegistrationId,
					EmployeeId, EmployeeName, GrantOptionId, ParentNote, GrantDate, ExercisePrice, Status, OptionsGranted, OptionsVested, OptionsUnVested,
					OptionsExercised, OptionsCancelled, OptionsLapsed, SBU, Entity, AccountNo)
					(SELECT SchemeId, GrantRegistrationId, EmployeeId,	EmployeeName, GrantOptionId, Parent_Note, GrantDate, ExercisePrice, Status,
					SUM(OptionsGranted), SUM(OptionsVested)  + SUM([Pending For Approval]), SUM(OptionsUnVested), SUM(OptionsExercised), SUM(OptionsCancelled),
					SUM(OptionsLapsed), SBU, Entity, AccountNo FROM #MASTER_TEMP_DATA_MyESOPs
					GROUP BY SchemeId, GrantRegistrationId,EmployeeId, EmployeeName, GrantOptionId, Parent_Note, GrantDate, ExercisePrice, Status, SBU, Entity, AccountNo)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[GrantSummaryReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
			IF (@ReportName = 'VestwiseReport'
				OR @ReportName = 'All')
				BEGIN
					SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport]';
					EXECUTE (@ClearDataQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport] (SchemeName, EmployeeId, EmployeeName, Status, GrantDate, GrantLegId, GrantRegistrationId,
							GrantOptionId, ParentNote, OptionsGranted, VestingType, VestingDate, ExpiryDate, ExercisePrice, OptionsVested, PendingForApproval,
							OptionsUnVested, OptionsExercised, OptionsCancelled, OptionsLapsed, UnvestedCancelled, VestedCancelled)
						(SELECT SchemeId, EmployeeId, EmployeeName,	Status, GrantDate, GrantLegId, GrantRegistrationId, GrantOptionId, Parent_Note, SUM(OptionsGranted),
						VestingType, VestingDate, ExpirayDate as ExpiryDate, ExercisePrice, SUM(OptionsVested), SUM([Pending For Approval]), SUM(OptionsUnVested), SUM(OptionsExercised),
						SUM(OptionsCancelled), SUM(OptionsLapsed), SUM(UnvestedCancelled), SUM(VestedCancelled) FROM #MASTER_TEMP_DATA_MyESOPs
						GROUP BY SchemeId, EmployeeId, EmployeeName, Status, GrantDate, GrantLegId, GrantRegistrationId, GrantOptionId, Parent_Note, VestingType, VestingDate, ExpirayDate, ExercisePrice)';
					EXECUTE (@StrInsertQuery);
					SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestWiseReport] SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
					EXECUTE (@StrUpdateQuery);
				END
	END
END
GO

