/****** Object:  StoredProcedure [dbo].[PROC_GrantAccMassUpload]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GrantAccMassUpload]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GrantAccMassUpload]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GrantAccMassUpload] 
	@EmployeeId					AS VARCHAR(MAX),
	@SchemeName					AS VARCHAR(MAX),
	@GrantDate					AS VARCHAR(MAX),
	@LetterAcceptanceStatus		AS VARCHAR(MAX),
	@LetterAcceptanceDate		AS VARCHAR(MAX),
	@EmployeeName				AS NVARCHAR(MAX),
	@LetterCode					AS VARCHAR(MAX) = NULL,
	@NoOfVests					AS NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @WHERE_CLAUSE AS VARCHAR(MAX), @SQL AS VARCHAR(MAX),@STATUS  AS VARCHAR(5)
	
	SET @LetterAcceptanceStatus = REPLACE(@LetterAcceptanceStatus, 'Accepted', 'A')
	SET @LetterAcceptanceStatus = REPLACE(@LetterAcceptanceStatus, 'Pending', 'P')
	SET @LetterAcceptanceStatus = REPLACE(@LetterAcceptanceStatus, 'Rejected', 'R')
	SET @LetterAcceptanceStatus = REPLACE(@LetterAcceptanceStatus, 'Expired', 'PExpired')
	
	SET @WHERE_CLAUSE = ' WHERE (GAMU.LetterAcceptanceStatus IS NULL OR GAMU.LetterAcceptanceStatus IN (SELECT Param FROM fn_MVParam('''+@LetterAcceptanceStatus+''','','')))'
		 
	SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.NoOfVests IN (SELECT Param FROM fn_MVParam('''+@NoOfVests+''','',''))'
	SET @WHERE_CLAUSE = REPLACE(@WHERE_CLAUSE,'PExpired','P')
		
	IF (@LetterCode <> '' AND @LetterCode IS NOT NULL)
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.LetterCode LIKE ' + '''%' + @LetterCode + '%'''
	END
	 
	IF (@LetterAcceptanceDate <> '---All DATES---')
	BEGIN
		IF (@LetterAcceptanceDate = '---Pending for Action---')
			BEGIN
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.LetterAcceptanceDate IS NULL'
			END
		ELSE
			BEGIN
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.LetterAcceptanceDate = ' + char(39) + @LetterAcceptanceDate + char(39)
			END
	END
		
	IF (@EmployeeId <> '---ALL EMPLOYEES---')
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.EmployeeID = ' + char(39) + @EmployeeId + char(39)
	END
	
	IF (@EmployeeName <> '---ALL EMPLOYEES---')
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND EM.EmployeeName = ' + char(39) + @EmployeeName + char(39)
	END
	
	IF (@EmployeeName <> '---ALL EMPLOYEES---')
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND EM.EmployeeName = ' + char(39) + @EmployeeName + char(39)
	END
	
	IF (@SchemeName <> '---ALL SCHEME---')
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.SchemeName = ' + char(39) + @SchemeName + char(39)
	END
	
	IF (@GrantDate <> '---ALL GrantDates---')
	BEGIN
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND GAMU.GrantDate = ' + char(39) + @GrantDate + char(39)
	END

	print @LetterAcceptanceStatus
	
	IF (@LetterAcceptanceStatus LIKE('%P%') AND @LetterAcceptanceStatus NOT LIKE('%PExpired%'))
	BEGIN	
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND (CONVERT(DATE, GETDATE()) < CONVERT(DATE, GAMU.LastAcceptanceDate))'		
	END

	IF (@LetterAcceptanceStatus LIKE('%PExpired%'))
	BEGIN	

	IF ((@LetterAcceptanceStatus ='PExpired') OR (@LetterAcceptanceStatus ='PExpired,A,R'))
	BEGIN		
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate))'	
	END
	IF ((@LetterAcceptanceStatus ='A,PExpired,R') OR (@LetterAcceptanceStatus ='PExpired,R'))
    BEGIN
	   SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND ((GAMU.LetterAcceptanceStatus =''A'') AND (LetterAcceptanceDate IS NOT NULL) OR (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate))) OR GAMU.LetterAcceptanceStatus =''R'''	
	END

	IF ((@LetterAcceptanceStatus IN('PExpired,A') OR (@LetterAcceptanceStatus IN('A,PExpired'))))
	BEGIN	
		SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND ((GAMU.LetterAcceptanceStatus =''A'') AND (LetterAcceptanceDate IS NOT NULL) OR (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate)))'	
	END
	
	END
		
	PRINT @WHERE_CLAUSE
		
	SET @SQL=N'SELECT
				DENSE_RANK() OVER (ORDER BY GAMU.EmployeeID,GAMU.LetterCode ) AS SRNO,
				GAMU.EmployeeID, EM.EmployeeName, GAMU.SchemeName, GAMU.LetterCode, GAMU.GrantDate, GAMU.GrantType, GAMU.NoOfOptions AS TOTAL_OPTIONS, GAMU.Currency, GAMU.ExercisePrice, 
				GAMU.FirstVestDate, GAMU.NoOfVests, GAMU.VestingFrequency, GAMU.VestingPercentage, GAMU.Adjustment, GAMU.CompanyName, GAMU.CompanyAddress, 
				GAMU.LotNumber, GAMU.LastAcceptanceDate, 
				CASE 
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate)) THEN ''Expired''
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = ''4'' THEN ''Pending for Acceptance''
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> ''4'' THEN ''Pending for Acceptance/Rejection''				
				WHEN GAMU.LetterAcceptanceStatus = ''R'' THEN ''Rejected''
				WHEN GAMU.LetterAcceptanceStatus = ''A'' THEN ''Accepted'' 
				ELSE ''No Action Taken'' END LetterAcceptanceStatus, GAMU.LetterAcceptanceDate,
				CASE WHEN GAMU.LetterAcceptanceDate IS NULL THEN 
					''''
				ELSE
					(SELECT TOP 1 UL.IP_ADDRESS from UserLoginHistory UL WHERE UL.ORGANIZATION = ''OGA'' AND UL.UserId = EM.LoginID AND (CONVERT(DATETIME, UL.LoginDate) <= CONVERT(DATETIME, GAMU.LetterAcceptanceDate) AND CONVERT(DATETIME, ISNULL(UL.LogOutDate, GAMU.LetterAcceptanceDate)) >= CONVERT(DATETIME, GAMU.LetterAcceptanceDate)) ORDER BY UL.Idt DESC) 
				END
				AS IP_ADDRESS, 	
				GAMU.GrantLetterName, GAMU.GrantLetterPath, 
				GAMU.MailSentStatus, GAMU.MailSentDate, GAMU.CreatedBy, GAMU.CreatedOn, GAMU.LastUpdatedBy, GAMU.LastUpdatedOn, GAMUD.VestPeriod, 
				GAMUD.VestingDate, GAMUD.NoOfOptions,
				CASE WHEN GAMU.IsGlGenerated = 1 THEN ''Yes'' ELSE ''No'' END IsGlGenerated
			FROM GrantAccMassUpload AS GAMU 
			INNER JOIN GrantAccMassUploadDet AS GAMUD ON GAMU.GAMUID = GAMUD.GAMUID 
			INNER JOIN EmployeeMaster AS EM ON GAMU.EmployeeID = EM.EmployeeID
			'
			+ @WHERE_CLAUSE 
			
			EXECUTE (@SQL);
	
	SET NOCOUNT OFF;
    
END
GO
