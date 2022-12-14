/****** Object:  UserDefinedFunction [dbo].[FN_GET_CLOSEPRICE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_CLOSEPRICE]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_CLOSEPRICE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_CLOSEPRICE] 
(	
    @TransactionDate DATETIME,
	@StockExchangeSymbol NVARCHAR(15),    
    @PriceConsiderationDay NVARCHAR(15)    
)
RETURNS @CLOSEPRICE_TABLE TABLE 
(
    ClosePrice NUMERIC(18, 2),
    TaxFlag CHAR(1)
)
AS
BEGIN
 
	IF EXISTS(	
				SELECT 
					ClosePrice 
				FROM FMVSharePrices 
				WHERE StockExchange IN ( SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL WHEN 'NSE' THEN 'N' WHEN 'BSE' THEN 'B' WHEN 'NYSE' THEN 'N' ELSE '' END AS StockExchange
										 FROM MST_STOCK_EXCHANGE 
										 WHERE STOCK_EXCHANGE_SYMBOL = @StockExchangeSymbol )            
					AND CONVERT(DATE, TransactionDate) = CONVERT(DATE, @TransactionDate) AND @PriceConsiderationDay = 'Same Day'
			)
	BEGIN
				INSERT INTO @CLOSEPRICE_TABLE (ClosePrice, TaxFlag)
				SELECT TOP 1 
					ClosePrice, 'A' 
				FROM FMVSharePrices 
				WHERE StockExchange IN ( SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL WHEN 'NSE' THEN 'N' WHEN 'BSE' THEN 'B' WHEN 'NYSE' THEN 'N' ELSE '' END AS StockExchange
										 FROM MST_STOCK_EXCHANGE 
										 WHERE STOCK_EXCHANGE_SYMBOL = @StockExchangeSymbol )            
					AND CONVERT(DATE, TransactionDate) = CONVERT(DATE, @TransactionDate)
	END
	ELSE
	BEGIN
				INSERT INTO @CLOSEPRICE_TABLE (ClosePrice, TaxFlag)
				SELECT TOP 1 
					ClosePrice, CASE WHEN @PriceConsiderationDay = 'Same Day' THEN 'T' ELSE 'A' END 
				FROM FMVSharePrices 
				WHERE StockExchange IN ( SELECT TOP 1 CASE STOCK_EXCHANGE_SYMBOL WHEN 'NSE' THEN 'N' WHEN 'BSE' THEN 'B' WHEN 'NYSE' THEN 'N' ELSE '' END AS StockExchange
										 FROM MST_STOCK_EXCHANGE 
										 WHERE STOCK_EXCHANGE_SYMBOL = @StockExchangeSymbol )            
					AND CONVERT(DATE, TransactionDate) < CONVERT(DATE, @TransactionDate) ORDER BY TransactionDate DESC								  
	END
        
	RETURN
END
GO
