/****** Object:  StoredProcedure [dbo].[PROC_SAVE_SCHEME]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_SCHEME]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_SCHEME]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SAVE_SCHEME]
    	@ApprovalId VARCHAR(20), @SchemeId VARCHAR(50), @SchemeTitle VARCHAR(20), @AdjustResidueOptionsIn VARCHAR(1), @VestingOverPeriodOffset NUMERIC(9,0),
    	@VestingStartOffset NUMERIC(9,0), @VestingFrequency NUMERIC(9,0), @LockInPeriod NUMERIC(9,0), @LockInPeriodStartsFrom VARCHAR(1),
    	@OptionRatioMultiplier NUMERIC(9,0),@OptionRatioDivisor NUMERIC(9,0), @ExercisePeriodOffset NUMERIC(9,0), @ExercisePeriodStartsAfter VARCHAR(1),
    	@LastUpdatedBy VARCHAR(20), @LastUpdatedOn DATETIME, @Action CHAR(1),@PeriodUnit CHAR(1), @UnVestedCancelledOptions VARCHAR(1),
    	@VestedCancelledOptions VARCHAR(1),@LapsedOptions VARCHAR(1),@IsPUPEnabled TINYINT, @DisplayExPrice BIT, @DisplayExpDate BIT, 
    	@DisplayPerqVal BIT, @DisplayPerqTax BIT, @PUPExedPayoutProcess BIT, @PUPFORMULAID INT, @IS_ADS_SCHEME BIT, @IS_ADS_EX_OPTS_ALLOWED BIT,
    	@MIT_ID INT, @IS_AUTO_EXERCISE_ALLOWED CHAR(1),@CALCULATE_TAX NVARCHAR(100), @CALCUALTE_TAX_PRIOR_DAYS INT,@CALCULATE_TAX_PREVESTING NVARCHAR(100),@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING INT, @MESSAGE_OUT INT OUTPUT
AS
BEGIN
	
	SET NOCOUNT ON;	
   	
	BEGIN TRY	
	
		BEGIN TRANSACTION
	
		--IF MIT_ID =3,4 THEN INSERT IS_ADS_SCHEME = 1
		SELECT 
			@IS_ADS_SCHEME = CASE WHEN (UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END,
			@IS_ADS_EX_OPTS_ALLOWED = CASE WHEN (UPPER(MCC.CODE_NAME)='ADR')THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END
		FROM 
			MST_INSTRUMENT_TYPE MIT INNER JOIN MST_COM_CODE MCC ON
			MCC.MCC_ID=MIT.INSTRUMENT_GROUP AND MIT.MIT_ID=@MIT_ID
			
		INSERT INTO ShScheme 
		(
			ApprovalId, SchemeId, SchemeTitle, AdjustResidueOptionsIn, VestingOverPeriodOffset, VestingStartOffset,
			VestingFrequency, LockInPeriod, LockInPeriodStartsFrom, OptionRatioMultiplier, OptionRatioDivisor, 
			ExercisePeriodOffset,ExercisePeriodStartsAfter, LastUpdatedBy, LastUpdatedOn, Action, PeriodUnit,
			UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions, IsPUPEnabled, DisplayExPrice, 
			DisplayExpDate, DisplayPerqVal, DisplayPerqTax, PUPExedPayoutProcess, PUPFORMULAID, IS_ADS_SCHEME, 
			IS_ADS_EX_OPTS_ALLOWED,MIT_ID,IS_AUTO_EXERCISE_ALLOWED,CALCULATE_TAX,CALCUALTE_TAX_PRIOR_DAYS,CALCULATE_TAX_PREVESTING,CALCUALTE_TAX_PRIOR_DAYS_PREVESTING		
		)
		VALUES
		(
			@ApprovalId, @SchemeId, @SchemeTitle, @AdjustResidueOptionsIn, @VestingOverPeriodOffset, @VestingStartOffset,
			@VestingFrequency, @LockInPeriod, @LockInPeriodStartsFrom, @OptionRatioMultiplier, @OptionRatioDivisor,
			@ExercisePeriodOffset, @ExercisePeriodStartsAfter, @LastUpdatedBy, @LastUpdatedOn, @Action, @PeriodUnit,
			@UnVestedCancelledOptions, @VestedCancelledOptions, @LapsedOptions, @IsPUPEnabled, @DisplayExPrice,
			@DisplayExpDate, @DisplayPerqVal, @DisplayPerqTax, @PUPExedPayoutProcess, @PUPFORMULAID, @IS_ADS_SCHEME, 
			@IS_ADS_EX_OPTS_ALLOWED, @MIT_ID, @IS_AUTO_EXERCISE_ALLOWED,@CALCULATE_TAX,@CALCUALTE_TAX_PRIOR_DAYS,@CALCULATE_TAX_PREVESTING,@CALCUALTE_TAX_PRIOR_DAYS_PREVESTING
		)
		
		SET @MESSAGE_OUT = 1
			
		COMMIT TRANSACTION
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @MESSAGE_OUT = 0
	END CATCH
		
	SET NOCOUNT OFF;					
END
GO
