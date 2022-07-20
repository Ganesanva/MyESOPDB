DROP PROCEDURE IF EXISTS [dbo].[SP_ALERT_FOR_DATA_DIFF]
GO

/****** Object:  StoredProcedure [dbo].[SP_ALERT_FOR_DATA_DIFF]    Script Date: 18-07-2022 16:37:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_ALERT_FOR_DATA_DIFF]	
AS     
BEGIN
	SET NOCOUNT ON;
	DECLARE
		@MAIL_TO AS VARCHAR(MAX) = 'it-dev@esopdirect.com',
		@MAIL_CC AS VARCHAR(MAX) = 'it-dev@esopdirect.com',
		@MAIL_SUBJECT VARCHAR(150) = 'DB Alert ED1.8 for difference in Data',
		@MAIL_BODY AS VARCHAR(MAX),
		@MAIL_QUERY AS VARCHAR(MAX),
		@ToDate AS DATE = CONVERT(DATE,GETDATE()), 
		@GrantOptionId AS VARCHAR(500), 
		@GrantLegId AS VARCHAR(100), 
		@Employeeid AS VARCHAR(100), 
		@EmployeeName AS VARCHAR(200),
		@NegativeValueinSP_REPORT_DATA AS VARCHAR(100) = 'NegativeValueinSP_REPORT_DATA',
		@DifInEqn  AS VARCHAR(100) = 'Difference in the Equation',
		@DifInCancellationAndSP_REPORT_DATA AS VARCHAR(250) = 'Difference between Cancellation Report and SP_REPORT_DATA',
		@DifInLapsedAndSP_REPORT_DATA AS VARCHAR(250) = 'Difference between Lapsed Report and SP_REPORT_DATA',
		@DifInExercisedAndSP_REPORT_DATA AS VARCHAR(250) = 'Difference between Exercised Report and SP_REPORT_DATA',
		@DifInPerfAndGL AS VARCHAR(250) = 'Difference between Performance and Grantleg table',
		@DifInCnAndGLTable  AS VARCHAR(250) = 'Difference between Cancelled and Grantleg table',
		@DifInExAndGLTable AS VARCHAR(250) = 'Difference between ShExercisedOptions and Grantleg table'
		
		
	IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB WHERE SYSTAB.NAME = 'ALL_MAIL_ITEMS')
	BEGIN
		CREATE TABLE ALL_MAIL_ITEMS
		(
			SR_NO INT IDENTITY(1,1),
			COMPANY_NAME VARCHAR(150),
			MAIL_FOR VARCHAR(500),
			MAIL_SUBJECT VARCHAR(MAX),
			MAIL_BODY VARCHAR(MAX)
		)
	END
	ELSE
	BEGIN
		TRUNCATE TABLE 	ALL_MAIL_ITEMS
	END
	
	
	CREATE TABLE #SP_REPORT_DATA 
    (	
		SR_NO INT IDENTITY(1,1),		
		OptionsGranted NUMERIC(18,0), OptionsVested NUMERIC(18,0), OptionsExercised NUMERIC(18,0), OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0), OptionsUnVested NUMERIC(18,0), PendingForApproval NUMERIC(18,0), 
		GrantOptionId NVARCHAR(100),GrantLegId NUMERIC(18,0), SchemeId NVARCHAR(150), GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150), EmployeeName NVARCHAR(250), SBU NVARCHAR(100) NULL, AccountNo NVARCHAR(100) NULL, PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100), GrantDate DATETIME, VestingType NVARCHAR(100), ExercisePrice numeric(10,2), VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), UnvestedCancelled NUMERIC(18,0), VestedCancelled NUMERIC(18,0),
		INSTRUMENT_NAME NVARCHAR(500), CurrencyName NVARCHAR(500), COST_CENTER NVARCHAR(500), Department NVARCHAR(500), Location NVARCHAR(500), EmployeeDesignation NVARCHAR(500), 
		Grade NVARCHAR(500), ResidentialStatus NVARCHAR(10), CountryName NVARCHAR(500), CurrencyAlias NVARCHAR(500), MIT_ID NVARCHAR(500), CancellationReason NVARCHAR(500)		
	)
	
	CREATE TABLE #GetCancellationDetails
    (	
		SR_NO INT IDENTITY(1,1),		
		Expr1 NUMERIC (38, 0), GrantOptionId VARCHAR (500), INSTRUMENT_NAME NVARCHAR(500), ExercisePrice NUMERIC(18,2), CurrencyName NVARCHAR(50), CurrencyAlias NVARCHAR(50), 
		GrantDate DATETIME, VestID NUMERIC(10,0), VestingDate DATETIME, FinalVestingDate DATETIME, FinalExpirayDate DATETIME, 
		ExpirayDate DATETIME, CancelledDate DATETIME, Expr2 VARCHAR (100), EmployeeID VARCHAR (20), EmployeeName VARCHAR (150), DateOfTermination DATETIME, 
		SchemeTitle VARCHAR (100), GrantRegistrationId VARCHAR (100), OptionRatioDivisor NUMERIC (18, 0), OptionRatioMultiplier NUMERIC (18, 0), 
		counter INT, Parent VARCHAR (10),
		GrantLegSerialNumber NUMERIC (18, 0), CancelledQuantity NUMERIC (18, 0), CancellationReason VARCHAR (400), Status VARCHAR (50), VestedUnVested VARCHAR (8), 
		OptionsCancelled DECIMAL (18, 0), Flag INT, Note VARCHAR (10)				
	)
	
	CREATE TABLE #PROC_CRExerciseReport
	(
		EmployeeID VARCHAR (20), INSTRUMENT_NAME NVARCHAR(500), CountryName VARCHAR (50), ExercisePrice NUMERIC (10, 2), CurrencyName NVARCHAR(200),
		SharesArised NUMERIC (38, 0), SARExerciseAmount NUMERIC (38, 2), ExercisedId NUMERIC (18, 0), EmployeeName VARCHAR (75), GrantRegistrationId VARCHAR (20), 
		grantoptionid VARCHAR (100), GrantDate DATETIME, ExercisedQuantity NUMERIC (38, 0), SharesAlloted NUMERIC (18, 0), ExercisedDate DATETIME, ExercisedPrice NUMERIC (10, 2),
		SchemeTitle VARCHAR (50), OptionRatioMultiplier NUMERIC (18, 0), schemeid VARCHAR (50), OptionRatioDivisor NUMERIC (18, 0), SharesIssuedDate DATETIME, 
		DateOfPayment DATETIME, Parent VARCHAR (8), VestingDate DATETIME, GrantLegId DECIMAL (10, 0), FBTValue NUMERIC (38, 2), Cash VARCHAR (50), SAR_PerqValue NUMERIC (38, 2), 
		FaceValue NUMERIC (18, 2),FACE_VALUE NUMERIC (18, 2),  PerqstValue VARCHAR (30), PerqstPayable NUMERIC (38, 2), FMVPrice VARCHAR (30),
		FBTdays INT, TravelDays INT, PaymentMode VARCHAR (20), PerqTaxRate DECIMAL (18, 2), ExerciseNo NUMERIC (18, 0), Exercise_Amount NUMERIC (37, 2), [Date of Payment] DATETIME,
		[Account number] VARCHAR (20), ConfStatus CHAR (1), dateofjoining DATETIME, dateoftermination DATETIME, department VARCHAR (200), employeedesignation VARCHAR (200), Entity VARCHAR (200),
		Grade VARCHAR (200), Insider CHAR (1), ReasonForTermination VARCHAR (50), SBU VARCHAR (200), residentialstatus VARCHAR (50), itcircle_wardnumber VARCHAR (15), depositoryname VARCHAR (200),
		depositoryparticipatoryname VARCHAR (200), confirmationdate DATETIME, nameasperdprecord VARCHAR (50), employeeaddress VARCHAR (500), employeeemail VARCHAR (100), employeephone VARCHAR (20), 
		pan_girnumber VARCHAR (50), dematactype VARCHAR (50), dpidnumber VARCHAR (50), clientidnumber VARCHAR (50), location VARCHAR (200), lotnumber VARCHAR(50), 
		CurrencyAlias NVARCHAR(50), MIT_ID INT, SettlmentPrice NUMERIC(18,6), StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6),ShareAriseApprValue NUMERIC(18,6), LWD DATETIME,  COST_CENTER NVARCHAR(200),
		[status] NVARCHAR(10), BROKER_DEP_TRUST_CMP_ID NVARCHAR(200), BROKER_DEP_TRUST_CMP_NAME NVARCHAR(200), BROKER_ELECT_ACC_NUM NVARCHAR(200),
		Country NVARCHAR(50), [State] NVARCHAR(300), EquivalentShares NUMERIC(38,0)
	)
	
	CREATE TABLE #SP_LAPSE_REPORT
	(
		SchemeTitle VARCHAR (50), GrantDate DATETIME, GrantRegistration VARCHAR (20), ExercisePrice NUMERIC (10, 2), EmployeeId VARCHAR (20),
		EmployeeName VARCHAR (75), GrantOpId VARCHAR (100), Status DATETIME, ExpiryDate DATETIME, OptionsLapsed NUMERIC (38, 6), 
		parent VARCHAR (3), CSFlag VARCHAR (1)
	)
			
	-- COLLECT DETAILS FROM SP_REPORT_DATA AND INSERT THE SAME IN EMPLOYEE_TEMP_DATA TABLE	
	INSERT INTO #SP_REPORT_DATA 
	(
		OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, 
		GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber,
		Entity, [Status], GrantDate, VestingType, ExercisePrice, VestingDate, ExpiryDate, Parent_Note, UnvestedCancelled, VestedCancelled,
		INSTRUMENT_NAME, CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus, CountryName, 
		CurrencyAlias, MIT_ID, CancellationReason
	)	
	EXEC SP_REPORT_DATA '1990-01-01', @ToDate
	
	PRINT '#SP_REPORT_DATA INSERTION COMPLETED'
	DECLARE @TOTOAL_ROWS AS INT, @ROW_NUMBER AS INT	

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'For negative figures in OptionsVested under #SP_REPORT_DATA'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'			
	IF EXISTS (SELECT OptionsVested FROM #SP_REPORT_DATA WHERE OptionsVested < 0)
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY SR_NO) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName INTO #TEMP_OptionsVested	
		FROM #SP_REPORT_DATA WHERE OptionsVested < 0
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_OptionsVested)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_OptionsVested WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
							
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @NegativeValueinSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)			
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		DROP TABLE #TEMP_OptionsVested		
	END
	
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'For negative figures in OptionsUnVested under #SP_REPORT_DATA'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'			
	IF EXISTS (SELECT OptionsUnVested FROM #SP_REPORT_DATA WHERE OptionsUnVested < 0)
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY SR_NO) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName INTO #TEMP_OptionsUnVested
		FROM #SP_REPORT_DATA WHERE OptionsUnVested < 0
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_OptionsUnVested)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_OptionsUnVested WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
							
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @NegativeValueinSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
			
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		DROP TABLE #TEMP_OptionsUnVested		
	END
		
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'For negative figures in OptionsCancelled under #SP_REPORT_DATA'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'			
	IF EXISTS (SELECT OptionsCancelled FROM #SP_REPORT_DATA WHERE OptionsCancelled < 0)
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY SR_NO) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName INTO #TEMP_OptionsCancelled
		FROM #SP_REPORT_DATA WHERE OptionsCancelled < 0
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_OptionsCancelled)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_OptionsCancelled WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
							
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @NegativeValueinSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
			
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		DROP TABLE #TEMP_OptionsCancelled		
	END

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'For negative figures in OptionsExercised under #SP_REPORT_DATA'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'			
	IF EXISTS (SELECT OptionsExercised FROM #SP_REPORT_DATA WHERE OptionsExercised < 0)
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY SR_NO) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName INTO #TEMP_OptionsExercised
		FROM #SP_REPORT_DATA WHERE OptionsExercised < 0
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_OptionsExercised)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_OptionsExercised WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
							
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @NegativeValueinSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
			
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		DROP TABLE #TEMP_OptionsExercised		
	END

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'When equation is not matching SP_REPORT_DATA (OptionsGranted <> (OptionsVested + OptionsExercised + OptionsCancelled + OptionsLapsed + OptionsUnVested + PendingForApproval)'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'		
	
	IF EXISTS(SELECT OptionsGranted FROM #SP_REPORT_DATA WHERE OptionsGranted <> ((CASE WHEN OptionsVested < 0 THEN 0 ELSE OptionsVested END)+ OptionsExercised + OptionsCancelled + OptionsLapsed + OptionsUnVested + PendingForApproval))
	BEGIN
		SELECT ROW_NUMBER() OVER (ORDER BY SR_NO) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName INTO #TEMP_Equation
		FROM #SP_REPORT_DATA WHERE OptionsGranted <> ((CASE WHEN OptionsVested < 0 THEN 0 ELSE OptionsVested END)+ OptionsExercised + OptionsCancelled + OptionsLapsed + OptionsUnVested + PendingForApproval)
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Equation)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Equation WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInEqn, @MAIL_SUBJECT, @MAIL_BODY)
			
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		DROP TABLE #TEMP_Equation		
	END
	

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'When equation is not matching GrantLeg (OptionsGranted <> (OptionsVested + OptionsExercised + OptionsCancelled + OptionsLapsed + OptionsUnVested + PendingForApproval)'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'		
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, ID, GrantOptionId, GrantLegId
	INTO #TEMP_GL
	FROM 
	(	
		SELECT GL.ID, GL.GrantOptionId, GL.GrantLegId FROM GrantLeg GL WHERE
		GL.VestingType = 'T' AND
		((CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN  CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN  GL.GrantedQuantity ELSE  GL.SplitQuantity END ELSE GL.BonusSplitQuantity END) -
		((CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN  CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN  GL.ExercisedQuantity ELSE  GL.SplitExercisedQuantity END ELSE GL.BonusSplitExercisedQuantity END)+ (CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN GL.CancelledQuantity ELSE  GL.SplitCancelledQuantity END ELSE GL.BonusSplitCancelledQuantity END) + GL.LapsedQuantity+GL.UnapprovedExerciseQuantity+GL.ExercisableQuantity))
		<> 0
	) AS FINAL_OUTPUT
	
	IF EXISTS (SELECT TEMP_SR_NO FROM #TEMP_GL)
	BEGIN
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_GL)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = ID
			FROM #TEMP_GL WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
				'This is to inform you that there is a difference in the data (found negative value) in GrantLeg for ' + 
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 							
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'')
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInEqn, @MAIL_SUBJECT, @MAIL_BODY)				
					
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
	END
	DROP TABLE #TEMP_GL
	
	
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'-----------------------------When data is not matching between Cancellation report and SP_Report_DATA------------------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'	
	IF (SELECT DISPLAYAS FROM BONUSSPLITPOLICY) = 'S' AND (select DisplaySplit from BonusSplitPolicy) = 'S'
	BEGIN
		INSERT INTO #GetCancellationDetails 
		(
			Expr1, GrantOptionId, INSTRUMENT_NAME, ExercisePrice, CurrencyName, CurrencyAlias, GrantDate, VestID, VestingDate, FinalVestingDate, FinalExpirayDate, 
			ExpirayDate, CancelledDate, Expr2, EmployeeID, EmployeeName, DateOfTermination, SchemeTitle, GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, 
			GrantLegSerialNumber, CancelledQuantity, CancellationReason, Status, VestedUnVested, OptionsCancelled, Flag, Note
		)	
		EXEC GetCancellationDetails '1990-01-01', @ToDate				
	END
	ELSE
	BEGIN
		INSERT INTO #GetCancellationDetails 
		(
			Expr1, GrantOptionId, INSTRUMENT_NAME, ExercisePrice, CurrencyName, CurrencyAlias, GrantDate, VestID, VestingDate, FinalVestingDate, FinalExpirayDate, 
			ExpirayDate, CancelledDate, Expr2, EmployeeID, EmployeeName, DateOfTermination, SchemeTitle, GrantRegistrationId, OptionRatioDivisor, OptionRatioMultiplier, 
			GrantLegSerialNumber, CancelledQuantity, CancellationReason, Status, VestedUnVested, OptionsCancelled, Flag, Note
		)	
		EXEC GetCancellationDetails '1990-01-01', @ToDate
	END
	PRINT '#GetCancellationDetails INSERTION COMPLETED'
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName 
	INTO #TEMP_Cancelled
	FROM
	(
		SELECT GrantOptionId, GrantLegId, Employeeid, EmployeeName, SUM(Expr1) AS Expr1, SUM(OptionsCancelled) AS OptionsCancelled FROM 
		(
			SELECT RD.GrantOptionId, RD.GrantLegId, RD.Employeeid, RD.EmployeeName, SUM(CN.Expr1) AS Expr1,RD.OptionsCancelled
				FROM #GetCancellationDetails CN INNER JOIN #SP_REPORT_DATA RD ON 
				CN.GrantOptionID = RD.GrantOptionID AND
				CN.EmployeeID = RD.EmployeeID AND
				CONVERT(DATE, CN.FinalVestingDate) = CONVERT(DATE, RD.VestingDate) AND 
				CONVERT(DATE, CN.FinalExpirayDate) = CONVERT(DATE, RD.ExpiryDate) AND
				(SELECT GrantLegID FROM GrantLeg WHERE ID = CN.GrantLegSerialNumber) = RD.GrantLegID AND 
				(SELECT VestingType FROM GrantLeg WHERE ID = CN.GrantLegSerialNumber) = (CASE WHEN RD.VESTINGTYPE = 'PerFormance Based' THEN 'P' ELSE 'T' END) AND
				CN.NOTE = RD.PARENT_NOTE 
			WHERE CONVERT(INT, CN.Expr1) <> CONVERT(INT,RD.OptionsCancelled)
			AND CONVERT(INT, CN.Expr1) > 0  AND CONVERT(INT,RD.OptionsCancelled) > 0 
			GROUP BY RD.GrantOptionId, RD.GrantLegId, RD.Employeeid, RD.EmployeeName, RD.OptionsCancelled, CN.COUNTER
		) AS FINAL_OUTPUT
		GROUP BY GrantOptionId, GrantLegId, Employeeid, EmployeeName
	) AS OUT_PUT
	WHERE Expr1 <> OptionsCancelled
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_Cancelled)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Cancelled)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Cancelled WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInCancellationAndSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
					
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END
	DROP TABLE #TEMP_Cancelled
	
	
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'-----------------------------When data is not matching between Execised report and SP_Report_DATA------------------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'	
	 
	INSERT INTO #PROC_CRExerciseReport
	(
		EmployeeID, INSTRUMENT_NAME, CountryName, ExercisePrice, CurrencyName,
		SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, 
		grantoptionid, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice,
		SchemeTitle, OptionRatioMultiplier, schemeid, OptionRatioDivisor, SharesIssuedDate, 
		DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, 
		FaceValue,FACE_VALUE, PerqstValue, PerqstPayable, FMVPrice,
		FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, [Date of Payment],
		[Account number], ConfStatus, dateofjoining, dateoftermination, department, employeedesignation, Entity,
		Grade, Insider, ReasonForTermination, SBU, residentialstatus, itcircle_wardnumber, depositoryname,
		depositoryparticipatoryname, confirmationdate, nameasperdprecord, employeeaddress, employeeemail, employeephone, 
		pan_girnumber, dematactype, dpidnumber, clientidnumber, location, lotnumber, 
		CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue,ShareAriseApprValue ,LWD, COST_CENTER,
		[status], BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM,
		Country, [State], EquivalentShares
	)	
	EXEC PROC_CRExerciseReport '1990-01-01', @ToDate
		
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName 
	INTO #TEMP_Exercised
	FROM 
	(
		SELECT RD.GrantOptionId, RD.GrantLegId, RD.Employeeid, RD.EmployeeName, SUM(EX.ExercisedQuantity) AS Expr1, RD.OptionsExercised
			FROM #PROC_CRExerciseReport EX INNER JOIN #SP_REPORT_DATA RD ON 
			EX.GrantOptionID = RD.GrantOptionID AND
			EX.EmployeeID = RD.EmployeeID AND
			CONVERT(DATE, EX.VestingDate) = CONVERT(DATE, RD.VestingDate) AND 
			EX.GrantLegID  = RD.GrantLegID
		WHERE CONVERT(INT, EX.ExercisedQuantity) <> CONVERT(INT,RD.OptionsExercised)
		AND RD.OptionsExercised > 0
		AND RD.VestingType = (SELECT VestingType  FROM GrantLeg GL INNER JOIN Exercised INNER_EX ON GL.ID  = INNER_EX.GrantLegSerialNumber 
							AND EX.ExercisedId = INNER_EX.ExercisedId
							)
		GROUP BY RD.GrantOptionId, RD.GrantLegId, RD.Employeeid, RD.EmployeeName, RD.OptionsExercised
	) AS FINAL_OUTPUT 
	WHERE Expr1 <> OptionsExercised
	ORDER BY Expr1, OptionsExercised
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_Exercised)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Exercised)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Exercised WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
				'This is to inform you that there is a difference between Exercised report and SP_Report_DATA for ' + 
							'GrantOptionID:' + @GrantOptionId + 
							', GrantLegID:' + @GrantLegId + 
							', Employeeid:' + @Employeeid + 
							', EmployeeName:' + @EmployeeName 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInExercisedAndSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
				
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END
	DROP TABLE #TEMP_Exercised	

	
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'-----------------------------When data is not matching between Lapsed report and GrantLeg------------------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'	
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName
	INTO #TEMP_Lapse
	FROM 
	(
		SELECT 
			GL.GrantOptionId, GL.GrantLegId, (SELECT EM.EmployeeID FROM EmployeeMaster EM INNER JOIN GrantOptions GOP ON GOP.EmployeeId = EM.EmployeeID WHERE GOP.GrantOptionId = GL.GrantOptionId) AS EmployeeID, (SELECT EM.EmployeeName FROM EmployeeMaster EM INNER JOIN GrantOptions GOP ON GOP.EmployeeId = EM.EmployeeID WHERE GOP.GrantOptionId = GL.GrantOptionId) AS EmployeeName
		FROM 
			GrantLeg GL WHERE GL.ID NOT IN (SELECT  GrantLegSerialNumber FROM LapseTrans) AND GL.LapsedQuantity > 0
		UNION ALL
		
		SELECT 
			LT.GrantOptionID, LT.GrantLegID, LT.Employeeid, (SELECT EmployeeName FROM EmployeeMaster WHERE EmployeeID = LT.Employeeid) EmployeeName
		FROM 
			LapseTrans LT INNER JOIN GRANTLEG GL ON LT.GrantLegSerialNumber = GL.ID AND LT.LapsedQuantity <> GL.LapsedQuantity
	) AS FINAL_OUTPUT 
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_Lapse)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Lapse)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Lapse WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'-------, GrantOptionID:' + ISNULL(@GrantOptionId,'') + 
							'-------, GrantLegID:' + ISNULL(@GrantLegId,'') + 
							'-------, Employeeid:' + ISNULL(@Employeeid,'') + 
							'-------, EmployeeName:' + ISNULL(@EmployeeName,'') 
			----Amin Temporary blocked
			--INSERT INTO ALL_MAIL_ITEMS 
			--	(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			--VALUES
			--	((SELECT DB_NAME()), @DifInLapsedAndSP_REPORT_DATA, @MAIL_SUBJECT, @MAIL_BODY)
				
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END	
	DROP TABLE #TEMP_Lapse
	
		
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'-------------------When performance is not uploaded and still options are available in bucket of GrantLeg table----------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'	
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName
	INTO #TEMP_Performance
	FROM 
	(	
		SELECT GL.GrantOptionId,GrantLegId, EM.EmployeeID, EM.EmployeeName FROM GrantLeg GL 
		INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId 
		INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GOP.EmployeeId
		WHERE 
			VestingType = 'P' AND IsPerfBased = 'N' AND
			(CancelledQuantity > 0 OR SplitCancelledQuantity > 0 OR BonusSplitCancelledQuantity > 0 OR
			ExercisableQuantity > 0 OR LapsedQuantity > 0) AND
			CancellationDate IS NULL AND CancellationReason IS NULL
			
	) AS FINAL_OUTPUT 
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_Performance)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Performance)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Performance WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +				
							'GrantOptionID:' + @GrantOptionId + 
							', GrantLegID:' + @GrantLegId + 
							', Employeeid:' + @Employeeid + 
							', EmployeeName:' + @EmployeeName 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInPerfAndGL, @MAIL_SUBJECT, @MAIL_BODY)
				
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END	
	DROP TABLE #TEMP_Performance
	

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'-----------------------------------When data discrepancy between cancelled and GrantLeg table--------------------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'		
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName
	INTO #TEMP_Cn
	FROM 
	(
		SELECT * FROM
		(
			SELECT GL.GrantOptionId, GL.GrantLegId, EM.EmployeeID, EM.EmployeeName,
			CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN SUM(CN.CancelledQuantity) ELSE SUM(CN.SplitCancelledQuantity)	END ELSE SUM(CN.BonusSplitCancelledQuantity) END AS CN_CancelledQuantity,
			CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN MAX(GL.CancelledQuantity) ELSE MAX(GL.SplitCancelledQuantity)	END ELSE MAX(GL.BonusSplitCancelledQuantity) END AS GL_CancelledQuantity
			FROM GrantLeg GL INNER JOIN Cancelled CN ON CN.GrantLegSerialNumber = GL.ID
			INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId 
			INNER JOIN EmployeeMaster EM ON EM.EmployeeID = GOP.EmployeeId
			GROUP BY GL.ID, GL.GrantOptionId, GL.GrantLegId, EM.EmployeeID, EM.EmployeeName
		) AS OUT_PUT
		WHERE GL_CancelledQuantity <> CN_CancelledQuantity		
	) AS FINAL_OUTPUT 
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_Cn)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_Cn)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_Cn WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +				
							'GrantOptionID:' + @GrantOptionId + 
							', GrantLegID:' + @GrantLegId + 
							', Employeeid:' + @Employeeid + 
							', EmployeeName:' + @EmployeeName 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInCnAndGLTable, @MAIL_SUBJECT, @MAIL_BODY)
				
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END	
	DROP TABLE #TEMP_Cn
	

	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'
	------'---------------------------------When data discrepancy between ShExercisedOptions and GrantLeg table-----------------------'
	------'***************************************************************************************************************************'
	------'***************************************************************************************************************************'		
	SELECT ROW_NUMBER() OVER (ORDER BY GrantOptionId) AS TEMP_SR_NO, GrantOptionId, GrantLegId, Employeeid, EmployeeName
	INTO #TEMP_ShEx
	FROM 
	(		
		SELECT DISTINCT GL.GrantOptionId, GL.GrantLegId, SHEX.Employeeid , EM.EmployeeName
		FROM ShExercisedOptions SHEX 
		INNER JOIN GrantLeg GL ON SHEX.GrantLegSerialNumber = GL.ID AND GL.UnapprovedExerciseQuantity = 0
		INNER JOIN EmployeeMaster EM ON EM.EmployeeID = SHEX.Employeeid
		
	) AS FINAL_OUTPUT 
	
	IF EXISTS(SELECT TEMP_SR_NO FROM #TEMP_ShEx)
	BEGIN
		
		SET @TOTOAL_ROWS = (SELECT COUNT(TEMP_SR_NO) FROM #TEMP_ShEx)
		SET @ROW_NUMBER = 1
		
		WHILE @ROW_NUMBER <= @TOTOAL_ROWS
		BEGIN
			SELECT 
				@GrantOptionId = GrantOptionId,
				@GrantLegId = GrantLegId,
				@Employeeid = Employeeid,
				@EmployeeName = EmployeeName				
			FROM #TEMP_ShEx WHERE TEMP_SR_NO = @ROW_NUMBER
			
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +				
							'GrantOptionID:' + @GrantOptionId + 
							', GrantLegID:' + @GrantLegId + 
							', Employeeid:' + @Employeeid + 
							', EmployeeName:' + @EmployeeName 
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInExAndGLTable, @MAIL_SUBJECT, @MAIL_BODY)
				
			SET @ROW_NUMBER = @ROW_NUMBER + 1
		END
		
	END	
	DROP TABLE #TEMP_ShEx
		
	--SELECT * FROM ALL_MAIL_ITEMS
	SET @MAIL_QUERY = 'SELECT * FROM ' + DB_NAME() + '..ALL_MAIL_ITEMS';
	SET @MAIL_BODY = 'Difference in DB for ' + (SELECT DB_NAME())
	IF(SELECT COUNT(SR_NO) FROM	ALL_MAIL_ITEMS) > 0
	BEGIN
		SET @MAIL_SUBJECT = @MAIL_SUBJECT + '. CompanyName: ' + (Select DB_NAME()) + '<EOM>'
		EXEC msdb.dbo.sp_send_dbmail 
					@recipients = @MAIL_TO,
					@copy_recipients = @MAIL_CC,
					@body = 'Query to execute : SELECT * FROM ALL_MAIL_ITEMS',
					@subject = @MAIL_SUBJECT,
					@from_address = 'noreply@esopdirect.com';					
	END

	/* New code for checking employee seprated or not*/
	IF EXISTS(select * from EmployeeMaster where DateOfTermination is NULL and LWD is not NULL)
	BEGIN
					
			SET @MAIL_BODY = 
				'CompanyName:' + (SELECT DB_NAME()) +
							'This company has EmployeeMaster where DateOfTermination is NULL and LWD is not NULL.To fix issue run the comand update employeemaster set LWD=NULL where DateOfTermination is NULL and LWD is not NULL'
						
			
			INSERT INTO ALL_MAIL_ITEMS 
				(COMPANY_NAME, MAIL_FOR, MAIL_SUBJECT, MAIL_BODY)
			VALUES
				((SELECT DB_NAME()), @DifInEqn, @MAIL_SUBJECT, @MAIL_BODY)
						
			
	END
	DROP TABLE #GetCancellationDetails
	DROP TABLE #PROC_CRExerciseReport
	DROP TABLE #SP_LAPSE_REPORT
	DROP TABLE #SP_REPORT_DATA
	SET NOCOUNT OFF;
END
GO


