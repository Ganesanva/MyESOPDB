/****** Object:  StoredProcedure [dbo].[PROC_GetEmpBrokerDtls]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmpBrokerDtls]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmpBrokerDtls]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_GetEmpBrokerDtls]
as 

SELECT 
	emp.EmployeeID AS [Employee Id], 
	emp.EmployeeName AS [Employee Name],
	emp.EmployeeEmail AS [Email Id],
	emp.BROKER_DEP_TRUST_CMP_NAME AS [BrokerCompanyName],
	emp.BROKER_DEP_TRUST_CMP_ID AS [BrokerCompanyID],
	emp.BROKER_ELECT_ACC_NUM AS [BrokerElectAccountNo]
FROM 
	EmployeeMaster emp
WHERE 
	emp.DateOfTermination IS NULL 
	AND emp.[ReasonForTermination] IS NULL
	AND emp.LWD IS NULL 
 	AND emp.Deleted=0
GO
