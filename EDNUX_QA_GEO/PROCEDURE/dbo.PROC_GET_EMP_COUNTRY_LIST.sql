/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_COUNTRY_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMP_COUNTRY_LIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMP_COUNTRY_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMP_COUNTRY_LIST] 
AS
BEGIN
   
	SET NOCOUNT ON;
   
	SELECT 
		CM.CountryName AS FIELD_NAME, 
		dbo.FN_GET_STATES_BY_COUNTRY(CM.ID) AS FIELD_VALUE, 
		CM.ID AS MLFN_ID  
	FROM 
		CountryMaster AS CM 
	WHERE 
		IsSelected = 1 
		
	SET NOCOUNT OFF;
	
END
GO
