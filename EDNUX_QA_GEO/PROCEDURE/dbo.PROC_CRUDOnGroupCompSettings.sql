/****** Object:  StoredProcedure [dbo].[PROC_CRUDOnGroupCompSettings]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDOnGroupCompSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDOnGroupCompSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUDOnGroupCompSettings]
(
	@CompanyID			VARCHAR(80),
	@GrpCompDetails		GrpCompDetailType READONLY,
	@CaseValue			CHAR	
)
AS
BEGIN
	SET NOCOUNT ON
	--============================================
	-- Temporary tables defination
	--============================================
	CREATE TABLE #TEMP_EMGrpCompany
	(
		[TempID]	INT IDENTITY(1,1),
		[GroupID]	INT,
		[GroupCode]	INT,
		[GroupName]	VARCHAR(50),
		[CompanyID]	VARCHAR(100)
	)
	CREATE TABLE #TEMP_GrpCompanyDetails
	(
		[CompanyName]		VARCHAR(100),
		[IsActive]			BIT,
		[GroupName]			VARCHAR(100),
		[ModifiedBy]		VARCHAR(50),
		[ViewOn]			BIT,
		[EM_GroupID]		INT,
		[EM_GroupCode]		INT,
		[EM_GroupName]		VARCHAR(50),
		[EM_CompanyID]		VARCHAR(100),
		[IsGrpNmMatch]		BIT,
		[IsError]			BIT,
		[Description]		VARCHAR(100)
	)
	DECLARE @GROUPID	INT,
			@GROUPCODE	INT = 0,
			@GroupName	VARCHAR(80)
	--============================================
	-- Operation perform on temporary tables
	--============================================	
		BEGIN TRY
			BEGIN TRANSACTION
			--PRINT 'Write operations logics'			
				BEGIN
				--------------------------------------------------------------------------------------------------
					-- Insert data into temporary tables for performing operations.
					-- Table 1.  #TEMP_GrpCompanyDetails 
					-- Table 2.  #TEMP_EMGrpCompany
					------------------------------------------------------------------
					INSERT INTO #TEMP_GrpCompanyDetails(CompanyName,GroupName,IsActive,ViewOn,ModifiedBy)
							SELECT CompanyName,GroupName,IsActive,ViewOn,ModifiedBy FROM @GrpCompDetails	
					
					IF EXISTS(SELECT 1 FROM ESOPManager..GroupCompanies WHERE CompanyID=@CompanyID)
						BEGIN
							INSERT INTO #TEMP_EMGrpCompany(GroupID,GroupCode,GroupName,CompanyID)
							SELECT GroupID,GroupCode,GroupName,CompanyID FROM ESOPManager..GroupCompanies
							
							INSERT INTO #TEMP_GrpCompanyDetails(CompanyName,GroupName,IsActive,ViewOn,ModifiedBy)
							SELECT CompanyID,GroupName,1,1,'Admin' FROM ESOPManager..GroupCompanies 
							WHERE CompanyID = @CompanyID
						END
					ELSE
						BEGIN
							INSERT INTO #TEMP_EMGrpCompany(GroupID,GroupCode,GroupName,CompanyID)
							SELECT GroupID,GroupCode,GroupName,CompanyID FROM ESOPManager..GroupCompanies
							UNION
							SELECT TOP 1 (SELECT MAX(GroupID)+ 1 FROM ESOPManager..GroupCompanies),
									NULL,GroupName,@CompanyID FROM @GrpCompDetails 
							WHERE GroupName IS NOT NULL
							
							INSERT INTO #TEMP_GrpCompanyDetails(CompanyName,GroupName,IsActive,ViewOn,ModifiedBy)
							SELECT TOP 1 @CompanyID,GroupName,1,1,'Admin'
							FROM #TEMP_EMGrpCompany 
							WHERE CompanyID = @CompanyID
						END		
				--------------------------------------------------------------------------------------------------
				END
				
				--------------------------------------------------------------------------------------------------
				-- UPDATE Esopmanager table details into temporary table for further operations
				--------------------------------------------------------------------------------------------------				
				
				--SELECT * FROM #TEMP_GrpCompanyDetails
				--SELECT * FROM #TEMP_EMGrpCompany
				
				IF(@CaseValue='U')
					BEGIN
						--PRINT 'Update Operation'
						BEGIN
							UPDATE	Temp 
								SET		Temp.[EM_GroupID]	= EM.GroupID,
										Temp.[EM_GroupCode]	= EM.GroupCode,
										Temp.[EM_GroupName]	= EM.GroupName,
										Temp.[EM_CompanyID] = EM.CompanyID,
										Temp.[IsGrpNmMatch]	= CASE WHEN Temp.GroupName=EM.GroupName 
																			THEN 1 
																	ELSE 0 
															   END												
							FROM	#TEMP_GrpCompanyDetails AS Temp
										INNER JOIN #TEMP_EMGrpCompany  EM 
											ON EM.CompanyID = Temp.CompanyName	
							
							SELECT @GROUPCODE = (EM.GroupCode),@GroupName=(EM.GroupName) FROM #TEMP_EMGrpCompany EM WHERE CompanyID=@CompanyID
						------------------------------------------------------------------------------------------
						-- Insert operations perform on EsopManger temporary table
						------------------------------------------------------------------------------------------
							IF (@GROUPCODE IS NULL)
								SELECT @GROUPCODE = MAX(EM.GroupCode) + 1 FROM #TEMP_EMGrpCompany EM
							
							INSERT INTO #TEMP_EMGrpCompany(GroupCode,GroupName,CompanyID)
							(SELECT		@GROUPCODE,Temp.GroupName,Temp.CompanyName
							FROM		#TEMP_GrpCompanyDetails Temp
							WHERE		Temp.[EM_GroupID] IS NULL AND (Temp.[EM_GroupName] IS NULL))
							
							DELETE FROM #TEMP_EMGrpCompany WHERE GroupID IS NULL AND GroupName IS NULL
							
							SELECT @GROUPCODE = NULL,@GroupName = NULL
						END
						
						SELECT @GroupName = Temp.GroupName FROM #TEMP_EMGrpCompany Temp WHERE Temp.CompanyID = @CompanyID
						IF(@GroupName IS NOT NULL)
							BEGIN
								SELECT @GROUPCODE=Temp.GroupCode FROM #TEMP_EMGrpCompany Temp WHERE Temp.GroupName = @GroupName 
								
								UPDATE Temp
								SET Temp.GroupCode=@GROUPCODE, Temp.GroupID= ''							
								FROM #TEMP_EMGrpCompany TEMP
									INNER JOIN #TEMP_GrpCompanyDetails T
											ON T.CompanyName = TEMP.CompanyID								
								WHERE Temp.GroupName = @GroupName AND Temp.GroupCode IS NULL AND T.IsActive=1
								
								--SELECT GroupCode,GroupName,CompanyID FROM #TEMP_EMGrpCompany  WHERE GroupName = @GroupName
								
								DELETE FROM	ESOPManager..GroupCompanies WHERE GroupName = @GroupName
								IF(@@ROWCOUNT > 0)
									BEGIN
										INSERT INTO ESOPManager..GroupCompanies (GroupCode,GroupName,CompanyID)
										SELECT EM.GroupCode,EM.GroupName,EM.CompanyID FROM #TEMP_EMGrpCompany EM
												INNER JOIN #TEMP_GrpCompanyDetails Temp
													ON Temp.CompanyName = EM.CompanyID
										WHERE EM.GroupName = @GroupName and Temp.IsActive = 1
										IF(@@ROWCOUNT > 0)
											SELECT 1 AS [OUTPUT],'Success' [Result],'The group has been successfully updated'[Description]
										ELSE
											SELECT 0 AS [OUTPUT],'No changes have been made' [Result],'Error Occured While Creating Group' [Description]
									END
								ELSE
									BEGIN
										INSERT INTO ESOPManager..GroupCompanies (GroupCode,GroupName,CompanyID)
										SELECT EM.GroupCode,EM.GroupName,EM.CompanyID FROM #TEMP_EMGrpCompany EM
												INNER JOIN #TEMP_GrpCompanyDetails Temp
													ON Temp.CompanyName = EM.CompanyID
										WHERE EM.GroupName = @GroupName and Temp.IsActive = 1
										IF(@@ROWCOUNT > 0)
											SELECT 1 AS [OUTPUT],'Success' [Result],'The group has been successfully created'[Description]
										ELSE
											SELECT 0 AS [OUTPUT],'No changes have been made' [Result],'Error Occured While Creating Group' [Description]
									END
							END
							
					END
				ELSE
					BEGIN
						--PRINT 'Delete Operation'
						SELECT @GroupName = EM.GroupName FROM #TEMP_EMGrpCompany EM WHERE CompanyID=@CompanyID
						--SELECT @GroupName 
						
						DELETE FROM ESOPManager..GroupCompanies  
						WHERE GroupName = @GroupName
						
						IF(@@ROWCOUNT > 0)
							SELECT 1 AS [OUTPUT],'Success' [Result],'The group has been successfully deleted'[Description]
						ELSE
							SELECT 0 AS [OUTPUT],'No changes have been made' [Result],'The group already deleted' [Description]					
					END
			
			COMMIT TRANSACTION	  
		END TRY
		BEGIN CATCH
			IF (@@TRANCOUNT > 0)
				ROLLBACK TRANSACTION
			SELECT	0				AS [OUTPUT],
					'No changes have been made'			AS [Result],
				ERROR_MESSAGE()		AS[Description],				
				ERROR_NUMBER()		AS ErrorNumber, 
				ERROR_SEVERITY()	AS ErrorSeverity, 
				ERROR_STATE()		AS ErrorState, 
				ERROR_PROCEDURE()	AS ErrorProcedure, 
				ERROR_LINE()		AS ErrorLine, 
				ERROR_MESSAGE()		AS ErrorMessage;
			ROLLBACK TRANSACTION
			
		END CATCH
	SET NOCOUNT OFF;
END
GO
