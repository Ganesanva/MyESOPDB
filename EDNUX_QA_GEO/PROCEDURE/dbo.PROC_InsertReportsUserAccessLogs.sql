/****** Object:  StoredProcedure [dbo].[PROC_InsertReportsUserAccessLogs]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertReportsUserAccessLogs]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertReportsUserAccessLogs]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*/
--Created By:- Prachi
--Created Date:- 03 June 2021
--Description :- Insert All reports access logs
--*/

CREATE   PROCEDURE [dbo].[PROC_InsertReportsUserAccessLogs]
 
@UserId  VARCHAR(50),   
@UserName    VARCHAR(50),   
@ReportName  VARCHAR(50),   
@FileName VARCHAR(50),   
@IPAddress  VARCHAR(50)    



AS 
  BEGIN 

  Insert into AllReportsUserAccessLogs(UserId,UserName,ReportName,DateandTime,IPAddress,[FileName])
  values(@UserId,@UserName,@ReportName,GETDATE(),@IPAddress,@FileName)


  END
GO
