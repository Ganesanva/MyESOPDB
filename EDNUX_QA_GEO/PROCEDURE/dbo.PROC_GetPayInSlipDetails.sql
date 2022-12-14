/****** Object:  StoredProcedure [dbo].[PROC_GetPayInSlipDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPayInSlipDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPayInSlipDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetPayInSlipDetails]
(
  @COMPANYID  VARCHAR(20) = NULL,
  @MIT_ID     INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ES.HeaderForExerciseAmount
		,ES.AccountNoForExerciseAmount
		,ES.HeaderForPerquisiteTax
		,ES.AccountNoForPerquisiteTax
	FROM CompanyParameters CP
	LEFT JOIN EXERCISE_SETTING ES on ES.CompanyID = CP.CompanyID AND MIT_ID = ISNULL(@MIT_ID,1)
	WHERE CP.COMPANYID = @COMPANYID

	SET NOCOUNT OFF;
END
GO
