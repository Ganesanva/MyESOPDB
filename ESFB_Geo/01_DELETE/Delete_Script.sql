--------------------------------------------------------------
--Author       : Vairavan A
--Project      : All databases should have the exact same schema as the master DB (EDNUX_QA)
--Create date  : 12-07-2022
--Description  : Drop Scripts for Additional objects in DB - ESFB_Geo
--------------------------------------------------------------
use ESFB_GEO_14072022;

Set Nocount OFF

---Table Drop scripts
DROP TABLE  IF EXISTS [dbo].[TEMP_FMV_DETAILS]
GO

--Function Drio Scripts 
DROP Function IF EXISTS [dbo].[FN_CHECKIDENTITY]
GO


---Procedure Drop scripts
DROP PROCEDURE IF EXISTS [dbo].[MG_DATA_COMPARE]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_AllTable_Identity_Insert_OffAndON]
GO

DROP PROCEDURE IF EXISTS [dbo].[Proc_Check_Targate_Count]
GO

DROP PROCEDURE IF EXISTS [dbo].[Proc_Check_Targate_Delete]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_ConfigurePersonalDetails_PostScript]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_Exercise_Tax_Details_PostScript]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_ShTransaction_Details_PostScript]
GO

DROP PROCEDURE IF EXISTS [dbo].[PROC_TRANSACTION_EXERCISE_STEPS_PostScript]
GO

DROP PROCEDURE IF EXISTS [dbo].[ST_CHECK_TABLE_DIFF]
GO

DROP PROCEDURE IF EXISTS [dbo].[ST_DATAMIGRATION]
GO

DROP PROCEDURE IF EXISTS [dbo].[ST_TRIGGER_ENABLEORDISABLE]
GO

DROP USER IF EXISTS [MyESOPsENCDB\karuna]
GO

Set Nocount ON
