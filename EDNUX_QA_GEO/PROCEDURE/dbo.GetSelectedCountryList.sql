/****** Object:  StoredProcedure [dbo].[GetSelectedCountryList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetSelectedCountryList]
GO
/****** Object:  StoredProcedure [dbo].[GetSelectedCountryList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************
Created By   :  Omprakash katre
Created Date :  9-Aug-2013
Description  :  Get selected Country list with Country Alias Name
************************************************************************************/

CREATE PROCEDURE [dbo].[GetSelectedCountryList] 
AS
BEGIN
    SELECT CountryName,CountryAliasName FROM CountryMaster WHERE IsSelected=1
	SELECT CountryName,CountryAliasName,Category FROM CountryMaster AS EUCountry where IsSelected=1 AND Category = 'EU'
	SELECT CountryName,CountryAliasName,Category FROM CountryMaster AS NonEUCountry where IsSelected=1 AND Category ='NonEU'
END
GO
