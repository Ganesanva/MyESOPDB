DROP PROCEDURE IF EXISTS [PROC_EMPLOYEE_OPTION_EXERCISED]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_OPTION_EXERCISED]    Script Date: 18-07-2022 12:53:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [PROC_EMPLOYEE_OPTION_EXERCISED] (@EmployeeId VARCHAR(50))
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @FACEVALUE AS NUMERIC (18,2)
	SET @EmployeeId=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT @ToDate = CONVERT(DATE,GETDATE())
	SELECT @FACEVALUE = FaceVaue FROM CompanyParameters
    
    IF (@ISLISTED = 'Y')	
		SET @ClosePrice = (SELECT SharePrices.ClosePrice FROM SharePrices WHERE (SharePrices.PriceDate = (SELECT Max(PriceDate) FROM SharePrices)))
	ELSE
		SET @ClosePrice = (SELECT FMV FROM FMVForUnlisted WHERE (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))) 
		
    -- Insert statements for procedure here
    
    CREATE TABLE #EMPLOYEE_TEMP_OPTION_EXERCISED
    (			
		EmployeeID NVARCHAR(50), CountryName NVARCHAR(300), ExercisePrice NUMERIC(18,2), Sharesarised NUMERIC(18,2), SARExerciseAmount NUMERIC(18,2), ExercisedId NVARCHAR(50), EmployeeName NVARCHAR(100), 	GrantRegistrationId NVARCHAR(100), GrantOptionId NVARCHAR(100), GrantDate DATETIME, 
		ExercisedQuantity NUMERIC(18,2), SharesAlloted NUMERIC(18,2), ExercisedDate DATETIME, ExercisedPrice NUMERIC(18,2), SchemeTitle NVARCHAR(100),OptionRatioMultiplier NUMERIC(18,2), SchemeId NVARCHAR(100), OptionRatioDivisor NUMERIC(18,2), 
		SharesIssuedDate DATETIME, DateOfPayment DATETIME, Parent NVARCHAR(10), VestingDate DATETIME, GrantLegId NVARCHAR(10), FBTValue NUMERIC(18,2), Cash NVARCHAR(10), SAR_PerqValue NVARCHAR(20), FaceValue NVARCHAR(20), FACE_VALUE NVARCHAR(10), PerqstValue NVARCHAR(20), PerqstPayable NVARCHAR(20), 
		FMVPrice NVARCHAR(20), FBTdays NVARCHAR(10), TravelDays NVARCHAR(10), PaymentMode NVARCHAR(30), PerqTaxRate NVARCHAR(20), ExerciseNo NVARCHAR(50), Exercise_Amount NVARCHAR(20), Date_of_Payment DATETIME, Account_number NVARCHAR(50), ConfStatus NVARCHAR(50), 
		DateOfJoining DATETIME, DateOfTermination DATETIME, Department NVARCHAR(300), EmployeeDesignation NVARCHAR(300), Entity NVARCHAR(300), Grade NVARCHAR(300), Insider NVARCHAR(300), ReasonForTermination NVARCHAR(300), SBU NVARCHAR(300), ResidentialStatus NVARCHAR(300),
		Itcircle_Wardnumber NVARCHAR(300), DepositoryName NVARCHAR(100), DepositoryParticipatoryname NVARCHAR(100), ConfirmationDate DATETIME, NameAsperDpRecord NVARCHAR(100), EmployeeAddress NVARCHAR(300), EmployeeEmail NVARCHAR(100), 
		EmployeePhone NVARCHAR(100), Pan_Girnumber NVARCHAR(15), DematACType NVARCHAR(50), DpIdNumber NVARCHAR(50), ClientIdNumber NVARCHAR(50), Location NVARCHAR(300), 
		OptionGranted NVARCHAR(100), MarketPrice NUMERIC(18,2), IsSARApplied NVARCHAR(10), lotnumber VARCHAR(50), INSTRUMENT_NAME NVARCHAR (50), CurrencyName NVARCHAR (20), CurrencyAlias VARCHAR (20), MIT_ID INT,
		SettlmentPrice NUMERIC(18,6), StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC (18,6), ShareAriseApprValue NUMERIC(18,6),
		LWD DATETIME,COST_CENTER NVARCHAR(50),	[status] NVARCHAR(50),	BROKER_DEP_TRUST_CMP_ID VARCHAR (500),	BROKER_DEP_TRUST_CMP_NAME NVARCHAR(50),	BROKER_ELECT_ACC_NUM NVARCHAR(50), Country NVARCHAR(50), State NVARCHAR(50), EquivalentShares INT,
		Taxitle NVARCHAR(100)

	)
	 CREATE TABLE #FINALDATA
    (			
		SR_NO VARCHAR (500),EmployeeID NVARCHAR(50), CountryName NVARCHAR(300), ExercisePrice NUMERIC(18,6), Sharesarised NUMERIC(18,2), SARExerciseAmount NUMERIC(18,2), ExercisedId NVARCHAR(50), EmployeeName NVARCHAR(100), 	GrantRegistrationId NVARCHAR(100), GrantOptionId NVARCHAR(100), GrantDate DATETIME, 
		ExercisedQuantity NUMERIC(18,6), SharesAlloted NUMERIC(18,2), ExercisedDate DATETIME, ExercisedPrice NUMERIC(18,2), SchemeTitle NVARCHAR(100),OptionRatioMultiplier NUMERIC(18,2), SchemeId NVARCHAR(100), OptionRatioDivisor NUMERIC(18,2), 
		SharesIssuedDate DATETIME,PendingForApproval varchar (100), DateOfPayment DATETIME, Parent NVARCHAR(10), VestingDate DATETIME, GrantLegId NVARCHAR(10), FBTValue NUMERIC(18,2), Cash NVARCHAR(10), SAR_PerqValue NVARCHAR(20), FaceValue NVARCHAR(20), FACE_VALUE NVARCHAR(10), PerqstValue NVARCHAR(20), PerqstPayable numeric (18,9), 
		FMVPrice NVARCHAR(20), FBTdays NVARCHAR(10), TravelDays NVARCHAR(10), PaymentMode NVARCHAR(30), PerqTaxRate NVARCHAR(20), ExerciseNo NVARCHAR(50), Exercise_Amount NVARCHAR(20), Date_of_Payment DATETIME, Account_number NVARCHAR(50), ConfStatus NVARCHAR(50), 
		DateOfJoining DATETIME, DateOfTermination DATETIME, Department NVARCHAR(300), EmployeeDesignation NVARCHAR(300), Entity NVARCHAR(300), Grade NVARCHAR(300), Insider NVARCHAR(300), ReasonForTermination NVARCHAR(300), SBU NVARCHAR(300), ResidentialStatus NVARCHAR(300),
		Itcircle_Wardnumber NVARCHAR(300), DepositoryName NVARCHAR(100), DepositoryParticipatoryname NVARCHAR(100), ConfirmationDate DATETIME, NameAsperDpRecord NVARCHAR(100), EmployeeAddress NVARCHAR(300), EmployeeEmail NVARCHAR(100), 
		EmployeePhone NVARCHAR(100), Pan_Girnumber NVARCHAR(15), DematACType NVARCHAR(50), DpIdNumber NVARCHAR(50), ClientIdNumber NVARCHAR(50), Location NVARCHAR(300), 
		OptionGranted NVARCHAR(100), MarketPrice NUMERIC(18,2), IsSARApplied NVARCHAR(10), lotnumber VARCHAR(50), INSTRUMENT_NAME NVARCHAR (50), CurrencyName NVARCHAR (20), CurrencyAlias VARCHAR (20), MIT_ID INT,
		SettlmentPrice NUMERIC(18,6), StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC (18,6), ShareAriseApprValue NUMERIC(18,6),
		LWD DATETIME,COST_CENTER NVARCHAR(50),	[status] NVARCHAR(50),	BROKER_DEP_TRUST_CMP_ID VARCHAR (500),	BROKER_DEP_TRUST_CMP_NAME NVARCHAR(50),	BROKER_ELECT_ACC_NUM NVARCHAR(50), Country NVARCHAR(50), State NVARCHAR(50), EquivalentShares INT,
		Taxtitle NVARCHAR(100) NULL,BasisofTaxation NVARCHAR(50) NULL

	)

	CREATE table #TEMP_EXERCISE_TAX_RATE
	(
	Tax_Title NVARCHAR (500),BASISOFTAXATION NVARCHAR(500),EXERCISE_NO NVARCHAR (500)

	)
	
	INSERT INTO #EMPLOYEE_TEMP_OPTION_EXERCISED 
	(
		EmployeeID, INSTRUMENT_NAME, CountryName, ExercisePrice, CurrencyName, Sharesarised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, 
		ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, SchemeId, OptionRatioDivisor, 
		SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE, PerqstValue, PerqstPayable, 
		FMVPrice, FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, Account_number, ConfStatus, 
		DateOfJoining , DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU, ResidentialStatus,
		Itcircle_Wardnumber, DepositoryName, DepositoryParticipatoryname, ConfirmationDate, NameAsperDpRecord, EmployeeAddress, EmployeeEmail, 
		EmployeePhone, Pan_Girnumber, DematACType, DpIdNumber, ClientIdNumber, Location, lotnumber, CurrencyAlias, MIT_ID,
		SettlmentPrice, StockApprValue, CashPayoutValue, ShareAriseApprValue, LWD,COST_CENTER,[status],	BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, [State],EquivalentShares

	)
	EXECUTE PROC_Employee_CRExerciseReport '1900-01-01', @ToDate, @EmployeeId
	--EXECUTE PROC_CRExerciseReport '1900-01-01', '2018-02-22', 'ED101'
	
	UPDATE TD SET IsSARApplied = GR.Apply_SAR FROM #EMPLOYEE_TEMP_OPTION_EXERCISED AS TD 
	INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = TD.GrantRegistrationId
	
	UPDATE TD SET MarketPrice = @ClosePrice FROM #EMPLOYEE_TEMP_OPTION_EXERCISED AS TD 
	
	Insert INTO #FINALDATA  (SR_NO, EmployeeID, SchemeId, GrantDate, GrantOptionId,  OptionGranted, ExercisedPrice, ExercisedDate, ExercisedQuantity, SharesAlloted, SharesIssuedDate,  PendingForApproval, 
			Exercise_Amount, FMVPrice, PerqstValue, PerqstPayable, ExercisedId, MarketPrice, PaymentMode, FBTValue, IsSARApplied, OptionRatioMultiplier, OptionRatioDivisor, CurrencyAlias, ExerciseNo, INSTRUMENT_NAME, MIT_ID,
			SettlmentPrice, StockApprValue, CashPayoutValue, EquivalentShares, ShareAriseApprValue
			, taxtitle)
	
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY #EMPLOYEE_TEMP_OPTION_EXERCISED.EmployeeID ASC) AS SR_NO, #EMPLOYEE_TEMP_OPTION_EXERCISED.EmployeeID, SchemeId, GrantDate, GrantOptionId, 0 OptionGranted, ExercisedPrice, ExercisedDate, ExercisedQuantity, SharesAlloted, SharesIssuedDate, '0' AS PendingForApproval, 
			Exercise_Amount, FMVPrice, PerqstValue, PerqstPayable, ExercisedId, MarketPrice, PaymentMode, FBTValue, IsSARApplied, OptionRatioMultiplier, OptionRatioDivisor, CurrencyAlias, ExerciseNo, INSTRUMENT_NAME, MIT_ID,
			SettlmentPrice, StockApprValue, CashPayoutValue, EquivalentShares, ShareAriseApprValue
			,'NULL' as taxtitle
		FROM 
			#EMPLOYEE_TEMP_OPTION_EXERCISED
		
		UNION ALL

		SELECT 
			DISTINCT ROW_NUMBER() OVER(ORDER BY SHEOP.EmployeeID ASC) AS SR_NO, SHEOP.EmployeeID, SC.SchemeTitle AS SchemeId, GR.GrantDate, GOP.GrantOptionId, 0 AS OptionGranted, SHEOP.ExercisePrice, SHEOP.ExerciseDate, '0' AS ExercisedQuantity, '0' AS SharesAlloted, 
			SHEOP.SharesIssuedDate AS SharesIssuedDate, 
			CONVERT(VARCHAR,(SHEOP.ExercisedQuantity)) AS PendingForApproval, 
			CONVERT(VARCHAR,(SHEOP.ExercisePrice * Sum(SHEOP.ExercisedQuantity))) AS Exercise_Amount, 			
			CONVERT(NUMERIC(18,2), ISNULL(CASE UPPER(SHEOP.CALCULATE_TAX) WHEN 'RDOACTUALTAX' THEN SUM(SHEOP.fmvprice) WHEN 'rdoTentativeTax' THEN SUM(ISNULL(SHEOP.TentativeFMVPrice, 0)) END,0)) AS FMVPrice,
			CONVERT(NUMERIC(18,2), ISNULL(CASE UPPER(SHEOP.CALCULATE_TAX) WHEN 'RDOACTUALTAX' THEN SUM(SHEOP.perqstvalue) WHEN 'rdoTentativeTax' THEN SUM(ISNULL(SHEOP.TentativePerqstValue, 0)) END,0)) AS PerqstValue,
			CONVERT(NUMERIC(18,2), ISNULL(CASE UPPER(SHEOP.CALCULATE_TAX) WHEN 'RDOACTUALTAX' THEN SUM(SHEOP.PerqstPayable) WHEN 'rdoTentativeTax' THEN SUM(ISNULL(SHEOP.TentativePerqstPayable, 0)) END,0)) AS PerqstPayable,			
			CONVERT(VARCHAR,SHEOP.ExerciseId), CONVERT(VARCHAR,@ClosePrice) AS MarketPrice, 
			CASE SHEOP.PaymentMode
			WHEN 'A' THEN 'Sell-all' WHEN 'P' THEN 'Sell To Cover' WHEN 'D' THEN 'DD' WHEN 'G' THEN 'GENERAL' WHEN 'N' THEN 'ONLINE' WHEN 'Q' THEN 'CHEQUE'
			WHEN 'W' THEN 'Wire Transfer' WHEN 'R' THEN 'RTGS' WHEN 'F' THEN 'Funding' WHEN 'I' THEN 'Direct Debit' WHEN 'X' THEN 'Not Applicable'
			END
			AS PaymentMode, 
			CONVERT(VARCHAR,FBTValue) AS FBTValue, MAX(GR.Apply_SAR) AS IsSARApplied, SC.OptionRatioMultiplier, SC.OptionRatioDivisor, CM.CurrencyAlias, SHEOP.ExerciseNo,
			CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
			MIT.MIT_ID,
			(CASE WHEN (UPPER(SHEOP.CALCULATE_TAX) = 'RDOTENTATIVETAX') THEN ISNULL(SHEOP.TentativeSettlmentPrice, 0) ELSE (SHEOP.SettlmentPrice) END) AS ShSettlmentPrice,
			(CASE WHEN (UPPER(SHEOP.CALCULATE_TAX) = 'RDOTENTATIVETAX') THEN ISNULL(SHEOP.TentativeStockApprValue, 0) ELSE (SHEOP.StockApprValue) END) AS ShStockApprValue,
			(CASE WHEN (UPPER(SHEOP.CALCULATE_TAX) = 'RDOTENTATIVETAX') THEN ISNULL(SHEOP.TentativeCashPayoutValue,0) ELSE (SHEOP.CashPayoutValue) END) AS ShCashPayoutValue,
			CONVERT(INT,(SHEOP.BonusSplitExercisedQuantity * SC.OptionRatioMultiplier)/SC.OptionRatioDivisor) AS EquivalentShares,
			(CASE WHEN (UPPER(SHEOP.CALCULATE_TAX) = 'RDOTENTATIVETAX') THEN ISNULL(SHEOP.TentShareAriseApprValue, 0) ELSE (SHEOP.ShareAriseApprValue) END) AS ShShareAriseApprValue
			,'NULL' as taxtitle
			--,CASE WHEN ETD.Tax_Title = 'NA'  then  ETD.BASISOFTAXATION  else   ETD.Tax_Title END  AS Taxtitle
		
		FROM 
			GrantOptions AS GOP
			INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId = GR.GrantRegistrationId
			INNER JOIN Scheme AS SC ON GR.SchemeId = SC.SchemeId AND SC.IsPUPEnabled <>1
			INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
			INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID = CIM.MIT_ID
			INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID = CM.CurrencyID
			INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId = GL.GrantOptionId
			LEFT JOIN ShExercisedOptions AS SHEOP ON GL.id = SHEOP.GrantLegSerialNumber
			
		WHERE 
			GOP.EmployeeID = @EmployeeId AND SHEOP.[Action] = 'A'
		GROUP BY 
			SC.SchemeTitle, GR.GrantDate, GOP.GrantOptionId, GL.GrantedOptions, SHEOP.ExercisePrice, SHEOP.ExerciseDate, SHEOP.ExercisedQuantity, 
			SHEOP.SharesIssuedDate, SHEOP.ExercisedQuantity, SC.OptionRatioMultiplier, SC.OptionRatioDivisor, SHEOP.FMVPrice, SHEOP.PerqstValue, 
			SHEOP.PerqstPayable, SHEOP.ExerciseId, SHEOP.PaymentMode, FBTValue, SHEOP.EmployeeID, CM.CurrencyAlias, SHEOP.ExerciseNo,
			MIT.MIT_ID, MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,SC.CALCULATE_TAX,SHEOP.SettlmentPrice, SHEOP.TentativeSettlmentPrice,
			SHEOP.StockApprValue, SHEOP.TentativeStockApprValue, SHEOP.CashPayoutValue, SHEOP.TentativeCashPayoutValue, SHEOP.BonusSplitExercisedQuantity,
			SHEOP.ShareAriseApprValue, SHEOP.TentShareAriseApprValue,SHEOP.CALCULATE_TAX
			--, ETD.EXERCISE_NO 
			) 
		ORDER BY
			SchemeId, GrantOptionId, GrantDate, ExercisedDate ASC  
	
	-- Query is return for calcualte sum of grant option for perticular grant option id
	SELECT DISTINCT GrantOptionId INTO #GRANT_OPTION_ID_TEMP FROM #FINALDATA  
	
	SELECT ROW_NUMBER() OVER(ORDER BY GrantOptionId ASC) AS SR_NO, GrantOptionId INTO #GRANT_OPTION_ID FROM #GRANT_OPTION_ID_TEMP 
	
	SELECT * INTO #CONSOLIDATED_VALUES FROM
	(
		SELECT 
			SR_NO, SUM(GL.GrantedOptions)  AS OptionGranted , GL.SchemeId, GL.GrantRegistrationId, GL.GrantOptionId
		FROM 
			GrantLeg GL INNER JOIN #GRANT_OPTION_ID ON #GRANT_OPTION_ID.GrantOptionId = GL.GrantOptionId
		GROUP BY 
			GL.SchemeId, GL.GrantRegistrationId, GL.GrantOptionId, SR_NO
	) 
	AS CONSOLIDATED_VALUES
	
	DECLARE @TOTAL_GRANT_OPTION_ID AS INT
	DECLARE @TOTAL_GRANT_OPTION_ID_Backup AS INT
	SET @TOTAL_GRANT_OPTION_ID = (SELECT COUNT(1) FROM #GRANT_OPTION_ID)
	SET @TOTAL_GRANT_OPTION_ID_Backup = @TOTAL_GRANT_OPTION_ID
	
	---For Updating SR_NO
	WHILE (@TOTAL_GRANT_OPTION_ID > 0)
	BEGIN
		
		UPDATE #FINALDATA SET SR_NO = @TOTAL_GRANT_OPTION_ID FROM #CONSOLIDATED_VALUES INNER JOIN #FINALDATA
		ON #FINALDATA.GrantOptionId = #CONSOLIDATED_VALUES.GrantOptionId AND #FINALDATA.SchemeId = #CONSOLIDATED_VALUES.SchemeId WHERE
		#CONSOLIDATED_VALUES.SR_NO = @TOTAL_GRANT_OPTION_ID
		
		SET @TOTAL_GRANT_OPTION_ID = @TOTAL_GRANT_OPTION_ID - 1;
	END
	
	
	SET @TOTAL_GRANT_OPTION_ID = @TOTAL_GRANT_OPTION_ID_Backup 
	--For Updating GrantedOptions
	WHILE (@TOTAL_GRANT_OPTION_ID > 0)
	BEGIN
		
		UPDATE #FINALDATA SET OptionGranted = 
		#CONSOLIDATED_VALUES.OptionGranted FROM #CONSOLIDATED_VALUES INNER JOIN #FINALDATA
		ON #FINALDATA.GrantOptionId = #CONSOLIDATED_VALUES.GrantOptionId AND #FINALDATA.SchemeId = #CONSOLIDATED_VALUES.SchemeId WHERE
		ExercisedId = (SELECT TOP 1 ExercisedId FROM #FINALDATA WHERE SR_NO = @TOTAL_GRANT_OPTION_ID)
		
		SET @TOTAL_GRANT_OPTION_ID = @TOTAL_GRANT_OPTION_ID - 1;
	END
	INSERT INTO #TEMP_EXERCISE_TAX_RATE ( Tax_Title,BASISOFTAXATION,EXERCISE_NO)	
	(SELECT Tax_Title,BASISOFTAXATION,EXERCISE_NO from EXERCISE_TAXRATE_DETAILS)


	
	UPDATE FD

	SET 
	FD.Taxtitle = TEAR.Tax_Title 
	,FD.BasisofTaxation = CASE WHEN  TEAR.Tax_Title = 'NA'  then  TEAR.BASISOFTAXATION  else 'NA' END  

	FROM #TEMP_EXERCISE_TAX_RATE AS TEAR INNER JOIN #FINALDATA AS FD on FD.ExerciseNo = TEAR.EXERCISE_NO

	SELECT SR_NO, EmployeeID, SchemeId, GrantDate, GrantOptionId,  OptionGranted, ExercisedPrice, ExercisedDate, ExercisedQuantity, SharesAlloted, SharesIssuedDate,  PendingForApproval, 
			Exercise_Amount, FMVPrice, PerqstValue, CASE WHEN PerqstPayable < 0 THEN 0 ELSE PerqstPayable END AS PerqstPayable, ExercisedId, MarketPrice, PaymentMode, FBTValue, IsSARApplied, OptionRatioMultiplier, OptionRatioDivisor, CurrencyAlias, ExerciseNo, INSTRUMENT_NAME, MIT_ID,
			SettlmentPrice, StockApprValue, CashPayoutValue, EquivalentShares, ShareAriseApprValue
			, taxtitle,BasisofTaxation FROM #FINALDATA

	

	SELECT SR_NO, EmployeeID, SchemeId, GrantDate, GrantOptionId,  OptionGranted, ExercisedPrice, ExercisedDate, ExercisedQuantity, SharesAlloted, SharesIssuedDate,  PendingForApproval, 
			Exercise_Amount, FMVPrice, PerqstValue,CASE WHEN PerqstPayable < 0 THEN 0 ELSE PerqstPayable END AS PerqstPayable, ExercisedId, MarketPrice, PaymentMode, FBTValue, IsSARApplied, OptionRatioMultiplier, OptionRatioDivisor, CurrencyAlias, ExerciseNo, INSTRUMENT_NAME, MIT_ID,
			SettlmentPrice, StockApprValue, CashPayoutValue, EquivalentShares, ShareAriseApprValue
			, taxtitle,BasisofTaxation,@FACEVALUE AS FaceValue FROM #FINALDATA ORDER BY SchemeId, GrantOptionId, GrantDate ASC  
	
	DROP TABLE #EMPLOYEE_TEMP_OPTION_EXERCISED  
END
GO


