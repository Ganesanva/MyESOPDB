/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_DEMATDETAILS_CMLCOPY]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_DEMATDETAILS_CMLCOPY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_DEMATDETAILS_CMLCOPY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_DEMATDETAILS_CMLCOPY]

AS
BEGIN
	SET NOCOUNT ON;
     SELECT EUD.EmployeeID,UM.UserName,
			CASE 
			   WHEN EUD.DepositoryName='N' THEN 'NSDL'
			   WHEN EUD.DepositoryName='C' THEN 'CDSL'
			   ELSE '' 
			END AS DepositoryName,DepositoryParticipantName,ClientIDNumber,
				 CASE 
						WHEN EUD.DematAccountType='R' THEN 'Repatriable' 
						WHEN EUD.DematAccountType='N' OR EUD.DematAccountType='NR' THEN 'Non-Repatriable'
						WHEN EUD.DematAccountType='A' THEN 'Not Applicable'
			   ELSE '' 
			END AS DematAccountType,DepositoryIDNumber,DPRecord,CMLCOPY,CMLUploadDate FROM Employee_UserDematDetails AS EUD
				 INNER JOIN UserMaster AS UM ON UM.EmployeeId = EUD.EmployeeID  where EUD.CMLUploadStatus='Y' 
			 
	SET NOCOUNT OFF;
END
GO
