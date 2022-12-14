/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_EXERCISEID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [PROC_SOPsUI_VALIDATE_EXERCISEID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_EXERCISEID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [PROC_SOPsUI_VALIDATE_EXERCISEID] 
	
	@SOPSsUI_EXERCISE_EMPLOYEE_IDS SOPSsUI_EXERCISE_EMPLOYEE_IDS READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--SELECT * FROM @SOPSsUI_EXERCISE_EMPLOYEE_IDS
	CREATE TABLE #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE
	(
		EXERCISE_ID NUMERIC(18)
	)

	CREATE TABLE #TEMP_EXERCISE_FORM_GENERATED_STATUS
	(
		EXERCISE_FORM_EXERCISE_ID NUMERIC(18)
	)

	INSERT INTO #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE 
	SELECT IDs FROM @SOPSsUI_EXERCISE_EMPLOYEE_IDS

	INSERT INTO #TEMP_EXERCISE_FORM_GENERATED_STATUS 
	SELECT IDs FROM @SOPSsUI_EXERCISE_EMPLOYEE_IDS

	DELETE TEIA
	FROM #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE AS TEIA
	INNER JOIN ShExercisedOptions AS SEO  ON TEIA.EXERCISE_ID = SEO.ExerciseId
 
	DELETE TEFGS
	FROM #TEMP_EXERCISE_FORM_GENERATED_STATUS AS TEFGS
	INNER JOIN ShExercisedOptions AS SEO ON TEFGS.EXERCISE_FORM_EXERCISE_ID = SEO.ExerciseId
	WHERE SEO.isFormGenerate = 0

	/* REMOVE DUPLICATE ENTRIES WITH IS ALREADY FOUND #TEMP_EXERCISE_ID_AVAIABLE TABLE */
	DELETE TEFGS
	FROM #TEMP_EXERCISE_FORM_GENERATED_STATUS AS TEFGS
	INNER JOIN #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE AS TEIA ON TEFGS.EXERCISE_FORM_EXERCISE_ID = TEIA.EXERCISE_ID
	
	--SELECT * FROM #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE
	--SELECT * FROM #TEMP_EXERCISE_FORM_GENERATED_STATUS

	SELECT IDs AS 'ExerciseID', 'Remove duplicate Exercise ID from Excel Sheet.' AS 'Message' FROM @SOPSsUI_EXERCISE_EMPLOYEE_IDS GROUP BY IDs HAVING COUNT(IDs)>1
	UNION ALL
	SELECT EXERCISE_ID AS 'ExerciseID', 'Exercise ID not available in table. Please remove from Excel Sheet.' AS 'Message' FROM #TEMP_EXERCISE_ID_NOT_AVALABLE_IN_TABLE
	UNION ALL
	SELECT EXERCISE_FORM_EXERCISE_ID AS 'ExerciseID', 'Form is already generated for Exercise ID. Please remove from Excel Sheet.' AS 'Message' FROM #TEMP_EXERCISE_FORM_GENERATED_STATUS

	SET NOCOUNT OFF;				
END
GO
