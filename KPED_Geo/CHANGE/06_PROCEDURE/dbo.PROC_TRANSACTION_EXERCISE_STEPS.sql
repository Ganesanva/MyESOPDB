/****** Object:  StoredProcedure [dbo].[PROC_TRANSACTION_EXERCISE_STEPS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TRANSACTION_EXERCISE_STEPS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TRANSACTION_EXERCISE_STEPS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_TRANSACTION_EXERCISE_STEPS]

AS
BEGIN
	 SET NOCOUNT ON;
		
		CREATE TABLE #TEMP_EXERCISE
		(  
			ID INT IDENTITY(1,1) NOT NULL, EmployeeID VARCHAR(20),  ExerciseNo NVARCHAR(50),
			MIT_ID INT, ExerciseDate DATETIME, IsAutoExercised TINYINT
		)   
		INSERT INTO #TEMP_EXERCISE (EmployeeID, ExerciseNo, MIT_ID, ExerciseDate, IsAutoExercised)
		SELECT DISTINCT EmployeeID, ExerciseNo, MIT_ID, ExerciseDate, IsAutoExercised
		FROM ShExercisedOptions
        WHERE ExerciseNo NOT IN (SELECT EXERCISE_NO FROM TRANSACTIONS_EXERCISE_STEP)


		INSERT INTO TRANSACTIONS_EXERCISE_STEP
        (EXERCISE_STEPID, DISPLAY_NAME, EXERCISE_NO, UPLOAD_TYPE, ISATTEMPTED_ON, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON )
        SELECT
        MST_EX_STEP_ID, DISPLAY_NAME, TAD.ExerciseNo, UPLOAD_TYPE, GETDATE(), 'ADMIN', GETDATE(),'ADMIN', GETDATE()		  
        FROM MST_EXERCISE_STEPS MES  LEFT JOIN #TEMP_EXERCISE TAD ON MES.MIT_ID = TAD.MIT_ID
	    WHERE  ((CONVERT(date, GETDATE())  <= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 2) OR
		       (CONVERT(date, GETDATE())  >= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 1)) AND
			   IS_ACTIVE = 1 ORDER BY TAD.ExerciseNo
		
		IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_STEPID = 1)
		BEGIN
			UPDATE TRANSACTIONS_EXERCISE_STEP SET IS_ATTEMPTED = 1 WHERE EXERCISE_STEPID = 1 AND EXERCISE_NO in (SELECT ExerciseNo FROM SHEXERCISEDOPTIONS SHEX WHERE ISNULL(SHEX.PaymentMode,'') <> '' OR SHEX.MIT_ID = 5 OR SHEX.MIT_ID = 7)
		END
		IF ((SELECT count(*) FROM MST_EXERCISE_STEPS WHERE MIT_ID in (7) AND IS_ACTIVE = 1 ) = 1)
		BEGIN
		print 'ss'
		 update ShExercisedOptions set IsFormGenerate=1,IS_UPLOAD_EXERCISE_FORM=1 ,IsAccepted=1
			 from ShExercisedOptions inner join  #TEMP_EXERCISE    TAD 
			 on ShExercisedOptions.ExerciseNo = TAD.ExerciseNo
			 WHERE  ((CONVERT(date, GETDATE())  <= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 2) OR
		     (CONVERT(date, GETDATE())  >= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 1)) AND
			TAD.MIT_ID in(7)
			END

			IF ((SELECT count(*) FROM MST_EXERCISE_STEPS WHERE MIT_ID in (5) AND IS_ACTIVE = 1 ) = 1)
		BEGIN
		print 'ss'
		 update ShExercisedOptions set IsFormGenerate=1,IS_UPLOAD_EXERCISE_FORM=1 ,IsAccepted=1
			 from ShExercisedOptions inner join  #TEMP_EXERCISE    TAD 
			 on ShExercisedOptions.ExerciseNo = TAD.ExerciseNo
			 WHERE  ((CONVERT(date, GETDATE())  <= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 2) OR
		     (CONVERT(date, GETDATE())  >= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 1)) AND
			TAD.MIT_ID in(5)
		END
		SELECT
             TAD.EmployeeID, TAD.ExerciseNo	, MES.DISPLAY_NAME 
        FROM MST_EXERCISE_STEPS MES  LEFT JOIN #TEMP_EXERCISE TAD ON MES.MIT_ID = TAD.MIT_ID
	    WHERE  ((CONVERT(date, GETDATE())  <= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 2) OR
		       (CONVERT(date, GETDATE())  >= CONVERT(date, TAD.ExerciseDate) AND TAD.IsAutoExercised = 1)) AND
			   IS_ACTIVE = 1 ORDER BY TAD.ExerciseNo

		DROP TABLE #TEMP_EXERCISE	

	 SET NOCOUNT OFF;	
END
