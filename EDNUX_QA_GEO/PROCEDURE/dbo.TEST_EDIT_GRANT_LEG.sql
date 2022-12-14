/****** Object:  StoredProcedure [dbo].[TEST_EDIT_GRANT_LEG]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[TEST_EDIT_GRANT_LEG]
GO
/****** Object:  StoredProcedure [dbo].[TEST_EDIT_GRANT_LEG]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TEST_EDIT_GRANT_LEG]   
AS  
BEGIN  

 DECLARE @GOPID VARCHAR(20),  
		 @GLID VARCHAR(10),  
		 @VESTINGDATE DATETIME,  
		 @GL_VESTEDOPTIONS NUMERIC(18,0),  
		 @EXPIRYDATE DATETIME,  
		 @GRANTEDOPTIONS NUMERIC(18,0),  
		 @GL_VESTINGDATE DATETIME,  
		 @GL_EXPIRYDATE DATETIME,  
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
		 @GL_STATUS CHAR,  
		 @SUM INT,
		 @TEMPSUM INT,
		 @GL_GRNTLGID INT,
		 @RCOUNT INT  
		    
 SET @ISVESTING = 0  
 SET @ISGRANTED = 0  
 SET @ISEXPIRY = 0  
  
 SELECT @MIN=MIN(SRNO),
		@MAX = MAX(SRNO)  
   FROM EDIT_GRANT_MASSUPLOAD  
  	PRINT 'Min'
	PRINT @MIN
	PRINT 'Max'
	PRINT @MAX
  
 SELECT  Max(GrantLeg.ID) AS ID,Row_Number() over(order by SRNO)as SRNO,EDIT_GRANT_MASSUPLOAD.SRNO as Row_No, GRANTLEG.GRANTLEGID,
		EDIT_GRANT_MASSUPLOAD.GRANTOPTIONID,  
		EDIT_GRANT_MASSUPLOAD.VESTINGDATE,EDIT_GRANT_MASSUPLOAD.EXPIRYDATE,EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED,  
		EDIT_GRANT_MASSUPLOAD.PARENT,  GRANTLEG.Status,
		  
		GRANTLEG.FinalExpirayDate,GRANTLEG.FINALVESTINGDATE,GRANTLEG.GRANTEDOPTIONS,GRANTLEG.BONUSSPLITQUANTITY,  
		GRANTLEG.EXERCISEDQUANTITY,GRANTLEG.UNAPPROVEDEXERCISEQUANTITY,GRANTLEG.EXERCISABLEQUANTITY,GRANTLEG.LAPSEDQUANTITY,   
		GRANTLEG.CANCELLEDQUANTITY,GRANTLEG.BONUSSPLITCANCELLEDQUANTITY,       
		 
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.VESTINGDATE <> GRANTLEG.VESTINGDATE) OR (EDIT_GRANT_MASSUPLOAD.VESTINGDATE <> GRANTLEG.FINALVESTINGDATE)) THEN 'Y' ELSE 'N' END AS ISVESTINGUPDATE,  
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.EXPIRYDATE <> GRANTLEG.EXPIRAYDATE) OR (EDIT_GRANT_MASSUPLOAD.EXPIRYDATE <> GRANTLEG.FINALEXPIRAYDATE))  THEN 'Y' ELSE 'N' END AS ISEXPIRYUPDATE,  
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED <> GRANTLEG.GRANTEDOPTIONS)AND(EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED <> GRANTLEG.BONUSSPLITQUANTITY)) THEN 'Y' ELSE 'N' END  AS ISGRANTEDOPTIONS    
		
		INTO #TEMP  
		
		FROM   GRANTLEG  
		RIGHT  JOIN  EDIT_GRANT_MASSUPLOAD ON GRANTLEG.GRANTOPTIONID = EDIT_GRANT_MASSUPLOAD.GRANTOPTIONID AND   
		GRANTLEG.GRANTLEGID = EDIT_GRANT_MASSUPLOAD.VESTINGPERIODID AND GRANTLEG.PARENT = EDIT_GRANT_MASSUPLOAD.PARENT  
		WHERE   EDIT_GRANT_MASSUPLOAD.VESTINGDATE != GRANTLEG.FINALVESTINGDATE OR EDIT_GRANT_MASSUPLOAD.EXPIRYDATE != GRANTLEG.FINALEXPIRAYDATE   
		OR EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED != GRANTLEG.GRANTEDOPTIONS   
		GROUP BY EDIT_GRANT_MASSUPLOAD.SRNO, GRANTLEG.GRANTLEGID,
		EDIT_GRANT_MASSUPLOAD.GRANTOPTIONID,  
		EDIT_GRANT_MASSUPLOAD.VESTINGDATE,EDIT_GRANT_MASSUPLOAD.EXPIRYDATE,EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED,  
		EDIT_GRANT_MASSUPLOAD.PARENT,  GRANTLEG.Status,
		  
		GRANTLEG.FinalExpirayDate,GRANTLEG.FINALVESTINGDATE,GRANTLEG.GRANTEDOPTIONS,GRANTLEG.BONUSSPLITQUANTITY,  
		   GRANTLEG.EXERCISEDQUANTITY,GRANTLEG.UNAPPROVEDEXERCISEQUANTITY,GRANTLEG.EXERCISABLEQUANTITY,GRANTLEG.LAPSEDQUANTITY,   
		   GRANTLEG.CANCELLEDQUANTITY,GRANTLEG.BONUSSPLITCANCELLEDQUANTITY ,     
		 
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.VESTINGDATE <> GRANTLEG.VESTINGDATE) OR (EDIT_GRANT_MASSUPLOAD.VESTINGDATE <> GRANTLEG.FINALVESTINGDATE)) THEN 'Y' ELSE 'N' END ,  
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.EXPIRYDATE <> GRANTLEG.EXPIRAYDATE) OR (EDIT_GRANT_MASSUPLOAD.EXPIRYDATE <> GRANTLEG.FINALEXPIRAYDATE))  THEN 'Y' ELSE 'N' END ,  
		CASE WHEN ((EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED <> GRANTLEG.GRANTEDOPTIONS)AND(EDIT_GRANT_MASSUPLOAD.OPTIONSGRANTED <> GRANTLEG.BONUSSPLITQUANTITY)) THEN 'Y' ELSE 'N' END    

		ORDER BY  EDIT_GRANT_MASSUPLOAD.SRNO, EDIT_GRANT_MASSUPLOAD.GRANTOPTIONID 

  
	ALTER TABLE #TEMP ADD REMARK VARCHAR(MAX)  
	--SELECT *FROM #TEMP ORDER BY SRNO  
	SELECT * INTO #TEMP2 FROM #TEMP  
	SELECT TOP 1 * INTO #TEMP3 FROM SHGRANTLEG WHERE ID = null


	SELECT @MIN =1, @MAX = COUNT(1) FROM #TEMP
	PRINT 'Min'
	PRINT @MIN
	PRINT 'Max'
	PRINT @MAX

    PRINT '---VALIDATION START-----'	
	WHILE (@MIN<=@MAX)  
	BEGIN  
			PRINT '-----dATA FETCHING START--------'
			PRINT @MIN
			SELECT @GOPID=GRANTOPTIONID,@VESTINGDATE=VESTINGDATE,@EXPIRYDATE=EXPIRYDATE,@GRANTEDOPTIONS=OPTIONSGRANTED,@PARENT = PARENT,  @GL_STATUS = Status,      
					@GL_EXPIRYDATE=FinalExpirayDate,@GL_VESTINGDATE=FINALVESTINGDATE,@GL_OPTION = GRANTEDOPTIONS, @GL_BONUS = BONUSSPLITQUANTITY,@GL_GRNTLGID = GRANTLEGID,
					@EXERCISED = EXERCISEDQUANTITY, @UNAPPROVEEXD = UNAPPROVEDEXERCISEQUANTITY,@GL_VESTEDOPTIONS=EXERCISABLEQUANTITY, @LAPSED = LAPSEDQUANTITY,   
					@GL_CANCELLED = CANCELLEDQUANTITY, @GL_BONUSCANC = BONUSSPLITCANCELLEDQUANTITY,@GLID = ID,@ISVESTING = ISVESTINGUPDATE ,  
					@ISEXPIRY  = ISEXPIRYUPDATE,  @ISGRANTED = ISGRANTEDOPTIONS   
			FROM   #TEMP   
			WHERE  SRNO = @MIN      
			PRINT '-----dATA FETCHING END--------'
		-----//////--------------\\\\\\-----------
			IF(@ISEXPIRY = 'Y')  
			BEGIN
				IF(@ISVESTING ='Y')  
					BEGIN    
			--------*****---------
						IF(@ISGRANTED = 'Y')    
						BEGIN  
							 --VALIDATION CHECK FOR GRANTED OPTIONS   
							IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
							 BEGIN  
								IF(@VESTINGDATE > @GL_EXPIRYDATE)  
									 BEGIN  
										SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
										UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN  
										----EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,10,@VALIDATIONMSG,@MIN  
										--PRINT 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									 END  
								ELSE  
									BEGIN  
										SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
										UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN  
										--PRINT 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									END  
							END  
							--WHEN GRANTED OPTIONS VALIDATION IS FALSE  
					   ELSE  
						 BEGIN  
							--CHECK VESTING DATE VALIDATION  
							  IF(@VESTINGDATE > @GL_EXPIRYDATE)  
								BEGIN  
									IF(@EXPIRYDATE < @GL_VESTINGDATE)  
										BEGIN  
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.  Vesting date cannot be after the expiry date. Please check.'  
												UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN  
													--PRINT 'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.  Vesting date cannot be after the expiry date. Please check.'  
										END  
									ELSE  
										BEGIN  
												SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check.'  
												UPDATE #TEMP2 SET REMARK=@VALIDATIONMSG where SRNO=@MIN  
													--PRINT 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check.'  
										END  
								END  
		       			  --CHECK EXPIRY DATE VALIDATION  
							ELSE  
								BEGIN  
								IF(@EXPIRYDATE < @GL_VESTINGDATE)  
									BEGIN  
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.'  
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											--PRINT 'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.'  
									END  
		       
								 --WHEN DATA IS PERFECT THEN YOU HAVE TO EXECUTE FINAL STEPS  
								ELSE  
									BEGIN  
											INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
											UPDATE #TEMP3 set ExpirayDate=@EXPIRYDATE,FinalExpirayDate=@EXPIRYDATE,VestingDate=@VESTINGDATE,FinalVestingDate=@VESTINGDATE,GrantedOptions=@GRANTEDOPTIONS,GrantedQuantity=@GRANTEDOPTIONS,SplitQuantity=@GRANTEDOPTIONS,BonusSplitQuantity=@GRANTEDOPTIONS,ExercisableQuantity=@GRANTEDOPTIONS,LastUpdatedBy='CR/ADMIN',LastUpdatedOn=GETDATE() where ID=@GLID  
											--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,9,Null,@MIN  
											--PRINT 'CHANGE EXPIRY DATE & VESTING DATE & GRANTED OPTIONS'  
									END  
							END  
						END  
						END  
		    --------*****---------
		  --Check when Granted options is not update.  
					--//-\\-----//----\\--------
						ELSE  
						BEGIN  
						--CHECK VESTING DATE VALIDATION,  
							IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
							BEGIN  
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
								BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.  Vesting date cannot be after the expiry date. Please check.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
									--PRINT 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.  Vesting date cannot be after the expiry date. Please check.'  
								END  
							ELSE  
								BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
									--PRINT 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id'  
								END  
						END  
		     				ELSE  
							BEGIN  
							--check vesting 2nd date validation  
							-----*******------****------
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
								BEGIN  
									IF(@EXPIRYDATE < @GL_VESTINGDATE)  
										BEGIN  
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Expiry date cannot be before the vesting date. Please check.'  
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											--PRINT 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Expiry date cannot be before the vesting date. Please check.'  
										END  
									ELSE  
										BEGIN  
											SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check.'  
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										END  
								END      
							-----*******------****------
							ELSE  
								BEGIN  
								--  
								IF(@EXPIRYDATE < @GL_VESTINGDATE)  
								BEGIN  
									SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
								END  
		       
								ELSE  
								BEGIN  
									IF(@LAPSED > 0 AND @GL_VESTEDOPTIONS = 0)  
										BEGIN  
											SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id'  
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										END  
									ELSE IF(@GL_VESTEDOPTIONS > 0 AND @LAPSED = 0)  
										BEGIN  
											INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
											UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
												--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,6,Null,@MIN  
												--PRINT 'CHANGE VESTING DATE & EXPIRY DATE'  
										END  
								END
							END 
							
							-----//*******------****------
					    END  
						END  
				    --//-\\-----//----\\--------
					END  		   
			   ELSE  
					BEGIN         
					  IF(@ISGRANTED = 'Y')  
						BEGIN  
						/*---------------------------*/
							IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
								 BEGIN  
									IF(@EXPIRYDATE < @VESTINGDATE)  
										BEGIN  
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.   Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'   
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										END  
								   ELSE  
										BEGIN  
											SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
											UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										END  
								END  
							ELSE  
								BEGIN  
									IF(@EXPIRYDATE < @VESTINGDATE)  
										BEGIN  
											 SET @VALIDATIONMSG ='VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.'   
											 UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										END  
									ELSE  
										 BEGIN  
											IF(@LAPSED > 0 AND @GL_VESTEDOPTIONS = 0)  
												BEGIN      
													SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
													UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
												END  
											ELSE  
												BEGIN  
													INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
													UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,EXERCISABLEQUANTITY=@GRANTEDOPTIONS,LASTUPDATEDBY=
															'CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
													--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,7,Null,@MIN  
													--PRINT 'CHANGE GRANTED OPTIONS AND EXPIRY DATE'    
												END  
										 END  
								END  
						/*---------------------------*/
					   END  
		    
			ELSE  
					BEGIN  
					--CHECK FOR EXPIRY VALIDATION
					Print('CHECK FOR EXPIRY VALIDATION')
					Print(@EXPIRYDATE)
					print(@VESTINGDATE)
							IF(@EXPIRYDATE < @VESTINGDATE)  
								BEGIN  
									SET @VALIDATIONMSG =  'VALIDATION MESSAGE : Expiry date cannot be before the vesting date. Please check.'   
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
								END  
							ELSE  
								BEGIN  
									IF(@LAPSED > 0 AND @GL_VESTEDOPTIONS = 0 AND @EXPIRYDATE > GETDATE())  
										BEGIN  
										IF(@GL_STATUS <> 'P')
											BEGIN
													Print(@GLID + '@GLID')
													INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
													UPDATE #TEMP3 SET EXPIRAYDATE=@EXPIRYDATE,FINALEXPIRAYDATE=@EXPIRYDATE,EXERCISABLEQUANTITY=LAPSEDQUANTITY,EXPIRYPERFORMED=NULL,LAPSEDQUANTITY=0,LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
													Update GrantLeg set Status ='P' WHERE ID=@GLID  
													--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,3,Null,@MIN  
													--PRINT 'CHANGE EXPIRY DATE ONLY AND MOVE OPTIONS INTO VESTED'  
												END
										ELSE
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Data pending for approval'  
												UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											END 
										END   
								   ELSE IF (@LAPSED = 0 AND @GL_VESTEDOPTIONS > 0 AND @EXPIRYDATE < GETDATE())  
										BEGIN  
										IF(@GL_STATUS <> 'P')
											BEGIN
												Print(@GLID + '@GLID')
												INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
												update #TEMP3 set ExpirayDate=@EXPIRYDATE,FinalExpirayDate=@EXPIRYDATE,LapsedQuantity=ExercisableQuantity,ExpiryPerformed='Y',ExercisableQuantity=0,LastUpdatedBy='CR/ADMIN',LastUpdatedOn=GETDATE() where ID=@GLID  
												Update GrantLeg set Status ='P' WHERE ID=@GLID  
												--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,2,Null,@MIN  
												--PRINT 'CHANGE EXPIRY DATE ONLY AND MOVE OPTIONS INTO LAPSED' 
											END
										ELSE
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Data pending for approval'  
												UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											END 
										END  
								  
								   ELSE IF (@LAPSED = 0 AND @GL_VESTEDOPTIONS > 0 AND @EXPIRYDATE > GETDATE())  
										BEGIN  
										IF(@GL_STATUS <> 'P')
											BEGIN
												Print(@GLID + '@GLID')
												INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
												update #TEMP3 set ExpirayDate=@EXPIRYDATE,FinalExpirayDate=@EXPIRYDATE,LastUpdatedBy='CR/ADMIN',LastUpdatedOn=GETDATE() where ID=@GLID  
												Update GrantLeg set Status ='P' WHERE ID=@GLID  
												--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,2,Null,@MIN  
												--PRINT 'CHANGE EXPIRY DATE ONLY AND MOVE OPTIONS INTO LAPSED'  
											END
										ELSE
											BEGIN
												SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Data pending for approval'  
												UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
											END
										END  
								END  
					END  
					END   
			END  
		-----//////--------------\\\\\\-----------
		    ELSE  
			BEGIN  
				IF(@ISVESTING='Y')  
				  BEGIN  
				 --------/*/*/*/*/*/*/-----------------------
					IF(@ISGRANTED ='Y')  
					BEGIN  
						IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
						BEGIN  
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
							ELSE  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
						END  
						ELSE  
						BEGIN  
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
							BEGIN       
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
							ELSE  
							BEGIN 
							 BEGIN try
									SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP WHERE GRANTOPTIONID = @GOPID --AND GRANTLEGID = @GL_GRNTLGID 
									SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP WHERE GRANTOPTIONID = @GOPID --AND GRANTLEGID = @GL_GRNTLGID 
									PRINT('SUM')
									PRINT(@SUM)
									PRINT('TEMPSUM')
									PRINT(@TEMPSUM)
								IF(@SUM = @TEMPSUM)
								BEGIN
									INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
									UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,EXERCISABLEQUANTITY=@GRANTEDOPTIONS,LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
									--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,8,Null,@MIN  
									--PRINT 'CHANGE VESTING DATE & GRANTED OPTIONS'  
								END
								ELSE
									BEGIN
										  PRINT('IN RAISE ERROR')
										  SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Sum of Options Granted is not matching.'
										  UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										  --GOTO GOTOENDOFSP 
										  --RAISERROR('VALIDATION MESSAGE : Options Granted are Exceeded.',11,1)
									END 
								END TRY
								BEGIN CATCH		
										 SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Error in processing'  
										 PRINT('ERROR')
										 UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
								END CATCH
								IF @@ERROR <> 0
								BEGIN 
										--SET @MessageOut = 'Error occured while saving data for Employee'
										SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Options Granted are Exceeded.'  
										UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										PRINT('ROLLBACK ERROR')
										--ROLLBACK TRANSACTION
								RETURN
								END
							END   
						END  
					END 
				   --------/*/*/*/*/*/*/----------------------- 
					ELSE  
					BEGIN  
							--check vesting 2nd date validation  
						IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
						BEGIN  
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check. Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
							ELSE  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
						END  
						ELSE  
						BEGIN  
							IF(@VESTINGDATE > @GL_EXPIRYDATE)  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Vesting date cannot be after the expiry date. Please check.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END  
							ELSE  
							BEGIN  
									INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
									UPDATE #TEMP3 SET VESTINGDATE=@VESTINGDATE,FINALVESTINGDATE=@VESTINGDATE,LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
									--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,4,Null,@MIN  
									--PRINT 'CHEANGE VESTING DATE ONLY'  
							END  
						END      
					END
				 --------/*/*/*/*/*/*/-----------------------  
				END
				-------/*/*/*/*/*/*/-------------------------  
				ELSE  
				  BEGIN  
					  IF(@ISGRANTED ='Y')  
					  BEGIN  
						--//*****//----------------
							IF(@EXERCISED > 0 OR @UNAPPROVEEXD > 0 OR @LAPSED > 0 OR @GL_CANCELLED > 0 OR @GL_BONUSCANC > 0)  
							BEGIN  
									SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Details cannot be edited as there has been exercise or cancellation or unapprove or lapse  of options for the particular grant leg id.'  
									UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
							END 
						--//*****//---------------- 
							ELSE  
							BEGIN  
							------------------------------------------							  
								BEGIN try
									SELECT @SUM = SUM(GRANTEDOPTIONS) FROM #TEMP WHERE GRANTOPTIONID = @GOPID --AND GRANTLEGID = @GL_GRNTLGID 
									SELECT @TEMPSUM = SUM(OPTIONSGRANTED) FROM #TEMP WHERE GRANTOPTIONID = @GOPID --AND GRANTLEGID = @GL_GRNTLGID 
									PRINT('SUM')
									PRINT(@SUM)
									PRINT('TEMPSUM')
									PRINT(@TEMPSUM)
									IF(@SUM = @TEMPSUM)
									BEGIN
										   INSERT INTO #TEMP3 SELECT * FROM GRANTLEG WHERE ID=@GLID  
										   UPDATE #TEMP3 SET GRANTEDOPTIONS=@GRANTEDOPTIONS,GRANTEDQUANTITY=@GRANTEDOPTIONS,SPLITQUANTITY=@GRANTEDOPTIONS,BONUSSPLITQUANTITY=@GRANTEDOPTIONS,EXERCISABLEQUANTITY=@GRANTEDOPTIONS,LASTUPDATEDBY='CR/ADMIN',LASTUPDATEDON=GETDATE() WHERE ID=@GLID  
											--EXEC dbo.USP_EDIT_GRANT_MASSUPLOADQUERYS @EXPIRYDATE,@VESTINGDATE,@GRANTEDOPTIONS,@GLID,5,Null,@MIN  
											--PRINT 'CHANGE GRANTED OPTIONS ONLY'  
									END
									ELSE
									BEGIN
										  PRINT('IN RAISE ERROR')
										  SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Sum of Options Granted is not matching.'
										  UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										  --GOTO GOTOENDOFSP 
										  --RAISERROR('VALIDATION MESSAGE : Options Granted are Exceeded.',11,1)
									END 
								END TRY
								BEGIN CATCH		
										 SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Error in processing'  
										 PRINT('ERROR')
										 UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
								END CATCH
								IF @@ERROR <> 0
								BEGIN 
										--SET @MessageOut = 'Error occured while saving data for Employee'
										SET @VALIDATIONMSG = 'VALIDATION MESSAGE : Options Granted are Exceeded.'  
										UPDATE #TEMP2 SET REMARK = @VALIDATIONMSG where SRNO=@MIN  
										PRINT('ROLLBACK ERROR')
										--ROLLBACK TRANSACTION
								RETURN
							END
							  --COMMIT TRANSACTION
							------------------------------------------
							END  
					  END   
			      END  
				-------/*/*/*/*/*/*/-------------------------
			END  
		-----//////--------------\\\\\\-----------
			SET @MIN = @MIN + 1  
		END  
	PRINT '---VALIDATION FINISH-----'
	--SELECT * FROM #TEMP3

	SELECT TOP 1 @RCOUNT = ISNULL((CASE WHEN(REMARK!='') THEN  COUNT(REMARK) END),0) FROM #TEMP2 GROUP BY REMARK ORDER BY ISNULL((CASE WHEN(REMARK ! = '') THEN COUNT(REMARK) END), 0) DESC  

	IF(@RCOUNT > 0)  
	BEGIN  
		PRINT '------- ERROR IN EXCEL SHEET START -------'	
		
		SELECT * FROM #TEMP2 WHERE #TEMP2.REMARK != ''
		--DELETE FROM SHGRANTLEG
		SELECT COUNT(*) as TotalRows,'INVALID' as Chk_Status  FROM #TEMP2  WHERE #TEMP2.REMARK != ''   
		
		PRINT '------- ERROR IN EXCEL SHEET END  --------'	
	END  
	ELSE  
	BEGIN  
		PRINT '------- DATA INSERT IN SHADOW TABLE-------'		
		
		--select * from #TEMP3
		SELECT 'DATA UPLOAD SUCCESSFULLY' AS REMARK
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
		
		
		PRINT '------- DATA INSERT IN SHADOW TABLE END-------'
	END  

--GOTOENDOFSP:
	--IF @@ERROR<> 0 OR @VALIDATIONMSG !=''
	--	BEGIN
	--		SELECT * FROM #TEMP2
	--		ROLLBACK TRANSACTION
	--	END
	--ELSE
	--	BEGIN
	--		COMMIT TRANSACTION
	--	END
   
    IF EXISTS        
     (        
		SELECT *        
		FROM tempdb.dbo.sysobjects        
		WHERE ID = OBJECT_ID(N'tempdb..#TEMP2')        
     )        
     BEGIN        
		DROP TABLE #TEMP2
		DROP TABLE #TEMP3
		DROP TABLE #TEMP   
     END  
END  
--SELECT * FROM EDIT_GRANT_MASSUPLOAD  
--DROP TABLE #TEMP  

GO
