/****** Object:  StoredProcedure [dbo].[GradeWiseOptnsRptAvg]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GradeWiseOptnsRptAvg]
GO
/****** Object:  StoredProcedure [dbo].[GradeWiseOptnsRptAvg]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GradeWiseOptnsRptAvg]	
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	----Creating a temporary table
	CREATE TABLE #TEMP
		(
			GRADE VARCHAR(150),
			AvgExerciseTimeAfterVestInDays DECIMAL(18,3)
		)
	
	----Creating a temporary table
	CREATE TABLE #TEMP_ALL_DATA 
		(
			GRADE VARCHAR(150),
			AvgExerciseTimeAfterVestInDays DECIMAL(18,3),
			AvgProfitOnExercisePerOption DECIMAL(18,3)
		)
	
	----Inseting data( Grade,AvgExerciseTimeAfterVestInDays)  in a temporary table
	INSERT INTO #TEMP (GRADE, AvgExerciseTimeAfterVestInDays)
	(
		SELECT EMP.GRADE,DATEDIFF(DAY,GL.VESTINGDATE,EX.EXERCISEDDATE) AS DIFFERENCEINDAYS
		FROM	Exercised EX 
				 INNER JOIN GrantLeg GL ON GL.ID = EX.GrantLegSerialNumber 
				 INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId 
				 INNER JOIN EmployeeMaster EMP ON EMP.EmployeeID = GOP.EmployeeId    
		GROUP BY EMP.GRADE,EX.EXERCISEDDATE,GL.VESTINGDATE 
	) 

	----Inseting data FROM #TEMP TO #TEMP_ALL_DATA (GROUP BY GRADE)
	INSERT INTO #TEMP_ALL_DATA (GRADE, AvgExerciseTimeAfterVestInDays)
	(
		SELECT Grade, convert(decimal(10,2),(convert(decimal(10,2),SUM(AvgExerciseTimeAfterVestInDays))/convert(decimal(10,2),COUNT(AvgExerciseTimeAfterVestInDays)))) 
		FROM #TEMP 
		GROUP BY Grade
	)

	---DROPPING THE #TEMP TABLE
	DROP TABLE #TEMP
	
	----Creating a temporary table again for AvgProfitOnExercisePerOption
	CREATE TABLE #TEMP_Profit
		(
			GRADE VARCHAR(150),
			AvgProfitOnExercisePerOption DECIMAL(18,3)
		)
		


	----Inseting data( Grade,AvgProfitOnExercisePerOption)  in a temporary table
	INSERT INTO #TEMP_Profit (GRADE, AvgProfitOnExercisePerOption)
	(
		SELECT EMP.Grade,((select ClosePrice from SharePrices where PriceDate = (select max(PriceDate) from SharePrices)) - EX.ExercisedPrice) as Avg_Profit_on_exercise_per_Option
		FROM	Exercised EX 
				 INNER JOIN GrantLeg GL ON GL.ID = EX.GrantLegSerialNumber 
				 INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId 
				 INNER JOIN EmployeeMaster EMP ON EMP.EmployeeID = GOP.EmployeeId    
		GROUP BY EMP.Grade,EX.ExercisedQuantity,EX.ExercisedPrice 
	)


	--SELECT * FROM #TEMP_ALL_DATA

	SELECT * INTO #TEMP_GROUP_BY_DATA
	FROM
	(
	SELECT Grade, convert(decimal(10,2),(convert(decimal(10,2),SUM(AvgProfitOnExercisePerOption))/convert(decimal(10,2),COUNT(AvgProfitOnExercisePerOption)))) AvgProfitOnExercisePerOption 
		 FROM #TEMP_Profit GROUP BY Grade) AS TEST

	--SELECT * FROM #TEMP_GROUP_BY_DATA
		 
	UPDATE #TEMP_ALL_DATA SET AvgProfitOnExercisePerOption = #TEMP_GROUP_BY_DATA.AvgProfitOnExercisePerOption FROM #TEMP_ALL_DATA
			INNER JOIN #TEMP_GROUP_BY_DATA ON #TEMP_ALL_DATA.GRADE = #TEMP_GROUP_BY_DATA.GRADE



	SELECT CASE WHEN GRADE = '' THEN '-' ELSE GRADE END GRADE, AvgExerciseTimeAfterVestInDays, AvgProfitOnExercisePerOption  FROM #TEMP_ALL_DATA ORDER BY GRADE
	
	DROP TABLE #TEMP_Profit
	DROP TABLE #TEMP_GROUP_BY_DATA
	DROP TABLE #TEMP_ALL_DATA

END
GO
