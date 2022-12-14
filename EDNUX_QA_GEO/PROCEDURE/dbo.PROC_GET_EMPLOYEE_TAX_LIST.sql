/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_TAX_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_TAX_LIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_TAX_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_TAX_LIST]  
AS  
BEGIN  
  
 SET NOCOUNT ON;   
 SELECT CODE_NAME,  
     CASE WHEN CODE_NAME = 'EMPLOYEE COMPANY LEVEL TAX RATE' THEN 'E'  
     WHEN CODE_NAME = 'EMPLOYEE RESIDENT STATUS TAX RATE' THEN 'ER'  
     WHEN CODE_NAME = 'EMPLOYEE COUNTRY AND STATE LEVEL TAX RATE' THEN 'ES'  
     WHEN CODE_NAME = 'EMPLOYEE COUNTRY LEVEL TAX RATE' THEN 'EC' END AS CODE_VALUE  
 FROM   
  MST_COM_CODE  
 WHERE MCC_ID IN (1051,1053,1055,1057)  
    
SET NOCOUNT OFF;   
END  
GO
