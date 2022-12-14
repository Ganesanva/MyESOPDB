/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_TEMPLATE_NAME_BY_EXERCISENO]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_TEMPLATE_NAME_BY_EXERCISENO]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_TEMPLATE_NAME_BY_EXERCISENO]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_EXERCISE_TEMPLATE_NAME_BY_EXERCISENO]
(	 
	 @ExerciseNO NUMERIC(18,0),
	 @EmployeeID VARCHAR(100)
)
AS
BEGIN			
			-- Resolved Issue for Association EmployeeID 
	SET @EmployeeID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)
			SELECT 
				CONCAT(
						'PrintExerciseForm_',SE.MIT_ID,'_',
							(
								SELECT RT.[Description]
								FROM EmployeeMaster EM
								INNER JOIN ResidentialType RT 
								ON (Case when (Len(ISNULL(EM.ResidentialStatus,'R'))<=0) Then 'R' else ISNULL(EM.ResidentialStatus,'R') End) = RT.ResidentialStatus 
								WHERE EM.EmployeeID = SE.EmployeeID AND ISNULL(Deleted,0) = 0
							),'_',
							(
								SELECT PM.[Description]
								FROM PaymentMaster PM
								WHERE PM.PaymentMode = SE.PaymentMode 
							)
						)	AS TemplateName

				FROM ShExercisedOptions SE
				WHERE ExerciseNo=@ExerciseNO AND EmployeeID=@EmployeeID
END
GO
