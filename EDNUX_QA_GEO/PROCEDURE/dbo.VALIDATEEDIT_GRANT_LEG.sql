/****** Object:  StoredProcedure [dbo].[VALIDATEEDIT_GRANT_LEG]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[VALIDATEEDIT_GRANT_LEG]
GO
/****** Object:  StoredProcedure [dbo].[VALIDATEEDIT_GRANT_LEG]    Script Date: 7/6/2022 1:40:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[VALIDATEEDIT_GRANT_LEG]
AS
BEGIN
---------------------------------------------- DATA DECLERATION START ------------------------------------------------------------------
	 --DECALRE VARIABLE'S
	 DECLARE 
		 @GOPID VARCHAR(100),
		 @ED_ID INT, 
		 @ED_VESTINGTYPE CHAR,
		 @GLID VARCHAR(10),  
		 @VESTINGDATE DATETIME,  
		 @GL_VESTEDOPTIONS NUMERIC(18,0),  
		 @EXPIRYDATE DATETIME,  
		 @GRANTEDOPTIONS NUMERIC(18,0),  
		 @GL_VESTINGDATE DATETIME,  
		 @GL_EXPIRYDATE DATETIME,
		 @ED_GRANTDATE DATETIME,  
		 @GL_OPTION NUMERIC(18,0),  
		 @PARENT CHAR,  
		 @GL_BONUS NUMERIC(18,0),  
		 @EXERCISED NUMERIC(18,0),  
		 @UNAPPROVEEXD NUMERIC(18,0),  
		 @LAPSED NUMERIC(18,0),  
		 @GL_CANCELLED NUMERIC(18,0),  
		 @GL_BONUSCANC NUMERIC(18,0),  
		 @MAX INT,  
		 @MIN INT,  
		 @ISVESTING CHAR,  
		 @ISGRANTED CHAR,  
		 @ISEXPIRY CHAR,  
		 @VALIDATIONMSG VARCHAR(800),
		 @ISPERFORMANCE VARCHAR(1),
		 @GL_STATUS CHAR,  
		 @SUM INT,
		 @TEMPSUM INT,
		 @GL_GRNTLGID INT,
		 @RCOUNT INT, 	
		 @PENDING_COUNT INT
	 --CREATE TABLE DEFINATION
	 CREATE TABLE #TEMP2 
	 (
		[Row_no] [int] identity(1,1),
		[ID] [numeric](18, 0) NULL,
		[SRNO] [int] NOT NULL,		
		[GRANTLEGID] [decimal](10, 0) NULL,
		[GRANTOPTIONID] [varchar](100) NULL,
		[VESTINGDATE] [datetime] NULL,
		[EXPIRYDATE] [datetime] NULL,
		[OPTIONSGRANTED] [numeric](18, 0) NULL,
		[PARENT] [char](1) NULL,
		[Status] [char](1) NULL,
		[GRANTDATE] [datetime] NULL,
		[GRANTID] [numeric](10, 0) NULL,
		[VESTINGTYPE] [char](1) NULL,
		[FinalExpirayDate] [datetime] NULL,
		[FINALVESTINGDATE] [datetime] NULL,
		[GRANTEDOPTIONS] [numeric](18, 0) NULL,
		[BONUSSPLITQUANTITY] [numeric](18, 0) NULL,
		[EXERCISEDQUANTITY] [numeric](18, 0) NULL,
		[UNAPPROVEDEXERCISEQUANTITY] [numeric](18, 0) NULL,
		[EXERCISABLEQUANTITY] [numeric](18, 0) NULL,
		[LAPSEDQUANTITY] [numeric](18, 0) NULL,
		[CANCELLEDQUANTITY] [numeric](18, 0) NULL,
		[BONUSSPLITCANCELLEDQUANTITY] [numeric](18, 0) NULL,
		[ISVESTINGUPDATE] [varchar](1) NOT NULL,
		[ISEXPIRYUPDATE] [varchar](1) NOT NULL,
		[ISGRANTEDOPTIONS] [varchar](1) NOT NULL,
		[ISPERFORMANCEBASE] [VARCHAR](1) NULL,
		[EQ_REMARK] [varchar](MAX) NULL,
		[REMARK] [varchar](MAX) NULL
	 )
 
	 INSERT INTO #TEMP2  
	SELECT MAX(GL.ID) AS ID,
		ED.SRNO, 
		GL.GRANTLEGID,
		ED.GRANTOPTIONID,  
		ED.VESTINGDATE,
		ED.EXPIRYDATE,
		ED.OPTIONSGRANTED,  
		ED.PARENT,  
		GL.STATUS,
		ED.GRANTDATE,
		ED.GRANTID,
		ED.VESTINGTYPE,		  
		GL.FINALEXPIRAYDATE,
		GL.FINALVESTINGDATE,
		GL.GRANTEDOPTIONS,
		GL.BONUSSPLITQUANTITY,  
		GL.EXERCISEDQUANTITY,
		GL.UNAPPROVEDEXERCISEQUANTITY,
		GL.EXERCISABLEQUANTITY,
		GL.LAPSEDQUANTITY,   
		GL.CANCELLEDQUANTITY,
		GL.BONUSSPLITCANCELLEDQUANTITY,       
		 
		CASE WHEN ((ED.VESTINGDATE <> GL.VESTINGDATE) OR (ED.VESTINGDATE <> GL.FINALVESTINGDATE)) THEN 'Y' ELSE 'N' END AS ISVESTINGUPDATE,  
		CASE WHEN ((ED.EXPIRYDATE <> GL.EXPIRAYDATE) OR (ED.EXPIRYDATE <> GL.FINALEXPIRAYDATE))  THEN 'Y' ELSE 'N' END AS ISEXPIRYUPDATE,  
		CASE WHEN ((ED.OPTIONSGRANTED <> GL.GRANTEDOPTIONS)AND(ED.OPTIONSGRANTED <> GL.BONUSSPLITQUANTITY)) THEN 'Y' ELSE 'N' END  AS ISGRANTEDOPTIONS,    
		GL.ISPERFBASED,
		NULL,
		NULL
		
		FROM   GRANTLEG  GL
				RIGHT  JOIN  EDIT_GRANT_MASSUPLOAD ED ON GL.GRANTOPTIONID = ED.GRANTOPTIONID 
				AND   GL.GRANTLEGID = ED.VESTINGPERIODID 
				AND GL.PARENT = ED.PARENT  
				AND ED.GRANTID = GL.ID
		WHERE   ED.VESTINGDATE != GL.FINALVESTINGDATE OR ED.EXPIRYDATE != GL.FINALEXPIRAYDATE   
				OR ED.OPTIONSGRANTED != GL.GRANTEDOPTIONS   
		GROUP BY	ED.SRNO, 
					GL.GRANTLEGID,
					ED.GRANTOPTIONID,  
					ED.VESTINGDATE,
					ED.EXPIRYDATE,
					ED.OPTIONSGRANTED,  
					ED.PARENT,  
					GL.STATUS,
					ED.GRANTDATE,
				  
					GL.FINALEXPIRAYDATE,
					GL.FINALVESTINGDATE,
					GL.GRANTEDOPTIONS,
					GL.BONUSSPLITQUANTITY,  
					GL.EXERCISEDQUANTITY,
					GL.UNAPPROVEDEXERCISEQUANTITY,
					GL.EXERCISABLEQUANTITY,
					GL.LAPSEDQUANTITY,   
					GL.CANCELLEDQUANTITY,
					GL.BONUSSPLITCANCELLEDQUANTITY ,   
					ED.GRANTID,
					ED.VESTINGTYPE,
					GL.ISPERFBASED,  
					 
		CASE WHEN ((ED.VESTINGDATE <> GL.VESTINGDATE) OR (ED.VESTINGDATE <> GL.FINALVESTINGDATE)) THEN 'Y' ELSE 'N' END ,  
		CASE WHEN ((ED.EXPIRYDATE <> GL.EXPIRAYDATE) OR (ED.EXPIRYDATE <> GL.FINALEXPIRAYDATE))  THEN 'Y' ELSE 'N' END ,  
		CASE WHEN ((ED.OPTIONSGRANTED <> GL.GRANTEDOPTIONS)AND(ED.OPTIONSGRANTED <> GL.BONUSSPLITQUANTITY)) THEN 'Y' ELSE 'N' END    

		ORDER BY	ED.SRNO, 
					ED.GRANTOPTIONID 
	 
	 --CREATE DUMMY TABLE FOR INSERT VALIDATE RECORD IN TABLE.
	 SELECT TOP 1 * INTO #TEMP3 FROM SHGRANTLEG WHERE ID = null

	 --SET VALUE TO DEFAULT FLAGS.	
	 SET @ISVESTING = 0  
	 SET @ISGRANTED = 0  
	 SET @ISEXPIRY = 0  
	
	---[START:]Check whether the Vesting Date or Expiry Date is different for a particular GrantOptionID and VestingPeriodID-----------------
	DECLARE  @CNT_ROW AS INT, @TOTAL_ROWS AS INT, @GrantOptionId varchar(100) = null, @GRANTLEGID varchar(20) = null
			
	SELECT * INTO #VESTING_EXPIRY_DATE_TBL FROM
	(
		SELECT * FROM 
			(SELECT EGM1.GRANTOPTIONID, EGM1.VESTINGPERIODID, COUNT(EGM1.SRNO) AS COUNTOFDATE, ' ' AS REMARK FROM EDIT_GRANT_MASSUPLOAD EGM1 
					INNER JOIN EDIT_GRANT_MASSUPLOAD EGM2 ON  EGM1.GRANTOPTIONID = EGM2.GRANTOPTIONID AND EGM1.VESTINGPERIODID = EGM2.VESTINGPERIODID
					WHERE EGM1.VESTINGDATE <> EGM2.VESTINGDATE OR EGM1.EXPIRYDATE <> EGM2.EXPIRYDATE
					GROUP BY EGM1.GRANTOPTIONID, EGM1.VESTINGPERIODID
			) 
		AS FINAL_DATA
	) FINAL_DATA

	IF EXISTS (SELECT 1 FROM #VESTING_EXPIRY_DATE_TBL) 
	BEGIN
		WHILE EXISTS(SELECT 1 FROM #VESTING_EXPIRY_DATE_TBL WHERE REMARK = '')
		BEGIN
			SELECT TOP 1 @GrantOptionId = GRANTOPTIONID, @GRANTLEGID = VESTINGPERIODID FROM #VESTING_EXPIRY_DATE_TBL WHERE REMARK = ''
			UPDATE #TEMP2 SET REMARK = 'Validation Message : Date needs to be changed for the corresponding Normal Or Bonus OR Split entry for same grant leg.' +' GrantOptionId :' + @GrantOptionId +' Leg Id : ' + CONVERT(VARCHAR(2),@GRANTLEGID) + '.' where GRANTOPTIONID = @GrantOptionId AND GRANTLEGID = @GRANTLEGID	
			UPDATE #VESTING_EXPIRY_DATE_TBL SET REMARK = '-' WHERE GRANTOPTIONID = @GrantOptionId AND VESTINGPERIODID = @GRANTLEGID
		END		
	END	
	---[END:]Check whether the Vesting Date or Expiry Date is different for a particular GrantOptionID and VestingPeriodID-----------------

	--SET MIN AND MAX VALUE TO VARIABLE FOR DATA PROCESSING.
	 SELECT @MIN=MIN(SRNO),
			@MAX = MAX(SRNO)  
	 FROM	#TEMP2 
	 --SELECT * FROM #TEMP2
	 
	 
------------------------------------------- DATA DECLERATION END ---------------------------------------------------------------------	 
	  PRINT '---VALIDATION START-----'	
		WHILE (@MIN<=@MAX)  
		BEGIN
		 --cONDITIONAL LOOP START
			IF EXISTS (SELECT 1 FROM #TEMP2 WHERE SRNO = @MIN)
			BEGIN
					PRINT 'MIN  '+ CONVERT(VARCHAR(4),@MIN)
					PRINT 'MAX  '+ CONVERT(VARCHAR(4),@MAX)
					
					PRINT '----VALUE FETCH START ----'			
						SELECT 	@GOPID=GRANTOPTIONID,
							@VESTINGDATE=VESTINGDATE,
							@EXPIRYDATE=EXPIRYDATE,
							@GRANTEDOPTIONS=OPTIONSGRANTED,
							@PARENT = PARENT,
							@GL_STATUS = Status,      
							@GL_EXPIRYDATE=FinalExpirayDate,
							@GL_VESTINGDATE=FINALVESTINGDATE,
							@GL_OPTION = GRANTEDOPTIONS,
							@GL_BONUS = BONUSSPLITQUANTITY,
							@GL_GRNTLGID = GRANTLEGID,
							@EXERCISED = EXERCISEDQUANTITY, 
							@UNAPPROVEEXD = UNAPPROVEDEXERCISEQUANTITY,
							@GL_VESTEDOPTIONS=EXERCISABLEQUANTITY, 
							@LAPSED = LAPSEDQUANTITY,   
							@GL_CANCELLED = CANCELLEDQUANTITY, 
							@GL_BONUSCANC = BONUSSPLITCANCELLEDQUANTITY,
							@GLID = ID,
							@ISPERFORMANCE = ISPERFORMANCEBASE, 
							@ISVESTING = ISVESTINGUPDATE ,  
							@ISEXPIRY  = ISEXPIRYUPDATE,  
							@ISGRANTED = ISGRANTEDOPTIONS,
							@ED_VESTINGTYPE = VESTINGTYPE,
							@ED_GRANTDATE = GRANTDATE 
					FROM   #TEMP2   
					WHERE  SRNO = @MIN			
					PRINT '----VALUE FETCH ENDED ----'
					
					PRINT 'VALIDATION START : ' + 'EXPIRY FLAG: '+ @ISEXPIRY + ' ; VESTING FLAG: '+ @ISVESTING + ' ; GRANTED FLAG: '+ @ISGRANTED 
			-----------------------------------------------------------------------------------------------------------------------------------
				IF(@ISEXPIRY = 'Y')
				BEGIN
					IF(@EXPIRYDATE > @ED_GRANTDATE AND @EXPIRYDATE >= @VESTINGDATE)
						BEGIN
							PRINT 'ENTER INTO LOOP1.'
							PRINT CONVERT(DATE,GETDATE())
						--------------------------------------------------------
							IF(@EXPIRYDATE >= CONVERT(DATE,GETDATE()))
								BEGIN
									--IF LOOP VESTING = 'Y' START --
								   IF(@ISVESTING ='Y')
									BEGIN
											IF(@VESTINGDATE >= @ED_GRANTDATE AND @VESTINGDATE <= @EXPIRYDATE)
											BEGIN
												 --IF LOOP 100 START---
												 IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)
												 BEGIN
													SET @VALIDATIONMSG = 'Validation Message : Vesting date cannot be before grant date and after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
													UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
												 END
												 --IF LOOP 100 END-----
												 ELSE
												 BEGIN
													--IF LOOP 200 START -- 
													IF(@ISGRANTED ='Y')
													BEGIN
														SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID 
														SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID
														PRINT('SUM')
														PRINT(@SUM)
														PRINT('TEMPSUM')
														PRINT(@TEMPSUM)
														PRINT('ISPERFORMANCE')
														PRINT(@ISPERFORMANCE)
														PRINT('VESTING TYPE')
														PRINT(@ED_VESTINGTYPE)
														 ------------------------------------------------------
														 IF(@SUM = @TEMPSUM)	
															BEGIN
																--IF LOOP 300 START --
																IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
																	BEGIN
																		PRINT 'WHEN PERFORMANCE DIDN"T UPLOAD'
																		INSERT INTO #TEMP3 
																		(
																			ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																			GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																			SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																			SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																			SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																			BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																			SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																			IsSplit,TempExercisableQuantity
																		)
																		SELECT 
																			ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																			GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																			SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																			SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																			SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																			BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																			SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																			IsSplit,TempExercisableQuantity
																		FROM GRANTLEG WHERE ID=@GLID 
																		UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																						EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																						GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																						SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																						LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																	END
																--IF LOOP 300 END --
																ELSE
																	BEGIN
																		INSERT INTO #TEMP3 
																		(
																			ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																			GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																			SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																			SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																			SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																			BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																			SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																			IsSplit,TempExercisableQuantity
																		)																		
																		SELECT 
																			ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																			GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																			SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																			SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																			SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																			BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																			SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																			IsSplit,TempExercisableQuantity
																		FROM GRANTLEG WHERE ID=@GLID 
																		UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																						EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																						GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																						SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																						EXERCISABLEQUANTITY = @GRANTEDOPTIONS,
																						LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																	END
																--ELSE LOOP 300 END --		
															END
														 ELSE
															BEGIN
																SET @VALIDATIONMSG = 'Validation Message : Total options granted does not match with the original total options granted.'  
																UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
															END
													END
													--IF LOOP 200 END -- 
													ELSE
													BEGIN
															--IF LOOP 2.100 START--
															IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
																BEGIN
																	INSERT INTO #TEMP3 
																	(
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity
																	)
																	SELECT 
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity	
																	FROM GRANTLEG WHERE ID=@GLID 
																	UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,VESTINGDATE=@VESTINGDATE,
																					  FINALVESTINGDATE=@VESTINGDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																					  LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID 
																END
															--IF LOOP 2.100 END--
															ELSE
																BEGIN
																	INSERT INTO #TEMP3 
																	(
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity
																	)
																	SELECT 
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity
																	FROM GRANTLEG WHERE ID=@GLID 
																	UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,VESTINGDATE=@VESTINGDATE,
																					  FINALVESTINGDATE=@VESTINGDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																					  LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID 
																END
															--ELSE LOOP 2.100 END--
														END
													--ELSE LOOP 200 END -- 
												 END
												 --ELSE LOOP 100 END---
											END
											
											ELSE 
											BEGIN
												SET @VALIDATIONMSG =  'Validation Message : Vesting date cannot be before grant date and after the expiry date. Please check.'   
												UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											END
									END
									--IF LOOP VESTING = 'Y' END --
								   ELSE 
									BEGIN
										IF((@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)AND(@ISGRANTED = 'Y'))
											BEGIN
												PRINT ''
													SET @VALIDATIONMSG = 'Validation Message : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
													UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
												PRINT ''
											END
										ELSE
											BEGIN
												PRINT ''
												IF(@ISGRANTED = 'Y')
													BEGIN
														PRINT 'modify the expiry date with adjust granted options :-- start'
															IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
															BEGIN
																INSERT INTO #TEMP3 
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																FROM GRANTLEG WHERE ID=@GLID 
																UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																			GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																			SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																			LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															END
															ELSE
															BEGIN
																INSERT INTO #TEMP3 
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)	
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity 
																FROM GRANTLEG 
																WHERE ID=@GLID 
																
																UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																			GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																			SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																			EXERCISABLEQUANTITY = @GRANTEDOPTIONS,
																			LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															
															END
														PRINT 'modify the expiry date with adjust granted options :-- end'
													END
												ELSE
													BEGIN
														PRINT 'Modify the expiry date :-- start'
															INSERT INTO #TEMP3
															(
																ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																IsSplit,TempExercisableQuantity
															)
															SELECT
																ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																IsSplit,TempExercisableQuantity
															FROM GRANTLEG 
															WHERE ID=@GLID
															
															UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,																	  
																		  LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
														PRINT 'Modify the expiry date :-- end'
													END
												PRINT ''
											END
									END
									--ELSE LOOP VESTING = 'Y' END (i.e. VESTING='N') --
								END
						--------------------------------------------------------		
							ELSE IF(@EXPIRYDATE < CONVERT(DATE,GETDATE()))
								BEGIN
								   PRINT ''
									--IF LOOP VESTING = 'Y' START --
								   IF(@ISVESTING ='Y')
									BEGIN
										IF(@VESTINGDATE >= @ED_GRANTDATE AND @VESTINGDATE <= @EXPIRYDATE)
											BEGIN
												 --IF LOOP 100 START---
												 IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)
													 BEGIN 
														SET @VALIDATIONMSG = 'Validation Message : Vesting date cannot be before grant date and after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
														UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
													 END
												 ELSE
													 BEGIN 
														PRINT 'MODIFY THE VESTING DATE AND EXPIRY DATE : START'
															IF(@ISGRANTED ='Y')
																BEGIN
																	PRINT 'CHECKING FOR GRANTED OPTIONS'
																	SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID 
																	SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID
																	PRINT('SUM')
																	PRINT(@SUM)
																	PRINT('TEMPSUM')
																	PRINT(@TEMPSUM)
																	PRINT('ISPERFORMANCE')
																	PRINT(@ISPERFORMANCE)
																	PRINT('VESTING TYPE')
																	PRINT(@ED_VESTINGTYPE)
																-------------------------------------
																	IF(@SUM = @TEMPSUM)
																	BEGIN
																		IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
																			BEGIN
																				INSERT INTO #TEMP3 
																				(
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				)	
																				SELECT 
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				FROM GRANTLEG WHERE ID=@GLID 
																				UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																							EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																							GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																							SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																							LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																			END
																		ELSE
																			BEGIN
																				SET @VALIDATIONMSG =  'Validation Message : Not Possible through code. Please check.'   
																				UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
																			END
																	END
																-------------------------------------
																END	
															ELSE
																BEGIN
																	PRINT 'CHECKING FOR expiry and vesting date : Start'
																		IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
																			BEGIN 
																				INSERT INTO #TEMP3 
																				(
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				)	
																				SELECT 
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				FROM GRANTLEG WHERE ID=@GLID 
																				UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																									EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																									LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																			END
																		ELSE
																			BEGIN 
																				INSERT INTO #TEMP3 
																				(
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				)																				
																				SELECT 
																					ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																					GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																					SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																					SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																					SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																					BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																					SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																					IsSplit,TempExercisableQuantity
																				FROM GRANTLEG WHERE ID=@GLID 
																				UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																								EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																								LapsedQuantity = LapsedQuantity + ExercisableQuantity,
																								ExpiryPerformed='Y',ExercisableQuantity = 0,
																								LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																			END
																	PRINT 'CHECKING FOR expiry and vesting date : End'
																END
														PRINT 'MODIFY THE VESTING DATE AND EXPIRY DATE : END'
													 END
												 --ELSE LOOP 100 END---
											END
										PRINT ''
									END
									--IF LOOP END FOR (VESTING = 'Y') --
								   ELSE
									BEGIN
										IF((@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0) AND (@ISGRANTED = 'Y'))
											BEGIN 
												SET @VALIDATIONMSG = 'Validation Message : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
												UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN	
											END
										ELSE
											BEGIN
												-- CODE START FOR lOOP 800 --
												IF(@ISGRANTED = 'Y')
													BEGIN
														PRINT 'CHECKING FOR GRANTED OPTIONS'
														SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID 
														SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID
														PRINT('SUM')
														PRINT(@SUM)
														PRINT('TEMPSUM')
														PRINT(@TEMPSUM)
														PRINT('ISPERFORMANCE')
														PRINT(@ISPERFORMANCE)
														PRINT('VESTING TYPE')
														PRINT(@ED_VESTINGTYPE)
													-------------------------------------
														IF(@SUM = @TEMPSUM)
														BEGIN
															IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
																BEGIN
																	INSERT INTO #TEMP3 
																	(
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity
																	)
																	SELECT 
																		ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																		GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																		SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																		SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																		SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																		BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																		SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																		IsSplit,TempExercisableQuantity
																	FROM GRANTLEG WHERE ID=@GLID 
																	UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																					GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																					SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																					LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
																END
															ELSE
																BEGIN
																	SET @VALIDATIONMSG = 'Validation Message : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
																	UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN	
																END
														END
														ELSE
															BEGIN
																SET @VALIDATIONMSG = 'Validation Message : Total options granted does not match with the original total options granted.' 
																UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
															END
													------------------------------------
													END
												ELSE
													BEGIN
														IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
															BEGIN
																INSERT INTO #TEMP3																
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																FROM GRANTLEG WHERE ID=@GLID  
																UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																				  LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															END
														ELSE
															BEGIN
																INSERT INTO #TEMP3 
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																FROM GRANTLEG WHERE ID=@GLID  
																UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,
																			 LapsedQuantity = LapsedQuantity + ExercisableQuantity, ExpiryPerformed = 'Y',
																			 ExercisableQuantity =0,
																			 LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															END
													END
												-- CODE ENDED FOR lOOP 800 --
											END
									END
									--ELSE LOOP END FOR (VESTING = 'Y') --
								   PRINT ''
								END
						--------------------------------------------------------
						END
					ELSE
						BEGIN
						SET @VALIDATIONMSG =  'Validation Message : Expiry date cannot be before the vesting date. Please check.'   
						UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
					END
				END
			-----------------------------------------------------------------------------------------------------------------------------------
				ELSE
				BEGIN
					IF(@ISVESTING ='Y')
						BEGIN
							IF(@VESTINGDATE >= @ED_GRANTDATE AND @VESTINGDATE <= @EXPIRYDATE)
							BEGIN
								 IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)
									BEGIN
										SET @VALIDATIONMSG = 'Validation Message : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
										UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
									END
								 ELSE
									BEGIN
										----lOOP 500 sTART----
										IF(@ISGRANTED ='Y')
											BEGIN
												SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID 
												SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID
												PRINT('SUM')
												PRINT(@SUM)
												PRINT('TEMPSUM')
												PRINT(@TEMPSUM)
												PRINT('ISPERFORMANCE')
												PRINT(@ISPERFORMANCE)
												PRINT('VESTING TYPE')
												PRINT(@ED_VESTINGTYPE)
												 ------------------------------------------------------
												 IF(@SUM = @TEMPSUM)
													BEGIN
														IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
															BEGIN
																PRINT 'WHEN PERFORMANCE DIDN"T UPLOAD'
																INSERT INTO #TEMP3 
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)																
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																FROM GRANTLEG WHERE ID=@GLID 
																UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,																					
																				GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																				SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																				LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															END
														ELSE
															BEGIN
																INSERT INTO #TEMP3 
																(
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																)
																SELECT 
																	ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
																	GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
																	SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
																	SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
																	SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
																	BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
																	SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
																	IsSplit,TempExercisableQuantity
																FROM GRANTLEG WHERE ID=@GLID 
																UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,																					
																				GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																				SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																				ExercisableQuantity = @GRANTEDOPTIONS,
																				LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
															END
													 END
												 ELSE
													 BEGIN
														SET @VALIDATIONMSG = 'Validation Message : Total options granted does not match with the original total options granted.' 
														UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
													 END
											END
										----lOOP 500 END----
										ELSE
											BEGIN
												IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
													BEGIN
														INSERT INTO #TEMP3 
														(
															ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
															GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
															SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
															SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
															SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
															BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
															SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
															IsSplit,TempExercisableQuantity
														)
														SELECT 
															ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
															GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
															SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
															SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
															SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
															BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
															SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
															IsSplit,TempExercisableQuantity
														FROM GRANTLEG WHERE ID=@GLID 
																UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
													END
												ELSE
													BEGIN
														INSERT INTO #TEMP3 
														(
															ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
															GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
															SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
															SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
															SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
															BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
															SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
															IsSplit,TempExercisableQuantity
														)
														SELECT 
															ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
															GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
															SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
															SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
															SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
															BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
															SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
															IsSplit,TempExercisableQuantity
														FROM GRANTLEG WHERE ID=@GLID 
														
														UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,
																LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
													END
											END
										----ELSE lOOP 500 END----
									END										
							END
							ELSE
								BEGIN
									SET @VALIDATIONMSG = 'Validation Message : Vesting date cannot be before grant date and after the expiry date. Please check.'  
									UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
								END
						END	
					ELSE
						BEGIN
							IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)
								BEGIN
									SET @VALIDATIONMSG = 'Validation Message : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
								END
							ELSE
								BEGIN
									IF(@ISGRANTED ='Y')
									BEGIN
										SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID 
										SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP2 WHERE GRANTOPTIONID = @GOPID
										PRINT('SUM')
										PRINT(@SUM)
										PRINT('TEMPSUM')
										PRINT(@TEMPSUM)
										PRINT('ISPERFORMANCE')
										PRINT(@ISPERFORMANCE)
										PRINT('VESTING TYPE')
										PRINT(@ED_VESTINGTYPE)
										 ------------------------------------------------------
										 IF(@SUM = @TEMPSUM)
										 BEGIN
											IF((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='P'))
												BEGIN
													PRINT 'WHEN PERFORMANCE DIDN"T UPLOAD'
													INSERT INTO #TEMP3 
													(
														ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
														GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
														SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
														SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
														SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
														BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
														SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
														IsSplit,TempExercisableQuantity
													)													
													SELECT 
														ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
														GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
														SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
														SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
														SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
														BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
														SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
														IsSplit,TempExercisableQuantity
													FROM GRANTLEG WHERE ID=@GLID 
													UPDATE #TEMP3 SET GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																	  SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																	  LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
												END
											ELSE
												BEGIN
													INSERT INTO #TEMP3 
													(
														ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
														GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
														SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
														SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
														SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
														BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
														SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
														IsSplit,TempExercisableQuantity
													)													
													SELECT 
														ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
														GrantDistributedLegId,GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
														SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
														SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
														SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
														BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,LapsedQuantity,IsPerfBased,
														SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
														IsSplit,TempExercisableQuantity
													FROM GRANTLEG WHERE ID=@GLID 
													
													UPDATE #TEMP3 SET GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,
																SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,
																EXERCISABLEQUANTITY = @GRANTEDOPTIONS,
																LASTUPDATEDBY='CR/ADMIN', LASTUPDATEDON=GETDATE() WHERE ID=@GLID
												END
										 END
										 ELSE
											BEGIN
												SET @VALIDATIONMSG = 'Validation Message : Total options granted does not match with the original total options granted.' 
												UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN
											END
									END
								END
						END	
				END
			END
	 	 --cONDITIONAL LOOP START
	 		
 		PRINT '------------ VALUE INCREMENT START; BEFORE INCREMENT =' + CONVERT(VARCHAR(5),@MIN)
													
		PRINT '------ EQUATION CHECKING PROCESS START... ------'
			IF(((@ISPERFORMANCE ='1') AND (@ED_VESTINGTYPE='P')) OR ((@ISPERFORMANCE ='N') AND (@ED_VESTINGTYPE='T')))
			BEGIN
				IF((SELECT CASE 
		 				WHEN (GRANTEDOPTIONS)=(CANCELLEDQUANTITY+UNAPPROVEDEXERCISEQUANTITY+EXERCISEDQUANTITY+EXERCISABLEQUANTITY+LAPSEDQUANTITY) 
						THEN '1' 
						ELSE '0' 
						END AS EQUANTION_MATCH 
						FROM #TEMP3 WHERE ID=@GLID)=('1'))
					BEGIN
							PRINT' EQUANTION MATCH...FOR ID='+ CONVERT(VARCHAR(5),@MIN)
					END
				ELSE
					BEGIN
							SET @VALIDATIONMSG = 'Validation Message : Total options granted does not match with the original total options granted. [Equation :(GRANTED=Unvested+Vested+Exercised+UnApproved+Lapsed+Cancelled)] not statify against ID='+CONVERT(VARCHAR(5),@MIN)+''
							UPDATE #TEMP2 SET EQ_REMARK = @VALIDATIONMSG WHERE SRNO=@MIN  
					END
			END
			ELSE
				BEGIN
						PRINT 'NO NEED TO CHECK THE EQUATION BECAUSE VESTING TYPE : P AND ISPERFORMANCE : N'
				END
		PRINT '------ EQUATION CHECKING PROCESS END. ------'
	 		
	 	SET @MIN = @MIN + 1	 		
		END
		PRINT 'PROCEDURE EXECUTION STOP'
		
		------------------------------Logic for check the vesting date update for performance as well as  time base grant----------------------------------
		
		/*

select * from #TEMP3
*/



	CREATE TABLE #TEMP4   
	(
		RANK_NO INT,
		ID INT,
		REMARK varchar(200)
	)
	INSERT INTO #TEMP4(RANK_NO,ID)
	SELECT 
	ROW_NUMBER() OVER (ORDER BY ID) RANK_NO,
	ID
	FROM #TEMP3

	DECLARE --@MAX INT,
			--@MIN INT,
			@GID INT,			
			@GL_GrantOPID varchar(100) = null,
			@GL_GrantLegID int,
			@GL_vestingType char = null,
			--@GL_ExpiryDate datetime ,
			@GL_FinalVestingDate datetime ,
			@GL_FinalExpiryDate datetime ,
			--@GL_vestingdate datetime ,
			@GL_Id int,
			@Temp_vestingdate datetime ,
			@Temp_ExpiryDate datetime ,
			@Temp_FinalVestingDate datetime ,
			@Temp_FinalExpiryDate datetime ,
			@Temp_vestingType char = null,
			@Temp_Id int,
			@Result varchar(250) = null,
			@case varchar(5) = 'TEMP'		
		
		SET @GL_EXPIRYDATE = NULL
		SET @GL_VESTINGDATE = NULL
		
	SELECT @MIN = MIN(RANK_NO),@MAX = MAX(RANK_NO) FROM #TEMP4

	WHILE(@MIN <= @MAX)
		BEGIN
			SELECT @GID=ID FROM #TEMP4 WHERE RANK_NO = @MIN
			PRINT 'ID : '+CONVERT(VARCHAR(3),@GID)
			--SET @case = 'TEMP'
					
			PRINT '/*---------------------------SEARCH FOR VALUE:- '+CONVERT(VARCHAR(3),@MIN) +'---------------------------*/'
			----------------------------Logic Start--------------------------------
				IF(UPPER(@case) = 'TEMP')
					BEGIN
						PRINT 'SERACH INTO TEMP TABLE[i.e. Same Table]'
							SELECT 
							   @GL_GrantOPID		= B.GRANTOPTIONID, 
							   @GL_GrantLegID		= B.GRANTLEGID,
							   @GL_vestingdate		= B.VESTINGDATE,
							   @GL_ExpiryDate		= B.EXPIRAYDATE,
							   @GL_FinalVestingDate	= B.FINALVESTINGDATE,
							   @GL_FinalExpiryDate	= B.FINALEXPIRAYDATE,
							   @GL_vestingType		= B.VESTINGTYPE, 
							   @GL_Id				= B.ID,
							   
							   @Temp_vestingdate		= A.VESTINGDATE,
							   @Temp_EXPIRYDATE			= A.EXPIRAYDATE,
							   @Temp_FINALVESTINGDATE	= A.FINALVESTINGDATE,
							   @Temp_FINALEXPIRYDATE	= A.FINALEXPIRAYDATE,
							   @Temp_VESTINGTYPE		= A.VESTINGTYPE, 
							   @Temp_ID					= A.ID
						
						FROM #TEMP3 A CROSS JOIN #TEMP3 B
						WHERE A.ID <> B.ID
							AND A.GRANTOPTIONID = B.GRANTOPTIONID
							AND A.GRANTLEGID = B.GRANTLEGID
							AND A.VESTINGTYPE <> B.VESTINGTYPE
							AND A.ID = @GID
						
						PRINT 'PRINT THE VALUES'	
							/*SELECT 
								@GL_GrantOPID		 GrantOptionId,
								@GL_GrantLegID		 GrantLegId,
								@GL_Id				 GL_ID,
								@GL_vestingType		 GL_VestingType,
								@GL_vestingdate		 GL_VestingDate,
								@GL_FinalVestingDate GL_FinalVestingDate,
								@GL_ExpiryDate		 GL_ExpiryDate,	   
								@GL_FinalExpiryDate	 GL_FinalExpiryDate,
							
								@GL_GrantOPID			GrantOptionId,
								@GL_GrantLegID			GrantLegId,
								@Temp_ID				TempID,
								@Temp_vestingType		TempVestingType,
								@Temp_vestingdate		TempVestingDate,
								@Temp_FinalVestingDate	TempFinalVestingDate,	   
								@Temp_ExpiryDate		TempExpiryDate,	   
								@Temp_FinalExpiryDate	TempFinalExpiryDate*/
					/*------------------------------------------------------------------------*/				
						IF((@GL_vestingdate is NULL) AND  (@Temp_vestingdate is NULL) 
							AND (@GL_ExpiryDate is NULL) AND (@Temp_EXPIRYDATE is NULL)
							AND (@GL_FinalVestingDate is NULL) AND (@Temp_FINALVESTINGDATE is NULL)
							AND (@GL_FinalExpiryDate is NULL) AND (@Temp_FINALEXPIRYDATE is NULL))
							BEGIN   
								PRINT 'All Value are Null'
								SET @case = 'GRANT'
								GOTO EndOftheSP
							END
				   /*------------------------------------------------------------------------*/				
						ELSE
							BEGIN
							/*-------------------------------*/	
								IF((@GL_vestingdate = @Temp_vestingdate) AND (@GL_ExpiryDate = @Temp_ExpiryDate)
									AND (@GL_FinalVestingDate = @Temp_FinalVestingDate) AND (@GL_FinalExpiryDate = @Temp_FinalExpiryDate))
									BEGIN   
										UPDATE #TEMP4 SET REMARK ='Match Found with All Columns.' where ID = @GID 
										SET @GL_vestingdate   = NULL
										SET @Temp_vestingdate = NULL
										SET @GL_ExpiryDate    = NULL
										SET @Temp_EXPIRYDATE  = NULL
										SET @GL_FinalVestingDate = NULL
										SET @Temp_FINALVESTINGDATE = NULL
										SET @GL_FinalExpiryDate = NULL
										SET @Temp_FINALEXPIRYDATE = NULL
										SET @GL_GRANTOPID = Null
										SET @GL_GRANTLEGID = NULL
									END
								ELSE
									BEGIN   
										UPDATE #TEMP4 SET REMARK = 'Validation Message : Data needs to be changed the corresponding Time Or Performance entry for same grant leg.' +' GrantOptionId :' + @GL_GrantOPID +' Leg Id : ' + CONVERT(VARCHAR(2),@GL_GrantLegID) + ' Vesting type :' + @Temp_vestingType +'.' where ID = @GID 
										UPDATE #TEMP2 SET REMARK = 'Validation Message : Data needs to be changed the corresponding Time Or Performance entry for same grant leg.' +' GrantOptionId :' + @GL_GrantOPID +' Leg Id : ' + CONVERT(VARCHAR(2),@GL_GrantLegID) + ' Vesting type :' + @Temp_vestingType +'.' WHERE GRANTID = @GID
										SET @GL_vestingdate   = NULL
										SET @Temp_vestingdate = NULL
										SET @GL_ExpiryDate    = NULL
										SET @Temp_EXPIRYDATE  = NULL
										SET @GL_FinalVestingDate = NULL
										SET @Temp_FINALVESTINGDATE = NULL
										SET @GL_FinalExpiryDate = NULL
										SET @Temp_FINALEXPIRYDATE = NULL
										SET @GL_GRANTOPID = Null
										SET @GL_GRANTLEGID = NULL
									END
							/*-------------------------------*/	
							END
					 /*------------------------------------------------------------------------*/	
					END
					
		EndOftheSP: 
				IF(UPPER(@case) = 'GRANT')
				BEGIN    
					PRINT 'Record Serach Into GrantLeg Table[i.e. Grant Leg Table]'
					SELECT 
					   @GL_GrantOPID=B.GRANTOPTIONID, 
					   @GL_GrantLegID= B.GRANTLEGID,
					   @GL_vestingdate = B.VESTINGDATE,
					   @GL_ExpiryDate = B.EXPIRAYDATE,
					   @GL_FinalVestingDate=B.FINALVESTINGDATE,
					   @GL_FinalExpiryDate = B.FINALEXPIRAYDATE,
					   @GL_vestingType = B.VESTINGTYPE, 
					   @GL_Id = B.ID,
					   @Temp_vestingdate = A.VESTINGDATE,
					   @Temp_ExpiryDate = A.EXPIRAYDATE,
					   @Temp_FinalVestingDate=A.FINALVESTINGDATE,
					   @Temp_FinalExpiryDate = A.FINALEXPIRAYDATE,
					   @Temp_vestingType = A.VESTINGTYPE, 
					   @Temp_Id = A.ID
					FROM #TEMP3  A CROSS JOIN GRANTLEG  B
					WHERE A.ID <> B.ID
					AND A.GRANTOPTIONID = B.GRANTOPTIONID
					AND A.GRANTLEGID = B.GRANTLEGID
					AND A.VESTINGTYPE <> B.VESTINGTYPE
					AND A.ID = @GID
				
					PRINT 'PRINT THE VALUE'			
					/*SELECT 
							@GL_GrantOPID		GrantOptionId,
							@GL_GrantLegID		GrantLegId,
							@GL_Id				GL_ID,
							@GL_vestingType		GL_VestingType,
							@GL_vestingdate		GL_VestingDate,
							@GL_FinalVestingDate GL_FinalVestingDate,
							@GL_ExpiryDate		GL_ExpiryDate,	   
							@GL_FinalExpiryDate	GL_FinalExpiryDate,
						
							@GL_GrantOPID			GrantOptionId,
							@GL_GrantLegID			GrantLegId,
							@Temp_ID				TempID,
							@Temp_vestingType		TempVestingType,
							@Temp_vestingdate		TempVestingDate,
							@Temp_FinalVestingDate	TempFinalVestingDate,	   
							@Temp_ExpiryDate		TempExpiryDate,	   
							@Temp_FinalExpiryDate	TempFinalExpiryDate*/
					
					IF((@GL_vestingdate is NULL) AND (@Temp_vestingdate is NULL) 
						AND (@GL_ExpiryDate is NULL) AND (@Temp_EXPIRYDATE is NULL)
						AND (@GL_FinalVestingDate is NULL) AND (@Temp_FINALVESTINGDATE is NULL)
						AND (@GL_FinalExpiryDate is NULL) AND (@Temp_FINALEXPIRYDATE is NULL))
						BEGIN
							PRINT 'Record are Valid : Id =' + CONVERT(VARCHAR(4),@GID)+'.'
						END
					ELSE
						BEGIN
							PRINT 'RECORD PRESENT IN GRANTLEG'
							UPDATE #TEMP4 SET REMARK = 'Validation Message : Data needs to be changed the corresponding Time Or Performance entry for same grant leg. Id = '+ CONVERT(VARCHAR(20),@GL_GrantOPID)+'. Performance Type :'+@GL_vestingType+'.' WHERE ID=@GID
							UPDATE #TEMP2 SET REMARK = 'Validation Message : Data needs to be changed the corresponding Time Or Performance entry for same grant leg. Id = '+ CONVERT(VARCHAR(20),@GL_GrantOPID)+'. Performance Type :'+@GL_vestingType+'.' WHERE GRANTID = @GID
							SET @GL_vestingdate   = NULL
							SET @Temp_vestingdate = NULL
							SET @GL_ExpiryDate    = NULL
							SET @Temp_EXPIRYDATE  = NULL
							SET @GL_FinalVestingDate = NULL
							SET @Temp_FINALVESTINGDATE = NULL
							SET @GL_FinalExpiryDate = NULL
							SET @Temp_FINALEXPIRYDATE = NULL
						END
					
					PRINT '--Value set to case variable--'
						SET @case = 'TEMP'				
						print @case
					PRINT '------'
				END
					
				----------------------------Logic End--------------------------------	
				SET @MIN = @MIN + 1		
				PRINT '/*--------------------------- VALUE AFTER UPDATE:- '+CONVERT(VARCHAR(3),@MIN) + '---------------------------*/'
			END

		--SELECT * FROM #TEMP4	

		IF EXISTS
		(
			SELECT *        
			FROM tempdb.dbo.sysobjects        
			WHERE ID = OBJECT_ID(N'tempdb..#TEMP4')        
		)        
		BEGIN        
			DROP TABLE #TEMP4   
		END 
			
		------------------------------Logic Ended---------------------------------------------------------------------------
		-----------------------Procedure data insertion start---------------------------------------------------------------------------------------------
	    PRINT 'DATA INSERTION START.....'
		  
	    SELECT TOP 1 @RCOUNT = ISNULL((CASE WHEN(REMARK!='') THEN  COUNT(REMARK) END),0) FROM #TEMP2 GROUP BY REMARK ORDER BY ISNULL((CASE WHEN(REMARK ! = '') THEN COUNT(REMARK) END), 0) DESC  

		 ---------------------------------------------------------------------------
			IF(@RCOUNT > 0)  
			 BEGIN  
				PRINT '------- ERROR IN EXCEL SHEET START -------'	
				
				/*Changes done for testing purpose only*/
				UPDATE #TEMP2 SET SRNO = SRNO + 1 WHERE #TEMP2.REMARK != ''
				/*Changes Ends*/
				
				SELECT RANK() OVER( ORDER BY Row_no) AS Row_no, ID,	SRNO,	GRANTLEGID,	GRANTOPTIONID,	VESTINGDATE,	EXPIRYDATE,	OPTIONSGRANTED,	PARENT,	
					Status,	GRANTDATE,	GRANTID,	VESTINGTYPE,	FinalExpirayDate,	FINALVESTINGDATE,	GRANTEDOPTIONS,	BONUSSPLITQUANTITY,	EXERCISEDQUANTITY,
					UNAPPROVEDEXERCISEQUANTITY,	EXERCISABLEQUANTITY,	LAPSEDQUANTITY,	CANCELLEDQUANTITY,	BONUSSPLITCANCELLEDQUANTITY,
					ISVESTINGUPDATE,	ISEXPIRYUPDATE,	ISGRANTEDOPTIONS,	REMARK , EQ_REMARK
				FROM #TEMP2 WHERE #TEMP2.REMARK != ''
			    
				--DELETE FROM SHGRANTLEG
				SELECT COUNT(*) as TotalRows,'INVALID' as Chk_Status  FROM #TEMP2  WHERE #TEMP2.REMARK != ''   
			
				PRINT '------- ERROR IN EXCEL SHEET END  --------'	
			END 
			--------------------------------------------------------------------------- 
			ELSE  
			 BEGIN  
				PRINT '------- DATA INSERT IN SHADOW TABLE-------'		
				--SELECT * FROM #TEMP3		
				
				
				 SELECT @PENDING_COUNT = COUNT(*) FROM SHGRANTLEG WHERE ID IN (SELECT ID FROM #TEMP3)
				 IF(@PENDING_COUNT > 0)
				 BEGIN
					UPDATE #TEMP2 SET REMARK='Execution Error : Data Pending for approval.' where ID in (SELECT ID FROM SHGRANTLEG WHERE ID IN (SELECT ID FROM #TEMP3)) 					
				 
					SELECT RANK() OVER( ORDER BY Row_no) AS Row_no, ID,	SRNO,	GRANTLEGID,	GRANTOPTIONID,	VESTINGDATE,	EXPIRYDATE,	OPTIONSGRANTED,	PARENT,	
					Status,	GRANTDATE,	GRANTID,	VESTINGTYPE,	FinalExpirayDate,	FINALVESTINGDATE,	GRANTEDOPTIONS,	BONUSSPLITQUANTITY,	EXERCISEDQUANTITY,
					UNAPPROVEDEXERCISEQUANTITY,	EXERCISABLEQUANTITY,	LAPSEDQUANTITY,	CANCELLEDQUANTITY,	BONUSSPLITCANCELLEDQUANTITY,
					ISVESTINGUPDATE,	ISEXPIRYUPDATE,	ISGRANTEDOPTIONS,	REMARK
					FROM #TEMP2 WHERE #TEMP2.REMARK != ''
			    
				--DELETE FROM SHGRANTLEG
					SELECT COUNT(*) as TotalRows,'INVALID' as Chk_Status  FROM #TEMP2  WHERE #TEMP2.REMARK != ''   
				 
				 END
				 ELSE
					BEGIN
						SELECT 'DATA UPLOADED SUCCESSFULLY' AS REMARK
						INSERT INTO ShGrantLeg 
						(
							ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
							GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
							SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
							SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
							SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
							BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,Status,ParentID,LapsedQuantity,IsPerfBased,
							SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
							IsSplit,TempExercisableQuantity
						)
						(
							SELECT 
							ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,
							GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,
							SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,
							SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,
							SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
							BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,Status,ParentID,LapsedQuantity,IsPerfBased,
							SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,IsBonus,
							IsSplit,TempExercisableQuantity
							FROM #TEMP3
						)		
						SELECT COUNT(*) as TotalRows, 'VALID'  as Chk_Status FROM ShGrantLeg  
				    END
				PRINT '------- DATA INSERT IN SHADOW TABLE END-------'
			END  
		 --------------------------------------------------------------------------- 
		  PRINT 'DATA INSERTION END.....'
		
		
		
		 ------------------------------------------------
		  PRINT '---TABLE DELETE START-------'
		  IF EXISTS        
			(        
				SELECT *        
				FROM tempdb.dbo.sysobjects        
				WHERE ID = OBJECT_ID(N'tempdb..#TEMP2')        
			)        
		 BEGIN        
			DROP TABLE #TEMP2
			DROP TABLE #TEMP3				
		 END 
		  PRINT '---TABLE DELETE END-------'
	 	------------------------------------------Procedure end----------------------------------------------------------------------------------------------------
END
GO
