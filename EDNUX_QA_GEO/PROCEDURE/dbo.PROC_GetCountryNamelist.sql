/****** Object:  StoredProcedure [dbo].[PROC_GetCountryNamelist]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCountryNamelist]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCountryNamelist]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetCountryNamelist]
AS
BEGIN
    SELECT CountryName, CountryAliasName FROM CountryMaster WHERE IsSelected = 1 
END
GO
