-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09	
-- Description:	This procedures brings data from SchemeSeperationRule table and inserts it into SeparationRule table on linked server
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_SchemeSeparationRule')
BEGIN
DROP PROCEDURE SP_SchemeSeparationRule
END
GO

create    PROCEDURE [dbo].[SP_SchemeSeparationRule]
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
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeSeparationRule]' ;
	EXEC(@ClearDataQuery);

	SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SeparationRule]' ;
	EXEC(@ClearDataQuery);

	IF(@ESOPVersion = 'Global')
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeSeparationRule](ApprovalId,SchemeId,SeperationRuleId,
		VestedOptionsLiveFor,IsVestingOfUnvestedOptions,UnvestedOptionsLiveFor,VestedOptionsLiveTillExercisePeriod,PeriodUnit,IsRuleBypassed,OthersReason)
		(SELECT ApprovalId,SchemeId,SeperationRuleId,VestedOptionsLiveFor,IsVestingOfUnvestedOptions,UnvestedOptionsLiveFor,VestedOptionsLiveTillExercisePeriod,
		PeriodUnit,IsRuleBypassed,OthersReason FROM SchemeSeperationRule WITH (NOLOCK))';

		EXEC(@StrInsertQuery);
		--PRINT(@StrInsertQuery);
	 END
	 ELSE
	 BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SchemeSeparationRule](ApprovalId, SchemeId, SeperationRuleId, 
		VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor, VestedOptionsLiveTillExercisePeriod,PeriodUnit, IsRuleBypassed, Status, 
		OthersReason)
		(SELECT ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor, 
		VestedOptionsLiveTillExercisePeriod, PeriodUnit, IsRuleBypassed, Status, OthersReason FROM SchemeSeperationRule WITH (NOLOCK))';

		EXEC(@StrInsertQuery);
	 END

	 SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[SeparationRule](SeperationRuleId, Reason)
		(SELECT SeperationRuleId, Reason FROM SeperationRule WITH (NOLOCK))';
	 EXEC(@StrInsertQuery);

	 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[SchemeSeparationRule] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);

	 SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[SeparationRule] 
	 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	 EXEC(@StrUpdateQuery);

END
GO

