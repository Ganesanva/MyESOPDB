DROP PROCEDURE IF EXISTS [dbo].[PROC_REMINDER_MAIL_FOR_SELECTING_PAYMENTMODE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_REMINDER_MAIL_FOR_SELECTING_PAYMENTMODE]    Script Date: 18-07-2022 15:22:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_REMINDER_MAIL_FOR_SELECTING_PAYMENTMODE]
(
	@CompanyId VARCHAR(50) = NULL
)
AS
BEGIN
	DECLARE @CompanyName	NVARCHAR(50),
			@CompanyEmailID NVARCHAR(200),
			@MailSubject	NVARCHAR(500),
			@MailBody		NVARCHAR(MAX),	
			@MaxMsgId		BIGINT,
			@MaxNewMsgId	BIGINT
			
	SET NOCOUNT ON;
	
	BEGIN
		---------------------
		-- CREATE TEMP TABLES
		---------------------
		CREATE TABLE #Payment_Mail_Alert
		(
			Message_ID				NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			MIT_ID					BIGINT,
			EmployeeId				NVARCHAR(50),
			UserId					NVARCHAR(50),	
			EmployeeName			NVARCHAR(100),	
			EmployeeEmail			NVARCHAR(80),	
			GrantOptionId			NVARCHAR(200),	
			GrantedOptions			NUMERIC(18,0),
			ExerciseNo				NUMERIC(18,0),	
			ExercisedQuantity		NUMERIC(18,0),
			ExerciseAmount		    NUMERIC(18,2),
			CompanyName				NVARCHAR(100), 
			CompanyEmail			NVARCHAR(200), 
			MailSubject				NVARCHAR(100),
			MailBody				NVARCHAR(MAX)
		)		
		
		CREATE TABLE #New_Message_To
		(
			Message_ID				NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EmployeeID				NVARCHAR(80),
			MessageDate				DATE,
			MailSubject				NVARCHAR(100),
			MailBody				NVARCHAR(MAX)					
		)
	END
	
	BEGIN
		---------------------------------------------------------
		-- GET COMPANY NAME AND COMPANY EMAIL ID
		---------------------------------------------------------
		SELECT	@CompanyName = CM.CompanyName, @CompanyEmailID = CP.CompanyEmailID,
				@CompanyId = CM.CompanyID 
		FROM	CompanyParameters AS CP 
				INNER JOIN CompanyMaster AS CM ON CP.CompanyID = CM.CompanyID

		-----------------------------------------------------------------------------
		-- GET Payment MAIL ALERT SET BY EMPLOYEE DETAILS FROM MailMessages TABLE
		-----------------------------------------------------------------------------
		
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages  WHERE Formats='PaymentMailAlertForEmp'
		
		
		-------------------------------------------------------------------
		-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
		-------------------------------------------------------------------
		
		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
		BEGIN
			DBCC CHECKIDENT(#Payment_Mail_Alert, RESEED, @MaxMsgId) 
		END	
		
		SET @MaxNewMsgId = (SELECT ISNULL(MAX(MessageID),0)+ 1	AS MessageID FROM NewMessageTo)
		
		BEGIN
			DBCC CHECKIDENT(#New_Message_To, RESEED, @MaxNewMsgId) 
		END
	END
	declare @PayModeReminderDays int
		declare @IsReminderForPaymentModeSelection char
	select @PayModeReminderDays=PayModeReminderDays,@IsReminderForPaymentModeSelection=IsReminderForPaymentModeSelection from  CompanyParameters
	BEGIN
		-----------------------------------------------------------------
		-- GET Payment MAIL ALERT SET BY EMPLOYEE DETAILS FOR SEND MAIL
		-----------------------------------------------------------------
		if @IsReminderForPaymentModeSelection='Y'
		BEGIN
		INSERT INTO #Payment_Mail_Alert (
					MIT_ID,				
					EmployeeId,		
					UserId,			
					EmployeeName,
					EmployeeEmail,	
					GrantOptionId,			
					GrantedOptions	,
					ExerciseNo	,		
					ExercisedQuantity,
					ExerciseAmount,
					CompanyName,
					CompanyEmail,
					MailSubject,
					MailBody		
					)
			SELECT	distinct Shex.MIT_ID,
					EM.EmployeeID,
					UM.UserId,
					EM.EmployeeName,
					EM.EmployeeEmail,
					GOP.GrantOptionId,		
					GOP.GrantedOptions,
					Shex.ExerciseNo,
					SUM(Shex.ExercisedQuantity),	  
				    SUM(Shex.ExercisedQuantity)*Shex.ExercisePrice as ExerciseAmount,
					@CompanyName,
					@CompanyEmailID,
					@MailSubject,
					REPLACE(REPLACE(REPLACE(REPLACE(
											REPLACE(@MailBody,
												'{0}', EM.EmployeeName),
									  			'{1}', Shex.ExerciseNo),
												'{2}', GOP.GrantOptionId),
												'{3}', SUM(Shex.ExercisedQuantity)),
												'{4}', SUM(Shex.ExercisedQuantity)*Shex.ExercisePrice )
			FROM	EmployeeMaster AS EM  	INNER JOIN UserMaster AS UM ON EM.EmployeeID = UM.EmployeeId
				INNER JOIN ShExercisedOptions AS Shex ON EM.EmployeeID = Shex.EmployeeId  
				INNER JOIN grantleg GL  ON shex.grantlegserialnumber = GL.id 
				INNER JOIN GrantOptions AS GOP ON GOP.GrantOptionId = GL.grantoptionid
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID=shex.MIT_ID
					
			WHERE	(UM.IsUserActive = 'Y') 
					AND ((EM.ReasonForTermination='2') OR (EM.DateOfTermination IS NULL))
					AND (ISNULL(shex.PaymentMode,'')='') 
					AND shex.MIT_ID NOT IN(5,7)
					AND CIM.ISPaymentReminder='Y'
					AND (DATEDIFF(DAY, shex.ExerciseDate, GETDATE())) <=@PayModeReminderDays

			GROUP BY ExerciseNo,Shex.MIT_ID,
					EM.EmployeeID,
					UM.UserId,
					EM.EmployeeName,
					EM.EmployeeEmail,
					GOP.GrantOptionId,		
					GOP.GrantedOptions,Shex.ExercisePrice
		INSERT INTO #New_Message_To(
					EmployeeID,		
					MessageDate,
					MailSubject,
					MailBody
					)
			SELECT	PMA.EmployeeId,
					CONVERT(DATE,GETDATE()),
					PMA.MailSubject,
					PMA.MailBody
			FROM	#Payment_Mail_Alert AS PMA
			WHERE	MailBody IS NOT NULL
		END	
	END
