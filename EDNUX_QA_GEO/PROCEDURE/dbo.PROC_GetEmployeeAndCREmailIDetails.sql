/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeAndCREmailIDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmployeeAndCREmailIDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmployeeAndCREmailIDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetEmployeeAndCREmailIDetails]
(
	@EmployeeID VARCHAR(15)
)
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT 
		EM.EmployeeName, EM.EmployeeEmail, CM.CompanyID, CM.CompanyEmailID, OGAMC.AcceptanceOrRejectionMailToEmp, OGAMC.AcceptanceOrRejectionMailToCR
	FROM 
		EmployeeMaster EM CROSS JOIN CompanyMaster CM CROSS JOIN OGA_CONFIGURATIONS OGAMC
	WHERE EM.EmployeeID = @EmployeeID

END
GO
