/****** Object:  StoredProcedure [dbo].[PROC_GetTypeOfBankAc]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetTypeOfBankAc]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetTypeOfBankAc]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetTypeOfBankAc] @PaymentMode CHAR
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CompanyName VARCHAR(100)
	SET @CompanyName = (SELECT DB_NAME() AS [Current Database])
	
	IF(UPPER(@CompanyName) = 'KPIT' AND UPPER(@PaymentMode) = 'A' OR UPPER(@PaymentMode) = 'P' )
	BEGIN
		SELECT *
		FROM TypeOfBankAc
		WHERE PaymentMode = @PaymentMode
		AND TypeOfBankAcName NOT IN ('NRE','NRO')
		ORDER BY TypeOfBankAcName
	END
	ELSE
	BEGIN
		SELECT *
		FROM TypeOfBankAc
		WHERE PaymentMode = @PaymentMode
		ORDER BY TypeOfBankAcName
	END
	SET NOCOUNT OFF;
END
GO
