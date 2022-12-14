/****** Object:  StoredProcedure [dbo].[PROC_EmpWithGrantDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EmpWithGrantDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EmpWithGrantDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EmpWithGrantDetails]
	@ACTION					NVARCHAR(50),
	@RESIDENTIALSTATUS		NVARCHAR(50) = '',
	@EMPLOYEEDESIGNATION	NVARCHAR(50) = '',
	@GRADE					NVARCHAR(50) = '',
	@DEPARTMENT				NVARCHAR(50) = '',
	@SBU					NVARCHAR(50) = '',
	@GRANTTYPE				NVARCHAR(50) = '',
	@GRANTDATE				NVARCHAR(50) = '',
	@LOTNUMBER				NVARCHAR(500) = '',
	@ISGLGENERATED			NVARCHAR(50) = '',
	@EMPLOYEEID				NVARCHAR(50) = '',
	@LetterAcceptanceStatus NVARCHAR(50) = '',
	@GRANTMAILSENTSTATUS	NVARCHAR(50) = ''
	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@ACTION	= 'FILTERS')
	BEGIN
		SELECT DISTINCT
			ISNULL(RT.DESCRIPTION, '') AS RESIDENTIALSTATUS, 
			EM.EMPLOYEEDESIGNATION, 
			EM.GRADE, 
			EM.DEPARTMENT, 
			ISNULL(EM.SBU, '') SBU, 
			GAMU.GRANTTYPE,
			REPLACE(CONVERT(VARCHAR(11), GAMU.GRANTDATE,106),' ','/') AS GRANTDATE, 
			GAMU.LotNumber,
			CASE WHEN GAMU.IsGlGenerated = 1 THEN 'Yes' ELSE 'No' END IsGlGenerated,
			GAMU.EMPLOYEEID, 
			CASE 
			WHEN GAMU.LetterAcceptanceStatus = 'P' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate)) THEN 'Expired'
			WHEN GAMU.LetterAcceptanceStatus = 'P' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = '4' THEN 'Pending for Acceptance'
			WHEN GAMU.LetterAcceptanceStatus = 'P' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> '4' THEN 'Pending for Acceptance/Rejection'
			WHEN GAMU.LetterAcceptanceStatus = 'R' THEN 'Rejected' 
			WHEN GAMU.LetterAcceptanceStatus = 'A' THEN 'Accepted'		
			ELSE 'No Action Taken' END LetterAcceptanceStatus
					
		FROM GRANTACCMASSUPLOAD GAMU
			INNER JOIN EMPLOYEEMASTER EM ON EM.EMPLOYEEID = GAMU.EMPLOYEEID
			LEFT OUTER JOIN RESIDENTIALTYPE RT ON RT.ResidentialStatus = EM.RESIDENTIALSTATUS
			LEFT OUTER JOIN GENERATE_GRANT_LETTER GGL ON GGL.GAMUID = GAMU.GAMUID
	END
	
	ELSE IF (@ACTION	= 'GRID')
	BEGIN
		DECLARE @QUERY AS VARCHAR(MAX)
		DECLARE @WHERE_CLAUSE AS NVARCHAR(MAX)
		SET @WHERE_CLAUSE = ''
		--FOR RESIDENTIAL STATUS 
		IF @RESIDENTIALSTATUS <> '' 
		BEGIN
			SET @WHERE_CLAUSE = ' WHERE ISNULL(RT.DESCRIPTION, '''') = ' + CHAR(39) + @RESIDENTIALSTATUS + CHAR(39)
		END
		
		--FOR EMPLOYEE DESIGNATION
		IF @EMPLOYEEDESIGNATION <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' EM.EMPLOYEEDESIGNATION = ' + CHAR(39) + @EMPLOYEEDESIGNATION + CHAR(39)
		END
		
		--FOR GRADE
		IF @GRADE <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' EM.GRADE = ' + CHAR(39) + @GRADE + CHAR(39)
		END
		
		--FOR DEPARTMENT
		IF @DEPARTMENT <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' EM.DEPARTMENT = ' + CHAR(39) + @DEPARTMENT + CHAR(39)
		END
		
		--FOR SBU
		IF @SBU <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' ISNULL(EM.SBU, '''') = ' + CHAR(39) + @SBU + CHAR(39)
		END
				
		--FOR GRANT TYPE
		IF @GRANTTYPE <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' GAMU.GRANTTYPE = ' + CHAR(39) + @GRANTTYPE + CHAR(39)
		END
		
		--FOR GRANT DATE
		IF @GRANTDATE <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' REPLACE(CONVERT(VARCHAR(11), GAMU.GRANTDATE,106),'' '',''/'') = ' + CHAR(39) + @GRANTDATE + CHAR(39)
		END
		
		--FOR LOT NUMBER
		IF @LOTNUMBER <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' GAMU.LotNumber IN (' + @LOTNUMBER + ')'
		END
				
		--FOR IS GLGENERATED
		IF @ISGLGENERATED <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' CASE WHEN GAMU.IsGlGenerated = 1 THEN ''Yes'' ELSE ''No'' END = ' + CHAR(39) + @ISGLGENERATED + CHAR(39)
		END	
		
		--FOR EMPLOYEE ID
		IF @EMPLOYEEID <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' GAMU.EMPLOYEEID = ' + CHAR(39) + @EMPLOYEEID + CHAR(39)
		END	
		
		--FOR LetterAcceptanceStatus
		IF @LetterAcceptanceStatus <> '' 
		BEGIN
			IF (@WHERE_CLAUSE = '')
				SET @WHERE_CLAUSE = ' WHERE '
			ELSE
				SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' AND '
			
			SET @WHERE_CLAUSE = @WHERE_CLAUSE + ' CASE 
									WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate)) THEN ''Expired''
									WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = ''4'' THEN ''Pending for Acceptance''
									WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> ''4'' THEN ''Pending for Acceptance/Rejection''
									WHEN GAMU.LetterAcceptanceStatus = ''R'' THEN ''Rejected'' 
									WHEN GAMU.LetterAcceptanceStatus = ''A'' THEN ''Accepted''		
									ELSE ''No Action Taken'' END = ' + CHAR(39) + @LetterAcceptanceStatus + CHAR(39)
		END		
		
		--PRINT @WHERE_CLAUSE
		
		SET @QUERY = '
		SELECT * INTO #TEMP_GAMU FROM
		(
			SELECT 
				CONVERT(BIT, 0) AS IS_SELECTED,
				GAMU.EMPLOYEEID, EM.EMPLOYEENAME, EM.EMPLOYEEEMAIL, EM.EMPLOYEEDESIGNATION, GAMU.LETTERCODE, REPLACE(CONVERT(VARCHAR(11), GAMU.GRANTDATE,106),'' '',''/'') AS GRANTDATE, 
				EM.AccountNo, EM.ClientIDNumber, EM.Confirmn_Dt, EM.ConfStatus, EM.DateOfTermination,	EM.DematAccountType, EM.DepositoryIDNumber, EM.DepositoryName, EM.DepositoryParticipantNo,
				EM.DPRecord, EM.EmployeePhone, EM.Entity, EM.SecondaryEmailID, EM.Insider, EM.Location, EM.LoginID, EM.LWD, EM.PANNumber, 
				EM.ReasonForTermination, EM.tax_slab, EM.WardNumber,
				RT.DESCRIPTION AS RESIDENTIALSTATUS,  
				REPLACE(CONVERT(VARCHAR(11), EM.DATEOFJOINING,106),'' '',''/'') AS DATEOFJOINING, EM.GRADE, 
				EM.DEPARTMENT, ISNULL(EM.SBU, '''') SBU, GAMU.GRANTTYPE, GAMU.NOOFOPTIONS,
				GAMU.CURRENCY, GAMU.EXERCISEPRICE, REPLACE(CONVERT(VARCHAR(11), GAMU.FIRSTVESTDATE,106),'' '',''/'') AS FIRSTVESTDATE, 
				GAMU.NOOFVESTS, GAMU.VESTINGFREQUENCY, EM.EmployeeAddress,
				CM.CountryName AS CountryName,
				GAMU.SchemeName, GAMU.CompanyName, GAMU.CompanyAddress, 
				CASE 
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (CONVERT(DATE, GETDATE()) > CONVERT(DATE, GAMU.LastAcceptanceDate)) THEN ''Expired''
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) = ''4'' THEN ''Pending for Acceptance''
				WHEN GAMU.LetterAcceptanceStatus = ''P'' AND (SELECT ACSID FROM OGA_CONFIGURATIONS) <> ''4'' THEN ''Pending for Acceptance/Rejection''
				WHEN GAMU.LetterAcceptanceStatus = ''R'' THEN ''Rejected'' 
				WHEN GAMU.LetterAcceptanceStatus = ''A'' THEN ''Accepted''		
				ELSE ''No Action Taken'' END LetterAcceptanceStatus, 
				REPLACE(CONVERT(VARCHAR(11), GAMU.LetterAcceptanceDate ,106),'' '',''/'') AS LetterAcceptanceDate,
				REPLACE(CONVERT(VARCHAR(11), GAMU.LastAcceptanceDate ,106),'' '',''/'') AS LastAcceptanceDate,
				GAMU.VestingPercentage, GAMU.Adjustment, GAMU.LotNumber,
				CASE WHEN ('''+ @GRANTMAILSENTSTATUS +''' = ''0'' OR '''+ @GRANTMAILSENTSTATUS +'''=''NO'' ) THEN '''' ELSE  REPLACE(CONVERT(VARCHAR(11), GAMU.MailSentDate ,106),'' '',''/'') END AS MailSentDate,
				CASE WHEN GAMU.MailSentStatus = 1 THEN ''Yes'' ELSE ''No'' END MailSentStatus,
				CASE WHEN GAMU.IsGlGenerated = 1 THEN ''Yes'' ELSE ''No'' END IsGlGenerated,
				GAMU.Field1, GAMU.Field2, GAMU.Field3, GAMU.Field4, GAMU.Field5, GAMU.Field6, GAMU.Field7, GAMU.Field8, GAMU.Field9, GAMU.Field10, GAMU.VestingType,
				GAMU.LetterAcceptanceStatus as LetterAcceptanceStatusCode,
				GAMU.LastUpdatedOn,
				CASE WHEN GAMU.MailSentStatus = 1 THEN  ''Yes''  ELSE ''No'' END AS GRANTMAILSENTSTATUS,
				CASE WHEN (Select top 1 GGL.ISPROCESSD from GENERATE_GRANT_LETTER GGL Where GGL.GAMUID = GAMU.GAMUID order by GGL.GRANTLETTER_ID desc) = 0 THEN ''Pending'' 
				WHEN (Select top 1 GGL.ISPROCESSD from GENERATE_GRANT_LETTER GGL Where GGL.GAMUID = GAMU.GAMUID order by GGL.GRANTLETTER_ID desc) = 1 THEN ''Letter Generated Successfull'' 
				ELSE '' '' END ISPROCESSD
		
			FROM GRANTACCMASSUPLOAD GAMU
				INNER JOIN EMPLOYEEMASTER EM ON EM.EMPLOYEEID = GAMU.EMPLOYEEID
				LEFT OUTER JOIN RESIDENTIALTYPE RT ON RT.ResidentialStatus = EM.RESIDENTIALSTATUS
				LEFT OUTER JOIN CountryMaster CM ON CM.CountryAliasName = EM.CountryName '
			+ @WHERE_CLAUSE + '
		) OUT_PUT 
		ORDER BY LastUpdatedOn DESC
		
		IF NOT EXISTS(SELECT VSCID FROM VestingScheduleColumns WHERE FIELDS = ''@VestingType'')
		BEGIN				
			CREATE TABLE #TEMP_OGA_VESTING_PERCENTAGE
			(
				LETTER_CODE			NVARCHAR(500),
				VESTING_PERCENTAGE  NVARCHAR(1000)		
			)

			CREATE TABLE #TEMP_OGA_ADJUSTED_VESTING_PERCENTAGE
			(
				ADJ_LETTER_CODE			NVARCHAR(500),
				ADJ_VESTING_PERCENTAGE  NVARCHAR(1000)		
			)

			INSERT INTO #TEMP_OGA_VESTING_PERCENTAGE
			(
				LETTER_CODE, VESTING_PERCENTAGE
			)
			SELECT 
				GAMU.LetterCode, (VP.OptionTimePercentage + VP.OptionPerformancePercentage)
			FROM 
				GrantAccMassUpload AS GAMU 
				INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GAMU.LetterCode
				INNER JOIN VestingPeriod AS VP ON VP.GrantRegistrationId = GOP.GrantRegistrationId
				INNER JOIN #TEMP_GAMU AS TEMP ON TEMP.LetterCode = GOP.GrantOptionId

			INSERT INTO #TEMP_OGA_ADJUSTED_VESTING_PERCENTAGE
			(
				ADJ_LETTER_CODE, ADJ_VESTING_PERCENTAGE
			)
			SELECT 
				LETTER_CODE, 
				REPLACE(STUFF
				(
					(
						SELECT
							'', '' + CAST(VESTING_PERCENTAGE AS NVARCHAR(1000)) [text()]
						FROM 
							#TEMP_OGA_VESTING_PERCENTAGE 
						WHERE 
							LETTER_CODE = t.LETTER_CODE
						FOR XML PATH(''''), TYPE
					)
					.value(''.'',''NVARCHAR(MAX)''),1,2,''''
				),'' '', '''') AS VESTING_PERCENTAGE
			FROM 
				#TEMP_OGA_VESTING_PERCENTAGE t
			GROUP BY 
				LETTER_CODE
			
				
			UPDATE TEMP SET 
				TEMP.VestingPercentage = TOAVP.ADJ_VESTING_PERCENTAGE
			FROM 
				#TEMP_GAMU AS TEMP 
				LEFT OUTER JOIN #TEMP_OGA_ADJUSTED_VESTING_PERCENTAGE AS TOAVP ON TOAVP.ADJ_LETTER_CODE = TEMP.LetterCode
		
			DROP TABLE #TEMP_OGA_VESTING_PERCENTAGE
			DROP TABLE #TEMP_OGA_ADJUSTED_VESTING_PERCENTAGE			
		END
					
		SELECT * FROM #TEMP_GAMU 
			
		'
	--PRINT @QUERY

	EXECUTE (@QUERY)
	
	END	
	
	ELSE IF (@ACTION	= 'VEST_DETAILS')
	BEGIN

		SELECT 
			GAMUD.GAMUDETID, GAMUD.GAMUID, GAMUD.LetterCode, GAMUD.VestPeriod,
			CASE WHEN GAMUD.VestingType='T' THEN 'Time' ELSE 'Performance' END AS VestingType,
			REPLACE(CONVERT(VARCHAR(11), GAMUD.VestingDate ,106),' ','/') AS VestingDate, 
			GAMUD.NoOfOptions 
		FROM
			GrantAccMassUploadDet GAMUD WHERE GAMUD.LetterCode IN (@LOTNUMBER)	
	END
	ELSE IF (@ACTION = 'CHECK_VEST_TYPE')
	BEGIN
		SELECT FIELDS FROM VestingScheduleColumns WHERE FIELDS = '@VestingType'	
	END
	
	SET NOCOUNT OFF;
    
END
GO
