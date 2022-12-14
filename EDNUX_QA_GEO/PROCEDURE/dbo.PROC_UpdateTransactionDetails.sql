/****** Object:  StoredProcedure [dbo].[PROC_UpdateTransactionDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateTransactionDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateTransactionDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE   PROCEDURE [dbo].[PROC_UpdateTransactionDetails]
	@PRN VARCHAR(200),  
	@BankTransactionId VARCHAR(200),
	@TPSLTransactionId VARCHAR(200),
	@PaymentStatus VARCHAR(200),
	@PAID VARCHAR(200),
	@Message VARCHAR(200),
	@Result	INT OUT 
AS
BEGIN
	BEGIN TRY	 
		
		DECLARE @ITEM_CODE VARCHAR(200)
		
		SET @ITEM_CODE  = (SELECT Item_Code FROM Transaction_Details WHERE MerchantreferenceNo= @PRN)
	
		UPDATE 
			Transaction_Details 
		SET 
			BankReferenceNo = @BankTransactionId,
			TPSLTransID = @TPSLTransactionId,
			Payment_status = @PaymentStatus,
			Transaction_Status = @PAID,
			FailureReson = @Message,
			LastUpdatedBy = 'ByOfflineScheduler',
			LastUpdated = GETDATE()
		WHERE 
			(MerchantreferenceNo = @PRN) AND (Item_Code = @ITEM_CODE)


			update  ShExercisedOptions  set PaymentMode='N'  from ShExercisedOptions inner join 
			Transaction_Details td  on td.Sh_ExerciseNo=ShExercisedOptions.ExerciseNo
				WHERE 
			(MerchantreferenceNo = @PRN) AND (Item_Code = @ITEM_CODE)

		
		SET @Result = 1
					
	END TRY
	BEGIN CATCH
		SET @Result = 0		
	END CATCH     
END       
GO
