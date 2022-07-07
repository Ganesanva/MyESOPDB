/****** Object:  StoredProcedure [dbo].[PROC_GetPerqPayable]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPerqPayable]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPerqPayable]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetPerqPayable] 
	@ExerciseNo numeric
AS
BEGIN
	SET NOCOUNT ON;   
	SELECT PerqstPayable FROM ShExercisedOptions WHERE ExerciseNo=@ExerciseNo ORDER BY PerqstPayable
END
GO
