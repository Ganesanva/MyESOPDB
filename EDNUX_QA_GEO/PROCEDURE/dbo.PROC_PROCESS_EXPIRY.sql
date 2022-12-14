/****** Object:  StoredProcedure [dbo].[PROC_PROCESS_EXPIRY]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PROCESS_EXPIRY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PROCESS_EXPIRY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PROCESS_EXPIRY] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @GRANTED_OPTIONS VARCHAR(50)	
	DECLARE @AND_CONDITION VARCHAR(MAX)
	DECLARE @LAPSE_QTY VARCHAR(MAX)
	DECLARE @UPDATE_QUERY1 VARCHAR(MAX)	
	DECLARE @UPDATE_QUERY2 VARCHAR(MAX)		
	DECLARE @LAPSE_ID NUMERIC(18,0)
	SET @AND_CONDITION ='' 
	SET @LAPSE_QTY = ''
	
	----------------------------
	-- CHECK AND SET BONUS SPLIT POLICY
	---------------------------
	
	BEGIN
	
		DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
		SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
					
		IF(@ApplyBonusTo='V')
			BEGIN
				IF(@ApplySplitTo='V')
					BEGIN
						-- Set Parameter GrantedQuantity, ExercisedQuantity, CancelledQuantity,
						SET @GRANTED_OPTIONS = 'VW.GrantedQuantity'
						SET @AND_CONDITION = 'AND (((VW.GrantedQuantity - (VW.CancelledQuantity + VW.ExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'
						SET @LAPSE_QTY = 'VW.GrantedQuantity - VW.ExercisedQuantity - VW.CancelledQuantity - VW.UnapprovedExerciseQuantity'
					END
				ELSE 
					BEGIN
						-- Set Parameter SplitQuantity, SplitExercisedQuantity, SplitCancelledQuantity, 						
						SET @GRANTED_OPTIONS = 'VW.SplitQuantity'
						SET @AND_CONDITION = 'AND (((VW.SplitQuantity - (VW.SplitCancelledQuantity + VW.SplitExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'
						SET @LAPSE_QTY = 'VW.SplitQuantity - VW.SplitExercisedQuantity - VW.SplitCancelledQuantity - VW.UnapprovedExerciseQuantity'
					END
			END
		ELSE
			 BEGIN
					-- Set Parameter BonusSplitQuantity, BonusSplitExercisedQuantity, BonusSplitCancelledQuantity, 
				SET @GRANTED_OPTIONS = 'VW.BonusSplitQuantity'
				SET @AND_CONDITION = 'AND (((VW.BonusSplitQuantity - (VW.BonusSplitCancelledQuantity + VW.BonusSplitExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'	  
				SET @LAPSE_QTY = 'VW.BonusSplitQuantity - VW.BonusSplitExercisedQuantity - VW.BonusSplitCancelledQuantity - VW.UnapprovedExerciseQuantity'
			 END	
	
	END
	
	---------------------
	-- CREATE TEMP TABLES
	---------------------
	
	BEGIN
	
		-- CREATE TEMP TABLE FOR COLLECT EMPLOYEE EXPIRYIES DETAILS	
		
		CREATE TABLE #EMPLOYEE_EXPIRY_DATA
		(
			Expiry_LAPSE_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EmployeeId NVARCHAR(50), GrantApprovalId NVARCHAR(50), ID NVARCHAR(50), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(50), 
			VestingType NVARCHAR(10), SeperationCancellationDate DATETIME, SeparationPerformed NVARCHAR(50), GrantedOptions NUMERIC(18,0), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), 
			CancelledQuantity NUMERIC(18,0), SplitCancelledQuantity NUMERIC(18,0), BonusSplitCancelledQuantity NUMERIC(18,0), 
			ExercisedQuantity NUMERIC(18,0), SplitExercisedQuantity NUMERIC(18,0), BonusSplitExercisedQuantity NUMERIC(18,0), 
			ExercisableQuantity NUMERIC(18,0), LapsedQuantity NUMERIC(18,0), UnapprovedExerciseQuantity NUMERIC(18,0), FinalExpirayDate DATETIME,	
			ExpiryPerformed NVARCHAR(10), IsPerfBased NVARCHAR(10), DateOfTermination DATETIME, IsUserActive NVARCHAR(10), 
			ApprovalStatus NVARCHAR(10), [Status] NVARCHAR(10), Expiry_Lapse_Quantity NUMERIC(18,0), Expiry_Lapse_Date DATETIME
		)
		
		-- CREATE TEMP TABLE FOR GRANT APPROVAL
		
		CREATE TABLE #TEMP_GRANT_APPROVAL
		(
			GrantApprovalId NVARCHAR(50),  Expiry_Lapse_Quantity NUMERIC(18,0)
		)
				
		
		-- CREATE TEMP TABLE FOR SHAREHOLDER APPROVAL
		
		CREATE TABLE #TEMP_SHAREHOLDER_APPROVAL
		(
			ApprovalId NVARCHAR(50),  Expiry_Lapse_Quantity NUMERIC(18,0)
		)
	
	END
	
	
	-----------------------------------------------------------------
	-- CHECK LAPSE TRANSE SEQUENCE ID AVAILABLE IN SEQUENCE TABLE
	-----------------------------------------------------------------
	
	IF NOT EXISTS (SELECT 1 FROM SequenceTable WHERE UPPER(Seq1) ='LAPSETRANS')
	BEGIN
		INSERT INTO SequenceTable (Seq1, Seq2, Seq3, Seq4, Seq5, SequenceNo)
		VALUES ('LapseTrans', NULL, NULL , NULL , NULL, 0)
	END
	
	-----------------------------------------------------------------
	-- GET LAST LAPSE ID FROM THE SEQUENCE TABLE OR LAPSE TRANS TABLE
	-----------------------------------------------------------------
	
	BEGIN
	
		DECLARE @SEQUENCE_LAPSE_ID BIGINT
		DECLARE @SEQ_LAPSE_ID BIGINT
		DECLARE @LAPSE_TBL_TRANS_ID BIGINT
		
		SET @SEQ_LAPSE_ID  = (SELECT ISNULL(CONVERT(BIGINT,(ISNULL(SequenceNo,0))),0) AS SequenceNo FROM SequenceTable WHERE UPPER(Seq1) = 'LAPSETRANS')
		SET @LAPSE_TBL_TRANS_ID = (SELECT ISNULL(MAX(CONVERT(BIGINT,ISNULL(LapseTransID,0))),0) AS LapseTransID from LapseTrans)
		
		IF(@SEQ_LAPSE_ID >= @LAPSE_TBL_TRANS_ID)
			BEGIN 
				SET @SEQUENCE_LAPSE_ID = @SEQ_LAPSE_ID + 1 	
			END
		ELSE
			BEGIN 
				SET @SEQUENCE_LAPSE_ID = @LAPSE_TBL_TRANS_ID + 1 	
			END
			
		--PRINT @SEQUENCE_LAPSE_ID
		--PRINT @SEQ_LAPSE_ID
		--PRINT @LAPSE_TBL_TRANS_ID
		
		IF (@SEQUENCE_LAPSE_ID IS NOT NULL)
		BEGIN
			DBCC CHECKIDENT(#EMPLOYEE_EXPIRY_DATA, RESEED, @SEQUENCE_LAPSE_ID) 
		END
	
	END
	
	--------------------------------------
	-- INSERT VIEW DETAILS INTO TEMP TABLE
	--------------------------------------
	
	BEGIN 
	
		INSERT INTO #EMPLOYEE_EXPIRY_DATA 	
		(	
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeperationCancellationDate, SeparationPerformed, GrantedOptions, 
			GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
			ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status]
		)
		
		SELECT EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeperationCancellationDate, SeparationPerformed, GrantedOptions, 
		GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
		SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
		ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status]
		FROM [VW_GrantLegDetails] AS VW
		WHERE (VW.[Status] ='A') AND (CONVERT(DATE,GETDATE() - 1 ) >= CONVERT(DATE,VW.FinalExpirayDate)) AND (LEN(VW.ExpiryPerformed) IS NULL)
		AND (CONVERT(DATE,GETDATE()) < CONVERT(DATE,VW.SeperationCancellationDate)) 
		AND ((UPPER(VestingType) = 'P' AND IsPerfBased = '1') OR (UPPER(VestingType) = 'T' AND UPPER(IsPerfBased) = 'N'))
		ORDER BY ID ASC 
		
		---- UPDATE LAPSE QUANITTY, DATE TO TEMP TABLE
		
		SET @UPDATE_QUERY1 = 
		' UPDATE TEMP SET Expiry_Lapse_Quantity = '+ @LAPSE_QTY +',  Expiry_Lapse_Date = GETDATE(), ExpiryPerformed = ''Y'' FROM #EMPLOYEE_EXPIRY_DATA AS TEMP
		INNER JOIN [VW_GrantLegDetails] AS VW ON TEMP.ID = VW.ID '
		
		EXECUTE (@UPDATE_QUERY1)
		--PRINT @UPDATE_QUERY1
		
		INSERT INTO #TEMP_GRANT_APPROVAL 	
		(	
			GrantApprovalId, Expiry_Lapse_Quantity
		)
		SELECT GA.GrantApprovalId, SUM(ETEMP.Expiry_Lapse_Quantity)AS Expiry_Lapse_Quantity FROM #EMPLOYEE_EXPIRY_DATA AS ETEMP 
		INNER JOIN GrantApproval AS GA ON ETEMP.GrantApprovalId = GA.GrantApprovalId GROUP BY GA.GrantApprovalId
		
		---- SELECT GrantApprovalId, Expiry_Lapse_Quantity FROM #TEMP_GRANT_APPROVAL
					
		INSERT INTO #TEMP_SHAREHOLDER_APPROVAL
		(
			ApprovalId, Expiry_Lapse_Quantity
		)
		SELECT SHA.ApprovalId, SUM(ETEMP.Expiry_Lapse_Quantity) AS Expiry_Lapse_Quantity FROM #EMPLOYEE_EXPIRY_DATA AS ETEMP 
		INNER JOIN GrantApproval AS GA ON ETEMP.GrantApprovalId = GA.GrantApprovalId
		INNER JOIN ShareHolderApproval AS SHA ON GA.ApprovalId = SHA.ApprovalId GROUP BY SHA.ApprovalId
				
		---- SELECT ApprovalId, Expiry_Lapse_Quantity FROM #TEMP_SHAREHOLDER_APPROVAL	
	
	END
	
	BEGIN
	
		SELECT ETEMP.EmployeeId, ETEMP.GrantApprovalId, ETEMP.ID, ETEMP.GrantOptionId, ETEMP.GrantLegId, ETEMP.VestingType, ETEMP.SeperationCancellationDate, 
		ETEMP.SeparationPerformed, ETEMP.GrantedOptions, ETEMP.GrantedQuantity, ETEMP.SplitQuantity, ETEMP.BonusSplitQuantity, ETEMP.CancelledQuantity, 
		ETEMP.SplitCancelledQuantity, ETEMP.BonusSplitCancelledQuantity, ETEMP.ExercisedQuantity, ETEMP.SplitExercisedQuantity, ETEMP.BonusSplitExercisedQuantity, 
		ETEMP.ExercisableQuantity, ETEMP.LapsedQuantity, ETEMP.UnapprovedExerciseQuantity, ETEMP.FinalExpirayDate, ETEMP.ExpiryPerformed, ETEMP.IsPerfBased, 
		ETEMP.DateOfTermination, ETEMP.IsUserActive, ETEMP.ApprovalStatus, ETEMP.[Status], ETEMP.Expiry_LAPSE_ID, ETEMP.Expiry_Lapse_Quantity, 
		ETEMP.Expiry_Lapse_Date FROM #EMPLOYEE_EXPIRY_DATA AS ETEMP
		INNER JOIN [VW_GrantLegDetails] AS VW ON VW.ID = ETEMP.ID 
	
	END
	
	----------------------------------------------------------------------------------------------------------------------------
	-- DATABASE UPDATE AND MANIPULATIONS, UPADTE GRANT LEG, LAPSE TRANS, SEQUENCE TABLE, GRANT APPROVAL AND SHAREHOLDER APPROVAL
	----------------------------------------------------------------------------------------------------------------------------
	
	BEGIN
	
		-- CHECK COUNT, IF TEMP TABLE HAVE DEATAILS THEN PERFORM THE OPERATIONS
		IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #EMPLOYEE_EXPIRY_DATA) > 0)
			BEGIN
				BEGIN TRY
				
					BEGIN TRANSACTION
					
					---- UPDATE GRANT LEG TABLE
					
					UPDATE GL SET GL.ExpiryPerformed = ETEMP.ExpiryPerformed, GL.LapsedQuantity = (ISNULL(GL.LapsedQuantity,0) + ETEMP.Expiry_Lapse_Quantity), GL.ExercisableQuantity = 0, 
					GL.LastUpdatedBy = 'ADMIN', GL.LastUpdatedOn = GETDATE() FROM GrantLeg AS GL
					INNER JOIN #EMPLOYEE_EXPIRY_DATA AS ETEMP ON ETEMP.ID = GL.ID 
					
					---- INSERT INTO LAPSE TRNSE TABLE
					
					INSERT INTO LapseTrans (LapseTransID, ApprovalStatus, GrantOptionID, GrantLegID, VestingType, LapsedQuantity, GrantLegSerialNumber, LapseDate, EmployeeID, LastUpdatedBy, LastUpdatedOn)
					SELECT Expiry_LAPSE_ID, ApprovalStatus, GrantOptionId, GrantLegId, VestingType, Expiry_Lapse_Quantity, ID, Expiry_Lapse_Date, EmployeeId, 'ADMIN', GETDATE() FROM #EMPLOYEE_EXPIRY_DATA
					
					---- UPDATE SEQUENCE TABLE
					
					UPDATE SequenceTable SET SequenceNo = (SELECT MAX(CONVERT(BIGINT,ISNULL(LapseTransID,0))) AS LapseTransID FROM LapseTrans)
					WHERE UPPER(Seq1) = 'LAPSETRANS'
					
					---- UPDATE IN GRANT APPROVAL TABLE
										
					UPDATE GA SET GA.AvailableShares = GA.AvailableShares + TGA.Expiry_Lapse_Quantity, GA.LastUpdatedBy = 'ADMIN', GA.LastUpdatedOn = GETDATE() FROM GrantApproval AS GA
					INNER JOIN #TEMP_GRANT_APPROVAL AS TGA ON TGA.GrantApprovalId = GA.GrantApprovalId
					WHERE TGA.Expiry_Lapse_Quantity > 0
					
					---- After discussion with Neha we will add addationl shares to Share Holder Approval table 
					------ UPDATE IN SHARE HOLDER APPROVAL TABLE											
					
					--UPDATE SHA SET SHA.AvailableShares =  SHA.AvailableShares + TSHA.Expiry_Lapse_Quantity, SHA.LastUpdatedBy = 'ADMIN', SHA.LastUpdatedOn = GETDATE() FROM ShareHolderApproval AS SHA
					--INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TSHA ON TSHA.ApprovalId = SHA.ApprovalId
					--WHERE TSHA.Expiry_Lapse_Quantity > 0
					
					COMMIT TRANSACTION
														
				END TRY
				BEGIN CATCH
					
					IF @@TRANCOUNT > 0			
						ROLLBACK TRANSACTION
					
					SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
					ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
				
				END CATCH
			END
		ELSE
			BEGIN
				PRINT 'NO DATA AVAILABLE FOR MOVE OPTION TO LAPSE'
			END
	
	END
	
	BEGIN
		
		DROP TABLE #EMPLOYEE_EXPIRY_DATA
		DROP TABLE #TEMP_GRANT_APPROVAL
		DROP TABLE #TEMP_SHAREHOLDER_APPROVAL
	
	END
	
	SET NOCOUNT OFF;
END
GO
