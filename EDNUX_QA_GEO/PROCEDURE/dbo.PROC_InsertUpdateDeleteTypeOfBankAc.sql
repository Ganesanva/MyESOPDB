/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateDeleteTypeOfBankAc]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InsertUpdateDeleteTypeOfBankAc]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InsertUpdateDeleteTypeOfBankAc]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InsertUpdateDeleteTypeOfBankAc] @PaymentMode CHAR(1) = ''
	,@ResidentialStatus CHAR(1) = ''
	,@TypeOfBankAcName VARCHAR(150) = ''
	,@TypeOfBankAcID INT = 0
	,@Action CHAR(1) = ''
	,@OG_TypeOfBankAcName VARCHAR(150) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@Action = 'I')
	BEGIN
		INSERT INTO TypeOfBankAc
		VALUES (
			@PaymentMode
			,@ResidentialStatus
			,@TypeOfBankAcName
			)
	END
	ELSE IF (@Action = 'U')
	BEGIN
		UPDATE TypeOfBankAc
		SET TypeOfBankAcName = @TypeOfBankAcName
		WHERE PaymentMode = @PaymentMode
			AND ResidentialStatus = @ResidentialStatus
			AND TypeOfBankAcName = @OG_TypeOfBankAcName
	END
	ELSE
		DELETE
		FROM TypeOfBankAc
		WHERE TypeOfBankAcID = @TypeOfBankAcID

	SET NOCOUNT OFF;
END
GO
