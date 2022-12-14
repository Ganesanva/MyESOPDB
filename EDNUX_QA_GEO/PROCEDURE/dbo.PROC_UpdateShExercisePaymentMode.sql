/****** Object:  StoredProcedure [dbo].[PROC_UpdateShExercisePaymentMode]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateShExercisePaymentMode]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateShExercisePaymentMode]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateShExercisePaymentMode]
(
	@ExerciseId INT,
	@PaymentModeId INT 
)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @PaymentMode VARCHAR(2)
    
	SELECT 
		@PaymentMode=PaymentMode 
	FROM 
		PaymentMaster 
	WHERE 
		Id = @PaymentModeId
    
	UPDATE ShExercisedOptions SET PaymentMode=@PaymentMode WHERE ExerciseNo = @ExerciseId 
	
	SET NOCOUNT OFF;
	
 END	
GO
