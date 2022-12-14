/****** Object:  StoredProcedure [dbo].[PROC_SelectProcessNote]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SelectProcessNote]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SelectProcessNote]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SelectProcessNote] @ResidentialType_Id INT = 0
	,@PaymentMaster_Id INT = 0
	,@MIT_ID INT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT PROCESSNOTE
	FROM RESIDENTIALPAYMENTMODE
	WHERE RESIDENTIALTYPE_ID = @ResidentialType_Id
	AND PAYMENTMASTER_ID = @PaymentMaster_Id AND MIT_ID = @MIT_ID

	SET NOCOUNT OFF;
END
GO
