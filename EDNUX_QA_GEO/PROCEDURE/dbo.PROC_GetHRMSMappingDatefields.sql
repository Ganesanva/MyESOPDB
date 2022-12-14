/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSMappingDatefields]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetHRMSMappingDatefields]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetHRMSMappingDatefields]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetHRMSMappingDatefields]
	@CompanyID	VARCHAR(100)	
AS
BEGIN   
		DECLARE @SqlString NVARCHAR(1000)
		
		SET @SqlString =  'SELECT HMF.MyESOPsFields ,HMF.InputFields FROM INFORMATION_SCHEMA.COLUMNS C  INNER JOIN ' +
							+  @CompanyID + '..HRMSMappingsFields HMF ON HMF.MyESOPsFields = C.COLUMN_NAME ' +
							+  'WHERE C.TABLE_NAME = ''EMPLOYEEMASTER'' AND C.COLUMN_NAME = HMF.MyESOPsFields AND UPPER(C.DATA_TYPE) = ''DATETIME'''+
							+  'ORDER BY HMF.MyESOPsFields '
		
		EXEC sp_executesql @SqlString, N'@CompanyID VARCHAR(100) output', @CompanyID output
END 
GO
