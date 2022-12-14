/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_CONSENT_AND_DECLARATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_CONSENT_AND_DECLARATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_CONSENT_AND_DECLARATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_CONSENT_AND_DECLARATION]	
	@EmployeeID		VARCHAR(20),
	@ACTION			CHAR
AS
BEGIN
SET NOCOUNT ON;
	SET @EmployeeID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)
	IF(SELECT COUNT(IS_CONSENT_SET) FROM CompanyMaster WHERE IS_CONSENT_SET=1)> 0
	BEGIN
		/*VARIABLE DECLARAION AND COMMON CODE OR 'R' AND 'A' ACTION*/
		BEGIN TRY
			BEGIN /*[variable declaration]*/
				DECLARE @CompanyLevel NVARCHAR(40), @EUNonEU NVARCHAR(40), @BasedOnCountry NVARCHAR(40), @BasedOnTaxIdentiCountry NVARCHAR(40),
				@FirstLogin NVARCHAR(40),@FristChangeInCategory NVARCHAR(40), @EveryChangeInCategory NVARCHAR(40), @EveryTime NVARCHAR(40),
				@Category NVARCHAR(40), @GetLastCategory NVARCHAR(40),@Date_of_change_in_category NVARCHAR(50)
				DECLARE @COUNT INT, @GetCountryId INT
				SET @CompanyLevel='rdoECT_01' SET  @EUNonEU='rdoECT_02' SET @BasedOnCountry ='rdoECST_01' SET  @BasedOnTaxIdentiCountry='rdoECST_02'
				SET @FirstLogin='rdoEEFCA_01' SET @FristChangeInCategory='rdoEEFCA_02' SET @EveryChangeInCategory='rdoEEFCA_03' SET @EveryTime='rdoEEFCA_04'
	
				/*VERIABLES FOR DYNAMIC DATA [get data from tables]*/
				DECLARE @ECT_ID NVARCHAR(40), @ECST_ID NVARCHAR(40), @EEFCA_ID NVARCHAR(40)
				SELECT @ECT_ID = ECT from MST_EMP_CONSENT_TYPE where Is_Selected=1
				SELECT @ECST_ID = ECST from MST_EMP_CONSENT_SUBTYPE where Is_Selected=1
				SELECT @EEFCA_ID = EEFCA from MST_EMP_EVENT_FOR_CONSENT_ACCEPTANCE where Is_Selected=1
			END
			IF(@BasedOnTaxIdentiCountry = @ECST_ID)			
				BEGIN					
					SELECT @GetCountryId = ISNULL(CM.ID,0), @GetLastCategory = ISNULL(CM.Category,'') from CountryMaster AS CM INNER JOIN EmployeeMaster AS EM ON ISNULL(CONVERT(int,EM.TAX_IDENTIFIER_COUNTRY),0)=ISNULL(CM.ID,0) WHERE EM.EmployeeID = @EmployeeID	
					--print @GetLastCategory + ' ' + 'GetLastCategory from Based on Tax identifier'
				END
			ELSE IF(SELECT count(CM.Category) from CountryMaster AS CM INNER JOIN EmployeeMaster AS EM on EM.CountryName=CM.CountryAliasName WHERE EM.EmployeeID=@EmployeeID)> 0
				BEGIN						
					SELECT @GetCountryId = ISNULL(CM.ID,0), @GetLastCategory = ISNULL(CM.Category,'') from CountryMaster AS CM INNER JOIN EmployeeMaster AS EM on EM.CountryName=CM.CountryAliasName WHERE EM.EmployeeID = @EmployeeID
					--print @GetLastCategory + ' ' + 'GetLastCategory from Based on Country'
				END
				
				BEGIN /*[COUNTRY OR TAX IDENTIFIER COUNTRY, OR CATEGORY IS BLANK THEN]*/				
					IF(((LEN(ISNULL(@GetCountryId, 0))=0) OR (ISNULL(@GetCountryId,0) = 0)) AND (@BasedOnCountry = @ECST_ID))
						BEGIN
							--Print 'if @BasedOnCountry,and country is blank then'
							SELECT 'Employee Country is not updated, please contact the helpdesk' AS ConsentMsg, 404 as IsConsent					
							RETURN
						END
					ELSE IF(((LEN(ISNULL(@GetCountryId, 0))=0) OR (ISNULL(@GetCountryId,0) = 0)) AND (@BasedOnTaxIdentiCountry = @ECST_ID))
						BEGIN
							--Print 'if @@BasedOnTaxIdentiCountry,and Tax identifie country is blank then'
							SELECT 'Employee Tax identifier Country is not updated, please contact the helpdesk' AS ConsentMsg, 404 as IsConsent					
							RETURN
						END
					ELSE IF(((LEN(ISNULL(@GetLastCategory, ''))=0) OR (@GetLastCategory = 'NULL')) AND (@BasedOnTaxIdentiCountry = @ECST_ID))
						BEGIN
							--Print 'if @BasedOnTaxIdentiCountry,and category is blank then'
							SELECT 'Employee Tax identifier Country as updated is not associated with EU or Non-EU category, please contact the helpdesk' AS ConsentMsg, 404 as IsConsent
							RETURN
						END
					ELSE IF(((LEN(ISNULL(@GetLastCategory, ''))=0) OR (@GetLastCategory = 'NULL')) AND (@BasedOnCountry = @ECST_ID))
						BEGIN
							--Print 'if @BasedOnCountry,and category is blank then'
							SELECT 'Employee Country as updated is not associated with EU or Non-EU category, please contact the helpdesk' AS ConsentMsg, 404 as IsConsent
							RETURN
						END				
				END		
		END TRY  
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS ConsentMsg, 404 as IsConsent
		END CATCH
		
		/*READ CONSENT FROM CONFIGURATION, 'R'*/
		BEGIN TRY
			IF(@Action = 'R')
				BEGIN
					/*Company Level all events*/
					IF(@CompanyLevel = @ECT_ID)
						BEGIN
							IF(@FirstLogin = @EEFCA_ID)
								BEGIN
									/*print 'CompanyLevel - FirstLogin'*/
									IF NOT EXISTS
									(
										SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID AND ISNULL(Category,'ALL') = 'ALL'										
									)
									BEGIN 
										SELECT CompanyLevelMsg AS ConsentMsg, '1|C' as IsConsent FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
									END
								END
							IF(@EveryTime = @EEFCA_ID)
								BEGIN
									/*print 'CompanyLevel - EveryTime'*/
									SELECT CompanyLevelMsg AS ConsentMsg, '1|C' as IsConsent FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
								END
						END

					/*EU / NON-EU category*/
					IF(@EUNonEU = @ECT_ID)
					BEGIN
						/*Print 'EU-NonEU category'*/
						IF((@BasedOnCountry = @ECST_ID) OR (@BasedOnTaxIdentiCountry = @ECST_ID))
							BEGIN
								IF(@EveryTime = @EEFCA_ID)
								BEGIN
									/*print 'EveryTime'*/
									IF(@GetLastCategory='EU')
										BEGIN
											SELECT EU_EmployeeMsg AS ConsentMsg, '1|E' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
										END
									ELSE IF(@GetLastCategory='NonEU')
										BEGIN
											SELECT Non_EUEmployeeMsg AS ConsentMsg, '1|N' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
										END
								END
								IF(@FirstLogin = @EEFCA_ID)
									BEGIN
										/*print 'FirstLogin'*/
										IF NOT EXISTS
											(				
													SELECT 
														DISTINCT ISNULL(CM.Category,'NA') AS Category FROM CountryMaster AS CM		
														INNER JOIN CompanyConsent AS CC ON CM.Category = CC.Category
													WHERE 
														CM.IsSelected=1 and CC.EmployeeID = @EmployeeID
											)
											BEGIN
												IF(@GetLastCategory='EU')
													BEGIN
														SELECT EU_EmployeeMsg AS ConsentMsg, '1|E' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
												ELSE IF(@GetLastCategory='NonEU')
													BEGIN
														SELECT Non_EUEmployeeMsg AS ConsentMsg, '1|N' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
											END
									END			
								
								IF((@EveryChangeInCategory = @EEFCA_ID) OR (@FristChangeInCategory= @EEFCA_ID))
									BEGIN
										--print 'EveryChangeInCategory / FristChangeInCategory'
										/*check is there any change in category*/
										--PRINT 'case FristChangeInCategory, found new Change in category / new category found'
										IF NOT EXISTS
											(
												SELECT 
													DISTINCT ISNULL(CM.Category,'NA') AS Category FROM CountryMaster AS CM			
													INNER JOIN CompanyConsent AS CC ON CM.Category = CC.Category			
												WHERE 
													CM.IsSelected=1 and CC.EmployeeID = @EmployeeID	and CM.ID = @GetCountryId
											)
											BEGIN
												IF(@GetLastCategory='EU')
													BEGIN
														SELECT EU_EmployeeMsg AS ConsentMsg, '1|E' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
												ELSE IF(@GetLastCategory='NonEU')
													BEGIN
														SELECT Non_EUEmployeeMsg AS ConsentMsg, '1|N' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
											END	
										IF(@COUNT <= 2)
											BEGIN
												--PRINT 'EveryChangeInCategory'
												IF NOT EXISTS
													(
														SELECT 
															DISTINCT ISNULL(CM.Category,'NA') AS Category, EM.EmployeeID FROM CountryMaster AS CM
															INNER JOIN EmployeeMaster AS EM ON CM.ID = @GetCountryId
															INNER JOIN CompanyConsent AS CC ON CM.Category = CC.Category
														WHERE 
															CM.IsSelected=1 and EM.EmployeeID = @EmployeeID
													)
													BEGIN
														IF(@GetLastCategory='EU')
															BEGIN
																SELECT EU_EmployeeMsg AS ConsentMsg, '1|E' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
															END
														ELSE IF(@GetLastCategory='NonEU')
															BEGIN
																SELECT Non_EUEmployeeMsg AS ConsentMsg, '1|N' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
															END
													END
											END

										IF((@EveryChangeInCategory = @EEFCA_ID) AND (@GetLastCategory <> (SELECT TOP 1 category FROM CompanyConsent WHERE EmployeeID=@EmployeeID ORDER BY ECAD DESC)))
											BEGIN
												--print 'Every time change in category'
												IF(@GetLastCategory='EU')
													BEGIN
														SELECT EU_EmployeeMsg AS ConsentMsg, '1|E' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
												ELSE IF(@GetLastCategory='NonEU')
													BEGIN
														SELECT Non_EUEmployeeMsg AS ConsentMsg, '1|N' as IsConsent  FROM MST_EMP_CONSENT_DISCLARATION WHERE Is_Selected = 1
													END
											END
									END
							END	
					END
				END
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS ConsentMsg, 404 as IsConsent
		END CATCH

		/*INSERT INTO COMPANY CONSENT, 'A'*/
		BEGIN TRY
			
			BEGIN /*[GET LAST UPDATED TAX IDENTIFIER COUNTRY FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD MOBILITY TRACKING FOR BASED ON TAX IDENTIFIER COUNTRY SETTING]*/			
				DROP TABLE IF EXISTS tempdb.dbo.#TEMP_ENTITY_DATA
				CREATE TABLE #TEMP_ENTITY_DATA
				(
					SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
					EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE
				)	
				INSERT INTO #TEMP_ENTITY_DATA
				(
					SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
				)	
				EXEC PROC_EMP_MOVEMENT_TRANSFER 'Tax Identifier Country',@EmployeeID
			END

			BEGIN /*[GET DATE OF CHANGE IN CATEGORY DEPENDING ON BASED ON COUNTRY /  TAX IDENTIFIER COUNTRY]*/
				SELECT @Date_of_change_in_category =
				CASE 
					WHEN 					
						@BasedOnCountry = @ECST_ID THEN 
						(
							SELECT TOP 1 REPLACE(REPLACE(CONVERT(VARCHAR, HAT.UpdatedOn ,106), ' ','/'), ',','') FROM HRMSAuditTrails AS HAT 
							INNER JOIN HRMSMappingsFields AS HMF ON HAT.HRMSMappingsFldID = HMF.HRMSMappingsFldID
							WHERE HAT.EmployeeID = @EmployeeID AND HMF.HRMSMappingsFldID=22 ORDER BY HRMSAuditTrailsID DESC
						)
					WHEN 
						@BasedOnTaxIdentiCountry = @ECST_ID THEN 
						(
							SELECT 
								TOP 1 REPLACE(REPLACE(CONVERT(VARCHAR, FROMDATE ,106), ' ','/'), ',','')
							FROM 
								#TEMP_ENTITY_DATA AS TED
							WHERE 
								TODATE IS NULL AND 
								TED.ENTITY = 
								(
									SELECT 
										CM.CountryName 
									FROM 
										CountryMaster AS CM 
									INNER JOIN 
										EmployeeMaster AS EM ON CM.ID = EM.TAX_IDENTIFIER_COUNTRY 
									WHERE 
										EM.EmployeeID= @EmployeeID
								)
							ORDER BY SRNO DESC
						)
				END
				DROP TABLE IF EXISTS tempdb.dbo.#TEMP_ENTITY_DATA
			END

			IF(@ACTION='A')
				BEGIN
					IF(@CompanyLevel = @ECT_ID)
						BEGIN
							/*print 'Company Level'*/
							IF NOT EXISTS(SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID AND (LEN(ISNULL(Category, ''))=0))
								BEGIN	
									INSERT INTO CompanyConsent 
									SELECT @EmployeeID, GETDATE(),@EmployeeID, GETDATE(),'ALL', '', '',''	
								END
						END
					IF NOT EXISTS(SELECT 1 FROM CompanyConsent WHERE EmployeeID = @EmployeeID AND Category = @GetLastCategory)
						BEGIN	
							/*Print 'Save once if there is new category for that employee'*/
							INSERT INTO CompanyConsent							
							SELECT
								@EmployeeID, GETDATE(),@EmployeeID, GETDATE(),CM.Category, CM.CountryAliasName, CM.CountryName,ISNULL(@Date_of_change_in_category,'NA')
							FROM 
								CountryMaster AS CM
							WHERE 
								CM.ID = @GetCountryId
						END
					ELSE IF((@EveryChangeInCategory = @EEFCA_ID) AND (@GetLastCategory <> (SELECT TOP 1 category FROM CompanyConsent WHERE EmployeeID=@EmployeeID ORDER BY ECAD DESC)))
						BEGIN
							/*Print 'Save Every time When change in category'*/
							INSERT INTO CompanyConsent 
							SELECT
								@EmployeeID, GETDATE(),@EmployeeID, GETDATE(),CM.Category, CM.CountryAliasName, CM.CountryName, ISNULL(@Date_of_change_in_category,'NA')
							FROM 
								CountryMaster AS CM
							WHERE 
								CM.ID = @GetCountryId
						END
					ELSE IF(@EveryTime = @EEFCA_ID)
						BEGIN
							/*Print 'Save Every time'*/
							INSERT INTO CompanyConsent 
							SELECT
								@EmployeeID, GETDATE(),@EmployeeID, GETDATE(),CM.Category, CM.CountryAliasName, CM.CountryName, ISNULL(@Date_of_change_in_category,'NA')
							FROM 
								CountryMaster AS CM
							WHERE 
								CM.ID = @GetCountryId
						END
				END
		END TRY
		BEGIN CATCH			
			SELECT ERROR_MESSAGE() AS ConsentMsg, 404 as IsConsent
		END CATCH
	END	
	
	IF(SELECT COUNT(IS_EULA_SET) FROM CompanyMaster WHERE IS_EULA_SET=1)> 0
	BEGIN
		IF(@Action = 'R')
		BEGIN
			/* GET EULA FILE Name or Path*/
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM EULA_ACCEPTANCE where EmployeeId=@EmployeeID)
					BEGIN
						SELECT
							UD.FILEPATH AS EULA
						FROM 
							UPLOADDETAILS UD INNER JOIN CATEGORYMASTER CM ON CM.CATEGORYID = UD.CATEGORYID AND UD.ISDELETED = '0'
						WHERE 						
							CM.CATEGORYID = (SELECT CATEGORYID FROM CATEGORYMASTER WHERE CATEGORYNAME='EULA')
					END					
			END TRY
			BEGIN CATCH			
				SELECT ERROR_MESSAGE() AS ConsentMsg, 404 as IsConsent
			END CATCH
		END
		IF(@Action = 'A')
		BEGIN
			BEGIN TRY
				/*save eula acceptance*/
				IF EXISTS (SELECT 1 FROM UPLOADDETAILS UD INNER JOIN CATEGORYMASTER CM ON CM.CATEGORYID = UD.CATEGORYID AND UD.ISDELETED = '0'
							WHERE CM.CATEGORYID = (SELECT CATEGORYID FROM CATEGORYMASTER WHERE CATEGORYNAME='EULA'))
					BEGIN
						IF NOT EXISTS(SELECT 1 FROM EULA_ACCEPTANCE WHERE EmployeeID = @EmployeeID AND ISNULL(Category, '')='EULA')
						BEGIN	
							/*(EmployeeID, Acceptance_Date, Category, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)*/
							INSERT INTO EULA_ACCEPTANCE
							SELECT @EmployeeID, GETDATE(),'EULA', @EmployeeID, GETDATE(), @EmployeeID, GETDATE()
						END
					END
			END TRY
			BEGIN CATCH			
				SELECT ERROR_MESSAGE() AS ConsentMsg, 404 as IsConsent
			END CATCH
		END
	END
SET NOCOUNT OFF;
END
GO
