/****** Object:  StoredProcedure [dbo].[PROC_GetCurrencyDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCurrencyDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCurrencyDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetCurrencyDetails]

AS
BEGIN
	SELECT	
		CurrencyID, CurrencyName, CurrencySymbol, 
		CurrencyAlias, (CONVERT(VARCHAR,CurrencyName) + ' - ' + CONVERT(VARCHAR,CurrencySymbol)) CURRENCY_DESC
	FROM	
		CurrencyMaster
END
GO
