/****** Object:  StoredProcedure [dbo].[PROC_CANCELLED_NON_SEL_OF_PAYMENT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CANCELLED_NON_SEL_OF_PAYMENT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CANCELLED_NON_SEL_OF_PAYMENT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CANCELLED_NON_SEL_OF_PAYMENT] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @AND_CONDITION VARCHAR(MAX), @COMPANY_EMAIL_ID VARCHAR(200)
	DECLARE @SEPARATION_CANC_QTY VARCHAR(MAX)
	DECLARE @UPDATE_QUERY1 VARCHAR(MAX)		
	
	DECLARE @MailSubject NVARCHAR(500), @MailBody NVARCHAR(MAX), @MaxMsgId BIGINT
	
	SET @AND_CONDITION ='' 
	SET @SEPARATION_CANC_QTY = ''
	
	-----------------------------------
	-- CHECK AND SET BONUS SPLIT POLICY
	-----------------------------------
	
	BEGIN
		
		DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
		SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
	
		SELECT	
			@COMPANY_EMAIL_ID = CompanyEmailID
		FROM 
			CompanyParameters
		
		IF(@ApplyBonusTo='V')
			BEGIN
				IF(@ApplySplitTo='V')
					BEGIN
						-- Set Parameter GrantedQuantity, ExercisedQuantity, CancelledQuantity,
						SET @AND_CONDITION = ' (((GL.GrantedQuantity - (GL.CancelledQuantity + GL.ExercisedQuantity + GL.ExercisableQuantity + GL.LapsedQuantity + GL.UnapprovedExerciseQuantity))) = 0)'
						SET @SEPARATION_CANC_QTY = ' GL.GrantedQuantity - GL.ExercisedQuantity - GL.CancelledQuantity - GL.LapsedQuantity - GL.UnapprovedExerciseQuantity'
					END
				ELSE 
					BEGIN
						-- Set Parameter SplitQuantity, SplitExercisedQuantity, SplitCancelledQuantity, 						
						SET @AND_CONDITION = ' (((GL.SplitQuantity - (GL.SplitCancelledQuantity + GL.SplitExercisedQuantity + GL.ExercisableQuantity + GL.LapsedQuantity + GL.UnapprovedExerciseQuantity))) = 0)'
						SET @SEPARATION_CANC_QTY = ' GL.SplitQuantity - GL.SplitExercisedQuantity - GL.SplitCancelledQuantity - GL.LapsedQuantity - GL.UnapprovedExerciseQuantity'
					END
			END
		ELSE
			 BEGIN
					-- Set Parameter BonusSplitQuantity, BonusSplitExercisedQuantity, BonusSplitCancelledQuantity, 
				  SET @AND_CONDITION = ' (((GL.BonusSplitQuantity - (GL.BonusSplitCancelledQuantity + GL.BonusSplitExercisedQuantity + GL.ExercisableQuantity + GL.LapsedQuantity + GL.UnapprovedExerciseQuantity))) = 0)'	  
				  SET @SEPARATION_CANC_QTY = ' GL.BonusSplitQuantity - GL.BonusSplitExercisedQuantity - GL.BonusSplitCancelledQuantity - GL.LapsedQuantity - GL.UnapprovedExerciseQuantity'
			 END	
	
	END
	
	PRINT @ApplyBonusTo 
	PRINT @ApplySplitTo
	PRINT @SEPARATION_CANC_QTY
	---------------------------
	-- CREATE TEMP TABLES
	---------------------------
	
	BEGIN
	 
		---- TEMP TABLE FOR CANCELLATION DATA
		
		CREATE TABLE #EMPLOYEE_CANCELLATION_DATA
		(
			EmployeeId NVARCHAR(50), GrantApprovalId NVARCHAR(50), ID NVARCHAR(50), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(50), 
			VestingType NVARCHAR(10), GrantedOptions NUMERIC(18,0), GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), 
			BonusSplitQuantity NUMERIC(18,0), CancelledQuantity NUMERIC(18,0), SplitCancelledQuantity NUMERIC(18,0), 
			BonusSplitCancelledQuantity NUMERIC(18,0), ExercisedQuantity NUMERIC(18,0), SplitExercisedQuantity NUMERIC(18,0), 
			BonusSplitExercisedQuantity NUMERIC(18,0), ExercisableQuantity NUMERIC(18,0), LapsedQuantity NUMERIC(18,0), 
			UnapprovedExerciseQuantity NUMERIC(18,0), FinalVestingDate DATETIME, FinalExpirayDate DATETIME, IsPerfBased NVARCHAR(10), 
			CancelTransId NVARCHAR(50), CancelledId NUMERIC(18,0) IDENTITY (1, 1) NOT NULL,
			CancellationReasion NVARCHAR(200), CancellationDate DATETIME, SeparationCancellationQuantity NUMERIC(18,0),
			MAIL_ON_AUTO_CANCELLATION TINYINT, EMPLOYEE_EMAIL NVARCHAR(1000), EMPLOYEE_NAME NVARCHAR(1000), 
			SCHEME_ID NVARCHAR(500), SCHEME_NAME NVARCHAR(500)
		)
		
		CREATE TABLE #EMPLOYEE_CANCELLATION_DATA_MAIL
		(
			M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			M_EmployeeID NVARCHAR(100), M_EmployeeName NVARCHAR(200), M_EmployeeEmail NVARCHAR(200), 
			M_SchemeName NVARCHAR(500), M_GrantDate NVARCHAR(500), M_VestDate NVARCHAR(500), M_OptionsCancelled NVARCHAR(100),
			M_MailSubject VARCHAR(200), M_MailBody VARCHAR(MAX)
		)
		
		-- TEMP TABLE FOR CANCELLED TRANS
		
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
			DBCC CHECKIDENT(#EMPLOYEE_CANCELLATION_DATA, RESEED, @CANCELLED_ID) 
		END
	
	END
	
	---------------------------------------
	-- INSERT DETAILS INTO TEMP SEPARATION TABLE
	---------------------------------------
	
	BEGIN
	
		INSERT INTO #EMPLOYEE_CANCELLATION_DATA 	
		(	
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, GrantedOptions, GrantedQuantity, SplitQuantity, 
			BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity, 
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, 
			FinalVestingDate, FinalExpirayDate, IsPerfBased, MAIL_ON_AUTO_CANCELLATION, EMPLOYEE_EMAIL, EMPLOYEE_NAME, 
			SCHEME_ID, SCHEME_NAME, CancellationDate
		)
		SELECT 
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, GrantedOptions, GrantedQuantity, SplitQuantity, 
			BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity, 
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, 
			FinalVestingDate, FinalExpirayDate, IsPerfBased, MAIL_ON_AUTO_CANCELLATION, EmployeeEmail, 
			EmployeeName, SchemeId, SchemeTitle, CancellationDate
		FROM
		(
			/* CANCELLATION AS ON VESTING DATE */
			
			SELECT 
				GOP.EmployeeId, GL.GrantApprovalId, GL.ID, GL.GrantOptionId, GL.GrantLegId, GL.VestingType,  
				GL.GrantedOptions, GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, GL.CancelledQuantity, 
				GL.SplitCancelledQuantity, GL.BonusSplitCancelledQuantity, GL.ExercisedQuantity, GL.SplitExercisedQuantity, 
				GL.BonusSplitExercisedQuantity, GL.ExercisableQuantity, GL.LapsedQuantity, GL.UnapprovedExerciseQuantity, 
				GL.FinalVestingDate, GL.FinalExpirayDate, GL.IsPerfBased, AEPC.MAIL_ON_AUTO_CANCELLATION, EM.EmployeeEmail, 
				EM.EmployeeName, SC.SchemeId, SC.SchemeTitle, CONVERT(DATE,GL.FinalVestingDate) AS CancellationDate
			FROM 
				GrantLeg AS GL
				INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
				INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
				INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
			WHERE 
				(UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END)) AND
				(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND
				(UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) =  'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(AEPC.CANCELLATION_VESTED_OPTION) = 'RDOASONVESTINGDATE') 
				AND (CONVERT(DATE,GL.FinalVestingDate) <= CONVERT(DATE,GETDATE()))
				AND ((GL.GrantedQuantity <> GL.CancelledQuantity) AND (GL.SplitQuantity <> GL.SplitCancelledQuantity) AND (GL.BonusSplitQuantity <> GL.BonusSplitCancelledQuantity))
				AND (GL.ExercisableQuantity > 0 )

			UNION ALL
			
			/* CANCELLATION AS ON AFTER DAYS FROM DATE OF VESTING */

			SELECT 
				GOP.EmployeeId, GL.GrantApprovalId, GL.ID, GL.GrantOptionId, GL.GrantLegId, GL.VestingType,  
				GL.GrantedOptions, GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, GL.CancelledQuantity, 
				GL.SplitCancelledQuantity, GL.BonusSplitCancelledQuantity, GL.ExercisedQuantity, GL.SplitExercisedQuantity, 
				GL.BonusSplitExercisedQuantity, GL.ExercisableQuantity, GL.LapsedQuantity, GL.UnapprovedExerciseQuantity, 
				GL.FinalVestingDate, GL.FinalExpirayDate, GL.IsPerfBased, AEPC.MAIL_ON_AUTO_CANCELLATION, EM.EmployeeEmail, 
				EM.EmployeeName, SC.SchemeId, SC.SchemeTitle, CONVERT(DATE,DATEADD(DAY, AEPC.DAYS_FROM_VESTING_DATE,GL.FinalVestingDate)) AS CancellationDate	
			FROM 
				GrantLeg AS GL
				INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
				INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
				INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
			WHERE 
				(UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END)) AND
				(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND
				(UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) =  'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(AEPC.CANCELLATION_VESTED_OPTION) = 'RDOAFTERXDAYS') 
				AND (CONVERT(DATE,DATEADD(DAY, AEPC.DAYS_FROM_VESTING_DATE,GL.FinalVestingDate)) <= CONVERT(DATE,GETDATE()))
				AND ((GL.GrantedQuantity <> GL.CancelledQuantity) AND (GL.SplitQuantity <> GL.SplitCancelledQuantity) AND (GL.BonusSplitQuantity <> GL.BonusSplitCancelledQuantity))
				AND (GL.ExercisableQuantity > 0 )
				
			UNION ALL
			
			/* CANCELLATION AS ON ACTUAL EXPIRY DATE  */

			SELECT 
				GOP.EmployeeId, GL.GrantApprovalId, GL.ID, GL.GrantOptionId, GL.GrantLegId, GL.VestingType,  
				GL.GrantedOptions, GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, GL.CancelledQuantity, 
				GL.SplitCancelledQuantity, GL.BonusSplitCancelledQuantity, GL.ExercisedQuantity, GL.SplitExercisedQuantity, 
				GL.BonusSplitExercisedQuantity, GL.ExercisableQuantity, GL.LapsedQuantity, GL.UnapprovedExerciseQuantity, 
				GL.FinalVestingDate, GL.FinalExpirayDate, GL.IsPerfBased, AEPC.MAIL_ON_AUTO_CANCELLATION, EM.EmployeeEmail, 
				EM.EmployeeName, SC.SchemeId, SC.SchemeTitle, CONVERT(DATE,GL.FinalExpirayDate) AS CancellationDate
			FROM 
				GrantLeg AS GL
				INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
				INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
				INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = GL.SchemeId
				INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
			WHERE 
				(UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END)) AND
				(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND
				(UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) =  'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(AEPC.CANCELLATION_VESTED_OPTION) = 'RDOASONACTUALEXPIRY') 
				AND (CONVERT(DATE,GL.FinalExpirayDate) <= CONVERT(DATE,GETDATE()))
				AND ((GL.GrantedQuantity <> GL.CancelledQuantity) AND (GL.SplitQuantity <> GL.SplitCancelledQuantity) AND (GL.BonusSplitQuantity <> GL.BonusSplitCancelledQuantity))
				AND (GL.ExercisableQuantity > 0 )
		)
		TEMP 
		ORDER BY ID ASC

		-- UPDATE CANCELLATION REASION, DATE, SEPARATION STATUS, SEPARATION CANCELLED QUANTITY
		
		SET @UPDATE_QUERY1 = 
		' 
			UPDATE TEMP 
				SET TEMP.CancellationReasion = ''Cancelled due to non-selection of payment mode for scheme under auto exercise'',
				TEMP.SeparationCancellationQuantity = '+ @SEPARATION_CANC_QTY +'
			FROM 
				#EMPLOYEE_CANCELLATION_DATA AS TEMP 
				INNER JOIN GrantLeg AS GL ON TEMP.ID = GL.ID
			WHERE 
				'+@AND_CONDITION+' AND '+@SEPARATION_CANC_QTY+'<>0' 	
		
		EXECUTE (@UPDATE_QUERY1)
		--PRINT @UPDATE_QUERY1
		
		--------------------------------
		---- EMPLOYEE SEPARATION DETAILS
		--------------------------------
				
		SELECT 
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, GrantedOptions, GrantedQuantity, SplitQuantity, 
			BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity, 
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, 
			FinalVestingDate, FinalExpirayDate, IsPerfBased, CancelTransId, CancelledId, CancellationReasion, CancellationDate, 
			SeparationCancellationQuantity, MAIL_ON_AUTO_CANCELLATION, EMPLOYEE_EMAIL, EMPLOYEE_NAME, SCHEME_ID, SCHEME_NAME 
		FROM 
			#EMPLOYEE_CANCELLATION_DATA		
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
		FROM #EMPLOYEE_CANCELLATION_DATA AS TEMP_EMP
		INNER JOIN GrantLeg AS GL ON TEMP_EMP.ID = GL.ID
		GROUP BY TEMP_EMP.GrantOptionId, CONVERT(DATE,TEMP_EMP.CancellationDate), TEMP_EMP.CancellationReasion, TEMP_EMP.EmployeeId,
		TEMP_EMP.GrantOptionId
			
		-- UPDATE CANCELLED TRANS ID TO TEMP SEPARATION TABLE
		
		UPDATE TEMP SET CancelTransId = TEMP_CANTRANS.CancelledTransId FROM #EMPLOYEE_CANCELLATION_DATA AS TEMP 
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
		SELECT GA.GrantApprovalId, SUM(ETEMP.SeparationCancellationQuantity) AS SEPARATION_CANCELLED_QUANTITY FROM #EMPLOYEE_CANCELLATION_DATA AS ETEMP 
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
		SELECT SHA.ApprovalId, SUM(ETEMP.SeparationCancellationQuantity) AS Expiry_Lapse_Quantity FROM #EMPLOYEE_CANCELLATION_DATA AS ETEMP 
		INNER JOIN GrantApproval AS GA ON ETEMP.GrantApprovalId = GA.GrantApprovalId
		INNER JOIN ShareHolderApproval AS SHA ON GA.ApprovalId = SHA.ApprovalId GROUP BY SHA.ApprovalId
				
		SELECT ApprovalId, Separation_Cancelled_Quantity FROM #TEMP_SHAREHOLDER_APPROVAL	

	END
	
	--------------------------------------------------------------------
	-- INSERT INTO MAILER DB 
	--------------------------------------------------------------------
	SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(FORMATS) = 'CANCELLATIONOFOPTIONSDUETONON-EXERCISE'
	
	-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
		
	SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
	BEGIN
		DBCC CHECKIDENT(#EMPLOYEE_CANCELLATION_DATA_MAIL, RESEED, @MaxMsgId)
	END
		
	INSERT INTO #EMPLOYEE_CANCELLATION_DATA_MAIL 
	(
		M_EmployeeID, M_EmployeeName, M_EmployeeEmail, M_SchemeName, M_GrantDate, M_VestDate, M_OptionsCancelled,
		M_MailSubject, M_MailBody
	)
	SELECT 
		ECD.EmployeeId, ECD.EMPLOYEE_NAME, ECD.EMPLOYEE_EMAIL, ECD.SCHEME_NAME, GR.GrantDate, ECD.FinalVestingDate, 
		ECD.SeparationCancellationQuantity, @MailSubject, @MailBody		
	FROM
		#EMPLOYEE_CANCELLATION_DATA AS ECD	
		INNER JOIN GrantRegistration AS GR ON GR.SchemeId = ECD.SCHEME_ID
	WHERE (ECD.MAIL_ON_AUTO_CANCELLATION = 1)
	
	IF((SELECT COUNT(M_EmployeeID) AS ROW_COUNT FROM #EMPLOYEE_CANCELLATION_DATA_MAIL) > 0)	
	BEGIN						
		SELECT 
			M_Message_ID, M_EmployeeID, M_EmployeeName, M_EmployeeEmail, M_SchemeName, M_GrantDate, M_VestDate, 
			M_OptionsCancelled, M_MailSubject,  
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(M_MailBody,'{0}',M_EmployeeName),'{2}', M_SchemeName),'{3}',REPLACE(CONVERT(VARCHAR(11), M_GrantDate, 106), ' ', '/')),'{4}',REPLACE(CONVERT(VARCHAR(11), M_VestDate, 106), ' ', '/')),'{5}',M_OptionsCancelled),'{6}',@COMPANY_EMAIL_ID) AS M_MailBody			
		FROM #EMPLOYEE_CANCELLATION_DATA_MAIL
		WHERE (M_MailBody IS NOT NULL)									
	END	
											
	----------------------------------------------------------------------------------------------------------------------------
	-- DATABASE UPDATE AND MANIPULATIONS, UPADTE GRANT LEG, LAPSE TRANS, SEQUENCE TABLE, GRANT APPROVAL AND SHAREHOLDER APPROVAL
	----------------------------------------------------------------------------------------------------------------------------	

	IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #EMPLOYEE_CANCELLATION_DATA) > 0)		
		BEGIN 
		
			BEGIN TRY
				
				BEGIN TRANSACTION
					
					-- UPDATE DETAILS IN GRANT LEG TABLE
					
					UPDATE GL SET GL.ExercisableQuantity = 0, GL.CancelledQuantity = (ISNULL(GL.CancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), GL.SplitCancelledQuantity = (ISNULL(GL.SplitCancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), 
					GL.BonusSplitCancelledQuantity = (ISNULL(GL.BonusSplitCancelledQuantity,0) + ETEMP.SeparationCancellationQuantity), GL.CancellationDate = CONVERT(DATE,ETEMP.CancellationDate),
					GL.CancellationReason = ETEMP.CancellationReasion, GL.LastUpdatedBy = 'ADMIN', GL.LastUpdatedOn = GETDATE() FROM GrantLeg AS GL
					INNER JOIN #EMPLOYEE_CANCELLATION_DATA AS ETEMP ON ETEMP.ID = GL.ID                                                 
					
					-- INSERT DETAILS INTO CANCELLED TRANS TABLE
						
					INSERT INTO CancelledTrans (CancelledTransID, ApprovalStatus, CancellationDate, CancellationReason, CancelledQuantity, EmployeeID, [Action], GrantOptionID, LastUpdatedBy, LastUpdatedOn, GrantLegSerialNumber)							
					SELECT CancelledTransId, ApprovalStatus, CONVERT(DATE,CancellationDate), CancellationReason, CancelledQuantity, EmployeeID, [Action], GrantOptionID, LastUpdatedBy, LastUpdatedOn, GrantLegSerialNumber FROM #TEMP_CANCELLED_TRANS
					
					-- INSERT DETAILS TO CANCELLED TABLE
					
					INSERT INTO Cancelled (CancelledId, GrantLegSerialNumber, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, CancelledTransID, 
					CancelledDate, CancelledPrice, VestingType, GrantLegId, CancellationType, [Status], LastUpdatedBy, LastUpdatedOn) 
					SELECT CancelledId, ID, SeparationCancellationQuantity, SeparationCancellationQuantity, SeparationCancellationQuantity, CancelTransId,
					 CONVERT(DATE,CancellationDate), '0.00', VestingType, GrantLegId, 'S', 'A', 'ADMIN', GETDATE() FROM #EMPLOYEE_CANCELLATION_DATA
					
					-- UPDATE IN GRANT APPROVAL TABLE	

					UPDATE GA SET GA.AvailableShares = GA.AvailableShares + TGA.SEPARATION_CANCELLED_QUANTITY, GA.LastUpdatedBy = 'ADMIN', GA.LastUpdatedOn = GETDATE() FROM GrantApproval AS GA
					INNER JOIN #TEMP_GRANT_APPROVAL AS TGA ON TGA.GrantApprovalId = GA.GrantApprovalId
					WHERE TGA.SEPARATION_CANCELLED_QUANTITY > 0
					
					-- UPDATE SEQUENCE TABLE
					
					UPDATE SequenceTable SET SequenceNo = (SELECT MAX(CONVERT(BIGINT,ISNULL(CancelledId,0))) AS CancelledId FROM Cancelled)
					WHERE UPPER(Seq1) = 'CANCELLED'
					
					-- After discussion with Neha we will add addationl shares to Share Holder Approval table 
					-- UPDATE IN SHARESHOLDER TABLE

					--UPDATE SHA SET SHA.AvailableShares =  SHA.AvailableShares + TSHA.SEPARATION_CANCELLED_QUANTITY, SHA.LastUpdatedBy = 'ADMIN', SHA.LastUpdatedOn = GETDATE() FROM ShareHolderApproval AS SHA
					--INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TSHA ON TSHA.ApprovalId = SHA.ApprovalId 
					--WHERE TSHA.SEPARATION_CANCELLED_QUANTITY > 0

					IF((SELECT COUNT(M_EmployeeID) AS ROW_COUNT FROM #EMPLOYEE_CANCELLATION_DATA_MAIL) > 0)	
					BEGIN						
						-- INSSET INTO MAIL SPOOL TABLE
						INSERT INTO [MailerDB].[dbo].[MailSpool]
						([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
						SELECT 
							M_Message_ID, @COMPANY_EMAIL_ID, M_EmployeeEmail, M_MailSubject, 
							REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(M_MailBody,'{0}',M_EmployeeName),'{2}', M_SchemeName),'{3}',REPLACE(CONVERT(VARCHAR(11), M_GrantDate, 106), ' ', '/')),'{4}',REPLACE(CONVERT(VARCHAR(11), M_VestDate, 106), ' ', '/')),'{5}',M_OptionsCancelled),'{6}',@COMPANY_EMAIL_ID) AS M_MailBody, 
							NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() 
						FROM #EMPLOYEE_CANCELLATION_DATA_MAIL
						WHERE (M_MailBody IS NOT NULL)									
					END													
				
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
		DROP TABLE #EMPLOYEE_CANCELLATION_DATA
		DROP TABLE #EMPLOYEE_CANCELLATION_DATA_MAIL
		DROP TABLE #TEMP_CANCELLED_TRANS
		DROP TABLE #TEMP_GRANT_APPROVAL
		DROP TABLE #TEMP_SHAREHOLDER_APPROVAL	
	END
	
	SET NOCOUNT OFF;
END
GO
