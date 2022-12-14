/****** Object:  StoredProcedure [dbo].[IsValidateGenerateShareTransfer]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IsValidateGenerateShareTransfer]
GO
/****** Object:  StoredProcedure [dbo].[IsValidateGenerateShareTransfer]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================
-- Author:		 OMPRAKASH KATRE																	==
-- Description:	 Validate Generate Share Transfer list												==
-- DECLARE @RESUTL INT EXEC IsValidateGenerateShareTransfer 40,@RESUTL OUT select @RESUTL   ==
-- Modified by : Santosh Panchal
-- Description : Procedure modified during Web-Service to WCF service conversion. Change parameter name '@isResult' to '@Result'.
-- ===================================================================================================

CREATE PROCEDURE [dbo].[IsValidateGenerateShareTransfer] 
	 @ExcId INT,
	 @Result INT = 0 OUTPUT 
AS
BEGIN
	DECLARE @ExFormReceived CHAR
	DECLARE @ExFormRequired CHAR
	SET @Result = 1

SELECT 
	@ExFormReceived = ExerciseFormReceived,
	@ExFormRequired = EPS.TrustRecOfEXeForm	
FROM 
	ShExercisedOptions SHEX INNER JOIN 
	ExerciseProcessSetting EPS ON EPS.PaymentMode = SHEX.PaymentMode AND EPS.MIT_ID = SHEX.MIT_ID	
WHERE 
	SHEX.ExerciseId = @ExcId


	IF @ExFormRequired = 'Y' 
	BEGIN
		IF (@ExFormReceived = 'Y')
			SET @Result=1
		ELSE
			SET @Result=0
	END
RETURN @Result
END
GO
