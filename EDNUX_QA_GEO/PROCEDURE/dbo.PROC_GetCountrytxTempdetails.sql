/****** Object:  StoredProcedure [dbo].[PROC_GetCountrytxTempdetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCountrytxTempdetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCountrytxTempdetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetCountrytxTempdetails]
AS
BEGIN

SELECT 
	CountryName,
    NULL AS Employeetaxrate,
    NULL AS EmployeeSSrate,
    NULL AS MaximumemployeeSScapping,
    NULL AS Companytaxrate,
    NULL AS EmployerSSrate,
    NULL AS MaximumemployerSScapping,
    NULL AS Remarks,
    NULL AS EDUploadStatus,
    NULL AS EDRemarks 
FROM 
    CountryMaster 
WHERE 
    IsSelected = 1
     
END
GO
