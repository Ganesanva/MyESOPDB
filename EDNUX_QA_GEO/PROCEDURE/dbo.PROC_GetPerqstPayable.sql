/****** Object:  StoredProcedure [dbo].[PROC_GetPerqstPayable]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPerqstPayable]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPerqstPayable]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetPerqstPayable] 
@ExerciseNo NUMERIC,
@Result INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;   		
		SET @Result=(SELECT SUM(PerqstPayable) AS Payable FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseNo)	
		IF @Result IS NULL
			BEGIN
				SET @Result=0
			END
		SELECT  @Result AS Result
END
GO
