-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09
-- Description:	This procedure brings data from FMVSharePrices and SharePrices tables are inserts it into the respective table at Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_StockPrice')
BEGIN
DROP PROCEDURE SP_StockPrice
END

GO
create    PROCEDURE [dbo].[SP_StockPrice] 
	-- Add the parameters for the stored procedure here
		@DBName VARCHAR(50),
		@LinkedServer VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedFMVSharePrices]';
	EXEC(@ClearDataQuery);

	SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSharePrices]' ;
	EXEC(@ClearDataQuery);

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedFMVSharePrices](FMVPriceID, StockExchange, 
	StockExchangeCode, TransactionDate,	OpenPrice, HighPrice, LowPrice,	PriceDate, ClosePrice, Volume, LastUpdatedBy, LastUpdatedOn)
	(SELECT FMVPriceID, StockExchange, StockExchangeCode, TransactionDate,	OpenPrice, HighPrice, LowPrice,	PriceDate, ClosePrice, Volume, 
	LastUpdatedBy, LastUpdatedOn FROM FMVSharePrices WITH (NOLOCK))';
	EXEC(@StrInsertQuery);

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSharePrices](PriceID, StockExchangeCode, 
	TransactionDate, OpenPrice, HighPrice, LowPrice, PriceDate, ClosePrice, LastUpdatedBy, LastUpdatedOn)
	(SELECT PriceID, StockExchangeCode, TransactionDate, OpenPrice, HighPrice, LowPrice, PriceDate, ClosePrice, LastUpdatedBy, LastUpdatedOn 
	FROM SharePrices WITH (NOLOCK))';
	EXEC(@StrInsertQuery);

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedFMVSharePrices] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);

	 SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedSharePrices] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);
END
GO

