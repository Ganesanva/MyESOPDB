/****** Object:  StoredProcedure [dbo].[PROC_KOTAK_MIS_WEB_API_AUDITRAIL]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_KOTAK_MIS_WEB_API_AUDITRAIL]
GO
/****** Object:  StoredProcedure [dbo].[PROC_KOTAK_MIS_WEB_API_AUDITRAIL]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_KOTAK_MIS_WEB_API_AUDITRAIL]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT GrantType,Identifier,ReferenceNumber,ReferenceDate,CompanyCode,EmployeeID,CheckSumID,GrantOptionID,FromGrantDate,ToGrantDate,FromExerciseDate,
		   ToExerciseDate,RequestXMLFile,RequestDateTime,ResponseXMLFile,ResponseDateTime,HttpRequestFile,HttpRespnoseFile
	FROM (SELECT GrantType,Identifier,ReferenceNumber,ReferenceDate,CompanyCode,EmployeeID,CheckSumID,GrantOptionID,FromGrantDate,ToGrantDate,FromExerciseDate,
		         ToExerciseDate,RequestXMLFile,RequestDateTime,ResponseXMLFile,ResponseDateTime,HttpRequestFile,HttpRespnoseFile
		  FROM APIRequestResponseDetails
		  UNION ALL
		  SELECT GrantType,Identifier,ReferenceNumber,ReferenceDate,CompanyCode,EmployeeID ,CheckSumID,GrantOptionID,FromGrantDate,ToGrantDate,
				 FromExerciseDate,ToExerciseDate,RequestXMLFile,RequestDateTime,ResponseXMLFile,ResponseDateTime,HttpRequestFile,HttpRespnoseFile
		  FROM InvalidAPIRequestResponseDetails) TEMP 
	ORDER BY  TEMP.RequestDateTime
	SET NOCOUNT OFF;
END
 

 
GO
