/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetExerciseData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetExerciseData] @ResidentialType_Id INT = 0
	,@PaymentMaster_Id INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ExerciseFormText1
		,ExerciseFormText2
		,ExerciseFormText3
		,TemplateName
	FROM ResidentialPaymentMode
	WHERE ResidentialType_Id = @ResidentialType_Id
		AND PaymentMaster_Id = @PaymentMaster_Id

	SET NOCOUNT OFF;
END
GO
