/****** Object:  StoredProcedure [dbo].[PROC_SelectActiveResidentialStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectActiveResidentialStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectActiveResidentialStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectActiveResidentialStatus] @PaymentMaster_Id INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT ResidentialPaymentMode.ResidentialType_Id AS Id
		,ResidentialType.Description AS NAME
	FROM ResidentialPaymentMode
	INNER JOIN ResidentialType ON ResidentialPaymentMode.ResidentialType_Id = ResidentialType.id
	WHERE (
			(ResidentialPaymentMode.isActivated = 'Y')
			AND ResidentialPaymentMode.PaymentMaster_Id = @PaymentMaster_Id
			)
		OR ResidentialPaymentMode.PaymentMaster_Id IN (
			3
			,9
			,10
			)

	SET NOCOUNT OFF;
END
GO
