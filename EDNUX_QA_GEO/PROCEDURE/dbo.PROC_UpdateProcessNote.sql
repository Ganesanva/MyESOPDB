/****** Object:  StoredProcedure [dbo].[PROC_UpdateProcessNote]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateProcessNote]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateProcessNote]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateProcessNote] @ProcessNote NVARCHAR(MAX) = NULL
	,@ResidentialType_Id INT = NULL
	,@PaymentMaster_Id INT = NULL
	,@ExerciseFormText1 NVARCHAR(MAX) = NULL
	,@ExerciseFormText2 NVARCHAR(MAX) = NULL
	,@ExerciseFormText3 NVARCHAR(MAX) = NULL
	,@ExerciseFormTemplate NVARCHAR(100) = NULL
	,@MIT_ID INT = NULL	
	,@LastUpdatedBy VARCHAR(100) = NULL
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE ResidentialPaymentMode
	SET ProcessNote = ISNULL(@ProcessNote, ProcessNote)
		,ExerciseFormText1 = ISNULL(@ExerciseFormText1, ExerciseFormText1)
		,ExerciseFormText2 = ISNULL(@ExerciseFormText2, ExerciseFormText2)
		,ExerciseFormText3 = ISNULL(@ExerciseFormText3, ExerciseFormText3)
		,TemplateName = ISNULL(@ExerciseFormTemplate, TemplateName)
		,LastUpdatedBy = @LastUpdatedBy
		,LastUpdatedOn = GETDATE()
	WHERE ResidentialType_Id = @ResidentialType_Id
		AND PaymentMaster_Id = @PaymentMaster_Id
		AND MIT_ID = @MIT_ID

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
