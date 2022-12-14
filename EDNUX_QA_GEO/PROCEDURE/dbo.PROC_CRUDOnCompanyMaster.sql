/****** Object:  StoredProcedure [dbo].[PROC_CRUDOnCompanyMaster]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDOnCompanyMaster]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDOnCompanyMaster]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_CRUDOnCompanyMaster]
(
	@CompanyID 			    VARCHAR(20),
	@CompanyName 	  	    VARCHAR(100),
	@CompanyAdd			    NTEXT,
	@CompanyEmail 		    VARCHAR(50),
	@CompanyURL			    VARCHAR(50),
	@AdminEmail			    VARCHAR(50),
	@SEType				    CHAR,
	@LoginAttmpt 			TINYINT,
	@FundingAllowed			BIT,
	@NominatnEnble			TINYINT,
	@IsListingEnabled		BIT,
	@Is_EGrants_Enabled		BIT,
	@Is_PFUTP_Setting		BIT,
	@BaseCurrencyID		    TINYINT,
	@IS_SCHWISE_DOC_UPLOAD  BIT,
	@IS_CONSENT_SET			BIT,
	@CONSENT_MESSAGE		VARCHAR(MAX),
	@AuthenticationModeID   INT,
	@IS_EULA_SET			BIT,
	@OTPAuthApplicableUserType INT=NULL,	
	@IS_VALIDATE_IP_CONFIG_ENABLED BIT,
	@IS_FUTURE_SEPRATION_ALLOW  BIT
)
AS
BEGIN

	DECLARE @SQuery VARCHAR(500), @OLD_AuthenticationModeID INT, 
			@Result	TINYINT = 0
			
    ---------------------------------------------------------------------
    -- Copy data with Schema of CompanyMaster into temporary table
    ---------------------------------------------------------------------			
	SELECT	CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmailID,
			AdminEmailID, StockExchangeType, StockExchangeCode, LastUpdatedBy, LastUpdatedOn,
			MaxLoginAttempts, ISFUNDINGALLOWED, IsNominationEnabled, IsPUPEnabled, DisplayAs,
			VwMenuForGrpCompany, IS_ADS_ENABLED, IsListingEnabled, IS_EGRANTS_ENABLED, Is_PFUTP_Setting, IS_SCHWISE_DOC_UPLOAD,
			IS_CONSENT_SET, CONSENT_MESSAGE, AuthenticationModeID, IS_EULA_SET,OTPAuthApplicableUserType, IS_VALIDATE_IP_CONFIG_ENABLED,IS_FUTURE_SEPRATION_ALLOW
	INTO	#TEMP_CompanyMaster 
	FROM	CompanyMaster
	
	 

	SET @OLD_AuthenticationModeID = (SELECT AuthenticationModeID FROM CompanyMaster)
			
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS(SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS  WHERE TABLE_NAME = 'CompanyMaster' AND  COLUMN_NAME = 'isFundingAllowed')
			BEGIN
					UPDATE	CompanyMaster 
					SET		CompanyName			    = @CompanyName,
							CompanyAddress			= @CompanyAdd,
							CompanyEmailID			= @CompanyEmail,
							CompanyURL			    = @CompanyURL,
							AdminEmailID			= @AdminEmail,
							StockExchangeType		= @SEType,						
							MaxLoginAttempts		= @LoginAttmpt,
							isFundingAllowed		= @FundingAllowed,
							IsNominationEnabled		= @NominatnEnble,						
							IsListingEnabled		= @IsListingEnabled,
							IS_EGRANTS_ENABLED		= @Is_EGrants_Enabled,
							Is_PFUTP_Setting		= @Is_PFUTP_Setting,
							BaseCurrencyID			= @BaseCurrencyID,
							IS_SCHWISE_DOC_UPLOAD   = @IS_SCHWISE_DOC_UPLOAD,
							IS_CONSENT_SET			= @IS_CONSENT_SET,
							CONSENT_MESSAGE			= @CONSENT_MESSAGE,
							AuthenticationModeID    = @AuthenticationModeID,
							IS_EULA_SET				= @IS_EULA_SET,
							OTPAuthApplicableUserType=@OTPAuthApplicableUserType,
							IS_VALIDATE_IP_CONFIG_ENABLED = @IS_VALIDATE_IP_CONFIG_ENABLED,
							IS_FUTURE_SEPRATION_ALLOW = @IS_FUTURE_SEPRATION_ALLOW
					WHERE	CompanyID=@CompanyID			
					
					--PRINT 'RowCount Value' + Convert(VARCHAR(2),@@ROWCOUNT) +'Error Value   '+ Convert(VARCHAR(2),@@ERROR)
					IF(@@ROWCOUNT > 0)
					BEGIN
							--print	@Is_PFUTP_Setting
							IF(@Is_PFUTP_Setting = 0)

							BEGIN
								--print 'i m in'
								UPDATE 
									CompanyParameters
								SET 
									PFUTPDate = NULL;

							SELECT 1 AS [OUTPUT], 'Success' AS [Remark]
							END				
						
						----------------------------------------------------------------------------------------------------------------
						-- For maintaing Audit trail Log over CompanyInfo Section, Inserted new record ino Company Info History table
						----------------------------------------------------------------------------------------------------------------				
						--PRINT 'Insert Loop'
						INSERT INTO CompanyInfoHistory
						(	
								CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmail, 
								AdminEmail, StockExchange, StockExchangeCode, UpdatedDate, UpdatedTime, 
								LastUpdatedBy, LastUpdatedOn, MaxLoginAttempts, isFundingAllowed, IsNominationEnabled,
								IsPUPEnabled, DisplayAs, VwMenuForGrpCompany, IS_ADS_ENABLED, IsListingEnabled,
								IS_EGRANTS_ENABLED, Is_PFUTP_Setting, IS_SCHWISE_DOC_UPLOAD, IS_CONSENT_SET,
								CONSENT_MESSAGE, AuthenticationModeID, IS_EULA_SET,OTPAuthApplicableUserType,
								IS_VALIDATE_IP_CONFIG_ENABLED,IS_FUTURE_SEPRATION_ALLOW
						)
						SELECT 	CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmailID,
								AdminEmailID, StockExchangeType, StockExchangeCode, CONVERT(DATE,GETDATE()), GETDATE(),
								LastUpdatedBy, GETDATE(), MaxLoginAttempts, ISFUNDINGALLOWED, IsNominationEnabled,
								IsPUPEnabled, DisplayAs, VwMenuForGrpCompany, IS_ADS_ENABLED, IsListingEnabled,
								IS_EGRANTS_ENABLED, Is_PFUTP_Setting, IS_SCHWISE_DOC_UPLOAD, IS_CONSENT_SET,
								CONSENT_MESSAGE, AuthenticationModeID, IS_EULA_SET,OTPAuthApplicableUserType,
								IS_VALIDATE_IP_CONFIG_ENABLED,IS_FUTURE_SEPRATION_ALLOW
						FROM	#TEMP_CompanyMaster
						
						SELECT 1 AS [OUTPUT], 'Success' AS [Remark]
					END
					ELSE
						SELECT 0 AS [OUTPUT], 'Fail' AS [Remark]
			END
		ELSE
			BEGIN
				UPDATE	CompanyMaster 
				SET		CompanyName			    = @CompanyID,
						CompanyAddress			= @CompanyName,
						CompanyEmailID			= @CompanyEmail,
						CompanyURL			    = @CompanyURL,
						AdminEmailID			= @AdminEmail,
						StockExchangeType       = @SEType,					
						MaxLoginAttempts        = @LoginAttmpt,
						IsNominationEnabled		= @NominatnEnble,					
						IsListingEnabled		= @IsListingEnabled,
						IS_EGRANTS_ENABLED		= @Is_EGrants_Enabled,
						Is_PFUTP_Setting		= @Is_PFUTP_Setting,
						BaseCurrencyID			= @BaseCurrencyID,
						IS_SCHWISE_DOC_UPLOAD   = @IS_SCHWISE_DOC_UPLOAD,
						IS_CONSENT_SET			= @IS_CONSENT_SET,
						CONSENT_MESSAGE			= @CONSENT_MESSAGE,
						AuthenticationModeID    = @AuthenticationModeID,
						IS_EULA_SET				= @IS_EULA_SET,
						OTPAuthApplicableUserType=@OTPAuthApplicableUserType,
						IS_VALIDATE_IP_CONFIG_ENABLED = @IS_VALIDATE_IP_CONFIG_ENABLED,
						IS_FUTURE_SEPRATION_ALLOW = @IS_FUTURE_SEPRATION_ALLOW
				WHERE	CompanyID=@CompanyID
				
				
				IF(@@ROWCOUNT > 0)
				BEGIN
					----------------------------------------------------------------------------------------------------------------
					---- For maintaing Audit trail Log over CompanyInfo Section, Inserted new record ino Company Info History table
					----------------------------------------------------------------------------------------------------------------				
					INSERT INTO CompanyInfoHistory
					(					
							CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmail, 
							AdminEmail, StockExchange, StockExchangeCode, UpdatedDate, UpdatedTime, 
							LastUpdatedBy, LastUpdatedOn, MaxLoginAttempts,IsNominationEnabled, IsPUPEnabled,
							DisplayAs, VwMenuForGrpCompany, IS_ADS_ENABLED, IsListingEnabled, Is_PFUTP_Setting,
							IS_SCHWISE_DOC_UPLOAD, IS_CONSENT_SET, CONSENT_MESSAGE, AuthenticationModeID, IS_EULA_SET,OTPAuthApplicableUserType,
							IS_VALIDATE_IP_CONFIG_ENABLED,IS_FUTURE_SEPRATION_ALLOW
					)
					SELECT 	CompanyID, CompanyName, CompanyAddress, CompanyURL, CompanyEmailID,
							AdminEmailID, StockExchangeType, StockExchangeCode, CONVERT(DATE,GETDATE()), GETDATE(),
							LastUpdatedBy, LastUpdatedOn, MaxLoginAttempts, IsNominationEnabled, IsPUPEnabled,
							DisplayAs, VwMenuForGrpCompany, IS_ADS_ENABLED, IsListingEnabled, Is_PFUTP_Setting,
							IS_SCHWISE_DOC_UPLOAD, IS_CONSENT_SET, CONSENT_MESSAGE, @AuthenticationModeID, IS_EULA_SET,OTPAuthApplicableUserType,
							IS_VALIDATE_IP_CONFIG_ENABLED,IS_FUTURE_SEPRATION_ALLOW
					FROM	#TEMP_CompanyMaster
									
					SELECT 1 AS [OUTPUT], 'Success' AS [Remark]
				END
				ELSE
					SELECT 0 AS [OUTPUT], 'Fail' AS [Remark]
			END
		/* UPDATE IN COMPANYLIST TABLE FOR OGA LETTER GENRATION */
			IF(@Is_EGrants_Enabled = 1)
			BEGIN
				UPDATE ESOPManager..CompanyList SET IsActivatedForLG = 1 WHERE CName = @CompanyID;
			END
			ELSE
			BEGIN
				UPDATE ESOPManager..CompanyList SET IsActivatedForLG = 0 WHERE CName = @CompanyID;
			END
		/* TWO STEP AUTHENTICATION */
		UPDATE EmployeeRoleMaster SET Show = @AuthenticationModeID WHERE (UPPER(NAME) = 'UPDATE SECURITY SETTINGS')	
		
		IF (@OLD_AuthenticationModeID <> @AuthenticationModeID)
		BEGIN
			DELETE FROM UserSecurityQuestion 
		END
			
		DELETE FROM RolePrivileges WHERE ScreenActionId = 
		(
			SELECT ScreenActionId FROM ScreenActions WHERE ScreenId = 
			(
				SELECT ScreenId FROM SCREENMASTER WHERE (UPPER(NAME) = 'UPDATE SECURITY SETTINGS') AND (ScreenURL ='CR/CR1/UPDATECRSECURITYANSWERS.ASPX?') AND (MAINMENUID = 19) AND (USERTYPEID = 2)
			)
		)
			
		IF (@AuthenticationModeID > 0)
		BEGIN
			INSERT INTO ROLEPRIVILEGES
			SELECT 
				(SELECT ISNULL(MAX(ROLEPRIVILEGEID),0) + 1 FROM ROLEPRIVILEGES) - 1 + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RolePrivilegeId, 
				ROLEID,
				(SELECT 
					ScreenActionId 
				FROM 
					SCREENMASTER SM INNER JOIN SCREENACTIONS SA ON SA.ScreenId = SM.ScreenId
				WHERE 
					UPPER(NAME) = 'UPDATE SECURITY SETTINGS' AND ScreenURL ='CR/CR1/UPDATECRSECURITYANSWERS.ASPX?' AND USERTYPEID = 2) AS ScreenActionId,
				'Admin' AS LastUpdatedBy,
				GETDATE() LastUpdatedon
			FROM 
				ROLEMASTER 
			WHERE	
				USERTYPEID = 2
		END
		
				
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		IF (@@TRANCOUNT > 0)
			ROLLBACK TRANSACTION
		SELECT	0					AS [OUTPUT],				
				ERROR_NUMBER()		AS ErrorNumber, 
				ERROR_SEVERITY()	AS ErrorSeverity, 
				ERROR_STATE()		AS ErrorState, 
				ERROR_PROCEDURE()	AS ErrorProcedure, 
				ERROR_LINE()		AS ErrorLine, 
				ERROR_MESSAGE()		AS ErrorMessage;
	END CATCH
	
	------------------------------------------------------------------------------
	-- DROP Temporary table
	------------------------------------------------------------------------------
	IF EXISTS  
			(        
				SELECT 1        
				FROM tempdb.dbo.sysobjects        
				WHERE ID In 
					(OBJECT_ID(N'#TEMP_CompanyMaster'))        
			)        
	 BEGIN        
		DROP TABLE #TEMP_CompanyMaster
	 END
	 
	 /* Delete the records from CompanyConsent Table if Admin reset/uncheck the Consent Settings */
	 IF EXISTS (SELECT 1 FROM CompanyConsent)
	 BEGIN
		 IF(@IS_CONSENT_SET = 0)
		 BEGIN
			DELETE FROM COMPANYCONSENT
		 END
	 END
	
	 IF(@IS_CONSENT_SET = 0)
		 BEGIN
			/*UNCHECK OR DELETE THE ROLE PRIVILEGES RECORD FOR CR IF IS_CONSENT_SET IS UNCHECKED*/
			IF EXISTS (SELECT SM.* FROM RolePrivileges AS RP INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
					   INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId WHERE SM.Name LIKE '%Employee Consent And Declaration%')
			BEGIN
				DELETE FROM 
					RolePrivileges 
				WHERE 
					ScreenActionId IN ( SELECT DISTINCT SA.ScreenActionId 
										FROM 
											RolePrivileges AS RP 
											INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
											INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId 
										WHERE 
											SM.Name LIKE '%Employee Consent And Declaration%'
									  )
			END

		 END

	IF(@IS_EULA_SET = 0)
		 BEGIN
			/*UNCHECK OR DELETE THE ROLE PRIVILEGES RECORD FOR CR IF IS_EULA_SET IS UNCHECKED*/
			IF EXISTS (SELECT SM.* FROM RolePrivileges AS RP INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
					   INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId WHERE SM.Name LIKE '%EULA Acceptance Report%')
			BEGIN
				DELETE FROM 
					RolePrivileges 
				WHERE 
					ScreenActionId IN ( SELECT DISTINCT SA.ScreenActionId 
										FROM 
											RolePrivileges AS RP 
											INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
											INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId 
										WHERE 
											SM.Name LIKE '%EULA Acceptance Report%'
									  )
			END

		 END

	/*DELETE ALL EMPLOYEE ACCEPTANCE RECORD IF EULA IS UNSET OR DEACTIVATED*/
	/* this functionality commented due to changes in requirement
	 IF EXISTS (SELECT 1 FROM EULA_ACCEPTANCE)
	 BEGIN
		 IF(@IS_EULA_SET = 0)
		 BEGIN
			DELETE FROM EULA_ACCEPTANCE WHERE CATEGORY='EULA'
		 END
	 END
	 */
END
GO
