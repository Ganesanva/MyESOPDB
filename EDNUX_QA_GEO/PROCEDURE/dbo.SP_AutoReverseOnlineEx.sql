/****** Object:  StoredProcedure [dbo].[SP_AutoReverseOnlineEx]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_AutoReverseOnlineEx]
GO
/****** Object:  StoredProcedure [dbo].[SP_AutoReverseOnlineEx]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_AutoReverseOnlineEx]  
AS  
BEGIN

	SET NOCOUNT ON;

	DECLARE @AutoRevForOnlineEx BIT, 
			@AutoRevMinutes INT, 
			@MaxMsgId BIGINT

	SELECT @AutoRevForOnlineEx = AutoRevForOnlineEx, @AutoRevMinutes = AutoRevMinutes FROM CompanyParameters
	
	/* Added code for Auto reversal to NOT to reverse excersies to those amount is greater than @TotalAmount and online payment is failed */ 
		
	IF ( (SELECT isexceptionactivated FROM   autoreversalconfigmaster) = 1 ) 
  BEGIN 
      DECLARE @TotalAmount NUMERIC(18, 0) 

      --PICK THE TOTAL AMOUNT 
      SELECT @TotalAmount = exceptionactivatedtoamount 
							FROM   autoreversalconfigmaster 

      ---LIST DOWN AND LOOP FOR ALL THE FORMULA WHERE IS_SELECTED = 1 AND CONCATINATE WITH ADDITION 
      ---AND USE FOR WHERE CLAUSE WHILE FETCHING THE ROWS FROM shexercisedoptions 
      SELECT * 
			  INTO   #tempautorev 
			  FROM   (SELECT formula 
					  FROM   autoreversalsettingdetails 
					  WHERE  isactivated = 1) AS x 

      DECLARE @WHERECLAUSE VARCHAR(max) 

      SELECT @WHERECLAUSE = COALESCE(@WHERECLAUSE + '+', '') + [formula] 
							FROM   #tempautorev 

      CREATE TABLE #temp_exercise_exceptions 
        ( 
           exerciseno INT 
        ) 

      INSERT INTO #temp_exercise_exceptions 
                  (exerciseno) 
      EXECUTE('(SELECT EXERCISENO  FROM SHEXERCISEDOPTIONS WHERE ('+@WHERECLAUSE 
      + 
      ')  > '+@TOTALAMOUNT+')')           
  
  END
	
	
	IF NOT EXISTS(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ShExercisedOptionsAutoRevOnlnEx')
	BEGIN
	CREATE TABLE ShExercisedOptionsAutoRevOnlnEx
	(
		[ExerciseId] [numeric](18, 0) PRIMARY KEY NOT NULL,
		[GrantLegSerialNumber] [numeric](18, 0) NULL,
		[ExercisedQuantity] [numeric](18, 0) NULL,
		[SplitExercisedQuantity] [numeric](18, 0) NULL,
		[BonusSplitExercisedQuantity] [numeric](18, 0) NULL,
		[ExercisePrice] [numeric](18, 2) NULL,
		[ExerciseDate] [datetime] NULL,
		[EmployeeID] [varchar](20) NULL,
		[LockedInTill] [datetime] NULL,
		[ExercisableQuantity] [numeric](18, 0) NULL,
		[ValidationStatus] [char](1) NULL,
		[Action] [char](1) NULL,
		[GrantLegId] [numeric](18, 0) NULL,
		[ExerciseNo] [numeric](18, 0) NULL,
		[LotNumber] [varchar](20) NULL,
		[DiscrepancyInformation] [varchar](200) NULL,
		[SharesIssuedDate] [datetime] NULL,
		[PerqstValue] [numeric](18, 6) NULL,
		[PerqstPayable] [numeric](18, 6) NULL,
		[FMVPrice] [numeric](18, 6) NULL,
		[isExerciseMailSent] [char](1) NULL,
		[DrawnOn] [datetime] NULL,
		[payrollcountry] [varchar](100) NULL,
		[IsMassUpload] [char](1) NULL,
		[LastUpdatedBy] [varchar](20) NULL,
		[LastUpdatedOn] [datetime] NULL,
		[Cash] [varchar](50) NULL,
		[FBTValue] [numeric](10, 2) NULL,
		[FBTPayable] [numeric](10, 2) NULL,
		[FBTPayBy] [varchar](20) NULL,
		[FBTDays] [int] NULL,
		[TravelDays] [int] NULL,
		[FBTTravelInfoYN] [char](1) NULL,
		[Perq_Tax_rate] [numeric](18, 2) NULL,
		[SharesArised] [numeric](18, 0) NULL,
		[FaceValue] [numeric](18, 2) NULL,
		[SARExerciseAmount] [numeric](18, 2) NULL,
		[StockApperciationAmt] [numeric](18, 2) NULL,
		[FMV_SAR] [numeric](18, 2) NULL,
		[ExerciseFormReceived] [varchar](10) NULL,
		[ReceivedDate] [datetime] NULL,
		[TaxRule] [varchar](5) NULL,
		[ExerciseSARid] [int] NULL,
		[Cheque_received_deposited] [char](1) NULL,
		[PaymentMode] [varchar](1) NULL,
		[CapitalGainTax] [decimal](18, 3) NULL,
		[CGTformulaID] [int] NULL,
		[PANStatus] [varchar](20) NULL,
		[CGTRateLT] [decimal](18, 9) NULL,
		[CGTUpdatedDate] [datetime] NULL,
		[IsPaymentDeposited] [bit] NULL,
		[PaymentDepositedDate] [datetime] NULL,
		[IsPaymentConfirmed] [bit] NULL,
		[PaymentConfirmedDate] [datetime] NULL,
		[IsExerciseAllotted] [bit] NULL,
		[ExerciseAllotedDate] [datetime] NULL,
		[IsAllotmentGenerated] [bit] NULL,
		[AllotmentGenerateDate] [datetime] NULL,
		[IsAllotmentGeneratedReversed] [bit] NULL,
		[AllotmentGeneratedReversedDate] [datetime] NULL,
		[GenerateAllotListUniqueId] [varchar](50) NULL,
		[GenerateAllotListUniqueIdDate] [datetime] NULL,
		[IsPayInSlipGenerated] [bit] NULL,
		[PayInSlipGeneratedDate] [datetime] NULL,
		[PayInSlipGeneratedUniqueId] [varchar](50) NULL,
		[IsTRCFormReceived] [tinyint] NULL,
		[TRCFormReceivedDate] [datetime] NULL,
		[TRCFormReceivedUpdatedBy] [varchar](100) NULL,
		[TRCFormReceivedUpdatedOn] [datetime] NULL,
		[IsForm10FReceived] [tinyint] NULL,
		[Form10FReceivedDate] [datetime] NULL,
		[isFormGenerate] [tinyint] NULL
	) 
	END
	
	CREATE TABLE #TempTransaction
	(
		MerchantreferenceNo NUMERIC (18, 0),
		Merchant_Code VARCHAR (50),
		ExerciseNo NUMERIC (18, 0),
		ExerciseId NUMERIC (18, 0),
		GrantLegSerialNumber NUMERIC (18, 0),
		Item_Code VARCHAR (50),
		Amount NUMERIC (18, 2),
		Tax_Amount NUMERIC (18, 2),
		Transaction_Date DATETIME,
		bankid VARCHAR (10),
		TPSLTransID VARCHAR (50),
		ExercisedQuantity NUMERIC (18, 0),
		EmployeeID VARCHAR (20),
		EmployeeName VARCHAR (75),
		EmployeeEmail VARCHAR (100),
		ExerciseDate DATETIME,
		MinuteDiff INT,
		CompanyEmailID VARCHAR (50),
		MailSubject VARCHAR (500),
		MailBody VARCHAR (8000)
	)

	-- Check Auto reversal of online exercises is enabled or not.
	IF (@AutoRevForOnlineEx = 1)
	BEGIN
		--If the company is AxisBank and the current time is between 11:45 pm to 11:55 pm then reverse those exercises.
		IF (UPPER(DB_NAME()) = 'AXISBANK' AND (CONVERT(TIME, GETDATE(),108) BETWEEN '23:44:59' AND '23:56:01'))
		BEGIN
			
			INSERT INTO #TempTransaction 
			(MerchantreferenceNo, Merchant_Code, ExerciseNo, ExerciseId, GrantLegSerialNumber, Item_Code, Amount, Tax_Amount, Transaction_Date, bankid, TPSLTransID, ExercisedQuantity, EmployeeID, EmployeeName, EmployeeEmail, ExerciseDate, MinuteDiff, CompanyEmailID, MailSubject, MailBody)
			-- Get data related to Exercises which need to be reversed.
			SELECT  TD.MerchantreferenceNo, TD.Merchant_Code, SEO.ExerciseNo, SEO.ExerciseId, 
					SEO.GrantLegSerialNumber,TD.Item_Code, TD.Amount, TD.Tax_Amount, TD.Transaction_Date, 
					TD.bankid, TD.TPSLTransID, SEO.ExercisedQuantity, SEO.EmployeeID, EM.EmployeeName, 
					EM.EmployeeEmail, SEO.ExerciseDate, DATEDIFF(MINUTE, SEO.ExerciseDate, GETDATE()) AS MinuteDiff,
					CM.CompanyEmailID, MM.MailSubject,
					REPLACE(REPLACE(REPLACE(MM.MailBody,'{0}',EM.EmployeeName),'{1}',SEO.ExerciseNo),'{2}',CM.CompanyEmailID) AS MailBody
			FROM	Transaction_Details TD
					RIGHT OUTER JOIN ShExercisedOptions SEO ON TD.Sh_ExerciseNo = SEO.ExerciseNo
					INNER JOIN GrantLeg GL ON SEO.GrantLegSerialNumber = GL.ID
					INNER JOIN EmployeeMaster EM ON SEO.EmployeeID = EM.EmployeeID
					CROSS JOIN MailMessages MM					
					CROSS JOIN CompanyMaster CM				
			WHERE	TD.BankReferenceNo IS NULL 
					AND (TD.Payment_status IS NULL OR TD.Payment_status <> 'S')
					AND (TD.Transaction_Status IS NULL OR TD.Transaction_Status <> 'Y')
					AND DATEDIFF(MINUTE, SEO.ExerciseDate, GETDATE()) > @AutoRevMinutes
					AND MM.Formats = 'OnlineExReversalAlert'
					AND (SEO.PaymentMode = 'N' OR SEO.PaymentMode = '' OR SEO.PaymentMode IS NULL)
			ORDER BY TD.MerchantreferenceNo
			
			IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'TempTransaction')
			BEGIN
				DROP TABLE TempTransaction
			END
			
			IF ((SELECT COUNT(ExerciseNo) FROM #TempTransaction) > 0)
			BEGIN
				DECLARE @FILE_NAME VARCHAR(50),
						@tab CHAR(1) = CHAR(9),
						@STR_QUERY VARCHAR(MAX)
				
				SELECT * INTO TempTransaction FROM #TempTransaction
				SET @FILE_NAME = 'AxisBank_AutoRevEx_' + CONVERT(VARCHAR(8), GETDATE(),112) + '.csv'
				
				SET @STR_QUERY = 'SELECT ExerciseNo, ExerciseId, ExercisedQuantity, EmployeeID, EmployeeName, EmployeeEmail, ExerciseDate FROM ' + DB_NAME()  + '..TempTransaction'
				
				EXECUTE 
					msdb.dbo.sp_send_dbmail 
					@from_address = 'noreply@esopdirect.com',		
					@recipients = 'walter@esopdirect.com;lopa@esopdirect.com;axisbank@esopdirect.com',
					@blind_copy_recipients = 'dev@esopdirect.com',
					@subject = 'AXISBANK : Auto Reversal of the Exercises', 
					@body = 'PFA list of exercises those are auto reversed by the system.',		
					@body_format = 'HTML',
					@query = @STR_QUERY, 
					@attach_query_result_as_file = 1,
					@query_attachment_filename =  @FILE_NAME,
					@query_result_separator = @tab,
					@query_result_no_padding = 1
			END
		END
		
		ELSE
		BEGIN
			INSERT INTO #TempTransaction 
			(MerchantreferenceNo, Merchant_Code, ExerciseNo, ExerciseId, GrantLegSerialNumber, Item_Code, Amount, Tax_Amount, Transaction_Date, bankid, TPSLTransID, ExercisedQuantity, EmployeeID, EmployeeName, EmployeeEmail, ExerciseDate, MinuteDiff, CompanyEmailID, MailSubject, MailBody)
			-- Get data related to Exercises which need to be reversed.
			SELECT	TD.MerchantreferenceNo, TD.Merchant_Code, SEO.ExerciseNo, SEO.ExerciseId, 
					SEO.GrantLegSerialNumber,TD.Item_Code, TD.Amount, TD.Tax_Amount, TD.Transaction_Date, 
					TD.bankid, TD.TPSLTransID, SEO.ExercisedQuantity, SEO.EmployeeID, EM.EmployeeName, 
					EM.EmployeeEmail, SEO.ExerciseDate, DATEDIFF(MINUTE, SEO.ExerciseDate, GETDATE()) AS MinuteDiff,
					CM.CompanyEmailID, MM.MailSubject,
					REPLACE(REPLACE(REPLACE(MM.MailBody,'{0}',EM.EmployeeName),'{1}',SEO.ExerciseNo),'{2}',CM.CompanyEmailID) AS MailBody				
			FROM	Transaction_Details TD
					RIGHT OUTER JOIN ShExercisedOptions SEO ON TD.Sh_ExerciseNo = SEO.ExerciseNo
					INNER JOIN GrantLeg GL ON SEO.GrantLegSerialNumber = GL.ID
					INNER JOIN EmployeeMaster EM ON SEO.EmployeeID = EM.EmployeeID
					CROSS JOIN MailMessages MM
					CROSS JOIN CompanyMaster CM				
			WHERE	TD.BankReferenceNo IS NULL 
					AND (TD.Payment_status IS NULL OR TD.Payment_status <> 'S')
					AND (TD.Transaction_Status IS NULL OR TD.Transaction_Status <> 'Y')
					AND DATEDIFF(MINUTE, SEO.ExerciseDate, GETDATE()) > @AutoRevMinutes
					AND MM.Formats = 'OnlineExReversalAlert'
					AND SEO.PaymentMode = 'N'				
			ORDER BY TD.MerchantreferenceNo
		END
		
		IF ((SELECT isexceptionactivated FROM autoreversalconfigmaster) = 1) 
		BEGIN 
			DELETE TT FROM #TempTransaction TT 			
			INNER JOIN #TEMP_EXERCISE_EXCEPTIONS Temp ON Temp.ExerciseNo = TT.ExerciseNo
			
			DROP TABLE #TEMP_EXERCISE_EXCEPTIONS
			DROP TABLE #TEMPAutoRev
		END
						
		-- Check if there exist any Exercises which need to be reversed.
		IF ((SELECT COUNT(ExerciseNo) FROM #TempTransaction) > 0)
		BEGIN
		
			CREATE TABLE #TEMP_GL
			(
				ID INT,
				ExercisedQuantity NUMERIC(18,0)
			)
			
			-- Temporary table which will hold details of reversal alert mails to be sent.
			CREATE TABLE #Reversal_Mail_Alert
			(
				Message_ID NUMERIC(18,0) IDENTITY(1,1) NOT NULL,
				CompanyEmail VARCHAR(50),
				EmployeeEmail VARCHAR(50),
				MailSubject VARCHAR(250),
				MailBody TEXT
			)	
		
			INSERT INTO #TEMP_GL (ID, ExercisedQuantity)	
			SELECT DISTINCT GrantLegSerialNumber, SUM(ExercisedQuantity) ExercisedQuantity
			FROM #TempTransaction
			GROUP BY GrantLegSerialNumber		
			
			-- Reset the identity of #Reversal_Mail_Alert table such that it will match MessageID in MailSpool table.
			SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)	
			DBCC CHECKIDENT(#Reversal_Mail_Alert, RESEED, @MaxMsgId)	
			
			INSERT INTO #Reversal_Mail_Alert (CompanyEmail, EmployeeEmail, MailSubject, MailBody)
			SELECT DISTINCT CompanyEmailID, EmployeeEmail, MailSubject, MailBody
			FROM #TempTransaction	
			
			BEGIN TRY
			
				BEGIN TRANSACTION
					
					BEGIN TRY
						INSERT INTO ShExercisedOptionsAutoRevOnlnEx
						(ExerciseId, GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisePrice, ExerciseDate, EmployeeID, LockedInTill, ExercisableQuantity, ValidationStatus, Action, GrantLegId, ExerciseNo, LotNumber, DiscrepancyInformation, SharesIssuedDate, PerqstValue, PerqstPayable, FMVPrice, isExerciseMailSent, DrawnOn, payrollcountry, IsMassUpload, LastUpdatedBy, LastUpdatedOn, Cash, FBTValue, FBTPayable, FBTPayBy, FBTDays, TravelDays, FBTTravelInfoYN, Perq_Tax_rate, SharesArised, FaceValue, SARExerciseAmount, StockApperciationAmt, FMV_SAR, ExerciseFormReceived, ReceivedDate, TaxRule, ExerciseSARid, Cheque_received_deposited, PaymentMode, CapitalGainTax, CGTformulaID, PANStatus, CGTRateLT, CGTUpdatedDate, IsPaymentDeposited, PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, GenerateAllotListUniqueId, GenerateAllotListUniqueIdDate, IsPayInSlipGenerated, PayInSlipGeneratedDate, PayInSlipGeneratedUniqueId, IsTRCFormReceived, TRCFormReceivedDate, TRCFormReceivedUpdatedBy, TRCFormReceivedUpdatedOn, IsForm10FReceived, Form10FReceivedDate, isFormGenerate)									
						SELECT ExerciseId, GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisePrice, ExerciseDate, EmployeeID, LockedInTill, ExercisableQuantity, ValidationStatus, Action, GrantLegId, ExerciseNo, LotNumber, DiscrepancyInformation, SharesIssuedDate, PerqstValue, PerqstPayable, FMVPrice, isExerciseMailSent, DrawnOn, payrollcountry, IsMassUpload, LastUpdatedBy, LastUpdatedOn, Cash, FBTValue, FBTPayable, FBTPayBy, FBTDays, TravelDays, FBTTravelInfoYN, Perq_Tax_rate, SharesArised, FaceValue, SARExerciseAmount, StockApperciationAmt, FMV_SAR, ExerciseFormReceived, ReceivedDate, TaxRule, ExerciseSARid, Cheque_received_deposited, PaymentMode, CapitalGainTax, CGTformulaID, PANStatus, CGTRateLT, CGTUpdatedDate, IsPaymentDeposited, PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, GenerateAllotListUniqueId, GenerateAllotListUniqueIdDate, IsPayInSlipGenerated, PayInSlipGeneratedDate, PayInSlipGeneratedUniqueId, IsTRCFormReceived, TRCFormReceivedDate, TRCFormReceivedUpdatedBy, TRCFormReceivedUpdatedOn, IsForm10FReceived, Form10FReceivedDate, isFormGenerate
						FROM ShExercisedOptions WHERE ExerciseId IN (SELECT ExerciseId FROM #TempTransaction) 
					END TRY
					
					BEGIN CATCH
						DECLARE @MAIL_BODY AS VARCHAR(200)
						SET @MAIL_BODY = '<html><body><font face="Calibri" size="3">Error while inserting rows in ShExercisedOptionsAutoRevOnlnEx in ' + (select DB_NAME()) + ' </font>	</body></html>'
						EXEC msdb.dbo.sp_send_dbmail  
							@recipients = 'amin.mutawlli@esopdirect.com;santosh@esopdirect.com',												
							@body = @MAIL_BODY,
							@body_format = 'HTML',
							@subject = 'Error while inserting rows in ShExercisedOptionsAutoRevOnlnEx',
							@from_address = 'noreply@esopdirect.com' ;
					END CATCH
					-- Delete entries from 'Transaction_Details' and 'ShExercisedOptions' tables.
					DELETE FROM Transaction_Details WHERE MerchantreferenceNo IN (SELECT DISTINCT MerchantreferenceNo FROM #TempTransaction WHERE MerchantreferenceNo IS NOT NULL)
					DELETE FROM ShExercisedOptions WHERE ExerciseId IN (SELECT ExerciseId FROM #TempTransaction)
					
					-- Update Grantleg table
					UPDATE GL SET ExercisableQuantity = ExercisableQuantity + Temp.ExercisedQuantity, UnapprovedExerciseQuantity = UnapprovedExerciseQuantity - Temp.ExercisedQuantity
					FROM GrantLeg GL 
					INNER JOIN #TEMP_GL Temp ON GL.ID = Temp.ID			
					
					-- Insert into MailSpool to send email.
					INSERT INTO MailerDB..MailSpool
					([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
					SELECT Message_ID, CompanyEmail, EmployeeEmail, MailSubject, MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() 
					FROM #Reversal_Mail_Alert
					WHERE (MailBody IS NOT NULL)
					
					-- Insert data related to reversed exercises in the audit trail table.
					BEGIN TRY
					
						INSERT INTO AuditTrailAutoReverseOnlineEx
							(MerchantreferenceNo, Merchant_Code, Sh_ExerciseNo, ExerciseId, 
							GrantLegSerialNumber, Item_Code, Amount, Tax_Amount, Transaction_Date, 
							bankid, TPSLTransID, ExercisedQuantity, EmployeeID, EmployeeName, 
							EmployeeEmail, ExerciseDate, InsertedOn)
							SELECT MerchantreferenceNo, Merchant_Code, ExerciseNo, ExerciseId, 
								   GrantLegSerialNumber, Item_Code, Amount, Tax_Amount, Transaction_Date, 
								   bankid, TPSLTransID, ExercisedQuantity, EmployeeID, EmployeeName, 
								   EmployeeEmail, ExerciseDate, GETDATE()
							FROM   #TempTransaction
							
					END TRY
					BEGIN CATCH
						-- Do nothing.
					END CATCH
					
				COMMIT TRANSACTION
				
			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT > 0			
					ROLLBACK TRANSACTION
			END CATCH
			DROP TABLE #TEMP_GL
			DROP TABLE #Reversal_Mail_Alert	
				
		END
		DROP TABLE #TempTransaction
		
		
	END
	
	SET NOCOUNT OFF;

END
GO
