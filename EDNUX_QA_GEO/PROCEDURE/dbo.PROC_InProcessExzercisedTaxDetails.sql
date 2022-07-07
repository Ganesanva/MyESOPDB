/****** Object:  StoredProcedure [dbo].[PROC_InProcessExzercisedTaxDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InProcessExzercisedTaxDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InProcessExzercisedTaxDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InProcessExzercisedTaxDetails] 
	(
		@ExerciseNo VARCHAR(50)
	)			 	
AS

BEGIN
 
select * from ShExercisedOptions where ExerciseNo = @ExerciseNo

select * from EXERCISE_TAXRATE_DETAILS  where Exercise_No =@ExerciseNo

END

--exec PROC_InProcessExzercisedTaxDetails '1062'

GO
