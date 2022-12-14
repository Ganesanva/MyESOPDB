/****** Object:  StoredProcedure [dbo].[PROC_GET_AUTOEXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_AUTOEXERCISED_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_AUTOEXERCISED_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_AUTOEXERCISED_DETAILS] 
AS
BEGIN	

	SET NOCOUNT ON;
	
	BEGIN /* CREATE TEMP TABLES */
	
		CREATE TABLE #TEMP_EXERCISE_DETAILS
		(
			ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100), GrantRegistrationId NVARCHAR(100), 
			GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(10), [Counter] NVARCHAR(10), VestingType NVARCHAR(2), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), Parent NVARCHAR(2), 
			FinalVestingDate DATETIME, FinalExpirayDate DATETIME, ExercisePrice NUMERIC(18,6), GrantDate DATETIME, 
			LockInPeriodStartsFrom NVARCHAR(2), LockInPeriod NUMERIC(18,0), OptionRatioMultiplier NUMERIC(18,2), OptionRatioDivisor NUMERIC(18,2), 
			SchemeTitle NVARCHAR(100), IsPaymentModeRequired NVARCHAR(2), PaymentModeEffectiveDate DATETIME, MIT_ID BIGINT, 
			OptionTimePercentage NUMERIC(18,2), EmployeeId NVARCHAR(100), LoginID NVARCHAR(100),
			ResidentialStatus NVARCHAR(2), TAX_IDENTIFIER_COUNTRY NVARCHAR(10), 
			A_GrantedQuantity NUMERIC(18,0), A_SplitQuantity NUMERIC(18,0), A_BonusSplitQuantity NUMERIC(18,0), 
			A_ExercisedQuantity NUMERIC(18,0), A_SplitExercisedQuantity NUMERIC(18,0), A_BonusSplitExercisedQuantity NUMERIC(18,0), 
			A_CancelledQuantity NUMERIC(18,0), A_SplitCancelledQuantity NUMERIC(18,0), A_BonusSplitCancelledQuantity NUMERIC(18,0), 
			A_UnapprovedExerciseQuantity NUMERIC(18,0), T_LapsedQuantity NUMERIC(18,0), A_ExercisableQuantity NUMERIC(18,0), 
			EXERCISABLE_QUANTITY NUMERIC(18,0)
		)
		
		CREATE TABLE #TEMP_AUTO_EXERCISE_DETAILS
		(
			ROW_ID BIGINT IDENTITY (1,1), ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100), GrantRegistrationId NVARCHAR(100), 
			GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(10), [Counter] NVARCHAR(10), VestingType NVARCHAR(2), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), Parent NVARCHAR(2), 
			FinalVestingDate DATETIME, FinalExpirayDate DATETIME, ExercisePrice NUMERIC(18,6), GrantDate DATETIME, 
			LockInPeriodStartsFrom NVARCHAR(2), LockInPeriod NUMERIC(18,0), OptionRatioMultiplier NUMERIC(18,2), OptionRatioDivisor NUMERIC(18,2), 
			SchemeTitle NVARCHAR(100), IsPaymentModeRequired NVARCHAR(2), PaymentModeEffectiveDate DATETIME, MIT_ID BIGINT, 
			OptionTimePercentage NUMERIC(18,2), EmployeeId NVARCHAR(100), LoginID NVARCHAR(100),
			ResidentialStatus NVARCHAR(2), TAX_IDENTIFIER_COUNTRY NVARCHAR(10), 
			A_GrantedQuantity NUMERIC(18,0), A_SplitQuantity NUMERIC(18,0), A_BonusSplitQuantity NUMERIC(18,0), 
			A_ExercisedQuantity NUMERIC(18,0), A_SplitExercisedQuantity NUMERIC(18,0), A_BonusSplitExercisedQuantity NUMERIC(18,0), 
			A_CancelledQuantity NUMERIC(18,0), A_SplitCancelledQuantity NUMERIC(18,0), A_BonusSplitCancelledQuantity NUMERIC(18,0), 
			A_UnapprovedExerciseQuantity NUMERIC(18,0), T_LapsedQuantity NUMERIC(18,0), A_ExercisableQuantity NUMERIC(18,0), 
			EXERCISABLE_QUANTITY NUMERIC(18,0),
			AEC_ID BIGINT, EXERCISE_ON NVARCHAR(200), EXERCISE_AFTER_DAYS BIGINT, IS_EXCEPTION_ENABLED TINYINT, EXECPTION_FOR NVARCHAR(200), 
			EXECPTION_LIST NVARCHAR(MAX), CALCULATE_TAX NVARCHAR(200), CALCUALTE_TAX_PRIOR_DAYS BIGINT, IS_MAIL_ENABLE TINYINT, 
			MAIL_BEFORE_DAYS BIGINT, MAIL_REMINDER_DAYS BIGINT, COUNTRY_ID NVARCHAR(MAX), EXERCISE_DATE DATETIME
		)
		
		CREATE TABLE #TEMP_DO_NOT_CONSIDER_FOR_AUTO_EXERCISE
		(
			ROW_ID BIGINT, ID BIGINT, ApprovalId NVARCHAR(100), SchemeId NVARCHAR(100), GrantApprovalId NVARCHAR(100), GrantRegistrationId NVARCHAR(100), 
			GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(10), [Counter] NVARCHAR(10), VestingType NVARCHAR(2), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), Parent NVARCHAR(2), 
			FinalVestingDate DATETIME, FinalExpirayDate DATETIME, ExercisePrice NUMERIC(18,6), GrantDate DATETIME, 
			LockInPeriodStartsFrom NVARCHAR(2), LockInPeriod NUMERIC(18,0), OptionRatioMultiplier NUMERIC(18,2), OptionRatioDivisor NUMERIC(18,2), 
			SchemeTitle NVARCHAR(100), IsPaymentModeRequired NVARCHAR(2), PaymentModeEffectiveDate DATETIME, MIT_ID BIGINT, 
			OptionTimePercentage NUMERIC(18,2), EmployeeId NVARCHAR(100), LoginID NVARCHAR(100),
			ResidentialStatus NVARCHAR(2), TAX_IDENTIFIER_COUNTRY NVARCHAR(10), 
			A_GrantedQuantity NUMERIC(18,0), A_SplitQuantity NUMERIC(18,0), A_BonusSplitQuantity NUMERIC(18,0), 
			A_ExercisedQuantity NUMERIC(18,0), A_SplitExercisedQuantity NUMERIC(18,0), A_BonusSplitExercisedQuantity NUMERIC(18,0), 
			A_CancelledQuantity NUMERIC(18,0), A_SplitCancelledQuantity NUMERIC(18,0), A_BonusSplitCancelledQuantity NUMERIC(18,0), 
			A_UnapprovedExerciseQuantity NUMERIC(18,0), T_LapsedQuantity NUMERIC(18,0), A_ExercisableQuantity NUMERIC(18,0), 
			EXERCISABLE_QUANTITY NUMERIC(18,0), DO_NOT_CONSIDER_FOR_AUTO_EXERCISE DATETIME
		)
		
		CREATE TABLE #TEMP_EMP_MOMENT_TRAKING
		(
			MOM_EMPLOYEE_ID NVARCHAR(400), MOM_MOVE_TO_ID BIGINT, MOM_MOVE_TO NVARCHAR(400), MOM_FROM_DATE_OF_MOVEMENT DATETIME
		)
		
	END
	
	--SELECT * FROM #TEMP_RESIDENTIAL_TYPE

	INSERT INTO #TEMP_EXERCISE_DETAILS
	(
		ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter], VestingType, 
		GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, 
		LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY
	
	)
	SELECT
		GL.ID, GL.ApprovalId, GL.SchemeId, GL.GrantApprovalId, GL.GrantRegistrationId, GL.GrantOptionId, GL.GrantLegId, GL.[Counter], GL.VestingType, 
		GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, GL.Parent, GL.FinalVestingDate, GL.FinalExpirayDate, GR.ExercisePrice, GR.GrantDate, 
		SC.LockInPeriodStartsFrom, SC.LockInPeriod, SC.OptionRatioMultiplier, SC.OptionRatioDivisor, SC.SchemeTitle, SC.IsPaymentModeRequired, 
		SC.PaymentModeEffectiveDate, SC.MIT_ID, VP.OptionTimePercentage, EMP.EmployeeId, EMP.LoginID, 
		EMP.ResidentialStatus, EMP.TAX_IDENTIFIER_COUNTRY, GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, 
		GL.ExercisedQuantity, GL.SplitExercisedQuantity, GL.BonusSplitExercisedQuantity, GL.CancelledQuantity, 
		GL.SplitCancelledQuantity, GL.BonusSplitCancelledQuantity, GL.UnapprovedExerciseQuantity, GL.LapsedQuantity, 
		GL.ExercisableQuantity, 
		(CASE WHEN 
			(GL.GrantedQuantity <> GL.UnapprovedExerciseQuantity) THEN GL.GrantedQuantity - (GL.UnapprovedExerciseQuantity + GL.CancelledQuantity + GL.ExercisedQuantity + GL.LapsedQuantity)
		ELSE 
			GL.GrantedQuantity
		END) 				
	FROM 
		GrantLeg AS GL
		INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
		INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GL.GrantRegistrationId
		INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
		INNER JOIN VestingPeriod AS VP ON VP.VestingPeriodId = GL.VestingPeriodId
		INNER JOIN EmployeeMaster AS EMP ON EMP.EmployeeID = GOP.EmployeeId
		INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = GL.SchemeId
	WHERE
		SC.IS_AUTO_EXERCISE_ALLOWED = 1 AND	(GETDATE() >= DATEADD(MONTH, SC.LockInPeriod, GL.FinalVestingDate))
		AND (GL.GrantedQuantity <> GL.ExercisedQuantity) AND (GL.GrantedQuantity <> GL.UnapprovedExerciseQuantity)
		AND AEC.IS_APPROVE = 1 AND (UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END))
		AND (GL.ExercisableQuantity > 0) AND (EMP.Deleted = 0)
	ORDER BY GL.ID ASC 	 
	
	IF ((SELECT COUNT(ID) FROM #TEMP_EXERCISE_DETAILS) > 0)
	BEGIN
		
		/* GET AUTO EXERCISE DETAILS FOR RDOVESTING*/ 
		INSERT INTO #TEMP_AUTO_EXERCISE_DETAILS
		(
			ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
			[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
			FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
			LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
			PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
			ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
			A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
			A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
			A_ExercisableQuantity, EXERCISABLE_QUANTITY,
			AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, 
			CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, 
			COUNTRY_ID, EXERCISE_DATE
		)
		SELECT 
			TED.ID, TED.ApprovalId, TED.SchemeId, TED.GrantApprovalId, TED.GrantRegistrationId, TED.GrantOptionId, TED.GrantLegId, 
			TED.[Counter], TED.VestingType, TED.GrantedQuantity, TED.SplitQuantity, TED.BonusSplitQuantity, TED.Parent, 
			TED.FinalVestingDate, TED.FinalExpirayDate, TED.ExercisePrice, TED.GrantDate, TED.LockInPeriodStartsFrom,  
			TED.LockInPeriod, TED.OptionRatioMultiplier, TED.OptionRatioDivisor, TED.SchemeTitle, TED.IsPaymentModeRequired, 
			TED.PaymentModeEffectiveDate, TED.MIT_ID, TED.OptionTimePercentage, TED.EmployeeId, TED.LoginID,
			TED.ResidentialStatus, TED.TAX_IDENTIFIER_COUNTRY, TED.A_GrantedQuantity, TED.A_SplitQuantity, TED.A_BonusSplitQuantity, 
			TED.A_ExercisedQuantity, TED.A_SplitExercisedQuantity, TED.A_BonusSplitExercisedQuantity, TED.A_CancelledQuantity, 
			TED.A_SplitCancelledQuantity, TED.A_BonusSplitCancelledQuantity, TED.A_UnapprovedExerciseQuantity, TED.T_LapsedQuantity, 
			TED.A_ExercisableQuantity, TED.EXERCISABLE_QUANTITY,
			AEC.AEC_ID, AEC.EXERCISE_ON, AEC.EXERCISE_AFTER_DAYS, AEC.IS_EXCEPTION_ENABLED, AEC.EXECPTION_FOR, AEC.EXECPTION_LIST, 
			AEC.CALCULATE_TAX, AEC.CALCUALTE_TAX_PRIOR_DAYS, AEC.IS_MAIL_ENABLE, AEC.MAIL_BEFORE_DAYS, AEC.MAIL_REMINDER_DAYS, 
			AEC.COUNTRY_ID, CONVERT(DATE, TED.FinalVestingDate)
			/*
			/* FOR DEBUG */
			,RES_TYP.id,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '' END),
			TED.TAX_IDENTIFIER_COUNTRY,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '' END)	
			*/		
		FROM 
			AUTO_EXERCISE_CONFIG AS AEC
			INNER JOIN #TEMP_EXERCISE_DETAILS AS TED ON TED.SchemeId = AEC.SchemeId
			INNER JOIN ResidentialType AS RES_TYP ON RES_TYP.ResidentialStatus = TED.ResidentialStatus
		WHERE 			
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDOVESTING') AND 
			(CONVERT(DATE, TED.FinalVestingDate) <= CONVERT(DATE, GETDATE()))
			AND	
			(
				(
					RES_TYP.id NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
				AND
				(
					TED.TAX_IDENTIFIER_COUNTRY NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
			)			
			
		--/* GET AUTO EXERCISE DETAILS FOR RDODAYS*/ 
		
		INSERT INTO #TEMP_AUTO_EXERCISE_DETAILS
		(
			ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
			[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
			FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
			LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
			PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
			ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
			A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
			A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
			A_ExercisableQuantity, EXERCISABLE_QUANTITY,
			AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, 
			CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, 
			COUNTRY_ID, EXERCISE_DATE
		)
		SELECT 
			TED.ID, TED.ApprovalId, TED.SchemeId, TED.GrantApprovalId, TED.GrantRegistrationId, TED.GrantOptionId, TED.GrantLegId, 
			TED.[Counter], TED.VestingType, TED.GrantedQuantity, TED.SplitQuantity, TED.BonusSplitQuantity, TED.Parent, 
			TED.FinalVestingDate, TED.FinalExpirayDate, TED.ExercisePrice, TED.GrantDate, TED.LockInPeriodStartsFrom,  
			TED.LockInPeriod, TED.OptionRatioMultiplier, TED.OptionRatioDivisor, TED.SchemeTitle, TED.IsPaymentModeRequired, 
			TED.PaymentModeEffectiveDate, TED.MIT_ID, TED.OptionTimePercentage, TED.EmployeeId, TED.LoginID,
			TED.ResidentialStatus, TED.TAX_IDENTIFIER_COUNTRY, TED.A_GrantedQuantity, TED.A_SplitQuantity, TED.A_BonusSplitQuantity, 
			TED.A_ExercisedQuantity, TED.A_SplitExercisedQuantity, TED.A_BonusSplitExercisedQuantity, TED.A_CancelledQuantity, 
			TED.A_SplitCancelledQuantity, TED.A_BonusSplitCancelledQuantity, TED.A_UnapprovedExerciseQuantity, TED.T_LapsedQuantity, 
			TED.A_ExercisableQuantity, TED.EXERCISABLE_QUANTITY,
			AEC.AEC_ID, AEC.EXERCISE_ON, AEC.EXERCISE_AFTER_DAYS, AEC.IS_EXCEPTION_ENABLED, AEC.EXECPTION_FOR, AEC.EXECPTION_LIST, 
			AEC.CALCULATE_TAX, AEC.CALCUALTE_TAX_PRIOR_DAYS, AEC.IS_MAIL_ENABLE, AEC.MAIL_BEFORE_DAYS, AEC.MAIL_REMINDER_DAYS, 
			AEC.COUNTRY_ID, (CONVERT(DATE,DATEADD(DAY, AEC.EXERCISE_AFTER_DAYS,TED.FinalVestingDate)))
			/*
			/* FOR DEBUG */
			,RES_TYP.id,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '' END),
			TED.TAX_IDENTIFIER_COUNTRY,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '' END)	
			*/
		FROM 
			AUTO_EXERCISE_CONFIG AS AEC			
			INNER JOIN #TEMP_EXERCISE_DETAILS AS TED ON TED.SchemeId = AEC.SchemeId
			INNER JOIN ResidentialType AS RES_TYP ON RES_TYP.ResidentialStatus = TED.ResidentialStatus
		WHERE 
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDODAYS') AND 
			(CONVERT(DATE,DATEADD(DAY, AEC.EXERCISE_AFTER_DAYS,TED.FinalVestingDate)) <= CONVERT(DATE,GETDATE()))			
			AND	
			(
				(
					RES_TYP.id NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
				AND
				(
					TED.TAX_IDENTIFIER_COUNTRY NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
			)			
		
		/* GET AUTO EXERCISE DETAILS FOR RDOMOVMENT*/ 
		
		INSERT INTO #TEMP_EMP_MOMENT_TRAKING 
		(
			MOM_EMPLOYEE_ID, MOM_MOVE_TO_ID, MOM_MOVE_TO, MOM_FROM_DATE_OF_MOVEMENT
		)
		SELECT 
			ATFTM.EmployeeId, CM.ID, ATFTM.[Moved To] AS Moved_To, ATFTM.[From Date of Movement] AS From_Date_of_Movement
		FROM 
			AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD AS ATFTM
			INNER JOIN
				(
					SELECT 
						EmployeeId, MAX([From Date of Movement]) AS [From Date of Movement]
					FROM 
						AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
					GROUP BY EmployeeId
				) ATFTM_1 
			ON ATFTM.EmployeeId = ATFTM_1.EmployeeId AND ATFTM.[From Date of Movement] = ATFTM_1.[From Date of Movement]
			INNER JOIN CountryMaster AS CM ON CM.CountryName = ATFTM.[Moved To]
		ORDER BY ATFTM.EmployeeId ASC
		
		
		INSERT INTO #TEMP_AUTO_EXERCISE_DETAILS
		(
			ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
			[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
			FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
			LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
			PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
			ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
			A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
			A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
			A_ExercisableQuantity, EXERCISABLE_QUANTITY,
			AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, 
			CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, 
			COUNTRY_ID, EXERCISE_DATE
		)
		SELECT 
			TED.ID, TED.ApprovalId, TED.SchemeId, TED.GrantApprovalId, TED.GrantRegistrationId, TED.GrantOptionId, TED.GrantLegId, 
			TED.[Counter], TED.VestingType, TED.GrantedQuantity, TED.SplitQuantity, TED.BonusSplitQuantity, TED.Parent, 
			TED.FinalVestingDate, TED.FinalExpirayDate, TED.ExercisePrice, TED.GrantDate, TED.LockInPeriodStartsFrom,  
			TED.LockInPeriod, TED.OptionRatioMultiplier, TED.OptionRatioDivisor, TED.SchemeTitle, TED.IsPaymentModeRequired, 
			TED.PaymentModeEffectiveDate, TED.MIT_ID, TED.OptionTimePercentage, TED.EmployeeId, TED.LoginID,
			TED.ResidentialStatus, TED.TAX_IDENTIFIER_COUNTRY, TED.A_GrantedQuantity, TED.A_SplitQuantity, TED.A_BonusSplitQuantity, 
			TED.A_ExercisedQuantity, TED.A_SplitExercisedQuantity, TED.A_BonusSplitExercisedQuantity, TED.A_CancelledQuantity, 
			TED.A_SplitCancelledQuantity, TED.A_BonusSplitCancelledQuantity, TED.A_UnapprovedExerciseQuantity, TED.T_LapsedQuantity, 
			TED.A_ExercisableQuantity, TED.EXERCISABLE_QUANTITY,
			AEC.AEC_ID, AEC.EXERCISE_ON, AEC.EXERCISE_AFTER_DAYS, AEC.IS_EXCEPTION_ENABLED, AEC.EXECPTION_FOR, AEC.EXECPTION_LIST, 
			AEC.CALCULATE_TAX, AEC.CALCUALTE_TAX_PRIOR_DAYS, AEC.IS_MAIL_ENABLE, AEC.MAIL_BEFORE_DAYS, AEC.MAIL_REMINDER_DAYS, 
			AEC.COUNTRY_ID, 
			(CASE WHEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE,TED.FinalVestingDate) THEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT)
							 WHEN CONVERT(DATE,TED.FinalVestingDate) >= CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) THEN CONVERT(DATE,TED.FinalVestingDate) ELSE CONVERT(DATE,GETDATE()) END)
			/*
				/* FOR DEBUG */
			,
			TEMT.MOM_FROM_DATE_OF_MOVEMENT, TEMT.MOM_MOVE_TO_ID,
			(CASE WHEN (MOM_MOVE_TO_ID NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING(AEC.COUNTRY_ID,','))) THEN 
						CASE WHEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE,TED.FinalVestingDate) THEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT)
							 WHEN CONVERT(DATE,TED.FinalVestingDate) >= CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) THEN CONVERT(DATE,TED.FinalVestingDate) ELSE '' END
						END) AS [OUTPUT]
			,RES_TYP.id,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '' END),
			TED.TAX_IDENTIFIER_COUNTRY,
			(CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '' END)	
			*/
		FROM 
			AUTO_EXERCISE_CONFIG AS AEC
			INNER JOIN #TEMP_EXERCISE_DETAILS AS TED ON TED.SchemeId = AEC.SchemeId
			INNER JOIN ResidentialType AS RES_TYP ON RES_TYP.ResidentialStatus = TED.ResidentialStatus
			INNER JOIN #TEMP_EMP_MOMENT_TRAKING AS TEMT ON TEMT.MOM_EMPLOYEE_ID = TED.EmployeeId
		WHERE 
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDOMOVMENTDATE') 
			AND 
			(
				(
					CASE WHEN (MOM_MOVE_TO_ID NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING(AEC.COUNTRY_ID,','))) THEN 
						CASE WHEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE,TED.FinalVestingDate) THEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT)
							 WHEN CONVERT(DATE,TED.FinalVestingDate) >= CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) THEN CONVERT(DATE,TED.FinalVestingDate) ELSE '' END
						END
				)
				<= CONVERT(DATE, GETDATE()) 
			 )			
			AND	
			(
				(
					RES_TYP.id NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDORESIDENTSTATUS') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
				AND
				(
					TED.TAX_IDENTIFIER_COUNTRY NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING((CASE WHEN (AEC.IS_EXCEPTION_ENABLED = 1) AND (UPPER(AEC.EXECPTION_FOR) = 'RDOCOUNTRY') THEN AEC.EXECPTION_LIST ELSE '0' END),','))
				)
			)	
	END
	
	/*
		 FOR CANCELLAITON RECORD CONDITION HANDEL FOR 
		 IF PAYMENT MODE SELECTED THEN CANCELLATION OPTION SELECTD THEN DO NOT CONSIDER OPTIONS FOR AUTO EXERCISE
	*/
	
	INSERT INTO #TEMP_DO_NOT_CONSIDER_FOR_AUTO_EXERCISE
	(
		ROW_ID, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter], VestingType, 
		GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, 
		LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY, DO_NOT_CONSIDER_FOR_AUTO_EXERCISE	
	)
	SELECT 
		ROW_ID, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
		[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
		FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
		LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY,
		(
			CASE 
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOASONVESTINGDATE') THEN TAED.FinalVestingDate 
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOAFTERXDAYS') THEN (CONVERT(DATE,DATEADD(DAY, AEPC.DAYS_FROM_VESTING_DATE,TAED.FinalVestingDate)))
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOASONACTUALEXPIRY') THEN TAED.FinalExpirayDate 
			ELSE
				NULL 
			END
		) AS DO_NOT_CONSIDER_FOR_AUTO_EXERCISE
	FROM
		#TEMP_AUTO_EXERCISE_DETAILS	AS TAED
		LEFT OUTER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC ON AEPC.SCHEME_ID = TAED.SchemeId	
	WHERE
		FinalVestingDate <= 
		(
			CASE 
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOASONVESTINGDATE') THEN TAED.FinalVestingDate 
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOAFTERXDAYS') THEN (CONVERT(DATE,DATEADD(DAY, AEPC.DAYS_FROM_VESTING_DATE,TAED.FinalVestingDate)))
				WHEN (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (UPPER(AEPC.PAYMENT_MODE_NOT_SELECTED) = 'RDOCANCELLATIONVESTEDOPTION') AND (UPPER(CANCELLATION_VESTED_OPTION) = 'RDOASONACTUALEXPIRY') THEN TAED.FinalExpirayDate 
			ELSE
				NULL 
			END
		) 
	
	DELETE FROM #TEMP_AUTO_EXERCISE_DETAILS WHERE ROW_ID IN (SELECT ROW_ID FROM #TEMP_DO_NOT_CONSIDER_FOR_AUTO_EXERCISE)
	
	SELECT 
		ROW_ID, ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, 
		[Counter], VestingType, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, 
		FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, LockInPeriodStartsFrom, 
		LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY,
		AEC_ID, EXERCISE_ON, EXERCISE_AFTER_DAYS, IS_EXCEPTION_ENABLED, EXECPTION_FOR, EXECPTION_LIST, 
		CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE, MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, EXERCISE_DATE
	FROM
		#TEMP_AUTO_EXERCISE_DETAILS		
	
	DROP TABLE #TEMP_EXERCISE_DETAILS	
	DROP TABLE #TEMP_AUTO_EXERCISE_DETAILS
	DROP TABLE #TEMP_EMP_MOMENT_TRAKING
	DROP TABLE #TEMP_DO_NOT_CONSIDER_FOR_AUTO_EXERCISE
	
	SET NOCOUNT OFF;
END
GO
