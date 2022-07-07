/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_GRANT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SOPsUI_VALIDATE_GRANT_EXPIRY_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_GRANT_EXPIRY_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SOPsUI_VALIDATE_GRANT_EXPIRY_DETAILS] 
	
	@SOPSsUI_GET_GRNAT_EXPIRY_DETAILS SOPSsUI_GET_GRNAT_EXPIRY_DETAILS READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--SELECT * FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS

	CREATE TABLE #TABLE_CHECK_COMBINAION
	(
		TCC_GRANT_OPTION_ID NVARCHAR(100),
		TCC_GRANT_LEG_ID NVARCHAR(10),
		TCC_VESTING_TYPE NVARCHAR(1),
	)
	
	-- Expiry date greater than or equal to Vesting Date

	CREATE TABLE #TABLE_EXPIRY_DATE_VALIDATION
	(
		TCC_GRANT_OPTION_ID NVARCHAR(100),
		TCC_GRANT_LEG_ID NVARCHAR(10),
		TCC_VESTING_TYPE NVARCHAR(1),
		TCC_ERROR_MESSAGE NVARCHAR(500)
	)
	
	INSERT INTO #TABLE_CHECK_COMBINAION 
	SELECT GRANT_OPTION_ID, GRANT_LEG_ID, GRANT_VESTING_TYPE FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS

	
	DELETE TCC
	FROM #TABLE_CHECK_COMBINAION AS TCC
	INNER JOIN GrantLeg AS GL ON GL.GrantOptionId = TCC.TCC_GRANT_OPTION_ID AND  GL.GrantLegId = TCC.TCC_GRANT_LEG_ID AND UPPER(GL.VestingType) = UPPER(TCC.TCC_VESTING_TYPE)	

	INSERT INTO #TABLE_EXPIRY_DATE_VALIDATION 	
	SELECT GRANT_OPTION_ID, GRANT_LEG_ID, GRANT_VESTING_TYPE, ERR_MESSAGE FROM
	(
		SELECT 
			GRANT_OPTION_ID, GRANT_LEG_ID, GRANT_VESTING_TYPE, 'Expiry Date should be greater than or equal to Vesting Date.' AS 'ERR_MESSAGE'
		FROM 
			@SOPSsUI_GET_GRNAT_EXPIRY_DETAILS AS SGGED
			INNER JOIN GrantLeg AS GL ON GL.GrantOptionId = SGGED.GRANT_OPTION_ID AND  GL.GrantLegId = SGGED.GRANT_LEG_ID AND UPPER(GL.VestingType) = UPPER(SGGED.GRANT_VESTING_TYPE)	
		WHERE 
			(CONVERT(DATE, GL.FinalVestingDate)) >= (CONVERT(DATE,SGGED.GRANT_EXPIRY_DATE))
		UNION ALL
		SELECT 
			GRANT_OPTION_ID, GRANT_LEG_ID, GRANT_VESTING_TYPE, 'Expiry Date should be greater than or equal to Grant Registration Date.' AS 'ERR_MESSAGE'
		FROM 
			@SOPSsUI_GET_GRNAT_EXPIRY_DETAILS AS SGGED
			INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = SGGED.GRANT_OPTION_ID
			LEFT OUTER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GOP.GrantRegistrationId
		WHERE 
			(CONVERT(DATE,GR.GrantDate)) >= (CONVERT(DATE,SGGED.GRANT_EXPIRY_DATE))
	)  #TEMP

	SELECT GRANT_OPTION_ID + ', ' + GRANT_LEG_ID AS 'IDs', 'Invalid Vesting type in Excel.' AS 'Message' FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS WHERE (UPPER(GRANT_VESTING_TYPE) NOT IN ('T','P'))
	UNION ALL
	SELECT GRANT_OPTION_ID + ', ' + GRANT_LEG_ID AS 'IDs', 'Please provide vesting type.' AS 'Message' FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS WHERE (GRANT_VESTING_TYPE IS NULL)
	UNION ALL
	SELECT GRANT_OPTION_ID + ', ' + GRANT_LEG_ID AS 'IDs', 'Please provide Grant Leg Id.' AS 'Message' FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS WHERE (GRANT_LEG_ID IS NULL)
	UNION ALL
	SELECT GRANT_OPTION_ID + ', ' + GRANT_LEG_ID AS 'IDs', 'Please provide Grant Option Id.' AS 'Message' FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS WHERE (GRANT_OPTION_ID IS NULL)
	UNION ALL
	SELECT GRANT_OPTION_ID + ', ' + GRANT_LEG_ID AS 'IDs', 'Please provide Expiry Date.' AS 'Message' FROM @SOPSsUI_GET_GRNAT_EXPIRY_DETAILS WHERE (GRANT_EXPIRY_DATE IS NULL)
	UNION ALL
	SELECT TCC_GRANT_OPTION_ID + ', ' + TCC_GRANT_LEG_ID AS 'IDs',  'Grant Option id, Grant leg Id and vesting type combination not match.' AS 'Message' FROM #TABLE_CHECK_COMBINAION
	UNION ALL
	SELECT TCC_GRANT_OPTION_ID + ', ' + TCC_GRANT_LEG_ID AS 'IDs',  TCC_ERROR_MESSAGE AS 'Message' FROM #TABLE_EXPIRY_DATE_VALIDATION

	SET NOCOUNT OFF;				
END
GO
