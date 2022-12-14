/****** Object:  StoredProcedure [dbo].[PROC_GetReportData1Yr]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetReportData1Yr]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetReportData1Yr]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetReportData1Yr]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @pt INT

	SET @pt = (
			SELECT PreqTax_Shareprice
			FROM CompanyParameters
			)

	IF @pt = 1
		SELECT CONVERT(VARCHAR(11), T1.TransactionDate, 106) AS DATE
			,convert(VARCHAR, Convert(MONEY, T1.openprice), 1) AS OpeningPriceNSE
			,convert(VARCHAR, Convert(MONEY, T1.closeprice), 1) AS ClosingPriceNSE
			,cast(t1.volume AS INT) AS TradingVolumeNSE
			,convert(VARCHAR, Convert(MONEY, T2.openprice), 1) AS OpeningPriceBSE
			,convert(VARCHAR, Convert(MONEY, T2.closeprice), 1) AS ClosingPriceBSE
			,cast(T2.Volume AS INT) AS TradingVolumeBSE
			,CAST(T1.ClosePrice AS DECIMAL(6, 2)) AS FMV
		FROM (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE DATEDIFF(DAY, T1.TransactionDate, getdate()) < 365
	ELSE IF @pt = 2
		SELECT CONVERT(VARCHAR(11), T1.TransactionDate, 106) AS DATE
			,convert(VARCHAR, Convert(MONEY, T1.openprice), 1) AS OpeningPriceNSE
			,convert(VARCHAR, Convert(MONEY, T1.closeprice), 1) AS ClosingPriceNSE
			,cast(t1.volume AS INT) AS TradingVolumeNSE
			,convert(VARCHAR, Convert(MONEY, T2.openprice), 1) AS OpeningPriceBSE
			,convert(VARCHAR, Convert(MONEY, T2.closeprice), 1) AS ClosingPriceBSE
			,cast(T2.Volume AS INT) AS TradingVolumeBSE
			,CAST((T1.ClosePrice + T1.OpenPrice) / 2 AS DECIMAL(6, 2)) AS FMV
		FROM (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE DATEDIFF(DAY, T1.TransactionDate, getdate()) < 365
	ELSE IF @pt = 3
		SELECT CONVERT(VARCHAR(11), T1.TransactionDate, 106) AS DATE
			,convert(VARCHAR, Convert(MONEY, T1.openprice), 1) AS OpeningPriceNSE
			,convert(VARCHAR, Convert(MONEY, T1.closeprice), 1) AS ClosingPriceNSE
			,cast(t1.volume AS INT) AS TradingVolumeNSE
			,convert(VARCHAR, Convert(MONEY, T2.openprice), 1) AS OpeningPriceBSE
			,convert(VARCHAR, Convert(MONEY, T2.closeprice), 1) AS ClosingPriceBSE
			,cast(T2.Volume AS INT) AS TradingVolumeBSE
			,CASE 
				WHEN T1.Volume > T2.Volume
					THEN T1.ClosePrice
				ELSE T2.ClosePrice
				END AS FMV
		FROM (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE DATEDIFF(DAY, T1.TransactionDate, getdate()) < 365
	ELSE IF @pt = 4
		SELECT CONVERT(VARCHAR(11), T1.TransactionDate, 106) AS DATE
			,convert(VARCHAR, Convert(MONEY, T1.openprice), 1) AS OpeningPriceNSE
			,convert(VARCHAR, Convert(MONEY, T1.closeprice), 1) AS ClosingPriceNSE
			,cast(t1.volume AS INT) AS TradingVolumeNSE
			,convert(VARCHAR, Convert(MONEY, T2.openprice), 1) AS OpeningPriceBSE
			,convert(VARCHAR, Convert(MONEY, T2.closeprice), 1) AS ClosingPriceBSE
			,cast(T2.Volume AS INT) AS TradingVolumeBSE
			,CASE 
				WHEN T1.Volume > T2.Volume
					THEN CAST((T1.ClosePrice + T1.OpenPrice) / 2 AS DECIMAL(6, 2))
				ELSE CAST((T2.ClosePrice + T2.OpenPrice) / 2 AS DECIMAL(6, 2))
				END AS FMV
		FROM (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'N'
			) AS T1
		INNER JOIN (
			SELECT TransactionDate
				,openprice
				,closeprice
				,Volume
			FROM FMVSharePrices
			WHERE StockExchange = 'B'
			) T2 ON T2.TransactionDate = T1.TransactionDate
		WHERE DATEDIFF(DAY, T1.TransactionDate, getdate()) < 365
		order by T1.TransactionDate asc

	SET NOCOUNT OFF;
END
GO
