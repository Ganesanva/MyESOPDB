/****** Object:  StoredProcedure [dbo].[PROC_IsUserBlockedORUnblocked]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_IsUserBlockedORUnblocked]
GO
/****** Object:  StoredProcedure [dbo].[PROC_IsUserBlockedORUnblocked]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_IsUserBlockedORUnblocked]
( 
	@ExerciseNo VARCHAR(30),
	@PayMode	VARCHAR(5) 
)
AS
BEGIN
	IF ((SELECT COUNT(1) 
			FROM ShExercisedOptions 
			WHERE REPLACE(CONVERT(VARCHAR,ExerciseDate,103), '/','') 
			IN(	SELECT	REPLACE(CONVERT(VARCHAR,ExerciseDate,103), '/','')  
				FROM SentExercised     
				WHERE SUBSTRING(REPLACE(TrancheName,DB_NAME(),''),1,2)=''+@PayMode+'' 
				AND SentExercised.CompanyName = DB_NAME()) 
			AND ExerciseNo =  @ExerciseNo )>0)
		BEGIN 
			SELECT 'BLOCKUSER' AS OUT_PUT 
		END 
	ELSE 
		BEGIN 
			SELECT 'CONTINUE' AS OUT_PUT 
		END
END							
GO
