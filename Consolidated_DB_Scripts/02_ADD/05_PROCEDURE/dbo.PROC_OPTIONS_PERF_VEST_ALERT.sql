DROP PROCEDURE IF EXISTS [PROC_OPTIONS_PERF_VEST_ALERT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_OPTIONS_PERF_VEST_ALERT]    Script Date: 18-07-2022 15:20:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [PROC_OPTIONS_PERF_VEST_ALERT] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	DECLARE @ReminderPerfVestAlert VARCHAR(5)
	DECLARE @BeforePerfVestDateYN CHAR(1)
	DECLARE @SendPerfVestAlertYN CHAR(1)
	DECLARE @CompanyName VARCHAR(50)
	DECLARE @CompanyEmailID VARCHAR(200)
	DECLARE @MailSubject NVARCHAR(500)
	DECLARE @MailBody NVARCHAR(MAX)	
	DECLARE @FILENAME NVARCHAR(500)
	DECLARE @STR_QUERY VARCHAR(MAX)
	DECLARE @VESING_DATE DATETIME
	DECLARE @DROP_QUERY VARCHAR(1000)
	
	SET NOCOUNT ON;
	
	----------------------------------------------------
	-- GET DETAILS FORM COMPANY PARAMETER / MASTER TABLE
	----------------------------------------------------
	
	SELECT @ReminderPerfVestAlert = ReminderPerformanceVestingAlert, @BeforePerfVestDateYN = BeforePerfVestDateYN, @SendPerfVestAlertYN = ISNULL(SendPerfVestAlertYN,'Y') FROM CompanyParameters
	--PRINT 'ReminderPerformanceVestingAlert : '+@ReminderPerfVestAlert +', BeforePerfVestDateYN : '+@BeforePerfVestDateYN +', SendPerfVestAlertYN : '+@SendPerfVestAlertYN
	
	SELECT @CompanyName = CompanyID, @CompanyEmailID = CompanyEmailID FROM CompanyParameters
	--PRINT 'Company Name : ' + @CompanyName +', Company Email Id : '+@CompanyEmailID
	
	--------------------
	-- CREATE TEMP TABLE
	--------------------
	
	CREATE TABLE #OPTION_PERF_VEST_ALERT
	(
		EmployeeId NVARCHAR(50), EmployeeName NVARCHAR(200), GrantOptionId NVARCHAR(100), FinalVestingDate DATETIME, GrantedOptions NUMERIC(18,2),
		GrantLegId VARCHAR(5), Parent VARCHAR(5)		
	)
	
	--------------------------------------------
	-- CHECK REMINDER COLUMN SHOULD NOT BE BLANK
	--------------------------------------------
	
	IF(@ReminderPerfVestAlert IS NOT NULL AND @SendPerfVestAlertYN = 'Y')	
	BEGIN
		
		---------------------------------------------------------
		-- GET COMPANY NAME AND COMPANY EMAIL ID
		---------------------------------------------------------
		
		SELECT @MailSubject = MailSubject, @MailBody = MailBody FROM MailMessages WHERE UPPER(Formats) = 'OPTIONPERFVESTALERT'
		SET @MailBody = REPLACE(@MailBody,'{0}',@CompanyName)
		--PRINT 'Subject : '+ @MailSubject +' Mail Body : '+ @MailBody
	
		------------------------------------------------
		-- INSERT OPTION PERF VEST ALERT INTO TEMP TABLE
		------------------------------------------------
		
		INSERT INTO #OPTION_PERF_VEST_ALERT (EmployeeId, EmployeeName, GrantOptionId, FinalVestingDate,GrantedOptions, GrantLegId, Parent)
		SELECT GrOp.EmployeeId, EmployeeMaster.EmployeeName, GrOp.GrantOptionId, GrLg.FinalVestingDate, GrLg.GrantedOptions, GrLg.GrantLegId, GrLg.Parent
		FROM GrantOptions AS GrOp 
		INNER JOIN GrantLeg AS GrLg ON GrOp.GrantOptionId = GrLg.GrantOptionId 
		INNER JOIN VestingPeriod AS VePe ON GrOp.GrantRegistrationId = VePe.GrantRegistrationId AND GrLg.VestingPeriodId = VePe.VestingPeriodId 
		INNER JOIN EmployeeMaster ON GrOp.EmployeeId = EmployeeMaster.EmployeeID 
		WHERE (GrLg.FinalVestingDate <= GETDATE()) AND (GrLg.IsPerfBased = 'N') AND (GrLg.[Status] = 'A') AND (GrLg.VestingType = 'P') AND (GrLg.ExpiryPerformed IS NULL)
		AND (DATEDIFF(D,CONVERT(DATE,GrLg.FinalVestingDate), CONVERT(DATE,GETDATE())) = @ReminderPerfVestAlert) 
		ORDER BY EmployeeID ASC 

		IF EXISTS (SELECT name FROM sys.tables WHERE NAME = N'OPTION_PERF_VEST_ALERT' AND TYPE = 'U')
		BEGIN
			DROP TABLE OPTION_PERF_VEST_ALERT
		END
				
		SELECT * INTO OPTION_PERF_VEST_ALERT FROM #OPTION_PERF_VEST_ALERT
		
		SELECT EmployeeId, EmployeeName, GrantOptionId, FinalVestingDate,GrantedOptions, GrantLegId, Parent FROM #OPTION_PERF_VEST_ALERT
		
		SET @MailBody = REPLACE(@MailBody,'{2}',(SELECT EmployeeName FROM #OPTION_PERF_VEST_ALERT))	
		---------------------------------------------
		-- PREPARED QUERY FOR MAIL SEND FUNCTIONALITY
		---------------------------------------------
		
		SET @STR_QUERY = 'SELECT EmployeeId, EmployeeName, GrantOptionId, FinalVestingDate,GrantedOptions, GrantLegId, Parent FROM '+@CompanyName+'..OPTION_PERF_VEST_ALERT'
		
		-------------------
		-- GET VESTING DATE
		-------------------
		
		SET @VESING_DATE = (SELECT FinalVestingDate FROM #OPTION_PERF_VEST_ALERT GROUP BY FinalVestingDate)
		
		----------------------------------
		-- PREPARED SUBJECT FOR MAIL ALERT
		----------------------------------
		
		SET @FILENAME = RTRIM(RTRIM(@CompanyName) + 'PendingPerformanceVestingDetails' + CONVERT(VARCHAR(100),GETDATE(),105) + 'ForVestingOn ') + CONVERT(VARCHAR(100),@VESING_DATE,105)+'.csv'		
		--PRINT @FILENAME
				
		--------------------------------------
		-- SEND MAIL TO RESPECTIVE COMPANY CR
		--------------------------------------
		
		IF((SELECT COUNT(FinalVestingDate) FROM #OPTION_PERF_VEST_ALERT) > 0)		
		BEGIN
			DECLARE @tab CHAR(1) = CHAR(9)
			EXECUTE 
				msdb.dbo.sp_send_dbmail 		
				@recipients = @CompanyEmailID, 		
				@subject = @MailSubject, 
				@body = @MailBody,		
				@body_format = 'HTML',
				@query = @STR_QUERY, 
				@attach_query_result_as_file = 1,
				@query_attachment_filename = @FILENAME, 
				@query_result_separator = @tab,
				@query_result_no_padding = 1
		END		
	END
	
	IF EXISTS (SELECT name FROM sys.tables WHERE NAME = N'OPTION_PERF_VEST_ALERT' AND TYPE = 'U')
	BEGIN
		DROP TABLE OPTION_PERF_VEST_ALERT
	END
	
	SET NOCOUNT OFF;
END
GO


