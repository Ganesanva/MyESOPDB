/****** Object:  StoredProcedure [dbo].[GetCountryList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetCountryList]
GO
/****** Object:  StoredProcedure [dbo].[GetCountryList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCountryList] 
AS
BEGIN
    SELECT COUNTRYNAME, COUNTRYALIASNAME FROM COUNTRYMASTER ORDER BY COUNTRYNAME ASC
END

GO
