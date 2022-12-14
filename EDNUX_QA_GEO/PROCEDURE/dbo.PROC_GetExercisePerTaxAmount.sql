/****** Object:  StoredProcedure [dbo].[PROC_GetExercisePerTaxAmount]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetExercisePerTaxAmount]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetExercisePerTaxAmount]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetExercisePerTaxAmount] 
	@ExerciseNo numeric
AS
BEGIN
	SET NOCOUNT ON;   
		SELECT CASE WHEN SHO.ExerciseSARid IS NULL  THEN SUM(ISNULL((SHO.ExercisePrice * SHO.ExercisedQuantity),0)) 
			   ELSE SUM(ISNULL((ESD.ExercsiedQuantity),0))  
			   END AS ExerciseAmount, SUM (ISNULL(PerqstPayable,0)) as PerTax,ExerciseId  
		FROM ShExercisedOptions SHO 
				LEFT OUTER JOIN ExerciseSARDetails ESD ON SHO.ExerciseSARid =ESD.ExerciseSARid WHERE ExerciseNo= @ExerciseNo
		GROUP BY ExerciseId,SHO.ExerciseSARid  
		
		UNION  
		
		SELECT CASE WHEN EX.ExerciseSARid IS NULL THEN SUM (ISNULL((EX.ExercisedPrice * EX.ExercisedQuantity),0)) 
			   ELSE SUM(ISNULL((ESD.ExercsiedQuantity),0))  
			   END AS ExerciseAmount, SUM(ISNULL(PerqstPayable,0)) as PerTax, ExercisedId  			 
		FROM Exercised EX  
				LEFT OUTER JOIN ExerciseSARDetails ESD ON EX.ExerciseSARid =ESD.ExerciseSARid WHERE ExerciseNo= @ExerciseNo
		GROUP BY ExercisedId,EX.ExerciseSARid
END
GO
