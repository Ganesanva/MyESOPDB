-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-05
-- Description:	Extracts the data from GetCancellationDetails procedure and dumps it into CancellationData on Linked Server
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_Cancellation_Report')
BEGIN
DROP PROCEDURE SP_Cancellation_Report
END
GO

CREATE    PROCEDURE [dbo].[SP_Cancellation_Report] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR (50), @LinkedServer VARCHAR (50), @FromDate DATETIME, @ToDate DATETIME, @ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    --SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[CancellationData]';
    EXECUTE (@ClearDataQuery);
	IF(@ESOPVersion = 'Global')
	BEGIN
	CREATE TABLE #CancellationDataTemp
	(
	[Expr1] [numeric](18, 0) NULL,
	[GrantOptionId] [varchar](100) NULL,
	[INSTRUMENT_NAME] [nvarchar](500) NULL,
	[ExercisePrice] [numeric](18, 2) NULL,
	[CurrencyName] [varchar](50) NULL,
	[CurrencyAlias] [varchar](50) NULL,
	[GrantDate] [datetime] NULL,
	[VestID] [decimal](10, 0) NULL,
	[VestingDate] [datetime] NULL,
	[FinalVestingDate] [datetime] NULL,
	[FinalExpirayDate] [datetime] NULL,
	[ExpirayDate] [datetime] NULL,
	[CancelledDate] [datetime] NULL,
	[Expr2] [varchar](100) NULL,
	[EmployeeID] [varchar](20) NULL,
	[EmployeeName] [varchar](75) NULL,
	[DateOfTermination] [datetime] NULL,
	[SchemeTitle] [varchar](50) NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[OptionRatioDivisor] [numeric](18, 0) NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NULL,
	[CancelledQuantity] [numeric](18, 0) NULL,
	[CancellationReason] [varchar](100) NULL,
	[Status] [varchar](50) NULL,
	[VestedUnVested] [varchar](50) NULL,
	[OptionsCancelled] [numeric](18, 0) NULL,
	[Flag] [char](1) NULL,
	[Note] [varchar](100) NULL
	);


		SET @StrInsertQuery = 'INSERT INTO #CancellationDataTemp
					(Expr1, GrantOptionId, INSTRUMENT_NAME, ExercisePrice, CurrencyName, CurrencyAlias, GrantDate, VestID, VestingDate, FinalVestingDate,
					FinalExpirayDate, ExpirayDate, CancelledDate, Expr2, EmployeeID, EmployeeName, DateOfTermination, SchemeTitle,
					GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, GrantLegSerialNumber, CancelledQuantity,
					CancellationReason, Status, VestedUnVested, OptionsCancelled, Flag, Note)
					EXECUTE dbo.GetCancellationDetails ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
					PRINT (@StrInsertQuery);
					EXECUTE (@StrInsertQuery);
					SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[CancellationData]
					(Expr1, GrantOptionId, INSTRUMENT_NAME, ExercisePrice, CurrencyName, CurrencyAlias, GrantDate, VestID, VestingDate, FinalVestingDate,
					FinalExpirayDate, ExpirayDate, CancelledDate, Expr2, EmployeeID, EmployeeName, DateOfTermination, SchemeTitle,
					GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, GrantLegSerialNumber, CancelledQuantity,
					CancellationReason, Status, VestedUnVested, OptionsCancelled, Flag, Note)
					SELECT Expr1, GrantOptionId, INSTRUMENT_NAME, ExercisePrice, CurrencyName, CurrencyAlias, GrantDate, VestID, VestingDate, FinalVestingDate,
					FinalExpirayDate, ExpirayDate, CancelledDate, Expr2, EmployeeID, EmployeeName, DateOfTermination, SchemeTitle,
					GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, GrantLegSerialNumber, CancelledQuantity,
					CancellationReason, Status, VestedUnVested, OptionsCancelled, Flag, Note FROM #CancellationDataTemp';
	PRINT (@StrInsertQuery);
	EXECUTE (@StrInsertQuery);
	
	END
	ELSE
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[CancellationData]
					(Expr1, GrantOptionId, GrantDate, VestingDate, FinalVestingDate, FinalExpirayDate, ExpirayDate, CancelledDate, Expr2, EmployeeID, 
					EmployeeName, DateOfTermination, SchemeTitle,	GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, 
					GrantLegSerialNumber, CancelledQuantity, CancellationReason,	Status, VestedUnVested, OptionsCancelled, Flag, Note)
					EXECUTE dbo.GetCancellationDetails ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
	END
	--SET XACT_ABORT ON;
	--EXECUTE (@StrInsertQuery);
	--PRINT('Insert Complete');
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[CancellationData] 
	 SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', 
	 ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''', 
	 PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (50), GetDate(), 121)) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO

