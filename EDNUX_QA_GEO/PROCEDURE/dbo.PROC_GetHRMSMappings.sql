/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSMappings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetHRMSMappings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSMappings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetHRMSMappings]
	@MAPPING_TYPE VARCHAR(15)
AS
BEGIN
	IF(UPPER(@MAPPING_TYPE) = 'MAPPINGTYPEFLD')	
	BEGIN
	
		SELECT 
			HM.HRMSMappingsFldID, IsAuditMaintained, MyESOPsFields, InputFields, 0 IsDeleted,
			DT.DATA_TYPE AS DataTypeName, HM.UpdatedBy, HM.UpdatedOn
		
		FROM HRMSMappingsFields HM
		INNER JOIN 
		(	SELECT SYSCOL.NAME COLUMN_NAME, SYSTYP.NAME DATA_TYPE 
			FROM SYS.COLUMNS SYSCOL 
			INNER JOIN SYS.TABLES SYSTAB ON SYSCOL.OBJECT_ID = SYSTAB.OBJECT_ID 
			INNER JOIN SYS.TYPES SYSTYP ON SYSTYP.SYSTEM_TYPE_ID = SYSCOL.SYSTEM_TYPE_ID
			WHERE SYSTAB.NAME = 'EMPLOYEEMASTER' AND SYSTYP.NAME <> 'sysname'
		) DT
		ON HM.MyESOPsFields = DT.COLUMN_NAME ORDER BY HM.HRMSMappingsFldID
	END
	
	ELSE IF (UPPER(@MAPPING_TYPE) = 'MAPPINGTYPEVAL')
	BEGIN
		SELECT 
			HM.HRMSMappingsValID, HM.HRMSMappingsFldID, 
			(SELECT MyESOPsFields FROM HRMSMappingsFields WHERE HRMSMappingsFldID = HM.HRMSMappingsFldID) AS  HRMSMappingsFldName, 
			MyESOPsValue, MyESOPsActualMappedValue, InputValue, 0 IsDeleted,
			HM.UpdatedBy, HM.UpdatedOn
	
		FROM HRMSMappingsValues HM
		ORDER BY HM.HRMSMappingsValID
	END
	
END
GO
