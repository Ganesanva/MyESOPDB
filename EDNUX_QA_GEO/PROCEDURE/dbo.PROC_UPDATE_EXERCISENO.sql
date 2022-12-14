/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EXERCISENO]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_EXERCISENO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_EXERCISENO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_EXERCISENO]
AS
BEGIN


	DECLARE @ChkAutoExercisedFlag INT
	SELECT TOP 1  @ChkAutoExercisedFlag = IsAutoExercised FROM ShExercisedOptions

	CREATE TABLE #TEMP_UPDATE_EXERCISE_NO
	(
	  TUEN_GRANT_LEG_ID BIGINT, TUEN_EXERCISE_NO NVARCHAR(500),TUEN_EMPLOYEEID VARCHAR(50), TUEN_GRANTOPTION_ID NVARCHAR(500),TUEN_GRANTREGISTRATION_ID NVARCHAR(500),TUEN_EXERCISEDATE DATETIME
	)


		-- FOR AUTOEXERCISE --
	IF(@ChkAutoExercisedFlag =  1)
	BEGIN
	
		INSERT INTO #TEMP_UPDATE_EXERCISE_NO
		(
	     TUEN_GRANT_LEG_ID, TUEN_EXERCISE_NO,TUEN_EMPLOYEEID,TUEN_GRANTOPTION_ID,TUEN_GRANTREGISTRATION_ID,TUEN_EXERCISEDATE
		)
		SELECT 
		GL.GrantLegId, MIN(SEO.ExerciseId),SEO.EmployeeID  ,GL.GrantOptionId,
		GL.GrantRegistrationId,SEO.ExerciseDate		
		FROM 
			ShExercisedOptions AS SEO
			INNER JOIN GrantLeg AS GL ON GL.ID = SEO.GrantLegSerialNumber	
	    WHERE 
			SEO.IsAutoExercised = 1 AND SEO.ExerciseDate <= CONVERT(DATE, GETDATE())
		GROUP BY 
			GL.GrantRegistrationId,GL.GrantOptionId,GL.GrantLegId,SEO.EmployeeID ,SEO.ExerciseDate	
	END
	-- FOR PREVESTING --
	ELSE IF(@ChkAutoExercisedFlag =  2)
	BEGIN
		 INSERT INTO #TEMP_UPDATE_EXERCISE_NO
		(
		 TUEN_GRANT_LEG_ID, TUEN_EXERCISE_NO,TUEN_EMPLOYEEID,TUEN_GRANTOPTION_ID,TUEN_GRANTREGISTRATION_ID,TUEN_EXERCISEDATE
		)
		SELECT 
		GL.GrantLegId, MIN(SEO.ExerciseId),SEO.EmployeeID ,GL.GrantOptionId,
		GL.GrantRegistrationId,SEO.ExerciseDate			
		FROM 
			ShExercisedOptions AS SEO
			INNER JOIN GrantLeg AS GL ON GL.ID = SEO.GrantLegSerialNumber				
		WHERE 
			SEO.FMVPrice IS  NULL AND SEO.IsAutoExercised = 2 AND SEO.ExerciseDate >= CONVERT(DATE, GETDATE())			
		GROUP BY 
			GL.GrantRegistrationId,GL.GrantOptionId,GL.GrantLegId,SEO.EmployeeID,SEO.ExerciseDate	
	END
		
	BEGIN TRY
				
	BEGIN TRANSACTION
				
			   UPDATE 
					SHO SET ExerciseNo = TUEN.TUEN_EXERCISE_NO
				FROM 
					ShExercisedOptions AS SHO
					INNER JOIN  GrantLeg AS GL ON
							SHO.GrantLegSerialNumber = GL.ID
					INNER JOIN #TEMP_UPDATE_EXERCISE_NO AS TUEN ON TUEN.TUEN_EMPLOYEEID = SHO.EmployeeID  
					AND
					TUEN.TUEN_GRANT_LEG_ID = SHO.GrantLegId
					AND
					TUEN.TUEN_GRANTOPTION_ID = GL.GrantOptionId
					AND 
					TUEN.TUEN_GRANTREGISTRATION_ID = GL.GrantRegistrationId
					AND 
					TUEN.TUEN_EXERCISEDATE = SHO.ExerciseDate  



				 SELECT SHO.ExerciseNo,SHO.EmployeeID,TUEN.TUEN_EXERCISE_NO, SHO.ExerciseId
				 FROM 
					ShExercisedOptions AS SHO
					INNER JOIN  GrantLeg AS GL ON
                         SHO.GrantLegSerialNumber = GL.ID
					INNER JOIN #TEMP_UPDATE_EXERCISE_NO AS TUEN ON TUEN.TUEN_EMPLOYEEID = SHO.EmployeeID  
					AND
					TUEN.TUEN_GRANT_LEG_ID = SHO.GrantLegId
					AND
					TUEN.TUEN_GRANTOPTION_ID = GL.GrantOptionId
					AND 
					TUEN.TUEN_GRANTREGISTRATION_ID = GL.GrantRegistrationId

					
				DROP TABLE #TEMP_UPDATE_EXERCISE_NO	

	COMMIT TRANSACTION
			
	END TRY
	BEGIN CATCH
	ROLLBACK TRANSACTION
	END CATCH
END
GO
