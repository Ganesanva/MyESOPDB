-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-09
-- Description:	This procedure fetches data from Bonus and Split tables and inserts it into the respective tables on linked server
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_CorporateActionParameter')
BEGIN
DROP PROCEDURE SP_CorporateActionParameter
END
GO

create    PROCEDURE [dbo].[SP_CorporateActionParameter]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedBonus]';
	EXEC(@ClearDataQuery);

	SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSplit]';
	EXEC(@ClearDataQuery);

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedBonus](BonusId, Note, RatioMultiplier, 
	RatioDivisor, BonusGrantDate, ApplicableFor, LastUpdatedBy, LastUpdatedOn, Status)
	(SELECT BonusId, Note, RatioMultiplier, RatioDivisor, BonusGrantDate, ApplicableFor, LastUpdatedBy, LastUpdatedOn, Status FROM Bonus WITH (NOLOCK)
)';
	EXEC(@StrInsertQuery);

	SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedSplit](SplitId, ApprovalStatus, Note, RatioMultiplier, 
	RatioDivisor, SplitDate, SplitFactor, Status, ApplicableFor, LastUpdatedBy, LastUpdatedOn, ApplySplitToAll, ApplySplitToVested, 
	ApplySplitToUnvested, ApplySplitToExercised, ApplySplitToLapsed, ApplySplitToCancelled, Approved)
	(SELECT SplitId, ApprovalStatus, Note, RatioMultiplier, RatioDivisor, SplitDate, SplitFactor, Status, ApplicableFor, LastUpdatedBy, LastUpdatedOn,
	ApplySplitToAll, ApplySplitToVested, ApplySplitToUnvested, ApplySplitToExercised, ApplySplitToLapsed, ApplySplitToCancelled, Approved 
	FROM Split WITH (NOLOCK)
)';
	EXEC(@StrInsertQuery);

	DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedBonus] 
	SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	EXEC(@StrUpdateQuery);

	SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedSplit] 
	SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
	EXEC(@StrUpdateQuery);
END
GO

