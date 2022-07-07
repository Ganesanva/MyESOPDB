/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentModeList]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPaymentModeList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentModeList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetPaymentModeList]
        @MIT_ID INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT PAYMENTMASTER.PAYMENTMODE 
        ,PAYMENTMASTER.ID
		,RESIDENTIALTYPE.RESIDENTIALSTATUS
		,RESIDENTIALPAYMENTMODE.ISACTIVATED
		,PAYMENTMASTER.ISBANKACCNOACTIVATED
		,PAYMENTMASTER.ISTYPEOFBNKACCACTIVATED
		,PAYMENTMASTER.ISBNKBRNHADDACTIVATED
		,RESIDENTIALPAYMENTMODE.PAYMENT_MODE_CONFIG_TYPE
		,PAYMENTMASTER.PAYMODENAME
		,RESIDENTIALTYPE.Description AS RESIDENTNAME
		,RESIDENTIALTYPE.id AS RESIDENTID
		,RESIDENTIALPAYMENTMODE.PROCESSNOTE
		,CASE WHEN RESIDENTIALPAYMENTMODE.PROCESSNOTE IS NULL THEN '0' ELSE '1' END ISEDITABLE
		,ISNULL(RESIDENTIALPAYMENTMODE.IsValidatedBankAcc,'0') AS IsValidatedBankAcc
        ,ISNULL(RESIDENTIALPAYMENTMODE.IsValidatedDematAcc,'0') AS IsValidatedDematAcc
		,ISNULL(RESIDENTIALPAYMENTMODE.IsOneProcessFlow,'0') AS IsOneProcessFlow
		,ISNULL(ResidentialPaymentMode.IsUpdatedDematAcc, '0') AS IsUpdatedDematAcc
	FROM RESIDENTIALPAYMENTMODE
	LEFT JOIN RESIDENTIALTYPE ON RESIDENTIALPAYMENTMODE.RESIDENTIALTYPE_ID = RESIDENTIALTYPE.ID 
	INNER JOIN PAYMENTMASTER ON RESIDENTIALPAYMENTMODE.PAYMENTMASTER_ID = PAYMENTMASTER.ID WHERE MIT_ID = @MIT_ID    

	SET NOCOUNT OFF;
END
GO
