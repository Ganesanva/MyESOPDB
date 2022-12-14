/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EXERCISE_FORM_STATUS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_EXERCISE_FORM_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EXERCISE_FORM_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_EXERCISE_FORM_STATUS]
( 
		@ExerciseNo INT	
)
AS
BEGIN
	 SET NOCOUNT ON;

	 BEGIN
	    IF NOT EXISTS(SELECT 1 as isFormGeneratestatus FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ShExercisedOptions' AND  COLUMN_NAME = 'isFormGenerate') 
		BEGIN
		    ALTER TABLE ShExercisedOptions ADD isFormGenerate tinyint NOT NULL DEFAULT 0;
		END
		IF NOT EXISTS(SELECT 1 as isFormGeneratestatus FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Exercised' AND  COLUMN_NAME = 'isFormGenerate')
		BEGIN
		    ALTER TABLE Exercised ADD isFormGenerate tinyint NOT NULL DEFAULT 1;
		END
	 END
	 
	 BEGIN
	      UPDATE ShExercisedOptions SET isFormGenerate = 1 WHERE ExerciseNo = @ExerciseNo
	 END

	 BEGIN 
	    IF EXISTS(select isFormGenerate from ShExercisedOptions where ExerciseNo = @ExerciseNo)
	    BEGIN	     
		  UPDATE TES SET IS_ATTEMPTED = 1 , UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
		  FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
          ON TES.EXERCISE_NO = SHEX.ExerciseNo 
		  WHERE EXERCISE_NO = @ExerciseNo AND EXERCISE_STEPID  in (2)
	    END
	 END	
	 SET NOCOUNT OFF;	
END
GO
