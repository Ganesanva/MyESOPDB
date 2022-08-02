DROP PROCEDURE IF EXISTS [dbo].PROC_GetGrantAccLettersOfEmployee
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGrantAccLettersOfEmployee]    Script Date: 18-07-2022 15:02:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GetGrantAccLettersOfEmployee]
(
	@EmployeeID VARCHAR(15),
	@RetVal VARCHAR(200)=null OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @STATUS  AS VARCHAR(5)
	SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS

	DECLARE @Is_GrantLetterBeforeAcc  AS VARCHAR(5)
	DECLARE @Is_GenGrantLetterPostAcc  AS VARCHAR(5)
	SELECT @Is_GrantLetterBeforeAcc = Is_GrantLetterBeforeAcc ,@Is_GenGrantLetterPostAcc = Is_GenGrantLetterPostAcc FROM OGACondGrantViewSettings


	SET @EmployeeID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)	

	DECLARE @SITEURL VARCHAR(MAX)
	SET @SITEURL=(SELECT SITEURL FROM CompanyMaster)
	
	DECLARE @DEPOSITORYNAME VARCHAR(10)	
	SET @DEPOSITORYNAME=(SELECT TOP 1 CASE
			WHEN DepositoryName='N' THEN 'NSDL'
			WHEN DepositoryName='C' THEN 'CDSL' 		
		    ELSE '' 
		END DepositoryName FROM Employee_UserDematDetails)
	
	SELECT 
		GAMUID, SchemeName, ExercisePrice,NoOfOptions, LetterCode,replace(convert(NVARCHAR, GrantDate, 106), ' ', '-')  as GrantDate,  FORMAT(LetterAcceptanceDate, 'dd-MMM-yyyy hh:mm tt', 'en-US') AS LetterAcceptanceDate, 
		replace(convert(NVARCHAR, LastAcceptanceDate, 106), ' ', '-') as LastAcceptanceDate,
		CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R')  AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'Expired' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '2' THEN 'Pending for Rejection'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'Pending for Acceptance'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'Pending for Acceptance / Rejection'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'Accepted' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'Rejected'			
		    ELSE 'Pending for Acceptance / Rejection' 
		END LetterAcceptanceStatus,			
			CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) THEN 1 ELSE 0 END AS ShowActionLinks,
		CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) AS ActionAfter,
		CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R')  AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'E' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '2' THEN 'PR'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'PA'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'PAR'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'A' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'R'			
		    ELSE 'NULL' 
		END LetterAcceptanceStatusFlag,
		@STATUS AS OGA_Configurations_Status,
		@SITEURL AS SITEURL,
		@DEPOSITORYNAME AS DepositoryName,
		CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'a' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '2' THEN 'd'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'd'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'd'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'c' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'b'			
		    ELSE 'NULL' 
		END LetterAcceptanceStatusFlagorderbyonly,
		CASE
			WHEN @Is_GrantLetterBeforeAcc = '1'  THEN '1' 
			ELSE  CASE WHEN @Is_GenGrantLetterPostAcc = '1' THEN	
			CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A'  THEN	'1'	
		    ELSE '0' end end 
		END ViewLetterHideShow
	FROM GrantAccMassUpload 
	WHERE GrantAccMassUpload.EmployeeID = @EmployeeID
	AND MailSentStatus = 1
	AND MailSentDate IS NOT NULL
	ORDER BY LetterAcceptanceStatusFlagorderbyonly DESC ,cast(GrantDate  as date) DESC
END

GO


