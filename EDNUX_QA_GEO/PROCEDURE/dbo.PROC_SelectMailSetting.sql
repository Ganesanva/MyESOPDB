/****** Object:  StoredProcedure [dbo].[PROC_SelectMailSetting]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectMailSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectMailSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_SelectMailSetting]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT PayModeName
		,PaymentMode
		,ConfirmPaymentMailSent
		,Exerciseform_Submit_SndMail
		,ExerciseReversal_SendMail
	FROM PaymentMaster
	WHERE Parentid = 0

	SET NOCOUNT OFF;
END
GO
