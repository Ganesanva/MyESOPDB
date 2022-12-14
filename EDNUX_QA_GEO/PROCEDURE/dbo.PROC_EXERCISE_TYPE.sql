/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EXERCISE_TYPE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EXERCISE_TYPE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EXERCISE_TYPE]
@ExerciseNo INT  
AS  
BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT MCC.CODE_NAME   AS [Type] 
	FROM ShExercisedOptions SHE INNER join GrantLeg GL
	On GL.ID=SHE.GrantLegSerialNumber
	INNER Join Scheme SH on SH.SchemeId = GL.SchemeId
	INNER join MST_INSTRUMENT_TYPE MIT On MIT.MIT_ID=SH.MIT_ID
	INNER join MST_COM_CODE MCC ON MCC.MCC_ID=MIT.INSTRUMENT_GROUP
	WHERE SHE.ExerciseNo = @ExerciseNo
	
	SET NOCOUNT OFF;	
END
GO
