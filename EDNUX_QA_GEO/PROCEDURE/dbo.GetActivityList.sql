/****** Object:  StoredProcedure [dbo].[GetActivityList]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetActivityList]
GO
/****** Object:  StoredProcedure [dbo].[GetActivityList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetActivityList] 	
	@TrsutCompanyId VARCHAR(150)
AS
BEGIN
	SET NOCOUNT ON;

	EXEC UpdateFormStatusFromTrustDB @TrsutCompanyId
	

	SELECT 1 AS SRNO, 'Complete list with status' COLUMN_NAME, 'A' AS COLUMN_VALUE
	UNION
	SELECT 2 AS SRNO, CASE WHEN NTrustsRecOfEXeForm = 'Y' OR TrustRecOfEXeForm = 'Y' THEN 'For updating form receipt status' ELSE '--' END AS COLUMN_NAME, 'R' AS COLUMN_VALUE FROM ExerciseProcessSetting WHERE NTrustsRecOfEXeForm = 'Y' OR TrustRecOfEXeForm = 'Y'
	UNION
	SELECT 3 AS SRNO, CASE WHEN NTrustDepositOfPayInstrument = 'Y' OR TrustDepositOfPayInstrument = 'Y' THEN 'For updating payment deposit' ELSE '--' END AS COLUMN_NAME , 'D' AS COLUMN_VALUE FROM ExerciseProcessSetting WHERE NTrustDepositOfPayInstrument = 'Y' OR TrustDepositOfPayInstrument = 'Y'
	UNION
	SELECT 4 AS SRNO, CASE WHEN NTrustPayRecConfirmation = 'Y' OR TrustPayRecConfirmation = 'Y' THEN 'For updating payment confirmation' ELSE '--' END AS COLUMN_NAME , 'C' AS COLUMN_VALUE FROM ExerciseProcessSetting WHERE NTrustPayRecConfirmation = 'Y' OR TrustPayRecConfirmation = 'Y'
	UNION
	SELECT 5 AS SRNO, CASE WHEN NTrustGenShareTransList = 'Y' OR TrustGenShareTransList = 'Y' THEN 'For updating allotment update' ELSE '--' END AS COLUMN_NAME , 'U' AS COLUMN_VALUE FROM ExerciseProcessSetting WHERE NTrustGenShareTransList = 'Y' OR TrustGenShareTransList = 'Y'

END
GO
