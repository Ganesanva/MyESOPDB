/****** Object:  StoredProcedure [dbo].[PROC_REVERSE_EXERCISE_FOR_SEPERATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_REVERSE_EXERCISE_FOR_SEPERATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_REVERSE_EXERCISE_FOR_SEPERATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_REVERSE_EXERCISE_FOR_SEPERATION] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	---------------------------
	-- CREATE TEMP TABLES
	---------------------------
	
	BEGIN
	
		---- TEMP TABLE FOR SEPARATION DATA

		CREATE TABLE #AUTOEXERCISE_DATA
		(
			ExerciseId NVARCHAR(50),GrantLegSerialNumber BIGINT,ExerciseDate DATETIME,ExercisedQuantity NUMERIC(18,0), EmployeeId NVARCHAR(100),ExerciseNo NUMERIC(18,0),
			MIT_ID INT, IsAutoExercised INT,IsPrevestExercised INT,LastUpdatedBy NVARCHAR(50),LastUpdatedOn DATETIME
		)		 
		
		CREATE TABLE #EMPLOYEE_SEPARATION_DATA
		(
			ID NVARCHAR(50),EmployeeId NVARCHAR(50),GrantLegSerialNumber BIGINT, EmployeeName NVARCHAR(500),ExerciseId NVARCHAR(50),
			ExerciseNo NUMERIC(18,0),ExerciseDate DATETIME,ExercisedQuantity NUMERIC(18,0),MIT_ID INT,IsAutoExercised INT,IsPrevestExercised INT,
			LastUpdatedBy NVARCHAR(50),LastUpdatedOn DATETIME
		)
			
	END			
	
	---------------------------------------
	-- INSERT DETAILS INTO TEMP SEPARATION TABLE
	---------------------------------------
	
	BEGIN

		 INSERT INTO #AUTOEXERCISE_DATA
		 (
	  		 ExerciseId,ExerciseNo,ExercisedQuantity,GrantLegSerialNumber,ExerciseDate,EmployeeID, MIT_ID,
			 IsAutoExercised ,IsPrevestExercised, LastUpdatedBy,LastUpdatedOn
		 )
	    SELECT
		SH.ExerciseId,SH.ExerciseNo,SH.ExercisedQuantity,SH.GrantLegSerialNumber,	
		SH.ExerciseDate,SH.EmployeeID,SH.MIT_ID,SH.IsAutoExercised ,SH.IsPrevestExercised,SH.LastUpdatedBy,SH.LastUpdatedOn
		FROM 
		SHEXERCISEDOPTIONS AS SH
		INNER JOIN GRANTLEG GL ON GL.ID = SH.GrantLegSerialNumber
		INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AEPC ON AEPC.SCHEME_ID = GL.SCHEMEID
		WHERE 
		SH.IsAutoExercised = 2  AND CONVERT(Date,SH.ExerciseDate)=CONVERT(Date,GETDATE())
		AND ISNULL(AEPC.IS_Reverse_Exercise_For_Seperation,0) = 1		
		
	--2020-10-19 00:00:00.000
		INSERT INTO #EMPLOYEE_SEPARATION_DATA 	
		(	
			EmployeeId, ExerciseId ,ExerciseNo,ExercisedQuantity , GrantLegSerialNumber,ExerciseDate,MIT_ID, EmployeeName,
			IsAutoExercised,IsPrevestExercised,ID,LastUpdatedBy,LastUpdatedOn
		)
		SELECT 
		AD.EmployeeID,AD.ExerciseId ,AD.ExerciseNo,AD.ExercisedQuantity,Ad.GrantLegSerialNumber,AD.ExerciseDate,AD.MIT_ID , EM.EmployeeName, AD.IsAutoExercised,AD.IsPrevestExercised,
		GL.ID,'ADMIN',GETDATE()

	FROM  
		#AUTOEXERCISE_DATA AS AD INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = AD.EmployeeId
		INNER JOIN GRANTLEG GL ON GL.ID = AD.GrantLegSerialNumber
		WHERE		    
			 EM.DateOfTermination IS NOT NULL AND CONVERT(datetime, EM.DateOfTermination) != CONVERT(datetime,0)
			 AND ISNULL(EM.ReasonForTermination,0) > 0
			 AND EM.Deleted = 0 
			 AND CONVERT(DATE, EM.DateOfTermination)<=Convert(date,AD.ExerciseDate)
			 AND CONVERT(DATE, GL.SeperationCancellationDate)<=Convert(date,AD.ExerciseDate)

		ORDER BY ExerciseId ASC 

				
	END

	----------------------------------------------------------------------------------------------------------------------------------------------------
	-- DATABASE UPDATE AND MANIPULATIONS, UPADTE GRANT LEG,DELETE EXERCISE_TAXRATE_DETAILS, DELETE TRANSACTIONS_EXERCISE_STEP, Delete ShExercisedOptions
	----------------------------------------------------------------------------------------------------------------------------------------------------
	

	IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #EMPLOYEE_SEPARATION_DATA) > 0)		

		BEGIN 
		
			BEGIN TRY
				
				BEGIN TRANSACTION
		
					---- UPDATE DETAILS IN GRANT LEG TABLE
					
					UPDATE GL SET GL.ExercisableQuantity = (GL.ExercisableQuantity + ETEMP.ExercisedQuantity),GL.UnapprovedExerciseQuantity= (GL.UnapprovedExerciseQuantity-ETEMP.ExercisedQuantity),GL.PerVestingQuantity=Null,
					GL.LastUpdatedBy = 'TaskShedular', GL.LastUpdatedOn = GETDATE() FROM GrantLeg AS GL
					INNER JOIN #EMPLOYEE_SEPARATION_DATA AS ETEMP ON ETEMP.ID = GL.ID                                                 
					

					--DELETE EXERCISE_TAXRATE_DETAILS
					DELETE FROM EXERCISE_TAXRATE_DETAILS 
					WHERE EXERCISE_NO IN(SELECT EXERCISENO FROM #EMPLOYEE_SEPARATION_DATA ETEMP)	

					--DELETE TRANSACTIONS_EXERCISE_STEP
					DELETE FROM TRANSACTIONS_EXERCISE_STEP  
					WHERE EXERCISE_NO IN(SELECT EXERCISENO FROM #EMPLOYEE_SEPARATION_DATA ETEMP)

					--Delete ShExercisedOptions
					DELETE FROM SHEXERCISEDOPTIONS
					WHERE EXERCISENO IN(SELECT EXERCISENO FROM #EMPLOYEE_SEPARATION_DATA ETEMP)								
														
				COMMIT TRANSACTION
														
			END TRY
			BEGIN CATCH
					
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION
				
				SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
				
			END CATCH
		END
	ELSE
		BEGIN
			PRINT 'NO DATA AVAILABLE FOR REVERSE EXERCISE'
		END
	
		SELECT distinct EmployeeId, ExerciseNo FROM #EMPLOYEE_SEPARATION_DATA order by 	EmployeeId asc	
	-------------------
	 --TEMP TABLE DETAILS
	-------------------
					
	BEGIN
	
		DROP TABLE #EMPLOYEE_SEPARATION_DATA	
		DROP TABLE #AUTOEXERCISE_DATA
	
	END
	
	SET NOCOUNT OFF;
END
GO
