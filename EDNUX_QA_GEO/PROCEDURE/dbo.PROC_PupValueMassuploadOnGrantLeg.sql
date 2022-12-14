/****** Object:  StoredProcedure [dbo].[PROC_PupValueMassuploadOnGrantLeg]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PupValueMassuploadOnGrantLeg]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PupValueMassuploadOnGrantLeg]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_PupValueMassuploadOnGrantLeg]
(
	@PupData PUPValueMassUploadType READONLY,
	@UserId	 VARCHAR(50),
	@Action	 CHAR
)
AS
BEGIN
	SET NOCOUNT ON
	--Variable Declaration.
	DECLARE @Min			INT,
			@Max			INT,
			@GrantID		INT,
			@VestId 		INT,
			@Count			INT = 0,
			@ErrorCount     BIT,
			@TrueCount      BIT,
			@CountExedId	INT,			
			@CountGLId		INT,
			@CountShId		INT,
			@ExId			INT,
			@IsPUPEnable	BIT,
			@IsCombination  BIT,
			@VestingType	CHAR,
			@ParentType 	CHAR,
			@ISPerf			CHAR,
			@PayoutDate 	DATE,
			@VestingDate	DATE,
			@ExpiryDate		DATE,
			@PUPFMV 		NUMERIC(18,2),
			@PayoutAmt 		NUMERIC(18,2),
			@PerqValue 		NUMERIC(18,2),
			@PerqTax 		NUMERIC(18,2),
			@ExercisePrice	NUMERIC(18,2),
			@VestedOption	NUMERIC(18,0),
			@ExercisedQty	NUMERIC(18,0),			
			@ExercisedID	NUMERIC(18,0),
			@SchemeId		VARCHAR(50),
			@EmployeeId		VARCHAR(100),
			@GrantOptionId  VARCHAR(100),
			@GrantRegId		VARCHAR(100),
			@Exception		VARCHAR(200)=NULL,
			@ErrorMessage	VARCHAR(200)='PUP FMV/Payout Amount/Payout date fields are mandatory. Please enter all required details.',			
			@ErrorMessage1	VARCHAR(200)='The grant option id is not registered under a ''PUP scheme''. Please check the details.',
			@ErrorMessage2	VARCHAR(200)='Combination of employee id, grant option id, vest id and parent id does not exist. Please check.',
			@ErrorMessage3  VARCHAR(200)='There are no vested options for particular grant option id, vest id and parent id combination. Please check.',
			@ErrorMessage5  VARCHAR(200)='PUP Feature is not enabled for provided scheme.',
			@ErrorMessage6	VARCHAR(200)='Payout date format should be (dd/MMM/yyyy).'
	--@ErrorMessage + '|' + CONVERT(VARCHAR(5),@Min) + '|' + @GrantOptionId + '|' + @EmployeeId,

	CREATE TABLE #TEMP 
	(
		[TempId]		INT IDENTITY(1,1),
		[RowID]			INT,
		[GrantId]		INT,
		[SchemeId]		VARCHAR(100),
		[GrantRegId]	VARCHAR(100),
		[ExercisePrice] NUMERIC(18,2),
		[EmployeeId]	VARCHAR(100),
		[GrantOptionId] VARCHAR(100), 
		[VestID]		INT,				
		[ParentType]	CHAR,
		[PUPFMV]		NUMERIC(18,2),
		[PayoutAmt]		NUMERIC(18,2),
		[PayoutDate]	DATE,
		[PerqValue]		NUMERIC(18,2),
		[PerqTax]		NUMERIC(18,2),		
		[Remark]		VARCHAR(500),
		[IsError]		BIT DEFAULT 0,
		[IsPUPEnabled]	BIT,
		[IsGOP_GLCombin]BIT,
		[VestingDate]	DATE,	
		[ExpiryDate]	DATE,	
		[VestedOptions] NUMERIC(18,2),
		[VestingType]	CHAR,
		[IsPerfBased]   CHAR,		
		[UpdatedBy]		VARCHAR(50)		
	)
    INSERT INTO  #TEMP	(GrantId,
						RowID,
						SchemeId,
						EmployeeId,
						GrantOptionId,
						VestID,
						ParentType,
						PUPFMV,
						PayoutAmt,
						PayoutDate,
						PerqValue,
						PerqTax,
						Remark,
						IsError,
						IsPUPEnabled,
						IsGOP_GLCombin,
						UpdatedBy,
						VestingDate,
						ExpiryDate,
						VestedOptions,
						VestingType,
						IsPerfBased,
						[GrantRegId],
						ExercisePrice)
			SELECT		GrantID,
						P.PUPID,
						SC.SchemeId, 
						P.EmployeeId,	
						P.GrantOptionId, 
						P.VestId,
						P.ParentType, 
						P.PUPFMV, 
						P.PayoutAmt, 
						Convert(date,P.PayoutDate),
						P.PerqValue, 
						P.PerqTax, 
						'',	
						0,	
						SC.IsPUPEnabled, 
						1,
						@UserId, 
						GL.FinalVestingDate,
						GL.FinalExpirayDate,
						GL.ExercisableQuantity, 
						GL.VestingType,
						GL.IsPerfBased,
						GR.GrantRegistrationId,
						GR.ExercisePrice
			FROM		@PUPData P
			INNER JOIN  GrantLeg GL
					ON  GL.ID = P.GrantID 
				   AND  GL.GrantOptionId = P.GrantOptionId 
				   AND  GL.GrantLegId = P.VestId
				   AND  GL.Parent = P.ParentType
			INNER JOIN  GrantOptions GOPs
					ON	GOPs.GrantOptionId = GL.GrantOptionId
				   AND  GOPs.EmployeeId = P.EmployeeId
			INNER JOIN  Scheme SC
					ON  SC.SchemeId = GL.SchemeId
			INNER JOIN  GrantRegistration GR
					ON	GR.GrantRegistrationId = GL.GrantRegistrationId
				   AND  SC.SchemeId = GR.SchemeId
    
    --CREATE EXERCISED TABLE STRUCTURE
    IF (OBJECT_ID('Exercised','U')) IS NOT NULL
    BEGIN
		SELECT * INTO #TEMP2 FROM Exercised WHERE 1 = 2		
	END
	--Copy ShTransaction Table Schema
	IF (OBJECT_ID('ShTransactionDetails','U')) IS NOT NULL
    BEGIN
		SELECT * INTO #TEMP3 FROM ShTransactionDetails WHERE 1 = 2
	END
	--Copy ShTransaction Table Schema
	IF (OBJECT_ID('GrantLeg','U')) IS NOT NULL
    BEGIN
		SELECT * INTO #TEMP4 FROM GrantLeg WHERE 1 = 2
	END
	
	
	--SELECT * FROM #TEMP
	--Fetch Max and Min value for loop		
	SELECT @Min=Min(TempId),@Max=Max(TempId)  FROM #TEMP	
	--PRINT @Min	 PRINT @Max	
	
	SET @ErrorCount = 1
	SET @TrueCount  = 0
	--------------------------------	
	WHILE(@Min<=@Max)
	BEGIN
		--PRINT @Min
		--Select row wise data.
		SELECT  @GrantID		= GrantId,
				@SchemeId		= SchemeId,
				@EmployeeiD		= EmployeeId,
				@GrantOptionId	= GrantOptionId,
				@VestId			= VestID,
				@ParentType		= ParentType,
				@PUPFMV			= PUPFMV,
				@PayoutAmt		= PayoutAmt,
				@PayoutDate		= PayoutDate,
				@PerqValue		= PerqValue,
				@PerqTax		= PerqTax,		
				@IsPUPEnable	= IsPUPEnabled,
				@IsCombination	= IsGOP_GLCombin,
				@VestingType	= VestingType,
				@VestedOption	= VestedOptions,
				@ISPerf			= IsPerfBased,
				@VestingDate	= VestingDate,
				@ExpiryDate		= ExpiryDate,
				@GrantRegId		= GrantRegId,
				@ExercisePrice	= ExercisePrice					
		FROM	#Temp
		WHERE #Temp.TempId = @Min
		
		--PRINT @PayoutDate		
		
		--Check validation any blank row present or not : START.
		IF (@GrantID IS NULL OR @EmployeeId IS NULL OR @GrantOptionId IS NULL 
			OR @VestId IS NULL OR @ParentType IS NULL OR @PUPFMV IS NULL OR @PayoutAmt IS NULL
			OR (@PayoutDate IS NULL) OR (@PayoutDate = '1900-01-01'))
		 BEGIN			
			--PRINT 'Error - 0'
			--Insert record into temp table					
			  UPDATE #TEMP 
			  SET Remark   = Remark + @ErrorMessage,
			   	  IsError  = 1
		  	  WHERE TempId = @Min			
		 END
		ELSE
		BEGIN			
			--Check IsPUPEnable enabled or disable.
			IF (@IsPUPEnable = 1)
			BEGIN 
				----Check Performance/Time base logic----Start-------------------------
				--PRINT 'Check Is Performance base grantoptionid having vested options or not : Performance Logic'
				IF(@Min = 1)
					BEGIN 
						SELECT @ExercisedID = ISNULL(MAX(ISNULL(ExercisedId,0)),0) FROM Exercised
						SELECT @ExId = ISNULL(MAX(ISNULL (ExerciseId,0)),0) FROM ShExercisedOptions
						
						IF(@ExercisedID >= @ExId)							
							SELECT @ExercisedID	= @ExercisedID
						ELSE
							SELECT @ExercisedID =  @ExId
							
						SET @ExercisedID = @ExercisedID + 1
					END
				ELSE
					BEGIN
						SELECT @ExercisedID = @ExercisedID + 1
					END
					
				IF(@VestingType='P')
				BEGIN
					IF(@VestingDate <=CONVERT(DATE,GETDATE()) AND @ExpiryDate >= Convert(DATE,GETDATE()) AND @VestedOption > 0 AND @ISPerf = '1')
					BEGIN
						--PRINT 'Perform Exercise Logic'							
						BEGIN TRY
							--Insert record into #Temp2 table [i.e. Exercised table]
							INSERT INTO #TEMP2 
								(ExercisedId,GrantLegSerialNumber,ExercisedQuantity,SplitExercisedQuantity,BonusSplitExercisedQuantity,ExercisedDate,
								ExercisedPrice,BSEOriginalPrice,LockedInTill,SharesIssuedStatus,SharesIssuedDate,ExercisableQuantity,ExerciseNo,
								LotNumber,DrawnOn,ValidationStatus,Status,PerqstValue,PerqstPayable,FMVPrice,payrollcountry,LastUpdatedBy,LastUpdatedOn,
								Cash,FBTValue,FBTPayable,FBTPayBy,FBTDays,TravelDays,FBTTravelInfoYN,Perq_Tax_rate,SharesArised,FaceValue,SARExerciseAmount,
								StockApperciationAmt,TransID_BankRefNo,isExerciseMailSent,PaymentMode,CapitalGainTax,ExerciseSARid,CGTformulaID,PANStatus,
								CGTRateLT,CGTUpdatedDate,IsPaymentDeposited,PaymentDepositedDate,IsPaymentConfirmed,PaymentConfirmedDate,IsExerciseAllotted,
								ExerciseAllotedDate,IsAllotmentGenerated,AllotmentGenerateDate,IsAllotmentGeneratedReversed,AllotmentGeneratedReversedDate,
								GenerateAllotListUniqueId,GenerateAllotListUniqueIdDate,IsPayInSlipGenerated,PayInSlipGeneratedDate,PayInSlipGeneratedUniqueId,
								IsTRCFormReceived,TRCFormReceivedDate,TRCFormReceivedUpdatedBy,TRCFormReceivedUpdatedOn,IsForm10FReceived,Form10FReceivedDate, isFormGenerate)
							SELECT @ExercisedID,@GrantID,@VestedOption,@VestedOption,@VestedOption,
								   CONVERT(DATE,@PayoutDate),@ExercisePrice,@ExercisePrice,CONVERT(DATE,@PayoutDate),'N',
								   CONVERT(DATE,@PayoutDate),0,NULL,NULL,NULL,'N','A',@PerqValue,@PerqTax,
								   @PUPFMV,NULL,@UserId,SYSDATETIME(),'PUP',0.00,0.00,'Employee',0,0,
								   NULL,'0.00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
									NULL,NULL,0,NULL,0,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,0,NULL,NULL,
								   0,NULL,NULL,NULL,0,Null, 1
								   
							-- Insert record into #Temp3 table [i.e. ShTransactionDetails Table]	   
							INSERT INTO #TEMP3 
									(Cheque_DDNo,BankName,DrawnOn,WriteTransferNo,PANNumber,ITCircle_WardNo,ResidentialStatus,
									DematACType,DepositoryName,DPIDNo,DepositoryParticipantName,ClientNo,AmountPaid,LastUpdatedBy,
									LastUpdatedOn,ExerciseNo,Cheque_DDNo_FBT,BankName_FBT,DrawnOn_FBT,DPRecord,PerqAmt_ChequeNo,
									PerqAmt_DrownOndate,PerqAmt_WireTransfer,PerqAmt_BankName,PerqAmt_Branch,PerqAmt_BankAccountNumber,
									Branch,	AccountNo, PaymentNameEX, PaymentNamePQ, Nationality, Location, IBANNo, Mobile,
									IBANNoPQ, CountryCode, STATUS, ActionType, SecondaryEmailID, ExerciseBankType, PerqBankType,
									ExAmtTypOfBnkAC, PeqTxTypOfBnkAC, CountryName)
							SELECT	NULL, NULL, NULL, NULL,  PANNumber, WardNumber, ResidentialStatus, DematAccountType,
									DepositoryName,	DepositoryIDNumber, DepositoryParticipantNo, ClientIDNumber, @PayoutAmt,
									@EmployeeId, SYSDATETIME(), @ExercisedID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
									NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, Mobile, NULL, NULL, 'P', NULL,
									SecondaryEmailID, NULL, NULL, NULL, NULL, CountryName
							FROM EmployeeMaster
							WHERE EmployeeID = @EmployeeId	
																		
							-- Insert record into #Temp4 table [i.e. GrantLeg Table]	   
							INSERT INTO #TEMP4 
									(ID,ApprovalId, SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,
									 VestingPeriodId,GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,
									 GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,
									 AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,
									 FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,
									 BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
									 BonusSplitExercisedQuantity, ExercisableQuantity,UnvestedQuantity,Status,ParentID,LapsedQuantity,
									 IsPerfBased,SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn)
							SELECT  @GrantID,ApprovalId, SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,
									VestingPeriodId,GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,
									GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,
									AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,
									FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,
									BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,@VestedOption,@VestedOption,@VestedOption,
									0,UnvestedQuantity,Status,ParentID,LapsedQuantity,IsPerfBased,SeparationPerformed,ExpiryPerformed,
									VestMailSent,ExpiredMailSent,@UserId,SYSDATETIME()
							FROM	GrantLeg Where ID=@GrantID   												
						END TRY
						BEGIN CATCH
							SET @Exception = 'Error occured while performing operations.'
						END CATCH							
					END
					ELSE
					BEGIN
						UPDATE #TEMP 
						SET Remark   = Remark + @ErrorMessage3,
							IsError  = 1
						WHERE TempId = @Min
					END
				END
				ELSE
				BEGIN
					IF(@VestingDate <=CONVERT(DATE,GETDATE()) AND @ExpiryDate >= Convert(DATE,GETDATE()) AND @VestedOption > 0 AND @ISPerf='N')
					BEGIN
						--PRINT 'Timebase Exercise Logic'						
						BEGIN TRY
							--Insert record into #Temp2 table [i.e. Exercised table]
							INSERT INTO #TEMP2
								(ExercisedId,GrantLegSerialNumber,ExercisedQuantity,SplitExercisedQuantity,BonusSplitExercisedQuantity,ExercisedDate,
								ExercisedPrice,BSEOriginalPrice,LockedInTill,SharesIssuedStatus,SharesIssuedDate,ExercisableQuantity,ExerciseNo,
								LotNumber,DrawnOn,ValidationStatus,Status,PerqstValue,PerqstPayable,FMVPrice,payrollcountry,LastUpdatedBy,LastUpdatedOn,
								Cash,FBTValue,FBTPayable,FBTPayBy,FBTDays,TravelDays,FBTTravelInfoYN,Perq_Tax_rate,SharesArised,FaceValue,SARExerciseAmount,
								StockApperciationAmt,TransID_BankRefNo,isExerciseMailSent,PaymentMode,CapitalGainTax,ExerciseSARid,CGTformulaID,PANStatus,
								CGTRateLT,CGTUpdatedDate,IsPaymentDeposited,PaymentDepositedDate,IsPaymentConfirmed,PaymentConfirmedDate,IsExerciseAllotted,
								ExerciseAllotedDate,IsAllotmentGenerated,AllotmentGenerateDate,IsAllotmentGeneratedReversed,AllotmentGeneratedReversedDate,
								GenerateAllotListUniqueId,GenerateAllotListUniqueIdDate,IsPayInSlipGenerated,PayInSlipGeneratedDate,PayInSlipGeneratedUniqueId,
								IsTRCFormReceived,TRCFormReceivedDate,TRCFormReceivedUpdatedBy,TRCFormReceivedUpdatedOn,IsForm10FReceived,Form10FReceivedDate, isFormGenerate)
							SELECT @ExercisedID,@GrantID,@VestedOption,@VestedOption,@VestedOption,
								   CONVERT(DATE,@PayoutDate),@ExercisePrice,@ExercisePrice,CONVERT(DATE,@PayoutDate),'N',
								   CONVERT(DATE,@PayoutDate),0,NULL,NULL,NULL,'N','A',@PerqValue,@PerqTax,
								   @PUPFMV,NULL,@UserId,SYSDATETIME(),'PUP',0.00,0.00,'Employee',0,0,
								   NULL,'0.00',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
									NULL,NULL,0,NULL,0,NULL,0,NULL,0,NULL,0,NULL,NULL,NULL,0,NULL,NULL,
								   0,NULL,NULL,NULL,0,NULL, 1
								   
							-- Insert record into #Temp3 table [i.e. ShTransactionDetails Table]	   
							INSERT INTO #TEMP3 
							   (Cheque_DDNo,BankName,DrawnOn,WriteTransferNo,PANNumber,ITCircle_WardNo,ResidentialStatus,
								DematACType,DepositoryName,DPIDNo,DepositoryParticipantName,ClientNo,AmountPaid,LastUpdatedBy,
								LastUpdatedOn,ExerciseNo,Cheque_DDNo_FBT,BankName_FBT,DrawnOn_FBT,DPRecord,PerqAmt_ChequeNo,
								PerqAmt_DrownOndate,PerqAmt_WireTransfer,PerqAmt_BankName,PerqAmt_Branch,PerqAmt_BankAccountNumber,
								Branch,	AccountNo, PaymentNameEX, PaymentNamePQ, Nationality, Location, IBANNo, Mobile,
								IBANNoPQ, CountryCode, STATUS, ActionType, SecondaryEmailID, ExerciseBankType, PerqBankType,
								ExAmtTypOfBnkAC, PeqTxTypOfBnkAC, CountryName)
						SELECT	NULL, NULL, NULL, NULL,  PANNumber, WardNumber, ResidentialStatus, DematAccountType,
								DepositoryName,	DepositoryIDNumber, DepositoryParticipantNo, ClientIDNumber, @PayoutAmt,
								@EmployeeId, SYSDATETIME(), @ExercisedID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
								NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, Mobile, NULL, NULL, 'P', NULL,
								SecondaryEmailID, NULL, NULL, NULL, NULL, CountryName
						   FROM EmployeeMaster
						  WHERE EmployeeID = @EmployeeId	
																		
							-- Insert record into #Temp4 table [i.e. GrantLeg Table]	   
							INSERT INTO #TEMP4 
									(ID,ApprovalId, SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,
									 VestingPeriodId,GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,
									 GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,
									 AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,
									 FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,
									 BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,ExercisedQuantity,SplitExercisedQuantity,
									 BonusSplitExercisedQuantity, ExercisableQuantity,UnvestedQuantity,Status,ParentID,LapsedQuantity,
									 IsPerfBased,SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn)
							SELECT  @GrantID,ApprovalId, SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,
									VestingPeriodId,GrantDistributedLegId,GrantLegId,Counter,VestingType,VestingDate,ExpirayDate,
									GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,AcceleratedVestingDate,
									AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,
									FinalExpirayDate,CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,
									BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,@VestedOption,@VestedOption,@VestedOption,
									0,UnvestedQuantity,Status,ParentID,LapsedQuantity,IsPerfBased,SeparationPerformed,ExpiryPerformed,
									VestMailSent,ExpiredMailSent,@UserId,SYSDATETIME()
							FROM	GrantLeg Where ID=@GrantID   												
						END TRY
						BEGIN CATCH
							SET @Exception = 'Error occured while performing operations.'
						END CATCH
						----------------------------------------------------------
					END
					ELSE
					BEGIN
						UPDATE #TEMP 
						SET Remark   = Remark + @ErrorMessage3,
							IsError  = 1
						WHERE TempId = @Min
					END
				END
				----Check Performance/Time base logic----End---------------------------
			END
			ELSE
			BEGIN 
				--Insert record into temp table 
				--PRINT 'Error - 1'
				UPDATE #TEMP 
				SET Remark   = Remark + @ErrorMessage5,
					IsError  = 1
				WHERE TempId = @Min
			END
		END
		--Check validation any blank row present or not : END.
		SET @Min = @Min + 1
	END
--------------------------------------------------------------------------------------------------------------------------------
	--SELECT * FROM #TEMP
	--ERROR MESSAGE		
	INSERT INTO #TEMP
		(	[GrantId],[RowID],[SchemeId],[EmployeeId],[GrantOptionId],[VestID],
			[ParentType],[PUPFMV],[PayoutAmt],[PayoutDate],[PerqValue],
			[PerqTax],[Remark],[IsError],[IsPUPEnabled],[IsGOP_GLCombin],[UpdatedBy],[VestingDate],	
			[VestedOptions],[VestingType],[IsPerfBased]	)
	SELECT 	GrantID,PUPID,NULL ,EmployeeId,GrantOptionId ,VestId ,ParentType ,
			PUPFMV ,PayoutAmt ,Convert(date,PayoutDate),PerqValue ,PerqTax ,@ErrorMessage2,1,
			0,0,@UserId,NULL,NULL,NULL,NULL
	FROM @PupData WHERE GrantID NOT IN (SELECT GrantId FROM #TEMP)
	
-------------------------------------------------------------------------------------------------------------------------------------------------------		 
	IF((SELECT Count(1) FROM #TEMP WHERE (PUPFMV IS NULL) OR (PayoutAmt IS NULL) OR ((PayoutDate IS NULL) OR (PayoutDate = '1900-01-01'))) > 0)
	BEGIN
		PRINT 'Enter in last loop' 		
		 BEGIN
			  /*SELECT COUNT(1) FROM #TEMP WHERE LTRIM(RTRIM(Remark)) != LTRIM(RTRIM(@ErrorMessage))*/
			  IF((SELECT COUNT(1) FROM #TEMP WHERE LTRIM(RTRIM(Remark)) != LTRIM(RTRIM(@ErrorMessage))) >= 0)
			  BEGIN
			  /*SELECT * FROM #TEMP WHERE ((PayoutDate IS NULL) OR (PayoutDate = '1900-01-01')) AND Remark != @ErrorMessage*/
				 /*SELECT * FROM #TEMP WHERE ((PayoutDate IS NULL) OR (PayoutDate = '1900-01-01')) AND LTRIM(RTRIM(Remark)) = LTRIM(RTRIM(@ErrorMessage)) */
				  IF EXISTS (SELECT COUNT(1) FROM #TEMP WHERE ((PayoutDate IS NULL) OR (PayoutDate = '1900-01-01')))
				  BEGIN
					UPDATE #TEMP 
					SET Remark   = Remark + '<br/>'+@ErrorMessage,
		   				IsError  = 1
					WHERE ((PayoutDate IS NULL) OR (PayoutDate = '1900-01-01')) AND Remark != @ErrorMessage
				 END
			 END
		 END
		 IF EXISTS(SELECT Count(1) FROM #TEMP WHERE ((VestedOptions IS NULL) AND VestingType IS NULL AND IsPerfBased IS NULL))
		 BEGIN
			  --PRINT 'Enter in Error message 3'
			  --SELECT * FROM #TEMP WHERE (VestedOptions = 0 AND VestingType='P' AND IsPerfBased='N') OR (VestedOptions IS NULL AND VestingType IS NULL AND IsPerfBased IS NULL)
			  UPDATE #TEMP 
			  SET Remark   = Remark +'<br/>'+ @ErrorMessage3,
		      	IsError  = 1
			  WHERE (VestedOptions IS NULL AND VestingType IS NULL AND IsPerfBased IS NULL)
			  
			  IF ((SELECT Count(1) FROM #TEMP WHERE (VestedOptions =0) AND VestingType ='T' AND IsPerfBased='N' AND LTRIM(RTRIM(Remark)) != LTRIM(RTRIM(@ErrorMessage3))) > 0)
			  BEGIN
					Print 'Update data'
					UPDATE #TEMP 
						SET Remark   = Remark +'<br/>'+ @ErrorMessage3,
		      				IsError  = 1
					WHERE (VestedOptions =0) AND VestingType ='T' AND IsPerfBased='N' AND LTRIM(RTRIM(Remark)) != LTRIM(RTRIM(@ErrorMessage3))
			  END
		 END		 		 
		 --PRINT 'Enter in last loop -- END' 		
	END
-------------------------------------------------------------------------------------------------------------------------------------------------------	
	--SELECT * FROM #TEMP order by GrantId asc
	--SELECT * FROM @PupData
	--Find out how many errors is occurred during testing.
	SELECT @CountGLId = Count(IsError) FROM #Temp WHERE IsError = 1
	--PRINT @CountGLId
	IF (@CountGLId >= 1 OR @Exception IS NOT NULL )
	BEGIN
		--PRINT 'Error Table'
		SELECT  Row_Number()OVER(order by RowID) [Row_no], TempId + 1 [SRNO1] ,RowID+1 [SRNO],GrantID [ID],SchemeId [SchemeId],EmployeeId [EmployeeId],
				GrantOptionId [GrantOptionID],VestId [GrantLegId],ParentType [Parent],
				PUPFMV [PUPFMV],PayoutAmt [PayoutAmt],Convert(DATE,PayoutDate) [PayoutDate],
				PerqValue [PerqValue],PerqTax [PerqTax],Remark [Remark],IsError [IsError],					
				IsPUPEnabled [IsPUPEnabled],IsGOP_GLCombin [IsCorrectCombination],@UserId [UserId],
				[VestingDate],[VestedOptions],[VestingType],[IsPerfBased]
		FROM #TEMP WHERE IsError = 1 order by RowID
	END
	ELSE
	BEGIN		
		--SELECT * FROM #TEMP2
		--SELECT * FROM #TEMP3
		--SELECT * FROM #TEMP4
		--Insert record into original table.
		SELECT @CountExedId = COUNT(ExercisedId),@Min = Min(ExercisedId),@Max=MAX(ExercisedId) FROM #TEMP2
		SELECT @CountShId   = COUNT(ID) FROM #TEMP3
		SELECT @CountGLId   = COUNT(ID) FROM #TEMP4
		--PRINT @CountExedId PRINT @CountShId PRINT @CountGLId
		IF(@CountExedId = @CountShId AND @CountExedId = @CountGLId)
		BEGIN
			--Insert record into Exercised,ShTransaction tables based on ExercisedId and Id respectively.
			--Update record into GrantLeg table based on ID
			--SET @Count = 1
			WHILE(@Min <= @Max)
			BEGIN
				--PRINT 'Final Insert Record'
				BEGIN TRY
				SELECT @ExercisedID = #TEMP2.ExercisedId , @GrantId = GrantLegSerialNumber FROM #TEMP2 WHERE ExercisedId = @Min
										
				--PRINT 'Exercised Id :' PRINT @ExercisedId
				--PRINT 'Grant Id :'PRINT @GrantId	
				---------------------------------------------------------------------------------------------------------------
						INSERT INTO Exercised
						(
							ExercisedId, GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisedDate, 
							ExercisedPrice,BSEOriginalPrice, LockedInTill, SharesIssuedStatus, SharesIssuedDate, ExercisableQuantity, ExerciseNo, 
							LotNumber, DrawnOn, ValidationStatus, Status, PerqstValue, PerqstPayable, FMVPrice, payrollcountry, LastUpdatedBy, 
							LastUpdatedOn, Cash, FBTValue, FBTPayable, FBTPayBy, FBTDays, TravelDays, FBTTravelInfoYN, Perq_Tax_rate, 
							SharesArised, FaceValue, SARExerciseAmount, StockApperciationAmt, TransID_BankRefNo, isExerciseMailSent,
							PaymentMode, CapitalGainTax, ExerciseSARid, CGTformulaID, PANStatus, CGTRateLT, CGTUpdatedDate, IsPaymentDeposited, 
							PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, 
							IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, 
							GenerateAllotListUniqueId, GenerateAllotListUniqueIdDate, IsPayInSlipGenerated, PayInSlipGeneratedDate,
							PayInSlipGeneratedUniqueId, IsTRCFormReceived, TRCFormReceivedDate, TRCFormReceivedUpdatedBy, TRCFormReceivedUpdatedOn, isFormGenerate 
						)
						(SELECT ExercisedId, GrantLegSerialNumber, ExercisedQuantity, SplitExercisedQuantity, BonusSplitExercisedQuantity, ExercisedDate, 
							ExercisedPrice,BSEOriginalPrice, LockedInTill, SharesIssuedStatus, SharesIssuedDate, ExercisableQuantity, ExerciseNo, 
							LotNumber, DrawnOn, ValidationStatus, Status, PerqstValue, PerqstPayable, FMVPrice, payrollcountry, LastUpdatedBy, 
							LastUpdatedOn, Cash, FBTValue, FBTPayable, FBTPayBy, FBTDays, TravelDays, FBTTravelInfoYN, Perq_Tax_rate, 
							SharesArised, FaceValue, SARExerciseAmount, StockApperciationAmt, TransID_BankRefNo, isExerciseMailSent,
							PaymentMode, CapitalGainTax, ExerciseSARid, CGTformulaID, PANStatus, CGTRateLT, CGTUpdatedDate, IsPaymentDeposited, 
							PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, 
							IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, 
							GenerateAllotListUniqueId, GenerateAllotListUniqueIdDate, IsPayInSlipGenerated, PayInSlipGeneratedDate,
							PayInSlipGeneratedUniqueId, IsTRCFormReceived, TRCFormReceivedDate, TRCFormReceivedUpdatedBy, TRCFormReceivedUpdatedOn, isFormGenerate
						FROM #TEMP2 WHERE ExercisedID=@ExercisedId)
				
						INSERT INTO ShTransactionDetails
						(
							Cheque_DDNo,BankName,DrawnOn,WriteTransferNo,PANNumber,ITCircle_WardNo,ResidentialStatus,DematACType,DepositoryName,
							DPIDNo,DepositoryParticipantName,ClientNo,AmountPaid,LastUpdatedBy,LastUpdatedOn,ExerciseNo,Cheque_DDNo_FBT,BankName_FBT,
							DrawnOn_FBT,DPRecord,PerqAmt_ChequeNo,PerqAmt_DrownOndate,PerqAmt_WireTransfer,PerqAmt_BankName,PerqAmt_Branch,
							PerqAmt_BankAccountNumber,Branch,AccountNo,PaymentNameEX,PaymentNamePQ,Nationality,Location,IBANNo,Mobile,IBANNoPQ,CountryCode,
							STATUS,ActionType,SecondaryEmailID,ExerciseBankType,PerqBankType,ExAmtTypOfBnkAC,PeqTxTypOfBnkAC,CountryName
						)
						SELECT 
							Cheque_DDNo,BankName,DrawnOn,WriteTransferNo,PANNumber,ITCircle_WardNo,ResidentialStatus,DematACType,DepositoryName,
							DPIDNo,DepositoryParticipantName,ClientNo,AmountPaid,LastUpdatedBy,LastUpdatedOn,ExerciseNo,Cheque_DDNo_FBT,BankName_FBT,
							DrawnOn_FBT,DPRecord,PerqAmt_ChequeNo,PerqAmt_DrownOndate,PerqAmt_WireTransfer,PerqAmt_BankName,PerqAmt_Branch,
							PerqAmt_BankAccountNumber,Branch,AccountNo,PaymentNameEX,PaymentNamePQ,Nationality,Location,IBANNo,Mobile,IBANNoPQ,CountryCode,
							STATUS,ActionType,SecondaryEmailID,ExerciseBankType,PerqBankType,ExAmtTypOfBnkAC,PeqTxTypOfBnkAC,CountryName 
						FROM #TEMP3 WHERE ExerciseNo = @ExercisedID
				
						SELECT 
							@VestedOption = ExercisableQuantity,
							@ExercisedQty = ExercisedQuantity,
							@UserId = LastUpdatedBy
						FROM #TEMP4
						WHERE ID=@GrantId
				
						UPDATE GrantLeg 
						SET ExercisedQuantity = @ExercisedQty,SplitExercisedQuantity=@ExercisedQty,
							BonusSplitExercisedQuantity = @ExercisedQty,LastUpdatedBy = @UserId,
							LastUpdatedOn = SYSDATETIME(),ExercisableQuantity = 0
						WHERE ID = @GrantID													
				---------------------------------------------------------------------------------------------------------------
				END TRY
				BEGIN CATCH
					--SELECT	1 [RowNo],NULL [GrantId],NULL [SchemeId],NULL [EmployeeId],
					--	NULL [GrantOptionId],0 [VestId],NULL [ParentType],
					--	NULL [PUPFMV],NULL [PayoutAmt],NULL [PayoutDate],
					--	NULL [PerqValue],NULL [PerqTax],'Error while performing massupload.' [Remark],1 [IsError],	
					--	0 [IsPUPEnabled],0 [IsCorrectCombination],'Admin' [UserId],
					--	NULL [VestingDate],0 [VestedOptions],NULL [VestingType],NULL [IsPerfBased]

				END CATCH
				SET @Min = @Min + 1
			END
			
			BEGIN
				--script written to set seed value of shexercisedoptions table
				DECLARE @exReseedValue BIGINT
				DECLARE @shExReseedValue BIGINT
				SET @exReseedValue = (SELECT  ISNULL(MAX(ISNULL(ExercisedId,0)),0) AS EXERCISEDID FROM Exercised)
				SET @shExReseedValue = (SELECT ISNULL(MAX(ISNULL (ExerciseId,0)),0) AS EXERCISEDID FROM ShExercisedOptions)

				IF @exReseedValue>@shExReseedValue
					BEGIN
						--PRINT 'Exercised table max value for ressed -- ' + convert(varchar(20), @exReseedValue)
						DBCC CHECKIDENT (ShExercisedOptions, RESEED, @exReseedValue)			
					END   
				ELSE
					BEGIN
						--PRINT 'ShExercisedOptions table max value for ressed -- ' + convert(varchar(20), @shExReseedValue)
						DBCC CHECKIDENT (ShExercisedOptions, RESEED, @shExReseedValue)			
					END
			END
			
			SELECT	1 [RowNo],NULL [GrantId],NULL [SchemeId],NULL [EmployeeId],
					NULL [GrantOptionId],0 [VestId],NULL [ParentType],
					NULL [PUPFMV],NULL [PayoutAmt],NULL [PayoutDate],
					NULL [PerqValue],NULL [PerqTax],'Data Uploaded Successfully.' [Remark], @TrueCount [IsError],	
					0 [IsPUPEnabled],0 [IsCorrectCombination],'Admin' [UserId],
					NULL [VestingDate],0 [VestedOptions],NULL [VestingType],NULL [IsPerfBased]
		END
		ELSE
		BEGIN
			SELECT	1[Row_no],1 [SRNo],NULL [ID],NULL [SchemeId],NULL [EmployeeId],
					NULL [GrantOptionId],0 [GrantLegId],NULL [Parent],
					NULL [PUPFMV],NULL [PayoutAmt],NULL [PayoutDate],
					NULL [PerqValue],NULL [PerqTax],'Error while performing massupload.' [Remark],@ErrorCount [IsError],	
					0 [IsPUPEnabled],0 [IsCorrectCombination],'Admin' [UserId],
					NULL [VestingDate],0 [VestedOptions],NULL [VestingType],NULL [IsPerfBased]
		END
	END

	--SELECT * FROM #TEMP2 --[i.e. Exercised Table]
	--SELECT * FROM #TEMP3 --[i.e. ShTransactionDetails Table]
	--SELECT * FROM #TEMP4 --[i.e. GrantLeg Table]
	------------------------------------------------------------------
	IF EXISTS  
			(        
				SELECT *        
				FROM tempdb.dbo.sysobjects        
				WHERE ID In 
					(OBJECT_ID(N'tempdb..#TEMP'),
					 OBJECT_ID(N'tempdb..#TEMP2'),
					 OBJECT_ID(N'tempdb..#TEMP3'),
					  OBJECT_ID(N'tempdb..#TEMP4'))        
			)        
	 BEGIN        
		DROP TABLE #TEMP
		DROP TABLE #TEMP2			
		DROP TABLE #TEMP3		
		DROP TABLE #TEMP4		
	 END 
	------------------------------------------------------------------
	SET NOCOUNT OFF
END
GO
