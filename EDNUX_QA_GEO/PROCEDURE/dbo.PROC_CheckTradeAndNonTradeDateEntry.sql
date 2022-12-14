/****** Object:  StoredProcedure [dbo].[PROC_CheckTradeAndNonTradeDateEntry]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CheckTradeAndNonTradeDateEntry]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CheckTradeAndNonTradeDateEntry]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_CheckTradeAndNonTradeDateEntry] (@FromDate DATE,@ToDate DATE)
	
AS
BEGIN
	    
	DECLARE @DisplayMessage VARCHAR(100) = 'You can not enter same date in Trading and Non Trading Day' 
	SET NOCOUNT ON;
	
	SELECT	FromDate,
			ToDate,
			CASE 
				WHEN (CONVERT(DATE, @FromDate) = CONVERT(DATE, FromDate) AND CONVERT(DATE, @ToDate) = CONVERT(DATE, ToDate))
					THEN  @DisplayMessage
			END Result 
	INTO #Temp
	FROM ApplicationSupport 
	WHERE ISNonTradingDay='Y'
 
 SELECT Result FROM #Temp WHERE Result IS NOT NULL
 DROP TABLE #Temp 
 
END
GO
