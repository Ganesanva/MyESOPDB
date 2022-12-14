/****** Object:  StoredProcedure [dbo].[PROC_GetValuesForMappedField]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetValuesForMappedField]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetValuesForMappedField]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GetValuesForMappedField]
	@MyESOPsFields 		AS VARCHAR(100)	
AS
BEGIN
	IF(UPPER(@MyESOPsFields) = 'RESIDENTIALSTATUS')
	BEGIN
		SELECT DESCRIPTION AS VALUE, ResidentialStatus AS MyESOPsActualMappedValue  FROM RESIDENTIALTYPE ORDER BY DESCRIPTION
	END
	ELSE IF(UPPER(@MyESOPsFields) = 'COUNTRYNAME')  
	BEGIN  
		SELECT CountryName AS VALUE, CountryAliasName AS MyESOPsActualMappedValue FROM CountryMaster WHERE IsSelected = 1 ORDER BY CountryName 
	END 
	ELSE
	BEGIN
		SELECT '' AS VALUE, '' AS MyESOPsActualMappedValue
	END
END
GO
