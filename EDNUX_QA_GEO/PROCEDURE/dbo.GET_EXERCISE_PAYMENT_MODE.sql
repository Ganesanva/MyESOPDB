/****** Object:  StoredProcedure [dbo].[GET_EXERCISE_PAYMENT_MODE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_EXERCISE_PAYMENT_MODE]
GO
/****** Object:  StoredProcedure [dbo].[GET_EXERCISE_PAYMENT_MODE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_EXERCISE_PAYMENT_MODE]
@EmployeeId NVARCHAR(MAX) = NULL,
@ExerciseNo NVARCHAR(MAX) = NULL
AS	   
BEGIN
	SET NOCOUNT ON;	
		
				 SELECT 
					SHEO.ExerciseNo ,UM.EmployeeId , UM.UserName ,SHEO.ExerciseDate, SUM(SHEO.ExercisedQuantity) AS ExercisedQuantity ,			
					ISNULL(PM.PayModeName,'') AS PayModeName								
					FROM 
		            ShExercisedOptions AS SHEO 
		            INNER JOIN PaymentMaster AS PM ON PM.PaymentMode=SHEO.PaymentMode
		            INNER JOIN UserMaster AS UM ON UM.EmployeeId = SHEO.EmployeeID
					WHERE SHEO.EmployeeID = COALESCE(@EmployeeId,SHEO.EmployeeID) AND SHEO.ExerciseNo = COALESCE(@ExerciseNo,SHEO.ExerciseNo)
					GROUP BY 
					SHEO.ExerciseNo ,UM.EmployeeId , UM.UserName ,SHEO.ExerciseDate,PayModeName
				    
					
    SET NOCOUNT OFF;						
End
GO
