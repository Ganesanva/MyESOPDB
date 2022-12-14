/****** Object:  StoredProcedure [dbo].[PROC_GetExercisedData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetExercisedData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetExercisedData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetExercisedData] 
	@ExerciseNo numeric
AS
BEGIN
	SET NOCOUNT ON;  
	    IF EXISTS (SELECT 1 FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseNo)
	    BEGIN
			SELECT ExerciseId,ExercisedQuantity,ExercisePrice,PerqstValue,ExerciseDate,EmployeeID,ExerciseNo,
			PerqstPayable,FMVPrice, Perq_Tax_rate, PaymentMode 
			FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseNo
		END
		ELSE 
		BEGIN
			SELECT Ex.ExercisedId AS ExerciseId,Ex.ExercisedQuantity AS ExercisedQuantity,Ex.ExercisedPrice AS ExercisePrice,Ex.PerqstValue AS PerqstValue,
			Ex.ExercisedDate AS ExerciseDate,G.EmployeeId,Ex.ExerciseNo AS ExerciseNo,Ex.PerqstPayable AS PerqstPayable,Ex.FMVPrice AS FMVPrice,
			Ex.Perq_Tax_rate AS Perq_Tax_rate,Ex.PaymentMode AS PaymentMode
			FROM Exercised Ex 
			INNER JOIN GrantLeg GL ON EX.GrantLegSerialNumber=GL.ID
			INNER JOIN GrantOptions G ON G.GrantOptionId=GL.GrantOptionId WHERE EX.ExerciseNo=@ExerciseNo
		END	
	SET NOCOUNT OFF;
END
GO
