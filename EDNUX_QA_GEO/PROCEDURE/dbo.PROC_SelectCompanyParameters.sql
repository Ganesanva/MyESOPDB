/****** Object:  StoredProcedure [dbo].[PROC_SelectCompanyParameters]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectCompanyParameters]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectCompanyParameters]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectCompanyParameters](@MIT_ID INT = NULL)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 	
		CP.CompanyID, CompanyEmailID, ShortTermCGTax, LongTermCGTax, VestingAlertNotice, ExpiryAlertNotice, ExpiryTime, ExcersiseFormText1, 
		ExcersiseFormText2, ListingDate, ListedYN, ES.Apply_Fifo, ExerciseFormPrequisitionText1, ExerciseFormPrequisitionText2, PreqTax_ExchangeType, 
		PreqTax_Shareprice, PreqTax_Calculateon, prqustcalcon, dbo.FN_PQ_TAX_ROUNDING(prequisiteTax) AS prequisiteTax, SendPrqstMailAfter, SendPrqstMailOn, 
		PerqTax_ApplyCash, CalcPerqtaxYN,Calc_PerqDt_From, Apply_Emp_taxslab, SendVestAlertYN, SendExpiryAlertYN, SendPerqMail, LastUpdatedBy, LastUpdatedOn, ReminderVestingAlert, 
		ReminderExpiryAlert, FBTax, FBTPayBy, FBTTravelInfoYN, BeforeVestDateYN, BeforeExpirtyDateYN, Is_PaymentGateway_Integrate, RoundupPlace_ExercisePrice, 
		RoundupPlace_ExerciseAmount, RoundupPlace_FMV, RoundupPlace_TaxAmt, RoundupPlace_TaxableVal, RoundupPalce_Gain, ES.Multiple_Grant_Exercise, ES.Exercise_Complete_Vest, 
		ES.DematDetails_check, dbo.FN_PQ_TAX_ROUNDING(TaxRate_ResignedEmp) AS TaxRate_ResignedEmp, FaceVaue, DematDtls_Required, rounding_param, ApplySAYE, SourceDPID, SourceDPAccount, ISIN, SecurityName, TransactionType, 
		Theme, SupportText, ES.Multiple_Vest_Exercise, ES.CheckUnderWater, RIPerqValue, RIPerqTax, NRIPerqValue, NRIPerqTax, FNPerqValue, FNPerqTax, ConfirmExerciseMailSent, 
		PayModeReminderDays, RoundingParam_ExercisePrice, RoundingParam_ExerciseAmount, RoundingParam_FMV, RoundingParam_Taxamt, RoundingParam_TaxableVal, RoundingParam_Gain, 
		IsReminderForPaymentModeSelection, MailFrom, isDownTimeSet, DownTimeMessage, DownTimeAccess, NominationTextNote, NominationAddress, EnableNominee, EmpEditNominee, 
		SendMailToEmp, NominationText, ReminderPerformanceVestingAlert, BeforePerfVestDateYN, SendPerfVestAlertYN, IncludeAcSlipOnExFrm, ES.HeaderForExerciseAmount, 
		ES.AccountNoForExerciseAmount, ES.HeaderForPerquisiteTax, ES.AccountNoForPerquisiteTax, CDSLSettings, ES.MinNoOfExeOpt, ES.MultipleForExeOpt, ES.isExeriseAtOneGo, ES.isExeSeparately, 
		IsSAPayModeAllowed, IsSPPayModeAllowed, IsSinglePayModeAllowed, BypassBankSelection, AutoRevForOnlineEx, AutoRevMinutes, 
		PERF_OPT_CAN_TREAT_ON, CAST(PERF_OPT_CAN_TREAT_APP_DT AS DATE) AS PERF_OPT_CAN_TREAT_APP_DT,
		ISNULL(IsSecondaryEmailIDForSep,0) AS IsSecondaryEmailIDForSep,ISNULL(IsSecondaryEmailIDForLive,0) AS IsSecondaryEmailIDForLive,	ISNULL(IsPrimaryEmailIDForLive,0) AS IsPrimaryEmailIDForLive,	ISNULL(IsPrimaryEmailIDForSep,0) AS IsPrimaryEmailIDForSep	
	FROM CompanyParameters AS CP, EXERCISE_SETTING ES		
	WHERE 
		(ES.MIT_ID = ISNULL(@MIT_ID,1))
	SET NOCOUNT OFF;
END
GO
