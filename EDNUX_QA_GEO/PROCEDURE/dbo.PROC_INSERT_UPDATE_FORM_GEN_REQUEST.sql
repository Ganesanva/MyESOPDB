/****** Object:  StoredProcedure [dbo].[PROC_INSERT_UPDATE_FORM_GEN_REQUEST]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_UPDATE_FORM_GEN_REQUEST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_UPDATE_FORM_GEN_REQUEST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_INSERT_UPDATE_FORM_GEN_REQUEST]
(	 
	 @EXERCISE_NO NUMERIC NULL,
	 @EMPLOYEEID VARCHAR(100) NULL,
	 @ISPROCESSED INT NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	IF((SELECT COUNT(EXERCISE_NO) FROM ESOP_FORM_GEN_REQUEST WHERE EXERCISE_NO = @EXERCISE_NO) > 0)
		BEGIN
			UPDATE 
				ESOP_FORM_GEN_REQUEST 
			SET 
				ISPROCESSED = @ISPROCESSED, ISPROCESSEDON = GETDATE(), UPDATED_BY = @EMPLOYEEID, UPDATED_ON = GETDATE()
			WHERE 
				EXERCISE_NO = @EXERCISE_NO AND EMPLOYEEID = @EMPLOYEEID
		END
	ELSE
		BEGIN
			INSERT INTO ESOP_FORM_GEN_REQUEST
			(	
				EXERCISE_NO, EMPLOYEEID, ISPROCESSED, ISPROCESSEDON, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON
			)
			Values
			( 
				@EXERCISE_NO, @EMPLOYEEID, @ISPROCESSED, GETDATE(), @EMPLOYEEID, GETDATE(), @EMPLOYEEID, GETDATE()
			)
		END

	SELECT @EXERCISE_NO
	
	SET NOCOUNT OFF;
END
GO
