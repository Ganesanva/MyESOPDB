/****** Object:  StoredProcedure [dbo].[PROC_SelectAllowWithoutPTCashless]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectAllowWithoutPTCashless]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectAllowWithoutPTCashless]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectAllowWithoutPTCashless]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Allow_Without_PT
	FROM PaymentMaster
	WHERE PaymentMode = 'C'

	SET NOCOUNT OFF;
END
GO
