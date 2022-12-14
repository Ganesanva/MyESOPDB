/****** Object:  StoredProcedure [dbo].[PROC_SEND_EMAIL_ALERT_FOR_EX_MANDATE_FIELDS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SEND_EMAIL_ALERT_FOR_EX_MANDATE_FIELDS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SEND_EMAIL_ALERT_FOR_EX_MANDATE_FIELDS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SEND_EMAIL_ALERT_FOR_EX_MANDATE_FIELDS]
		
AS

BEGIN
	 SET  NOCOUNT ON;

		DECLARE @MAX INT, @MIN INT, @FIELD VARCHAR(100), @OUT_PUT VARCHAR(100), @QUERY VARCHAR(MAX), @FIELD_LIST VARCHAR(MAX),@CHK_SEND_MAIL BIT , 
				@MailSubject NVARCHAR(500),@MailBody NVARCHAR(MAX),@MaxMsgId BIGINT, @DATE_DIFF INT ,@IS_ADS_ENABLED BIT,
				@REMINDER_DAYS INT,@DIFF_LUO_SMO DATETIME
			
		CREATE TABLE #TEMP_CONFIG_PERSONAL_DETAILS
		(
			TCPD_ID INT IDENTITY(1,1) NOT NULL,
			EmployeeField VARCHAR(200) ,Check_Exercise CHAR,ADS_CHECK_EXERCISE CHAR
		)
		
		INSERT INTO #TEMP_CONFIG_PERSONAL_DETAILS (EmployeeField,Check_Exercise,ADS_CHECK_EXERCISE)
		SELECT +'[' + EmployeeField +']',Check_Exercise,ADS_CHECK_EXERCISE FROM ConfigurePersonalDetails
		
		--select * From #TEMP_CONFIG_PERSONAL_DETAILS

		CREATE TABLE #TEMP_EMP_MASTER_CONFIG_DTLS
		(
				EMCD_ID				INT IDENTITY(1,1) NOT NULL,
				EmployeeField		VARCHAR(100)				
		)

		CREATE TABLE #TEMP_EMP_MASTER_CONFIG_DTLS_ADS
		(
				EMCD_ID				INT IDENTITY(1,1) NOT NULL,
				EmployeeField		VARCHAR(100)				
		)
		
		INSERT INTO #TEMP_EMP_MASTER_CONFIG_DTLS
		(
				EmployeeField
		)
		SELECT DISTINCT(CPD.EmployeeField) FROM EmployeeMaster EM CROSS JOIN #TEMP_CONFIG_PERSONAL_DETAILS CPD WHERE CPD.Check_Exercise ='Y' 

		INSERT INTO #TEMP_EMP_MASTER_CONFIG_DTLS_ADS
		(
				EmployeeField
		)
		SELECT DISTINCT(CPD.EmployeeField) FROM EmployeeMaster EM CROSS JOIN #TEMP_CONFIG_PERSONAL_DETAILS CPD WHERE CPD.ADS_CHECK_EXERCISE='Y'
		
		
		--SELECT * FROM #TEMP_EMP_MASTER_CONFIG_DTLS
		--SELECT * FROM #TEMP_EMP_MASTER_CONFIG_DTLS_ADS
		 -------------------------------------------------
		 -- CREATE TEMP TABLE
		 -------------------------------------------------
		CREATE TABLE #FINAL_DETAILS
		(
			EmployeeID VARCHAR(100), Employee_Name VARCHAR(100), EmployeeEmail VARCHAR(100),
			CompanyEmail NVARCHAR(200), CompanyName NVARCHAR(100), SchemeID VARCHAR(150),					
			MailSubject NVARCHAR(500), MailBody	NVARCHAR(MAX)
		)
		
		-------------------------------------------------------------
		-- CHECK IS SEND MAIL ALERT IS ACTIVE OR NOT
		-------------------------------------------------------------
		SET @CHK_SEND_MAIL = (SELECT IS_SEND_MAIL_ALERT FROM EMPLOYEEALERT_MANDATORYFIELDS WHERE EAMF_ID=(SELECT MAX(EAMF_ID) FROM EMPLOYEEALERT_MANDATORYFIELDS))
		--PRINT @CHK_SEND_MAIL
		
		-------------------------------------------------------------
		---- GET MAIL BODY AND MAIL SUBJECT FROM MAIL MESSAGES TABLE
		-------------------------------------------------------------
		
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'SENDMAILFORMANDATORYFILEDSFOREX'
		--PRINT 'Subject : '+ @MailSubject +' Mail Body : '+ @MailBody
		
		-------------------------------------------------------------
		---- GET THE DATE DIFFERENCE COMBINATION 
		-------------------------------------------------------------
		
		SELECT TOP 1 @DATE_DIFF = DATEDIFF(DAY, ISNULL(SENT_MAIL_ON, LAST_UPDATED_ON), GETDATE()),@REMINDER_DAYS = REMINDER_DAYS, @DIFF_LUO_SMO= (ISNULL(SENT_MAIL_ON, LAST_UPDATED_ON))FROM  EmployeeAlert_MandatoryFields ORDER BY EAMF_ID DESC

		 --PRINT @DATE_DIFF 	 --PRINT @REMINDER_DAYS 		 PRINT @DIFF_LUO_SMO 
		 
		 -------------------------------------------------------------
		---- CHECK IS ADS ENABLED FROM COMPANY MASTER
		-------------------------------------------------------------
		 SELECT @IS_ADS_ENABLED = IS_ADS_ENABLED  FROM CompanyMaster
		 
		--print @IS_ADS_ENABLED
		 
		IF(@CHK_SEND_MAIL = 1)
			BEGIN
				IF(@IS_ADS_ENABLED = 1)
				
				 BEGIN
				
						SELECT @MAX = MAX(EMCD_ID), @MIN = MIN(EMCD_ID) FROM #TEMP_EMP_MASTER_CONFIG_DTLS_ADS
						SET @FIELD_LIST=''
					
						WHILE (@MIN <= @MAX)
						BEGIN
							--ISNULL(MEC.EmployeeMaster_Fields,0),ISNULL(MEC.OUTPUT_FIELD,NULL)
							SELECT @FIELD = MEC.EmployeeMaster_Fields ,@OUT_PUT = MEC.OUTPUT_FIELD FROM #TEMP_EMP_MASTER_CONFIG_DTLS_ADS AS TEMCD
							LEFT OUTER JOIN Mapping_EmpMaster_ConfigDtls AS MEC ON TEMCD.EmployeeField = MEC.ConfigDetails_Fields
							WHERE EMCD_ID = @MIN
							--PRINT @FIELD
							BEGIN TRY
							IF(@FIELD <>'0')
							BEGIN
									INSERT INTO #FINAL_DETAILS (EmployeeID, Employee_Name, EmployeeEmail, CompanyName,CompanyEmail, MailSubject, MailBody,SchemeID)
									EXEC
										( 
											'SELECT 
												EM.EMPLOYEEID, EM.EMPLOYEENAME, EM.EmployeeEmail,CM.CompanyID,CM.CompanyEmailID,
												'''+@MailSubject+''',
												''<tr><td style="width: 10%; border: 2px solid #000;"> '+@OUT_PUT+'</td></tr>'' ,SC.SchemeId
											FROM EmployeeMaster EM 
											INNER JOIN UserMaster AS UM ON UM.UserId = EM.LoginID
											INNER JOIN GRANTOPTIONS AS GOP ON EM.EmployeeID = GOP.EmployeeId 
											INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId = GL.GrantOptionId
											INNER JOIN Scheme AS SC ON SC.SchemeId = GOP.SchemeId,
											CROSS JOIN CompanyMaster AS CM WHERE (UM.IsUserActive = ''Y'') AND ((EM.IsAssociated IS NULL) OR (EM.IsAssociated <> ''1'')) AND (GL.ExercisableQuantity > 0) AND SC.IS_ADS_SCHEME=1
											AND ((LEN('+@FIELD+') = 0) OR ('+@FIELD+' IS NULL) OR ('+@FIELD+'='''')) GROUP BY  EM.EMPLOYEEID, EM.EMPLOYEENAME, EM.EmployeeEmail,CM.CompanyID,CM.CompanyEmailID,SC.SchemeId ' 
										)
							END 
							
							SET @MIN = @MIN + 1
							--SELECT * FROM #FINAL_DETAILS
							END TRY
							BEGIN CATCH
								SELECT ERROR_MESSAGE()
							END CATCH

						END
						
						SELECT CompanyName, CompanyEmail, EmployeeID, EmployeeEmail, MailSubject, MailBody INTO #FINAL_DISTINCT_DETAILS_ADS FROM #FINAL_DETAILS WHERE 1 = 2
						
						ALTER TABLE #FINAL_DISTINCT_DETAILS_ADS ADD MessageID NUMERIC(18,0) IDENTITY(1,1) NOT NULL
						------------------------------------------------------------------
						---- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
						------------------------------------------------------------------							
						SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID)+1,0) AS MessageID FROM MailerDB..MailSpool)
						BEGIN
							DBCC CHECKIDENT(#FINAL_DISTINCT_DETAILS_ADS, RESEED, @MaxMsgId) 
						END
						
						INSERT INTO #FINAL_DISTINCT_DETAILS_ADS 
						(CompanyName, CompanyEmail, EmployeeID, EmployeeEmail , MailSubject, MailBody)
						SELECT DISTINCT
							OUTER_#FINAL_DETAILS.CompanyName, OUTER_#FINAL_DETAILS.CompanyEmail, OUTER_#FINAL_DETAILS.EmployeeID, 
							OUTER_#FINAL_DETAILS.EmployeeEmail, OUTER_#FINAL_DETAILS.MailSubject +'For ADS Scheme',
							REPLACE(REPLACE(@MailBody,'{0}', Employee_Name) ,'{1}', REPLACE(REPLACE(SUBSTRING((SELECT CONVERT(NVARCHAR(MAX), INNER_#FINAL_DETAILS.MailBody) as [text()] from #FINAL_DETAILS INNER_#FINAL_DETAILS WHERE INNER_#FINAL_DETAILS.Employeeid = OUTER_#FINAL_DETAILS.Employeeid ORDER BY INNER_#FINAL_DETAILS.Employeeid 
									FOR XML PATH ('')),1,100000),'&lt;','<'),'&gt;','>')) AS MailBody
						FROM #FINAL_DETAILS OUTER_#FINAL_DETAILS 
						
						
						--select Employee_Name, EmployeeEmail, CompanyName,CompanyEmail, MailSubject, MailBody from #FINAL_DETAILS 
						
						----------------------------------------------------------------
						-- INSERT INTO MAILER DB DATABASE MAIL SPOOL TABLE
						----------------------------------------------------------------
						BEGIN
							IF((SELECT COUNT(MessageID) AS ROW_COUNT FROM #FINAL_DISTINCT_DETAILS_ADS)>0)
							BEGIN
								BEGIN TRY
									BEGIN TRANSACTION
										 IF (@DATE_DIFF = @REMINDER_DAYS)
											BEGIN
											--print 'In ESOP Condition'
												INSERT INTO [MailerDB]..[MailSpool]
												([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
												SELECT DISTINCT
													MessageID, CompanyEmail, EmployeeEmail, MailSubject,  
													MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() 
												FROM #FINAL_DISTINCT_DETAILS_ADS
												
												UPDATE EmployeeAlert_MandatoryFields SET SENT_MAIL_ON=GETDATE() WHERE EAMF_ID= (SELECT MAX(EAMF_ID) FROM EmployeeAlert_MandatoryFields)
												
												SELECT DISTINCT
													MessageID, CompanyEmail, EmployeeEmail, EmployeeID, MailSubject,
													MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE(),CompanyName 
												FROM #FINAL_DISTINCT_DETAILS_ADS
											END
									COMMIT TRANSACTION
								END TRY
								BEGIN CATCH
										IF @@TRANCOUNT > 0
											ROLLBACK TRANSACTION
											SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
											ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
								END CATCH
							END
						END
						
				END
				
				IF(@IS_ADS_ENABLED <> -1)
				DELETE #FINAL_DETAILS
				BEGIN
					SELECT @MAX = MAX(EMCD_ID), @MIN = MIN(EMCD_ID) FROM #TEMP_EMP_MASTER_CONFIG_DTLS
				SET @FIELD_LIST=''
				
				WHILE (@MIN <= @MAX)
				BEGIN

					SELECT @FIELD = MEC.EmployeeMaster_Fields ,@OUT_PUT = MEC.OUTPUT_FIELD FROM #TEMP_EMP_MASTER_CONFIG_DTLS AS TEMCD
					LEFT OUTER JOIN Mapping_EmpMaster_ConfigDtls AS MEC ON TEMCD.EmployeeField = MEC.ConfigDetails_Fields
					WHERE EMCD_ID = @MIN
					--PRINT @FIELD
					BEGIN TRY
					IF(@FIELD <>'0')
					BEGIN
							INSERT INTO #FINAL_DETAILS (EmployeeID, Employee_Name, EmployeeEmail, CompanyName,CompanyEmail, MailSubject, MailBody,SchemeID)
							EXEC
								( 
									'SELECT 
										EM.EMPLOYEEID, EM.EMPLOYEENAME, EM.EmployeeEmail,CM.CompanyID,CM.CompanyEmailID,
										'''+@MailSubject+''',
										''<tr><td style="width: 10%; border: 2px solid #000;"> '+@OUT_PUT+'</td></tr>'' ,SC.SchemeId
									FROM EmployeeMaster EM 
									INNER JOIN UserMaster AS UM ON UM.UserId = EM.LoginID
									INNER JOIN GRANTOPTIONS AS GOP ON EM.EmployeeID = GOP.EmployeeId 
									INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId = GL.GrantOptionId
									INNER JOIN Scheme AS SC ON SC.SchemeId = GOP.SchemeId,
									CompanyMaster AS CM WHERE (UM.IsUserActive = ''Y'') AND ((EM.IsAssociated IS NULL) OR (EM.IsAssociated <> ''1'')) AND (GL.ExercisableQuantity > 0) AND SC.IS_ADS_SCHEME=0
									AND ((LEN('+@FIELD+') = 0) OR ('+@FIELD+' IS NULL) OR ('+@FIELD+'='''')) GROUP BY  EM.EMPLOYEEID, EM.EMPLOYEENAME, EM.EmployeeEmail,CM.CompanyID,CM.CompanyEmailID,SC.SchemeId ' 
								)
					END 
					
					SET @MIN = @MIN + 1
					--SELECT * FROM #FINAL_DETAILS
					END TRY
					BEGIN CATCH
						SELECT ERROR_MESSAGE()
					END CATCH

				END
				
				SELECT CompanyName, CompanyEmail, EmployeeID, EmployeeEmail, MailSubject, MailBody INTO #FINAL_DISTINCT_DETAILS FROM #FINAL_DETAILS WHERE 1 = 2
				
				ALTER TABLE #FINAL_DISTINCT_DETAILS ADD MessageID NUMERIC(18,0) IDENTITY(1,1) NOT NULL
				------------------------------------------------------------------
				---- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
				------------------------------------------------------------------							
				SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID)+1,0) AS MessageID FROM MailerDB..MailSpool)
				BEGIN
					DBCC CHECKIDENT(#FINAL_DISTINCT_DETAILS, RESEED, @MaxMsgId) 
				END
				
				INSERT INTO #FINAL_DISTINCT_DETAILS 
				(CompanyName, CompanyEmail, EmployeeID, EmployeeEmail , MailSubject, MailBody)
				SELECT DISTINCT
					OUTER_#FINAL_DETAILS.CompanyName, OUTER_#FINAL_DETAILS.CompanyEmail, OUTER_#FINAL_DETAILS.EmployeeID, 
					OUTER_#FINAL_DETAILS.EmployeeEmail, OUTER_#FINAL_DETAILS.MailSubject, 
					REPLACE(REPLACE(@MailBody,'{0}', Employee_Name) ,'{1}', REPLACE(REPLACE(SUBSTRING((SELECT CONVERT(NVARCHAR(MAX), INNER_#FINAL_DETAILS.MailBody) as [text()] from #FINAL_DETAILS INNER_#FINAL_DETAILS WHERE INNER_#FINAL_DETAILS.Employeeid = OUTER_#FINAL_DETAILS.Employeeid ORDER BY INNER_#FINAL_DETAILS.Employeeid 
							FOR XML PATH ('')),1,100000),'&lt;','<'),'&gt;','>')) AS MailBody
				FROM #FINAL_DETAILS OUTER_#FINAL_DETAILS 
				
				
				--select Employee_Name, EmployeeEmail, CompanyName,CompanyEmail, MailSubject, MailBody from #FINAL_DETAILS 
				
				----------------------------------------------------------------
				-- INSERT INTO MAILER DB DATABASE MAIL SPOOL TABLE
				----------------------------------------------------------------
					BEGIN
						IF((SELECT COUNT(MessageID) AS ROW_COUNT FROM #FINAL_DISTINCT_DETAILS)>0)
						BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								 IF (@DATE_DIFF = @REMINDER_DAYS)
									BEGIN
									--print 'In ESOP Condition'
										INSERT INTO [MailerDB]..[MailSpool]
										([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
										SELECT DISTINCT
											MessageID, CompanyEmail, EmployeeEmail, MailSubject,  
											MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE()
										FROM #FINAL_DISTINCT_DETAILS
										
										UPDATE EmployeeAlert_MandatoryFields SET SENT_MAIL_ON=GETDATE() WHERE EAMF_ID= (SELECT MAX(EAMF_ID) FROM EmployeeAlert_MandatoryFields)
										
										SELECT DISTINCT
											MessageID, CompanyEmail, EmployeeEmail, EmployeeID, MailSubject,
											MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE(),CompanyName
										FROM #FINAL_DISTINCT_DETAILS
										
									END
							COMMIT TRANSACTION
						END TRY
						BEGIN CATCH
								IF @@TRANCOUNT > 0
									ROLLBACK TRANSACTION
									SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
									ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
						END CATCH
					END
					END
					
				END
								
			END
		
	SET  NOCOUNT OFF;
			
END
GO
