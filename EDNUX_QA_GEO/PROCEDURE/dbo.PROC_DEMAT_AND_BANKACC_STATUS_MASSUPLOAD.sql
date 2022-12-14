/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD]
(
	@TemplateName NVARCHAR(100),
	@TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD dbo.TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD READONLY
)
AS
BEGIN
	SET XACT_ABORT ON
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRY
			/*CREATE TAMP TABLE TO GET THE UPLODED DATA FROM TYPE*/
			CREATE TABLE #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD
			(
				Sr_No INT NULL,
				EmployeeId VARCHAR(20) NULL,				
				EmpDematId BIGINT NULL,
				[Status] NVARCHAR(10) NULL
			)
			/*CREATE EXCEPTION TEMP TABLE*/
			CREATE TABLE #Exceptions
			(
				RowNo INT,
				EmployeeId VARCHAR(20) NULL,
				EmpDematId BIGINT NULL,
				[Status] NVARCHAR(10) NULL,
				TemplateName NVARCHAR(50) NULL,
				Remark VARCHAR(100) NULL
			)
			/*INSERT TYPE (UPLODED) DATA INTO TEMP TABLE*/
			INSERT INTO #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD(Sr_No, EmployeeId, EmpDematId, [Status])
			SELECT [Sr.No], [Employee Id], [Demat Id], [Status] FROM @TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD					
			
	END TRY
	BEGIN CATCH
		IF ( XACT_STATE() <> 0)
			BEGIN
				SELECT 'ERROR WHILE INSERTING INTO TEMP TABLE FROM TYPE RECORD' AS REMARK, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
				GOTO ERROR
			END
	END CATCH
	
		/*VALIDATION OF DEMAT AND BANK ACCOUNT MASSUPLOAD DATA BEGINS HERE*/		
		BEGIN TRY
			/*Employee Id null*/
			INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,[Status],TemplateName,Remark)
			SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'EMPLOYEE ID IS BLANK, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD
			WHERE (LEN(ISNULL(EmployeeId, 0)) = 0) OR ISNULL(EmployeeId, NULL) IS NULL OR ISNULL(EmployeeId, '') = '' ORDER BY Sr_No ASC

			/*Employee Id not valid*/			
			INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,[Status],TemplateName,Remark)
			SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'EMPLOYEE ID IS NOT VALID, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDABSM
			WHERE 
				NOT EXISTS (SELECT EMP.EmployeeID FROM EmployeeMaster AS EMP WHERE EMP.EmployeeID = TDABSM.EmployeeId) 
				AND (LEN(ISNULL(EmployeeId, 0)) > 0) AND ISNULL(EmployeeId, NULL) IS NOT NULL AND ISNULL(EmployeeId, '') <> ''
			ORDER BY Sr_No ASC

			/*MassUploadName Id null*/
			INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
			SELECT 0, '','',0,@TemplateName,'MASSUPLOAD FILE NAME IS BLANK, PLEASE UPLOAD VALID FILE'
			WHERE (LEN(ISNULL(@TemplateName, 0)) = 0) OR ISNULL(@TemplateName, NULL) IS NULL OR ISNULL(@TemplateName, '')=''

			/*MassUploadName Id null*/
			INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
			SELECT 0, '','',0,@TemplateName,'MASSUPLOAD IS NOT VALID, PLEASE UPLOAD VALID FILE'
			WHERE (LEN(ISNULL(@TemplateName, 0)) > 0) AND ISNULL(@TemplateName, NULL) IS NOT NULL AND ISNULL(@TemplateName, '') <>''
			AND ISNULL(@TemplateName, '')  NOT IN ('BANK_ACC_STATUS','DEMAT_STATUS','BROKER_STATUS')

			IF(@TemplateName='BANK_ACC_STATUS')
			BEGIN
				/*Status Id null*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS BLANK, PLEASE ENTER VALID STATUS (YES / NO)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE LEN(RTRIM(LTRIM([Status]))) = 0 OR ISNULL([Status], NULL)  IS NULL OR ISNULL([Status], '') = N'' OR [Status] = NULL OR [Status] = '' ORDER BY Sr_No ASC

				/*if status is invalid*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS NOT VALID, PLEASE ENTER VALID STATUS (YES / NO)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE UPPER([Status]) NOT IN ('YES','NO') AND (LEN(ISNULL([Status], 0)) >3) OR (LEN(ISNULL([Status], 0)) <2) AND LEN(RTRIM(LTRIM([Status]))) > 0 ORDER BY Sr_No ASC
			END

			IF(@TemplateName='DEMAT_STATUS')
			BEGIN
				/*EmpDematId Id null*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,Status,@TemplateName,'EMPLOYEE DEMAT ID IS BLANK, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE DEMAT ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD
				WHERE ISNULL(EmpDematId, NULL) IS NULL OR ISNULL(EmpDematId, '') = '' AND ISNULL(@TemplateName , '') = 'DEMAT_STATUS' ORDER BY Sr_No ASC
			
				/*EmpDematId Id is not valid*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, TDABSM.EmployeeId,EmpDematId,Status,@TemplateName,'EMPLOYEE DEMAT ID IS NOT VALID, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE DEMAT ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDABSM				
				WHERE NOT EXISTS (SELECT EUD.EmployeeDematId FROM Employee_UserDematDetails AS EUD WHERE EUD.EmployeeDematId = TDABSM.EmpDematId AND EUD.EmployeeID = TDABSM.EmployeeId) 
					  AND (LEN(ISNULL(EmployeeId, 0)) > 0) AND ISNULL(EmpDematId, NULL) IS NOT NULL AND ISNULL(EmpDematId, '') <> '' ORDER BY Sr_No ASC
				
				/*Status Id null*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS BLANK, PLEASE ENTER VALID STATUS (V/I)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE LEN(RTRIM(LTRIM([Status]))) = 0 OR ISNULL([Status], NULL)  IS NULL OR ISNULL([Status], '') = N'' OR [Status] = NULL OR [Status] = '' ORDER BY Sr_No ASC

				/*if status is invalid*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS NOT VALID, PLEASE ENTER VALID STATUS (V/I)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE [Status] NOT IN ('V','I') AND (LEN(ISNULL([Status], 0)) >1) OR (LEN(ISNULL([Status], 0)) <1) AND (LEN(ISNULL([Status], '')) >0) ORDER BY Sr_No ASC
			END

			--START BROKER STATUS
			IF(@TemplateName='BROKER_STATUS')
			BEGIN			
				/*EmpBrokerAccountId Id null*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark) 
				SELECT Sr_No, EmployeeId,EmpDematId,Status,@TemplateName,'EMPLOYEE BROKER ACCOUNT ID IS BLANK, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE BROKER ACCOUNT ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD
				WHERE ISNULL(EmpDematId, NULL) IS NULL OR ISNULL(EmpDematId, '') = '' AND ISNULL(@TemplateName , '') = 'BROKER_STATUS' ORDER BY Sr_No ASC
			
				/*EmpBrokerAccountId Id is not valid*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, TDABSM.EmployeeId,EmpDematId,Status,@TemplateName,'EMPLOYEE BROKER ACCOUNT ID IS NOT VALID, PLEASE DO NOT MODIFIY OR DELETE EMPLOYEE BROKER ACCOUNT ID' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDABSM				
				WHERE NOT EXISTS (SELECT EUD.EMPLOYEE_BROKER_ACC_ID FROM Employee_UserBrokerDetails AS EUD WHERE EUD.EMPLOYEE_BROKER_ACC_ID = TDABSM.EmpDematId AND EUD.EMPLOYEE_ID = TDABSM.EmployeeId) 
					  AND (LEN(ISNULL(EmployeeId, 0)) > 0) AND ISNULL(EmpDematId, NULL) IS NOT NULL AND ISNULL(EmpDematId, '') <> '' ORDER BY Sr_No ASC
				
				/*Status Id null*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS BLANK, PLEASE ENTER VALID STATUS (V/I)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE LEN(RTRIM(LTRIM([Status]))) = 0 OR ISNULL([Status], NULL)  IS NULL OR ISNULL([Status], '') = N'' OR [Status] = NULL OR [Status] = '' ORDER BY Sr_No ASC

				/*if status is invalid*/
				INSERT INTO #Exceptions (RowNo,EmployeeId, EmpDematId,Status,TemplateName,Remark)
				SELECT Sr_No, EmployeeId,EmpDematId,[Status],@TemplateName,'STATUS IS NOT VALID, PLEASE ENTER VALID STATUS (V/I)' FROM #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD			
				WHERE [Status] NOT IN ('V','I') AND (LEN(ISNULL([Status], 0)) >1) OR (LEN(ISNULL([Status], 0)) <1) AND (LEN(ISNULL([Status], '')) >0) ORDER BY Sr_No ASC
			END
			--END BROKER STATUS

			/* EXCEPTION TABLE RETURNS IF THERE IS ANY ERROR*/
			IF ((SELECT COUNT(*) FROM #Exceptions) > 0)	
			BEGIN
				SELECT 'EXCEPTION' AS EXCEPTION, RowNo AS ROWNUMBER, REMARK FROM #Exceptions ORDER BY ROWNUMBER ASC
				GOTO ERROR
			END
		END TRY
		BEGIN CATCH
			IF ( XACT_STATE() <> 0)
			BEGIN
				SELECT 'ERROR WHILE VALIDATING UPLODED RECORD' AS REMARK, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
				GOTO ERROR
			END
		END CATCH

		/*BEGIN TRANSACTION*/
		BEGIN TRANSACTION
		BEGIN TRY
		IF (UPPER(@TemplateName) ='DEMAT_STATUS')
			BEGIN
				UPDATE  
					EUD SET EUD.IsValidDematAcc = 
					CASE 
						WHEN TDBASM.[Status] ='V'	THEN 1							
						WHEN TDBASM.[Status] ='I'	THEN 0
					END
				FROM   
					Employee_UserDematDetails AS EUD INNER JOIN #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDBASM
				ON 
					EUD.EmployeeID = TDBASM.EmployeeId AND EUD.EmployeeDematId = TDBASM.EmpDematId
					
					--GET TRANSACTION STATUS
					SELECT @@TRANCOUNT AS TRACOUNT
					COMMIT TRANSACTION
			END
		
		IF (UPPER(@TemplateName)='BANK_ACC_STATUS')
			BEGIN
				UPDATE  
					EM SET EM.IsValidBankAcc =
					CASE 
						WHEN TDBASM.[Status] ='YES' THEN 1 
						WHEN TDBASM.[Status] ='NO'	THEN 0
					END
				FROM   
					EmployeeMaster AS EM INNER JOIN #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDBASM
				ON 
					EM.EmployeeID = TDBASM.EmployeeId
				WHERE
					EM.Deleted=0
					
					--GET TRANSACTION STATUS
					SELECT @@TRANCOUNT AS TRACOUNT
					COMMIT TRANSACTION
			END				

		--Start Broker Account Status
		IF (UPPER(@TemplateName) ='BROKER_STATUS')
			BEGIN
				UPDATE  
					EUD SET EUD.IsValidBrokerAcc = 
					CASE 
						WHEN TDBASM.[Status] ='V'	THEN 1							
						WHEN TDBASM.[Status] ='I'	THEN 0
					END,
					EUD.UPDATED_ON = GetDAte()
				FROM   
					EMPLOYEE_USERBROKERDETAILS AS EUD INNER JOIN #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD AS TDBASM
				ON 
					EUD.EMPLOYEE_ID = TDBASM.EmployeeId AND EUD.EMPLOYEE_BROKER_ACC_ID = TDBASM.EmpDematId
					
					--GET TRANSACTION STATUS
					SELECT @@TRANCOUNT AS TRACOUNT
					COMMIT TRANSACTION	
			END
		--End Broker Account Status
		END TRY
		BEGIN CATCH
			IF ( XACT_STATE() <> 0)
			BEGIN
				SELECT 'ERROR WHILE UPDATING UPLODED RECORD' AS REMARK, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
				ROLLBACK TRANSACTION;
				GOTO ERROR
			END
		END CATCH
	ERROR:
		DROP TABLE #Exceptions
		DROP TABLE #TYPE_DEMAT_AND_BANKACC_STATUS_MASSUPLOAD
	END TRY	
	BEGIN CATCH
		IF (@@TRANCOUNT > 0) OR XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'ERROR WHILE VALIDATING / UPDATING RECORD' AS REMARK, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
			ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
		END
	END CATCH
	SET NOCOUNT OFF;
END
GO
