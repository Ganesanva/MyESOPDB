/****** Object:  StoredProcedure [dbo].[PROC_GET_LSTREPORTMASTER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_LSTREPORTMASTER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_LSTREPORTMASTER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_LSTREPORTMASTER]
AS  
BEGIN
   
	SELECT 
		LstReportID, ReportName, Format
	FROM 
		ListingReportMaster
	ORDER BY 
		LstReportID
	
END
GO
