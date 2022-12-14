/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentDetailsforEMFM]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdatePaymentDetailsforEMFM]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentDetailsforEMFM]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdatePaymentDetailsforEMFM] 
@Paid Varchar(20),
@BankReferenceNo varchar(25),
@Merchant_Code varchar(50),
@Amount numeric,
@Item_Code varchar(50),
@BankName varchar(100),
@ErrorCode varchar(50),
@TPSTTransID numeric,
@FailureReson varchar(50),
@ExerciseNo numeric,
@MarginOrFunding varchar(1),
@Result	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;  

    SET @Result=0
    
    BEGIN TRY
			IF (@Paid = 'Y') 
		
				BEGIN
					UPDATE  Transaction_Details_Funding SET 
						BankReferenceNo = @BankReferenceNo,  
						Merchant_Code = @Merchant_Code, 
						Amount =  @Amount,  
						Item_Code = @Item_Code,  
						Payment_status='S',  
						Transaction_Status='Y',  
						Transaction_Date = GETDATE(),                         
						LastUpdated = GETDATE(),  
						BankName	= @BankName,  
						ErrorCode	= @ErrorCode,  
						TPSTTransID =  @TPSTTransID,  
						FailureReson = @FailureReson
					WHERE Sh_ExerciseNo = @ExerciseNo AND  
						MarginOrFunding = @MarginOrFunding 
						
						SET @Result=1
				END
			
			ELSE
				BEGIN
					UPDATE  Transaction_Details_Funding SET 
						BankReferenceNo = @BankReferenceNo,  
						Merchant_Code = @Merchant_Code, 
						Amount =  @Amount,  
						Item_Code = @Item_Code,
						Payment_status = 'F',  
						Transaction_Status = 'N',  
						Transaction_Date = GETDATE(),                      
						LastUpdated = GETDATE(),  
						BankName	= @BankName,
						ErrorCode	= @ErrorCode,
						TPSTTransID = @TPSTTransID,
						FailureReson = @FailureReson  
					WHERE Sh_ExerciseNo = @ExerciseNo AND 
						MarginOrFunding = @MarginOrFunding 
						
						SET @Result=1
				END
	END TRY
	BEGIN CATCH
		SET @Result=0
    END CATCH
    
    SELECT  @Result AS Result
END
GO
