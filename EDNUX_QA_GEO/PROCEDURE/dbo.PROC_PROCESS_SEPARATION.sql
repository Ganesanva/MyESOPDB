/****** Object:  StoredProcedure [dbo].[PROC_PROCESS_SEPARATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PROCESS_SEPARATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PROCESS_SEPARATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PROCESS_SEPARATION] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @AND_CONDITION VARCHAR(MAX)
	DECLARE @SEPARATION_CANC_QTY VARCHAR(MAX)
	DECLARE @UPDATE_QUERY VARCHAR(MAX), @UPDATE_ONLY_PERFORNACE VARCHAR(MAX)		
	
	SET @AND_CONDITION ='' 
	SET @SEPARATION_CANC_QTY = ''
	
	-----------------------------------
	-- CHECK AND SET BONUS SPLIT POLICY
	-----------------------------------
	
	BEGIN
		
		DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
		SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
	
		IF(@ApplyBonusTo='V')
			BEGIN
				IF(@ApplySplitTo='V')
					BEGIN
						-- Set Parameter GrantedQuantity, ExercisedQuantity, CancelledQuantity,
						SET @AND_CONDITION = 'AND (((VW.GrantedQuantity - (VW.CancelledQuantity + VW.ExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'
						SET @SEPARATION_CANC_QTY = 'VW.GrantedQuantity - VW.ExercisedQuantity - VW.CancelledQuantity - VW.LapsedQuantity - VW.UnapprovedExerciseQuantity'
					END
				ELSE 
					BEGIN
						-- Set Parameter SplitQuantity, SplitExercisedQuantity, SplitCancelledQuantity, 						
						SET @AND_CONDITION = 'AND (((VW.SplitQuantity - (VW.SplitCancelledQuantity + VW.SplitExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'
						SET @SEPARATION_CANC_QTY = 'VW.SplitQuantity - VW.SplitExercisedQuantity - VW.SplitCancelledQuantity - VW.LapsedQuantity - VW.UnapprovedExerciseQuantity'
					END
			END
		ELSE
			 BEGIN
					-- Set Parameter BonusSplitQuantity, BonusSplitExercisedQuantity, BonusSplitCancelledQuantity, 
				  SET @AND_CONDITION = 'AND (((VW.BonusSplitQuantity - (VW.BonusSplitCancelledQuantity + VW.BonusSplitExercisedQuantity + VW.ExercisableQuantity + VW.LapsedQuantity + VW.UnapprovedExerciseQuantity))) = 0)'	  
				  SET @SEPARATION_CANC_QTY = 'VW.BonusSplitQuantity - VW.BonusSplitExercisedQuantity - VW.BonusSplitCancelledQuantity - VW.LapsedQuantity - VW.UnapprovedExerciseQuantity'
			 END	
	
	END
	
	---------------------------
	-- CREATE TEMP TABLES
	---------------------------
	
	BEGIN
	
		---- TEMP TABLE FOR SEPARATION DATA
		
		CREATE TABLE #EMPLOYEE_SEPARATION_DATA
		(
			EmployeeId NVARCHAR(50), GrantApprovalId NVARCHAR(50), ID NVARCHAR(50), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(50), 
			VestingType NVARCHAR(10), SeparationCancellationDate DATETIME, SeparationPerformed NVARCHAR(50), GrantedOptions NUMERIC(18,0), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), 
			CancelledQuantity NUMERIC(18,0), SplitCancelledQuantity NUMERIC(18,0), BonusSplitCancelledQuantity NUMERIC(18,0), 
			ExercisedQuantity NUMERIC(18,0), SplitExercisedQuantity NUMERIC(18,0), BonusSplitExercisedQuantity NUMERIC(18,0), 
			ExercisableQuantity NUMERIC(18,0), LapsedQuantity NUMERIC(18,0), UnapprovedExerciseQuantity NUMERIC(18,0), FinalExpirayDate DATETIME,	
			ExpiryPerformed NVARCHAR(10), IsPerfBased NVARCHAR(10), DateOfTermination DATETIME, IsUserActive NVARCHAR(10), 
			ApprovalStatus NVARCHAR(10), [Status] NVARCHAR(10), CancelTransId NVARCHAR(50), CancelledId NUMERIC(18,0) IDENTITY (1, 1) NOT NULL,
			CancellationReasion NVARCHAR(200), CancellationDate DATETIME, SeparationCancellationQuantity NUMERIC(18,0)
		)
		
		---- TEMP TABLE FOR CANCELLED TRANS
		
		CREATE TABLE #TEMP_CANCELLED_TRANS
		(
			CancelledTransId NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, ApprovalStatus NVARCHAR(10), CancellationDate DATETIME, 
			CancellationReason NVARCHAR(200), CancelledQuantity NUMERIC(18,0), EmployeeID NVARCHAR(50), [Action] NVARCHAR(10), 
			GrantOptionID NVARCHAR(100), LastUpdatedBy NVARCHAR(50), LastUpdatedOn DATETIME, GrantLegSerialNumber NVARCHAR(50)
		)
		
		-- CREATE TEMP TABLE FOR GRANT APPROVAL
		
		CREATE TABLE #TEMP_GRANT_APPROVAL
		(
			GrantApprovalId NVARCHAR(50), SEPARATION_CANCELLED_QUANTITY NUMERIC(18,0)
		)
				
		-- CREATE TEMP TABLE FOR SHAREHOLDER APPROVAL
		
		CREATE TABLE #TEMP_SHAREHOLDER_APPROVAL
		(
			ApprovalId NVARCHAR(50), SEPARATION_CANCELLED_QUANTITY NUMERIC(18,0)
		)
	
	END
	
	-----------------------------------------------------------------
	-- CHECK CANCELLED  ID AVAILABLE IN SEQUENCE TABLE
	-----------------------------------------------------------------
	
	IF NOT EXISTS (SELECT * FROM SequenceTable WHERE UPPER(Seq1) ='CANCELLED')
	BEGIN
		INSERT INTO SequenceTable (Seq1, Seq2, Seq3, Seq4, Seq5, SequenceNo)
		VALUES ('Cancelled', NULL, NULL , NULL , NULL, 0)
	END
	
	-----------------------------------------------------------------------------
	-- SET RECENT IDENTITY TO #EMPLOYEE_EXPIRY_DATA TABLE FOR CANCELLED ID COLUMN
	-----------------------------------------------------------------------------
	
	BEGIN
			
		DECLARE @CANCELLED_ID BIGINT
		DECLARE @SEQ_CANCELLED_ID BIGINT
		DECLARE @CANCELLED_TBL_TRANS_ID BIGINT
		
		SET @SEQ_CANCELLED_ID  = (SELECT CONVERT(BIGINT,(ISNULL(SequenceNo,0))) AS SequenceNo FROM SequenceTable WHERE UPPER(Seq1) = 'CANCELLED')
		SET @CANCELLED_TBL_TRANS_ID = (SELECT MAX(CONVERT(BIGINT,ISNULL(CancelledId,0))) AS CancelledId FROM Cancelled)
		
		IF(@SEQ_CANCELLED_ID >= @CANCELLED_TBL_TRANS_ID)
			BEGIN 
				SET @CANCELLED_ID = @SEQ_CANCELLED_ID + 1 	
			END
		ELSE
			BEGIN 
				SET @CANCELLED_ID = @CANCELLED_TBL_TRANS_ID + 1 	
			END
			
		--PRINT 'CANCELLED_ID : '+ CONVERT(VARCHAR(100), @CANCELLED_ID)
		--PRINT 'SEQ_CANCELLED_ID : '+ CONVERT(VARCHAR(100), @SEQ_CANCELLED_ID)
		--PRINT 'CANCELLED_TBL_TRANS_ID : '+ CONVERT(VARCHAR(100), @CANCELLED_TBL_TRANS_ID)
		
		IF (@CANCELLED_ID IS NOT NULL)
		BEGIN 
			DBCC CHECKIDENT(#EMPLOYEE_SEPARATION_DATA, RESEED, @CANCELLED_ID) 
		END
	
	END
	
	---------------------------------------
	-- INSERT DETAILS INTO TEMP SEPARATION TABLE
	---------------------------------------
	
	BEGIN
	
		INSERT INTO #EMPLOYEE_SEPARATION_DATA 	
		(	
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeparationCancellationDate, SeparationPerformed, GrantedOptions, 
			GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
			ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status]
		)
		SELECT 
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, CONVERT(DATE,SeperationCancellationDate), SeparationPerformed, GrantedOptions, 
			GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
			ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status]
		FROM 
			[VW_GrantLegDetails] AS VW	
		WHERE
			 ([Status] ='A') AND (CONVERT(DATE,GETDATE()) >= CONVERT(DATE,SeperationCancellationDate)) AND (LEN(SeparationPerformed) IS NULL) AND (LapsedQuantity = 0)
				AND 
				(
					(UPPER(VestingType) = 'P' AND IsPerfBased = '1') OR (UPPER(VestingType) = 'T' AND UPPER(IsPerfBased) = 'N')
					OR (UPPER(VestingType) = 'P' AND IsPerfBased = 'N' AND CONVERT(DATE,SeperationCancellationDate) <= CONVERT(DATE,FinalVestingDate) AND (GrantedOptions <> CancelledQuantity))
				)
				
		ORDER BY ID ASC 

		---- UPDATE CANCELLATION REASION, DATE, SEPARATION STATUS, SEPARATION CANCELLED QUANTITY
		SET @UPDATE_QUERY = 
			' UPDATE TEMP SET SeparationPerformed = ''Y'', CancellationDate = GETDATE(), CancellationReasion = ''Employee has been separated and there are no pending options available to him/her'',
			SeparationCancellationQuantity = '+ @SEPARATION_CANC_QTY +'
			FROM #EMPLOYEE_SEPARATION_DATA AS TEMP 
			INNER JOIN [VW_GrantLegDetails] AS VW ON TEMP.ID = VW.ID
			WHERE (CONVERT(DATE,GETDATE()) >= CONVERT(DATE,VW.SeperationCancellationDate)) AND (LEN(VW.SeparationPerformed) IS NULL) 
			AND ((UPPER(VW.VestingType) = ''P'' AND VW.IsPerfBased = ''1'') OR (UPPER(VW.VestingType) = ''T'' AND UPPER(VW.IsPerfBased) = ''N'')) 
			'+@AND_CONDITION+'' 	
		
		EXECUTE (@UPDATE_QUERY)
		-- PRINT @UPDATE_QUERY
		
		SET @UPDATE_ONLY_PERFORNACE = 
			' UPDATE TEMP SET SeparationPerformed = ''Y'', CancellationDate = GETDATE(), CancellationReasion = ''Employee has been separated and there are no pending options available to him/her'',
			SeparationCancellationQuantity = '+ @SEPARATION_CANC_QTY +'
			FROM #EMPLOYEE_SEPARATION_DATA AS TEMP 
			INNER JOIN [VW_GrantLegDetails] AS VW ON TEMP.ID = VW.ID
			WHERE (CONVERT(DATE,GETDATE()) >= CONVERT(DATE,VW.SeperationCancellationDate)) AND (LEN(VW.SeparationPerformed) IS NULL) 
			AND (UPPER(VW.VestingType) = ''P'' AND VW.IsPerfBased = ''N'' AND CONVERT(DATE,VW.SeperationCancellationDate) <= CONVERT(DATE,VW.FinalVestingDate) AND (VW.GrantedOptions <> VW.CancelledQuantity)) 
			' 	
		
		EXECUTE (@UPDATE_ONLY_PERFORNACE)
		-- PRINT @UPDATE_ONLY_PERFORNACE

		--------------------------------
		---- EMPLOYEE SEPARATION DETAILS
		--------------------------------
				
		SELECT EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeparationCancellationDate, SeparationPerformed, 
		GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, 
		ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, 
		FinalExpirayDate, ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status], CancelTransId, CancelledId, 
		CancellationReasion, CancellationDate, SeparationCancellationQuantity FROM #EMPLOYEE_SEPARATION_DATA
		
	END
	
	------------------------------------------------------------------
	-- CALCULATE CANCELLED TRANS DETAILS TO TEMP CANCELLED TRANS TABLE
	------------------------------------------------------------------
	
	BEGIN
		
		DECLARE @CANCELLED_TRANS_ID BIGINT
		SET @CANCELLED_TRANS_ID = (SELECT MAX(CONVERT(BIGINT,ISNULL(CancelledTransID,0))) AS CancelledTransID FROM CancelledTrans) + 1 	
		
		--PRINT @SEQUENCE_LAPSE_ID
		
		IF (@CANCELLED_TRANS_ID IS NOT NULL)
		BEGIN 
			DBCC CHECKIDENT(#TEMP_CANCELLED_TRANS, RESEED, @CANCELLED_TRANS_ID) 
		END
		
		INSERT INTO #TEMP_CANCELLED_TRANS
		(
			ApprovalStatus, CancellationDate, CancellationReason, CancelledQuantity, EmployeeID, [Action], GrantOptionID, LastUpdatedBy, 
			LastUpdatedOn, GrantLegSerialNumber
		)
		SELECT 'A', CONVERT(DATE,TEMP_EMP.CancellationDate), TEMP_EMP.CancellationReasion, SUM(TEMP_EMP.SeparationCancellationQuantity), TEMP_EMP.EmployeeId, 'A', TEMP_EMP.GrantOptionId, 'ADMIN', GETDATE(), MIN(TEMP_EMP.[ID]) AS [ID]
		FROM #EMPLOYEE_SEPARATION_DATA AS TEMP_EMP
		INNER JOIN GrantLeg AS GL ON TEMP_EMP.ID = GL.ID
		GROUP BY TEMP_EMP.GrantOptionId, CONVERT(DATE,TEMP_EMP.CancellationDate), TEMP_EMP.CancellationReasion, TEMP_EMP.EmployeeId,
		TEMP_EMP.GrantOptionId
			
		-- UPDATE CANCELLED TRANS ID TO TEMP SEPARATION TABLE
		
		UPDATE TEMP SET CancelTransId = TEMP_CANTRANS.CancelledTransId FROM #EMPLOYEE_SEPARATION_DATA AS TEMP 
		INNER JOIN #TEMP_CANCELLED_TRANS AS TEMP_CANTRANS ON TEMP_CANTRANS.GrantOptionID = TEMP.GrantOptionId
		
		SELECT * FROM #TEMP_CANCELLED_TRANS

	END
	
	-------------------------------------------------------------
	-- CALCULATE SEPARATION QUANITTY IN TEMP GRANT APPROVAL TABLE
	-------------------------------------------------------------
	
	BEGIN

		INSERT INTO #TEMP_GRANT_APPROVAL 	
		(	
			GrantApprovalId, Separation_Cancelled_Quantity
		)
		SELECT GA.GrantApprovalId, SUM(ETEMP.SeparationCancellationQuantity) AS SEPARATION_CANCELLED_QUANTITY FROM #EMPLOYEE_SEPARATION_DATA AS ETEMP 
		INNER JOIN GrantApproval AS GA ON ETEMP.GrantApprovalId = GA.GrantApprovalId GROUP BY GA.GrantApprovalId

		SELECT GrantApprovalId, Separation_Cancelled_Quantity FROM #TEMP_GRANT_APPROVAL				
	
	END
	
	--------------------------------------------------------------------
	-- CALCULATE SHAREHOLDER APPROVAL IN TEMP SHAREHOLDER APPROVAL TABLE
	--------------------------------------------------------------------
	
	BEGIN
	
		INSERT INTO #TEMP_SHAREHOLDER_APPROVAL
		(
			ApprovalId, Separation_Cancelled_Quantity
		)
		SELECT SHA.ApprovalId, SUM(ETEMP.SeparationCancellationQuantity) AS Expiry_Lapse_Quantity FROM #EMPLOYEE_SEPARATION_DATA AS ETEMP 
		INNER JOIN GrantApproval AS GA ON ETEMP.GrantApprovalId = GA.GrantApprovalId
		INNER JOIN ShareHolderApproval AS SHA ON GA.ApprovalId = SHA.ApprovalId GROUP BY SHA.ApprovalId
				
		SELECT ApprovalId, Separation_Cancelled_Quantity FROM #TEMP_SHAREHOLDER_APPROVAL	

	END
	
	----------------------------------------------------------------------------------------------------------------------------
	-- DATABASE UPDATE AND MANIPULATIONS, UPADTE GRANT LEG, LAPSE TRANS, SEQUENCE TABLE, GRANT APPROVAL AND SHAREHOLDER APPROVAL
	----------------------------------------------------------------------------------------------------------------------------
	

	IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #EMPLOYEE_SEPARATION_DATA) > 0)		
		BEGIN 
		
			BEGIN TRY
				
				BEGIN TRANSACTION
		
					---- UPDATE DETAILS IN GRANT LEG TABLE
					
					UPDATE GL SET GL.ExercisableQuantity = 0, GL.CancelledQuantity = (ISNULL(GL.CancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), GL.SplitCancelledQuantity = (ISNULL(GL.SplitCancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), 
					GL.BonusSplitCancelledQuantity = (ISNULL(GL.BonusSplitCancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), GL.SeparationPerformed='Y', GL.CancellationDate = CONVERT(DATE,ETEMP.CancellationDate),
					GL.CancellationReason = ETEMP.CancellationReasion, GL.LastUpdatedBy = 'ADMIN', GL.LastUpdatedOn = GETDATE() FROM GrantLeg AS GL
					INNER JOIN #EMPLOYEE_SEPARATION_DATA AS ETEMP ON ETEMP.ID = GL.ID                                                 
					
					---- INSERT DETAILS INTO CANCELLED TRANS TABLE
						
					INSERT INTO CancelledTrans (CancelledTransID, ApprovalStatus, CancellationDate, CancellationReason, CancelledQuantity, EmployeeID, [Action], GrantOptionID, LastUpdatedBy, LastUpdatedOn, GrantLegSerialNumber)							
					SELECT CancelledTransId, ApprovalStatus, CONVERT(DATE,CancellationDate), CancellationReason, CancelledQuantity, EmployeeID, [Action], GrantOptionID, LastUpdatedBy, LastUpdatedOn, GrantLegSerialNumber FROM #TEMP_CANCELLED_TRANS
					
					---- INSERT DETAILS TO CANCELLED TABLE
					
					INSERT INTO Cancelled (CancelledId, GrantLegSerialNumber, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, CancelledTransID, 
					CancelledDate, CancelledPrice, VestingType, GrantLegId, CancellationType, [Status], LastUpdatedBy, LastUpdatedOn) 
					SELECT CancelledId, ID, SeparationCancellationQuantity, SeparationCancellationQuantity, SeparationCancellationQuantity, CancelTransId,
					 CONVERT(DATE,CancellationDate), '0.00', VestingType, GrantLegId, 'S', 'A', 'ADMIN', GETDATE() FROM #EMPLOYEE_SEPARATION_DATA
					
					---- UPDATE IN GRANT APPROVAL TABLE	

					UPDATE GA SET GA.AvailableShares = GA.AvailableShares + TGA.SEPARATION_CANCELLED_QUANTITY, GA.LastUpdatedBy = 'ADMIN', GA.LastUpdatedOn = GETDATE() FROM GrantApproval AS GA
					INNER JOIN #TEMP_GRANT_APPROVAL AS TGA ON TGA.GrantApprovalId = GA.GrantApprovalId
					WHERE TGA.SEPARATION_CANCELLED_QUANTITY > 0
					
					---- UPDATE SEQUENCE TABLE
					
					UPDATE SequenceTable SET SequenceNo = (SELECT MAX(CONVERT(BIGINT,ISNULL(CancelledId,0))) AS CancelledId FROM Cancelled)
					WHERE UPPER(Seq1) = 'CANCELLED'
					
					---- After discussion with Neha we will add addationl shares to Share Holder Approval table 
					---- UPDATE IN SHARESHOLDER TABLE

					--UPDATE SHA SET SHA.AvailableShares =  SHA.AvailableShares + TSHA.SEPARATION_CANCELLED_QUANTITY, SHA.LastUpdatedBy = 'ADMIN', SHA.LastUpdatedOn = GETDATE() FROM ShareHolderApproval AS SHA
					--INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TSHA ON TSHA.ApprovalId = SHA.ApprovalId 
					--WHERE TSHA.SEPARATION_CANCELLED_QUANTITY > 0
				
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
			PRINT 'NO DATA AVAILABLE FOR MOVE OPTION TO CANCELLED BUCKET'
		END
						
	---------------------
	-- TEMP TABLE DETAILS
	---------------------
					
	BEGIN
	
		DROP TABLE #EMPLOYEE_SEPARATION_DATA
		DROP TABLE #TEMP_CANCELLED_TRANS
		DROP TABLE #TEMP_GRANT_APPROVAL
		DROP TABLE #TEMP_SHAREHOLDER_APPROVAL
	
	END
	
	SET NOCOUNT OFF;
END
GO
