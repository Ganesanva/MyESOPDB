/****** Object:  StoredProcedure [dbo].[PROC_GETTRACKMAPPINGSDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETTRACKMAPPINGSDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETTRACKMAPPINGSDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETTRACKMAPPINGSDETAILS]
AS
BEGIN
		SELECT
			  HM.MLFN_ID,
			  HM.FIELD_NAME,
			  (CASE WHEN (UPPER(HM.FIELD_NAME)=UPPER('TAX_IDENTIFIER_COUNTRY')) THEN 'Tax Identifier Country' 
			  	   WHEN (UPPER(HM.FIELD_NAME)=UPPER('TAX_IDENTIFIER_STATE')) THEN 'Tax Identifier State'  
			  ELSE 
				   HM.FIELD_NAME 
         	  END) AS FIELD_DISPLAY_NAME,
			  IS_AUDIT_MAINTAINED,
			  IS_TRACKING_ENABLED,
			  HM.FIELD_NAME, 
			  0 ISDELETED,
			  DT.DATA_TYPE AS DATATYPENAME,
			  HM.UPDATED_BY, 
			  HM.UPDATED_ON,
			  IS_ADD_IN_LIST				
		FROM  MASTER_LIST_FLD_NAME HM
			INNER JOIN 
			(	SELECT SYSCOL.NAME COLUMN_NAME, SYSTYP.NAME DATA_TYPE 
				FROM SYS.COLUMNS SYSCOL 
				INNER JOIN SYS.TABLES SYSTAB ON SYSCOL.OBJECT_ID = SYSTAB.OBJECT_ID 
				INNER JOIN SYS.TYPES SYSTYP ON SYSTYP.SYSTEM_TYPE_ID = SYSCOL.SYSTEM_TYPE_ID
				WHERE SYSTAB.NAME = 'EMPLOYEEMASTER'AND (UPPER(SYSTYP.NAME) <> 'SYSNAME')
			) DT		 
		ON HM.FIELD_NAME = DT.COLUMN_NAME 
		WHERE HM.IS_TRACKING_ENABLED = 1 AND IS_ADD_IN_LIST = 1 
		ORDER BY HM.MLFN_ID
END
GO
