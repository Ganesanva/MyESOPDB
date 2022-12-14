/****** Object:  StoredProcedure [dbo].[PROC_MAIL_EMP_SEL_PAY_PRE_VESTING]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_MAIL_EMP_SEL_PAY_PRE_VESTING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_MAIL_EMP_SEL_PAY_PRE_VESTING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_MAIL_EMP_SEL_PAY_PRE_VESTING] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
		
	DECLARE @MailSubject NVARCHAR(500), @MailBody NVARCHAR(MAX), @MaxMsgId BIGINT, @COMPANY_EMAIL_ID VARCHAR(200)
	
	SELECT	
		@COMPANY_EMAIL_ID = CompanyEmailID
	FROM 
		CompanyParameters
	
	---------------------------
	-- CREATE TEMP TABLES
	---------------------------
	
	BEGIN
	 
		CREATE TABLE #EMP_DATA_BEFOR_VESTING_AND_REMINDER
		(
			ID NVARCHAR(100), SchemeId NVARCHAR(500), SchemeTitle NVARCHAR(500), GrantOptionId NVARCHAR(500), GrantLegId NVARCHAR(2), 
			VestingType NVARCHAR(500), FinalVestingDate NVARCHAR(500), BEFORE_VESTING_DAYS NVARCHAR(10), REMINDER_MAIL_DAYS NVARCHAR(10),
			EmployeeID NVARCHAR(500), EmployeeName NVARCHAR(500), EmployeeEmail NVARCHAR(500), ALERT_TYPE NVARCHAR(500)			
		)
			
		CREATE TABLE #EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL
		(
			M_Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			M_EmployeeID NVARCHAR(100), M_EmployeeName NVARCHAR(200), M_EmployeeEmail NVARCHAR(200), 
			M_MailSubject VARCHAR(200), M_MailBody VARCHAR(MAX)
		)		
	END
	
	INSERT INTO #EMP_DATA_BEFOR_VESTING_AND_REMINDER
	(
		ID, SchemeId, SchemeTitle, GrantOptionId, GrantLegId, VestingType, FinalVestingDate, BEFORE_VESTING_DAYS, REMINDER_MAIL_DAYS,
		EmployeeID, EmployeeName, EmployeeEmail, ALERT_TYPE					
	)
	SELECT 
		ID, SchemeId, SchemeTitle, GrantOptionId, GrantLegId, VestingType, REPLACE(CONVERT(VARCHAR(11), FinalVestingDate, 106), ' ', '/') AS FinalVestingDate,
		BEFORE_VESTING_DAYS, REMINDER_MAIL_DAYS, EmployeeID, EmployeeName, EmployeeEmail, ALERT_TYPE
		
	FROM
	(
		/* SEND MAIL TO EMPLOYEE FOR SELECTION OF PAYMENT MODE PRE VESTING BEFORE VESTING DAYS */
	
		SELECT 
			GL.ID, SC.SchemeId, SC.SchemeTitle,  GL.GrantOptionId, GL.GrantLegId, GL.VestingType, GL.FinalVestingDate,
			AEPC.BEFORE_VESTING_DAYS, AEPC.REMINDER_MAIL_DAYS, EM.EmployeeID, EM.EmployeeName, EM.EmployeeEmail,
			'BEFORE VESTING DAYS' AS ALERT_TYPE	
		FROM 
			Scheme AS SC
			INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = SC.SchemeId
			INNER JOIN GrantLeg AS GL ON GL.SchemeId = SC.SchemeId
			INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
			INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
			LEFT OUTER JOIN EmpPrePaySelection AS EPP ON EPP.GrantLegSerialNumber = GL.ID
		WHERE 
			(UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END)) AND
			(SC.[Status] = 'A') AND (SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_APPROVE = 1) AND 
			(AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (AEPC.MAIL_MODE_PREVESTING = 1)
			AND (GL.ExercisableQuantity <> 0) AND ((LEN(ISNULL(EPP.PaymentMode, '')) = 0) OR (EPP.PaymentMode IS NULL))	AND
			(CONVERT(DATE,DATEADD(DAY,-CONVERT(INT,AEPC.BEFORE_VESTING_DAYS),GL.FinalVestingDate)) = CONVERT(DATE,GETDATE()))
		
		UNION ALL	
		
		/* SEND MAIL TO EMPLOYEE FOR SELECTION OF PAYMENT MODE PRE VESTING REMINDER MAILS EVERY DAYS  */
		
		SELECT 
			GL.ID, SC.SchemeId, SC.SchemeTitle, GL.GrantOptionId, GL.GrantLegId, GL.VestingType, GL.FinalVestingDate,
			AEPC.BEFORE_VESTING_DAYS, AEPC.REMINDER_MAIL_DAYS, EM.EmployeeID, EM.EmployeeName, EM.EmployeeEmail,
			'REMINDER MAILS EVERY' AS ALERT_TYPE	
		FROM 
			Scheme AS SC
			INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = SC.SchemeId
			INNER JOIN GrantLeg AS GL ON GL.SchemeId = SC.SchemeId
			INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.GrantOptionId
			INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = GOP.EmployeeId
			LEFT OUTER JOIN EmpPrePaySelection AS EPP ON EPP.GrantLegSerialNumber = GL.ID
		WHERE 
			(UPPER(GL.IsPerfBased) = (CASE WHEN GL.VestingType = 'P' THEN '1' ELSE 'N' END)) AND
			(SC.[Status] = 'A') AND (SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_APPROVE = 1) AND 
			(AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND (AEPC.MAIL_MODE_PREVESTING = 1)
			AND (GL.ExercisableQuantity <> 0) AND ((LEN(ISNULL(EPP.PaymentMode, '')) = 0) OR (EPP.PaymentMode IS NULL))	AND
			((CONVERT(DATE,GL.FinalVestingDate) > CONVERT(DATE,GETDATE())) AND (CONVERT(DATE,GETDATE()) > CONVERT(DATE,DATEADD(DAY, - CONVERT(INT, AEPC.BEFORE_VESTING_DAYS), GL.FinalVestingDate)))) AND 
			(CONVERT(DATE,DATEADD(DAY, - CONVERT(INT, AEPC.BEFORE_VESTING_DAYS), GL.FinalVestingDate)) <> CONVERT(DATE,GETDATE())) AND 
			((DATEDIFF(DD, (CONVERT(DATE, DATEADD(DAY, - CONVERT(INT,AEPC.BEFORE_VESTING_DAYS), CONVERT(DATE,GL.FinalVestingDate)))), (CONVERT(DATE,GETDATE()))) % CONVERT(INT,AEPC.REMINDER_MAIL_DAYS) = 0))
	) 
	TEMP_ALERT
	
	SELECT 
		ID, SchemeId, SchemeTitle, GrantOptionId, GrantLegId, VestingType, FinalVestingDate, BEFORE_VESTING_DAYS, 
		REMINDER_MAIL_DAYS, EmployeeID, EmployeeName, EmployeeEmail, ALERT_TYPE			
	FROM 
		#EMP_DATA_BEFOR_VESTING_AND_REMINDER
	
	--------------------------------------------------------------------
	-- INSERT INTO MAILER DB 
	--------------------------------------------------------------------
		
	SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(FORMATS) = 'SELPAYMODEFORPREVESTING'
	
	-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
		
	SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
	BEGIN
		DBCC CHECKIDENT(#EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL, RESEED, @MaxMsgId)
	END
		
	INSERT INTO #EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL 
	(
		M_EmployeeID, M_EmployeeName, M_EmployeeEmail, M_MailSubject, M_MailBody
	)
	SELECT 
		EmployeeID, EmployeeName, EmployeeEmail, REPLACE(@MailSubject,'{0}', FinalVestingDate), 	
		REPLACE(REPLACE(REPLACE(@MailBody,'{1}', EmployeeName),'{2}', FinalVestingDate),'{3}',SchemeTitle)		
	FROM
		#EMP_DATA_BEFOR_VESTING_AND_REMINDER
	
	IF((SELECT COUNT(M_EmployeeID) AS ROW_COUNT FROM #EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL) > 0)	
	BEGIN						
		SELECT 
			M_Message_ID, M_EmployeeID, M_EmployeeName, M_EmployeeEmail, M_MailSubject, M_MailBody
		FROM 
			#EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL
		WHERE 
			(M_MailBody IS NOT NULL)									
	END	
											
	----------------------------------------------------------------------------------------------------------------------------
	-- INSERT INTO MAILER DB DATABASE
	----------------------------------------------------------------------------------------------------------------------------	

	IF((SELECT COUNT(M_EmployeeID) AS ROW_COUNT FROM #EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL) > 0)		
		BEGIN 
		
			BEGIN TRY
				
				BEGIN TRANSACTION
																
					-- INSSET INTO MAIL SPOOL TABLE
					INSERT INTO [MailerDB].[dbo].[MailSpool]
					([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
					SELECT 
						M_Message_ID, @COMPANY_EMAIL_ID, M_EmployeeEmail, M_MailSubject, M_MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', @COMPANY_EMAIL_ID, NULL, GETDATE() 
					FROM 
						#EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL
					WHERE 
						(M_MailBody IS NOT NULL)									
									
				COMMIT TRANSACTION
														
			END TRY
			BEGIN CATCH
					
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION
				
				SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
				
			END CATCH
		END
	ELSE
		BEGIN
			PRINT 'MAILS NOT AVAILABLE'
		END
						
	---------------------
	-- TEMP TABLE DETAILS
	---------------------
					
	BEGIN	
		DROP TABLE #EMP_DATA_BEFOR_VESTING_AND_REMINDER
		DROP TABLE #EMP_DATA_BEFOR_VESTING_AND_REMINDER_MAIL
	END
	
	SET NOCOUNT OFF;
END
GO
