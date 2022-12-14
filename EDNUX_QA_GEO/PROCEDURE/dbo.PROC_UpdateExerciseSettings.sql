/****** Object:  StoredProcedure [dbo].[PROC_UpdateExerciseSettings]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateExerciseSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateExerciseSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UpdateExerciseSettings] @TrustRecOfEXeForm CHAR
	,@NTrustsRecOfEXeForm CHAR
	,@TrustDepositOfPayInstrument CHAR
	,@NTrustDepositOfPayInstrument CHAR
	,@TrustPayRecConfirmation CHAR
	,@NTrustPayRecConfirmation CHAR
	,@TrustGenShareTransList CHAR
	,@NTrustGenShareTransList CHAR
	,@LastUpdatedBy VARCHAR(20)
	,@PaymentMode CHAR
	,@MIT_ID INT
	,@retValue INT OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE ExerciseProcessSetting
	SET TrustRecOfEXeForm = @TrustRecOfEXeForm
		,NTrustsRecOfEXeForm = @NTrustsRecOfEXeForm
		,TrustDepositOfPayInstrument = @TrustDepositOfPayInstrument
		,NTrustDepositOfPayInstrument = @NTrustDepositOfPayInstrument
		,TrustPayRecConfirmation = @TrustPayRecConfirmation
		,NTrustPayRecConfirmation = @NTrustPayRecConfirmation
		,TrustGenShareTransList = @TrustGenShareTransList
		,NTrustGenShareTransList = @NTrustGenShareTransList
		,LastUpdatedBy = @LastUpdatedBy
		,LastUpdatedOn = GETDATE()
	WHERE PaymentMode = @PaymentMode AND MIT_ID = @MIT_ID	
	
	SET @retValue = @@ROWCOUNT;

	SET NOCOUNT OFF;
END
GO
