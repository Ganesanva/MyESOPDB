/****** Object:  StoredProcedure [dbo].[PROC_PRE_VESTING_OPT_MOVEMENT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PRE_VESTING_OPT_MOVEMENT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PRE_VESTING_OPT_MOVEMENT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PRE_VESTING_OPT_MOVEMENT] 
AS
BEGIN	

	SET NOCOUNT ON;

	DECLARE @CompanyID VARCHAR(20)
	
	SELECT @CompanyID = CompanyID FROM CompanyParameters
	
	BEGIN /* CREATE TEMP TABLE */
	
		CREATE TABLE #TEMP_BASE_PRE_VEST_OPT_MOMVEMENT
		(   
			SchemeId NVARCHAR(500), ExerciseId NUMERIC(18,0),  ExerciseNo NUMERIC(18,0), GrantLegSerialNumber NUMERIC(18,0), ExercisedQuantity NUMERIC(18,0), 
			ExercisedDate DATETIME, EmployeeID NVARCHAR(500), TentativeFMVPrice NUMERIC(18,6), TentativePerqstValue NUMERIC(18,6), TentativePerqstPayable NUMERIC(18,6), 
			FinalVestingDate DATETIME, PerVestingQuantity NUMERIC(18,0), MIT_ID INT, PaymentMode NVARCHAR(5), Perq_Tax_rate NUMERIC(18,6), ExercisePrice NUMERIC(18,6)
		)		
		
		CREATE TABLE #TEMP_PRE_VEST_OPT_MOMVEMENT
		(   
			SchemeId NVARCHAR(500), ExerciseId NUMERIC(18,0),  ExerciseNo NUMERIC(18,0), GrantLegSerialNumber NUMERIC(18,0), ExercisedQuantity NUMERIC(18,0), 
			ExercisedDate DATETIME, EmployeeID NVARCHAR(500), TentativeFMVPrice NUMERIC(18,6), TentativePerqstValue NUMERIC(18,6), TentativePerqstPayable NUMERIC(18,6), 
			FinalVestingDate DATETIME, PerVestingQuantity NUMERIC(18,0), MIT_ID INT, PerPayModeSelected NVARCHAR(5), PaymentMode NVARCHAR(5), 
			Is_Payment_Mode_Updated TINYINT, Perq_Tax_rate NUMERIC(18,6), ExercisePrice NUMERIC(18,6), IsActivatedAccount VARCHAR(5)
			,IS_Applicable_validation BIT,ISDemateBrokerUpdate	BIGINT,PAYMENT_MODE_ForUpdate	BIGINT,ISDemateBrokerValidate	BIGINT,PAYMENT_MODE_ForValidate	BIGINT
			,ISDemateBrokerUnvalidate	BIGINT,PAYMENT_MODE_ForUnValidate BIGINT
		)
		
		CREATE TABLE #TEMP_EMP_MOMENT_TRAKING
		(
			MOM_EMPLOYEE_ID NVARCHAR(400), MOM_MOVE_TO_ID BIGINT, MOM_MOVE_TO NVARCHAR(400), MOM_FROM_DATE_OF_MOVEMENT DATETIME
		)
		
	END
	
	INSERT INTO #TEMP_BASE_PRE_VEST_OPT_MOMVEMENT 
	( 
		SchemeId, ExerciseId,  ExerciseNo, GrantLegSerialNumber, ExercisedQuantity, ExercisedDate, EmployeeID, TentativeFMVPrice, 
		TentativePerqstValue, TentativePerqstPayable, FinalVestingDate, PerVestingQuantity, MIT_ID, PaymentMode, Perq_Tax_rate, ExercisePrice
	)
	SELECT 
		SC.SchemeId, SHO.ExerciseId,  SHO.ExerciseNo, SHO.GrantLegSerialNumber, SHO.ExercisedQuantity, SHO.ExerciseDate, SHO.EmployeeID, 
		SHO.TentativeFMVPrice, SHO.TentativePerqstValue, SHO.TentativePerqstPayable, GL.FinalVestingDate, GL.PerVestingQuantity, SHO.MIT_ID,
		SHO.PaymentMode, SHO.Perq_Tax_rate, SHO.ExercisePrice
	FROM 
		ShExercisedOptions AS SHO 
		INNER JOIN GrantLeg AS GL ON GL.ID = SHO.GrantLegSerialNumber
		INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
		INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = GL.SchemeId
	WHERE 
		(GL.PerVestingQuantity > 0) AND (SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEC.IS_APPROVE = 1) AND (SHO.IsAutoExercised = 2)
		AND (SHO.IsPrevestExercised = 1)
		
	IF ((SELECT COUNT(SchemeId) FROM #TEMP_BASE_PRE_VEST_OPT_MOMVEMENT) > 0)
	BEGIN
		
		/* GET AUTO EXERCISE DETAILS FOR RDOVESTING*/ 
		
		INSERT INTO #TEMP_PRE_VEST_OPT_MOMVEMENT
		(
			SchemeId, ExerciseId,  ExerciseNo, GrantLegSerialNumber, ExercisedQuantity, ExercisedDate, EmployeeID, TentativeFMVPrice, 
			TentativePerqstValue, TentativePerqstPayable, FinalVestingDate, PerVestingQuantity, MIT_ID, PaymentMode, Perq_Tax_rate, ExercisePrice,
			IsActivatedAccount
		)
		SELECT 
			TBPVOM.SchemeId, TBPVOM.ExerciseId, TBPVOM.ExerciseNo, TBPVOM.GrantLegSerialNumber, TBPVOM.ExercisedQuantity, TBPVOM.ExercisedDate, 
			TBPVOM.EmployeeID, TBPVOM.TentativeFMVPrice, TBPVOM.TentativePerqstValue, TBPVOM.TentativePerqstPayable, TBPVOM.FinalVestingDate, 
			TBPVOM.PerVestingQuantity, TBPVOM.MIT_ID, TBPVOM.PaymentMode, TBPVOM.Perq_Tax_rate, TBPVOM.ExercisePrice, CIM.IsActivatedAccount
		FROM
			#TEMP_BASE_PRE_VEST_OPT_MOMVEMENT AS TBPVOM
			INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = TBPVOM.SchemeId
			INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = TBPVOM.MIT_ID
		WHERE 			
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDOVESTING') AND 
			(CONVERT(DATE,TBPVOM.FinalVestingDate) = CONVERT(DATE, GETDATE()))
			
		/* GET AUTO EXERCISE DETAILS FOR RDODAYS*/ 
		
		INSERT INTO #TEMP_PRE_VEST_OPT_MOMVEMENT
		(
			SchemeId, ExerciseId,  ExerciseNo, GrantLegSerialNumber, ExercisedQuantity, ExercisedDate, EmployeeID, TentativeFMVPrice, 
			TentativePerqstValue, TentativePerqstPayable, FinalVestingDate, PerVestingQuantity, MIT_ID, PaymentMode, Perq_Tax_rate, ExercisePrice,
			IsActivatedAccount
		)
		SELECT 
			TBPVOM.SchemeId, TBPVOM.ExerciseId, TBPVOM.ExerciseNo, TBPVOM.GrantLegSerialNumber, TBPVOM.ExercisedQuantity, TBPVOM.ExercisedDate, 
			TBPVOM.EmployeeID, TBPVOM.TentativeFMVPrice, TBPVOM.TentativePerqstValue, TBPVOM.TentativePerqstPayable, TBPVOM.FinalVestingDate, 
			TBPVOM.PerVestingQuantity, TBPVOM.MIT_ID, TBPVOM.PaymentMode, TBPVOM.Perq_Tax_rate, TBPVOM.ExercisePrice, CIM.IsActivatedAccount
		FROM
			#TEMP_BASE_PRE_VEST_OPT_MOMVEMENT AS TBPVOM
			INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = TBPVOM.SchemeId
			INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = TBPVOM.MIT_ID
		WHERE 			
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDODAYS') AND 
			(CONVERT(DATE,DATEADD(DAY, AEC.EXERCISE_AFTER_DAYS,TBPVOM.FinalVestingDate)) = CONVERT(DATE,GETDATE()))
		
		/* GET AUTO EXERCISE DETAILS FOR RDOMOVMENT*/ 
		
		INSERT INTO #TEMP_EMP_MOMENT_TRAKING 
		(
			MOM_EMPLOYEE_ID, MOM_MOVE_TO_ID, MOM_MOVE_TO, MOM_FROM_DATE_OF_MOVEMENT
		)
		SELECT 
			ATFTM.EmployeeId, CM.ID, ATFTM.[Moved To] AS Moved_To, ATFTM.[From Date of Movement] AS From_Date_of_Movement
		FROM 
			AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD AS ATFTM
			INNER JOIN
				(
					SELECT 
						EmployeeId, MAX([From Date of Movement]) AS [From Date of Movement]
					FROM 
						AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
					GROUP BY EmployeeId
				) ATFTM_1 
			ON ATFTM.EmployeeId = ATFTM_1.EmployeeId AND ATFTM.[From Date of Movement] = ATFTM_1.[From Date of Movement]
			INNER JOIN CountryMaster AS CM ON CM.CountryName = ATFTM.[Moved To]
		ORDER BY ATFTM.EmployeeId ASC
		
		INSERT INTO #TEMP_PRE_VEST_OPT_MOMVEMENT
		(
			SchemeId, ExerciseId,  ExerciseNo, GrantLegSerialNumber, ExercisedQuantity, ExercisedDate, EmployeeID, TentativeFMVPrice, 
			TentativePerqstValue, TentativePerqstPayable, FinalVestingDate, PerVestingQuantity, MIT_ID, PaymentMode, Perq_Tax_rate, ExercisePrice,
			IsActivatedAccount
		)
		SELECT 
			TBPVOM.SchemeId, TBPVOM.ExerciseId, TBPVOM.ExerciseNo, TBPVOM.GrantLegSerialNumber, TBPVOM.ExercisedQuantity, TBPVOM.ExercisedDate, 
			TBPVOM.EmployeeID, TBPVOM.TentativeFMVPrice, TBPVOM.TentativePerqstValue, TBPVOM.TentativePerqstPayable, TBPVOM.FinalVestingDate, 
			TBPVOM.PerVestingQuantity, TBPVOM.MIT_ID, TBPVOM.PaymentMode, TBPVOM.Perq_Tax_rate, TBPVOM.ExercisePrice,  CIM.IsActivatedAccount
		FROM
			#TEMP_BASE_PRE_VEST_OPT_MOMVEMENT AS TBPVOM
			INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = TBPVOM.SchemeId
			INNER JOIN #TEMP_EMP_MOMENT_TRAKING AS TEMT ON TEMT.MOM_EMPLOYEE_ID = TBPVOM.EmployeeId
			INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = TBPVOM.MIT_ID
		WHERE 			
			(AEC.IS_APPROVE = 1) AND (UPPER(AEC.EXERCISE_ON) = 'RDOMOVMENTDATE') 
			AND 
			(
				(
					CASE WHEN (MOM_MOVE_TO_ID NOT IN (SELECT * FROM dbo.FN_SPLIT_STRING(AEC.COUNTRY_ID,','))) THEN 
						CASE WHEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) >= CONVERT(DATE,TBPVOM.FinalVestingDate) THEN CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT)
							 WHEN CONVERT(DATE,TBPVOM.FinalVestingDate) >= CONVERT(DATE,TEMT.MOM_FROM_DATE_OF_MOVEMENT) THEN CONVERT(DATE,TBPVOM.FinalVestingDate) ELSE '' END
						END
				)
				= CONVERT(DATE, GETDATE()) 
			 )			
	END
	
	BEGIN /* ===== DEFAULT PAYMENT MODE ===== */	
	
		UPDATE TPVOM 
		SET TPVOM.IS_Applicable_validation =AEPC.IS_Applicable_validation,TPVOM.ISDemateBrokerUpdate=AEPC.ISDemateBrokerUpdate,
			TPVOM.PAYMENT_MODE_ForUpdate=AEPC.PAYMENT_MODE_ForUpdate,TPVOM.ISDemateBrokerValidate =AEPC.ISDemateBrokerValidate,
			TPVOM.PAYMENT_MODE_ForValidate=	AEPC.PAYMENT_MODE_ForValidate,TPVOM.ISDemateBrokerUnvalidate=AEPC.ISDemateBrokerUnvalidate,
			TPVOM.PAYMENT_MODE_ForUnValidate=AEPC.PAYMENT_MODE_ForUnValidate
		FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM
			INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = TPVOM.SchemeId
			INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
			INNER JOIN Scheme AS SC ON SC.SchemeId = TPVOM.SchemeId
		WHERE
			(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) 
			AND ISNULL(AEPC.IS_Applicable_validation,0) =1 AND (LEN(ISNULL(TPVOM.PaymentMode, '')) = 0) 

		/* PAYMENT MODE IF EMPLOYEE NOT SELECTED BY EMPLOYEE THEN SELECT PAYMENT MODE SET BY CR */
		IF EXISTS(SELECT 1 FROM AUTO_EXERCISE_PAYMENT_CONFIG WHERE IS_PAYMENT_MODE_SELECTED = 1 AND (UPPER(PAYMENT_MODE_NOT_SELECTED) =  'RDODEFAULTPAYMENTMODE'))
		BEGIN
			UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
			FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM
				INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = TPVOM.SchemeId
				INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
				INNER JOIN Scheme AS SC ON SC.SchemeId = AEC.SchemeId
				INNER JOIN PaymentMaster AS PM ON PM.Id = AEPC.DEFAULT_PAYMENT_MODE			
			WHERE
				(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.IS_PAYMENT_MODE_SELECTED = 1) AND
				(UPPER(PAYMENT_MODE_NOT_SELECTED) =  'RDODEFAULTPAYMENTMODE') AND (LEN(ISNULL(TPVOM.PaymentMode, '')) = 0) 
			
		END  
		
		/* Update payment mode on non updated demat/broker account */
		IF EXISTS(SELECT 1 FROM #TEMP_PRE_VEST_OPT_MOMVEMENT WHERE  IS_Applicable_validation = 1 and ISDemateBrokerUpdate = 1)
		BEGIN
			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerUpdate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForUpdate							
				WHERE
					TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerUpdate=1
					AND TPVOM.EmployeeID NOT IN (Select EmployeeID From  Employee_UserDematDetails Where IsActive=1)
			END
			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerUpdate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForUpdate							
				WHERE
					TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerUpdate=1
					AND TPVOM.EmployeeID NOT IN (Select Employee_id From Employee_UserBrokerDetails Where IS_ACTIVE=1)
			END
			/*
			UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
			FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM
				INNER JOIN AUTO_EXERCISE_PAYMENT_CONFIG AS AEPC ON AEPC.SCHEME_ID = TPVOM.SchemeId
				INNER JOIN AUTO_EXERCISE_CONFIG AS AEC ON AEC.SchemeId = AEPC.SCHEME_ID AND AEC.AEC_ID = AEPC.AEC_ID
				INNER JOIN Scheme AS SC ON SC.SchemeId = AEC.SchemeId
				INNER JOIN PaymentMaster AS PM ON PM.Id = AEPC.PAYMENT_MODE_ForUpdate
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = SC.MIT_ID			
			WHERE
				(SC.IS_AUTO_EXERCISE_ALLOWED = 1) AND (AEPC.ISDemateBrokerUpdate = 1) AND CIM.IS_ENABLED=1 AND
				(LEN(ISNULL(TPVOM.PaymentMode, '')) = 0)
			*/
		END 
		
		/* Update payment mode on updated demat/broker account but not validated */
		IF EXISTS(SELECT 1 FROM #TEMP_PRE_VEST_OPT_MOMVEMENT WHERE  IS_Applicable_validation = 1 and ISDemateBrokerUnvalidate = 1)
		BEGIN
			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerUnvalidate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForUnValidate							
				WHERE
					TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerUnvalidate=1
					AND TPVOM.EmployeeID IN (Select EmployeeID From  Employee_UserDematDetails Where IsActive=1 AND ISNULL(IsValidDematAcc,0) = 0)
			END
			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerUnvalidate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForUnValidate							
				WHERE
					TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerUnvalidate=1
					AND TPVOM.EmployeeID IN (Select Employee_id From Employee_UserBrokerDetails Where IS_ACTIVE=1 AND ISNULL(IsValidBrokerAcc,0) = 0)
			END			
		END    

		/* Update payment mode on updated demat/broker account and validated */
		IF EXISTS(SELECT 1 FROM #TEMP_PRE_VEST_OPT_MOMVEMENT WHERE  IS_Applicable_validation = 1 and ISDemateBrokerValidate = 1)
		BEGIN

			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerValidate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForValidate							
				WHERE
					TPVOM.IsActivatedAccount='D' And TPVOM.ISDemateBrokerValidate=1
					AND TPVOM.EmployeeID IN (Select EmployeeID From  Employee_UserDematDetails Where IsActive=1 AND ISNULL(IsValidDematAcc,0) = 1)
			END
			IF EXISTS(Select 1 from #TEMP_PRE_VEST_OPT_MOMVEMENT TPVOM 	WHERE TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerValidate=1)
			BEGIN
				UPDATE TPVOM 
				SET TPVOM.PaymentMode = PM.PaymentMode, TPVOM.PerPayModeSelected = 'CR', TPVOM.Is_Payment_Mode_Updated = 1
				FROM #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM			
					INNER JOIN PaymentMaster AS PM ON PM.Id = TPVOM.PAYMENT_MODE_ForValidate							
				WHERE
					TPVOM.IsActivatedAccount='B' And TPVOM.ISDemateBrokerValidate=1
					AND TPVOM.EmployeeID IN (Select Employee_id From Employee_UserBrokerDetails Where IS_ACTIVE=1 AND ISNULL(IsValidBrokerAcc,0) = 1)
			END
		END    
	END
	BEGIN TRY
		
		BEGIN TRANSACTION
		
		BEGIN /* ===== UPDATE PAYMENT MODE IN SH ===== */	
			
			UPDATE SHO SET
				SHO.PaymentMode =CASE WHEN ISNULL(TPVOM.PaymentMode,'')='Z' THEN NULL ELSE TPVOM.PaymentMode END, SHO.PerPayModeSelected = TPVOM.PerPayModeSelected
			FROM 
				ShExercisedOptions AS SHO
				INNER JOIN #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM ON TPVOM.ExerciseId = SHO.ExerciseId 
			WHERE 
				(LEN(ISNULL(TPVOM.PaymentMode, '')) <> 0) AND (TPVOM.Is_Payment_Mode_Updated = 1)	
			
		END
				
		BEGIN /* ===== ADD DATA TO AUDITDATA FOR AUTO PAYMENT MODE SELECTION ===== */
		
			INSERT INTO AuditData
			(
				ExerciseId, ExerciseNo, FMV, PaymentDateTime, ExerciseAmount, TaxRate, PerqVal, PerqTax, MarketPrice, PaymentMode, LoginHistoryId, CashlessChgsAmt
			)
			SELECT 
				ExerciseId, ExerciseId, TentativeFMVPrice, ExercisedDate + CAST(GETDATE() AS TIME), ExercisePrice * ExercisedQuantity, 
				Perq_Tax_rate, TentativePerqstValue, TentativePerqstPayable,
				(SELECT TOP 1 ClosePrice FROM SharePrices WHERE PriceDate = (SELECT MAX(PriceDate) FROM SharePrices)),
				PaymentMode, 0, (SELECT TOP 1 dbo.FN_GET_CASHLESSCHARGES(@CompanyID, ExercisedDate, MIT_ID, ExercisedQuantity))
			FROM 
				#TEMP_PRE_VEST_OPT_MOMVEMENT 
			WHERE 
				(LEN(ISNULL(PaymentMode, '')) <> 0) AND (Is_Payment_Mode_Updated = 1)
		END
					
		BEGIN /* ===== UPDATE GRANT LEG TABLE ===== */
			UPDATE GL SET 
				GL.PerVestingQuantity = 0,
				GL.UnapprovedExerciseQuantity = TPVOM.PerVestingQuantity
			FROM 
				Grantleg AS GL
			INNER JOIN #TEMP_PRE_VEST_OPT_MOMVEMENT AS TPVOM ON TPVOM.GrantLegSerialNumber = GL.ID			
		END	
										
		COMMIT TRANSACTION  		
		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION			
	END CATCH
	
	/* ================ FINAL OUTPUT ================== */
	
	SELECT
		SchemeId, ExerciseId, ExerciseNo, GrantLegSerialNumber, ExercisedQuantity, ExercisedDate, EmployeeID, TentativeFMVPrice, 
		TentativePerqstValue, TentativePerqstPayable, FinalVestingDate, PerVestingQuantity, MIT_ID , PerPayModeSelected, 
		PaymentMode, Is_Payment_Mode_Updated
	FROM 
		#TEMP_PRE_VEST_OPT_MOMVEMENT
		
	DROP TABLE #TEMP_BASE_PRE_VEST_OPT_MOMVEMENT
	DROP TABLE #TEMP_PRE_VEST_OPT_MOMVEMENT	
	DROP TABLE #TEMP_EMP_MOMENT_TRAKING
			
	SET NOCOUNT OFF;
END
GO
