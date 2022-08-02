--------------------------------------------------------------
--Author       : Vairavan A
--Project      : All databases should have the exact same schema as the master DB (EDNUX_QA)
--Create date  : 08-07-2022
--Description  : Drop Scripts for Additional objects in DB - Udaan_Geo1
--------------------------------------------------------------

Set Nocount OFF

---Table Drop scripts
DROP TABLE  IF EXISTS EMPLOYEEMASTER_QA
GO

DROP TABLE  IF EXISTS EmployeeMaster_QAHistory
GO

DROP TABLE  IF EXISTS TEMP_GET_TAXDETAILS
GO

DROP TABLE  IF EXISTS TEMP_SAR_SETTLEMENT_FINAL_DETAILS
GO

DROP TABLE  IF EXISTS TEMP_STOCK_APPRECIATION_DETAILS
GO

---Procedure Drop scripts
DROP PROCEDURE IF EXISTS [dbo].[TEMP_SAR_SETTLEMENT_FINAL_DETAILS]
GO

DROP PROCEDURE IF EXISTS [dbo].[Proc_Check_Targate_Count]
GO

DROP PROCEDURE IF EXISTS [dbo].[Proc_Check_Targate_Delete]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_GETEMPWISEDocuments]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_REVERSE_EXERCISE_FOR_PREVESTING_MODIFY_OPERATION]
GO


Set Nocount ON
