/****** Object:  StoredProcedure [dbo].[Get_AlReportsUserAccessLogs]    Script Date: 7/8/2022 3:00:42 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Get_AlReportsUserAccessLogs]
GO
/****** Object:  StoredProcedure [dbo].[Get_AlReportsUserAccessLogs]    Script Date: 7/8/2022 3:00:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 --*/
--Created By:- Prachi
--Created Date:- 04 June 2021
--Description :- Get All reports access logs
--*/

CREATE   PROCEDURE [dbo].[Get_AlReportsUserAccessLogs]
 
AS 
  BEGIN 

	  SELECT UserId,UserName,ReportName,DateandTime,IPAddress,[FileName] FROM
	  AllReportsUserAccessLogs
  END
GO

