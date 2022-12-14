/****** Object:  StoredProcedure [dbo].[PROC_GetFMVTrendRptData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetFMVTrendRptData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetFMVTrendRptData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetFMVTrendRptData]
AS

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @FromDate DATETIME, @ToDate   DATETIME
			SET @FromDate = DATEADD(YEAR, -2, GETDATE());
			SET @ToDate = GETDATE();
	SELECT 
		CONVERT(VARCHAR, CONVERT(MONEY, FMV), 1) AS FMV, 
		FMV_FromDate AS FMV_FromDate,
		FMV_ToDate AS FMV_ToDate,
		CUM.CurrencyAlias As CurrencyAlias
	FROM 
		FMVForUnlisted
		CROSS JOIN CompanyMaster COM 
		INNER JOIN CurrencyMaster CUM ON COM.BaseCurrencyID = CUM.CurrencyID
	WHERE 
		(CONVERT(DATE,FMV_FromDate) >= CONVERT(DATE,@FromDate) AND CONVERT(DATE,FMV_Todate) <= CONVERT(DATE,@ToDate) ) OR ( CONVERT(DATE,FMV_Todate) >= CONVERT(DATE,@FromDate) AND CONVERT(DATE,FMV_FromDate )<= CONVERT(DATE,@ToDate))
	ORDER BY 
		CONVERT(DATE,FMV_FromDate) ASC
			
	SET NOCOUNT OFF;
END
GO
