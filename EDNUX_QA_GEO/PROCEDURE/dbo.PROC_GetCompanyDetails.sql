/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCompanyDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetCompanyDetails]
AS
BEGIN
	SET NOCOUNT ON;   
	SELECT 
		CP.CompanyID,isnull(CP.ListedYN,'N') AS ListedYN, ISNULL(CP.CalcPerqtaxYN,'N') AS CalcPerqtaxYN, 
		CM.StockExchangeType 
	FROM 
		CompanyParameters AS CP
		INNER JOIN CompanyMaster AS CM ON CM.CompanyID = CP.CompanyID
END
GO
