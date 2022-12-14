/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForHRMS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AuditTrailForHRMS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AuditTrailForHRMS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_AuditTrailForHRMS]
AS
BEGIN
	SELECT 
		HATR.EmployeeID, HMFLD.MyESOPsFields , HMFLD.InputFields , HATR.OldValue , HATR.NewValue , HATR.UpdatedOn
	FROM 
		HRMSMappingsFields HMFLD
		INNER JOIN HRMSAuditTrails HATR ON HMFLD.HRMSMappingsFldID = HATR.HRMSMappingsFldID
	GROUP BY	
		HATR.EmployeeID, HMFLD.MyESOPsFields , HMFLD.InputFields , HATR.OldValue , HATR.NewValue , HATR.UpdatedOn
	ORDER BY   
		HATR.UpdatedOn DESC	
END
GO
