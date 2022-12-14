/****** Object:  StoredProcedure [dbo].[SP_GetAuditTrailOfEmpPaymentConfig]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetAuditTrailOfEmpPaymentConfig]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAuditTrailOfEmpPaymentConfig]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetAuditTrailOfEmpPaymentConfig]
AS
BEGIN
	SELECT 		
		SchemeId AS [Scheme Name],
		CASE WHEN (OldValueOfPaymentModeReq=1) THEN 'Yes' ELSE 'No' END [Old value of Is Payment Required],
		CASE WHEN (NEWValueOfPaymentModeReq=1) THEN 'Yes' ELSE 'No' END [New value of Is Payment Required],		
		NewEffectiveDate AS [Effective Date],
		LastUpdatedBy AS [Updated By],
		LastUpdatedOn AS [Updated On]
	FROM AuditTrailOfSchmePaymentSettings
	order by LastUpdatedOn desc
END
GO
