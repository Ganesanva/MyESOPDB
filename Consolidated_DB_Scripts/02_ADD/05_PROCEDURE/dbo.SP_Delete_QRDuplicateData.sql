-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_Delete_QRDuplicateData')
BEGIN
DROP PROCEDURE SP_Delete_QRDuplicateData
END
GO

create    PROCEDURE [dbo].[SP_Delete_QRDuplicateData] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@FromDate DateTime,
	@ToDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
	SET XACT_ABORT ON;
	--DECLARE @DELETEQUERY AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_FINAL_VESTWISE where FromDate = ''' + @FromDate +''' AND ToDate = ''' + @ToDate +'''';
	DECLARE @DELETEQUERY AS VARCHAR (MAX);
	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_CANCELLATIONREPORT where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_EXERCISEREPORT where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_GCR where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_GrantSummaryReport where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_LAPSEDREPORT where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

	SET @DELETEQUERY = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].DW_VESTWISEREPORT where 
	FromDate = ''' +  CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) +''' AND 
	ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) +'''';
	PRINT @DELETEQUERY;
	EXECUTE(@DELETEQUERY);

END
GO

