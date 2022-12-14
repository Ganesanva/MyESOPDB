/****** Object:  StoredProcedure [dbo].[PROC_GET_GENERICINFO]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_GENERICINFO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_GENERICINFO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_GENERICINFO]
AS  
BEGIN
   
	SELECT 
		Place,
		KindOfSecurity,
		ISINNumber,
		AuthourizedSignName,
		AuthorizedSingDesig,
		TelephoneNo,
		FaxNumber,
		EmailID,
		(SELECT CompanyName FROM CompanyMaster) AS CompanyName,
		(SELECT CompanyAddress FROM CompanyMaster) AS CompanyAddress
	FROM 
		ListingDocGenericInfo
	
	
END
GO
