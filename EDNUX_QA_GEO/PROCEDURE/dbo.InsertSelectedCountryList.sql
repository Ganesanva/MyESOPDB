/****** Object:  StoredProcedure [dbo].[InsertSelectedCountryList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[InsertSelectedCountryList]
GO
/****** Object:  StoredProcedure [dbo].[InsertSelectedCountryList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************************************************************************************
Created By   :  Omprakash katre
Created Date :  8-Aug-2013
Description  :  Insert selected country list and UnSelected Country list 
exec InsertSelectedCountryList 'AFG,AGO,AIA,ALA,ALB,AND'
************************************************************************************/

CREATE PROCEDURE [dbo].[InsertSelectedCountryList]
(
  @SelectedCountryList VARCHAR(Max)
) 
AS
BEGIN
    --Update all country list 
    UPDATE CountryMaster SET IsSelected=0  
     
    --Update the Selected Country list
    UPDATE CountryMaster SET IsSelected=1 WHERE CountryAliasName in (SELECT rtrim(ltrim(Param)) FROM fn_MVParam(@SelectedCountryList,','))  
END

GO
