/****** Object:  StoredProcedure [dbo].[PROC_GET_RS_DOWNLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_RS_DOWNLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_RS_DOWNLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_RS_DOWNLOAD]
@ReportPath VARCHAR(200),
@CompanyID VARCHAR(100)
AS  
BEGIN
	SELECT 
		RSID,
		RS.ScheRptID,
		CompanyID,
		CONVERT(VARCHAR(12),CONVERT(DATE,FromDate)) AS FromDate,
		CONVERT(VARCHAR(12),CONVERT(DATE,ToDate)) AS ToDate,
		CONVERT(VARCHAR(12),CONVERT(DATE,ScheduleDate)) AS ScheduleDate,
		RS.SubScriptionID,
		MailExecStatus,
		S.ReportName + SPACE(2) + ' (' + REPLACE(CONVERT(VARCHAR(12),CONVERT(DATE,FromDate),106),' ','/') + ' TO ' + REPLACE(CONVERT(VARCHAR(12),CONVERT(DATE,ToDate),106),' ','/') + ')'  AS ReportName,
		S.ReportName + SPACE(2) + ' (' + REPLACE(CONVERT(VARCHAR(12),CONVERT(DATE,FromDate),106),' ','_') + ' TO ' + REPLACE(CONVERT(VARCHAR(12),CONVERT(DATE,ToDate),106),' ','_') + ')' + REPLACE(S.DownloadReportExcel, substring(S.DownloadReportExcel, 0, CHARINDEX ('.',S.DownloadReportExcel, 1)), '') AS DownloadPath,		
		RS.ScheduleDetails
	FROM ReportSchDetails RS 
	INNER JOIN SchReportMaster S ON RS.ScheRptID=S.ScheRptID 
	WHERE S.ActiveStatus=1 AND CompanyID=@CompanyID AND MailExecStatus = 1
END
GO
