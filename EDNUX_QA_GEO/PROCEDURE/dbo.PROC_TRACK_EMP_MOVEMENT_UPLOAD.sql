/****** Object:  StoredProcedure [dbo].[PROC_TRACK_EMP_MOVEMENT_UPLOAD]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TRACK_EMP_MOVEMENT_UPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TRACK_EMP_MOVEMENT_UPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_TRACK_EMP_MOVEMENT_UPLOAD]
(
	@UserId										NVARCHAR(100),	
	@EMP_MOVE_UPLOAD TRACK_EMP_MOVE_UPLOAD_TYPE READONLY 
)
AS
BEGIN
	--SELECT * FROM @EMP_MOVE_UPLOAD
	SET NOCOUNT ON;
	DECLARE @EMP_COUNT_DATA						SMALLINT,
			@TEMP_EMP_COUNT_DATA    			SMALLINT,
			@MIN								INT,
			@MAX								INT,
			@SRNO								INT,
			@FIELD								NVARCHAR(200),
			@EMPLOYEEID							NVARCHAR(200),
			@EMPLOYEENAME						NVARCHAR(200),
			@STATUS								NVARCHAR(200),
			@CURRENTDETAILS						NVARCHAR(200),
			@FROM_DATE							DATE,
			@MOVE_TO							NVARCHAR(200) = NULL,
			@FROM_DATE_OF_MOVEMENT 				DATE,			
			@FIELD_VALUE						NVARCHAR(200) = NULL,
			@ERROR_MESSAGE						NVARCHAR(MAX) = NULL,
			@ERROR_MESSAGE_MOVETO_1				NVARCHAR(200) = '[Move To] column value should Not Be Empty. Row Number {0}. ',
			@ERROR_MESSAGE_MOVETO_2				NVARCHAR(200) = '[Move To] column value does not exist in master list. Please update the masterlist and then update the details. No record updated. Row Number {0}. ',
			@ERROR_MESSAGE_FROM_DATE_MOVE_1		NVARCHAR(200) = '[From Date Of Movement] dateshould not be empty. Row Number {0}. ',
			@ERROR_MESSAGE_FROM_DATE_MOVE_2		NVARCHAR(200) = '[From Date Of Movement] date is not in valid format. Row Number {0}. ',
			@ERROR_MESSAGE_FROM_DATE_MOVE_3		NVARCHAR(200) = '[From Date Of Movement] date cannot be a future date. Please enter details correctly. Row Number {0}. ',
			@ERROR_MESSAGE_FROM_DATE_MOVE_4		NVARCHAR(200) = '[From Date Of Movement] date cannot be equal to or lesser than the [From Date]. Please enter details correctly. Row Number {0}.	',
			@ERROR_MESSAGE_NO_RECORD			NVARCHAR(200) = 'Combination of Employee Id, Employee Name, Status does not exist. Please check.',
			@ERROR_MESSAGE_DATA_PRESENT			NVARCHAR(200) = 'Combination of Field, Employee Id, Move To, From Date of Movement is already updated on same date. Please check at row Number {0}.',
			@CNT_DATA							SMALLINT = 0
			
	
	CREATE TABLE #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
	(
		[SRNO]						INT IDENTITY(1,1),
		[FIELD]						VARCHAR(200),
		[EMPLOYEEID]				VARCHAR(200),
		[EMPLOYEENAME]				VARCHAR(200),
		[STATUS]					VARCHAR(200),
		[CURRENTDETAILS]			VARCHAR(200),
		[FROMDATE]					DATE,
		[MOVED TO]					VARCHAR(200),
		[FROM DATE OF MOVEMENT] 	DATE,
		[ISERROR]					BIT,
		[ERRORMESSAGE]				NVARCHAR(1000)
	)
	
	CREATE TABLE #TEMP_MASTER_LIST_DATA
	(
		[SR_NO]			INT IDENTITY(1,1),
		[FIELD_VALUE]	NVARCHAR(MAX)
		--[STATES]       NVARCHAR(MAX) NULL
	)	
	
	/* READ COUNT EMPLOYEE TRACKING DATA : VALIDATION PURPOSE */	
	SELECT @EMP_COUNT_DATA = COUNT([EmployeeId]) FROM @EMP_MOVE_UPLOAD
	
	/* INSERT RECORDS INTO TEMP TRACK TABLE FROM TABLE TYPE */
	INSERT INTO #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
				([Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
				[From Date of Movement],[IsError],[ErrorMessage])
	SELECT		E.[Field],E.[EmployeeId],E.[EmployeeName],E.[Status],E.[CurrentDetails],E.[FromDate],E.[Moved To],
				E.[From Date of Movement],0,E.[ErrorMessage] 
	FROM @EMP_MOVE_UPLOAD E
		 INNER JOIN EmployeeMaster EMP
		 ON EMP.EmployeeID = E.EmployeeId 	
		
		
	SET @FIELD = (SELECT DISTINCT CASE WHEN(Upper(FIELD)= UPPER('TAX IDENTIFIER COUNTRY')) THEN 'TAX_IDENTIFIER_COUNTRY'
	                                   WHEN (UPPER(FIELD)= UPPER('TAX IDENTIFIER STATE'))  THEN 'TAX_IDENTIFIER_STATE' 
	                              ELSE FIELD END
                   FROM  #TEMP_TRACK_EMP_MOVEMENT_UPLOAD)		
	/* INSERT RECORD TEMP MASTER LIST FROM MASTER LIST TABLE */
			INSERT INTO  #TEMP_MASTER_LIST_DATA
						 ([FIELD_VALUE])
			SELECT		 MLFV.FIELD_VALUE
			FROM MASTER_LIST_FLD_VALUE MLFV      
				 LEFT OUTER JOIN MASTER_LIST_FLD_NAME MLFN
				 ON MLFN.MLFN_ID = MLFV.MLFN_ID
				 WHERE UPPER(MLFN.FIELD_NAME) = UPPER(@FIELD)
				 AND MLFN.IS_TRACKING_ENABLED = 1 AND MLFN.FIELD_NAME NOT IN ('TAX_IDENTIFIER_COUNTRY','TAX_IDENTIFIER_STATE')
				 
				 IF(@FIELD='TAX_IDENTIFIER_COUNTRY')
				 BEGIN
				    INSERT INTO  #TEMP_MASTER_LIST_DATA
				    ([FIELD_VALUE])
					SELECT	CM.COUNTRYNAME AS FIELD_VALUE
					FROM MASTER_LIST_FLD_VALUE MLFV LEFT OUTER JOIN MASTER_LIST_FLD_NAME MLFN 
					ON MLFN.MLFN_ID = MLFV.MLFN_ID
					CROSS JOIN CountryMaster AS CM
	     			WHERE UPPER(MLFN.FIELD_NAME) = UPPER(@FIELD)
					AND MLFN.IS_TRACKING_ENABLED = 1 AND ISSELECTED = 1	  
				  END
				 
				 ELSE IF (@FIELD='TAX_IDENTIFIER_STATE')
				 BEGIN
				    INSERT INTO  #TEMP_MASTER_LIST_DATA
				    ([FIELD_VALUE])				    
					SELECT STATE_NAME AS FIELD_VALUE
					FROM MST_STATES ST 
					Where ( SELECT COUNT(MLFN.MLFN_ID)	FROM  MASTER_LIST_FLD_VALUE MLFV 
							LEFT OUTER JOIN MASTER_LIST_FLD_NAME MLFN ON MLFN.MLFN_ID = MLFV.MLFN_ID	   
							WHERE UPPER(MLFN.FIELD_NAME) = UPPER('TAX_IDENTIFIER_COUNTRY') AND	MLFN.IS_TRACKING_ENABLED = 1 ) >0 AND IS_SELECTED = 1		
				 END
								 
	/* READ COUNT EMPLOYEE TRACKING DATA : VALIDATION PURPOSE */
	SELECT @TEMP_EMP_COUNT_DATA = COUNT([EmployeeId]) FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
	
	--select * from #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
	IF (@EMP_COUNT_DATA = @TEMP_EMP_COUNT_DATA)
	BEGIN
		/* SET MIN AND MAX VALUE FROM TEMP TRACK TABLE FOR DATA PROCESSING */
		SELECT @MIN = MIN([SRNO]),
			   @MAX = MAX([SRNO])
		FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
		
		
		WHILE(@MIN <= @MAX)
		BEGIN
			SELECT	@SRNO = [SRNO], 					
					@FIELD = CASE WHEN(Upper([FIELD])= UPPER('TAX IDENTIFIER COUNTRY')) THEN 'TAX_IDENTIFIER_COUNTRY'
	                                WHEN (UPPER([FIELD])= UPPER('TAX IDENTIFIER STATE'))  THEN 'TAX_IDENTIFIER_STATE' 
	                           ELSE [FIELD] END ,-- [FIELD],					
					@EMPLOYEEID = [EMPLOYEEID],				
					@EMPLOYEENAME = [EMPLOYEENAME],			
					@STATUS	= [STATUS],				
					@CURRENTDETAILS = [CURRENTDETAILS],
					@FROM_DATE = [FROMDATE],				
					@MOVE_TO = [MOVED TO],				
					@FROM_DATE_OF_MOVEMENT = [FROM DATE OF MOVEMENT]
			FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
			WHERE [SRNO] = @MIN
			
			/*Need to check data in already present into table or not*/	
			-----------------------------------------------------------
			SELECT @CNT_DATA = COUNT(EmployeeId) FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD 
			WHERE Field = @FIELD 
					AND EmployeeId = @EMPLOYEEID 
					AND [Moved To] = @MOVE_TO 
					AND [From Date of Movement] = @FROM_DATE_OF_MOVEMENT
					AND CONVERT(DATE,CREATED_ON) = CONVERT(DATE,GETDATE())
			
			--PRINT '{'+CONVERT(VARCHAR,@CNT_DATA) +'}'
			IF(@CNT_DATA = 0)
			BEGIN		
			/* SET [FIELD_VALUE] */
			SELECT @FIELD_VALUE = TMLD.[FIELD_VALUE] 
			FROM #TEMP_MASTER_LIST_DATA TMLD
			WHERE UPPER(TMLD.[FIELD_VALUE]) = UPPER(@MOVE_TO)
			
			/* VALIDATEING [MOVE TO] FIELD VALUE IS NOT NULL */
			IF (@MOVE_TO IS NOT NULL AND @MOVE_TO <> '')
			BEGIN	
				/* VALIDATING [MOVE TO] FIELD VALUE AND MASTER LIST DATA VALUE IS SAME */
				IF(@FIELD_VALUE IS NOT NULL AND @FIELD_VALUE <> '')
				BEGIN	
					
					/* FROM_DATE IS NOT NULL */
					IF(CONVERT(DATE,@FROM_DATE) <> '1900-01-01')
					BEGIN
						/* VALIDATING - FROM_DATE_OF_MOVEMENT SHOULD NOT NULL*/
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> '1900-01-01')
						BEGIN
							/* VALIDATING - FROM_MOVE_TO_DATE CANNOT BE EQUAL TO OR LESSER THAN THE FROM_DATE*/
							IF((CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> CONVERT(DATE,@FROM_DATE)) AND (CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,@FROM_DATE)))
							BEGIN
								/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* LOG ERROR - FOR FUTURE DATE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
							END
							ELSE
							BEGIN
								/* LOG ERROR FOR DATE CANNOT BE EQUAL TO OR LESSER */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								/* VALIDATEING [MOVE TO FROM DATE] FIELD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* APPEND ERROR MESSAGE TO @ERROR_MESSAGE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
								
							END		
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
						END	
					END
					ELSE
					BEGIN
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> '1900-01-01')
						BEGIN
							/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
							IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
							BEGIN
								/* LOG ERROR - FOR FUTURE DATE */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
							END
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
						END	
					END
				END
				ELSE
				BEGIN
					/* LOG ERROR - [MOVE TO] FIELD VALUE AND MASTER LIST DATA VALUE IS SAME*/	
					IF(@ERROR_MESSAGE IS NULL)
						SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_MOVETO_2,'{0}',@MIN + 1)
					ELSE
						SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_MOVETO_2,'{0}',@MIN + 1)
					
					/* FROM_DATE IS NOT NULL */
					IF(CONVERT(DATE,@FROM_DATE) <> '1900-01-01')
					BEGIN	
						/* VALIDATING - FROM_DATE_OF_MOVEMENT SHOULD NOT NULL*/
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> '1900-01-01')
						BEGIN
							/* VALIDATING - FROM_MOVE_TO_DATE CANNOT BE EQUAL TO OR LESSER THAN THE FROM_DATE*/
							IF((CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> CONVERT(DATE,@FROM_DATE)) AND (CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,@FROM_DATE)))
							BEGIN
								/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* LOG ERROR - FOR FUTURE DATE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
							END
							ELSE
							BEGIN
								/* LOG ERROR FOR DATE CANNOT BE EQUAL TO OR LESSER */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								/* VALIDATEING [MOVE TO FROM DATE] FIELD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* APPEND ERROR MESSAGE TO @ERROR_MESSAGE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
								
							END		
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
						END	
					END
					ELSE
					BEGIN
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> '1900-01-01')
						BEGIN
							/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
							IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
							BEGIN
								/* LOG ERROR - FOR FUTURE DATE */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
							END
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)
						END	
					END
				END
			END
			ELSE
			BEGIN	
							
				/* LOG ERROR - [MOVE TO] VALUE SHOULD NOT NULL */
				IF(@ERROR_MESSAGE IS NULL)
					SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_MOVETO_1,'{0}',@MIN + 1)
				ELSE
					SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_MOVETO_1,'{0}',@MIN + 1)
				
				/* FROM_DATE IS NOT NULL */
					IF(CONVERT(DATE,@FROM_DATE) <> '1900-01-01')
					BEGIN	
						/* VALIDATING - FROM_DATE_OF_MOVEMENT SHOULD NOT NULL*/
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> '1900-01-01')
						BEGIN
							/* VALIDATING - FROM_MOVE_TO_DATE CANNOT BE EQUAL TO OR LESSER THAN THE FROM_DATE*/
							IF((CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) <> CONVERT(DATE,@FROM_DATE)) AND (CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,@FROM_DATE)))
							BEGIN
								/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* LOG ERROR - FOR FUTURE DATE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
							END
							ELSE
							BEGIN
								/* LOG ERROR FOR DATE CANNOT BE EQUAL TO OR LESSER */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_4,'{0}',@MIN + 1)
								/* VALIDATEING [MOVE TO FROM DATE] FIELD NOT A FUTURE DATE */
								IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
								BEGIN
									/* APPEND ERROR MESSAGE TO @ERROR_MESSAGE */
									IF(@ERROR_MESSAGE IS NULL)
										SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
									ELSE
										SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								END
								
							END		
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
						END	
					END
					ELSE
					BEGIN
						IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT)	<> '1900-01-01')
						BEGIN
							/* VALIDATEING - [MOVE TO FROM DATE] SHOULD NOT A FUTURE DATE */
							IF(CONVERT(DATE,@FROM_DATE_OF_MOVEMENT) > CONVERT(DATE,GETDATE()))
							BEGIN
								/* LOG ERROR - FOR FUTURE DATE */
								IF(@ERROR_MESSAGE IS NULL)
									SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
								ELSE
									SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_3,'{0}',@MIN + 1)
							END
						END				
						ELSE
						BEGIN
							/* LOG ERROR - FOR NULL FROM_DATE_OF_MOVEMENT*/
							IF(@ERROR_MESSAGE IS NULL)
								SET @ERROR_MESSAGE =  REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)
							ELSE
								SET @ERROR_MESSAGE += REPLACE(@ERROR_MESSAGE_FROM_DATE_MOVE_1,'{0}',@MIN + 1)							
						END	
					END
			END
			/* OUT SIDE LOOP */
			END
			-----------------------------------------------------------
			ELSE
			BEGIN
				--PRINT 'SET ERROR MESSAGE {'+CONVERT(VARCHAR,@MIN + 1) +'}'
				SET @ERROR_MESSAGE = REPLACE(@ERROR_MESSAGE_DATA_PRESENT,'{0}',@MIN + 1)
				--PRINT 'SET ERROR MESSAGE {'+CONVERT(VARCHAR,@ERROR_MESSAGE) +'}'
			END
			
			IF(@ERROR_MESSAGE IS NOT NULL)
			BEGIN	
				UPDATE #TEMP_TRACK_EMP_MOVEMENT_UPLOAD SET [ERRORMESSAGE] = @ERROR_MESSAGE,[ISERROR] = 1  
				WHERE [SRNO] = @SRNO 
				SET @ERROR_MESSAGE = NULL
			END
			SET @FIELD_VALUE = NULL
			SET @MIN = @MIN + 1
			
		END		
		/* RETUREN TEMP TABLE*/
		--SELECT * FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
			
	END			
	ELSE
	BEGIN
		INSERT INTO #TEMP_TRACK_EMP_MOVEMENT_UPLOAD 
					([Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
					[From Date of Movement],[IsError],[ErrorMessage])
		SELECT		E.[Field],E.[EmployeeId],E.[EmployeeName],E.[Status],E.[CurrentDetails],E.[FromDate],E.[Moved To],
					E.[From Date of Movement],1,@ERROR_MESSAGE_NO_RECORD
		FROM @EMP_MOVE_UPLOAD E
			WHERE E.EmployeeId NOT IN (SELECT TEMP.EMPLOYEEID FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TEMP)
			
	END	
	
	
	/* RETUREN TEMP TABLE WITH ERROR*/
	IF EXISTS (SELECT 1 FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD WHERE ISERROR = 1)
	BEGIN
		SELECT [SRNO] AS [SNNO], [Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
						[From Date of Movement],[IsError],[ErrorMessage] AS [ERROR],'ERROR OCCURED WHILE PERFORMING MASSUPLOAD' AS REMARK
		FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
		WHERE ISERROR = 1
	END
	ELSE
	BEGIN
		INSERT INTO AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
					([Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
					[From Date of Movement],[IsError],[ErrorMessage],[CREATED_BY],[CREATED_ON])
		SELECT		TEMP.[FIELD],TEMP.[EmployeeId],TEMP.[EmployeeName],TEMP.[Status],TEMP.[CurrentDetails],TEMP.[FromDate],TEMP.[Moved To],
					TEMP.[From Date of Movement],TEMP.[IsError],TEMP.[ErrorMessage],@UserId,GETDATE()
		FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TEMP 
		WHERE ISERROR = 0
		
		/* UPDATE FIELD VALUE INTO EMPLOYEE MASTER TABLE */
		BEGIN TRY
			IF UPPER(@FIELD) = 'ENTITY'
			BEGIN
				UPDATE EM  SET Entity = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EmployeeMaster EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EmployeeID AND EM.Deleted = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'SBU'
			BEGIN
				UPDATE EM  SET SBU = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EmployeeMaster EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EmployeeID AND EM.Deleted = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'DEPARTMENT'
			BEGIN
				UPDATE EM  SET Department = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EmployeeMaster EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EmployeeID AND EM.Deleted = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'COST_CENTER'
			BEGIN
				UPDATE EM  SET COST_CENTER = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EmployeeMaster EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EMPLOYEEID AND EM.DELETED = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'LOCATION'
			BEGIN
				UPDATE EM  SET Location = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EmployeeMaster EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EMPLOYEEID AND EM.DELETED = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'TAX_IDENTIFIER_COUNTRY'
			BEGIN
				UPDATE EM  SET TAX_IDENTIFIER_COUNTRY = (Select Top(1) CountryMaster.ID From CountryMaster Where UPPER(CountryName)=UPPER(TA.[Moved To])),FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EMPLOYEEMASTER EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EMPLOYEEID AND EM.DELETED = 0 
			END
			
			ELSE IF UPPER(@FIELD) = 'TAX_IDENTIFIER_STATE'
			BEGIN
				UPDATE EM  SET TAX_IDENTIFIER_STATE = TA.[Moved To],FROM_DATE = DATEADD(DAY,-1,TA.[From Date of Movement])
				FROM EMPLOYEEMASTER EM
				INNER JOIN #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TA
				ON TA.[EmployeeId] = EM.EMPLOYEEID AND EM.DELETED = 0 
			END
			
			/* RETURN TABLE WITHOUT ERROR*/
			SELECT [Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
							[From Date of Movement],[IsError],[ErrorMessage],'DATA UPLOADED SUCCESSFULLY' AS REMARK
			FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
			WHERE ISERROR = 0			
			
		END TRY
		BEGIN CATCH	
			SELECT [Field],[EmployeeId],[EmployeeName],[Status],[CurrentDetails],[FromDate],[Moved To],
						[From Date of Movement],1,[ErrorMessage],'ERROR OCCURED WHILE PERFORMING MASSUPLOAD' AS REMARK
			FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD
			WHERE ISERROR = 1
		END CATCH
	
		--/* INSERT DATA INTO EMP_MOVEMNT_TRACKING_UPLOAD TABLE FRO APPROVAL */
		--INSERT INTO EMP_MOVEMNT_TRACKING_UPLOAD 
		--			([EMP_ID], [EMP_NAME], [EMP_STATUS], [CURRENTDETAILS], [FROMDATE], [MOVED_TO], 
		--			[FROM_DATE_OF_MOVEMENT], [IS_ERROR], [ERROR_MESSAGE], [CREATED_BY], [CREATED_ON])
					
		--SELECT		TEMP.[EmployeeId],TEMP.[EmployeeName],TEMP.[Status],TEMP.[CurrentDetails],TEMP.[FromDate],TEMP.[Moved To],
		--			TEMP.[From Date of Movement],TEMP.[IsError],TEMP.[ErrorMessage],@UserId,CONVERT(DATE,GETDATE())
		--FROM #TEMP_TRACK_EMP_MOVEMENT_UPLOAD TEMP 
		--WHERE ISERROR = 0
	END
	SET NOCOUNT OFF;
END				
GO
