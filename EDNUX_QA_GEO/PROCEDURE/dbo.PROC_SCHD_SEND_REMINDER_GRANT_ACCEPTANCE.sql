/****** Object:  StoredProcedure [dbo].[PROC_SCHD_SEND_REMINDER_GRANT_ACCEPTANCE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SCHD_SEND_REMINDER_GRANT_ACCEPTANCE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SCHD_SEND_REMINDER_GRANT_ACCEPTANCE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SCHD_SEND_REMINDER_GRANT_ACCEPTANCE]
AS
BEGIN
	
	DECLARE @IsReminderMail BIT,
			@DaysBefore VARCHAR(5),
			@IsTillLastDate BIT,
			@FROM VARCHAR(50),
			@MaxMsgID BIGINT,
			@MailSubject	NVARCHAR(500),
			@MailBody		NVARCHAR(MAX),	
			@Str VARCHAR(MAX),
			@SqlString VARCHAR(MAX),
			@WhereClause VARCHAR(1000)
	---------------------------------------------------------
	-- GET CONFIGURATIONS FOR ONLINE GRANT ACCEPTANCE
	---------------------------------------------------------
	SELECT @IsReminderMail = IsReminderMail, @DaysBefore = DaysBefore, @IsTillLastDate = IsTillLastDate FROM OGA_CONFIGURATIONS
	
	IF @IsReminderMail = 1
	BEGIN
		---------------------------------------------------------
		-- GET COMPANY EMAIL ID
		---------------------------------------------------------
		SELECT @FROM = CompanyEmailID FROM CompanyParameters


		-----------------------------------------------------------------------------
		-- GET VESTING MAIL ALERT SET BY EMPLOYEE DETAILS FROM MailMessages TABLE
		-----------------------------------------------------------------------------
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages  WHERE UPPER(Formats)='REMINDERFORONLINEGRANTACCEPTANCE'

		---------------------------------------------------------
		-- GET TEMP TABLE TO STORE THE RECORDS TO BE INSERTED IN MAIL SPOOL
		---------------------------------------------------------	
		CREATE TABLE #TEMP_DATA
			(
				Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
				[FROM] VARCHAR(50),
				[TO] VARCHAR(50),
				SUBJECT NVARCHAR(200),
				DESCRIPTION NVARCHAR(MAX)		
			)
		
		---------------------------------------------------------
		-- GET THE MAX MESSAGE ID FROM MAIL SPOOL AND SET THE 
		-- IDENTITY VALUE TO THAT NUMBER IN TEMP TABLE
		---------------------------------------------------------	
		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		DBCC CHECKIDENT(#TEMP_DATA, RESEED, @MaxMsgId) 
		
		SET @Str = 'INSERT INTO #TEMP_DATA([FROM], [TO], Subject, Description)
					SELECT ' + CHAR(39) + @FROM + CHAR(39) +', 
					EMP.EmployeeEmail, 
					REPLACE(' + CHAR(39) + @MailSubject + CHAR(39) + ', ''{0}'', CONVERT(NVARCHAR(11),GMU.GrantDate,113)), 
					REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(' + CHAR(39) + @MailBody + CHAR(39) + ', ''{0}'', CONVERT(NVARCHAR(11),GMU.GrantDate,113)),
												''{1}'', EMP.EmployeeName) ,
												''{2}'', GMU.SchemeName), 
												''{3}'', CONVERT(NVARCHAR(11),GMU.LastAcceptanceDate,113)),
												''{4}'',' + CHAR(39) + @FROM + CHAR(39) + ')
					FROM GrantAccMassUpload GMU INNER JOIN EmployeeMaster EMP ON GMU.EmployeeID = EMP.EmployeeID
					WHERE LetterAcceptanceStatus = ''P''
					AND MailSentStatus = 1 
					AND CONVERT(DATE, LastAcceptanceDate) >= CONVERT(DATE, GETDATE()) '

		IF @IsTillLastDate = 1
		BEGIN
			SET @WhereClause = ' AND DATEDIFF(DAY, GETDATE(), LastAcceptanceDate) <= CONVERT(INT, ' + @DaysBefore + ')'
		END
		ELSE
		BEGIN
			SET @WhereClause = ' AND DATEDIFF(DAY, GETDATE(), LastAcceptanceDate) = CONVERT(INT, ' + @DaysBefore + ')'
		END
		
		SET @SqlString = @Str + @WhereClause
		EXECUTE (@SqlString)
		
		INSERT INTO MailerDB..MailSpool (MessageID, [From] , [TO], Subject, Description)
		SELECT Message_ID, [FROM], [TO], SUBJECT, DESCRIPTION FROM #TEMP_DATA
	END
END

GO
