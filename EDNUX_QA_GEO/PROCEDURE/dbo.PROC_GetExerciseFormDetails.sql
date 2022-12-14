/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseFormDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetExerciseFormDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseFormDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetExerciseFormDetails]
(
	@MIT_ID INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT (PaymentMaster.seqno)
		,PaymentMaster.PayModeName
		,PaymentMaster.PaymentMode
		,PaymentMaster.IsEnable
		,PMD.Exerciseform_Submit
	FROM ResidentialPaymentMode
	INNER JOIN PaymentMaster ON ResidentialPaymentMode.PaymentMaster_Id = PaymentMaster.Id
	INNER JOIN PAYMENT_MASTER_DETAILS PMD ON PMD.PM_ID = PaymentMaster.Id
		AND ResidentialPaymentMode.isActivated = 'Y'
		AND PaymentMaster.PaymentMode NOT IN (
			'A'
			,'P'
			)
	WHERE PMD.MIT_ID = ISNULL(@MIT_ID,1)
	ORDER BY PaymentMaster.seqno

	SET NOCOUNT OFF;
END
GO
