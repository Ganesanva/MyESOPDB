/****** Object:  StoredProcedure [dbo].[PROC_GetGrantLetterAcceptanceList]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetGrantLetterAcceptanceList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGrantLetterAcceptanceList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetGrantLetterAcceptanceList]	
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @STATUS  AS VARCHAR(5)
	SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS 		
	SELECT 
		CONVERT(BIT, 0) AS IS_SELECTED,
		EmployeeID, GAMUID, SchemeName, LetterCode, REPLACE(CONVERT(VARCHAR(11), GRANTDATE,106),' ','/') as GrantDate, LetterAcceptanceDate, LastAcceptanceDate,
		CASE 
		    WHEN LetterAcceptanceStatus = 'P' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, LastAcceptanceDate)) THEN 'Expired'
			WHEN LetterAcceptanceStatus = 'P' AND @STATUS = '4' THEN 'Pending for Acceptance'
			WHEN LetterAcceptanceStatus = 'P' AND @STATUS <> '4' THEN 'Pending for Acceptance/Rejection' 
			WHEN LetterAcceptanceStatus = 'A' THEN 'Accepted' 
			WHEN LetterAcceptanceStatus = 'R' THEN 'Rejected' 
			ELSE 'No Action Taken' 
		END LetterAcceptanceStatus
	FROM  GrantAccMassUpload	
    WHERE IsGlGenerated = 1
END
GO
