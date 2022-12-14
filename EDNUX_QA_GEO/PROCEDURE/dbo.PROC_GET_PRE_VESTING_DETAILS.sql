/****** Object:  StoredProcedure [dbo].[PROC_GET_PRE_VESTING_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PRE_VESTING_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PRE_VESTING_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_PRE_VESTING_DETAILS] 
AS
BEGIN	

	SET NOCOUNT ON;
	
	BEGIN /* CREATE TEMP TABLES */
	
		CREATE TABLE #TEMP_PRE_EXERCISE_DETAILS
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
			EXERCISABLE_QUANTITY NUMERIC(18,0), EXERCISE_DATE DATETIME, CALCULATE_TAX NVARCHAR(100),CALCUALTE_TAX_PRIOR_DAYS INT,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING INT
		)
							
	END
	
	INSERT INTO #TEMP_PRE_EXERCISE_DETAILS
	(
		ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantOptionId, GrantLegId, [Counter], VestingType, 
		GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent, FinalVestingDate, FinalExpirayDate, ExercisePrice, GrantDate, 
		LockInPeriodStartsFrom, LockInPeriod, OptionRatioMultiplier, OptionRatioDivisor, SchemeTitle, IsPaymentModeRequired, 
		PaymentModeEffectiveDate, MIT_ID, OptionTimePercentage, EmployeeId, LoginID,
		ResidentialStatus, TAX_IDENTIFIER_COUNTRY, A_GrantedQuantity, A_SplitQuantity, A_BonusSplitQuantity, 
		A_ExercisedQuantity, A_SplitExercisedQuantity, A_BonusSplitExercisedQuantity, A_CancelledQuantity, 
		A_SplitCancelledQuantity, A_BonusSplitCancelledQuantity, A_UnapprovedExerciseQuantity, T_LapsedQuantity, 
		A_ExercisableQuantity, EXERCISABLE_QUANTITY, EXERCISE_DATE, CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING	
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
		END), GL.FinalVestingDate, SC.CALCULATE_TAX,
		CASE WHEN (SC.CALCULATE_TAX='rdoTentativeTax' AND ISNULL(SC.CALCUALTE_TAX_PRIOR_DAYS,0)!=ISNULL(SC.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING,0)) OR SC.CALCULATE_TAX='rdoActualTax' THEN NULL
			 ELSE SC.CALCUALTE_TAX_PRIOR_DAYS
		END AS CALCUALTE_TAX_PRIOR_DAYS,
		SC.CALCUALTE_TAX_PRIOR_DAYS_PREVESTING			
	FROM 
		GrantLeg AS GL
		INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
		INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GL.GrantRegistrationId
		INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
		INNER JOIN VestingPeriod AS VP ON VP.VestingPeriodId = GL.VestingPeriodId
		INNER JOIN EmployeeMaster AS EMP ON EMP.EmployeeID = GOP.EmployeeId
		INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = GL.SchemeId
		INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.AEC_ID = AEC.AEC_ID		
	WHERE
		(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) 
		AND (GL.GrantedQuantity <> GL.ExercisedQuantity) AND (GL.GrantedQuantity <> GL.UnapprovedExerciseQuantity)
		AND (AEC.IS_APPROVE = 1) AND (AEPC.IS_APPROVE = 1) AND (UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END))
		AND (CONVERT(DATE,DATEADD(DAY, - (AEPC.BEFORE_VESTING_DATE),GL.FinalVestingDate)) = CONVERT(DATE, GETDATE()))	
		AND (Convert(date,GL.FinalVestingDate)> CONVERT(DATE, GETDATE()))			
		AND (GL.ExercisableQuantity > 0) AND (EMP.Deleted = 0)	
	ORDER BY GL.ID ASC 	 

	SELECT * FROM #TEMP_PRE_EXERCISE_DETAILS
	
	DROP TABLE #TEMP_PRE_EXERCISE_DETAILS
	
	SET NOCOUNT OFF;
END
GO
