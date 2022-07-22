-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_GrantLeg')
BEGIN
DROP PROCEDURE SP_GrantLeg
END
GO

create    PROCEDURE [dbo].[SP_GrantLeg] 
	-- Add the parameters for the stored procedure here
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedGrantLeg]';
	EXEC(@ClearDataQuery);
	
	IF(@ESOPVersion = 'Global')
	BEGIN
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedGrantLeg](ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantDistributionId, GrantOptionId, VestingPeriodId, GrantDistributedLegId,
			GrantLegId, Counter, VestingType, VestingDate, ExpirayDate, GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent,
			AcceleratedVestingDate, AcceleratedExpirayDate, SeperatingVestingDate, SeperationCancellationDate, FinalVestingDate, FinalExpirayDate,
			CancellationDate, CancellationReason, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, UnapprovedExerciseQuantity,
			ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, UnvestedQuantity, Status, ParentID,
			LapsedQuantity, IsPerfBased, SeparationPerformed, ExpiryPerformed, VestMailSent, ExpiredMailSent, LastUpdatedBy, LastUpdatedOn,
			IsOriginal, IsBonus, IsSplit, TEMPEXERCISABLEQUANTITY, PerVestingQuantity)
			(SELECT ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantDistributionId, GrantOptionId, VestingPeriodId, GrantDistributedLegId,
			GrantLegId, Counter, VestingType, VestingDate, ExpirayDate, GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent,
			AcceleratedVestingDate, AcceleratedExpirayDate, SeperatingVestingDate, SeperationCancellationDate, FinalVestingDate, FinalExpirayDate,
			CancellationDate, CancellationReason, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, UnapprovedExerciseQuantity,
			ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, UnvestedQuantity, Status, ParentID,
			LapsedQuantity, IsPerfBased, SeparationPerformed, ExpiryPerformed, VestMailSent, ExpiredMailSent, LastUpdatedBy, LastUpdatedOn,
			IsOriginal, IsBonus, IsSplit, TEMPEXERCISABLEQUANTITY, PerVestingQuantity FROM GrantLeg WITH (NOLOCK))';
	END
	ELSE
	BEGIN
			SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[LinkedGrantLeg](ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantDistributionId, GrantOptionId, VestingPeriodId, GrantDistributedLegId,
			GrantLegId, Counter, VestingType, VestingDate, ExpirayDate, GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent,
			AcceleratedVestingDate, AcceleratedExpirayDate, SeperatingVestingDate, SeperationCancellationDate, FinalVestingDate, FinalExpirayDate,
			CancellationDate, CancellationReason, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, UnapprovedExerciseQuantity,
			ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, UnvestedQuantity, Status, ParentID,
			LapsedQuantity, IsPerfBased, SeparationPerformed, ExpiryPerformed, VestMailSent, ExpiredMailSent, LastUpdatedBy, LastUpdatedOn,
			IsOriginal, IsBonus, IsSplit, TEMPEXERCISABLEQUANTITY)
			(SELECT ID, ApprovalId, SchemeId, GrantApprovalId, GrantRegistrationId, GrantDistributionId, GrantOptionId, VestingPeriodId, GrantDistributedLegId,
			GrantLegId, Counter, VestingType, VestingDate, ExpirayDate, GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, Parent,
			AcceleratedVestingDate, AcceleratedExpirayDate, SeperatingVestingDate, SeperationCancellationDate, FinalVestingDate, FinalExpirayDate,
			CancellationDate, CancellationReason, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, UnapprovedExerciseQuantity,
			ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, UnvestedQuantity, Status, ParentID,
			LapsedQuantity, IsPerfBased, SeparationPerformed, ExpiryPerformed, VestMailSent, ExpiredMailSent, LastUpdatedBy, LastUpdatedOn,
			IsOriginal, IsBonus, IsSplit, TEMPEXERCISABLEQUANTITY FROM GrantLeg WITH (NOLOCK))';
	END
		EXEC(@StrInsertQuery);

		DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[LinkedGrantLeg] 
		SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
		EXEC(@StrUpdateQuery);
END
GO

