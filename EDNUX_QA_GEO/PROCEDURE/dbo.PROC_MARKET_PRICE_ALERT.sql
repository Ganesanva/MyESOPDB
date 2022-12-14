/****** Object:  StoredProcedure [dbo].[PROC_MARKET_PRICE_ALERT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_MARKET_PRICE_ALERT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_MARKET_PRICE_ALERT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_MARKET_PRICE_ALERT] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	DECLARE @LastestClosingMarktePrice VARCHAR(50)
	DECLARE @CompanyName NVARCHAR(50)
	DECLARE @CompanyEmailID NVARCHAR(200)
	DECLARE @MailSubject NVARCHAR(500)
	DECLARE @MailBody NVARCHAR(MAX)	
	DECLARE @MaxMsgId BIGINT
	
	SET NOCOUNT ON;
	
	BEGIN
	
		----------------------------------
		-- GET LATEST CLOSING MARKET PRICE 
		----------------------------------
		SET @LastestClosingMarktePrice = NULL
		
		SET @LastestClosingMarktePrice = (SELECT ClosePrice FROM SharePrices WHERE PriceDate IN (SELECT MAX(PriceDate) FROM SharePrices))
		--PRINT @LastestClosingMarktePrice
		
		IF (@LastestClosingMarktePrice IS NULL)
			BEGIN
				SELECT 'Latest closing market price not found' AS MSG 
			END
		ELSE
			BEGIN
				SELECT 'Latest closing market price found' AS MSG 
			END
	
	END

	BEGIN
	
		---------------------
		-- CREATE TEMP TABLES
		---------------------
		
		CREATE TABLE #Market_Price_Alert
		(
			Message_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EmployeeId NVARCHAR(50), TriggerSharePrice NVARCHAR(50), EmployeeName NVARCHAR(200), EmployeeEmail NVARCHAR(200),
			CompanyName NVARCHAR(100), CompanyEmail NVARCHAR(200), LatestClosingMarketPrice NVARCHAR(50), MailSubject NVARCHAR(500),
			MailBody NVARCHAR(MAX)			
		)
	
	END
	
	BEGIN
		
		---------------------------------------------------------
		-- GET COMPANY NAME AND COMPANY EMAIL ID
		---------------------------------------------------------
		
		SELECT @CompanyName = CompanyID, @CompanyEmailID = CompanyEmailID FROM CompanyParameters
		--PRINT 'Company Name : ' + @CompanyName +', Company Email Id : '+@CompanyEmailID
		
		---------------------------------------------------------
		-- GET MARKET PRICE ALERT DETAILS FROM MailMessages TABLE
		---------------------------------------------------------
		
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'MARKETPRICEALERT'
		--PRINT 'Subject : '+ @MailSubject +' Mail Body : '+ @MailBody

		----------------------------------------------------------------
		-- GET MAX MESSAGE FROM MAIL SPOOL TABLE FROM MAILER DB DATABESE
		----------------------------------------------------------------
		
		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
		BEGIN
			DBCC CHECKIDENT(#Market_Price_Alert, RESEED, @MaxMsgId) 
		END
	
	END
	
	BEGIN
		-----------------------------------------------
		-- GET MARKET PRICE ALERT DETAILS FOR SEND MAIL
		-----------------------------------------------
		
		INSERT INTO #Market_Price_Alert (EmployeeId, TriggerSharePrice, EmployeeName, EmployeeEmail, CompanyName, CompanyEmail, LatestClosingMarketPrice, MailSubject, MailBody)
		SELECT EM.EmployeeID, SA.TriggerSharePrice, EM.EmployeeName, EM.EmployeeEmail, @CompanyName, @CompanyEmailID, @LastestClosingMarktePrice, @MailSubject, 
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@MailBody, '{0}', EM.EmployeeName),'{1}',@CompanyName),'{2}',SA.TriggerSharePrice),'{3}',@LastestClosingMarktePrice),'{4}',@CompanyEmailID)
		FROM EmployeeMaster AS EM 
		INNER JOIN SetAlert AS SA ON EM.EmployeeID = SA.EmployeeID
		INNER JOIN UserMaster AS UM ON EM.EmployeeID = UM.EmployeeId
		LEFT OUTER JOIN GrantOptions AS GOP ON EM.EmployeeID = GOP.EmployeeId
		INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId = GL.GrantOptionId
		WHERE (UM.IsUserActive = 'Y') AND ((EM.ReasonForTermination='2') OR (EM.DateOfTermination IS NULL))
		AND (SA.IsMailSentForPrice='1') 
		AND (SA.TriggerSharePrice < @LastestClosingMarktePrice)
		GROUP BY EM.EmployeeID, SA.TriggerSharePrice, EM.EmployeeName, EM.EmployeeEmail, EM.ReasonForTermination, EM.DateOfTermination
		HAVING (ISNULL(SUM(GL.GrantedOptions),0) > 0)
		ORDER BY EM.EmployeeID ASC 
		
		SELECT Message_ID, EmployeeId, TriggerSharePrice, EmployeeName, EmployeeEmail, CompanyName, CompanyEmail, LatestClosingMarketPrice, MailSubject, MailBody FROM #Market_Price_Alert
		
	END
	
	BEGIN
		IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #Market_Price_Alert) > 0)	
		BEGIN
			BEGIN TRY
					
				BEGIN TRANSACTION
				--------------------------------------------------------------------
				-- INSERT MAIL DETAILS INTO MAIL SPOOL TABLE FROM MAILER DB DATABASE
				--------------------------------------------------------------------				
				INSERT INTO [MailerDB].[dbo].[MailSpool]
				([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], [Attachment3], [Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], [Bcc], [FailureSendMailAttempt], [CreatedOn])
				SELECT Message_ID, CompanyEmail, EmployeeEmail, MailSubject, MailBody, NULL, NULL, NULL, NULL, NULL, NULL, 'N', 'N', NULL, NULL, GETDATE() FROM #Market_Price_Alert
				WHERE (MailBody IS NOT NULL)
				
				UPDATE SA SET SA.IsMailSentForPrice = '0' FROM SetAlert AS SA 
				INNER JOIN #Market_Price_Alert AS MPA ON MPA.EmployeeId = SA.EmployeeID WHERE (MPA.MailBody IS NOT NULL)
				
				COMMIT TRANSACTION
			
			END TRY
			BEGIN CATCH
						
				IF @@TRANCOUNT > 0			
					ROLLBACK TRANSACTION
				
				SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
					
			END CATCH
		END	
	END
	
	SET NOCOUNT OFF;
END



GO
