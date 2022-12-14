/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentMaster]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdatePaymentMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdatePaymentMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdatePaymentMaster] @PaymentMode CHAR = NULL
	,@IsBankAccNoActivated BIT = NULL
	,@IsTypeOfBnkAccActivated BIT = NULL
	,@IsBnkBrnhAddActivated BIT = NULL
	,@Exerciseform_Submit CHAR = NULL
	,@LastUpdatedBy VARCHAR(100) = NULL
    ,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE PaymentMaster
	SET IsBankAccNoActivated = ISNULL(@IsBankAccNoActivated, IsBankAccNoActivated)
		,IsTypeOfBnkAccActivated = ISNULL(@IsTypeOfBnkAccActivated, IsTypeOfBnkAccActivated)
		,IsBnkBrnhAddActivated = ISNULL(@IsBnkBrnhAddActivated, IsBnkBrnhAddActivated)
		,Exerciseform_Submit = ISNULL(@Exerciseform_Submit, Exerciseform_Submit)
		,LastUpdatedBy = ISNULL(@LastUpdatedBy, LastUpdatedBy)
		,LastUpdatedOn = GETDATE()
	WHERE PaymentMode = @PaymentMode

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
