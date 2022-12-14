/****** Object:  StoredProcedure [dbo].[PROC_GetGrantAccLettersOfEmployeeStatusWise]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetGrantAccLettersOfEmployeeStatusWise]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGrantAccLettersOfEmployeeStatusWise]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetGrantAccLettersOfEmployeeStatusWise]
(
	@EmployeeID VARCHAR(15),
	@RetVal VARCHAR(200)=null OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @STATUS  AS VARCHAR(5)
	SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS
	SET @EmployeeID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)	

	DECLARE @SITEURL VARCHAR(MAX)
	SET @SITEURL=(SELECT SITEURL FROM CompanyMaster)

	SELECT 
		GAMUID, SchemeName, ExercisePrice,LetterCode, replace(convert(NVARCHAR, GrantDate, 106), ' ', '-') as GrantDate,  FORMAT(LetterAcceptanceDate, 'dd-MMM-yyyy hh:mm tt', 'en-US') AS LetterAcceptanceDate, 
		replace(convert(NVARCHAR, LastAcceptanceDate, 106), ' ', '-') as LastAcceptanceDate,
		CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'Expired' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'Pending for Acceptance'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'Pending for Acceptance / Rejection'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'Accepted' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'Rejected'			
		    ELSE 'Pending for Acceptance / Rejection' 
		END LetterAcceptanceStatus,			
			CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) THEN 1 ELSE 0 END AS ShowActionLinks,
		CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) AS ActionAfter,
		CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'E' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'PA'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'PAR'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'A' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'R'			
		    ELSE 'NULL' 
		END LetterAcceptanceStatusFlag,
		@STATUS AS OGA_Configurations_Status,
		@SITEURL AS SITEURL
	FROM GrantAccMassUpload
	WHERE EmployeeID = @EmployeeID
	AND MailSentStatus = 1
	AND MailSentDate IS NOT NULL
	ORDER BY GrantDate DESC 
END

GO
