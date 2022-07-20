-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09	
-- Description:	This procedures brings data from Scheme table and inserts it into SchemeParameters table on linked server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_SchemeDetailParameters')
BEGIN
DROP PROCEDURE SP_SchemeDetailParameters
END
GO

create    PROCEDURE [dbo].[SP_SchemeDetailParameters]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
    SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeParameters]' ;
	EXEC(@ClearDataQuery);

	IF(@ESOPVersion = 'Global')
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeParameters](ApprovalId, SchemeId, Status, 
		SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset, VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, 
		OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset, ExercisePeriodStartsAfter, PeriodUnit, LastUpdatedBy, LastUpdatedOn, TrustType, 
		IsPaymentModeRequired, PaymentModeEffectiveDate, UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions, IsPUPEnabled, DisplayExPrice, 
		DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPEXEDPAYOUTPROCESS, PUPFORMULAID, IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED, MIT_ID, 
		IS_AUTO_EXERCISE_ALLOWED, CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, ROUNDING_UP, FRACTION_PAID_CASH)
		(SELECT ApprovalId, SchemeId, Status, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset, VestingFrequency, 
		LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset, ExercisePeriodStartsAfter, PeriodUnit, 
		LastUpdatedBy, LastUpdatedOn, TrustType, IsPaymentModeRequired, PaymentModeEffectiveDate, UnVestedCancelledOptions, VestedCancelledOptions, 
		LapsedOptions, IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPEXEDPAYOUTPROCESS, PUPFORMULAID, IS_ADS_SCHEME, 
		IS_ADS_EX_OPTS_ALLOWED, MIT_ID, IS_AUTO_EXERCISE_ALLOWED, CALCULATE_TAX, CALCUALTE_TAX_PRIOR_DAYS, ROUNDING_UP, FRACTION_PAID_CASH 
		FROM Scheme SP_SchemeDetailParameters)';

		EXEC(@StrInsertQuery);
		--PRINT(@StrInsertQuery);
	 END
	 ELSE
	 BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeParameters](ApprovalId, SchemeId, Status, 
		SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset, VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, 
		OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset, ExercisePeriodStartsAfter, PeriodUnit, LastUpdatedBy, LastUpdatedOn, TrustType, 
		IsPaymentModeRequired, PaymentModeEffectiveDate, UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions, IsPUPEnabled, DisplayExPrice, 
		DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPEXEDPAYOUTPROCESS, PUPFORMULAID, IS_ADS_SCHEME, IS_ADS_EX_OPTS_ALLOWED)
		(SELECT ApprovalId, SchemeId, Status, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset, VestingFrequency, 
		LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, ExercisePeriodOffset, ExercisePeriodStartsAfter, PeriodUnit, 
		LastUpdatedBy, LastUpdatedOn, TrustType, IsPaymentModeRequired, PaymentModeEffectiveDate, UnVestedCancelledOptions, VestedCancelledOptions, 
		LapsedOptions, IsPUPEnabled, DisplayExPrice, DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPEXEDPAYOUTPROCESS, PUPFORMULAID, IS_ADS_SCHEME, 
		IS_ADS_EX_OPTS_ALLOWED 
		FROM Scheme SP_SchemeDetailParameters)';

		EXEC(@StrInsertQuery);
	 END

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[SchemeParameters] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);

END
GO

