/****** Object:  StoredProcedure [dbo].[CapitalGainTaxAuditTrailReport]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CapitalGainTaxAuditTrailReport]
GO
/****** Object:  StoredProcedure [dbo].[CapitalGainTaxAuditTrailReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*--------------------------------------------------------------------------------------
Create By:   Omprakash katre
Create Date: 27-Feb-2013
Description: CGT Audit Trail report
exec CapitalGainTaxAuditTrailReport
--------------------------------------------------------------------------------------*/

CREATE PROC [dbo].[CapitalGainTaxAuditTrailReport]

AS
BEGIN

SELECT CGT_SETTINGS_ID,   
       CASE WHEN cgt_settings_at='C' THEN 'Company Level' ELSE 'Employee Level' END as CGT_SETTINGS_At,  
       --Cast(RI_STCG_RATE_WPAN AS nvarchar(max)) + CAST(RI_STCG_RATE_WOPAN AS nvarchar(max)) + CAST(RI_LTCG_RATE AS nvarchar(max)) + CAST((Select dbo.FN_ConvertAliseToActualField(cgt_ri_cgt_formula)) AS nvarchar(max)) AS 'Resident_Indian',  
       'Resident Indian' AS 'Resident_Indian',  
       RI_STCG_RATE_WPAN,   
       RI_STCG_RATE_WOPAN,  
       RI_LTCG_RATE,   
       (Select dbo.FN_ConvertAliseToActualField(cgt_ri_cgt_formula)) as RI_CGT_FORMULA,   
       NRI_STCG_RATE_WPAN,  
       NRI_STCG_RATE_WOPAN,   
       NRI_LTCG_RATE,   
       'Non-Resident Indian' AS 'Non-Resident_Indian',  
       (Select dbo.FN_ConvertAliseToActualField(nri_cgt_formula)) as NRI_CGT_FORMULA,   
       FN_STCG_RATE_WPAN,    
       FN_STCG_RATE_WOPAN,  
       FN_LTCG_RATE,          
       'Foreign National' AS 'Foreign National',  
       (Select dbo.FN_ConvertAliseToActualField(fn_cgt_formula)) as FN_CGT_FORMULA,          
       CGV_FOR_DECIMAL_UPTO,   
       SHORT_CGT_RATE_DECIMAL_UPTO,   
       LONG_CGT_RATE_DECIMAL_UPTO,   
       CASE WHEN CGV_FOR_ROUNDING_TYPE = 'N' THEN 'Normal' WHEN CGV_FOR_ROUNDING_TYPE = 'F' THEN 'Floor' WHEN CGV_FOR_ROUNDING_TYPE = 'C' THEN 'Ceiling' ELSE '' END AS CGV_FOR_ROUNDING_TYPE,   
       CASE WHEN SHORT_CGT_RATE_ROUNDING_TYPE = 'N' THEN 'Normal' WHEN SHORT_CGT_RATE_ROUNDING_TYPE = 'F' THEN 'Floor' WHEN SHORT_CGT_RATE_ROUNDING_TYPE = 'C' THEN 'Ceiling' ELSE '' END AS SHORT_CGT_RATE_ROUNDING_TYPE,   
       CASE WHEN LONG_CGT_RATE_ROUNDING_TYPE = 'N' THEN 'Normal' WHEN LONG_CGT_RATE_ROUNDING_TYPE = 'F' THEN 'Floor' WHEN LONG_CGT_RATE_ROUNDING_TYPE = 'C' THEN 'Ceiling' ELSE '' END AS LONG_CGT_RATE_ROUNDING_TYPE,                  
       LASTUPDATED_BY,   
       LASTUPDATED_ON,   
       APPLICABLE_FROM   
FROM   cgt_settings  order by LastUpdated_On  desc  

End
GO
