/****** Object:  StoredProcedure [dbo].[PROC_GET_EXCEPTION_DET_FOR_EXERCISE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXCEPTION_DET_FOR_EXERCISE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXCEPTION_DET_FOR_EXERCISE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EXCEPTION_DET_FOR_EXERCISE]
	@EXERCISE_NO NUMERIC(18,0)  
AS  
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @WHERECLAUSE VARCHAR(max) 

	SELECT @WHERECLAUSE = COALESCE(@WHERECLAUSE + '+', '') + [Formula] 
		FROM (SELECT Formula FROM  AutoReversalSettingDetails WHERE Isactivated = 1) AS OUT_PUT 
		
	CREATE TABLE #TEMP
	(
		Total_Exercise_Amount VARCHAR(50)
	)
	
	IF @WHERECLAUSE IS NOT NULL
	BEGIN
		INSERT INTO #TEMP
		EXECUTE ('SELECT SUM(' + @WHERECLAUSE +') FROM ShExercisedOptions WHERE ExerciseNo =' + @EXERCISE_NO)
	END
	
	SELECT 
		IsexceptionActivated, 
		ExceptionActivatedToAmount, 
		@EXERCISE_NO AS Exercise_No,
		ISNULL((SELECT Total_Exercise_Amount FROM #TEMP) ,0) AS Total_Exercise_Amount 
	FROM AutoReversalConfigMaster

END
GO
