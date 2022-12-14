/****** Object:  StoredProcedure [dbo].[PROC_InsertTempGrantLeg]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertTempGrantLeg]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertTempGrantLeg]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InsertTempGrantLeg] 
(
	@ID NUMERIC(18, 0),
    @VestingDate DATETIME,
	@GrantedOptions NUMERIC(18, 0) ,
	@ExercisableQuantity NUMERIC(18, 0),
	@UnapprovedExerciseQuantity NUMERIC(18, 0),
	@FinalVestingDate DATETIME,
	@FinalExpirayDate DATETIME ,
	@ExercisePrice NUMERIC(18, 0),
	@GrantDate DATETIME,
	@LockInPeriodStartsFrom VARCHAR(1)	,
	@LockInPeriod NUMERIC(18, 0),	
	@OptionRatioMultiplier NUMERIC(18, 0),
	@OptionRatioDivisor NUMERIC(18, 0),
	@ExercisedQuantity NUMERIC(18, 0),
	@GrantOptionId VARCHAR(100),
	@GrantLegId DECIMAL(10, 0),
	@SchemeTitle VARCHAR(200) NULL,
	@Counter NUMERIC(18, 0) NULL,
	@Parent CHAR(1)
)
AS
BEGIN	

	SET NOCOUNT ON;
	
	INSERT INTO TempGrantLeg
	(
	ID,VestingDate,GrantedOptions,ExercisableQuantity,UnapprovedExerciseQuantity,FinalVestingDate,FinalExpirayDate,
	ExercisePrice,GrantDate,LockInPeriodStartsFrom,LockInPeriod,OptionRatioMultiplier,OptionRatioDivisor,ExercisedQuantity,GrantOptionId,
	GrantLegId,SchemeTitle,Counter ,Parent
	)
	Values
	(
	@ID,@VestingDate,@GrantedOptions,@ExercisableQuantity,@UnapprovedExerciseQuantity,@FinalVestingDate,@FinalExpirayDate,
	@ExercisePrice,@GrantDate,@LockInPeriodStartsFrom	,@LockInPeriod,	@OptionRatioMultiplier,@OptionRatioDivisor,
	@ExercisedQuantity,@GrantOptionId,@GrantLegId,@SchemeTitle,@Counter ,@Parent
	
	)
	
	SET NOCOUNT OFF;
END
GO
