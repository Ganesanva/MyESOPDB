/****** Object:  StoredProcedure [dbo].[PROC_CRUDGratLetterTemplate]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDGratLetterTemplate]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDGratLetterTemplate]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUDGratLetterTemplate]
	@Type				VARCHAR(10) = NULL,
	@TemplateName		VARCHAR(50) = NULL,
	@Subject			VARCHAR(500)= NULL,
	@MailBodyTmplName	VARCHAR(50) = NULL,
	@TemplatePath		VARCHAR(200)= NULL,
	@MailBodyTmplPath	VARCHAR(200)= NULL,
	@TmplNmWiseData		VARCHAR(50) = NULL

AS
BEGIN
		-- EMPFD : Select fields from Grant letter template.
  		IF(@Type='EMPFD')
  		 BEGIN
			  (
				SELECT '@'+SYSCOL.NAME AS EmpMasterFields
				FROM 
  					SYS.COLUMNS SYSCOL INNER JOIN 
  					SYS.TABLES SYSTAB ON SYSCOL.OBJECT_ID = SYSTAB.OBJECT_ID 
				WHERE 
  				SYSTAB.NAME = 'EMPLOYEEMASTER' AND SYSCOL.NAME NOT IN('IsMailSent','LastUpdatedBy','LastUpdatedOn','ApprovalStatus','Deleted','payrollcountry','Remarks','Mobile',
																  'PerqAmt_ChequeNo','PerqAmt_DrownOndate','PerqAmt_WireTransfer','NewEmployeeId','IsAssociated',
																  'AssociatedDate','BackOutTermination','PerqAmt_BankName','PerqAmt_Branch','PerqAmt_BankAccountNumber','Branch','Status')
																  
				UNION
				
				SELECT '@'+ MAPPED_FIELD AS EmpMasterFields FROM OGA_FIELD_MAPPINGS WHERE MAPPED_FIELD IS NOT NULL
			 )
  		 END
  		 --GAMUP : select fields from Grant Acc Mass Upload table.
	 	 ELSE IF(@Type='GAMUP')
	 	 BEGIN

		 SELECT '@' + SYSCOL.NAME AS GrantAcceptanceFields 
		 FROM SYS.COLUMNS SYSCOL
		 INNER JOIN SYS.TABLES SYSTAB ON SYSCOL.OBJECT_ID = SYSTAB.OBJECT_ID
		 WHERE SYSTAB.NAME = 'GRANTACCMASSUPLOAD'
		 AND SYSCOL.NAME NOT IN('GAMUID', 'EmployeeID', 'LotNumber', 'LetterAcceptanceStatus', 
		 'LetterAcceptanceDate', 'GrantLetterName', 'GrantLetterPath', 'MailSentStatus', 
		 'MailSentDate', 'CreatedBy', 'CreatedOn', 'LastUpdatedBy', 'LastUpdatedOn', 'IsGlGenerated', 
		 'GlGeneratedDate', 'Field1', 'Field2', 'Field3', 'Field4', 'Field5', 'Field6', 'Field7',
		 'Field8', 'Field9', 'Field10') 
		 ORDER BY GrantAcceptanceFields
			  
	 	END
	 	ELSE IF(@Type='RGLT')
	 	--RGLT: Read / Select Grant Letter Template Data
	 	BEGIN
	 		SELECT TemplateName,[Subject],MailBodyTmplName,TemplatePath,MailBodyTmplPath FROM GrantLetterTemplate
	 	END
	 	
	 	ELSE IF(@Type='INSERT')
	 	BEGIN
	 		INSERT INTO GrantLetterTemplate (TemplateName,[Subject],MailBodyTmplName,TemplatePath,MailBodyTmplPath) VALUES (@TemplateName,@Subject,@MailBodyTmplName,@TemplatePath,@MailBodyTmplPath)
	 		IF(@@ROWCOUNT > 0)
	 		BEGIN	 			
	 			SELECT 'Data inserted successfully' AS RESULT
	 		END
	 		ELSE 
	 		BEGIN
	 			SELECT 'Error occurred while inserting data into data' AS RESULT	 			
	 		END
	 	END
	 	--DDLWISELST : Template name wise data has been selected.
	 	ELSE IF(@Type='DDLWISELST')
	 	BEGIN
	 		SELECT TemplateName,[Subject],MailBodyTmplName,TemplatePath,MailBodyTmplPath FROM GrantLetterTemplate WHERE TemplateName=@TmplNmWiseData
	 	END
	 	--GETVST : To receive the field vesting schedule.
	 	ELSE IF(@Type='GETVST')
	 	BEGIN
	 		SELECT '@'+ 'VestingSchedule' AS VestingSchedule
	 		UNION ALL
	 		SELECT '@'+ 'VestingDate' AS VestingSchedule
	 	END
		ELSE IF (@Type='UPDATE')
	 	BEGIN
	 	
	 	DECLARE @stringQuery VARCHAR(MAX) = 'UPDATE GrantLetterTemplate SET [Subject]='''+@Subject+''' WHERE TemplateName='''+@TemplateName+''''
	 	EXECUTE (@stringQuery)
	 		
	 		IF(@@ROWCOUNT > 0)
	 		BEGIN	 			
	 			SELECT 'Data updated successfully.' AS RESULT
	 		END
	 		ELSE 
	 		BEGIN
	 			SELECT 'Error occurred while updating data.' AS RESULT	 			
	 		END
	 	END
END

GO
