/****** Object:  StoredProcedure [dbo].[PROC_UpdateUploadExerciseFormStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateUploadExerciseFormStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateUploadExerciseFormStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateUploadExerciseFormStatus]
(
	@ExerciseId INT, --Consider as ExerciseNo
	@DOCUMENT_NAME VARCHAR(50)=NULL,
	@IsAccepted INT=NULL,
	@PAYMENTMODE VARCHAR(50)=NULL,
	@ISONEPROCESSFLOW bit=0

)
 AS
 BEGIN
	SET NOCOUNT ON;
	DECLARE @MDUM_ID INT  
	DECLARE @EmployeeID   VARCHAR(50)    
	SELECT @MDUM_ID=MDUM_ID FROM MST_DOCUMENT_UPLOAD_MASTER WHERE UPPER(DOCUMENT_NAME) = UPPER(@DOCUMENT_NAME)
	DECLARE @MaxStepID INT

	SELECT @EmployeeID=EmployeeID FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseId	

	IF @DOCUMENT_NAME IS NOT NULL AND @DOCUMENT_NAME <> ''
	BEGIN
		IF NOT EXISTS(SELECT MDUMD_ID FROM MST_DOCUMENT_UPLOAD_MASTER_DETAILS WHERE MDUM_ID=@MDUM_ID AND Exercise_NO = @ExerciseId )
		BEGIN  
			INSERT INTO MST_DOCUMENT_UPLOAD_MASTER_DETAILS (MDUM_ID,EXERCISE_NO,IS_UPLOADED,IS_UPLOADED_ON,EMPLOYEEID,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON) VALUES (@MDUM_ID,@ExerciseId,1,GETDATE(),@EmployeeID,@EmployeeID,GETDATE(),@EmployeeID,GETDATE())		
	    END
		ELSE 
		BEGIN
			UPDATE MST_DOCUMENT_UPLOAD_MASTER_DETAILS SET IS_UPLOADED = 1 , IS_UPLOADED_ON = GETDATE(), UPDATED_BY=@EmployeeID, UPDATED_ON=GETDATE() WHERE MDUM_ID = @MDUM_ID AND EXERCISE_NO=@ExerciseId			
		END	

		UPDATE ShExercisedOptions SET IS_UPLOAD_EXERCISE_FORM = 1 , IS_UPLOAD_EXERCISE_FORM_ON = GETDATE(),LastUpdatedOn = GETDATE() WHERE ExerciseNo = @ExerciseId 
	    UPDATE ShExercisedOptions SET isFormGenerate = 1, LastUpdatedOn = GETDATE() WHERE ExerciseNo = @ExerciseId 
	    UPDATE ShExercisedOptions SET IsAccepted = 1,IsAcceptedOn = GETDATE(), LastUpdatedOn = GETDATE()  WHERE ExerciseNo = @ExerciseId
	
		IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseId)
		BEGIN	     
			UPDATE TES SET IS_ATTEMPTED = 1 , UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
			FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
				ON TES.EXERCISE_NO = SHEX.ExerciseNo 
			WHERE EXERCISE_NO = @ExerciseId and EXERCISE_STEPID  IN ( 4,5)
		END	

	END

	IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseId )
	        BEGIN	     
			            
					UPDATE ShExercisedOptions SET IsAccepted = 1,IsAcceptedOn = GETDATE(), LastUpdatedOn = GETDATE()  WHERE ExerciseNo = @ExerciseId
	
	    			UPDATE TES SET IS_ATTEMPTED = 1 , UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
	    			FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
	  			      ON TES.EXERCISE_NO = SHEX.ExerciseNo 
	    			WHERE EXERCISE_NO = @ExerciseId and EXERCISE_STEPID  in(3)
	        END

	
	 
	IF (@IsAccepted > 0) AND NOT EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseId and EXERCISE_STEPID  = 4)
	  BEGIN

		  UPDATE ShExercisedOptions SET IS_UPLOAD_EXERCISE_FORM = 1 , IS_UPLOAD_EXERCISE_FORM_ON = GETDATE(),LastUpdatedOn = GETDATE() WHERE ExerciseNo = @ExerciseId 
	      UPDATE ShExercisedOptions SET isFormGenerate = 1, LastUpdatedOn = GETDATE() WHERE ExerciseNo = @ExerciseId 
	      UPDATE ShExercisedOptions SET IsAccepted = 1,IsAcceptedOn = GETDATE(), LastUpdatedOn = GETDATE()  WHERE ExerciseNo = @ExerciseId
	  
	      IF EXISTS(SELECT 1 FROM TRANSACTIONS_EXERCISE_STEP WHERE EXERCISE_NO = @ExerciseId)
	        BEGIN	     
	    			UPDATE TES SET IS_ATTEMPTED = 1 , UPDATED_BY = SHEX.EmployeeID , UPDATED_ON = GETDATE()
	    			FROM TRANSACTIONS_EXERCISE_STEP TES INNER JOIN ShExercisedOptions SHEX 
	  			      ON TES.EXERCISE_NO = SHEX.ExerciseNo 
	    			WHERE EXERCISE_NO = @ExerciseId and EXERCISE_STEPID  in(5)
	        END

			IF(@PAYMENTMODE='A' OR @PAYMENTMODE='P' AND @ISONEPROCESSFLOW=1 )
			BEGIN
			UPDATE ShExercisedOptions SET IsOneProcessFlow = 1, LastUpdatedOn = GETDATE()  WHERE ExerciseNo = @ExerciseId
			END
	  END

	SET NOCOUNT OFF;
	
 END	
 
GO
