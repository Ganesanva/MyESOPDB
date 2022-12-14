/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_STEPS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EXERCISE_STEPS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_STEPS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EXERCISE_STEPS]

AS
BEGIN
	 SET NOCOUNT ON;
		
		CREATE TABLE #TEMP_EXERCISE
		(  
			ID INT IDENTITY(1,1) NOT NULL,ExerciseNo NVARCHAR(50),
			MIT_ID BIGINT
		)   
		INSERT INTO #TEMP_EXERCISE (ExerciseNo,MIT_ID )
		SELECT DISTINCT ExerciseNo,MIT_ID
		FROM ShExercisedOptions
        WHERE ExerciseNo Not in (SELECT EXERCISE_NO FROM TRANSACTIONS_EXERCISE_STEP)

				
		DECLARE @MN_VALUE INT, @MX_VALUE INT
		SELECT @MN_VALUE = MIN(ID),@MX_VALUE = MAX(ID) FROM #TEMP_EXERCISE
		PRINT @MN_VALUE

		WHILE(@MN_VALUE <= @MX_VALUE)
		BEGIN
		     DECLARE @E_NO AS NVARCHAR(100)
			 SELECT @E_NO = ExerciseNo FROM #TEMP_EXERCISE WHERE ID=@MN_VALUE
			 PRINT @E_NO


			 INSERT INTO TRANSACTIONS_EXERCISE_STEP(EXERCISE_NO, EXERCISE_STEPID, DISPLAY_NAME, IS_ATTEMPTED, ISATTEMPTED_ON,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON)
			 SELECT sh.ExerciseNo,MST.MST_EX_STEP_ID, MST.DISPLAY_NAME, 
					CASE WHEN(MST.MST_EX_STEP_ID = 1 AND sh.PaymentMode != '') THEN 1
				         WHEN(MST.MST_EX_STEP_ID = 2 AND (Select count(ID) from ShTransactionDetails Where ExerciseNo=@E_NO)>0) THEN 1
				         WHEN(MST.MST_EX_STEP_ID = 3 AND sh.isFormGenerate = 1) THEN 1
					     WHEN(MST.MST_EX_STEP_ID = 4 AND sh.IS_UPLOAD_EXERCISE_FORM =1) THEN 1
					     WHEN(MST.MST_EX_STEP_ID = 5 AND sh.isFormGenerate = 1) THEN 1
					ELSE 0
				    END,
					CASE WHEN(MST.MST_EX_STEP_ID = 1 AND sh.PaymentMode != '') THEN GetDATE()
				         WHEN(MST.MST_EX_STEP_ID = 2 AND (Select count(ID) from ShTransactionDetails Where ExerciseNo=@E_NO)>0) THEN GetDATE()
				         WHEN(MST.MST_EX_STEP_ID = 3 AND sh.isFormGenerate = 1) THEN GetDATE()
					     WHEN(MST.MST_EX_STEP_ID = 4 AND sh.IS_UPLOAD_EXERCISE_FORM =1) THEN GetDATE()
					     WHEN(MST.MST_EX_STEP_ID = 5 AND sh.isFormGenerate = 1) THEN GetDATE()
					ELSE Null
				    END,'ADMIN',GETDATE(),'ADMIN',GETDATE()
			 FROM ShExercisedOptions sh
			 INNER JOIN MST_EXERCISE_STEPS MST
			 ON sh.MIT_ID = MST.MIT_ID
			 WHERE MST.IS_ACTIVE = 1 And sh.ExerciseId = @E_NO
			 
			
			SET @MN_VALUE = @MN_VALUE + 1

		END
		SELECT DB_NAME() CompanyName, * from #TEMP_EXERCISE

		DROP TABLE #TEMP_EXERCISE
	 SET NOCOUNT OFF;	
END
GO
