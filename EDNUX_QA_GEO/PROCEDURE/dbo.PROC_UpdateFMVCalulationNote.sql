/****** Object:  StoredProcedure [dbo].[PROC_UpdateFMVCalulationNote]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateFMVCalulationNote]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateFMVCalulationNote]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateFMVCalulationNote] @FMVCalculation_Note VARCHAR(max) = ''
	,@LastUpdatedBy VARCHAR(20) = NULL
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE CompanyMaster
	SET FMVCalculation_Note = @FMVCalculation_Note
		,LastUpdatedBy = @LastUpdatedBy
		,LastUpdatedOn = GETDATE()

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
