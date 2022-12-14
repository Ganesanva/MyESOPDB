/****** Object:  StoredProcedure [dbo].[PROC_DELETE_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DELETE_TRANSACTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DELETE_TRANSACTION_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[PROC_DELETE_TRANSACTION_DETAILS]
	@MERCHANT_REFERENCE_NO	NVARCHAR(100),  
	@ITEM_NUMBER			NVARCHAR(100),  
	@EXERCISE_NUMBER		NVARCHAR(100),
	@Result					INT OUT 
AS
BEGIN
	BEGIN TRY	 
		
		DELETE FROM 
			Transaction_Details 
		WHERE 
			(MerchantreferenceNo = @MERCHANT_REFERENCE_NO) AND (Sh_ExerciseNo = @EXERCISE_NUMBER) AND (Item_Code = @ITEM_NUMBER) AND
			(Payment_status IS NULL) AND (Transaction_Status IS NULL)		
			update ShExercisedOptions set PaymentMode=null where ExerciseNo = @EXERCISE_NUMBER 
		SET @Result = 1
					
	END TRY
	BEGIN CATCH
		SET @Result = 0
	END CATCH     
END       
GO
