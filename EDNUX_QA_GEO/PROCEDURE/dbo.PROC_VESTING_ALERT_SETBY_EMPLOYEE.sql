/****** Object:  StoredProcedure [dbo].[PROC_VESTING_ALERT_SETBY_EMPLOYEE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_VESTING_ALERT_SETBY_EMPLOYEE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_VESTING_ALERT_SETBY_EMPLOYEE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PROC_VESTING_ALERT_SETBY_EMPLOYEE] 
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
			@FBTRate		NUMERIC(10,2),
			@FBTPayBy		NVARCHAR(20),
			@MaxNewMsgId	BIGINT
			
	SET NOCOUNT ON;
	
	BEGIN
		---------------------
		-- CREATE TEMP TABLES
		---------------------
		
		CREATE TABLE #Vesting_Mail_Alert
		(
			Message_ID				NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EmployeeId				NVARCHAR(50),
			UserId					NVARCHAR(50),	
			EmployeeName			NVARCHAR(100),	
			EmployeeEmail			NVARCHAR(80),	
			SchemeId				NVARCHAR(200),	
			GrantRegistrationId		NVARCHAR(50),	
			GrantDate				DATE,
			ExercisePrice			NUMERIC(18,2),
			FBTValue				NUMERIC(18,2),	
			GrantId					BIGINT,
			GrantOptionId			NVARCHAR(100), 	
			GrantLegId				TINYINT,
			VestingType				CHAR,
			GrantedOptions			NUMERIC(18,0),
			FinalVestingDate		DATE,
			FinalExpiryDate			DATE,
			ExercisableQuantity		NUMERIC(18,0),
			VestMailSent			CHAR,
			DaysBeforeVestingStart	TINYINT,
			DateDifference			TINYINT,
			CompanyName				NVARCHAR(100), 
			CompanyEmail			NVARCHAR(200), 
			MailSubject				NVARCHAR(100),
			MailBody				NVARCHAR(MAX),
			FBTRate					NUMERIC(10,2),
			FBTPayBy				NVARCHAR(20),
			FBTOperation			NUMERIC(18,2),
			VestSchedInPercent		NUMERIC(18,2)
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
				@CompanyId = CM.CompanyID, @FBTRate = FBTax, @FBTPayBy = FBTPayBy 
		FROM	CompanyParameters AS CP 
				INNER JOIN CompanyMaster AS CM ON CP.CompanyID = CM.CompanyID
		--PRINT 'Company Name := '+ @CompanyName 	PRINT ' Company Email Id :='+ @CompanyEmailID
		-----------------------------------------------------------------------------
		-- GET VESTING MAIL ALERT SET BY EMPLOYEE DETAILS FROM MailMessages TABLE
		-----------------------------------------------------------------------------
		
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages  WHERE Formats='VestingMailAlertForEmp'
		--PRINT 'Mail Subject := '+@MailSubject  	PRINT 'Mail Body :=' + @MailBody
		
		-------------------------------------------------------------------
		-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
		-------------------------------------------------------------------
		
		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
		BEGIN
			DBCC CHECKIDENT(#Vesting_Mail_Alert, RESEED, @MaxMsgId) 
		END	
		
		SET @MaxNewMsgId = (SELECT ISNULL(MAX(MessageID),0)+ 1	AS MessageID FROM NewMessageTo)
		
		BEGIN
			DBCC CHECKIDENT(#New_Message_To, RESEED, @MaxNewMsgId) 
		END
	END
	
	BEGIN
		-----------------------------------------------------------------
		-- GET VESTING MAIL ALERT SET BY EMPLOYEE DETAILS FOR SEND MAIL
		-----------------------------------------------------------------
		INSERT INTO #Vesting_Mail_Alert (
					EmployeeId,
					UserId,
					EmployeeName,
					EmployeeEmail,
					SchemeId,
					GrantRegistrationId,
					GrantDate,
					ExercisePrice,
					FBTValue,
					GrantId,
					GrantOptionId,
					GrantLegId,
					VestingType,
					VestSchedInPercent,
					GrantedOptions,
					FinalVestingDate,
					FinalExpiryDate,
					ExercisableQuantity,
					VestMailSent,
					DaysBeforeVestingStart,
					DateDifference,
					CompanyName,
					CompanyEmail,
					MailSubject,
					MailBody,
					FBTRate,
					FBTPayBy,
					FBTOperation)
			SELECT	EM.EmployeeID,
					UM.UserId,
					EM.EmployeeName,
					EM.EmployeeEmail, 
					GL.SchemeId,
					GR.GrantRegistrationId,		
					CONVERT(DATE,GR.GrantDate,110) AS [GrantDate],
					GR.ExercisePrice, 
					CASE WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END [FBTValue],		
					GL.ID AS [GrantId],		 
					GL.GrantOptionId,
					GL.GrantLegId, 
					GL.VestingType,
					CASE WHEN GL.VestingType='T' THEN VP.OptionTimePercentage 
						 WHEN GL.VestingType='P' THEN VP.OptionPerformancePercentage
					END VestSchedInPercent,
					(GL.GrantedOptions) - (GL.CancelledQuantity) AS GrantedOptions,
					CONVERT(DATE,GL.FinalVestingDate,110) AS FinalVestingDate,
					CONVERT(DATE,GL.FinalExpirayDate,110) AS FinalExpiryDate,				
					GL.ExercisableQuantity, 
					'Y',		
					SA.DaysBeforeVestingStart,
					DATEDIFF(D,CONVERT(DATE,GETDATE()),
					CONVERT(DATE,GL.FinalVestingDate)) DateDifference,
					@CompanyName,
					@CompanyEmailID,
					@MailSubject,
					CASE	
						WHEN UPPER(@CompanyId)='TECHMAHINDRA'	
							THEN 
								REPLACE(REPLACE(REPLACE(
									REPLACE(REPLACE(REPLACE(REPLACE(
											REPLACE(@MailBody,
												'{0}', EM.EmployeeName),
									  			'{1}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalVestingDate,113),' ','-')),
												'{2}', GL.SchemeId),
												'{3}', REPLACE(CONVERT(NVARCHAR(11),GR.GrantDate,113),' ','-')),
												'{4}', GL.ExercisableQuantity),
												'{5}', GR.ExercisePrice),
												'{6}', CASE	WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END),
												'{7}', CASE	WHEN ((CASE WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END)-((GR.ExercisePrice)*(@FBTRate/100)) < 0) 
															THEN 0 
															ELSE (CASE WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END)-((GR.ExercisePrice)*(@FBTRate/100))  END)	
						WHEN UPPER(@CompanyId)='IDEA'			
							THEN 
								REPLACE(REPLACE(REPLACE
									(REPLACE(REPLACE(REPLACE(REPLACE
											(REPLACE(REPLACE(@MailBody,
												'{0}', EM.EmployeeName),
												'{1}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalVestingDate,113),' ','-')),
												'{2}',GL.SchemeId),
												'{3}',REPLACE(CONVERT(NVARCHAR(11),GR.GrantDate,113),' ','-')),
												'{4}',GL.ExercisableQuantity),
												'{5}',GR.ExercisePrice),
												'{6}',GR.GrantRegistrationId),
												'{7}',GL.GrantLegId),
												'{8}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalExpirayDate,113),' ','-'))
						WHEN UPPER(@CompanyId)='KOTAK'			
							THEN 
								REPLACE(REPLACE(REPLACE(REPLACE
									(REPLACE(REPLACE(REPLACE(REPLACE
										(REPLACE(REPLACE(@MailBody,'{0}', EM.EmployeeName),
												'{1}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalVestingDate,113),' ','-')),
												'{2}', GL.SchemeId),
												'{3}', REPLACE(CONVERT(NVARCHAR(11),GR.GrantDate,113),' ','-')),
												'{4}', GL.ExercisableQuantity),
												'{5}', GR.ExercisePrice),
												'{6}', GR.GrantRegistrationId),
												'{7}', GL.GrantLegId),
												'{8}', REPLACE(CONVERT(NVARCHAR(11),
														CASE WHEN GL.VestingType='T' THEN (VP.OptionTimePercentage) 
															 WHEN GL.VestingType='P' THEN (VP.OptionPerformancePercentage) END												
												,113),' ','-')),
												'{9}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalExpirayDate,113),' ','-'))
						WHEN UPPER(@CompanyId)='AXISBANK'		
							THEN 
								REPLACE(REPLACE(REPLACE(REPLACE
									(REPLACE(REPLACE(REPLACE(@MailBody,'{0}', EM.EmployeeName),
												'{1}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalVestingDate,113),' ','-')),
												'{2}', GL.SchemeId),
												'{3}', REPLACE(CONVERT(NVARCHAR(11),GR.GrantDate,113),' ','-')),
												'{4}', GL.ExercisableQuantity),
												'{5}', GR.ExercisePrice),												
												'{9}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalExpirayDate,113),' ','-'))
						ELSE 	
							REPLACE(REPLACE(REPLACE(
								REPLACE(REPLACE(REPLACE(@MailBody,
												'{0}', EM.EmployeeName),
												'{1}', REPLACE(CONVERT(NVARCHAR(11),GL.FinalVestingDate,113),' ','-')),
												'{2}',GL.SchemeId),
												'{3}',REPLACE(CONVERT(NVARCHAR(11),GR.GrantDate,113),' ','-')),
												'{4}', GL.ExercisableQuantity),
												'{5}',GR.ExercisePrice)
					END,
					@FBTRate,
					@FBTPayBy,
					CASE WHEN ((CASE WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END)-((GR.ExercisePrice)*(@FBTRate/100)) < 0) THEN 0 
						 ELSE (CASE WHEN (VP.FBTValue) > 0 THEN VP.FBTValue ELSE 0 END)-((GR.ExercisePrice)*(@FBTRate/100))  END						  
						
			FROM	SetAlert AS SA 
					INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = SA.EmployeeID
					INNER JOIN UserMaster AS UM ON EM.EmployeeID = UM.EmployeeId
					LEFT OUTER JOIN GrantOptions AS GOP ON EM.EmployeeID = GOP.EmployeeId
					INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId = GL.GrantOptionId
					INNER JOIN Scheme AS SC ON GOP.SchemeId = SC.SchemeId
					LEFT OUTER JOIN VestingPeriod AS VP ON VP.SchemeId = GL.SchemeId  AND GL.VestingPeriodId=VP.VestingPeriodId
					INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GOP.GrantRegistrationId		
			WHERE	(UM.IsUserActive = 'Y') 
					AND ((EM.ReasonForTermination='2') OR (EM.DateOfTermination IS NULL))
					AND (IsMailSentForVesting='1') 
					AND (SC.IsPUPEnabled = 0) 
					AND CONVERT(DATE,FinalVestingDate) >= CONVERT(DATE,GETDATE())					
					AND GL.ExercisableQuantity > 0
					AND DATEDIFF(D,CONVERT(DATE,GETDATE()), CONVERT(DATE,GL.FinalVestingDate)) = SA.DaysBeforeVestingStart
					AND GL.VestMailSent IS NULL 
			GROUP BY 
					EM.EmployeeID, 
					SA.DaysBeforeVestingStart, 
					GR.GrantDate, 
					GR.ExercisePrice,
					GL.ID, 
					GL.FinalVestingDate,
					GL.FinalExpirayDate,
					GL.GrantOptionId,
					GL.GrantLegId, 
					GL.VestingType,
					VP.OptionTimePercentage,
                    VP.OptionPerformancePercentage,  		
					GL.ExercisableQuantity, 					
					GL.SchemeId,
					VP.FBTValue,
					EM.EmployeeName,
					EM.EmployeeEmail,
					UM.UserId,
					GR.GrantRegistrationId,
					GL.GrantedOptions,
					GL.CancelledQuantity
			HAVING (ISNULL(SUM(GL.GrantedOptions),0) > 0)
			ORDER BY EM.EmployeeID ASC,
					GL.FinalVestingDate, 
					GL.GrantOptionId 

		INSERT INTO #New_Message_To(
					EmployeeID,		
					MessageDate,
					MailSubject,
					MailBody
					)
			SELECT	VMA.EmployeeId,
					CONVERT(DATE,GETDATE()),
					VMA.MailSubject,
					--REPLACE(REPLACE(REPLACE(REPLACE(VMA.MailBody,'</P>',' '),'<P>', ' '),'<br />', ' '),'&nbsp;',' ')
					REPLACE(REPLACE(
					REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
					REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(VMA.MailBody,
						'<div style="font-family: arial; font-size: 12px; width: 600px; line-height: 20px;">',''),
						'<table style="width: 100%; font-family: arial; font-size: 12px; line-height: 20px; border-collapse: collapse;" cellpadding="4" cellspaing="0">',''),									
						'<tr>',''),
						'</tr>',''),
						'<td style="width: 50%; border: 1px solid #000;">',''),
						'</td>',''),
						'</table>',''),
						'<td colspan="2">',''),
						'</div>',''),
						'<td colspan="2" style="text-align: justify;  font-family: arial; font-size: 12px; line-height: 20px; ">',''),
						'<a href="http://www.myesops.com/">',''),
						'</a>',''),
						'<br />',''),
						'<b>',''),
						'</b>',''),
						'<a href="mailto:fundinghelpdesk@esopdirect.com">',''),
						'<a href="mailto:techmahindra@esopdirect.com">',''),
						'<a href="mailto:axisbank@esopdirect.com">',''),
						'<a href="http://www.esopdirect.com/">','')
						
			FROM	#Vesting_Mail_Alert AS VMA
			WHERE	MailBody IS NOT NULL

			SELECT	Message_ID,
					EmployeeId,
					UserId,
					EmployeeName,
					EmployeeEmail,
					SchemeId,
					GrantRegistrationId,
					GrantDate,
					ExercisePrice,
					FBTValue,
					GrantId,
					GrantOptionId,
					GrantLegId,
					VestingType,
					GrantedOptions,
					FinalVestingDate,
					FinalExpiryDate,
					ExercisableQuantity,
					VestMailSent,
					DaysBeforeVestingStart,
					DateDifference,
					CompanyName,
					CompanyEmail,
					MailSubject,
					MailBody,
					FBTRate,
					FBTPayBy,
					FBTOperation 
			FROM	#Vesting_Mail_Alert				
	END
	
	BEGIN
		IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #Vesting_Mail_Alert) > 0)	
		BEGIN 
			BEGIN TRY
				BEGIN TRANSACTION
				-------------------------------------------------------------------------
				-- INSERT MAIL DETAILS INTO MAIL SPOOL TABLE FROM MAILER DB DATABASE
				-------------------------------------------------------------------------
				INSERT INTO [MailerDB]..[MailSpool]
				([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
				SELECT Message_ID, CompanyEmail, EmployeeEmail, MailSubject, MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() FROM #Vesting_Mail_Alert
				WHERE (MailBody IS NOT NULL)
				
				INSERT INTO NewMessageTo
				(MessageID,EmployeeID,MessageDate,[Subject],[Description],ReadDateTime,CategoryID,IsReplySent,LastUpdatedBy,LastUpdatedOn,IsDeleted)
				SELECT Message_ID,EmployeeID,MessageDate,NMT.MailSubject,NMT.MailBody,NULL,2,0,'Admin',GETDATE(),0 FROM #New_Message_To NMT
				WHERE (NMT.MailBody IS NOT NULL) 
				
				------------------------------------------------------------------
				-- UPDATE MAIL SENT FLAG INTO SETALERT TABLE AND GRANTLEG TABLE
				------------------------------------------------------------------
				UPDATE SA SET SA.IsMailSentForVesting = '0' FROM SetAlert AS SA 
				INNER JOIN #Vesting_Mail_Alert AS VMA ON VMA.EmployeeId = SA.EmployeeID WHERE (VMA.MailBody IS NOT NULL)
				
				UPDATE GL SET GL.VestMailSent = 'Y' FROM GrantLeg AS GL
				INNER JOIN #Vesting_Mail_Alert AS VMA ON VMA.GrantId = GL.ID WHERE (VMA.MailBody IS NOT NULL)				
				
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
