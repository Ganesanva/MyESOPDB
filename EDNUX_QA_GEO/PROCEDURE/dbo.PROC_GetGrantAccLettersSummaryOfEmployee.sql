/****** Object:  StoredProcedure [dbo].[PROC_GetGrantAccLettersSummaryOfEmployee]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetGrantAccLettersSummaryOfEmployee]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGrantAccLettersSummaryOfEmployee]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetGrantAccLettersSummaryOfEmployee] 
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


	CREATE TABLE #Temp
	(
		GrantStatus nvarchar(100),
	)
	INSERT INTO #Temp	
		SELECT 
		CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R')
		AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN  'Expired' 
		ELSE
		CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN  'Pending for Acceptance' 
		ELSE
		CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN   'Pending for Acceptance / Rejection'
		ELSE
		CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN  'Accepted' 
		ELSE
		CASE WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN   'Rejected'  END END END END END  AS GrantStatus
		FROM GrantAccMassUpload
	WHERE EmployeeID = @EmployeeID
	AND MailSentStatus = 1
	AND MailSentDate IS NOT NULL
	
	SELECT count(GrantStatus) Summary,GrantStatus from #Temp Group by GrantStatus

END
GO
