/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEMEDETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SCHEMEDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEMEDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SCHEMEDETAILS]
	 @SchemeId 	VARCHAR(50) = NULL,
	 @ApproveId VARCHAR(20)= NULL
AS
BEGIN
	SET NOCOUNT ON;	
	
	/*Get SHscheme records*/		   
	SELECT 
		SH.SchemeId, SH.ApprovalId, SH.SchemeTitle, SH.AdjustResidueOptionsIn, SH.VestingOverPeriodOffset, SH.VestingStartOffset,
		SH.VestingFrequency,SH.LockInPeriod,SH.LockInPeriodStartsFrom, SH.OptionRatioMultiplier, SH.OptionRatioDivisor, 
		SH.ExercisePeriodOffset, SH.ExercisePeriodStartsAfter, SH.LastUpdatedBy, SH.LastUpdatedOn, SH.Action,SH.PeriodUnit,
		SH.UnVestedCancelledOptions,SH.VestedCancelledOptions, SH.LapsedOptions, SH.IsPUPEnabled, SH.DisplayExPrice, SH.DisplayExpDate, 
		SH.DisplayPerqVal, SH.DisplayPerqTax, SH.PUPExedPayoutProcess, PUP.PUPFORMULAID, PUP.PUP_FORMULA_TEXT, SH.IS_ADS_SCHEME, 
		SH.IS_ADS_EX_OPTS_ALLOWED, SH.MIT_ID, SH.IS_AUTO_EXERCISE_ALLOWED, AUC.EXERCISE_ON,AUC.EXECPTION_FOR,AUC.EXECPTION_LIST, 
		SH.CALCULATE_TAX,SH.CALCUALTE_TAX_PRIOR_DAYS, AUC.IS_EXCEPTION_ENABLED, AUC.EXERCISE_AFTER_DAYS, SH.MIT_ID,SH.IS_AUTO_EXERCISE_ALLOWED,CALCULATE_TAX_PREVESTING, CALCUALTE_TAX_PRIOR_DAYS_PREVESTING                                                     
	FROM ShScheme SH 
	LEFT JOIN PUP_PAYOUTFMV_FORMULA PUP ON SH.PUPFORMULAID = PUP.PUPFORMULAID 
	LEFT JOIN AUTO_EXERCISE_CONFIG AUC ON AUC.SchemeId = SH.SchemeId 
	WHERE 
		SH.SchemeId = @SchemeId
	  	  
	/*Get SHScheme Separation Rule records*/	  
	SELECT
		SR.Reason, SH.VestedOptionsLiveFor, SH.UnvestedOptionsLiveFor, SH.OthersReason, SH.VestedOptionsLiveTillExercisePeriod, 
		SH.IsVestingOfUnvestedOptions, 'Periodunit'=CASE WHEN SH.Periodunit='D' THEN 'Days' ELSE 'Months' END, 
		'IsBypassed'= CASE WHEN SH.IsRuleBypassed='Y' THEN 'Yes' ELSE 'No' END  
	FROM ShSchemeSeparationRule AS SH 
	INNER JOIN SeperationRule AS SR ON SH.SeperationRuleId = SR.SeperationRuleId AND SH.SchemeId = @SchemeId AND SH.ApprovalId = @ApproveId     
    
    /*Get Auto Exercise records*/	 
	SELECT 
		AEC.AEC_ID, AEC.SchemeId, AEC.EXERCISE_ON, AEC.EXERCISE_AFTER_DAYS, AEC.COUNTRY_ID, AEC.IS_EXCEPTION_ENABLED, AEC.EXECPTION_FOR, AEC.EXECPTION_LIST, AEC.CALCULATE_TAX,
		AEC.CALCUALTE_TAX_PRIOR_DAYS, AEC.IS_MAIL_ENABLE,MAIL_BEFORE_DAYS, AEC.MAIL_REMINDER_DAYS,AEPC.IS_Reverse_Exercise_For_Seperation 
	FROM AUTO_EXERCISE_CONFIG AEC
	LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC ON AEC.AEC_ID = AEPC.AEC_ID
	WHERE AEC.SchemeId = @SchemeId AND AEC.IS_APPROVE <> 1 ORDER BY AEC.AEC_ID DESC
	                             
	SET NOCOUNT OFF;	
END
GO
