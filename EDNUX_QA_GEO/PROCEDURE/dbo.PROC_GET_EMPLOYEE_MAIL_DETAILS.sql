/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_MAIL_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_MAIL_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_MAIL_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_MAIL_DETAILS]
	@LoginID VARCHAR(50)
	
	 
AS
BEGIN
	

SELECT ConfirmExerciseMailSent,CompanyEmailID,

dbo.[FN_GET_COMPANYMAILSETTINGS](  
					
(CASE  WHEN ( EM.REASONFORTERMINATION IS NULL )OR EM.REASONFORTERMINATION IS NOT NULL AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN
					'L'
                    ELSE 'S'
					END),EM.EmployeeID
					) as EmployeeEmail,

EmployeeName,EmployeeID 
FROM employeemaster em
CROSS JOIN
CompanyParameters cp WHERE Deleted=0 and em.LoginID=@LoginID
	
END
GO
