/****** Object:  StoredProcedure [dbo].[PROC_GetAllSharePrices]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetAllSharePrices]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetAllSharePrices]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modified By:  Naim Shaikh.
-- Create date: 14-07-2014
-- Description:	This SP is used to retrieve all share prices
-- Example Query: EXEC PROC_GetAllSharePrices @StockExchange='B'
-- =============================================
CREATE PROCEDURE [dbo].[PROC_GetAllSharePrices] @StockExchange CHAR
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

		IF EXISTS(SELECT 1 FROM CompanyParameters WHERE UPPER(ListedYN)  = 'Y')
		BEGIN		
			SELECT *
				,CONVERT(VARCHAR(9), PriceDate, 6) AS DATE
			FROM FMVSharePrices
			WHERE DATEDIFF(DAY, PriceDate, GETDATE()) < 90
					AND StockExchange = @StockExchange	 
		END
		ELSE		BEGIN
			DECLARE 
				@FromDate DATETIME, 
				@ToDate   DATETIME
			
				SET @FromDate = DATEADD(YEAR, -2, GETDATE());
				SET @ToDate = GETDATE();		
				
			SELECT 
				CONVERT(VARCHAR, CONVERT(MONEY, FMV), 1) AS ClosePrice, 
				CONVERT(DATE, FMV_FromDate)AS DATE 
			FROM 
				FMVForUnlisted
				WHERE (CONVERT(DATE,FMV_FromDate) >= CONVERT(DATE,@FromDate) AND CONVERT(DATE,FMV_Todate) <= CONVERT(DATE,@ToDate) ) OR ( CONVERT(DATE,FMV_Todate) >= CONVERT(DATE,@FromDate) AND CONVERT(DATE,FMV_FromDate )<= CONVERT(DATE,@ToDate))
		END
	SET NOCOUNT OFF;
END
GO
