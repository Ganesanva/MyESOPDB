/****** Object:  StoredProcedure [dbo].[PROC_AUTO_EXERCISE_MAIL_CR]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_AUTO_EXERCISE_MAIL_CR]
GO
/****** Object:  StoredProcedure [dbo].[PROC_AUTO_EXERCISE_MAIL_CR]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_AUTO_EXERCISE_MAIL_CR] (@CompanyId VARCHAR(50) = NULL)

AS
BEGIN

	DECLARE @QUERY VARCHAR(MAX), @TodaysDate DATETIME, @BeforeAECDate DATETIME, @ReminderDate DATETIME,
			@MailSubject NVARCHAR(500), @MailBody NVARCHAR(MAX), @MaxMsgId BIGINT, @Exercise_On NVARCHAR(500),
			@Exercise_Days NVARCHAR(100), @COMPANY_EMAIL_ID NVARCHAR(100), @CC_TO NVARCHAR(100),
			@MailBodyHTMLTable NVARCHAR(MAX), @CrMailId VARCHAR(MAX), @CrName VARCHAR(MAX)

	SET @QUERY =
		(
			SELECT COUNT(SH.SchemeId) AS RecordCount FROM Scheme SH 
			INNER JOIN AUTO_EXERCISE_CONFIG AEC ON SH.SchemeId = AEC.SchemeId
            WHERE SH.IS_AUTO_EXERCISE_ALLOWED = 1  AND AEC.IS_MAIL_ENABLE = 1
        )
	
	IF(@QUERY > 0)
	BEGIN

		CREATE TABLE #TEMP_EMPLOYEE_DATA 
		(
			EmployeeId NVARCHAR(50), GrantApprovalId NVARCHAR(50), ID NVARCHAR(50), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(50), 
			VestingType NVARCHAR(10), SeparationCancellationDate DATETIME, SeparationPerformed NVARCHAR(50), GrantedOptions NUMERIC(18,0), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), 
			CancelledQuantity NUMERIC(18,0), SplitCancelledQuantity NUMERIC(18,0), BonusSplitCancelledQuantity NUMERIC(18,0), 
			ExercisedQuantity NUMERIC(18,0), SplitExercisedQuantity NUMERIC(18,0), BonusSplitExercisedQuantity NUMERIC(18,0), 
			ExercisableQuantity NUMERIC(18,0), LapsedQuantity NUMERIC(18,0), UnapprovedExerciseQuantity NUMERIC(18,0), FinalExpirayDate DATETIME,	
			ExpiryPerformed NVARCHAR(10), IsPerfBased NVARCHAR(10), DateOfTermination DATETIME, IsUserActive NVARCHAR(10), 
			ApprovalStatus NVARCHAR(10), [Status] NVARCHAR(10), CancelTransId NVARCHAR(50), CancelledId NUMERIC(18,0) IDENTITY (1, 1) NOT NULL,
			CancellationReasion NVARCHAR(200), CancellationDate DATETIME, SeparationCancellationQuantity NUMERIC(18,0),SchemeId VARCHAR(50),VestingDate DATETIME,EmailId VARCHAR(50),EmployeeName NVARCHAR(75)
		)
						
		CREATE TABLE #TEMP_SCHEME_DATA  
		(
		   SchemeId VARCHAR(50),ApprovalId varchar(20),ExercisePeriodStartsAfter VARCHAR(1),Mail_Before_Days varchar(50),Mail_Reminder_Days varchar(50),Exercise_on varchar(50),Exercise_Days varchar(50)
		)

		CREATE TABLE #TEMP_FILTERED_DATA 
		(
			SchemeId VARCHAR(50),ApprovalId varchar(20),VestingDate DATETIME,EmployeeId NVARCHAR(50),EmailId NVARCHAR(50),EmployeeName NVARCHAR(70),ExercisableQuantity NUMERIC(18,0), Later_date DATETIME ,MailBody NVARCHAR(MAX),GrantOptionId varchar(500),AutoExerciseDate DATETIME,M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL
		)

		CREATE TABLE #TEMP_FILTERED_MOVMENTDATA 
		(
			SchemeId VARCHAR(50),ApprovalId varchar(20),VestingDate DATETIME,EmployeeId NVARCHAR(50),EmailId NVARCHAR(50),EmployeeName NVARCHAR(70),ExercisableQuantity NUMERIC(18,0), Later_date DATETIME ,Mail_Before_Days varchar(50),Mail_Reminder_Days varchar(50),GrantOptionId varchar(500),M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL
		)

		CREATE TABLE #TEMP_CR_DATA
		(
			UserName NVARCHAR(50),EmailId NVARCHAR(50)
		)
					
		CREATE TABLE #TEMP_MAIL_MESSAGE
		(
			CRName VARCHAR(Max),M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL					
		)

		--INSERT DATA INTO TABLE
		INSERT INTO #TEMP_CR_DATA (UserName, EmailId)
		SELECT 
			UM.UserName, UM.EmailId FROM UserMaster UM
		INNER JOIN RoleMaster  Rm ON UM.RoleId = Rm.RoleId
		INNER JOIN UserType UT ON UT.UserTypeId = Rm.UserTypeId
		WHERE UM.IsUserActive = 'Y' AND UT.UserTypeId = 2

		INSERT INTO #TEMP_EMPLOYEE_DATA 
		(	
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeparationCancellationDate, SeparationPerformed, GrantedOptions, 
			GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
			SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
			ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status], SchemeId, VestingDate, EmailId, EmployeeName
		)
		SELECT EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, CONVERT(DATE,SeperationCancellationDate), SeparationPerformed, GrantedOptions, 
		GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, BonusSplitCancelledQuantity, ExercisedQuantity,
		SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate,	
		ExpiryPerformed, IsPerfBased, DateOfTermination, IsUserActive, ApprovalStatus, [Status], SchemeId, VestingDate, EmployeeEmail, EmployeeName
		FROM [VW_GrantLegDetails] 
			
		INSERT INTO #TEMP_SCHEME_DATA
		(
		   SchemeId ,ApprovalId ,ExercisePeriodStartsAfter,Mail_Before_Days ,Mail_Reminder_Days,Exercise_on,Exercise_Days
		)
		SELECT 
			SH.SchemeId, SH.ApprovalId, SH.ExercisePeriodStartsAfter, AEC.MAIL_BEFORE_DAYS, AEC.MAIL_REMINDER_DAYS, AEC.EXERCISE_ON, AEC.EXERCISE_AFTER_DAYS 
		FROM Scheme SH 
		INNER JOIN AUTO_EXERCISE_CONFIG AEC ON SH.SchemeId = AEC.SchemeId
		WHERE SH.IS_AUTO_EXERCISE_ALLOWED = 1  AND AEC.IS_MAIL_ENABLE = 1

		SELECT @COMPANY_EMAIL_ID = CompanyEmailID FROM CompanyParameters
				
		SELECT 
			@Exercise_On = AEC.EXERCISE_ON, @Exercise_Days = AEC.EXERCISE_AFTER_DAYS 
		FROM Scheme SH 
		INNER JOIN AUTO_EXERCISE_CONFIG AEC ON SH.SchemeId = AEC.SchemeId 
		WHERE 
			SH.IS_AUTO_EXERCISE_ALLOWED = 1  AND AEC.IS_MAIL_ENABLE = 1 

		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)

		BEGIN
			DBCC CHECKIDENT(#TEMP_FILTERED_DATA, RESEED, @MaxMsgId)
		END

		BEGIN
			DBCC CHECKIDENT(#TEMP_MAIL_MESSAGE, RESEED, @MaxMsgId)
		END
			
		/* FOR BEFORE AUTO EXERCISE DATE MAIL ALERT */
		BEGIN
			INSERT INTO #TEMP_FILTERED_DATA
			SELECT 
				TSD.SchemeId, TSD.ApprovalId, VestingDate, TED.EmployeeId, TED.EmailId, TED.EmployeeName, TED.ExercisableQuantity, GETDATE(), '', TED.GrantOptionId, DATEADD(DAY, DATEDIFF(DAY,CONVERT(INT,TSD.Mail_Before_Days), CONVERT(DATE,TED.VestingDate)),0)	  
			FROM #TEMP_EMPLOYEE_DATA TED 
			INNER JOIN #TEMP_SCHEME_DATA TSD ON TED.SchemeId = TSD.SchemeId
			WHERE  TSD.Exercise_on  = UPPER('RDOVESTING') AND TED.VestingDate = (SELECT(CONVERT(DATE,DATEADD(D,CONVERT(INT, TSD.Mail_Before_Days),GETDATE()))))	
		END
		 
		BEGIN
			INSERT INTO #TEMP_FILTERED_DATA
			SELECT 
				TSD.SchemeId, TSD.ApprovalId, VestingDate, TED.EmployeeId, TED.EmailId, TED.EmployeeName, TED.ExercisableQuantity, GETDATE(), '', TED.GrantOptionId, DATEADD(DAY, DATEDIFF(DAY,CONVERT(INT,TSD.Mail_Before_Days), CONVERT(DATE,DATEADD(D,CONVERT(INT, TSD.Exercise_Days),TED.VestingDate ))),0)	  
			FROM #TEMP_EMPLOYEE_DATA TED 
			INNER JOIN #TEMP_SCHEME_DATA TSD ON TED.SchemeId = TSD.SchemeId
			WHERE CONVERT(DATE,DATEADD(D,CONVERT(INT, TSD.Exercise_Days),TED.VestingDate)) = (SELECT(CONVERT(DATE,DATEADD(D,CONVERT(INT, TSD.Mail_Before_Days),GETDATE()))))
			AND TSD.Exercise_on  = UPPER('RDODAYS')
		END

		BEGIN
			INSERT INTO #TEMP_FILTERED_MOVMENTDATA
			SELECT TSD.SchemeId, TSD.ApprovalId,VestingDate, TED.EmployeeId, TED.EmailId, TED.EmployeeName, TED.ExercisableQuantity,
			CASE  
				WHEN( (CONVERT(date,ATFTM.[From Date of Movement] )> CONVERT(date, TED.VestingDate))) THEN 
					TED.VestingDate 
				ELSE
					ATFTM.[From Date of Movement] 
				END AS Later_date,TSD.Mail_Before_Days, TSD.Mail_Reminder_Days, TED.GrantOptionId
			FROM #TEMP_EMPLOYEE_DATA AS TED 
			INNER JOIN #TEMP_SCHEME_DATA AS TSD ON TED.SchemeId = TSD.SchemeId
			INNER JOIN AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD AS ATFTM ON TED.EmployeeId = ATFTM.EmployeeId
			WHERE TSD.Exercise_on  = UPPER('RDOMOVMENTDATE')
		 
	  		INSERT INTO #TEMP_FILTERED_DATA
				SELECT SchemeId, ApprovalId, VestingDate, EmployeeId, EmailId, EmployeeName, ExercisableQuantity, Later_date, '', GrantOptionId, Later_date
			FROM #TEMP_FILTERED_MOVMENTDATA
			WHERE CONVERT(DATE, Later_date) = (SELECT(CONVERT(DATE,DATEADD(D,CONVERT(INT, Mail_Before_Days),GETDATE()))))	  
		END                   

		SET @MailSubject = '' 			
		SET @MailBody = ''

		/* FOR AUTO EXECRCISE MAIL ALERT */
		IF((SELECT COUNT(*) AS ROW_COUNT FROM #TEMP_FILTERED_DATA) > 0)	
		BEGIN
			SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'AUTOEXERCISEMAILALERTTOCR'

			SET @CrMailId = ''
			SET @CrName = ''
			SELECT @CrMailId = @CrMailId + EmailId + ', ' FROM #TEMP_CR_DATA
			SELECT @CrName = @CrName + UserName + ', ' FROM #TEMP_CR_DATA
			SELECT @CrName = (SELECT SUBSTRING(@CrName, 1, (LEN(@CrName)-1)))
		
			SET @MailBodyHTMLTable =
				N'<table style="width: 50%; border:1; font-family: arial; font-size: 12px; line-height: 20px; border-collapse: collapse;" cellpadding="4" cellspaing="0">' +
				N'<tr><th align="left">Employee Id</th>
				<th align="left">Employee Name</th>
				<th align="left">Scheme Name</th>
				<th align="left">Grant Option Id</th>
				<th align="left">Quintity</th>
				<th align="left">Auto Exercise Date</th>
				</tr>' +
				CAST (
				(	SELECT 
						td  = CAST(EmployeeId AS VARCHAR(100)),'', td = EmployeeName, '', td = SchemeId,'', td = GrantOptionId,'',td = ExercisableQuantity,'' ,td = CONVERT(date, VestingDate), ''
					FROM #TEMP_FILTERED_DATA
					ORDER BY SchemeId
					FOR XML PATH('tr'), TYPE
				) AS NVARCHAR(MAX) ) +
				N'</table>'
               
                DECLARE @AUTOEXERCISEDATE DATETIME, @SCHEMEID varchar(500)

                SET @AUTOEXERCISEDATE = (SELECT TOP(1) VestingDate	FROM #TEMP_FILTERED_DATA)
                SET @SCHEMEID = (SELECT TOP(1) SchemeId	FROM #TEMP_FILTERED_DATA) 
				
				INSERT INTO #TEMP_MAIL_MESSAGE (CRName)
				SELECT @CrName
         
				INSERT INTO [MailerDB].[dbo].[MailSpool]
				([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
				SELECT @MaxMsgId, @COMPANY_EMAIL_ID, @CrMailId, REPLACE(REPLACE(@MailSubject,'{0}',@SCHEMEID),'{1}',CONVERT(date, @AUTOEXERCISEDATE)), REPLACE(REPLACE(REPLACE(REPLACE(@MailBody,'{0}',REPLACE(@CrName,',','/')),'{2}',@MailBodyHTMLTable),'{3}',CONVERT(date, @AUTOEXERCISEDATE)),'{4}',@COMPANY_EMAIL_ID), NULL, NULL, NULL, NULL, NULL, @CC_TO, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() 
				WHERE (LEN(@MailSubject)>0) AND (LEN(@CrMailId)>0) AND (LEN(@COMPANY_EMAIL_ID) > 0)
				
				SELECT * FROM #TEMP_MAIL_MESSAGE
				
		END	
			
		DROP TABLE #TEMP_EMPLOYEE_DATA
		DROP TABLE #TEMP_SCHEME_DATA
		DROP TABLE #TEMP_FILTERED_DATA
		DROP TABLE #TEMP_FILTERED_MOVMENTDATA
		DROP TABLE #TEMP_CR_DATA

	END

END
GO
