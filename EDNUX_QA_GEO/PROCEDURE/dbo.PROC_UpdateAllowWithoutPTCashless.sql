/****** Object:  StoredProcedure [dbo].[PROC_UpdateAllowWithoutPTCashless]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateAllowWithoutPTCashless]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateAllowWithoutPTCashless]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateAllowWithoutPTCashless] @Allow_Without_PT CHAR
	,@LastUpdatedBy VARCHAR(100)
	,@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE PaymentMaster
	SET Allow_Without_PT = @Allow_Without_PT
		,LastUpdatedBy = @LastUpdatedBy
		,LastUpdatedOn = GETDATE()
	WHERE PaymentMode = 'C'

	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
