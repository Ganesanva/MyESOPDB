
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_User_Login_History_Report')
BEGIN
DROP PROCEDURE SP_User_Login_History_Report
END
GO

create    PROCEDURE [dbo].[SP_User_Login_History_Report]
@DBName VARCHAR (50), @LinkedServer VARCHAR (50), @FromDate DATETIME, @ToDate DATETIME
AS
BEGIN
SET NOCOUNT ON;
DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
EXECUTE (@USEDB);
DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
SET XACT_ABORT ON;
DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[UserLoginHistoryReport]';
EXECUTE (@ClearDataQuery);

CREATE TABLE #UserLoginHistoryReportTemp(
[SN] [varchar](256) NULL,
[UserId] [varchar](20) NULL,
[LoginDate] [datetime] NULL,
[LogOutDate] [datetime] NULL,
[FromDate] [datetime] NULL,
[ToDate] [datetime] NULL,
[PushDate] [datetime] NULL
)



SET @StrInsertQuery = 'INSERT INTO #UserLoginHistoryReportTemp (SN, UserId, LoginDate, LogOutDate)
EXECUTE dbo.PROC_USER_LOGIN_HISTORY_REPORT ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
EXECUTE (@StrInsertQuery);
SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[UserLoginHistoryReport](SN, UserId, LoginDate, LogOutDate)
SELECT SN, UserId, LoginDate, LogOutDate FROM #UserLoginHistoryReportTemp';
EXECUTE (@StrInsertQuery);
DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[UserLoginHistoryReport]
SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + ''',
PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (50), GetDate(), 121)) + '''';
EXECUTE (@StrUpdateQuery);
END
GO

