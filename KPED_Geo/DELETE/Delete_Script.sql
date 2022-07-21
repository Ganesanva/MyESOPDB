--------------------------------------------------------------
--Author       : Vairavan A
--Project      : All databases should have the exact same schema as the master DB (EDNUX_QA)
--Create date  : 07-07-2022
--Description  : Drop Scripts for Additional objects in DB - KPED_Geo
--------------------------------------------------------------

Set Nocount OFF

IF object_id('EMPLOYEEMASTER_QA','U')	is not null  and 
OBJECTPROPERTY(OBJECT_ID('EMPLOYEEMASTER_QA'), 'TableTemporalType') = 2 
begin 
ALTER TABLE dbo.EMPLOYEEMASTER_QA SET (SYSTEM_VERSIONING = OFF)
end 
go

IF object_id('EmployeeMaster_QAHistory','U')	is not null  and 
OBJECTPROPERTY(OBJECT_ID('EmployeeMaster_QAHistory'), 'TableTemporalType') = 2 
begin
ALTER TABLE dbo.EmployeeMaster_QAHistory SET (SYSTEM_VERSIONING = OFF)
end 
go

---Table Drop scripts
DROP TABLE  IF EXISTS EMPLOYEEMASTER_QA
GO

DROP TABLE  IF EXISTS EmployeeMaster_QAHistory
GO

DROP TABLE  IF EXISTS FMVSharePricesTest
GO

DROP TABLE  IF EXISTS SharePricesTest
GO

DROP TABLE  IF EXISTS TEMP_GET_TAXDETAILS
GO

DROP TABLE  IF EXISTS TEMP_STOCK_APPRECIATION_DETAILS
GO

---Procedure Drop scripts
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_DETAILS]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_UserList]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_GETEMPWISEDocuments]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_REVERSE_EXERCISE_FOR_PREVESTING_MODIFY_OPERATION]
GO


Set Nocount ON
