-- =============================================
-- Author:		Vrushali Kamthe		
-- Create date: 2018-10-04
-- Description:	Extracts data from SP_LAPSE_REPORT and dumps it into LapseData table on Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_LapseReport')
BEGIN
DROP PROCEDURE SP_LapseReport
END
GO

CREATE    PROCEDURE [dbo].[SP_LapseReport]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@FromDate DATETIME,
	@ToDate DATETIME,
	@ESOPVersion VARCHAR(50) = NULL 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseData]';
    EXECUTE (@ClearDataQuery);
	
	IF(@ESOPVersion = 'Global')
	BEGIN
	PRINT('In Global')
	CREATE TABLE #LapseDataTemp(
	[MIT_ID] [bigint] NULL,
	[INSTRUMENT_NAME] [varchar](500) NULL,
	[CurrencyAlias] [varchar](50) NULL,
	[VestingPeriodId] [numeric](18, 0) NULL,
	[VestingDate] [datetime] NULL,
	[SchemeTitle] [varchar](50) NULL,
	[GrantDate] [datetime] NULL,
	[GrantRegistration] [varchar](20) NULL,
	[ExercisePrice] [numeric](18, 2) NULL,
	[EmployeeId] [varchar](20) NULL,
	[EmployeeName] [varchar](75) NULL,
	[GrantOpId] [varchar](100) NULL,
	[STATUS] [varchar](50) NULL,
	[ExpiryDate] [datetime] NULL,
	[OptionsLapsed] [numeric](18, 0) NULL,
	[parent] [varchar](10) NULL,
	[CSFlag] [char](1) NULL
);

	SET @StrInsertQuery = 'INSERT INTO #LapseDataTemp(MIT_ID, INSTRUMENT_NAME, CurrencyAlias, 
		VestingPeriodId, VestingDate, SchemeTitle,	GrantDate, GrantRegistration, ExercisePrice, EmployeeId, EmployeeName, GrantOpId, STATUS, 
		ExpiryDate, OptionsLapsed, parent, CSFlag) 
		EXECUTE dbo.SP_LAPSE_REPORT ''' + CONVERT(VARCHAR(50), CONVERT (VARCHAR (50), @FromDate, 23)) 
		+ ''', ''' + CONVERT(VARCHAR(50),CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
		PRINT(@StrInsertQuery);
		EXECUTE (@StrInsertQuery);
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseData](MIT_ID, INSTRUMENT_NAME, CurrencyAlias, 
		VestingPeriodId, VestingDate, SchemeTitle,	GrantDate, GrantRegistration, ExercisePrice, EmployeeId, EmployeeName, GrantOpId, STATUS, 
		ExpiryDate, OptionsLapsed, parent, CSFlag) SELECT MIT_ID, INSTRUMENT_NAME, CurrencyAlias, 
		VestingPeriodId, VestingDate, SchemeTitle,	GrantDate, GrantRegistration, ExercisePrice, EmployeeId, EmployeeName, GrantOpId, STATUS, 
		ExpiryDate, OptionsLapsed, parent, CSFlag FROM #LapseDataTemp';
		EXECUTE (@StrInsertQuery);
		PRINT (@StrInsertQuery);
	END
	ELSE
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseData](SchemeTitle,	GrantDate, GrantRegistration, ExercisePrice, EmployeeId, EmployeeName, GrantOpId, STATUS, 
		ExpiryDate, OptionsLapsed, parent, CSFlag) EXECUTE dbo.SP_LAPSE_REPORT ''' + CONVERT(VARCHAR(50), CONVERT (VARCHAR (50), @FromDate, 23)) 
		+ ''', ''' + CONVERT(VARCHAR(50),CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
	END
    
	--EXECUTE (@StrInsertQuery);
    
	DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LapseData] 
			SET FromDate = ''' + CONVERT(VARCHAR(50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + 
			CONVERT(VARCHAR(50),CONVERT (VARCHAR (50), @ToDate, 23)) + ''', 
			PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (50), GetDate(), 121)) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO

