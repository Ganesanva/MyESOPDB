/****** Object:  StoredProcedure [dbo].[PROC_GetReportData1YrWipro]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetReportData1YrWipro]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetReportData1YrWipro]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetReportData1YrWipro]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CONVERT(VARCHAR(11), T1.TransactionDate, 106) AS Date
		,convert(VARCHAR, Convert(MONEY, T1.openprice), 1) AS Open_Price
		,convert(VARCHAR, Convert(MONEY, T1.closeprice), 1) AS Close_Price
		,convert(VARCHAR, Convert(MONEY, T1.HighPrice), 1) AS HighPrice
		,convert(VARCHAR, Convert(MONEY, T1.LowPrice), 1) AS LowPrice
		,cast(t1.volume AS INT) AS TradingVolume
		,StockExchange
	FROM (
		SELECT TransactionDate
			,openprice
			,closeprice
			,HighPrice
			,LowPrice
			,Volume
			,StockExchange
		FROM FMVSharePrices

		) AS T1
   
	WHERE DATEDIFF(DAY, T1.TransactionDate, getdate()) < 365

	SET NOCOUNT OFF;
END
GO
