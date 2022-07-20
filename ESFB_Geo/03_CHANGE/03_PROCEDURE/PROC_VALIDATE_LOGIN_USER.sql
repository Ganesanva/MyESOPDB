DROP PROCEDURE IF EXISTS [dbo].[PROC_VALIDATE_LOGIN_USER]
GO

/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_LOGIN_USER]    Script Date: 18-07-2022 16:36:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_VALIDATE_LOGIN_USER]
	@USER_ID VARCHAR(100) = NULL,
	@USER_PASSWORD VARCHAR(100) = NULL,
	@COMPANY_ID VARCHAR(100) = NULL
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @USERID VARCHAR(100), @USER_NAME VARCHAR(1000), @EmployeeEmail VARCHAR(100), @USER_TYPE VARCHAR(500), @IS_USER_LOCKED VARCHAR(1), 
			@FORCE_PWD_CHANGE VARCHAR(1), @INSIDER VARCHAR(1), @IsUserActive VARCHAR(1),
			@ERROR_MESSAGE VARCHAR(1000), @MAX_LOGIN_HIT_SET INT, @MAX_LOGIN_HIT_USER INT, @IS_RESIGNED INT, @TAX_SLAB  NUMeric(18,0)  

	SELECT 
		@USERID = UM.UserId, @USER_NAME = UM.UserName, @EmployeeEmail = UM.EmailId, @USER_TYPE = UT.UserTypeName, @IS_USER_LOCKED = UM.IsUserLocked, 
		@FORCE_PWD_CHANGE = UM.ForcePwdChange, @INSIDER = ISNULL(EM.Insider,'N'),  @MAX_LOGIN_HIT_USER = InvalidLoginAttempt, @TAX_SLAB = dbo.FN_PQ_TAX_ROUNDING(EM.Tax_slab), 
		@IS_RESIGNED = EM.ReasonForTermination, @IsUserActive = UM.IsUserActive 
	FROM UserMaster AS UM
	INNER JOIN UserPassword AS UP ON UM.UserId = UP.UserId 
	INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
	INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
	LEFT OUTER JOIN EmployeeMaster EM on EM.LoginID = UM.UserId AND EM.Deleted = '0' 
	WHERE (UM.UserId = @USER_ID) AND (UP.UserPassword = @USER_PASSWORD)
		
	/* GET MAX LOGIN HIT */
	
	SELECT @MAX_LOGIN_HIT_SET = maxLoginAttempts FROM CompanyMaster
	
	/*
		PRINT '@USERID : '+ @USERID
		PRINT '@USER_NAME : '+ @USER_NAME
		PRINT '@USER_TYPE : '+ @USER_TYPE
		PRINT '@IS_USER_LOCKED : '+ @IS_USER_LOCKED
		PRINT '@FORCE_PWD_CHANGE : '+ @FORCE_PWD_CHANGE
		PRINT '@INSIDER : '+ @INSIDER		
	*/
	
	BEGIN TRY
	IF(UPPER(@IsUserActive) = 'N')
		BEGIN
		  SELECT 'F' AS [STATUS], 'Access Denied.' AS [MESSAGE],'User is inactive.' AS Remark
		END
	ELSE
	IF(@IS_USER_LOCKED = 'Y') AND (@MAX_LOGIN_HIT_SET <= @MAX_LOGIN_HIT_USER)
		BEGIN
			SELECT 'F' AS [STATUS], 'User is locked. Please reset your password.' AS [MESSAGE]
		END	
	ELSE
		BEGIN
			IF(LEN(@USERID) > 0)
				BEGIN
				
					/* GET COMPANY LEVEL DETAILS */	
					SELECT 'S' AS [STATUS], 'SUCCESS' AS [MESSAGE]
					
					CREATE TABLE #TEMP_EMPLOYEE_DATA
					(
						CompanyID VARCHAR(100), FBTTravelInfoYN CHAR(1), BeforeVestDateYN CHAR(1),
						BeforeExpirtyDateYN CHAR(1), FIFO CHAR(1), ListingDate DATE, ListedYN CHAR(1),
						CalcPerqtaxYN CHAR(1), CDSLSettings TINYINT, IsPUPEnabled TINYINT,
						DisplayAs VARCHAR(100), CurrencyName VARCHAR(100), CurrencySymbol VARCHAR(100), CurrencyAlias VARCHAR(100), IS_ADS_ENABLED TINYINT,
						IsListingEnabled TINYINT, IS_EGRANTS_ENABLED TINYINT, 
						StockExchangeType VARCHAR(100), CompanyName VARCHAR(100), IS_CONSENT_SET TINYINT, CONSENT_MESSAGE VARCHAR(MAX),
						AuthenticationModeID TINYINT, IS_EULA_SET TINYINT, ISDOWNTIMESET CHAR(1), DOWNTIMEMESSAGE VARCHAR(1000), DOWNTIMEACCESS VARCHAR(10), SITEURL VARCHAR(500),OTPAuthApplicableUserType TINYINT,
						IS_COMPANY_WITH_FMV BIT, SessionTimeOut INT, IS_VALIDATE_IP_CONFIG_ENABLED BIT
					)
					
					INSERT INTO #TEMP_EMPLOYEE_DATA
					(
						CompanyID, FBTTravelInfoYN, BeforeVestDateYN,
						BeforeExpirtyDateYN, FIFO, ListingDate, ListedYN,
						CalcPerqtaxYN, CDSLSettings, IsPUPEnabled,
						DisplayAs, CurrencyName, CurrencySymbol, CurrencyAlias, IS_ADS_ENABLED,
						IsListingEnabled, IS_EGRANTS_ENABLED, 
						StockExchangeType, CompanyName, IS_CONSENT_SET, CONSENT_MESSAGE,
						AuthenticationModeID, IS_EULA_SET, ISDOWNTIMESET, DOWNTIMEMESSAGE, DOWNTIMEACCESS, SITEURL ,OTPAuthApplicableUserType,
						IS_COMPANY_WITH_FMV,SessionTimeOut, IS_VALIDATE_IP_CONFIG_ENABLED
					)
					SELECT 
						CP.CompanyID, ISNULL(FBTTravelInfoYN,'N') AS FBTTravelInfoYN, ISNULL(BeforeVestDateYN,'N') AS BeforeVestDateYN, 
						ISNULL(BeforeExpirtyDateYN,'N') AS BeforeExpirtyDateYN, ISNULL(Apply_Fifo,'N') AS FIFO, ListingDate, ISNULL(ListedYN,'N') AS ListedYN,  
						ISNULL(CalcPerqtaxYN,'N') AS CalcPerqtaxYN, ISNULL(CDSLSettings,'1') AS CDSLSettings, ISNULL(CM.IsPUPEnabled,0) AS IsPUPEnabled,  
						CM.DisplayAs AS DisplayAs, CurM.CurrencyName, CurM.CurrencySymbol, CurM.CurrencyAlias, ISNULL(CM.IS_ADS_ENABLED,0) AS IS_ADS_ENABLED, 
						ISNULL(CM.IsListingEnabled,0) AS IsListingEnabled, ISNULL(CM.IS_EGRANTS_ENABLED,0) AS IS_EGRANTS_ENABLED, 
						CM.StockExchangeType, CM.CompanyName, ISNULL(CM.IS_CONSENT_SET,0) AS IS_CONSENT_SET, CM.CONSENT_MESSAGE, 
						ISNULL(CM.AuthenticationModeID,0) AS AuthenticationModeID, ISNULL(CM.IS_EULA_SET,0) AS IS_EULA_SET, ISNULL(ISDOWNTIMESET,'N') AS ISDOWNTIMESET,
						CP.DOWNTIMEMESSAGE, CP.DOWNTIMEACCESS, SITEURL ,ISNULL(CM.OTPAuthApplicableUserType,0) AS OTPAuthApplicableUserType,ISNULL(CP.IS_COMPANY_WITH_FMV,0) AS IS_COMPANY_WITH_FMV,
						CP.SessionTimeOut
						,ISNULL(CM.IS_VALIDATE_IP_CONFIG_ENABLED,0) AS IS_VALIDATE_IP_CONFIG_ENABLED				
					FROM CompanyParameters AS CP 
					INNER JOIN CompanyMaster AS CM ON CM.CompanyID = CP.CompanyID
					INNER JOIN MST_STOCK_EXCHANGE MSE on MSE.MSE_ID = CM.StockExchangeType
					INNER JOIN CurrencyMaster AS CurM ON CurM.CurrencyID = CASE WHEN  CP.ListedYN = 'Y' THEN MSE.CurrencyID ELSE CM.BaseCurrencyID END					
					
					/* UPDATE ADR STATUS*/						
					DECLARE @IS_ADS_ENABLED TINYINT
					
					SELECT 
						@IS_ADS_ENABLED = 1 
					FROM 
						MST_INSTRUMENT_TYPE AS MIT
					INNER JOIN MST_COM_CODE AS MCC ON MCC.MCC_ID = MIT.INSTRUMENT_GROUP
					INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON MIT.MIT_ID = CIM.MIT_ID
					WHERE 
						(MCC.CODE_NAME = 'ADR') AND (CIM.IS_ENABLED = 1)
					
					UPDATE #TEMP_EMPLOYEE_DATA SET IS_ADS_ENABLED = ISNULL(@IS_ADS_ENABLED,0)
					
					/* UPDATE PUP STATUS*/						
					
					DECLARE @IsPUPEnabled TINYINT
					
					SELECT 
						@IsPUPEnabled = 1
					FROM 
						MST_INSTRUMENT_TYPE AS MIT
					INNER JOIN MST_COM_CODE AS MCC ON MCC.MCC_ID = MIT.INSTRUMENT_GROUP
					INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON MIT.MIT_ID = CIM.MIT_ID
					WHERE 
						(MCC.CODE_NAME = 'PUP') AND (CIM.IS_ENABLED = 1)
					
					UPDATE #TEMP_EMPLOYEE_DATA SET IsPUPEnabled = ISNULL(@IsPUPEnabled,0)
					
					/*OUTPUT*/
					SELECT 
						CompanyID, FBTTravelInfoYN, BeforeVestDateYN,
						BeforeExpirtyDateYN, FIFO, ListingDate, ListedYN,
						CalcPerqtaxYN, CDSLSettings, IsPUPEnabled,
						DisplayAs, CurrencyName, CurrencySymbol, CurrencyAlias, IS_ADS_ENABLED,
						IsListingEnabled, IS_EGRANTS_ENABLED, 
						StockExchangeType, CompanyName, IS_CONSENT_SET, CONSENT_MESSAGE,
						AuthenticationModeID, IS_EULA_SET, ISDOWNTIMESET, DOWNTIMEMESSAGE, DOWNTIMEACCESS, SITEURL ,OTPAuthApplicableUserType,IS_COMPANY_WITH_FMV,
                        ISNULL(IS_VALIDATE_IP_CONFIG_ENABLED,0) AS IS_VALIDATE_IP_CONFIG_ENABLED
					FROM											
						#TEMP_EMPLOYEE_DATA					
					
					/* GET CURRENT EMPLOYEE ID */ 
					IF ((@USER_TYPE = 'CR') OR (@USER_TYPE = 'ADMIN'))
					BEGIN
						SELECT @USER_TYPE AS 'UserTypeName', '' AS ForcePwdChange, '' AS Insider, '' AS EmployeeID, @USER_NAME AS UserName, @EmployeeEmail AS EmployeeEmail, '' AS TAX_SLAB 
					END
					ELSE IF(UPPER(@USER_TYPE) = 'EMPLOYEE')
					BEGIN
						
						DECLARE @UNAPPROVED_EXERCISE_QUANTITY NUMERIC(18,0), @EXERCISABLE_QUANTITY NUMERIC(18,0), 
								@DATE_OF_TERMINATION DATETIME, @PERQ_TAX NUMERIC(18,6), @RESIGNED_PERQ_TAX NUMERIC(18,6),
								@CONF_STATUS CHAR(1)
						
						SELECT 
							@UNAPPROVED_EXERCISE_QUANTITY = SUM(GL.UnapprovedExerciseQuantity), 
							@EXERCISABLE_QUANTITY = SUM(GL.ExercisableQuantity), 
							@DATE_OF_TERMINATION = EM.DateOfTermination,
							@CONF_STATUS = EM.ConfStatus						
						FROM GrantLeg AS GL 
						INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
						INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						WHERE (UM.UserId = @USER_ID) GROUP BY EM.DateOfTermination, EM.ConfStatus
						
						SELECT  @PERQ_TAX = dbo.FN_PQ_TAX_ROUNDING(prequisiteTax), @RESIGNED_PERQ_TAX =dbo.FN_PQ_TAX_ROUNDING(TaxRate_ResignedEmp) FROM CompanyParameters
						
						--/*
							PRINT '@UNAPPROVED_EXERCISE_QUANTITY : '+ CONVERT(VARCHAR(100), @UNAPPROVED_EXERCISE_QUANTITY)
							PRINT '@EXERCISABLE_QUANTITY : '+ CONVERT(VARCHAR(100), @EXERCISABLE_QUANTITY)
							PRINT '@DATE_OF_TERMINATION : '+ CONVERT(VARCHAR(100), @DATE_OF_TERMINATION)							
						--*/
						
						IF Exists(SELECT TOP 1  GOP.GrantedOptions FROM GrantLeg AS GL
						INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId 
					    INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						WHERE (UM.UserId = @USER_ID) ORDER BY EM.DateOfTermination DESC)
                        BEGIN
								/* CHECK UNAPPROVED EXERCISE QUANTITY OR EXERCISABLE QUANTITY AVAILABLE TO EMPLOYEE  */
								IF (@DATE_OF_TERMINATION = '1900-01-01 00:00:00.000')
								BEGIN
								   SET @DATE_OF_TERMINATION = NULL
								END		
								IF(@CONF_STATUS = 'S' OR @CONF_STATUS = 'P')
								BEGIN
								   SELECT 'F' AS [STATUS], 'Access Denied.' AS [MESSAGE],'Confirmation status on Probation or Suspended should not be allowed to login. ' AS Remark
								END	
								ELSE				
								IF ((@DATE_OF_TERMINATION IS NOT NULL) AND (@UNAPPROVED_EXERCISE_QUANTITY = 0) AND (@EXERCISABLE_QUANTITY = 0))
									BEGIN
										--SELECT 'F' AS [STATUS], 'Your account has been blocked. Please contact ESOP Direct for further details.' AS [MESSAGE]
										SELECT 'F' AS [STATUS], 'Access Denied.' AS [MESSAGE],'Separated employee having 0 outstanding options should not be allowed to login' AS Remark
									END
								ELSE
									BEGIN	
										IF(UPPER(@COMPANY_ID) = 'KOTAK')
											BEGIN
												/*	CHECK SAR OPTION ASSING TO EMPLOYEE */
												IF EXISTS (SELECT NAME FROM SYS.TABLES WHERE UPPER(NAME) = 'SARSUMMARYDETAILS')
												BEGIN
													SELECT 
														@USER_TYPE AS 'UserTypeName', EM.Insider, EM.EmployeeID,
														COUNT(SAR.EmployeeID), EM.DateOfTermination, @USER_NAME AS UserName, EM.EmployeeEmail,
														(CASE
															WHEN ((LEN(@IS_RESIGNED) != 2) AND (LEN(@TAX_SLAB) > 0)) THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
															WHEN @IS_RESIGNED IS NULL THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
															WHEN ((LEN(@IS_RESIGNED) = 2) AND (LEN(@TAX_SLAB) = 0)) THEN @RESIGNED_PERQ_TAX ELSE dbo.FN_PQ_TAX_ROUNDING(@PERQ_TAX)
														END) AS TAX_SLAB, EM.ResidentialStatus, ISNULL(UM.ForcePwdChange,'N') AS ForcePwdChange																								
													FROM SARSummaryDetails AS SAR
													RIGHT OUTER JOIN EmployeeMaster AS EM ON EM.EmployeeID = SAR.EmployeeID
													RIGHT OUTER JOIN UserMaster AS UM ON EM.EmployeeId = UM.EmployeeId 
													WHERE (UM.UserId = @USER_ID) AND (EM.Deleted = 0)
													GROUP BY UM.ForcePwdChange, EM.Insider, EM.EmployeeID, SAR.EmployeeId, EM.DateOfTermination, EM.EmployeeEmail 
												END
											END																																				
										ELSE
											BEGIN
										
												SELECT  
													@USER_TYPE AS 'UserTypeName', EM.Insider, EM.EmployeeID, @USER_NAME AS UserName, EM.EmployeeEmail,
													(CASE
															WHEN ((LEN(@IS_RESIGNED) != 2) AND (LEN(@TAX_SLAB) > 0) AND @IS_RESIGNED IS NULL) THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
															WHEN @IS_RESIGNED IS NULL THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
															WHEN ((LEN(@IS_RESIGNED) = 2) AND (LEN(@TAX_SLAB) = 0)) THEN @RESIGNED_PERQ_TAX ELSE dbo.FN_PQ_TAX_ROUNDING(@PERQ_TAX)
													END) AS  TAX_SLAB,  EM.ResidentialStatus,  ISNULL(UM.ForcePwdChange,'N') AS ForcePwdChange 
												FROM EmployeeMaster AS EM
												INNER JOIN UserMaster AS UM ON UM.UserId = EM.LoginID 
												WHERE (EM.LoginID = @USERID) AND (EM.Deleted = 0)								
											END												
									END	
						END
					 ELSE
					 IF Exists(SELECT TOP 1 DC.EmployeeId FROM DeferredCashGrant AS DC						
					    INNER JOIN UserMaster AS UM ON DC.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						WHERE (UM.UserId = @USERID) ORDER BY EM.DateOfTermination DESC)
                        BEGIN
						  --SELECT 'S' AS [STATUS], 'SUCCESS' AS [MESSAGE]
						  SELECT  
							@USER_TYPE AS 'UserTypeName', EM.Insider, EM.EmployeeID, @USER_NAME AS UserName, EM.EmployeeEmail,
							(CASE
									WHEN ((LEN(@IS_RESIGNED) != 2) AND (LEN(@TAX_SLAB) > 0) AND @IS_RESIGNED IS NULL) THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
									WHEN @IS_RESIGNED IS NULL THEN dbo.FN_PQ_TAX_ROUNDING(@TAX_SLAB)
									WHEN ((LEN(@IS_RESIGNED) = 2) AND (LEN(@TAX_SLAB) = 0)) THEN @RESIGNED_PERQ_TAX ELSE dbo.FN_PQ_TAX_ROUNDING(@PERQ_TAX)
							END) AS  TAX_SLAB,  EM.ResidentialStatus,  ISNULL(UM.ForcePwdChange,'N') AS ForcePwdChange 
						FROM EmployeeMaster AS EM
						INNER JOIN UserMaster AS UM ON UM.UserId = EM.LoginID 
						WHERE (EM.LoginID = @USERID) AND (EM.Deleted = 0)
						END

						ELSE

						BEGIN
						   SELECT 'F' AS [STATUS], 'Access Denied.' AS [MESSAGE],'Employee who is registered but does not have any grant should not be allowed to login' AS Remark
						END
												
					END
					
					/* GET PAYMENT MODE DETAILS */
						
					SELECT PaymentMode, IsEnable FROM PaymentMaster WHERE UPPER(IsEnable) = 'Y'	 
					
					/*
						IF SUCCESSFUL LOING UPDATE LOGIN ATTEMPTED ZERO
					*/
					
					UPDATE UserMaster SET InvalidLoginAttempt = 0 WHERE (UserId = @USERID)
					
					/* GET LAST LOGIN DATE AND TIME */
					if Exists(SELECT TOP 1 ISNULL((LoginDate),GetDATE() ) AS LoginDate FROM UserLoginHistory   WHERE UserId = @USERID ORDER BY LoginDate DESC)
					    SELECT TOP 1 ISNULL((LoginDate),GetDATE() ) AS LoginDate 
						FROM UserLoginHistory   
						WHERE UserId = @USERID 
						ORDER BY LoginDate DESC
					Else
						SELECT GETDATE() AS LoginDate
					DROP TABLE #TEMP_EMPLOYEE_DATA
				END
			ELSE
				BEGIN
					
					SELECT 'F' AS [STATUS], 'Invalid User ID or Password.' AS [MESSAGE]
					
					/* 
						INCREMENT INVALID LOGIN ATTEMPTS
						PRINT 'INCREMENT INVALID LOGIN ATTEMPTS' 
					*/
					 
					UPDATE UserMaster SET InvalidLoginAttempt = InvalidLoginAttempt + 1 WHERE (UserId = @USER_ID) AND (UPPER(UserId) <> 'ADMIN')
					
					/* 
						LOCK USER IF INVALID ATTTEMPS ARE CROSS THE LIMIT				
						PRINT 'LOCK USER IF INVALID ATTTEMPS ARE CROSS THE LIMIT'
					*/	
					
					DECLARE @MAX_LOGIN_ATTEMPTS INT 
					SELECT @MAX_LOGIN_ATTEMPTS = maxLoginAttempts FROM CompanyMaster
					
					UPDATE UserMaster SET IsUserLocked = 'Y' WHERE (UserId = @USER_ID) AND (InvalidLoginAttempt >= @MAX_LOGIN_ATTEMPTS)
										
					SELECT  
						@MAX_LOGIN_HIT_USER = InvalidLoginAttempt
					FROM UserMaster AS UM
					INNER JOIN UserPassword AS UP ON UM.UserId = UP.UserId 
					INNER JOIN RoleMaster AS RM ON UM.RoleId = RM.RoleId 
					INNER JOIN UserType AS UT ON RM.UserTypeId = UT.UserTypeId 
					LEFT OUTER JOIN EmployeeMaster EM on EM.LoginID = UM.UserId AND EM.Deleted = '0' 
					WHERE (UM.UserId = @USER_ID)
					
					IF (@IS_USER_LOCKED = 'Y') AND (@MAX_LOGIN_HIT_SET <= @MAX_LOGIN_HIT_USER)
					BEGIN
						SELECT 'F' AS [STATUS], 'User is locked. Please reset your password.' AS [MESSAGE]
					END
				END
				
		END
	END TRY
	BEGIN CATCH
		SELECT 'F' AS [STATUS], 'Invalid User ID or Password.' AS [MESSAGE]
	END CATCH
		
	SET NOCOUNT OFF;  
   
END  
GO


