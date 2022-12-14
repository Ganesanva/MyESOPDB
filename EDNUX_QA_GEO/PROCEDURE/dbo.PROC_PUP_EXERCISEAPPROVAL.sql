/****** Object:  StoredProcedure [dbo].[PROC_PUP_EXERCISEAPPROVAL]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PUP_EXERCISEAPPROVAL]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PUP_EXERCISEAPPROVAL]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_PUP_EXERCISEAPPROVAL]
(
	@PUPDATA PUPEXERCISEAPPROVALTYPE READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	/*VARIABLE DECLARATION*/
	DECLARE @MIN			SMALLINT,
			@MAX			SMALLINT,
			@GRANTID		INT,
			@V_STATUSCNT	SMALLINT = 0,
			@I_STATUSCNT	SMALLINT = 0,
			@ERROR_CNT		SMALLINT = 0,
			@V_IS_SUCCESS	BIT = 0,
			@I_IS_SUCCESS	BIT = 0
	            
	CREATE TABLE #TEMP
	(
		[TEMP_ID]			INT IDENTITY(1,1),		
		[GRANTLEGSRNO]		INT,
		[EXERCISENO]		INT,
		[EXERCISEDID]		INT,	
		[EMPLOYEEID]		NVARCHAR(100),
		[GRANTREGID]		NVARCHAR(100),
		[GRANTOPTIONID]		NVARCHAR(200),	
		[EXERCISEDQTY]		NUMERIC(18,0),
		[UNAPPROVEDQTY]		NUMERIC(18,0),
		[EXERCISABLEQTY]	NUMERIC(18,0),
		[EXERCISEPRICE]		NUMERIC(18,2),
		[VALIDATIONSTATUS]	NCHAR,
		[LOTNUMBER]			NVARCHAR(10),
		[FINALEXPIRYDATE]	DATE,
		[PAYOUTDATE]		DATE DEFAULT NULL,		
		[USERID]			NVARCHAR(100),
		[ISERROR]           BIT DEFAULT 0,
		[REASON]            NVARCHAR(1000) NULL,		
		[ISEXEDINSERT]		BIT	DEFAULT 0,		
		[ISGLUPDATE]		BIT DEFAULT 0,
		[ISSHDELETED]		BIT DEFAULT 0		
	)
	/*GET DATA FROM SHEXERCISED FOR CURD OPERATION */
	INSERT INTO #TEMP(GRANTLEGSRNO,EXERCISENO,EXERCISEDID,EMPLOYEEID,
				GRANTREGID,GRANTOPTIONID,EXERCISEDQTY,UNAPPROVEDQTY,
				EXERCISABLEQTY,	EXERCISEPRICE,VALIDATIONSTATUS,LOTNUMBER,
				FINALEXPIRYDATE,PAYOUTDATE, USERID,REASON)
	SELECT		P.[GRANTLEGSERIALNUMBER],P.[EXERCISE NO],P.[EXERCISE ID],P.[EMPLOYEE ID],
				P.[GRANT REGISTRATION ID],P.[GRANT OPTION ID],P.[PUP OPTIONS EXERCISED],GL.UnapprovedExerciseQuantity,
				GL.ExercisableQuantity,P.[EXERCISE PRICE],
				CASE WHEN P.[UPDATE PAYOUT]='VALID' THEN 'V' WHEN P.[UPDATE PAYOUT]='INVALID' THEN 'I' END,
				P.[LOTNUMBER],GL.FinalExpirayDate, P.[PayoutDate], P.[USERID],
				CASE WHEN P.[UPDATE PAYOUT]='VALID' THEN NULL 
					 WHEN P.[UPDATE PAYOUT]='INVALID' THEN P.[REASON] END
				
	FROM		@PUPDATA P
				INNER JOIN ShExercisedOptions SHE
					ON SHE.ExerciseId = P.[EXERCISE ID]
				INNER JOIN GrantLeg GL
					ON GL.ID = P.[GRANTLEGSERIALNUMBER]
				INNER JOIN EmployeeMaster EM
					ON EM.EmployeeID = P.[EMPLOYEE ID] AND EM.Deleted =0
	
	/*CREATE EXERCISED TABLE STRUCTURE USING SCHEME OF TABLES*/
	IF(OBJECT_ID('EXERCISED','U')) IS NOT NULL
	BEGIN
		SELECT * INTO #TEMP_EXERCISED FROM EXERCISED WHERE 1=2		
	END
	
	/*CREATE GRANTLEG TABLE STRUCTURE USING SCHEME OF TABLES*/
	IF(OBJECT_ID('GRANTLEG','U')) IS NOT NULL
	BEGIN
		SELECT * INTO #TEMP_GRANTLEG FROM GRANTLEG WHERE 1=2
	END
		
	
	/*READ VALIDATION STATUS = V DATA*/	
	SELECT @V_STATUSCNT = COUNT(TEMP_ID) FROM #TEMP WHERE VALIDATIONSTATUS='V'	
	/*READ VALIDATION STATUS= I DATA*/	
	SELECT @I_STATUSCNT = COUNT(TEMP_ID) FROM #TEMP WHERE VALIDATIONSTATUS='I'	
	
	IF(@V_STATUSCNT > 0)
	BEGIN
		
		BEGIN TRY
			/* INSERT RECORDS INTO #TEMP_EXERCISED */
			INSERT INTO #TEMP_EXERCISED 
			(
				ExercisedId,	GrantLegSerialNumber,	ExercisedQuantity,	SplitExercisedQuantity,	BonusSplitExercisedQuantity,	
				ExercisedDate,	ExercisedPrice,	BSEOriginalPrice,	LockedInTill,	SharesIssuedStatus,	SharesIssuedDate,	
				ExercisableQuantity,	ExerciseNo,	LotNumber,	DrawnOn,	ValidationStatus,	[Status],	PerqstValue,	PerqstPayable,	
				FMVPrice,	payrollcountry,	LastUpdatedBy,	LastUpdatedOn,	Cash,	FBTValue,	FBTPayable,	FBTPayBy,	FBTDays,	
				TravelDays,	FBTTravelInfoYN,	Perq_Tax_rate,	SharesArised,	FaceValue,	SARExerciseAmount,	StockApperciationAmt,	FMV_SAR,	
				PaymentMode,	CapitalGainTax,	isExerciseMailSent,	ExerciseSARid,	CGTformulaID,	PANStatus,	CGTRateLT,	CGTUpdatedDate,	
				IsPaymentDeposited,	PaymentDepositedDate,	IsExerciseAllotted, IsPaymentConfirmed,	PaymentConfirmedDate,	IsAllotmentGenerated,	AllotmentGenerateDate,	
				IsAllotmentGeneratedReversed,	 AllotmentGeneratedReversedDate,	GenerateAllotListUniqueId,	GenerateAllotListUniqueIdDate,	
				IsPayInSlipGenerated,	PayInSlipGeneratedDate,	PayInSlipGeneratedUniqueId,	IsTRCFormReceived,	TRCFormReceivedDate,	TRCFormReceivedUpdatedBy,	
				TRCFormReceivedUpdatedOn, 	IsForm10FReceived,	Form10FReceivedDate,	isFormGenerate,	TransID_BankRefNo 
			)
			SELECT	SHE.ExerciseId, SHE.GrantLegSerialNumber, SHE.ExercisedQuantity, SHE.SplitExercisedQuantity, SHE.BonusSplitExercisedQuantity,CONVERT(DATE,SHE.ExerciseDate),
					SHE.ExercisePrice, SHE.ExercisePrice, SHE.LockedInTill,'N' [SharesIssuedStatus],T.PAYOUTDATE,SHE.ExercisableQuantity,SHE.ExerciseNo,
					SHE.LotNumber,	NULL [DrawnOn], SHE.ValidationStatus, [Action],	SHE.PerqstValue,SHE.PerqstPayable, SHE.FMVPrice, NULL [PAYROLLCOUNTRY], SHE.LastUpdatedBy,	
					SHE.LastUpdatedOn, SHE.Cash, ISNULL(SHE.FBTValue,0), ISNULL(SHE.FBTPayable,0), SHE.FBTPayBy, SHE.FBTDays, SHE.TravelDays, SHE.FBTTravelInfoYN,  SHE.Perq_Tax_rate, SHE.SharesArised,
					SHE.FaceValue, SHE.SARExerciseAmount, SHE.StockApperciationAmt, SHE.FMV_SAR, SHE.PaymentMode, SHE.CapitalGainTax, SHE.isExerciseMailSent, 
					SHE.ExerciseSARid, SHE.CGTformulaID, SHE.PANStatus, SHE.CGTRateLT,	SHE.CGTUpdatedDate,	SHE.IsPaymentDeposited, SHE.PaymentDepositedDate, 
					0,0 [IsPaymentConfirmed], NULL [PaymentConfirmedDate],SHE.IsAllotmentGenerated,	SHE.AllotmentGenerateDate, SHE.IsAllotmentGeneratedReversed,	
					SHE.AllotmentGeneratedReversedDate,	SHE.GenerateAllotListUniqueId,	SHE.GenerateAllotListUniqueIdDate,SHE.IsPayInSlipGenerated,	
					SHE.PayInSlipGeneratedDate,	SHE.PayInSlipGeneratedUniqueId,	SHE.IsTRCFormReceived,	SHE.TRCFormReceivedDate, SHE.TRCFormReceivedUpdatedBy,
					SHE.TRCFormReceivedUpdatedOn,	SHE.IsForm10FReceived,	SHE.Form10FReceivedDate, SHE.isFormGenerate, NULL [TransID_BankRefNo]
			FROM	ShExercisedOptions SHE 
					RIGHT JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'V'
			
			/* UPDATE ISEXEDINSERT FLAG VALUE = 1 */
			UPDATE T SET ISEXEDINSERT = 1 
			FROM	ShExercisedOptions SHE 
					INNER JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER 
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'V'
		
			/* INSERT RECORDS INTO TEMP_GRANTLEG TABLE */	
			INSERT INTO #TEMP_GRANTLEG 
			(
				ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,GrantDistributedLegId,
				GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,
				AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,
				CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,
				ExercisedQuantity,SplitExercisedQuantity,BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,
				LapsedQuantity,IsPerfBased,SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,
				IsBonus,IsSplit
			)
			SELECT 
					GL.ID,GL.ApprovalId,GL.SchemeId,GL.GrantApprovalId,GL.GrantRegistrationId,GL.GrantDistributionId,GL.GrantOptionId,GL.VestingPeriodId,GL.GrantDistributedLegId,
					GL.GrantLegId,GL.[Counter],GL.VestingType,GL.VestingDate,GL.ExpirayDate,GL.GrantedOptions,GL.GrantedQuantity,GL.SplitQuantity,GL.BonusSplitQuantity,GL.Parent,
					GL.AcceleratedVestingDate,GL.AcceleratedExpirayDate,GL.SeperatingVestingDate,GL.SeperationCancellationDate,GL.FinalVestingDate,GL.FinalExpirayDate,
					GL.CancellationDate,GL.CancellationReason,GL.CancelledQuantity,GL.SplitCancelledQuantity,GL.BonusSplitCancelledQuantity,0[UnapprovedExerciseQuantity],
					GL.ExercisedQuantity+GL.UnapprovedExerciseQuantity,GL.SplitExercisedQuantity+GL.UnapprovedExerciseQuantity,GL.BonusSplitExercisedQuantity+GL.UnapprovedExerciseQuantity,
					GL.ExercisableQuantity,GL.UnvestedQuantity,GL.[Status],GL.ParentID,	GL.LapsedQuantity,GL.IsPerfBased,GL.SeparationPerformed,GL.ExpiryPerformed,GL.VestMailSent,
					GL.ExpiredMailSent,GL.LastUpdatedBy,GL.LastUpdatedOn,GL.IsOriginal,	GL.IsBonus,GL.IsSplit
			FROM	GrantLeg GL
					INNER JOIN #TEMP T
						ON T.GRANTLEGSRNO = GL.ID
			WHERE T.VALIDATIONSTATUS = 'V'
			
			/* UPDATE ISGLUPDATE FLAG VALUE = 1 INTO TEMP TABLE */
			UPDATE T SET ISGLUPDATE = 1, ISSHDELETED = 1 
			FROM	ShExercisedOptions SHE 
					INNER JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER 
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'V'
		
		END TRY
		BEGIN CATCH
			/* UPDATE ISGLUPDATE FLAG VALUE = 1 INTO TEMP TABLE */
			UPDATE T SET ISGLUPDATE = 0, ISSHDELETED = 0,ISEXEDINSERT=0,ISERROR = 1, REASON=ERROR_MESSAGE() 
			FROM	ShExercisedOptions SHE
					INNER JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER 
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'V'
		END CATCH
	END
	
	IF(@I_STATUSCNT > 0)
	BEGIN
		BEGIN TRY
			/* INSERT RECORDS INTO GRANTLEG COLUMNS */	
			INSERT INTO #TEMP_GRANTLEG 
			(
				ID,ApprovalId,SchemeId,GrantApprovalId,GrantRegistrationId,GrantDistributionId,GrantOptionId,VestingPeriodId,GrantDistributedLegId,
				GrantLegId,[Counter],VestingType,VestingDate,ExpirayDate,GrantedOptions,GrantedQuantity,SplitQuantity,BonusSplitQuantity,Parent,
				AcceleratedVestingDate,AcceleratedExpirayDate,SeperatingVestingDate,SeperationCancellationDate,FinalVestingDate,FinalExpirayDate,
				CancellationDate,CancellationReason,CancelledQuantity,SplitCancelledQuantity,BonusSplitCancelledQuantity,UnapprovedExerciseQuantity,
				ExercisedQuantity,SplitExercisedQuantity,BonusSplitExercisedQuantity,ExercisableQuantity,UnvestedQuantity,[Status],ParentID,
				LapsedQuantity,IsPerfBased,SeparationPerformed,ExpiryPerformed,VestMailSent,ExpiredMailSent,LastUpdatedBy,LastUpdatedOn,IsOriginal,
				IsBonus,IsSplit
			)
			SELECT 
					GL.ID,GL.ApprovalId,GL.SchemeId,GL.GrantApprovalId,GL.GrantRegistrationId,GL.GrantDistributionId,GL.GrantOptionId,GL.VestingPeriodId,GL.GrantDistributedLegId,
					GL.GrantLegId,GL.[Counter],GL.VestingType,GL.VestingDate,GL.ExpirayDate,GL.GrantedOptions,GL.GrantedQuantity,GL.SplitQuantity,GL.BonusSplitQuantity,GL.Parent,
					GL.AcceleratedVestingDate,GL.AcceleratedExpirayDate,GL.SeperatingVestingDate,GL.SeperationCancellationDate,GL.FinalVestingDate,GL.FinalExpirayDate,
					GL.CancellationDate,GL.CancellationReason,GL.CancelledQuantity,GL.SplitCancelledQuantity,GL.BonusSplitCancelledQuantity,0[UnapprovedExerciseQuantity],
					GL.ExercisedQuantity,GL.SplitExercisedQuantity,GL.BonusSplitExercisedQuantity,GL.ExercisableQuantity+GL.UnapprovedExerciseQuantity,GL.UnvestedQuantity,GL.[Status],
					GL.ParentID,	GL.LapsedQuantity,GL.IsPerfBased,GL.SeparationPerformed,GL.ExpiryPerformed,GL.VestMailSent,	GL.ExpiredMailSent,GL.LastUpdatedBy,GL.LastUpdatedOn,GL.IsOriginal,
					GL.IsBonus,GL.IsSplit
			FROM	GrantLeg GL
					INNER JOIN #TEMP T
						ON T.GRANTLEGSRNO = GL.ID
			WHERE T.VALIDATIONSTATUS = 'I'
			
			/* UPDATE ISGLUPDATE FLAG VALUE = 1 INTO TEMP TABLE */
			UPDATE T SET ISGLUPDATE = 1, ISSHDELETED = 1 
			FROM	ShExercisedOptions SHE 
					INNER JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER 
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'I'

		END TRY
		BEGIN CATCH			
			/* UPDATE ISGLUPDATE FLAG VALUE = 1 INTO TEMP TABLE */
			UPDATE T SET ISGLUPDATE = 0, ISSHDELETED = 0,ISEXEDINSERT=0,ISERROR = 1, REASON=ERROR_MESSAGE()
			FROM	ShExercisedOptions SHE
					INNER JOIN #TEMP T
						ON SHE.ExerciseId=T.ExercisedId
			WHERE	SHE.LotNumber=T.LOTNUMBER 
			AND		SHE.Cash='PUP' 
			AND		SHE.ValidationStatus = 'I'		
		END CATCH
	END
	
	SELECT @ERROR_CNT = COUNT(TEMP_ID) FROM #TEMP WHERE ISERROR = 1 AND REASON != NULL

	IF(@ERROR_CNT = 0)
	BEGIN
		BEGIN TRY
			
			/*VALID RECORDS OPERATION*/
			IF(@V_STATUSCNT > 0)
			BEGIN
				INSERT INTO Exercised 
				(
					ExercisedId,	GrantLegSerialNumber,	ExercisedQuantity,	SplitExercisedQuantity,	BonusSplitExercisedQuantity,	
					ExercisedDate,	ExercisedPrice,	BSEOriginalPrice,	LockedInTill,	SharesIssuedStatus,	SharesIssuedDate,	
					ExercisableQuantity,	ExerciseNo,	LotNumber,	DrawnOn,	ValidationStatus,	[Status],	PerqstValue,	PerqstPayable,	
					FMVPrice,	payrollcountry,	LastUpdatedBy,	LastUpdatedOn,	Cash,	FBTValue,	FBTPayable,	FBTPayBy,	FBTDays,	
					TravelDays,	FBTTravelInfoYN,	Perq_Tax_rate,	SharesArised,	FaceValue,	SARExerciseAmount,	StockApperciationAmt,	FMV_SAR,	
					PaymentMode,	CapitalGainTax,	isExerciseMailSent,	ExerciseSARid,	CGTformulaID,	PANStatus,	CGTRateLT,	CGTUpdatedDate,	
					IsPaymentDeposited,	PaymentDepositedDate,	IsExerciseAllotted, IsPaymentConfirmed,	PaymentConfirmedDate,	IsAllotmentGenerated,	AllotmentGenerateDate,	
					IsAllotmentGeneratedReversed,	 AllotmentGeneratedReversedDate,	GenerateAllotListUniqueId,	GenerateAllotListUniqueIdDate,	
					IsPayInSlipGenerated,	PayInSlipGeneratedDate,	PayInSlipGeneratedUniqueId,	IsTRCFormReceived,	TRCFormReceivedDate,	TRCFormReceivedUpdatedBy,	
					TRCFormReceivedUpdatedOn, 	IsForm10FReceived,	Form10FReceivedDate,	isFormGenerate,	TransID_BankRefNo 
				)
				SELECT 
					TEX.ExercisedId,	GrantLegSerialNumber,	ExercisedQuantity,	SplitExercisedQuantity,	BonusSplitExercisedQuantity,	
					CONVERT(DATE,ExercisedDate),	ExercisedPrice,	BSEOriginalPrice,	LockedInTill,	SharesIssuedStatus,	SharesIssuedDate,	
					ExercisableQuantity,	TEX.ExerciseNo,	TEX.LotNumber,	DrawnOn,	TEX.ValidationStatus,	[Status],	PerqstValue,	PerqstPayable,	
					FMVPrice,	payrollcountry,	LastUpdatedBy,	LastUpdatedOn,	Cash,	FBTValue,	FBTPayable,	FBTPayBy,	FBTDays,	
					TravelDays,	FBTTravelInfoYN,	Perq_Tax_rate,	SharesArised,	FaceValue,	SARExerciseAmount,	StockApperciationAmt,	FMV_SAR,	
					PaymentMode,	CapitalGainTax,	isExerciseMailSent,	ExerciseSARid,	CGTformulaID,	PANStatus,	CGTRateLT,	CGTUpdatedDate,	
					IsPaymentDeposited,	PaymentDepositedDate,	IsExerciseAllotted, IsPaymentConfirmed,	PaymentConfirmedDate,	IsAllotmentGenerated,	AllotmentGenerateDate,	
					IsAllotmentGeneratedReversed,	 AllotmentGeneratedReversedDate,	GenerateAllotListUniqueId,	GenerateAllotListUniqueIdDate,	
					IsPayInSlipGenerated,	PayInSlipGeneratedDate,	PayInSlipGeneratedUniqueId,	IsTRCFormReceived,	TRCFormReceivedDate,	TRCFormReceivedUpdatedBy,	
					TRCFormReceivedUpdatedOn, 	IsForm10FReceived,	Form10FReceivedDate,	isFormGenerate,	TransID_BankRefNo 
				FROM #TEMP_EXERCISED TEX
					INNER JOIN #TEMP T
						ON TEX.ExercisedId = T.EXERCISEDID 
				WHERE T.VALIDATIONSTATUS = 'V' AND T.ISEXEDINSERT = 1
				
				UPDATE GL SET 
					GL.ExercisedQuantity = TGL.ExercisedQuantity,
					GL.SplitExercisedQuantity = TGL.SplitExercisedQuantity,
					GL.BonusSplitExercisedQuantity = TGL.BonusSplitExercisedQuantity,
					GL.UnapprovedExerciseQuantity = TGL.UnapprovedExerciseQuantity,
					GL.LastUpdatedBy = 'ADMIN',
					GL.LastUpdatedOn = GETDATE()
				FROM GrantLeg GL
					 INNER JOIN #TEMP_GRANTLEG TGL
						ON TGL.ID = GL.ID
					 INNER JOIN #TEMP T
						ON TGL.ID = T.GRANTLEGSRNO
				WHERE T.ISGLUPDATE = 1 AND T.VALIDATIONSTATUS = 'V'
				
				DELETE  FROM ShExercisedOptions WHERE EXERCISEID IN (SELECT EXERCISEDID FROM #TEMP T WHERE T.VALIDATIONSTATUS='V' AND T.ISSHDELETED = 1)
				
				SET @V_IS_SUCCESS = 1
				
				/*AUDIT TABLE RECORDS MAINTAIN */
				INSERT INTO AUDIT_PUP_EXERCISEAPPROVE(EXERCISEID,GrantOptionId,GrantLegSerialNumber,SH_UNAPPROVED_EX_QTY,VALIDATIONSTATUS,PAYOUTDATE,REASON,LASTUPDATEDBY,LASTUPDATEDON)
				SELECT  #TEMP.EXERCISEDID,#TEMP.GRANTOPTIONID,#TEMP.GRANTLEGSRNO,#TEMP.UNAPPROVEDQTY,
						#TEMP.VALIDATIONSTATUS,#TEMP.PAYOUTDATE,#TEMP.REASON,#TEMP.USERID,GETDATE()
				FROM	#TEMP
				
			END
			
			
			/*INVALID RECORDS OPERATION*/
			IF(@I_STATUSCNT > 0)
			BEGIN

				UPDATE GL SET 
					GL.ExercisableQuantity = TGL.ExercisableQuantity,
					GL.UnapprovedExerciseQuantity = TGL.UnapprovedExerciseQuantity,
					GL.LastUpdatedBy = 'ADMIN',
					GL.LastUpdatedOn = GETDATE()
				FROM GrantLeg GL
					 INNER JOIN #TEMP_GRANTLEG TGL
						ON TGL.ID = GL.ID
					 INNER JOIN #TEMP T
						ON TGL.ID = T.GRANTLEGSRNO
				WHERE T.ISGLUPDATE = 1 AND T.VALIDATIONSTATUS = 'I'
				
				DELETE  FROM ShExercisedOptions WHERE EXERCISEID IN (SELECT EXERCISEDID FROM #TEMP T WHERE T.VALIDATIONSTATUS='I' AND T.ISSHDELETED = 1)
				
				SET @I_IS_SUCCESS = 1
				/*AUDIT TABLE RECORDS MAINTAIN */
				BEGIN TRY
				INSERT INTO AUDIT_PUP_EXERCISEAPPROVE(EXERCISEID,GrantOptionId,GrantLegSerialNumber,SH_UNAPPROVED_EX_QTY,VALIDATIONSTATUS,PAYOUTDATE,REASON,LASTUPDATEDBY,LASTUPDATEDON)
				SELECT  #TEMP.EXERCISEDID,#TEMP.GRANTOPTIONID,#TEMP.GRANTLEGSRNO,#TEMP.UNAPPROVEDQTY,
						#TEMP.VALIDATIONSTATUS,#TEMP.PAYOUTDATE,#TEMP.REASON,#TEMP.USERID,GETDATE()
				FROM	#TEMP
				END TRY
				BEGIN CATCH
				SELECT ERROR_MESSAGE(),ERROR_LINE()FROM AUDIT_PUP_EXERCISEAPPROVE 
			    END CATCH 
				
			END			
		END TRY
		BEGIN CATCH		    			 
			SET @V_IS_SUCCESS = 0
			SET @I_IS_SUCCESS = 0
		END CATCH
		
		IF(@I_IS_SUCCESS=1 OR @V_IS_SUCCESS=1 )
			BEGIN				
				SELECT 'DATA APPROVED SUCCESSFULLY'[MESSAGE], 0 [ISERROR]
				SELECT 
					TEMP_ID,	GRANTLEGSRNO,	EXERCISENO,	EXERCISEDID,	EMPLOYEEID,	GRANTREGID,	GRANTOPTIONID,	
					EXERCISEDQTY,	UNAPPROVEDQTY,	EXERCISABLEQTY,	EXERCISEPRICE,	VALIDATIONSTATUS,	LOTNUMBER,	
					FINALEXPIRYDATE,	PAYOUTDATE,	USERID,	ISERROR,	[REASON],	ISEXEDINSERT,	ISGLUPDATE,	ISSHDELETED
				FROM #TEMP
				SELECT  #TEMP.EXERCISEDID,#TEMP.GRANTOPTIONID,#TEMP.GRANTLEGSRNO,#TEMP.UNAPPROVEDQTY,
						#TEMP.VALIDATIONSTATUS,#TEMP.PAYOUTDATE,#TEMP.REASON,#TEMP.USERID,GETDATE()
				FROM	#TEMP
							  
			END	
		ELSE
			BEGIN
				SELECT 'UNABLE TO PERFORM APPROVE OPERATION'[MESSAGE], 1 [ISERROR]
				SELECT 
					TEMP_ID,	GRANTLEGSRNO,	EXERCISENO,	EXERCISEDID,	EMPLOYEEID,	GRANTREGID,	GRANTOPTIONID,	
					EXERCISEDQTY,	UNAPPROVEDQTY,	EXERCISABLEQTY,	EXERCISEPRICE,	VALIDATIONSTATUS,	LOTNUMBER,	
					FINALEXPIRYDATE,	PAYOUTDATE,	USERID,	ISERROR,	[REASON],	ISEXEDINSERT,	ISGLUPDATE,	ISSHDELETED
				FROM #TEMP
			END
		
		
	END 
END
GO
