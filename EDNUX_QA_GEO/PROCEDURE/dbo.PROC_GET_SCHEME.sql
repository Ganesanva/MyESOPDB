/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEME]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SCHEME]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEME]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SCHEME]
	@SchemeId 	VARCHAR(50) = NULL,
	@ApproveId VARCHAR(20)= NULL
AS
BEGIN
	
	SET NOCOUNT ON;	
	/*Get scheme Records*/		   
    SELECT 
		ApprovalId, SchemeId, Status, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset,
		VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset,
		ExercisePeriodStartsAfter, PeriodUnit, LastUpdatedBy, LastUpdatedOn, UnVestedCancelledOptions, VestedCancelledOptions,
		LapsedOptions, IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPExedPayoutProcess, 
		PUP.PUPFORMULAID, PUP.PUP_FORMULA_TEXT, IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED , ISNULL(MIT_ID,0) AS MIT_ID, IS_AUTO_EXERCISE_ALLOWED
		,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCULATE_TAX_PREVESTING,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING 
    FROM Scheme 
    LEFT JOIN PUP_PAYOUTFMV_FORMULA PUP ON Scheme.PUPFORMULAID = PUP.PUPFORMULAID  
    WHERE 
		SchemeId = @SchemeId  
	
	/*Get Scheme Seperation Rule Records*/		 														
    SELECT 
		SR.Reason, SH.VestedOptionsLiveFor, SH.IsVestingOfUnvestedOptions, SH.UnvestedOptionsLiveFor, SH.OthersReason, 
		SH.VestedOptionsLiveTillExercisePeriod, 'Periodunit'= CASE WHEN SH.Periodunit='D' THEN 'Days' ELSE 'Months' END,
		'IsBypassed' = CASE WHEN SH.IsRuleBypassed = 'Y' THEN 'Yes' ELSE 'No' END 
    FROM SchemeSeperationRule AS SH 
    INNER JOIN SeperationRule AS SR ON SH.SeperationRuleId = SR.SeperationRuleId AND SH.SchemeId = @SchemeId  AND SH.ApprovalId = @ApproveId	 
	
	/*Get Auto Exercise Records*/	     
	SELECT 
		AEPC.AEC_ID, SchemeId, EXERCISE_ON, EXERCISE_AFTER_DAYS, COUNTRY_ID, IS_EXCEPTION_ENABLED, EXECPTION_FOR,
		EXECPTION_LIST, CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, IS_MAIL_ENABLE,MAIL_BEFORE_DAYS, MAIL_REMINDER_DAYS, 
		ISNULL(AEPC.IS_Reverse_Exercise_For_Seperation,'0') AS IS_Reverse_Exercise_For_Seperation
	FROM AUTO_EXERCISE_CONFIG AEC
	LEFT JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC on AEPC.AEC_ID = AEC.AEC_ID
	WHERE SchemeId=@SchemeId   
    
    /*Get Audit Trail Records*/	   
    SELECT
		CASE    
            WHEN (UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'IS EXCEPTION ACTIVE' 
			WHEN (UPPER(Field_Name)='IS_MAIL_ENABLE') THEN 'SEND MAIL' 
			WHEN (UPPER(Field_Name)='SchemeId') THEN 'SCHEME ID' 
			WHEN (UPPER(Field_Name)='EXERCISE_ON') THEN 'EXERCISE DATE' 
			WHEN (UPPER(Field_Name)='COUNTRY_ID') THEN 'COUNTRY MOVEMENT' 			
			WHEN (UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'EXCEPTION FOR' 
			WHEN (UPPER(Field_Name)='CALCUALTE_TAX_PRIOR_DAYS') THEN 'CALCUALTE TENTATIVE TAX' 
			WHEN (UPPER(Field_Name)='MAIL_BEFORE_DAYS') THEN 'BEFORE AUTO EXERCISE DATE' 
			WHEN (UPPER(Field_Name)='MAIL_REMINDER_DAYS') THEN 'REMINDER' 
			WHEN (UPPER(Field_Name)='EXECPTION_LIST') THEN 'EXCEPTION LIST' 
			WHEN (UPPER(Field_Name)='CALCULATE_TAX') THEN 'TAX CALCULATION' 				
			WHEN (UPPER(Field_Name)='EXERCISE_AFTER_DAYS') THEN 'EXERCISE AFTER DAYS'
			WHEN (UPPER(Field_Name)='EXECPTION_FOR') THEN 'EXCEPTION FOR'
			--featching prevesting payment mode selection
			WHEN (UPPER(Field_Name)='IS_PAYMENT_MODE_SELECTED') THEN 'IS PAYMENT MODE ACTIVE'
			WHEN (UPPER(Field_Name)='BEFORE_VESTING_DATE') THEN 'PERIOD BEFORE VESTING DATE'
			WHEN (UPPER(Field_Name)='PREVESTING_AUTOEXERCISE') THEN 'IS PREVESTING AUTOEXERCISE ACTIVE'
			WHEN (UPPER(Field_Name)='POSTVESTING_AUTOEXERCISE') THEN 'IS POSTVESTING AUTOEXERCISE ACTIVE'
			WHEN (UPPER(Field_Name)='POSTVESTING_DAYS') THEN 'POSTVESTING DAYS'
			WHEN (UPPER(Field_Name)='PAYMENT_MODE_NOT_SELECTED') THEN 'IS PAYMENT MODE ACTIVE'			
			WHEN (UPPER(Field_Name)='DEFAULT_PAYMENT_MODE') THEN 'DEFAULT PAYMENT MODE'
			WHEN (UPPER(Field_Name)='CANCELLATION_VESTED_OPTION') THEN 'CANCELLATION VESTED OPTION'			
			WHEN (UPPER(Field_Name)='DAYS_FROM_VESTING_DATE') THEN 'DAYS FROM VESTING DATE'
			WHEN (UPPER(Field_Name)='MAIL_MODE_PREVESTING') THEN 'IS MAIL ACTIVE FOR PREVESTING'
			WHEN (UPPER(Field_Name)='BEFORE_VESTING_DAYS') THEN 'BEFORE VESTING DAYS'
			WHEN (UPPER(Field_Name)='REMINDER_MAIL_DAYS') THEN 'REMINDER MAIL DAYS'
			WHEN (UPPER(Field_Name)='MAIL_ON_AUTO_CANCELLATION') THEN 'IS MAIL ACTIVE ON AUTO CANCELLATION'
			
		ELSE 		
			Field_Name 
		END	AS Field_Name,
        
        CASE  
            WHEN( upper(Old_value)='rdoVesting') THEN 'Vesting Date' 
            WHEN( upper(Old_value)='rdoDays') THEN 'Days after vesting date'
            WHEN( upper(Old_value)='rdoMovmentDate') THEN 'Vesting Date of Movment'
            WHEN( upper(Old_value)='rdoTentativeTax') THEN 'Tentative Tax Payment' 
            WHEN( upper(Old_value)='rdoActualtax') THEN 'Actual Tax Payment' 
            WHEN( upper(Old_value)='rdoResidentStatus') THEN 'Residential Status' 
            WHEN( upper(Old_value)='rdoCountry') THEN 'Country'   
            WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'Yes'
            WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'No'               
            --PRE-VESTING PAYMENT MODE SELECTION FIELDS
			WHEN( upper(Old_value)='rdoAfterXDays') THEN 'Cancellation Vested After Days'
			WHEN( upper(Old_value)='rdoAsOnVestingDate') THEN 'Cancellation As On Vesting Time'
			WHEN( upper(Old_value)='rdoAsOnActualExpiry') THEN 'Cancellation As On Actual Expiry'
			WHEN( upper(Old_value)='RdoDefaultPaymentMode') THEN 'Default Payment Mode'
			WHEN( upper(Old_value)='rdoCancellationVestedOption') THEN 'Cancellation Vested Option'			
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='IS_PAYMENT_MODE_SELECTED') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='IS_PAYMENT_MODE_SELECTED') THEN 'No'
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='PREVESTING_AUTOEXERCISE') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='PREVESTING_AUTOEXERCISE') THEN 'No'
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='POSTVESTING_AUTOEXERCISE') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='POSTVESTING_AUTOEXERCISE') THEN 'No'
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='PAYMENT_MODE_NOT_SELECTED') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='PAYMENT_MODE_NOT_SELECTED') THEN 'No'
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='CANCELLATION_VESTED_OPTION') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='CANCELLATION_VESTED_OPTION') THEN 'No'			
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='MAIL_MODE_PREVESTING') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='MAIL_MODE_PREVESTING') THEN 'No'
			WHEN( upper(Old_value)= '1' AND UPPER(Field_Name)='MAIL_ON_AUTO_CANCELLATION') THEN 'Yes'
			WHEN( upper(Old_value)= '0' AND UPPER(Field_Name)='MAIL_ON_AUTO_CANCELLATION') THEN 'No'	
		ELSE
			Old_value END  AS Old_value,
		
		CASE  
            WHEN( upper(New_Value)='rdoVesting') THEN 'Vesting Date' 
            WHEN( upper(New_Value)='rdoDays') THEN 'Days after vesting date'
            WHEN( upper(New_Value)='rdoMovmentDate') THEN 'Vesting Date of Movment'
            WHEN( upper(New_Value)='rdoTentativeTax') THEN 'Tentative Tax Payment' 
            WHEN( upper(New_Value)='rdoActualtax') THEN 'Actual Tax Payment' 
            WHEN( upper(New_Value)='rdoResidentStatus') THEN 'Residential Status' 
            WHEN( upper(New_Value)='rdoCountry') THEN 'Country'   
            WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'Yes'
            WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='IS_EXCEPTION_ENABLED') THEN 'No' 
             --PRE-VESTING PAYMENT MODE SELECTION FIELDS
			WHEN( upper(Old_value)='rdoAfterXDays') THEN 'Cancellation Vested After Days'
			WHEN( upper(Old_value)='rdoAsOnVestingDate') THEN 'Cancellation As On Vesting Time'
			WHEN( upper(Old_value)='rdoAsOnActualExpiry') THEN 'Cancellation As On Actual Expiry'
			WHEN( upper(Old_value)='RdoDefaultPaymentMode') THEN 'Default Payment Mode'
			WHEN( upper(Old_value)='rdoCancellationVestedOption') THEN 'Cancellation Vested Option'			
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='IS_PAYMENT_MODE_SELECTED') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='IS_PAYMENT_MODE_SELECTED') THEN 'No'
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='PREVESTING_AUTOEXERCISE') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='PREVESTING_AUTOEXERCISE') THEN 'No'
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='POSTVESTING_AUTOEXERCISE') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='POSTVESTING_AUTOEXERCISE') THEN 'No'
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='PAYMENT_MODE_NOT_SELECTED') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='PAYMENT_MODE_NOT_SELECTED') THEN 'No'
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='CANCELLATION_VESTED_OPTION') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='CANCELLATION_VESTED_OPTION') THEN 'No'			
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='MAIL_MODE_PREVESTING') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='MAIL_MODE_PREVESTING') THEN 'No'
			WHEN( upper(New_Value)= '1' AND UPPER(Field_Name)='MAIL_ON_AUTO_CANCELLATION') THEN 'Yes'
			WHEN( upper(New_Value)= '0' AND UPPER(Field_Name)='MAIL_ON_AUTO_CANCELLATION') THEN 'No'
		ELSE
			New_Value End  AS New_Value,             
        Created_By, Created_On, Updated_By, Updated_On, SchemeId, AEC_ID, ATSAE_ID
	FROM AUDIT_TRAIL_SCHEMEAUTOEXERCISE	
	WHERE 
		SchemeId = @SchemeId AND IS_Update=1 ORDER BY ATSAE_ID ASC
	SET NOCOUNT OFF;	
END
GO
