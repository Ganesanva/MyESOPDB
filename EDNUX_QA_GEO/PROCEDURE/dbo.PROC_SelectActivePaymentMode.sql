/****** Object:  StoredProcedure [dbo].[PROC_SelectActivePaymentMode]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectActivePaymentMode]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectActivePaymentMode]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectActivePaymentMode] 
(
	@PaymentMaster_Id INT = NULL,
	@MIT_ID           INT = NULL
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @PaymentMaster_Id = ISNULL(@PaymentMaster_Id, 0);

	IF (@PaymentMaster_Id > 0)
	BEGIN
		SELECT ResidentialPaymentMode.PaymentMaster_Id AS Id
			,PaymentMaster.PayModeName AS NAME
		FROM ResidentialPaymentMode
		INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id
		WHERE isActivated = 'Y'
			AND ResidentialPaymentMode.ResidentialType_Id = @PaymentMaster_Id
			AND PaymentMaster.PaymentMode NOT IN (
				'A'
				,'P'
				)
			AND ResidentialPaymentMode.MIT_ID = @MIT_ID
	END
	ELSE
	BEGIN --Resident Wise
		SELECT DISTINCT ResidentialPaymentMode.PaymentMaster_Id AS Id
			,PaymentMaster.PayModeName AS NAME
		FROM ResidentialPaymentMode
		INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id
		WHERE (
				isActivated = 'Y'
				OR ResidentialPaymentMode.PaymentMaster_Id IN (
					3
					,9
					,10
					)
				)
			AND PaymentMaster.PaymentMode NOT IN (
				'A'
				,'P'
				)
			AND ResidentialPaymentMode.MIT_ID = @MIT_ID
	END

	SET NOCOUNT OFF;
END
GO
