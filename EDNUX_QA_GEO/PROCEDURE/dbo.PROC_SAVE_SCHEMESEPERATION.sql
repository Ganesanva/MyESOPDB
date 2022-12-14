/****** Object:  StoredProcedure [dbo].[PROC_SAVE_SCHEMESEPERATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_SCHEMESEPERATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_SCHEMESEPERATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SAVE_SCHEMESEPERATION]
	@ApprovalId VARCHAR(20), @SchemeId VARCHAR(50), @SeperationRuleId DECIMAL(18,9), @VestedOptionsLiveFor DECIMAL(18,9),
	@IsVestingOfUnvestedOptions CHAR(1), @UnvestedOptionsLiveFor DECIMAL(18,9), @LastUpdatedBy VARCHAR(20), 
	@LastUpdatedOn DATETIME, @OthersReason VARCHAR(30), @VestedOptionsLiveTillExercisePeriod CHAR(1),
	@SEPPeriodUnit CHAR(1), @IsRuleBypassed CHAR(1), @MESSAGE_OUT VARCHAR(100) OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;	
		
	INSERT INTO ShSchemeSeparationRule 
	(
		ApprovalId, SchemeId, SeperationRuleId, VestedOptionsLiveFor, IsVestingOfUnvestedOptions, UnvestedOptionsLiveFor,
		LastUpdatedBy, LastUpdatedOn, OthersReason, VestedOptionsLiveTillExercisePeriod, PeriodUnit, IsRuleBypassed
	) 
	VALUES
	(
		@ApprovalId, @SchemeId, @SeperationRuleId, @VestedOptionsLiveFor, @IsVestingOfUnvestedOptions, @UnvestedOptionsLiveFor,
		@LastUpdatedBy, @LastUpdatedOn, @OthersReason, @VestedOptionsLiveTillExercisePeriod, @SEPPeriodUnit, @IsRuleBypassed
	) 
		
	SET NOCOUNT OFF;				
END
GO
