/****** Object:  StoredProcedure [dbo].[PROC_CRUD_INTEGRATIONSETTINGS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_INTEGRATIONSETTINGS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_INTEGRATIONSETTINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_INTEGRATIONSETTINGS] 
	@ACTION					CHAR(1),
	@PARAM					VARCHAR(10)  = NULL,
	@USERID					VARCHAR(max) = NULL,
	@DAYS					INT			 = NULL,
	@USERNAME				VARCHAR      = NULL
		
AS
BEGIN
SET NOCOUNT ON;
	
	DECLARE @IsUserId VARCHAR(max) 
	
	CREATE TABLE #TempUserMaster
	(
		chkValue	bit,
		UserID		varchar(max),
		Username	varchar(200),
		EmailId		varchar(100)
	 )
	 
	INSERT INTO #TempUserMaster (chkValue, UserID, Username, EmailId) 
	SELECT '0', USERID, USERNAME, EMAILID FROM USERMASTER 
	WHERE UPPER(ROLEID) NOT IN ('EMPLOYEE','ADMIN') AND ISUSERACTIVE ='Y'
		
	--SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
	
	IF @ACTION='R'  
	BEGIN
		
		IF @PARAM='SCHEME'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForSchemeDet FROM HRMSSettings)
				
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID INT, @MIN_ID INT, @SELECTED_USER_ID VARCHAR(20)
					
					SELECT @MIN_ID = MIN(GSU_ID), @MAX_ID = MAX(GSU_ID) FROM #GET_SELCTED_USER
					
					WHILE (@MIN_ID <= @MAX_ID)
					BEGIN
						
						SELECT @SELECTED_USER_ID = USERS_ID FROM #GET_SELCTED_USER WHERE GSU_ID = @MIN_ID
						
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID
						
						SET @MIN_ID = @MIN_ID + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
		ELSE IF @PARAM='GRANT'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForGrantDet FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_G
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_G
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_G INT, @MIN_ID_G INT, @SELECTED_USER_ID_G VARCHAR(20)
					
					SELECT @MIN_ID_G = MIN(GSU_ID), @MAX_ID_G = MAX(GSU_ID) FROM #GET_SELCTED_USER_G
					
					WHILE (@MIN_ID_G <= @MAX_ID_G)
					BEGIN
						
						SELECT @SELECTED_USER_ID_G = USERS_ID FROM #GET_SELCTED_USER_G WHERE GSU_ID = @MIN_ID_G
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_G
						
						SET @MIN_ID_G = @MIN_ID_G + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
		ELSE IF @PARAM='PERFORM'		 
			BEGIN
				SET @IsUserId = (SELECT UserIDListForPerfVesting FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_P
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_P
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_P INT, @MIN_ID_P INT, @SELECTED_USER_ID_P VARCHAR(20)
					
					SELECT @MIN_ID_P = MIN(GSU_ID), @MAX_ID_P = MAX(GSU_ID) FROM #GET_SELCTED_USER_P
					
					WHILE (@MIN_ID_P <= @MAX_ID_P)
					BEGIN
						
						SELECT @SELECTED_USER_ID_P = USERS_ID FROM #GET_SELCTED_USER_P WHERE GSU_ID = @MIN_ID_P
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_P
						
						SET @MIN_ID_P = @MIN_ID_P + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
			
			ELSE IF @PARAM='CtrTx'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForCtryTxTemp FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_CtrTx
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_CtrTx
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')	
			
					DECLARE @MAX_ID_CtrTx INT, @MIN_ID_CtrTx INT, @SELECTED_USER_ID_CtrTx VARCHAR(20)
					
					SELECT @MIN_ID_CtrTx = MIN(GSU_ID), @MAX_ID_CtrTx = MAX(GSU_ID) FROM #GET_SELCTED_USER_CtrTx
					
					WHILE (@MIN_ID_CtrTx <= @MAX_ID_CtrTx)
					BEGIN
						
						SELECT @SELECTED_USER_ID_CtrTx = USERS_ID FROM #GET_SELCTED_USER_CtrTx WHERE GSU_ID = @MIN_ID_CtrTx
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_CtrTx
						
						SET @MIN_ID_CtrTx = @MIN_ID_CtrTx + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
			
			ELSE IF @PARAM='EmpVestRpt'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForEmpVestRpt FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_EmpVestRpt
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_EmpVestRpt
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_EmpVestRpt INT, @MIN_ID_EmpVestRpt INT, @SELECTED_USER_ID_EmpVestRpt VARCHAR(20)
					
					SELECT @MIN_ID_EmpVestRpt = MIN(GSU_ID), @MAX_ID_EmpVestRpt = MAX(GSU_ID) FROM #GET_SELCTED_USER_EmpVestRpt
					
					WHILE (@MIN_ID_EmpVestRpt <= @MAX_ID_EmpVestRpt)
					BEGIN
						
						SELECT @SELECTED_USER_ID_EmpVestRpt = USERS_ID FROM #GET_SELCTED_USER_EmpVestRpt WHERE GSU_ID = @MIN_ID_EmpVestRpt
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_EmpVestRpt
						
						SET @MIN_ID_EmpVestRpt = @MIN_ID_EmpVestRpt + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
			
			
			ELSE IF @PARAM='TenTxA'
			BEGIN
				SET @IsUserId = (SELECT UserIDListTenFMVTxInpRptA FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_TenFMVTxInpRptA
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_TenFMVTxInpRptA
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_TenFMVTxInpRptA INT, @MIN_ID_TenFMVTxInpRptA INT, @SELECTED_USER_ID_TenFMVTxInpRptA VARCHAR(20)
					
					SELECT @MIN_ID_TenFMVTxInpRptA = MIN(GSU_ID), @MAX_ID_TenFMVTxInpRptA = MAX(GSU_ID) FROM #GET_SELCTED_USER_TenFMVTxInpRptA
					
					WHILE (@MIN_ID_TenFMVTxInpRptA <= @MAX_ID_TenFMVTxInpRptA)
					BEGIN
						
						SELECT @SELECTED_USER_ID_TenFMVTxInpRptA = USERS_ID FROM #GET_SELCTED_USER_TenFMVTxInpRptA WHERE GSU_ID = @MIN_ID_TenFMVTxInpRptA
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_TenFMVTxInpRptA
						
						SET @MIN_ID_TenFMVTxInpRptA = @MIN_ID_TenFMVTxInpRptA + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
			
			ELSE IF @PARAM='TenTxB'
			BEGIN
				SET @IsUserId = (SELECT UserIDListTenFMVTxInpRptB FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_TenFMVTxInpRptB
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_TenFMVTxInpRptB
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_TenFMVTxInpRptB INT, @MIN_ID_TenFMVTxInpRptB INT, @SELECTED_USER_ID_TenFMVTxInpRptB VARCHAR(20)
					
					SELECT @MIN_ID_TenFMVTxInpRptB = MIN(GSU_ID), @MAX_ID_TenFMVTxInpRptB = MAX(GSU_ID) FROM #GET_SELCTED_USER_TenFMVTxInpRptB
					
					WHILE (@MIN_ID_TenFMVTxInpRptB <= @MAX_ID_TenFMVTxInpRptB)
					BEGIN
						
						SELECT @SELECTED_USER_ID_TenFMVTxInpRptB = USERS_ID FROM #GET_SELCTED_USER_TenFMVTxInpRptB WHERE GSU_ID = @MIN_ID_TenFMVTxInpRptB
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_TenFMVTxInpRptB
						
						SET @MIN_ID_TenFMVTxInpRptB = @MIN_ID_TenFMVTxInpRptB + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
			
			ELSE IF @PARAM='EmpTxTemp'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForEmpTaxTemp FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_EmpTxTemp
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_EmpTxTemp
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
			
					DECLARE @MAX_ID_EmpTxTemp INT, @MIN_ID_EmpTxTemp INT, @SELECTED_USER_ID_EmpTxTemp VARCHAR(20)
					
					SELECT @MIN_ID_EmpTxTemp = MIN(GSU_ID), @MAX_ID_EmpTxTemp = MAX(GSU_ID) FROM #GET_SELCTED_USER_EmpTxTemp
					
					WHILE (@MIN_ID_EmpTxTemp <= @MAX_ID_EmpTxTemp)
					BEGIN
						
						SELECT @SELECTED_USER_ID_EmpTxTemp = USERS_ID FROM #GET_SELCTED_USER_EmpTxTemp WHERE GSU_ID = @MIN_ID_EmpTxTemp
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_EmpTxTemp
						
						SET @MIN_ID_EmpTxTemp = @MIN_ID_EmpTxTemp + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END				

			ELSE IF @PARAM='ActFMVTx'
			BEGIN
				SET @IsUserId = (SELECT UserIDListForActFMVTxPaidRpt FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_ActFMVTx
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_ActFMVTx
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_ActFMVTx INT, @MIN_ID_ActFMVTx INT, @SELECTED_USER_ID_ActFMVTx VARCHAR(20)
					
					SELECT @MIN_ID_ActFMVTx = MIN(GSU_ID), @MAX_ID_ActFMVTx = MAX(GSU_ID) FROM #GET_SELCTED_USER_ActFMVTx
					
					WHILE (@MIN_ID_ActFMVTx <= @MAX_ID_ActFMVTx)
					BEGIN
						
						SELECT @SELECTED_USER_ID_ActFMVTx = USERS_ID FROM #GET_SELCTED_USER_ActFMVTx WHERE GSU_ID = @MIN_ID_ActFMVTx
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_ActFMVTx
						
						SET @MIN_ID_ActFMVTx = @MIN_ID_ActFMVTx + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
			

				ELSE IF @PARAM='TxDiffTmp'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForTxDiffTemp FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_TxDiffTmp
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_TxDiffTmp
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_TxDiffTmp INT, @MIN_ID_TxDiffTmp INT, @SELECTED_USER_ID_TxDiffTmp VARCHAR(20)
					
					SELECT @MIN_ID_TxDiffTmp = MIN(GSU_ID), @MAX_ID_TxDiffTmp = MAX(GSU_ID) FROM #GET_SELCTED_USER_TxDiffTmp
					
					WHILE (@MIN_ID_TxDiffTmp <= @MAX_ID_TxDiffTmp)
					BEGIN
						
						SELECT @SELECTED_USER_ID_TxDiffTmp = USERS_ID FROM #GET_SELCTED_USER_TxDiffTmp WHERE GSU_ID = @MIN_ID_TxDiffTmp
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_TxDiffTmp
						
						SET @MIN_ID_TxDiffTmp = @MIN_ID_TxDiffTmp + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END			

				ELSE IF @PARAM='EmpBroDtls'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForEmpBroDtls FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_EmpBroDtls
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_EmpBroDtls
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_EmpBroDtls INT, @MIN_ID_EmpBroDtls INT, @SELECTED_USER_ID_EmpBroDtls VARCHAR(20)
					
					SELECT @MIN_ID_EmpBroDtls = MIN(GSU_ID), @MAX_ID_EmpBroDtls = MAX(GSU_ID) FROM #GET_SELCTED_USER_EmpBroDtls
					
					WHILE (@MIN_ID_EmpBroDtls <= @MAX_ID_EmpBroDtls)
					BEGIN
						
						SELECT @SELECTED_USER_ID_EmpBroDtls = USERS_ID FROM #GET_SELCTED_USER_EmpBroDtls WHERE GSU_ID = @MIN_ID_EmpBroDtls
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_EmpBroDtls
						
						SET @MIN_ID_EmpBroDtls = @MIN_ID_EmpBroDtls + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
			
				ELSE IF @PARAM='SleOdrMSSB'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForSleOdrMSSB FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_SleOdrMSSB
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_SleOdrMSSB
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
			
					DECLARE @MAX_ID_SleOdrMSSB INT, @MIN_ID_SleOdrMSSB INT, @SELECTED_USER_ID_SleOdrMSSB VARCHAR(20)
					
					SELECT @MIN_ID_SleOdrMSSB = MIN(GSU_ID), @MAX_ID_SleOdrMSSB = MAX(GSU_ID) FROM #GET_SELCTED_USER_SleOdrMSSB
					
					WHILE (@MIN_ID_SleOdrMSSB <= @MAX_ID_SleOdrMSSB)
					BEGIN
						
						SELECT @SELECTED_USER_ID_SleOdrMSSB = USERS_ID FROM #GET_SELCTED_USER_SleOdrMSSB WHERE GSU_ID = @MIN_ID_SleOdrMSSB
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_SleOdrMSSB
						
						SET @MIN_ID_SleOdrMSSB = @MIN_ID_SleOdrMSSB + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END	
			
				ELSE IF @PARAM='SleCfrmDtls'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForSleCfirmDtls FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_SleCfrmDtls
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_SleCfrmDtls
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
						
					DECLARE @MAX_ID_SleCfrmDtls INT, @MIN_ID_SleCfrmDtls INT, @SELECTED_USER_ID_SleCfrmDtls VARCHAR(20)
					
					SELECT @MIN_ID_SleCfrmDtls = MIN(GSU_ID), @MAX_ID_SleCfrmDtls = MAX(GSU_ID) FROM #GET_SELCTED_USER_SleCfrmDtls
					
					WHILE (@MIN_ID_SleCfrmDtls <= @MAX_ID_SleCfrmDtls)
					BEGIN
						
						SELECT @SELECTED_USER_ID_SleCfrmDtls = USERS_ID FROM #GET_SELCTED_USER_SleCfrmDtls WHERE GSU_ID = @MIN_ID_SleCfrmDtls
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_SleCfrmDtls
						
						SET @MIN_ID_SleCfrmDtls = @MIN_ID_SleCfrmDtls + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
			
			ELSE IF @PARAM='AdrAllot'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForADRAllotMandate FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_AdrAllot
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_AdrAllot
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
			
					DECLARE @MAX_ID_AdrAllot INT, @MIN_ID_AdrAllot INT, @SELECTED_USER_ID_AdrAllot VARCHAR(20)
					
					SELECT @MIN_ID_AdrAllot = MIN(GSU_ID), @MAX_ID_AdrAllot = MAX(GSU_ID) FROM #GET_SELCTED_USER_AdrAllot
					
					WHILE (@MIN_ID_AdrAllot <= @MAX_ID_AdrAllot)
					BEGIN
						
						SELECT @SELECTED_USER_ID_AdrAllot = USERS_ID FROM #GET_SELCTED_USER_AdrAllot WHERE GSU_ID = @MIN_ID_AdrAllot
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_AdrAllot
						
						SET @MIN_ID_AdrAllot = @MIN_ID_AdrAllot + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
			
			ELSE IF @PARAM='NonPayExc'
				BEGIN
				SET @IsUserId = (SELECT UserIDListForNonExCaseDtls FROM HRMSSettings)
				IF(@IsUserId IS NULL) 
				BEGIN
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				END		
				ELSE
				BEGIN
					CREATE TABLE #GET_SELCTED_USER_NonPayExc
					(	
						GSU_ID		INT IDENTITY (1,1),
						USERS_ID	VARCHAR(MAX)					
					)	
			
					INSERT INTO #GET_SELCTED_USER_NonPayExc
					SELECT * FROM dbo.fn_MVParam(@IsUserId,',')
				
					DECLARE @MAX_ID_NonPayExc INT, @MIN_ID_NonPayExc INT, @SELECTED_USER_ID_NonPayExc VARCHAR(20)
					
					SELECT @MIN_ID_NonPayExc = MIN(GSU_ID), @MAX_ID_NonPayExc = MAX(GSU_ID) FROM #GET_SELCTED_USER_NonPayExc
					
					WHILE (@MIN_ID_NonPayExc <= @MAX_ID_NonPayExc)
					BEGIN
						
						SELECT @SELECTED_USER_ID_NonPayExc = USERS_ID FROM #GET_SELCTED_USER_NonPayExc WHERE GSU_ID = @MIN_ID_NonPayExc
					
						UPDATE #TempUserMaster SET chkValue = 1 WHERE UserID = @SELECTED_USER_ID_NonPayExc
						
						SET @MIN_ID_NonPayExc = @MIN_ID_NonPayExc + 1  
					END
									
					SELECT chkValue, UserID, Username, EmailId FROM #TempUserMaster
				
				END	
			END
															
		ELSE IF @PARAM='PATH'
		BEGIN
			SELECT 
				UserIDListForPerfVesting,SFTPPathForPerfVesting,FileNameForPerfVesting,IsProcAutomatedForPerfVesting,TempNameForPerfVesting,
				UserIDListForSchemeDet,SFTPPathForSchemeDet,FileNameForSchemeDet,IsProcAutomatedForSchemeDet,TempNameForSchemeDet,
				UserIDListForGrantDet,SFTPPathForGrantDet,FileNameForGrantDet,IsProcAutomatedForGrantDet,TempNameForGrantDet,
				UserIDListForCtryTxTemp,SFTPPathForCtryTxTemp,FileNameForCtryTxTemp,IsProcAutomatedForCtryTxTemp,TempNameForCtryTxTemp,
				UserIDListForEmpVestRpt,SFTPPathForEmpVestRpt,FileNameForEmpVestRpt,IsProcAutomatedForEmpVestRpt,TempNameForEmpVestRpt, 
				UserIDListTenFMVTxInpRptA,SFTPPathForTenFMVTxInpRptA,FileNameForTenFMVTxInpRptA,IsProcAutomatedForTenFMVTxInpRptA,TempNameForTenFMVTxInpRptA,NoOfDaysForTenFMVTxInpRptA, 
				UserIDListTenFMVTxInpRptB,SFTPPathForTenFMVTxInpRptB,FileNameForTenFMVTxInpRptB,IsProcAutomatedForTenFMVTxInpRptB,TempNameForTenFMVTxInpRptB,NoOfDaysForTenFMVTxInpRptB, 
				UserIDListForEmpTaxTemp,SFTPPathForEmpTaxTemp,FileNameForEmpTaxTemp,IsProcAutomatedForEmpTaxTemp,TempNameForEmpTaxTemp,
				UserIDListForActFMVTxPaidRpt,SFTPPathForActFMVTxPaidRpt,FileNameForActFMVTxPaidRpt,IsProcAutomatedForActFMVTxPaidRpt,TempNameForActFMVTxPaidRpt,NoOfDaysForActFMVTxPaidRpt,
				UserIDListForTxDiffTemp,SFTPPathForTxDiffTemp,FileNameForTxDiffTemp,IsProcAutomatedForTxDiffTemp,TempNameForTxDiffTemp,NoOfDaysForTxDiffTemp,
				UserIDListForEmpBroDtls,SFTPPathForEmpBroDtls,FileNameForEmpBroDtls,IsProcAutomatedForEmpBroDtls,TempNameForEmpBroDtls,
				UserIDListForSleOdrMSSB,SFTPPathForSleOdrMSSB,FileNameForSleOdrMSSB,IsProcAutomatedForSleOdrMSSB,TempNameForSleOdrMSSB,
				UserIDListForSleCfirmDtls,SFTPPathForSleCfirmDtls,FileNameForSleCfirmDtls,IsProcAutomatedForSleCfirmDtls,TempNameForSleCfirmDtls,
				UserIDListForADRAllotMandate,SFTPPathForADRAllotMandate,FileNameForADRAllotMandate,IsProcAutomatedADRAllotMandate,TempNameForADRAllotMandate,
				UserIDListForNonExCaseDtls,SFTPPathForNonExCaseDtls,FileNameForNonExCaseDtls,IsProcAutomatedNonExCaseDtls,TempNameForNonExCaseDtls,NoOfDaysForEmpTxTemp,NoOfDaysForEmpVestRpt,
				IsSecureFile,PublicKey,PrivateKey,Password		
			FROM 
			HRMSSettings
		END
	END
	
	IF @ACTION='U'
	BEGIN
		IF @PARAM='SCHEME'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForSchemeDet=@USERID
		END
		
		IF @PARAM='GRANT'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForGrantDet=@USERID
		END
		
		IF @PARAM='PERFORM'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForPerfVesting=@USERID
		END
		
		IF @PARAM='CtrTx'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForCtryTxTemp=@USERID
		END
		
		IF @PARAM='EmpVestRpt'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForEmpVestRpt=@USERID
		END
		
		IF @PARAM='TenTxA'
		BEGIN
			UPDATE HRMSSettings SET UserIDListTenFMVTxInpRptA=@USERID
		END
		
		IF @PARAM='TenTxB'
		BEGIN
			UPDATE HRMSSettings SET UserIDListTenFMVTxInpRptB=@USERID
		END
		
		IF @PARAM='EmpTxTemp'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForEmpTaxTemp=@USERID
		END
		
		IF @PARAM='ActFMVTx'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForActFMVTxPaidRpt=@USERID
		END
		
		IF @PARAM='TxDiffTmp'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForTxDiffTemp=@USERID
		END
		
		IF @PARAM='EmpBroDtls'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForEmpBroDtls=@USERID
		END
		
		IF @PARAM='SleOdrMSSB'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForSleOdrMSSB=@USERID
		END
		
		IF @PARAM='SleCfrmDtls'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForSleCfirmDtls=@USERID
		END
		
		IF @PARAM='AdrAllot'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForADRAllotMandate=@USERID
		END
		
			IF @PARAM='NonPayExc'
		BEGIN
			UPDATE HRMSSettings SET UserIDListForNonExCaseDtls=@USERID
		END
		
		IF @PARAM='DAYS'
		BEGIN
			UPDATE HRMSSettings SET AlertBeforeNoOfDaysForPerfVesting=@DAYS
		END
	END
END
GO
