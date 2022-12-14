/****** Object:  StoredProcedure [dbo].[UpateAllotmentOnShareTransfer]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[UpateAllotmentOnShareTransfer]
GO
/****** Object:  StoredProcedure [dbo].[UpateAllotmentOnShareTransfer]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpateAllotmentOnShareTransfer] 
	@IsAllotmentGenerated BIT,
	@ExerciseNo NUMERIC,
	@Result INT =0 OUTPUT
AS
BEGIN	
	UPDATE	ShExercisedOptions 
	SET		IsAllotmentGenerated = @IsAllotmentGenerated, 
			AllotmentGenerateDate = CASE WHEN @IsAllotmentGenerated = 0 THEN NULL ELSE GETDATE() END 
	WHERE	ExerciseNo = @ExerciseNo
	IF (@@ROWCOUNT <> 0)
	BEGIN
		SET @Result = 1
	END	
END
GO
