/****** Object:  StoredProcedure [dbo].[USP_APPROVEEDITGRANTMASSUPLOAD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[USP_APPROVEEDITGRANTMASSUPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[USP_APPROVEEDITGRANTMASSUPLOAD]    Script Date: 7/6/2022 1:40:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[USP_APPROVEEDITGRANTMASSUPLOAD]    Script Date: 12/27/2012 09:27:06 ******/

CREATE PROCEDURE [dbo].[USP_APPROVEEDITGRANTMASSUPLOAD]
(
	@USERID VARCHAR(20),
	@STATUS CHAR
)
AS
BEGIN
DECLARE @MAX INT,
		@MIN INT,
		@SUM INT,
		@TEMPSUM INT,
		@GOPID VARCHAR(100),
		@EMPLOYEEID VARCHAR(50),		
		@SGL_ISPERFORMANCE VARCHAR(1),
		@GLID INT,
		@GL_EXEDQTY NUMERIC(10,0),
		@GL_VESTEDQTY NUMERIC(10,0),
		@GL_UNAPPROVEQTY NUMERIC(10,0),
		@GL_CANCELLEDQTY NUMERIC(10,0),
		@GL_LAPSEDQTY NUMERIC(10,0),
		@GL_GRANTEDQTY NUMERIC(10,0),
		@SGL_GRANTEDQTY NUMERIC(10,0),
		@SGL_FINALEXPIRYDATE DATETIME,
		@SGL_FINALVESTINGDATE DATETIME,
		@GL_FINALEXPIRYDATE DATETIME,
		@GL_FINALVESTINGDATE DATETIME,
		@SGL_ISVESTING CHAR,
		@SGL_ISEXPIRY  CHAR,
		@SGL_ISGRANTED CHAR,
		@SGL_VESTINGTYPE CHAR,
		@SGL_ID INT,
		@LTRANSID INT,
		@VALIDATIONMSG VARCHAR(5000),
		@ISERRORFOUND AS INT,
		@SEQ_NO INT
		
set @IsErrorFound = 0

	CREATE TABLE #TEMP1 
