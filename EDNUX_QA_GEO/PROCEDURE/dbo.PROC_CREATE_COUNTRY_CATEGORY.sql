/****** Object:  StoredProcedure [dbo].[PROC_CREATE_COUNTRY_CATEGORY]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CREATE_COUNTRY_CATEGORY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CREATE_COUNTRY_CATEGORY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************
CREATED BY   :  SHAHADATT NAGANE
CREATED DATE :  14-NOVEMBER-2018
DESCRIPTION  :  INSERT SELECTED COUNTRY LIST INTO CATEGORY EX. EUROPEAN COUNTRIES / NON EUROPEAN COUNTRIES
EXEC PROC_CREATE_COUNTRY_CATEGORY 'AFG,AGO,AIA,ALA,ALB,AND','IND','PAK','EU'
************************************************************************************/

CREATE PROCEDURE [dbo].[PROC_CREATE_COUNTRY_CATEGORY]
(
	@EUCountryList VARCHAR(Max),
	@NonEUCountryList VARCHAR(Max),
	@CATEGORY VARCHAR(MAX)
) 
AS
BEGIN
	IF (ISNULL(@EUCountryList,'') IS NOT NULL AND ISNULL(@EUCountryList,'') != '')
	BEGIN
		UPDATE CountryMaster SET CATEGORY='NULL' WHERE CATEGORY !='NonEU'
		UPDATE CountryMaster SET CATEGORY='EU' WHERE CountryAliasName in (SELECT rtrim(ltrim(Param)) FROM fn_MVParam(@EUCountryList,','))
	END
	IF (ISNULL(@NonEUCountryList,'') IS NOT NULL AND ISNULL(@NonEUCountryList,'') != '')
	BEGIN
		UPDATE CountryMaster SET CATEGORY='NULL' WHERE CATEGORY !='EU'
		UPDATE CountryMaster SET CATEGORY='NonEU' WHERE CountryAliasName in (SELECT rtrim(ltrim(Param)) FROM fn_MVParam(@NonEUCountryList,','))
	END
END
GO
