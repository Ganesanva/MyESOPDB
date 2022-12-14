/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_LOGIN]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_LOGIN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_LOGIN]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_LOGIN] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @TEMP_QUANTITY VARCHAR(1000)
	DECLARE @UPDATE_QUERY1 VARCHAR(1000)
	DECLARE @MAILFORMAT VARCHAR(100) = 'ExEmployeeAlert',@MAILSUBJECT VARCHAR(1000),@MAILBODY VARCHAR(MAX)
	DECLARE @MESSAGES_ID BIGINT
	DECLARE @ISSSOACTIVATED BIT = 0,@ISHRMSENABLED BIT,
			@MaxMsgId BIGINT,
			@CompanyEmailId VARCHAR(100)
	
	IF (@CompanyId IS NULL)
	BEGIN
		SET @CompanyId = (SELECT UPPER(DB_NAME()))
	END
	
	----------------------------
	-- CHECK AND SET BONUS SPLIT POLICY
	---------------------------	
	
	BEGIN
	
		DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
		SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
					
		IF(@ApplyBonusTo='V')
			BEGIN
				IF(@ApplySplitTo='V')
					BEGIN
						-- Set Parameter GrantedQuantity, ExercisedQuantity, CancelledQuantity,
						SET @TEMP_QUANTITY = 'VW.GrantedQuantity - VW.CancelledQuantity - VW.ExercisedQuantity - VW.LapsedQuantity'
					END
				ELSE 
					BEGIN
						-- Set Parameter SplitQuantity, SplitExercisedQuantity, SplitCancelledQuantity, 												
						SET @TEMP_QUANTITY = 'VW.SplitQuantity - VW.SplitCancelledQuantity - VW.SplitExercisedQuantity - VW.LapsedQuantity'
					END
			END
		ELSE
			 BEGIN
					-- Set Parameter BonusSplitQuantity, BonusSplitExercisedQuantity, BonusSplitCancelledQuantity, 
				SET @TEMP_QUANTITY = 'VW.BonusSplitQuantity - VW.BonusSplitCancelledQuantity - VW.BonusSplitExercisedQuantity - VW.LapsedQuantity'
			 END	
	
	END
		
	-- CREATE TEMP TABLE FOR COLLECT EMPLOYEE EXPIRYIES DETAILS	
	
	BEGIN
		
		CREATE TABLE #EMPLOYEE_LOGIN_DATA
		(
			Expiry_LAPSE_ID NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EmployeeId NVARCHAR(50), GrantApprovalId NVARCHAR(50), ID NVARCHAR(50), GrantOptionId NVARCHAR(100), GrantLegId NVARCHAR(50), 
			VestingType NVARCHAR(10), SeperationCancellationDate DATETIME, SeparationPerformed NVARCHAR(50), GrantedOptions NUMERIC(18,0), 
			GrantedQuantity NUMERIC(18,0), SplitQuantity NUMERIC(18,0), BonusSplitQuantity NUMERIC(18,0), 
			CancelledQuantity NUMERIC(18,0), SplitCancelledQuantity NUMERIC(18,0), BonusSplitCancelledQuantity NUMERIC(18,0), 
			ExercisedQuantity NUMERIC(18,0), SplitExercisedQuantity NUMERIC(18,0), BonusSplitExercisedQuantity NUMERIC(18,0), 
			ExercisableQuantity NUMERIC(18,0), LapsedQuantity NUMERIC(18,0), UnapprovedExerciseQuantity NUMERIC(18,0), FinalExpirayDate DATETIME,	
			ExpiryPerformed NVARCHAR(10), IsPerfBased NVARCHAR(10), DateOfTermination DATETIME, IsUserActive NVARCHAR(10), 
			ApprovalStatus NVARCHAR(10), [Status] NVARCHAR(10), Expiry_Lapse_Quantity NUMERIC(18,0), Expiry_Lapse_Date DATETIME, 
			TempSum NUMERIC(18,0),[EmployeeEmail] VARCHAR(100),LWD DATETIME,EmployeeName NVARCHAR(100),LoginID NVARCHAR(100)
		)
		
		CREATE TABLE #TEMP_MAIL_ALERT_EX_EMP
		(
			[Message_ID]		NUMERIC(18,0) IDENTITY (1, 1) NOT NULL, 
			EMPLOYEEID			VARCHAR(20) NULL,			
			ISMAILSENT			BIT NULL,
			MAIL_SUBJECT		VARCHAR(1000) NULL,
			MAIL_BODY			VARCHAR(MAX) NULL,
			LASTUPDATEDBY		VARCHAR(20) NULL,
			LASTUPDATEDON		DATETIME,
			IsSSOActivated		BIT NULL,
			IsHRMSEnabled		BIT NULL,
			[CompanyId]			VARCHAR(100) NOT NULL,
			[From]				VARCHAR(100), -- Company Email Id
			[EmployeeEmail]		VARCHAR(100), -- [To] means Employee Email Id
			[EmployeeName]		VARCHAR(100),
			[DOT]				DATE,
			[USERID]			VARCHAR(100)
		) 

		INSERT INTO #EMPLOYEE_LOGIN_DATA 	
		(	
			EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeperationCancellationDate, SeparationPerformed, 
			GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, 
			BonusSplitCancelledQuantity, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, 
			LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate, ExpiryPerformed, IsPerfBased, DateOfTermination, 
			IsUserActive, ApprovalStatus, [Status],[EmployeeEmail],LWD,EmployeeName,LoginID
		)
		SELECT	EmployeeId, GrantApprovalId, ID, GrantOptionId, GrantLegId, VestingType, SeperationCancellationDate, SeparationPerformed, 
				GrantedOptions, GrantedQuantity, SplitQuantity, BonusSplitQuantity, CancelledQuantity, SplitCancelledQuantity, 
				BonusSplitCancelledQuantity, ExercisedQuantity,	SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisableQuantity, 
				LapsedQuantity, UnapprovedExerciseQuantity, FinalExpirayDate, ExpiryPerformed, IsPerfBased, DateOfTermination, 
				IsUserActive, ApprovalStatus, [Status],EmployeeEmail,LWD,EmployeeName,UserId 
		FROM	[VW_GrantLegDetails] AS VW 
		WHERE	(VW.DateOfTermination IS NOT NULL) AND (VW.IsUserActive='Y')	

		SET @UPDATE_QUERY1 = 
			' UPDATE TEMP SET TempSum = '+ @TEMP_QUANTITY +' FROM #EMPLOYEE_LOGIN_DATA AS TEMP
			INNER JOIN [VW_GrantLegDetails] AS VW ON TEMP.ID = VW.ID '	
		EXECUTE (@UPDATE_QUERY1)
		
		--SELECT * FROM #EMPLOYEE_LOGIN_DATA
		SELECT  @MAILSUBJECT = MailSubject, @MAILBODY = MailBody FROM MailMessages WHERE Formats = @MAILFORMAT
		SELECT	@ISSSOACTIVATED = IsSSOActivated, @ISHRMSENABLED = IsHRMSEnabled, @CompanyEmailId = CompanyEmailID FROM CompanyMaster 
		
		SET @MaxMsgId = (SELECT ISNULL(MAX(MessageID),0) + 1 AS MessageID FROM MailerDB..MailSpool)
		
		BEGIN
			DBCC CHECKIDENT(#TEMP_MAIL_ALERT_EX_EMP, RESEED, @MaxMsgId) 
		END	
		
		INSERT INTO #TEMP_MAIL_ALERT_EX_EMP
		(
			EMPLOYEEID,ISMAILSENT,MAIL_SUBJECT,MAIL_BODY,LASTUPDATEDBY,LASTUPDATEDON,
			IsSSOActivated,IsHRMSEnabled,[CompanyId],[From],[EmployeeEmail],[EmployeeName],[DOT],[USERID] 
		)
		SELECT DISTINCT	E.EmployeeId,1, @MAILSUBJECT, @MAILBODY, 'Admin', GETDATE(), @ISSSOACTIVATED, 
				@ISHRMSENABLED,  @CompanyId, @CompanyEmailId,E.EmployeeEmail,E.EmployeeName, E.DateOfTermination, E.LoginID
		FROM	#EMPLOYEE_LOGIN_DATA E				
		WHERE	@ISSSOACTIVATED = 1 AND @ISHRMSENABLED = 1 AND E.ExercisableQuantity > 0 
		AND		CONVERT(DATE, E.DateOfTermination) <= CONVERT(DATE, GETDATE())
		AND		CONVERT(DATE, E.LWD) <= CONVERT(DATE, GETDATE())
		AND		E.EMPLOYEEID NOT IN (SELECT A.EMPLOYEEID FROM AUDIT_ALERT_TO_EXEMPLOYEE A WHERE A.ISMAILSENT = 1)
	
	END
	
	BEGIN
	
		CREATE TABLE #EMPLOYEE_LOGIN_DETAILS_DATA
		(
			EmployeeId NVARCHAR(50), TempSum NUMERIC(18,0), IsEmployeeBlock CHAR(1)
		)
		
		INSERT INTO #EMPLOYEE_LOGIN_DETAILS_DATA
		(
			EmployeeId, TempSum, IsEmployeeBlock
		)
		
		SELECT EmployeeId, SUM(TempSum) AS TempSum, (CASE WHEN SUM(TempSum) = 0 THEN 'N' ELSE 'Y' END) AS IsEmployeeBlock FROM #EMPLOYEE_LOGIN_DATA 
		GROUP BY EmployeeId HAVING SUM(TempSum) = 0
	
	END
	
	SELECT EmployeeId, TempSum, IsEmployeeBlock FROM #EMPLOYEE_LOGIN_DETAILS_DATA
	
	IF((SELECT COUNT(EmployeeId) AS ROW_COUNT FROM #EMPLOYEE_LOGIN_DETAILS_DATA) > 0)
		BEGIN
			BEGIN TRY				
								
				UPDATE UM SET UM.IsUserActive = TEMP.IsEmployeeBlock, UM.LastUpdatedBy = 'ADMIN', UM.LastUpdatedOn = GETDATE() FROM UserMaster AS UM
				INNER JOIN #EMPLOYEE_LOGIN_DETAILS_DATA AS TEMP ON TEMP.EmployeeId = UM.EmployeeId
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
			PRINT 'NO DATA AVAILABLE FOR BLOCK EMPLOYEE'
		END
			
	
	/************************************************************/
	-- Send Mail to Snapdeal Ex Employee Based on few Conditions
	-- 1. SSO Feature is Enabled
	-- 2. IsHRMS Feature is Enabled
	-- 3. DOT, LWD is Marked 
	--SELECT DISTINCT EMPLOYEEID,EmployeeName,[USERID],REPLACE(CONVERT(VARCHAR(11),[DOT],106),' ','/') AS [DOT],
	--		ISMAILSENT,MAIL_SUBJECT, MAIL_BODY, 'Admin' AS [UpdatedBy],GETDATE() AS [UpdatedOn],CompanyId
	--		FROM #TEMP_MAIL_ALERT_EX_EMP TEmp
	/************************************************************/
	BEGIN
		IF (((SELECT COUNT(EMPLOYEEID) FROM #TEMP_MAIL_ALERT_EX_EMP) > 0))
		BEGIN
			--Audit table record insertion query
			INSERT INTO AUDIT_ALERT_TO_EXEMPLOYEE
			( 
				EMPLOYEEID, ISMAILSENT, MAIL_SUBJECT, MAIL_BODY, LASTUPDATEDBY, LASTUPDATEDON
			)
			SELECT	DISTINCT EMPLOYEEID,ISMAILSENT,MAIL_SUBJECT,	
					REPLACE(REPLACE(REPLACE(REPLACE(MAIL_BODY,'{0}',EmployeeName),'{1}',
					REPLACE(CONVERT(VARCHAR(11),[DOT],106),' ','/')),'{2}',CompanyId),'{3}',USERID),
					'Admin',GETDATE()
			FROM #TEMP_MAIL_ALERT_EX_EMP TEmp
			
			-- Mail spool table data insertion query
			
			INSERT INTO [MailerDB]..[MailSpool]
				([MessageID], [From], [To], [Subject], [Description], [Attachment1], [Attachment2], 
				[Attachment3],[Attachment4], [MailSentOn], [Cc], [enablereadreceipt], [deliveryNotify], 
				[Bcc], [FailureSendMailAttempt], [CreatedOn])
			SELECT	Message_ID, [From], [EmployeeEmail], MAIL_SUBJECT,
					REPLACE(REPLACE(REPLACE(REPLACE(MAIL_BODY,'{0}',EmployeeName),'{1}',REPLACE(CONVERT(VARCHAR(11),[DOT],106),' ','/')),'{2}',CompanyId),'{3}',USERID), 
					NULL, NULL, NULL, NULL, NULL, NULL, 
					'N', 'N', NULL, NULL, GETDATE() 
			FROM #TEMP_MAIL_ALERT_EX_EMP
		END
	END
	
	
	SET NOCOUNT OFF;
END
GO