--	Select * from #Payment_Mail_Alert
	BEGIN
		IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #New_Message_To) > 0)	
		BEGIN 
			BEGIN TRY
				BEGIN TRANSACTION
				-------------------------------------------------------------------------
				-- INSERT MAIL DETAILS INTO MAIL SPOOL TABLE FROM MAILER DB DATABASE
				-------------------------------------------------------------------------
				INSERT INTO [MailerDB]..[MailSpool]
				([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
				SELECT Message_ID, CompanyEmail, EmployeeEmail, MailSubject, MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() FROM #Payment_Mail_Alert
				WHERE (MailBody IS NOT NULL)
				
				INSERT INTO NewMessageTo
				(MessageID,EmployeeID,MessageDate,[Subject],[Description],ReadDateTime,CategoryID,IsReplySent,LastUpdatedBy,LastUpdatedOn,IsDeleted)
				SELECT Message_ID,EmployeeID,MessageDate,NMT.MailSubject,NMT.MailBody,NULL,2,0,'Admin',GETDATE(),0 FROM #New_Message_To NMT
				WHERE (NMT.MailBody IS NOT NULL) 
			
				COMMIT TRANSACTION
			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION
				SELECT	ERROR_NUMBER()		AS ErrorNumber, 
						ERROR_SEVERITY()	AS ErrorSeverity, 
						ERROR_STATE()		AS ErrorState, 
						ERROR_PROCEDURE()	AS ErrorProcedure, 
						ERROR_LINE()		AS ErrorLine, 
						ERROR_MESSAGE()		AS ErrorMessage;
			END CATCH
		END
	END
	
	SET NOCOUNT OFF;			
END
GO


