-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09
-- Description:	This procedure brings data from GrantRegistration and VestingPeriod tables and inserts that into respective tables at Linked Server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_GrantRegistrationParameters')
BEGIN
DROP PROCEDURE SP_GrantRegistrationParameters
END
GO

create    PROCEDURE [dbo].[SP_GrantRegistrationParameters] 
	-- Add the parameters for the stored procedure here
		@DBName VARCHAR(50),
		@LinkedServer VARCHAR(50),
		@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedGrantRegistration]';
    EXECUTE (@ClearDataQuery);
    SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedVestingPeriod]';
    EXECUTE (@ClearDataQuery);

	IF(@ESOPVersion = 'Global')
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedGrantRegistration](ApprovalId, 
		SchemeId, GrantApprovalId, GrantRegistrationId, ApprovalStatus, GrantDate, ExercisePrice, IsPerformanceBasedIncluded, LastUpdatedBy, LastUpdatedOn, 
		Apply_SAR, Merchant_Code, Contributiion_Frequency, ContriBution_Period, MinContriAmt, MaxContAmt, ContributionMultiples, StartDate, LastDate, 
		BankIntRate, IntrestAmtCalcAs, FirstMailFre, RemMailFre, NonPayAllow, EmailRemXDays, EmailCompCR, SpecificDate, CompoundIntFreq, AccountType, 
		Apply_SAYE, ContristartDate, SARS_PRICE, ExercisePriceINR)
		(SELECT ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, ApprovalStatus, GrantDate, ExercisePrice, IsPerformanceBasedIncluded, LastUpdatedBy,
		 LastUpdatedOn, Apply_SAR, Merchant_Code, Contributiion_Frequency, ContriBution_Period, MinContriAmt, MaxContAmt, ContributionMultiples, StartDate,
		 LastDate, BankIntRate, IntrestAmtCalcAs, FirstMailFre, RemMailFre, NonPayAllow, EmailRemXDays, EmailCompCR, SpecificDate, CompoundIntFreq,
		 AccountType, Apply_SAYE, ContristartDate, SARS_PRICE, ExercisePriceINR FROM GrantRegistration WITH (NOLOCK))';
	 END
	 ELSE
	 BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedGrantRegistration](ApprovalId, 
		SchemeId, GrantApprovalId, GrantRegistrationId, ApprovalStatus, GrantDate, ExercisePrice, IsPerformanceBasedIncluded, LastUpdatedBy, LastUpdatedOn, 
		Apply_SAR, Merchant_Code, Contributiion_Frequency, ContriBution_Period, MinContriAmt, MaxContAmt, ContributionMultiples, StartDate, LastDate, 
		BankIntRate, IntrestAmtCalcAs, FirstMailFre, RemMailFre, NonPayAllow, EmailRemXDays, EmailCompCR, SpecificDate, CompoundIntFreq, AccountType, 
		Apply_SAYE, ContristartDate)
		(SELECT ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, ApprovalStatus, GrantDate, ExercisePrice, IsPerformanceBasedIncluded, LastUpdatedBy,
		LastUpdatedOn, Apply_SAR, Merchant_Code, Contributiion_Frequency, ContriBution_Period, MinContriAmt, MaxContAmt, ContributionMultiples, StartDate,
		LastDate, BankIntRate, IntrestAmtCalcAs, FirstMailFre, RemMailFre, NonPayAllow, EmailRemXDays, EmailCompCR, SpecificDate, CompoundIntFreq,
		AccountType, Apply_SAYE, ContristartDate FROM GrantRegistration WITH (NOLOCK))';
	 END
    EXECUTE (@StrInsertQuery);
    SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[LinkedVestingPeriod](ApprovalId, SchemeId, GrantApprovalId, 
	GrantRegistrationId, VestingPeriodId, VestingDate, ExpiryDate, VestingType, OptionTimePercentage, OptionPerformancePercentage, VestingPeriodNo, 
	LastUpdatedBy, LastUpdatedOn, FBTValue, AdjustResidueInTimeOrPerformance)
	(SELECT ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, VestingPeriodId, VestingDate, ExpiryDate, VestingType, OptionTimePercentage,
	OptionPerformancePercentage, VestingPeriodNo, LastUpdatedBy, LastUpdatedOn, FBTValue, AdjustResidueInTimeOrPerformance FROM VestingPeriod WITH (NOLOCK))';
    EXECUTE (@StrInsertQuery);
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[LinkedGrantRegistration] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) + '''';
    EXECUTE (@StrUpdateQuery);
    SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + ']. [dbo].[LinkedVestingPeriod] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO

