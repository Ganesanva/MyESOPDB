/****** Object:  StoredProcedure [dbo].[PROC_UpdateCompanyParameters]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateCompanyParameters]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateCompanyParameters]    Script Date: 7/8/2022 3:00:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateCompanyParameters] @CompanyID VARCHAR(20)
    ,@CompanyEmailID VARCHAR(50) = NULL
	,@ShortTermCGTax NUMERIC(9,0) = NULL
	,@LongTermCGTax NUMERIC(9,0) = NULL
	,@VestingAlertNotice NUMERIC(9,0) = NULL
	,@ExpiryAlertNotice NUMERIC(9,0) = NULL
	,@ExpiryTime NUMERIC(9,0) = NULL
	,@ExcersiseFormText1 VARCHAR(MAX) = NULL
	,@ExcersiseFormText2 VARCHAR(MAX) = NULL
	,@ReminderVestingAlert NUMERIC(9,0) = NULL
	,@ReminderExpiryAlert NUMERIC(9,0) = NULL
	,@FBTax NUMERIC(9,2) = NULL
	,@FBTPayBy VARCHAR(20) = NULL
	,@FBTTravelInfoYN CHAR = NULL
	,@BeforeVestDateYN CHAR = NULL
	,@BeforeExpirtyDateYN CHAR = NULL
	,@ListingDate DATETIME = NULL
	,@ListedYN CHAR = NULL
	,@Apply_Fifo CHAR = NULL
	,@prqustcalcon CHAR = NULL
	,@SendPrqstMailAfter NUMERIC(9,0) = NULL
	,@SendPrqstMailOn NUMERIC(9,0) = NULL
	,@prequisiteTax NUMERIC(18,6) = NULL
	,@ExerciseFormPrequisitionText1 VARCHAR(MAX) = NULL
	,@ExerciseFormPrequisitionText2 VARCHAR(MAX) = NULL
	,@PreqTax_ExchangeType CHAR = NULL
	,@PreqTax_Shareprice INT = NULL
	,@PreqTax_Calculateon CHAR = NULL
	,@PerqTax_ApplyCash CHAR = NULL
	,@SendPerqMail CHAR = NULL
	,@CalcPerqtaxYN CHAR = NULL
	,@Calc_PerqDt_From DATETIME = NULL
	,@Apply_Emp_taxslab CHAR = NULL
	,@SendVestAlertYN VARCHAR(1) = NULL
	,@SendExpiryAlertYN VARCHAR(1) = NULL
	,@Is_PaymentGateway_Integrate CHAR(1) = NULL
	,@RoundupPlace_ExercisePrice NUMERIC(9,0) = NULL
	,@RoundupPlace_ExerciseAmount NUMERIC(9,0) = NULL
	,@RoundupPlace_FMV NUMERIC(9,0) = NULL
	,@RoundupPlace_TaxAmt NUMERIC(9,0) = NULL
	,@RoundupPlace_TaxableVal NUMERIC(9,0) = NULL
	,@RoundupPalce_Gain NUMERIC(9,0) = NULL
	,@Multiple_Grant_Exercise CHAR = NULL
	,@Exercise_Complete_Vest CHAR = NULL
	,@TaxRate_ResignedEmp NUMERIC(18,6) = NULL
	,@FaceVaue NUMERIC(9,2) = NULL
	,@DematDetails_check CHAR(1) = NULL
	,@Theme VARCHAR(20) = NULL
	,@SupportText VARCHAR(MAX) = NULL
	,@SourceDPID VARCHAR(50) = NULL
	,@SourceDPAccount VARCHAR(50) = NULL
	,@ISIN VARCHAR(50) = NULL
	,@SecurityName VARCHAR(50) = NULL
	,@TransactionType VARCHAR(50) = NULL
	,@ApplySAYE CHAR(10) = NULL
	,@Multiple_Vest_Exercise CHAR = NULL
	,@rounding_param VARCHAR(1) = NULL
	,@CheckUnderWater VARCHAR(10) = NULL
	,@RIPerqValue CHAR = NULL
	,@RIPerqTax CHAR = NULL
	,@NRIPerqValue CHAR = NULL
	,@NRIPerqTax CHAR = NULL
	,@FNPerqValue CHAR = NULL
	,@FNPerqTax CHAR = NULL
	,@LastUpdatedBy VARCHAR(20) = NULL
	,@ConfirmExerciseMailSent CHAR = NULL
	,@PayModeReminderDays INT = NULL
	,@IsReminderForPaymentModeSelection CHAR = NULL
	,@ReminderPerformanceVestingAlert NUMERIC(9,0) = NULL
	,@BeforePerfVestDateYN CHAR = NULL
	,@SendPerfVestAlertYN VARCHAR(1) = NULL
	,@RoundingParam_ExercisePrice CHAR = NULL
	,@RoundingParam_ExerciseAmount CHAR = NULL
	,@RoundingParam_FMV CHAR = NULL
	,@RoundingParam_Taxamt CHAR = NULL
	,@RoundingParam_TaxableVal CHAR = NULL
	,@RoundingParam_Gain CHAR = NULL
	,@MinNoOfExeOpt VARCHAR(10) = NULL
	,@MultipleForExeOpt VARCHAR(10) = NULL
	,@isExeriseAtOneGo CHAR = NULL
	,@isExeSeparately CHAR = NULL
	,@PrimarymailidforLive BIT = NULL
	,@SecondaryMailidforLive BIT = NULL
	,@PrimarymailidforSep BIT = NULL
	,@SecondarmailidForSep BIT = NULL
	
	,@retValue INT OUTPUT 
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements. 
 SET NOCOUNT ON;  
  
 UPDATE CompanyParameters
 SET CompanyEmailID = ISNULL(@CompanyEmailID,CompanyEmailID)
	,ShortTermCGTax = ISNULL(@ShortTermCGTax,ShortTermCGTax)
	,LongTermCGTax = ISNULL(@LongTermCGTax,LongTermCGTax)
	,VestingAlertNotice = ISNULL(@VestingAlertNotice,VestingAlertNotice)
	,ExpiryAlertNotice = ISNULL(@ExpiryAlertNotice,ExpiryAlertNotice)
	,ExpiryTime = ISNULL(@ExpiryTime,ExpiryTime)
	,ExcersiseFormText1 = ISNULL(@ExcersiseFormText1,ExcersiseFormText1)
	,ExcersiseFormText2 = ISNULL(@ExcersiseFormText2,ExcersiseFormText2)
	,ReminderVestingAlert = ISNULL(@ReminderVestingAlert,ReminderVestingAlert)
	,ReminderExpiryAlert = ISNULL(@ReminderExpiryAlert,ReminderExpiryAlert)
	,FBTax = ISNULL(@FBTax,FBTax)
	,FBTPayBy = ISNULL(@FBTPayBy,FBTPayBy)
	,FBTTravelInfoYN = ISNULL(@FBTTravelInfoYN,FBTTravelInfoYN)
	,BeforeVestDateYN = ISNULL(@BeforeVestDateYN,BeforeVestDateYN)
	,BeforeExpirtyDateYN = ISNULL(@BeforeExpirtyDateYN,BeforeExpirtyDateYN)
	,ListingDate = ISNULL(@ListingDate,ListingDate)
	,ListedYN = ISNULL(@ListedYN,ListedYN)
	,Apply_Fifo = ISNULL(@Apply_Fifo,Apply_Fifo)
	,prqustcalcon = ISNULL(@prqustcalcon,prqustcalcon)
	,SendPrqstMailAfter = ISNULL(@SendPrqstMailAfter,SendPrqstMailAfter)
	,SendPrqstMailOn = ISNULL(@SendPrqstMailOn,SendPrqstMailOn)
	,prequisiteTax = ISNULL(@prequisiteTax,prequisiteTax)
	,ExerciseFormPrequisitionText1 = ISNULL(@ExerciseFormPrequisitionText1,ExerciseFormPrequisitionText1)
	,ExerciseFormPrequisitionText2 = ISNULL(@ExerciseFormPrequisitionText2,ExerciseFormPrequisitionText2)
	,PreqTax_ExchangeType = ISNULL(@PreqTax_ExchangeType,PreqTax_ExchangeType)
	,PreqTax_Shareprice = ISNULL(@PreqTax_Shareprice,PreqTax_Shareprice)
	,PreqTax_Calculateon = ISNULL(@PreqTax_Calculateon,PreqTax_Calculateon)
	,PerqTax_ApplyCash = ISNULL(@PerqTax_ApplyCash,PerqTax_ApplyCash)
	,SendPerqMail = ISNULL(@SendPerqMail,SendPerqMail)
	,CalcPerqtaxYN = ISNULL(@CalcPerqtaxYN,CalcPerqtaxYN)
	,Calc_PerqDt_From = ISNULL(@Calc_PerqDt_From,Calc_PerqDt_From)
	,Apply_Emp_taxslab = ISNULL(@Apply_Emp_taxslab,Apply_Emp_taxslab)
	,SendVestAlertYN = ISNULL(@SendVestAlertYN,SendVestAlertYN)
	,SendExpiryAlertYN = ISNULL(@SendExpiryAlertYN,SendExpiryAlertYN)
	,Is_PaymentGateway_Integrate = ISNULL(@Is_PaymentGateway_Integrate,Is_PaymentGateway_Integrate)
	,RoundupPlace_ExercisePrice = ISNULL(@RoundupPlace_ExercisePrice,RoundupPlace_ExercisePrice)
	,RoundupPlace_ExerciseAmount = ISNULL(@RoundupPlace_ExerciseAmount,RoundupPlace_ExerciseAmount)
	,RoundupPlace_FMV = ISNULL(@RoundupPlace_FMV,RoundupPlace_FMV)
	,RoundupPlace_TaxAmt = ISNULL(@RoundupPlace_TaxAmt,RoundupPlace_TaxableVal)
	,RoundupPlace_TaxableVal = ISNULL(@RoundupPlace_TaxableVal,RoundupPlace_TaxableVal)
	,RoundupPalce_Gain = ISNULL(@RoundupPalce_Gain,RoundupPalce_Gain)
	,Multiple_Grant_Exercise = ISNULL(@Multiple_Grant_Exercise,Multiple_Grant_Exercise)
	,Exercise_Complete_Vest = ISNULL(@Exercise_Complete_Vest,Exercise_Complete_Vest)
	,TaxRate_ResignedEmp = ISNULL(@TaxRate_ResignedEmp,TaxRate_ResignedEmp)
	,FaceVaue = ISNULL(@FaceVaue,FaceVaue)
	,DematDetails_check = ISNULL(@DematDetails_check,DematDetails_check)
	,Theme = ISNULL(@Theme,Theme)
	,SupportText = ISNULL(@SupportText,SupportText)
	,SourceDPID = ISNULL(@SourceDPID,SourceDPID)
	,SourceDPAccount = ISNULL(@SourceDPAccount,SourceDPAccount)
	,ISIN = ISNULL(@ISIN,ISIN)
	,SecurityName = ISNULL(@SecurityName,SecurityName)
	,TransactionType = ISNULL(@TransactionType,TransactionType)
	,ApplySAYE = ISNULL(@ApplySAYE,ApplySAYE)
	,Multiple_Vest_Exercise = ISNULL(@Multiple_Vest_Exercise,Multiple_Vest_Exercise)
	,rounding_param = ISNULL(@rounding_param,rounding_param)
	,CheckUnderWater = ISNULL(@CheckUnderWater,CheckUnderWater)
	,RIPerqValue = ISNULL(@RIPerqValue,RIPerqValue)
	,RIPerqTax = ISNULL(@RIPerqTax,RIPerqTax)
	,NRIPerqValue = ISNULL(@NRIPerqValue,NRIPerqValue)
	,NRIPerqTax = ISNULL(@NRIPerqTax,NRIPerqTax)
	,FNPerqValue = ISNULL(@FNPerqValue,FNPerqValue)
	,FNPerqTax = ISNULL(@FNPerqTax,FNPerqTax)
	,LastUpdatedBy = ISNULL(@LastUpdatedBy,LastUpdatedBy)
	,ConfirmExerciseMailSent = ISNULL(@ConfirmExerciseMailSent,ConfirmExerciseMailSent)
	,PayModeReminderDays = ISNULL(@PayModeReminderDays,PayModeReminderDays)
	,IsReminderForPaymentModeSelection = ISNULL(@IsReminderForPaymentModeSelection,IsReminderForPaymentModeSelection)
	,ReminderPerformanceVestingAlert = ISNULL(@ReminderPerformanceVestingAlert,ReminderPerformanceVestingAlert)
	,BeforePerfVestDateYN = ISNULL(@BeforePerfVestDateYN,BeforePerfVestDateYN)
	,SendPerfVestAlertYN = ISNULL(@SendPerfVestAlertYN,SendPerfVestAlertYN)
	,RoundingParam_ExercisePrice = ISNULL(@RoundingParam_ExercisePrice,RoundingParam_ExercisePrice)
	,RoundingParam_ExerciseAmount = ISNULL(@RoundingParam_ExerciseAmount,RoundingParam_ExerciseAmount)
	,RoundingParam_FMV = ISNULL(@RoundingParam_FMV,RoundingParam_FMV)
	,RoundingParam_Taxamt = ISNULL(@RoundingParam_Taxamt,RoundingParam_Taxamt)
	,RoundingParam_TaxableVal = ISNULL(@RoundingParam_TaxableVal,RoundingParam_TaxableVal)
	,RoundingParam_Gain = ISNULL(@RoundingParam_Gain,RoundingParam_Gain)
	,MinNoOfExeOpt = ISNULL(@MinNoOfExeOpt,MinNoOfExeOpt)
	,MultipleForExeOpt = ISNULL(@MultipleForExeOpt,MultipleForExeOpt)
	,isExeriseAtOneGo = ISNULL(@isExeriseAtOneGo,isExeriseAtOneGo)
	,isExeSeparately = ISNULL(@isExeSeparately,isExeSeparately)
	,LastUpdatedOn = GETDATE()
	,IsPrimaryEmailIDForLive = ISNULL(@PrimarymailidforLive,IsPrimaryEmailIDForLive)
	,IsSecondaryEmailIDForLive =ISNULL( @SecondaryMailidforLive,IsSecondaryEmailIDForLive)
	,IsPrimaryEmailIDForSep = ISNULL(@PrimarymailidforSep,IsPrimaryEmailIDForSep)
	,IsSecondaryEmailIDForSep = ISNULL(@SecondarmailidForSep,IsSecondaryEmailIDForSep)
	
	
WHERE CompanyID = @CompanyID

SET @retValue = @@ROWCOUNT;
  
 SET NOCOUNT OFF;  
END
GO
