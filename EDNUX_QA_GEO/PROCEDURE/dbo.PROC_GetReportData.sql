/****** Object:  StoredProcedure [dbo].[PROC_GetReportData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetReportData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetReportData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetReportData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @pt INT
	DECLARE @et CHAR
	DECLARE @RoundupPlace_FMV VARCHAR(5), @RoundingParam_FMV VARCHAR(5)
	SELECT @RoundingParam_FMV = RoundingParam_FMV,@RoundupPlace_FMV = RoundupPlace_FMV FROM CompanyParameters


	SET @pt = (
			SELECT PreqTax_Shareprice
			FROM CompanyParameters
			)
	SET @et = (
			SELECT PreqTax_ExchangeType
			FROM CompanyParameters
			)

	IF @pt = 1
		SELECT T1.TransactionDate
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.OpenPrice), 1) AS OPN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.ClosePrice), 1) AS CLN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.LowPrice), 1) AS LPN
 			,CONVERT(VARCHAR, CONVERT(MONEY, T1.HighPrice), 1) AS HPN
			,Cast(T1.Volume AS INT) AS vn
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.OpenPrice), 1) AS OPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.ClosePrice), 1) AS CPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.LowPrice), 1) AS LPB
 			,CONVERT(VARCHAR, CONVERT(MONEY, T2.HighPrice), 1) AS HPB
			,Cast(T2.Volume AS INT) AS VB
			,CASE @et
				WHEN 'N'
					THEN Cast(T1.ClosePrice AS DECIMAL(18, 6))
				ELSE Cast(T2.ClosePrice AS DECIMAL(18, 6))
				END AS FMV
		FROM (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume				
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE Datediff(day, T1.TransactionDate, Getdate()) < 15
	ELSE IF @pt = 2
		SELECT T1.TransactionDate
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.OpenPrice), 1) AS OPN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.ClosePrice), 1) AS CLN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.LowPrice), 1) AS LPN
 			,CONVERT(VARCHAR, CONVERT(MONEY, T1.HighPrice), 1) AS HPN			
			,Cast(T1.Volume AS INT) AS vn
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.OpenPrice), 1) AS OPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.ClosePrice), 1) AS CPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.LowPrice), 1) AS LPB
 			,CONVERT(VARCHAR, CONVERT(MONEY, T2.HighPrice), 1) AS HPB			
			,Cast(t2.Volume AS INT) AS VB
			,CASE @et
				WHEN 'N'
					THEN dbo.FN_PQ_TAX_ROUNDING(dbo.FN_ROUND_VALUE(((T1.ClosePrice + T1.OpenPrice)/2), @RoundingParam_FMV, @RoundupPlace_FMV))
				ELSE dbo.FN_PQ_TAX_ROUNDING(dbo.FN_ROUND_VALUE(((T2.ClosePrice + T2.OpenPrice)/2), @RoundingParam_FMV, @RoundupPlace_FMV))
				END AS FMV
		FROM (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE Datediff(day, T1.TransactionDate, Getdate()) < 15
	ELSE IF @pt = 3
		SELECT T1.TransactionDate
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.OpenPrice), 1) AS OPN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.ClosePrice), 1) AS CLN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.LowPrice), 1) AS LPN
 			,CONVERT(VARCHAR, CONVERT(MONEY, T1.HighPrice), 1) AS HPN						
			,Cast(T1.Volume AS INT) AS vn
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.OpenPrice), 1) AS OPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.ClosePrice), 1) AS CPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.LowPrice), 1) AS LPB
 			,CONVERT(VARCHAR, CONVERT(MONEY, T2.HighPrice), 1) AS HPB			
			,Cast(T2.Volume AS INT) AS VB
			,CASE 
				WHEN T1.Volume > T2.Volume
					THEN T1.ClosePrice
				ELSE T2.ClosePrice
				END AS FMV
		FROM (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice				
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE Datediff(day, T1.TransactionDate, Getdate()) < 15
	ELSE IF @pt = 4
		SELECT T1.transactiondate
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.OpenPrice), 1) AS OPN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.ClosePrice), 1) AS CLN
			,CONVERT(VARCHAR, CONVERT(MONEY, T1.LowPrice), 1) AS LPN
 			,CONVERT(VARCHAR, CONVERT(MONEY, T1.HighPrice), 1) AS HPN			
			,Cast(T1.Volume AS INT) AS vn
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.OpenPrice), 1) AS OPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.ClosePrice), 1) AS CPB
			,CONVERT(VARCHAR, CONVERT(MONEY, T2.LowPrice), 1) AS LPB
 			,CONVERT(VARCHAR, CONVERT(MONEY, T2.HighPrice), 1) AS HPB			
			,Cast(T2.Volume AS INT) AS VB
			,CASE 
				WHEN T1.volume > T2.volume
					THEN dbo.FN_PQ_TAX_ROUNDING(dbo.FN_ROUND_VALUE(((T1.ClosePrice + T1.OpenPrice)/2), @RoundingParam_FMV, @RoundupPlace_FMV))
				ELSE dbo.FN_PQ_TAX_ROUNDING(dbo.FN_ROUND_VALUE(((T2.ClosePrice + T2.OpenPrice)/2), @RoundingParam_FMV, @RoundupPlace_FMV))
				END AS FMV
		FROM (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice				
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,OpenPrice
				,ClosePrice
				,Volume
				,LowPrice
				,HighPrice
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE Datediff(day, T1.TransactionDate, Getdate()) < 15

	SET NOCOUNT OFF;
END

GO