(
	RNO INT IDENTITY(1,1),
	SGL_ID INT,
	SGL_GRANTOPTIONID VARCHAR(100),
	SGL_GRANTLEGID INT,
	SGL_VESTINGDATE DATETIME,
	SGL_EXPIRYDATE DATETIME,
	SGL_FINALVESTINGDATE DATETIME,
	SGL_FINALEXPIRYDATE DATETIME,
	SGL_GRANTEDOPTIONS NUMERIC(10,0),
	SGL_CANCELLEDQTY NUMERIC(10,0),
	SGL_UNAPPROVEQTY NUMERIC(10,0),
	SGL_EXERCISEDQTY NUMERIC(10,0),
	SGL_VESTEDQTY NUMERIC(10,0),
	SGL_LAPSEDQTY NUMERIC(10,0),
	SGL_SEPARATIONFLAG CHAR,
	SGL_EXPIRYFLAG CHAR,	
	SGL_VESTINGTYPE CHAR,
	SGL_ISPERFORMANCE VARCHAR(1),
	
	GL_VESTINGDATE DATETIME,
	GL_EXPIRYDATE DATETIME,
	GL_FINALVESTINGDATE DATETIME,
	GL_FINALEXPIRYDATE DATETIME,
	GL_GRANTEDOPTIONS NUMERIC(10,0),
	GL_CANCELLEDQTY NUMERIC(10,0),
	GL_UNAPPROVEQTY NUMERIC(10,0),
	GL_EXERCISEDQTY NUMERIC(10,0),
	GL_VESTEDQTY NUMERIC(10,0),
	GL_LAPSEDQTY NUMERIC(10,0),
	GL_SEPARATIONFLAG CHAR,
	GL_EXPIRYFLAG CHAR,
	ISVESTINGFLAG CHAR,
	ISEXPIRYFLAG CHAR,
	ISGRANTEDFLAG CHAR,
	REMARK VARCHAR(MAX)
)
	INSERT INTO  #TEMP1 
			SELECT	SGL.ID,
					SGL.GRANTOPTIONID,					
					SGL.GRANTLEGID,
					SGL.VESTINGDATE,
					SGL.EXPIRAYDATE,
					SGL.FINALVESTINGDATE,
					SGL.FINALEXPIRAYDATE,
					SGL.GRANTEDOPTIONS,
					SGL.CANCELLEDQUANTITY,
					SGL.UNAPPROVEDEXERCISEQUANTITY,
					SGL.EXERCISEDQUANTITY,
					SGL.EXERCISABLEQUANTITY,
					SGL.LAPSEDQUANTITY,
					SGL.SEPARATIONPERFORMED,
					SGL.EXPIRYPERFORMED, 
					SGL.VESTINGTYPE,
					SGL.ISPERFBASED,
					
					GL.VESTINGDATE AS GL_VESTINGDATE,
					GL.EXPIRAYDATE AS GL_EXPIRAYDATE,
					GL.FINALVESTINGDATE AS GL_FINALVESTINGDATE,
					GL.FINALEXPIRAYDATE AS GL_FINALEXPIRAYDATE,
					GL.GRANTEDOPTIONS AS GL_GRANTEDOPTIONS,
					GL.CANCELLEDQUANTITY AS GL_CANCELLEDQUANTITY,
					GL.UNAPPROVEDEXERCISEQUANTITY AS GL_UNAPPROVEDEXERCISEQUANTITY,
					GL.EXERCISEDQUANTITY AS GL_EXERCISEDQUANTITY,
					GL.EXERCISABLEQUANTITY  AS GL_EXERCISABLEQUANTITY,
					GL.LAPSEDQUANTITY AS GL_LAPSEDQUANTITY,
					GL.SEPARATIONPERFORMED AS GL_SEPARATIONPERFORMED,
					GL.EXPIRYPERFORMED AS GL_EXPIRYPERFORMED,
		  CASE WHEN SGL.FINALVESTINGDATE = GL.FINALVESTINGDATE THEN 'N' ELSE 'Y' END AS ISVESTINGDATEMODIFY,
		  CASE WHEN SGL.FINALEXPIRAYDATE = GL.FINALEXPIRAYDATE THEN 'N' ELSE 'Y' END AS ISEXPIRYDATEMODIFY,
		  CASE WHEN SGL.GRANTEDOPTIONS   = GL.GRANTEDOPTIONS   THEN 'N' ELSE 'Y' END AS ISGRANTEDMODIFY,
					NULL AS REMARK
		  FROM SHGRANTLEG SGL 
		  INNER JOIN GRANTLEG GL  
		  ON GL.ID = SGL.ID 

	SELECT	@MIN=MIN(#TEMP1.RNO),
			@MAX=MAX(#TEMP1.RNO) 
	FROM	#TEMP1

	PRINT @MIN 
	PRINT @MAX
	
 -- BEGIN TRY
	WHILE (@MIN <= @MAX)
		BEGIN
			PRINT '----value fetch start ----'
			PRINT @MIN
			SELECT	@GOPID = #TEMP1.SGL_GRANTOPTIONID,
					@GLID = #TEMP1.SGL_GRANTLEGID,
					@GL_CANCELLEDQTY = #TEMP1.GL_CANCELLEDQTY,
					@GL_EXEDQTY = #TEMP1.GL_EXERCISEDQTY,
					@GL_LAPSEDQTY = #TEMP1.GL_LAPSEDQTY,
					@GL_UNAPPROVEQTY = #TEMP1.GL_UNAPPROVEQTY,
					@GL_VESTEDQTY = #TEMP1.GL_VESTEDQTY, 
					@SGL_FINALEXPIRYDATE = #TEMP1.SGL_FINALEXPIRYDATE,
					@SGL_ISVESTING = #TEMP1.ISVESTINGFLAG,
					@SGL_ISEXPIRY = #TEMP1.ISEXPIRYFLAG,
					@SGL_ISGRANTED = #TEMP1.ISGRANTEDFLAG,
					@SGL_FINALVESTINGDATE = #TEMP1.SGL_FINALVESTINGDATE,
					@GL_FINALEXPIRYDATE = #TEMP1.GL_FINALEXPIRYDATE,
					@GL_FINALVESTINGDATE = #TEMP1.GL_FINALVESTINGDATE,
					@GL_GRANTEDQTY = #TEMP1.GL_GRANTEDOPTIONS,
					@SGL_VESTINGTYPE = #TEMP1.SGL_VESTINGTYPE,
					@SGL_ISPERFORMANCE = #TEMP1.SGL_ISPERFORMANCE,
					@SGL_GRANTEDQTY = #TEMP1.SGL_GRANTEDOPTIONS,
					@SGL_ID	 = #TEMP1.SGL_ID
			FROM	#TEMP1 
			WHERE	#TEMP1.RNO = @MIN
			
			--print  'Value of Expiry flag'+@SGL_ISEXPIRY
			PRINT '---- Value fetch finish ----'
			
			-----------------------------------------------------------------------
			---IS EXPIRY DATE UPDATE = Y START.
			IF(@SGL_ISEXPIRY='Y')
				BEGIN 
				-----------------------------------------------------------------------
				  ---IS EXPIRY DATE UPDATE = Y, VESTING DATE UPDATE = Y START.
					IF(@SGL_ISVESTING = 'Y')
						BEGIN 
						 -- EXPIRY = Y; VESTING = Y AND GRANTED = Y
							IF(@SGL_ISGRANTED = 'Y')
								BEGIN 
									--CODE STARTS : VALIDATION FOR UPDATE ALL FIELDs
									IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_LAPSEDQTY = 0 AND @GL_UNAPPROVEQTY = 0)
									 BEGIN
									
									--FINAL EXPIRY DATE IS GREATER THEN GET DATE : -- CODE START
										IF(GETDATE() <= @SGL_FINALEXPIRYDATE)
											BEGIN   												
													BEGIN TRY
														PRINT 'CHECK THE GRANTED OPTIONS, VESTING DATE, EXPIRY DATE VALIDATION AND UPDATE ONLY'
												------------------------------------------------------------------
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												-------------------------------------------------------------------
												IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
												------------------------------------------------------------------		
														UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																			SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																			VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
												------------------------------------------------------------------------	
													END
												ELSE
													BEGIN
														UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																			SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,EXERCISABLEQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																			VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													END	
												------------------------------------------------------------------------	
													END TRY
													BEGIN CATCH
														SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE GRANTED OPTIONS, VESTING DATE AND EXPIRY DATE.'
														GOTO ENDOFTHESP	
														--RAISERROR(@VALIDATIONMSG,11,9)
													END CATCH
													IF @@ERROR <>0
													BEGIN
														set @IsErrorFound = 1
														goto EndOftheSP
													END
													
											END
									--FINAL EXPIRY DATE IS GREATER THEN GET DATE :-- CODE END
									
										ELSE IF(GETDATE() > @SGL_FINALEXPIRYDATE)
											BEGIN	
													PRINT 'UPDATE THE GRANTED OPTIONS AND EXPIRY DATE AND VESTING DATE + MOVE OPTIONS INTO LAPSED BUCKET.'
													PRINT 'N.A.'												
											END											
									 END
									--CODE ENDS   : VALIDATION FOR UPDATE ALL FIELDs
									
									--CODE STARTS : ELSE WHEN VALIDATION CONDITION FAIL.
									ELSE
									 BEGIN 
										SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UPDATE FAIL.'
										GOTO ENDOFTHESP	
										--RAISERROR(@VALIDATIONMSG,11,1)
									 END
									--CODE ENDS : ELSE WHEN VALIDATION CONDITION FAIL. 
								END 
						 -- EXPIRY = Y; VESTING = Y AND GRANTED = Y
							ELSE
								BEGIN
									IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_LAPSEDQTY = 0 AND @GL_UNAPPROVEQTY = 0)
										BEGIN
										------------------------------------------------------
										---fINALVESTING DATE IS NOT GREATOR THAN EXPIRY DATE,
										IF(@SGL_FINALVESTINGDATE > @SGL_FINALEXPIRYDATE)
										BEGIN
											SET @VALIDATIONMSG ='VALIDATION MESSAGE : VESTING DATE CAN NOT BE GREATER THEN EXPIRY DATE.'
											GOTO ENDOFTHESP	
											--RAISERROR(@VALIDATIONMSG,11,2)
										END										
										------------------------------------------------------
										--FINALEXPIRYDATE IS >= GETDATE()
										ELSE IF(@SGL_FINALEXPIRYDATE >= GETDATE())
										BEGIN											
												BEGIN TRY
													PRINT 'UPDATE THE VESTING DATE AND EXPIRY DATE ONLY'
												------------------------------------------------------------------
													INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
													VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												------------------------------------------------------------------
												IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
												BEGIN	
													UPDATE GRANTLEG SET VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
																		EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID
												END
												ELSE
												BEGIN
													UPDATE GRANTLEG SET VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
																		EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID
												END												
												------------------------------------------------------------------
												END TRY
												BEGIN CATCH
													SET @VALIDATIONMSG ='VALIDATION MESSAGE : ERROR TO UPDATE WHILE UPDATE VESTING AND EXPIRY DATE.'
													GOTO ENDOFTHESP	
													--RAISERROR(@VALIDATIONMSG,11,2)
												END CATCH												
												IF(@@ERROR <> 0)
												BEGIN
													set @IsErrorFound = 1
													goto EndOftheSP
												END											
											
										END
										------------------------------------------------------
										--FINALEXPIRY DATE IS < GETDATE()
										ELSE IF(@SGL_FINALEXPIRYDATE < GETDATE())
											BEGIN
												BEGIN TRY
													--PRINT 'UPDATE VESTING DATE AND MOVE VESTED OPTIONS INTO LAPSE BUCKET.'
													------------------------------------------------------------------
													INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
													VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
													------------------------------------------------------------------
													IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
														BEGIN
															UPDATE GRANTLEG SET VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
																		EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		LapsedQuantity = #TEMP1.SGL_LAPSEDQTY, ExercisableQuantity = #TEMP1.SGL_VESTEDQTY,
																		ExpiryPerformed=#TEMP1.SGL_EXPIRYFLAG,
																		LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
															WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID												
															
															-----------------------------------------------------------------------------
																SELECT @LTRANSID=ISNULL(MAX(CONVERT(INT, LAPSETRANSID)),0) + 1 FROM LAPSETRANS
															-----------------------------------------------------------------------------													
																SELECT @EMPLOYEEID = EMPLOYEEID FROM GrantOptions WHERE GrantOptionId= @GOPID
															-----------------------------------------------------------------------------	
															--PRINT 'LAPSE TABLE UPDATE START'
																INSERT INTO LAPSETRANS (LAPSETRANSID,APPROVALSTATUS,GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,
																						LAPSEDQUANTITY,GRANTLEGSERIALNUMBER,LAPSEDATE,EMPLOYEEID,LASTUPDATEDBY,
																						LASTUPDATEDON)
																(SELECT @LTRANSID,'A',GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,LAPSEDQUANTITY,ID,@SGL_FINALEXPIRYDATE,
																					 @EMPLOYEEID,@USERID,GETDATE() FROM GRANTLEG WHERE ID=@SGL_ID)
															--PRINT 'LAPSE TABLE UPDATE END'
															-----------------------------------------------------------------------------		
																--PRINT 'SEQUENCE TABLE UPDATE START'
																	SELECT @SEQ_NO = SEQUENCENO FROM SEQUENCETABLE WHERE SEQ1 = 'LAPSETRANS'
																	IF(@SEQ_NO <> @LTRANSID)
																	BEGIN
																		UPDATE SEQUENCETABLE SET SEQUENCENO =(@LTRANSID) WHERE SEQ1='LAPSETRANS'
																	END
																--PRINT 'SEQUENCE TABLE UPDATE END'
																--PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'
															-----------------------------------------------------------------------------
														END
													ELSE
														BEGIN
															UPDATE GRANTLEG SET VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
																		EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		LapsedQuantity = #TEMP1.SGL_LAPSEDQTY, ExercisableQuantity = #TEMP1.SGL_VESTEDQTY,
																		ExpiryPerformed= #TEMP1.SGL_EXPIRYFLAG,
																		LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
															WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID																
															
															-----------------------------------------------------------------------------
																SELECT @LTRANSID=ISNULL(MAX(CONVERT(INT, LAPSETRANSID)),0) + 1 FROM LAPSETRANS
															-----------------------------------------------------------------------------													
																SELECT @EMPLOYEEID = EMPLOYEEID FROM GrantOptions WHERE GrantOptionId= @GOPID
															-----------------------------------------------------------------------------	
															--PRINT 'LAPSE TABLE UPDATE START'
																INSERT INTO LAPSETRANS (LAPSETRANSID,APPROVALSTATUS,GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,
																						LAPSEDQUANTITY,GRANTLEGSERIALNUMBER,LAPSEDATE,EMPLOYEEID,LASTUPDATEDBY,
																						LASTUPDATEDON)
																(SELECT @LTRANSID,'A',GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,LAPSEDQUANTITY,ID,@SGL_FINALEXPIRYDATE,
																					 @EMPLOYEEID,@USERID,GETDATE() FROM GRANTLEG WHERE ID=@SGL_ID)
															--PRINT 'LAPSE TABLE UPDATE END'
															-----------------------------------------------------------------------------		
																--PRINT 'SEQUENCE TABLE UPDATE START'
																	SELECT @SEQ_NO = SEQUENCENO FROM SEQUENCETABLE WHERE SEQ1 = 'LAPSETRANS'
																	IF(@SEQ_NO <> @LTRANSID)
																	BEGIN
																		UPDATE SEQUENCETABLE SET SEQUENCENO =(@LTRANSID) WHERE SEQ1='LAPSETRANS'
																	END
																--PRINT 'SEQUENCE TABLE UPDATE END'
																--PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'
															-----------------------------------------------------------------------------																												
														END														
												END TRY
												BEGIN CATCH
													SET @VALIDATIONMSG ='VALIDATION MESSAGE : ERROR TO UPDATE WHILE UPDATE VESTING AND EXPIRY DATE.'
													GOTO ENDOFTHESP	
												END CATCH
												IF(@@ERROR <> 0)
												BEGIN
													SET @ISERRORFOUND = 1
													GOTO ENDOFTHESP
												END		
												--PRINT 'NOT POSSIBLE.'
												--PRINT 'UPDATE VESTING DATE AND MOVE VESTED OPTIONS INTO LAPSE BUCKET.'
											END
										------------------------------------------------------
									END
									ELSE
										BEGIN
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE VESTING DATE AND OPTIONS MOVE INTO LAPSE BUCKET '
											GOTO ENDOFTHESP	
											--RAISERROR(@VALIDATIONMSG,11,3)
										END
								END
						END 
				  ---IS EXPIRY DATE UPDATE = Y, VESTING DATE UPDATE = Y END.
				  
				-------------------------------------------------------------------
					---IS EXPIRY DATE UPDATE = Y, VESTING DATE UPDATE = N START.
					ELSE
						BEGIN 
							IF(@SGL_ISGRANTED = 'Y')
								BEGIN 
						-----------------------------------------------------------
									IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_LAPSEDQTY = 0 AND @GL_UNAPPROVEQTY = 0)
										BEGIN 
									       IF(@SGL_FINALEXPIRYDATE >= GETDATE())
										BEGIN											
												BEGIN TRY
												
													--PRINT 'UPDATE THE GRANTED OPTIONS AND EXPIRY DATE'
												------------------------------------------------------------------
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												------------------------------------------------------------------		
												IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
												BEGIN
													UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																		BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																		EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,LASTUPDATEDBY=@USERID,
																		LASTUPDATEDON=GETDATE(),STATUS='A'
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID
												END
												ELSE
												BEGIN
													UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																		BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
																		EXERCISABLEQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																		FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,LASTUPDATEDBY=@USERID,
																		LASTUPDATEDON=GETDATE(),STATUS='A'
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID
												END
												------------------------------------------------------------------		
												END TRY
												BEGIN CATCH
													SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE GRANTED OPTIONS AND EXPIRY DATE'
													GOTO ENDOFTHESP	
													--RAISERROR(@VALIDATIONMSG,11,2)
												END CATCH
												IF @@ERROR <> 0
													BEGIN
														set @IsErrorFound = 1
														goto EndOftheSP
													END
											
										END
									       IF(@SGL_FINALEXPIRYDATE < GETDATE()) 
										BEGIN
											PRINT 'NOT POSSIBLE'
											PRINT 'UPDATE THE GRANTED OPTIONS AND MOVE OPTIONS INTO LAPSE BUCKET'
										END
								        END
						-----------------------------------------------------------
									ELSE
										BEGIN 
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : ERROR IN GRANTED OPTIONS ADJUSTMENT AND OPTIONS MOVE IN LAPSE BUCKET.'
									GOTO ENDOFTHESP	
									--RAISERROR(@VALIDATIONMSG,11,4)
								END
						-----------------------------------------------------------
								END
					--------------------------------------------------------------------		
							ELSE
								BEGIN 
									print 'Enter into expiry date change outer loop'
								------------------------------------------
									IF(@SGL_FINALEXPIRYDATE >= GETDATE())
									BEGIN 
										print 'Enter into Expiry date change as Future loop'
									------------------------------------------
										IF(@GL_LAPSEDQTY = 0 AND @GL_VESTEDQTY >=0)
											BEGIN												
													BEGIN TRY
													------------------------------------------------------------------
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)												------------------------------------------------------------------		
													--------------------------------------------------------------------
													IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID
													END
													ELSE
													BEGIN
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID													
													END
														--PRINT 'UPDATE THE EXPIRY DATE ONLY'
													--------------------------------------------------------------------
													END TRY
													BEGIN CATCH
														SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE.'
														GOTO ENDOFTHESP	
														--RAISERROR(@VALIDATIONMSG,11,1)
													END CATCH
													IF @@ERROR <> 0
													BEGIN															
														set @IsErrorFound = 1
														goto EndOftheSP													
													END												
											END
										ELSE IF(@GL_VESTEDQTY = 0 AND @GL_LAPSEDQTY > 0)
											BEGIN												
													BEGIN TRY
													------------------------------------------------------------------------													
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
													------------------------------------------------------------------	
													IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			ExercisableQuantity = ExercisableQuantity + LapsedQuantity,EXPIRYPERFORMED=NULL,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A',LapsedQuantity=0
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END
													ELSE
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			ExercisableQuantity = ExercisableQuantity + LapsedQuantity,EXPIRYPERFORMED=NULL,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A',LapsedQuantity=0
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END
														DELETE FROM LAPSETRANS WHERE GRANTLEGSERIALNUMBER IN (@SGL_ID)														
													---------------------------------------------
														--PRINT 'UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO VESTED BUCKET'
													END TRY
													BEGIN CATCH
														SET @VALIDATIONMSG ='VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO VESTED BUCKET.'
														GOTO ENDOFTHESP	
														--RAISERROR(@VALIDATIONMSG,11,3)
													END CATCH
													IF @@ERROR <> 0
													BEGIN													
														set @IsErrorFound = 1
														goto EndOftheSP													
													END												
											END
										ELSE IF(@GL_VESTEDQTY = 0 AND @GL_CANCELLEDQTY > 0)
										BEGIN
												BEGIN TRY
													------------------------------------------------------------------------													
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
													------------------------------------------------------------------	
													IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			EXPIRYPERFORMED=NULL,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END
													ELSE
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			EXPIRYPERFORMED=NULL,
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END																								
													---------------------------------------------
														--PRINT 'UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO VESTED BUCKET'
													END TRY
													BEGIN CATCH
														SET @VALIDATIONMSG ='VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE .'
														GOTO ENDOFTHESP	
														--RAISERROR(@VALIDATIONMSG,11,3)
													END CATCH
												IF @@ERROR <> 0
													BEGIN													
														SET @ISERRORFOUND = 1
														GOTO ENDOFTHESP													
													END
										END
										
										------------------------------------------------------------------
										 ELSE IF(@SGL_VESTINGTYPE ='P' AND @SGL_ISPERFORMANCE='N')
										 BEGIN
											IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND DID NOT MOVE OPTIONS INTO LAPSE BUCKET.'
												GOTO EndOftheSP
												--RAISERROR(@VALIDATIONMSG,11,2)
											END
											ELSE
											BEGIN
												UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
												WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
											END
										 END
									------------------------------------------------------------------
										 ELSE IF((@SGL_VESTINGTYPE ='P' OR @SGL_VESTINGTYPE='T') AND (@SGL_ISPERFORMANCE='1'))
										 BEGIN
											IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND DID NOT MOVE OPTIONS INTO LAPSE BUCKET.'
												GOTO EndOftheSP
												--RAISERROR(@VALIDATIONMSG,11,2)
											END
											ELSE
											BEGIN
												BEGIN TRY
												---------------------------------------------------------------------------------------------------------------	
													UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	EXPIRYPERFORMED='Y', LapsedQuantity = LapsedQuantity + ExercisableQuantity, 
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
												---------------------------------------------------------------------------------------------------------------
												-----------------------------------------------------------------------------
													SELECT @LTRANSID=ISNULL(MAX(CONVERT(INT, LAPSETRANSID)),0) + 1 FROM LAPSETRANS
												-----------------------------------------------------------------------------													
													SELECT @EMPLOYEEID = EMPLOYEEID FROM GrantOptions WHERE GrantOptionId= @GOPID
												-----------------------------------------------------------------------------	
												PRINT 'LAPSE TABLE UPDATE START'
													INSERT INTO LAPSETRANS (LAPSETRANSID,APPROVALSTATUS,GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,
																			LAPSEDQUANTITY,GRANTLEGSERIALNUMBER,LAPSEDATE,EMPLOYEEID,LASTUPDATEDBY,
																			LASTUPDATEDON)
													(SELECT @LTRANSID,'A',GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,LAPSEDQUANTITY,ID,@SGL_FINALEXPIRYDATE,
																		 @EMPLOYEEID,@USERID,GETDATE() FROM GRANTLEG WHERE ID=@SGL_ID)
												PRINT 'LAPSE TABLE UPDATE END'
												-----------------------------------------------------------------------------		
													PRINT 'SEQUENCE TABLE UPDATE START'
														SELECT @SEQ_NO = SEQUENCENO FROM SEQUENCETABLE WHERE SEQ1 = 'LAPSETRANS'
														IF(@SEQ_NO <> @LTRANSID)
														BEGIN
															UPDATE SEQUENCETABLE SET SEQUENCENO =(@LTRANSID) WHERE SEQ1='LAPSETRANS'
														END
													PRINT 'SEQUENCE TABLE UPDATE END'
													--PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'
												-----------------------------------------------------------------------------		
													INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												------------------------------------------------------------------
													
												END TRY
												BEGIN CATCH
												END CATCH
											END
										 END
									------------------------------------------------------------------
										
									------------------------------------------
									END
									IF(@SGL_FINALEXPIRYDATE < GETDATE())
									   BEGIN
										print 'Enter into expiry date change as past date loop'
									--------------------------------------------
										 IF(@GL_LAPSEDQTY = 0 AND @GL_VESTEDQTY >=0)
											BEGIN
											 IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
												BEGIN
													SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO LAPSE BUCKET.'
													GOTO ENDOFTHESP	
													--RAISERROR(@VALIDATIONMSG,11,2)
												END
											ELSE
												BEGIN	
											----------------------------------
													BEGIN TRY 
													PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'    
												-----------------------------------------------------------------------------
												PRINT 'GRANTLEG TABLE UPDATE START'
												IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
													UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
														   EXPIRYPERFORMED='Y', LapsedQuantity = LapsedQuantity + ExercisableQuantity, 
														   LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A',ExercisableQuantity = 0
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													END
												ELSE
													BEGIN
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
														   EXPIRYPERFORMED='Y', LapsedQuantity = LapsedQuantity + ExercisableQuantity, 
														   LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A',ExercisableQuantity = 0
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID														
													END
												PRINT 'GRANTLEG TABLE UPDATE END'
												-----------------------------------------------------------------------------													
													SELECT @LTRANSID=ISNULL(MAX(CONVERT(INT, LAPSETRANSID)),0) + 1 FROM LAPSETRANS
												-----------------------------------------------------------------------------													
													SELECT @EMPLOYEEID = EMPLOYEEID FROM GrantOptions WHERE GrantOptionId= @GOPID
												-----------------------------------------------------------------------------	
												PRINT 'LAPSE TABLE UPDATE START'
													INSERT INTO LAPSETRANS (LAPSETRANSID,APPROVALSTATUS,GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,
																			LAPSEDQUANTITY,GRANTLEGSERIALNUMBER,LAPSEDATE,EMPLOYEEID,LASTUPDATEDBY,
																			LASTUPDATEDON)
													(SELECT @LTRANSID,'A',GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,LAPSEDQUANTITY,ID,@SGL_FINALEXPIRYDATE,
																		 @EMPLOYEEID,@USERID,GETDATE() FROM GRANTLEG WHERE ID=@SGL_ID)
												PRINT 'LAPSE TABLE UPDATE END'
												-----------------------------------------------------------------------------		
													PRINT 'SEQUENCE TABLE UPDATE START'
														SELECT @SEQ_NO = SEQUENCENO FROM SEQUENCETABLE WHERE SEQ1 = 'LAPSETRANS'
														IF(@SEQ_NO <> @LTRANSID)
														BEGIN
															UPDATE SEQUENCETABLE SET SEQUENCENO =(@LTRANSID) WHERE SEQ1='LAPSETRANS'
														END
													PRINT 'SEQUENCE TABLE UPDATE END'
													--PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'
												-----------------------------------------------------------------------------		
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												------------------------------------------------------------------
												END TRY
												
												BEGIN CATCH
													SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO LAPSE BUCKET.'
													GOTO ENDOFTHESP	
													--RAISERROR(@VALIDATIONMSG,11,2)
												END CATCH
												
													IF(@@ERROR<>0)
													BEGIN
														set @IsErrorFound = 1
														goto EndOftheSP	
													END											
											----------------------------------
												END
											END
											
										 ELSE IF(@GL_VESTEDQTY = 0 AND @GL_LAPSEDQTY > 0)
											 BEGIN
											  IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
												BEGIN
													SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO LAPSE BUCKET.'
													RAISERROR(@VALIDATIONMSG,11,2)
												END
												
											   ELSE
												BEGIN	
													-----IF-ELSE LOOP START---------------------------------------												
														BEGIN TRY		
															PRINT 'UPDATE THE EXPIRY DATE'
														---------------------------------------------------------------------------
														IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
														BEGIN
															UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
															WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
														END
														ELSE
														BEGIN
															UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
															WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID	
														END
														---------------------------------------------------------------------------
												
													INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
													VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
														------------------------------------------------------------------
														END TRY
														BEGIN CATCH
															SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE.'
															GOTO EndOftheSP
															--RAISERROR(@VALIDATIONMSG,11,3)
														END CATCH
														IF(@@ERROR <> 0)
														 BEGIN
															set @IsErrorFound = 1
															goto EndOftheSP	
														 END													
														--PRINT 'UPDATE THE EXPIRY DATE'
													-----IF- ELSE LOOP END START---------------------------------------
												END
									--------------------------------------------																				
										   END
										 
										 ELSE IF(@GL_VESTEDQTY = 0 AND @GL_CANCELLEDQTY > 0)
										 BEGIN
												BEGIN TRY
													------------------------------------------------------------------------													
														INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
													------------------------------------------------------------------	
													IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			EXPIRYPERFORMED='Y',
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END
													ELSE
													BEGIN
													---------------------------------------------
														UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																			EXPIRYPERFORMED='Y',
																			LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
														WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													------------------------------------------------------------------------
													END																								
													---------------------------------------------
														--PRINT 'UPDATE THE EXPIRY DATE AND MOVE OPTIONS INTO VESTED BUCKET'
													END TRY
													BEGIN CATCH
														SET @VALIDATIONMSG ='VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE .'
														GOTO ENDOFTHESP	
														--RAISERROR(@VALIDATIONMSG,11,3)
													END CATCH
													IF @@ERROR <> 0
													BEGIN													
														SET @ISERRORFOUND = 1
														GOTO ENDOFTHESP													
													END
										END
										
										------------------------------------------------------------------
										 ELSE IF(@SGL_VESTINGTYPE ='P' AND @SGL_ISPERFORMANCE='N')
										 BEGIN
											IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND DID NOT MOVE OPTIONS INTO LAPSE BUCKET.'
												GOTO EndOftheSP
												--RAISERROR(@VALIDATIONMSG,11,2)
											END
											ELSE
											BEGIN
												UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
														FROM #TEMP1
												WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
											END
										 END
									------------------------------------------------------------------
										 ELSE IF((@SGL_VESTINGTYPE ='P' OR @SGL_VESTINGTYPE='T') AND (@SGL_ISPERFORMANCE='1'))
										 BEGIN
											IF(@SGL_FINALEXPIRYDATE < @SGL_FINALVESTINGDATE)
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE EXPIRY DATE AND DID NOT MOVE OPTIONS INTO LAPSE BUCKET.'
												GOTO EndOftheSP
												--RAISERROR(@VALIDATIONMSG,11,2)
											END
											ELSE
											BEGIN
												BEGIN TRY
												---------------------------------------------------------------------------------------------------------------	
													UPDATE GRANTLEG SET EXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,FINALEXPIRAYDATE=#TEMP1.SGL_FINALEXPIRYDATE,
																	EXPIRYPERFORMED='Y', LapsedQuantity = LapsedQuantity + ExercisableQuantity, 
																	LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
															FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND #TEMP1.SGL_ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
												---------------------------------------------------------------------------------------------------------------
												-----------------------------------------------------------------------------
													SELECT @LTRANSID=ISNULL(MAX(CONVERT(INT, LAPSETRANSID)),0) + 1 FROM LAPSETRANS
												-----------------------------------------------------------------------------													
													SELECT @EMPLOYEEID = EMPLOYEEID FROM GrantOptions WHERE GrantOptionId= @GOPID
												-----------------------------------------------------------------------------	
												PRINT 'LAPSE TABLE UPDATE START'
													INSERT INTO LAPSETRANS (LAPSETRANSID,APPROVALSTATUS,GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,
																			LAPSEDQUANTITY,GRANTLEGSERIALNUMBER,LAPSEDATE,EMPLOYEEID,LASTUPDATEDBY,
																			LASTUPDATEDON)
													(SELECT @LTRANSID,'A',GRANTOPTIONID,GRANTLEGID,VESTINGTYPE,LAPSEDQUANTITY,ID,@SGL_FINALEXPIRYDATE,
																		 @EMPLOYEEID,@USERID,GETDATE() FROM GRANTLEG WHERE ID=@SGL_ID)
												PRINT 'LAPSE TABLE UPDATE END'
												-----------------------------------------------------------------------------		
													PRINT 'SEQUENCE TABLE UPDATE START'
														SELECT @SEQ_NO = SEQUENCENO FROM SEQUENCETABLE WHERE SEQ1 = 'LAPSETRANS'
														IF(@SEQ_NO <> @LTRANSID)
														BEGIN
															UPDATE SEQUENCETABLE SET SEQUENCENO =(@LTRANSID) WHERE SEQ1='LAPSETRANS'
														END
													PRINT 'SEQUENCE TABLE UPDATE END'
													--PRINT 'UPDATE THE EXPIRY DATE ONLY AND MOVE THE OPTIONS IN LAPSE BUCKET'
												-----------------------------------------------------------------------------		
													INSERT INTO AuditTrailForEditGrantMassUpload 
															([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
														VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
												------------------------------------------------------------------
													
												END TRY
												BEGIN CATCH
												END CATCH
												
											END
										 END
									------------------------------------------------------------------
										
									--------------------------------------------	 
								END
						--------------------------------------------------------------------
						END 
					---IS EXPIRY DATE UPDATE = Y, VESTING DATE UPDATE = N END.
				-------------------------------------------------------------------				
				END
				---IS EXPIRY DATE UPDATE = Y END. 
		  END
			-----------------------------------------------------------------------
			ELSE
				BEGIN 
					IF(@SGL_ISVESTING ='Y')
					BEGIN
						--------------------------------------------------
						IF(@SGL_ISGRANTED = 'Y')
						BEGIN
							IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_UNAPPROVEQTY = 0 AND @GL_LAPSEDQTY = 0 AND @SGL_FINALVESTINGDATE < @SGL_FINALEXPIRYDATE)
								BEGIN																	
										BEGIN TRY
											PRINT 'CHECK THE VESTING DATE AND GRANTEDOPTIONS UPDATE'
									--------------------------------------------------------------------------------
											IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
											BEGIN
												UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
													BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
												   FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
												FROM #TEMP1
												WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
											END
											ELSE
											BEGIN	
												UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
													BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,EXERCISABLEQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
												   FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
												FROM #TEMP1
												WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
											END
									------------------------------------------------------------------
											INSERT INTO AuditTrailForEditGrantMassUpload 
													([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
											VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
									------------------------------------------------------------------	
											--PRINT 'CHECK THE VESTING DATE AND GRANTEDOPTIONS UPDATE'
										END TRY
										BEGIN CATCH
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE VESTING DATE AND GRANTED OPTIONS.'
											GOTO EndOftheSP
											--RAISERROR(@VALIDATIONMSG,11,2)
										END CATCH
										IF @@ERROR <> 0
										BEGIN
											set @IsErrorFound = 1
											goto EndOftheSP	
										END								
								END
							ELSE
								BEGIN
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : DETAILS CAN NOT MODIFY BECAUSE CANCELLED, EXERCISED, UNAPPROVE, LAPSE COLUMNS CONTAINS DATA.'
									GOTO EndOftheSP
									--RAISERROR(@VALIDATIONMSG,11,6)
								END
						END
						--------------------------------------------------
						ELSE
						 BEGIN
							IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_UNAPPROVEQTY = 0 AND @GL_LAPSEDQTY = 0 AND @SGL_FINALVESTINGDATE < @SGL_FINALEXPIRYDATE)
								BEGIN									
										BEGIN TRY
											PRINT 'UPDATE THE VESTING DATE.'
										-----------------------------------------------------------
										IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
										BEGIN
											UPDATE GRANTLEG SET FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
															LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
											FROM #TEMP1
											WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
											--PRINT 'UPDATE THE VESTING DATE.'								
										END
										ELSE
										BEGIN
											UPDATE GRANTLEG SET FINALVESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,VESTINGDATE=#TEMP1.SGL_FINALVESTINGDATE,
															LASTUPDATEDBY=@USERID,LASTUPDATEDON=GETDATE(),STATUS='A'
											FROM #TEMP1
											WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
										END
										------------------------------------------------------------------
											INSERT INTO AuditTrailForEditGrantMassUpload 
												([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
											VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
										------------------------------------------------------------------
										END TRY
										BEGIN CATCH
											SET @VALIDATIONMSG ='VALIDATION MESSAGE : UNABLE TO UPDATE THE VESTING DATE.'
											GOTO EndOftheSP
											--RAISERROR(@VALIDATIONMSG,11,6)
										END CATCH
										IF(@@ERROR <> 0)
										BEGIN
											set @IsErrorFound = 1
											goto EndOftheSP	
										END									
								END
							ELSE
								BEGIN
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE THE VESTING DATE.'
									GOTO EndOftheSP
									--RAISERROR(@VALIDATIONMSG,11,7)
								END
						END
					END
					ELSE
						BEGIN
							IF(@SGL_ISGRANTED = 'Y')
							BEGIN
								IF(@GL_CANCELLEDQTY = 0 AND @GL_EXEDQTY = 0 AND @GL_UNAPPROVEQTY = 0 AND @GL_LAPSEDQTY = 0)
									BEGIN										
											BEGIN TRY
												PRINT 'UPDATE THE GRANTED OPTIONS ONLY'
											---------------------------------------------------------------
												IF((@SGL_VESTINGTYPE = 'P') AND (@SGL_ISPERFORMANCE='N'))
												BEGIN
													UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
															BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,LASTUPDATEDBY=@USERID,LastUpdatedOn=GETDATE()
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													--PRINT 'UPDATE THE GRANTED OPTIONS ONLY'
												END
												ELSE
												BEGIN
													UPDATE GRANTLEG SET GRANTEDOPTIONS=#TEMP1.SGL_GRANTEDOPTIONS,GRANTEDQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
															BONUSSPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,SPLITQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,EXERCISABLEQUANTITY=#TEMP1.SGL_GRANTEDOPTIONS,
															LASTUPDATEDBY=@USERID,LastUpdatedOn=GETDATE()
													FROM #TEMP1
													WHERE #TEMP1.RNO = @MIN AND GRANTLEG.ID = @SGL_ID AND GRANTLEG.GRANTOPTIONID = @GOPID AND GRANTLEG.GRANTLEGID = @GLID		
													--PRINT 'UPDATE THE GRANTED OPTIONS ONLY'
												END
											---------------------------------------------------------------											
												INSERT INTO AuditTrailForEditGrantMassUpload 
														([DATE],[TIMEOFUPLOAD],[UPDATEDBY],[GRANTLEGSERIALNO],[STATUS],[OLD_EXPIRY_DATE],[EXPIRY_DATE],[OLD_VESTING_DATE],[VESTING_DATE],[OLD_GRANTEDOPTIONS],[GRANTEDOPTIONS])
												VALUES (GETDATE(),GETDATE(),@USERID,@SGL_ID,@STATUS,@GL_FINALEXPIRYDATE,@SGL_FINALEXPIRYDATE,@GL_FINALVESTINGDATE,@SGL_FINALVESTINGDATE,@GL_GRANTEDQTY,@SGL_GRANTEDQTY)
											------------------------------------------------------------------
											END TRY
											BEGIN CATCH
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : UNABLE TO UPDATE GRANTED OPTIONS. '
												GOTO EndOftheSP
												--RAISERROR(@VALIDATIONMSG,11,4)
											END CATCH
											IF(@@ERROR <> 0)
											BEGIN
												set @IsErrorFound = 1
												goto EndOftheSP	
											END										
									END
								ELSE
									BEGIN
										SET @VALIDATIONMSG ='VALIDATION MESSAGE : UNABLE TO UPDATE THE GRANTED OPTIONS.'
										GOTO EndOftheSP
										--RAISERROR(@VALIDATIONMSG,11,8)
									END
							END
						END					
				END
			-----------------------------------------------------------------------
			SET @MIN = @MIN + 1  			
		END

EndOftheSP:
	IF @@ERROR <> 0 OR @IsErrorFound = 1 OR @VALIDATIONMSG <> ''		
	BEGIN		
		SELECT @VALIDATIONMSG AS [SP_MESSAGE]
	END
	ELSE
	BEGIN
		SET @VALIDATIONMSG = 'DATA UPLOADED SUCCESSFULLY.'
		DELETE FROM SHGRANTLEG		
		SELECT @VALIDATIONMSG AS [SP_MESSAGE]	
	END

	IF EXISTS        
     (        
		SELECT *        
		FROM tempdb.dbo.sysobjects        
		WHERE ID = OBJECT_ID(N'tempdb..#TEMP1')        
     )        
     BEGIN        
		DROP TABLE #TEMP1   
     END 
END
		
	



GO
