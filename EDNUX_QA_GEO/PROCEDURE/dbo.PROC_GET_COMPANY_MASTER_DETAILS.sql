/****** Object:  StoredProcedure [dbo].[PROC_GET_COMPANY_MASTER_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_COMPANY_MASTER_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_COMPANY_MASTER_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [dbo].[PROC_GET_COMPANY_MASTER_DETAILS]
	
AS
BEGIN

	SET NOCOUNT ON;	
						
		SELECT 
			CP.CompanyID, ISNULL(FBTTravelInfoYN,'N') AS FBTTravelInfoYN, ISNULL(BeforeVestDateYN,'N') AS BeforeVestDateYN, 
			ISNULL(BeforeExpirtyDateYN,'N') AS BeforeExpirtyDateYN, ISNULL(Apply_Fifo,'N') AS FIFO, ListingDate, ISNULL(ListedYN,'N') AS ListedYN,  
			ISNULL(CalcPerqtaxYN,'N') AS CalcPerqtaxYN, ISNULL(CDSLSettings,'1') AS CDSLSettings, ISNULL(CM.IsPUPEnabled,0) AS IsPUPEnabled,  
			CM.DisplayAs AS DisplayAs, CurM.CurrencyName, CurM.CurrencySymbol, CurM.CurrencyAlias, CM.IS_ADS_ENABLED, CM.IsListingEnabled, 
			ISNULL(CM.IS_EGRANTS_ENABLED,0) AS IS_EGRANTS_ENABLED, CM.StockExchangeType, CM.CompanyName, ISNULL(CM.IS_CONSENT_SET,0) AS IS_CONSENT_SET, 
			CM.CONSENT_MESSAGE, ISNULL(CM.AuthenticationModeID,0) AS AuthenticationModeID,
			RoundupPlace_FMV,RoundupPlace_TaxAmt,RoundupPlace_TaxableVal,RoundupPlace_ExercisePrice,RoundupPlace_ExerciseAmount
		FROM CompanyParameters CP 
		INNER JOIN CompanyMaster AS CM ON CM.CompanyID = CP.CompanyID
		INNER JOIN CurrencyMaster AS CurM ON CM.BaseCurrencyID = CurM.CurrencyID					
		
	SET NOCOUNT OFF;  
   
END  
GO
