/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentModeConfiguration]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdatePaymentModeConfiguration]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentModeConfiguration]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdatePaymentModeConfiguration]
 
     @IsActivated             CHAR(1) = null,
	 @PaymentMode             CHAR(1) = null,
	 @PaymentModeConfigType   NVARCHAR(100) = null, 
	 @ResidentialStatus       CHAR(1) = null,
	 @MIT_ID                  INT = null,
	 @IsBankAccNoActivated    BIT = null,
	 @IsTypeOfBnkAccActivated BIT = null,
	 @IsBnkBrnhAddActivated   BIT = null,
	 @AutoRevForOnlineEx      BIT = null, 
	 @AutoRevMinutes          INT = null,
	 @LoginId                 VARCHAR(100) = null,
	 @EnableBankAcc           INT = null,
	 @IsApplicableForCashless BIT = null,
	 @IsValidatedDematAcc     BIT = null, 
	 @IsUpdateDematAcc		  BIT = null, 
	 @IsValidatedBankAcc      BIT = null, 
	 @IsOneProcessFlow        BIT = null,
	 @retValues INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN
	     
		   IF(Upper(@PaymentModeConfigType) = 'COMPANY')
			  BEGIN
			     UPDATE ResidentialPaymentMode 
                 SET IsValidatedDematAcc=@IsValidatedDematAcc, IsValidatedBankAcc=@IsValidatedBankAcc,IsOneProcessFlow=@IsOneProcessFlow ,isActivated=@IsActivated, LastUpdatedBy=@LoginId, LastUpdatedOn=GETDATE(),
                 IsUpdatedDematAcc = @IsUpdateDematAcc
				 FROM ResidentialPaymentMode RPM INNER JOIN PaymentMaster PM on PM.Id = RPM.PaymentMaster_Id
                 WHERE PM.PaymentMode = @PaymentMode AND PAYMENT_MODE_CONFIG_TYPE =@PaymentModeConfigType AND MIT_ID=@MIT_ID
			   
			  END
		   ELSE 
			  BEGIN
				  UPDATE ResidentialPaymentMode 
				  SET IsValidatedDematAcc=@IsValidatedDematAcc, IsValidatedBankAcc=@IsValidatedBankAcc,IsOneProcessFlow=@IsOneProcessFlow ,isActivated=@IsActivated, LastUpdatedBy=@LoginId, LastUpdatedOn=GETDATE(),
				  IsUpdatedDematAcc = @IsUpdateDematAcc
				  FROM ResidentialPaymentMode RPM INNER JOIN ResidentialType RT ON RPM.ResidentialType_Id = RT.id 
				  INNER JOIN PaymentMaster PM ON PM.Id = RPM.PaymentMaster_Id
				  WHERE PM.PaymentMode = @PaymentMode AND RT.ResidentialStatus= @ResidentialStatus 
				  AND PAYMENT_MODE_CONFIG_TYPE =@PaymentModeConfigType AND MIT_ID=@MIT_ID
				   
				  IF( @EnableBankAcc = 1)
				  BEGIN	   
						 UPDATE PAYMENTMASTER
						 SET IsBankAccNoActivated = @IsBankAccNoActivated, IsTypeOfBnkAccActivated = @IsTypeOfBnkAccActivated, IsBnkBrnhAddActivated =  @IsBnkBrnhAddActivated 
						 WHERE PaymentMode = @PaymentMode
				  END
			END
	END

	IF(@AutoRevForOnlineEx IS NOT NULL AND @AutoRevMinutes IS NOT NULL)
	BEGIN
	     UPDATE CompanyParameters SET AutoRevForOnlineEx = @AutoRevForOnlineEx, AutoRevMinutes = @AutoRevMinutes 
	END

	SET @retValues = @@ROWCOUNT;
	
	SET NOCOUNT OFF;
END 
GO
