/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_INSTRUMENT_DETAIL_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_INSTRUMENT_DETAIL_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_INSTRUMENT_DETAIL_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_INSTRUMENT_DETAIL_DATA] 

	@EmployeeId VARCHAR(50),
	@ControlMasterID INT,
	@ForMobile INT = null,
	@DisplayPram VARCHAR(10) = NULL, 
	@DateParm DATE = NULL
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @ORDER_BY AS VARCHAR(1000)
	Declare @CompanyID varchar(50)
	SELECT @CompanyID = DB_NAME()

	-- Added For OGA Conditional grant view changes
	DECLARE 
	@IS_EGRANTS_ENABLED AS CHAR(1),
    @IS_GRANTDETWITHOUTACCORREJ AS CHAR(1) = 0,
    @IS_GRANTDETONLYAFTERACC AS CHAR(1) = 0,
    @IS_GRANTDETIFACCORREJ AS CHAR(1) = 0,
    @IS_GRANTDETDISEXENOWIFNOTACC AS CHAR(1) = 0,
    @LetterAcceptanceStatus AS CHAR(1),
    @WHERE_OGA_CONDITION AS VARCHAR(MAX)
    
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Resolved Issue for Association EmployeeID 
	SET @EmployeeId=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)
    -- Insert statements for procedure here

    
    CREATE TABLE #EMPLOYEE_TEMP_DATA 
    (			
		OptionsGranted NUMERIC(18,0), OptionsVested NUMERIC(18,0), OptionsExercised NUMERIC(18,0), OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0), OptionsUnVested NUMERIC(18,0), PendingForApproval NUMERIC(18,0), 
		GrantOptionId NVARCHAR(100),GrantLegId NUMERIC(18,0), SchemeId NVARCHAR(150), GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150), EmployeeName NVARCHAR(250), SBU NVARCHAR(100) NULL, AccountNo NVARCHAR(100) NULL, PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100), GrantDate DATETIME, VestingType NVARCHAR(100), ExercisePrice numeric(10,2), VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), 
		VestingFrequency VARCHAR(50), -- Add column for Option vest Report
		LapseDate DATETIME,  -- Add column for Option Lapse Reprot
		CancelledDate DATETIME, CancelledReasion NVARCHAR(200), -- Add column for Option Cancelled Report
		-- Columns for What if I Resign and Option Value Report
		MarketPrice NUMERIC (18,2), UnvestedOptionsLiveFor NUMERIC(18,0), VestedOptionsLiveFor NUMERIC(18,0), IsVestingOfUnvestedOptions NVARCHAR(10), PeriodUnit NVARCHAR(10),
		AmountPayableOnExercise NUMERIC (18,2), LastDateToExercise DATETIME, UnvestedCancellationDate DATETIME,
		-- Columns Airtel
		ValueOfGrantedOptions NUMERIC(18,2), ValueOfVestedOptions NUMERIC(18,2), ValueOfUnvestedOptions NUMERIC(18,2),
		UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2), IsGlGenerated BIT, IsEGrantsEnabled BIT,
		INSTRUMENT_NAME NVARCHAR (100), CurrencyName NVARCHAR (100), COST_CENTER VARCHAR (50), Department VARCHAR (50),
		Location VARCHAR (100), EmployeeDesignation VARCHAR (100), Grade VARCHAR (50), ResidentialStatus VARCHAR (50), CountryName VARCHAR (100), CurrencyAlias VARCHAR (20),
		MIT_ID INT, LetterAcceptanceStatus NCHAR(1), CancellationReason NVARCHAR(500) 
		/* ,OptionRatioMultiplier NUMERIC(18,9) NULL ,OptionRatioDivisor NUMERIC(18,9) NULL */
	)
	
    IF (@DateParm IS NULL)
		BEGIN
			-- GET TODAY'S DATE	
			SELECT @ToDate = CONVERT(DATE,GETDATE())
		END
	ELSE
		BEGIN
			-- SELECT DATE FROM PICKER
			SELECT @ToDate = @DateParm
		END
	
	-- COLLECT DETAILS FROM SP_REPORT_DATA AND INSERT THE SAME IN EMPLOYEE_TEMP_DATA TABLE	
	INSERT INTO #EMPLOYEE_TEMP_DATA 
	(
		OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, 
		GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber,
		Entity, [Status], GrantDate, VestingType, ExercisePrice, VestingDate, ExpiryDate, Parent_Note, UnvestedCancelled, VestedCancelled,
		INSTRUMENT_NAME , CurrencyName , COST_CENTER , Department, Location , EmployeeDesignation , Grade, ResidentialStatus , CountryName, CurrencyAlias, MIT_ID, CancellationReason		
	)
	EXECUTE SP_REPORT_DATA '1900-01-01', @ToDate, @EmployeeId, @DisplayPram

	--- Update query added for RATIO MULTIPLIER/DIVISOR enhancement --
	/*
	UPDATE ETD 
	SET ETD.OptionRatioMultiplier = SH.OptionRatioMultiplier ,ETD.OptionRatioDivisor = SH.OptionRatioDivisor
	FROM #EMPLOYEE_TEMP_DATA AS ETD
	INNER JOIN Scheme AS SH ON ETD.SchemeId = SH.SchemeId AND sh.MIT_ID = ETD.MIT_ID
	*/
	/* SELECT * FROM #EMPLOYEE_TEMP_DATA */
	
	SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM CompanyMaster)
	
	IF (@IS_EGRANTS_ENABLED = 1)
		BEGIN		
			SELECT 
				@IS_GRANTDETONLYAFTERACC = IS_GRANTDETONLYAFTERACC, @IS_GRANTDETWITHOUTACCORREJ = IS_GRANTDETWITHOUTACCORREJ,
				@IS_GRANTDETIFACCORREJ = IS_GRANTDETIFACCORREJ, @IS_GRANTDETDISEXENOWIFNOTACC = IS_GRANTDETDISEXENOWIFNOTACC
			FROM OGACONDGRANTVIEWSETTINGS
			
			-- a.Show grant details only after acceptance
			IF (@IS_GRANTDETONLYAFTERACC = 1)
			BEGIN    
				SET @WHERE_OGA_CONDITION = ' WHERE GAM.LetterAcceptanceStatus =''A'' AND GAM.EmployeeID = '''+@EmployeeId+''' '     
			END
			-- b. Show grant details without acceptance/rejection 
			ELSE IF (@IS_GRANTDETWITHOUTACCORREJ = 1)
			BEGIN
				SET @WHERE_OGA_CONDITION =  ' WHERE GAM.EmployeeID = '''+@EmployeeId+''' '
			END
			--C.Show grant details if accepted/rejected 
			ELSE IF (@IS_GRANTDETIFACCORREJ = 1)
			BEGIN  
				SET @WHERE_OGA_CONDITION = ' WHERE GAM.LetterAcceptanceStatus =''A'' OR GAM.LetterAcceptanceStatus =''R'' AND GAM.EmployeeID = '''+@EmployeeId+''' '
			END    
			--D.Show Grant details but disable Exercise Now if grant is not accepted
			ELSE IF (@IS_GRANTDETDISEXENOWIFNOTACC = 1)
			BEGIN
				SET @WHERE_OGA_CONDITION =' WHERE (GAM.LetterAcceptanceStatus IS NULL OR GAM.LetterAcceptanceStatus = ''P'' OR GAM.LetterAcceptanceStatus = ''R'' OR GAM.LetterAcceptanceStatus = ''A'' OR GAM.LetterAcceptanceStatus = '''' ) AND GAM.EmployeeID = '''+@EmployeeId+''' '      
			END  					
		END
	ELSE
		BEGIN
			SET @WHERE_OGA_CONDITION = ''
		END
				  
	-- UPDATE DETAILS FOR OPTION VEST REPORT : VESTING FREQUENCY DETAIL TO TABLE	
	UPDATE TD SET VestingFrequency = SC.VestingFrequency FROM #EMPLOYEE_TEMP_DATA AS TD INNER JOIN SCHEME AS SC ON TD.SCHEMEID = SC.SCHEMEID 
	
	---- UPDATE DETAILS FOR OPTION LAPSE REPORT : LAPSE DATE	
	UPDATE TD SET LapseDate = LT.LapseDate FROM #EMPLOYEE_TEMP_DATA AS TD INNER JOIN dbo.LapseTrans AS LT ON TD.GrantOptionId = LT.GrantOptionID AND TD.GrantLegId = LT.GrantLegID
	
	SELECT 
		GL.CancellationDate, GL.CancellationReason, GL.GrantOptionId, GL.GrantLegId, CASE WHEN GL.VestingType = 'T' THEN 'Time Based' ELSE 'PerFormance Based' END VestingType
	INTO 
		#CancelledDataFromGrantLeg
	FROM 
		GrantLeg AS GL INNER JOIN GrantOptions GOP ON GOP.GrantOptionId = GL.GrantOptionId AND GOP.EmployeeId = @EmployeeId AND GL.CancellationDate IS NOT NULL	AND GL.CancellationDate <> ''
	
	---- UPDATE DETAILS FOR OPTION CANCELLATION REPORT - DATE AND REASON
	
	UPDATE TD SET CancelledDate = GL.CancellationDate, CancelledReasion = GL.CancellationReason 
	FROM 
		#EMPLOYEE_TEMP_DATA AS TD 
		INNER JOIN #CancelledDataFromGrantLeg AS GL ON GL.CancellationDate IS NOT NULL AND TD.GrantOptionId = GL.GrantOptionId AND TD.GrantLegId =  GL.GrantLegId AND GL.VestingType = TD.VestingType
		
	-- UPDATE DETAILS FOR OPTIONS VALUE REPORT AND WHAT IF I RESIGN
	
	IF (@ISLISTED = 'Y')	
		SET @ClosePrice = (SELECT SharePrices.ClosePrice FROM SharePrices WHERE (SharePrices.PriceDate = (SELECT Max(PriceDate) FROM SharePrices)))
	ELSE
		BEGIN
			IF EXISTS((SELECT FMV FROM FMVForUnlisted WHERE (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))))
				SET @ClosePrice = (SELECT FMV FROM FMVForUnlisted WHERE (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))) 
			ELSE
				SET @ClosePrice = (SELECT TOP 1 FMV FROM FMVFORUNLISTED ORDER BY FMV_TODATE DESC) 
		END

	
	SELECT * INTO #OptionValueReport FROM
	(
		SELECT TD.GrantOptionId, TD.GrantRegistrationId, TD.SchemeId,  TD.GrantLegId, LEFT(TD.VestingType,1) VestingType, TD.VestingDate AS FinalVestingDate, TD.ExpiryDate AS FinalExpirayDate, (CASE WHEN PBG.PerformanceBasedGrantID IS NULL THEN 'N' ELSE 'Y' END) IsPerfBased, (CASE UPPER(TD.Parent_Note) WHEN 'ORIGINAL' THEN 'N' WHEN '---' THEN 'N' WHEN 'BONUS' THEN 'B' ELSE 'S' END) Parent,
		@ClosePrice AS ClosePrice ,  (SSR.UnvestedOptionsLiveFor) AS UnvestedOptionsLiveFor, (SSR.VestedOptionsLiveFor) AS VestedOptionsLiveFor,
		(CONVERT(NUMERIC,  SSR.IsVestingOfUnvestedOptions)) AS IsVestingOfUnvestedOptions, (SSR.PeriodUnit) AS PeriodUnit		
		FROM #EMPLOYEE_TEMP_DATA AS TD		
		INNER JOIN SCHEMESEPERATIONRULE AS SSR ON TD.SchemeId = SSR.schemeid AND (SSR.SeperationRuleId ='2')	
		LEFT OUTER JOIN PerformanceBasedGrant PBG ON PBG.GrantLegID = TD.GrantLegId AND PBG.GrantOptionID = TD.GrantOptionId AND PBG.VestingType = (LEFT(TD.VestingType,1))
	) 
	AS OptionValueReport 

	UPDATE TD
		SET MarketPrice = OVR.ClosePrice, UnvestedOptionsLiveFor = OVR.UnvestedOptionsLiveFor, VestedOptionsLiveFor = OVR.VestedOptionsLiveFor,
		IsVestingOfUnvestedOptions = OVR.IsVestingOfUnvestedOptions, PeriodUnit = OVR.PeriodUnit
	FROM #EMPLOYEE_TEMP_DATA AS TD 
		INNER JOIN #OptionValueReport OVR ON TD.GrantOptionId = OVR.GrantOptionId AND TD.GrantRegistrationId = OVR.GrantRegistrationId AND
			TD.SchemeId = OVR.SchemeId AND TD.GrantLegId = OVR.GrantLegId AND LEFT(TD.VestingType,1) =  OVR.VestingType AND
			TD.VestingDate = OVR.FinalVestingDate AND TD.ExpiryDate = OVR.FinalExpirayDate 
			AND (CASE WHEN UPPER(TD.Parent_Note) = 'ORIGINAL' THEN 'N' ELSE CASE WHEN UPPER(TD.Parent_Note) = 'BONUS' THEN 'B' ELSE 'S' END END) = OVR.Parent
	
	-- For Airtel Report
	UPDATE TD SET 
		ValueOfGrantedOptions = CASE WHEN TD.OptionsGranted * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsGranted * (@ClosePrice - TD.ExercisePrice) END,
		ValueOfVestedOptions = CASE WHEN TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) END,
		ValueOfUnvestedOptions = CASE WHEN TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice)END
		FROM 
		#EMPLOYEE_TEMP_DATA AS TD 
	
	SET @SQL_QUERY = 
		'
			SELECT GAM.LetterCode, GAM.IsGlGenerated, GAM.LetterAcceptanceStatus INTO #GrantAccMassUpload FROM GrantAccMassUpload AS GAM ' + @WHERE_OGA_CONDITION + '
			
			UPDATE ETD
			SET 
				ETD.IsGlGenerated = GAM.IsGlGenerated,
				ETD.LetterAcceptanceStatus = GAM.LetterAcceptanceStatus,
				ETD.IsEGrantsEnabled = ' + @IS_EGRANTS_ENABLED + '
			FROM
				#EMPLOYEE_TEMP_DATA AS ETD
				INNER JOIN #GrantAccMassUpload AS GAM ON GAM.LetterCode = ETD.GrantOptionId
		
			SELECT DISTINCT 
				ETD.OptionsGranted, ETD.OptionsVested, ETD.OptionsExercised, ETD.OptionsCancelled, ETD.OptionsLapsed, ETD.OptionsUnVested, 
				ETD.PendingForApproval, ETD.GrantOptionId, ETD.GrantLegId, ETD.SchemeId, ETD.GrantRegistrationId, ETD.Employeeid, ETD.EmployeeName, 
				ETD.SBU, ETD.AccountNo, ETD.PANNumber, ETD.Entity, ETD.[Status], ETD.GrantDate, ETD.VestingType, ETD.ExercisePrice, 
				ETD.VestingDate, ETD.ExpiryDate, ETD.Parent_Note, 
				(CASE WHEN ETD.VestingFrequency = ''0'' THEN ''Once''
					WHEN ETD.VestingFrequency = ''6'' THEN ''Half Yearly''
					WHEN ETD.VestingFrequency = ''12'' THEN ''Annual''
					WHEN ETD.VestingFrequency = ''24'' THEN ''Bi Annual''
					WHEN ETD.VestingFrequency = ''1'' THEN ''Monthly''
				END) AS VestingFrequency, 
				ETD.LapseDate, ETD.CancelledDate, ETD.CancelledReasion, ETD.MarketPrice, ETD.UnvestedOptionsLiveFor, ETD.VestedOptionsLiveFor, 
				ETD.IsVestingOfUnvestedOptions, ETD.PeriodUnit, 
				(ETD.OptionsVested * ETD.ExercisePrice) AS AmountPayableOnExercise, 
				(CASE 
					WHEN UPPER(ETD.PeriodUnit) = ''D'' THEN DATEADD(D,VestedOptionsLiveFor,'''+@ToDate+''')
					ELSE DATEADD(M, ETD.VestedOptionsLiveFor,'''+@ToDate+''')
					END		 		
				) AS LastDateToExercise,
				(CASE 
					WHEN UPPER(ETD.PeriodUnit) = ''D'' THEN DATEADD(D,ETD.UnvestedOptionsLiveFor,'''+@ToDate+''')
					ELSE DATEADD(M,ETD.UnvestedOptionsLiveFor,'''+@ToDate+''')
					END		 		
				) AS UnvestedCancellationDate, 
			ISNULL(ETD.ValueOfGrantedOptions,0) AS ValueOfGrantedOptions, ISNULL(ETD.ValueOfVestedOptions,0) AS ValueOfVestedOptions, ISNULL(ETD.ValueOfUnvestedOptions,0) AS ValueOfUnvestedOptions, ISNULL(ETD.UnvestedCancelled,0) AS UnvestedCancelled, ISNULL(ETD.VestedCancelled,0) AS VestedCancelled, 
			ISNULL(ETD.IsGlGenerated,0) AS IsGlGenerated, ISNULL(ETD.IsEGrantsEnabled,0) AS IsEGrantsEnabled,
			ETD.INSTRUMENT_NAME, ETD.CurrencyName, ETD.COST_CENTER, ETD.Department, ETD.Location, ETD.EmployeeDesignation,
			ETD.Grade, ETD.ResidentialStatus, ETD.CountryName, ETD.CurrencyAlias, ETD.MIT_ID, ETD.LetterAcceptanceStatus,
			' + @IS_GRANTDETONLYAFTERACC + ' As ShowGantAftrAcceptance, ' + @IS_GRANTDETWITHOUTACCORREJ + ' AS ShowGrantWithoutAccOrReject, ' + @IS_GRANTDETIFACCORREJ + ' AS ShowGrantIfAccorReject
			
			
			FROM #EMPLOYEE_TEMP_DATA  AS ETD '
				
		IF (@IS_EGRANTS_ENABLED = 1)
		BEGIN		
			SET @SQL_QUERY = @SQL_QUERY + ' INNER JOIN #GrantAccMassUpload AS GAM ON GAM.LetterCode = ETD.GrantOptionId ' + ' '
		END		
	
	SET @WHERE_CONDITION = '' 
	IF ((@DateParm IS NOT NULL) AND (@IS_EGRANTS_ENABLED = 1))
		BEGIN
			SET @WHERE_CONDITION = ' AND ((ETD.OptionsVested > 0) OR (ETD.OptionsUnVested > 0)) '
		END
	ELSE IF ((@DateParm IS NOT NULL) AND (@IS_EGRANTS_ENABLED = 0))
		BEGIN
			SET @WHERE_CONDITION = ' WHERE ((ETD.OptionsVested > 0) OR (ETD.OptionsUnVested > 0)) '
		END
	
	SET @ORDER_BY = 'ORDER BY GrantDate DESC, GrantOptionId, GrantLegId, VestingDate ASC; DROP TABLE #GrantAccMassUpload'
	
	--PRINT  @SQL_QUERY + @WHERE_CONDITION 
	
	--PRINT ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )
	
	CREATE TABLE #EMPLOYEE_INSTRUMENT_DATA 
    (			
		OptionsGranted NUMERIC(18,0), 
		OptionsVested NUMERIC(18,0), 
		OptionsExercised NUMERIC(18,0), 
		OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0), 
		OptionsUnVested NUMERIC(18,0), 
		PendingForApproval NUMERIC(18,0), 
		GrantOptionId NVARCHAR(100), 
		GrantLegId NUMERIC(18,0), 
		SchemeId NVARCHAR(150), 
		GrantRegistrationId NVARCHAR(150), 
		Employeeid NVARCHAR(150), 
		EmployeeName NVARCHAR(250), 
		SBU NVARCHAR(100) NULL, 
		AccountNo NVARCHAR(100) NULL, 
		PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, 
		[Status] NVARCHAR(100), 
		GrantDate DATETIME, 
		VestingType NVARCHAR(100), 
		ExercisePrice numeric(10,2), 
		VestingDate DATETIME, 
		ExpiryDate DATETIME, 
		Parent_Note NVARCHAR(10),
		VestingFrequency VARCHAR(50),
		LapseDate DATETIME,
		CancelledDate DATETIME, 
		CancelledReasion NVARCHAR(200), 
		MarketPrice NUMERIC (18,2), 
		UnvestedOptionsLiveFor NUMERIC(18,0), 
		VestedOptionsLiveFor NUMERIC(18,0), 
		IsVestingOfUnvestedOptions NVARCHAR(10), 
		PeriodUnit NVARCHAR(10),
		AmountPayableOnExercise NUMERIC (18,2), 
		LastDateToExercise DATETIME, 
		UnvestedCancellationDate DATETIME,
		ValueOfGrantedOptions NUMERIC(18,2), 
		ValueOfVestedOptions NUMERIC(18,2), 
		ValueOfUnvestedOptions NUMERIC(18,2),
		UnvestedCancelled NUMERIC(18,2), 
		VestedCancelled NUMERIC(18,2),
		IsGlGenerated BIT, 
		IsEGrantsEnabled BIT,
		INSTRUMENT_NAME NVARCHAR (100), 
		CurrencyName NVARCHAR (100), 
		COST_CENTER VARCHAR (50), 
		Department VARCHAR (50), 
		Location VARCHAR (100), 
		EmployeeDesignation VARCHAR (100), 
		Grade VARCHAR (50), 
		ResidentialStatus VARCHAR (50),
		CountryName VARCHAR (100), 
		CurrencyAlias VARCHAR (20), 
		MIT_ID INT,
		LetterAcceptanceStatus NCHAR(1),
		ShowGantAftrAcceptance NCHAR(1),
		ShowGrantWithoutAccOrReject NCHAR(1),
		ShowGrantIfAccorReject NCHAR(1),
		 
	)
	
	INSERT INTO #EMPLOYEE_INSTRUMENT_DATA 
	(
		OptionsGranted, 
		OptionsVested, 
		OptionsExercised, 
		OptionsCancelled, 
		OptionsLapsed, 
		OptionsUnVested, 
		PendingForApproval, 
		GrantOptionId, 
		GrantLegId, 
		SchemeId, 
		GrantRegistrationId, 
		Employeeid, 
		EmployeeName, 
		SBU, 
		AccountNo, 
		PANNumber,
		Entity, 
		[Status], 
		GrantDate, 
		VestingType, 
		ExercisePrice, 
		VestingDate, 
		ExpiryDate, 
		Parent_Note,
		VestingFrequency,
		LapseDate,
		CancelledDate, 
		CancelledReasion, 
		MarketPrice, 
		UnvestedOptionsLiveFor, 
		VestedOptionsLiveFor, 
		IsVestingOfUnvestedOptions, 
		PeriodUnit,
		AmountPayableOnExercise, 
		LastDateToExercise, 
		UnvestedCancellationDate,
		ValueOfGrantedOptions, 
		ValueOfVestedOptions, 
		ValueOfUnvestedOptions,
		UnvestedCancelled, 
		VestedCancelled,
		IsGlGenerated, 
		IsEGrantsEnabled,
		INSTRUMENT_NAME, 
		CurrencyName, 
		COST_CENTER, 
		Department, 
		Location, 
		EmployeeDesignation, 
		Grade, 
		ResidentialStatus,
		CountryName, 
		CurrencyAlias, 
		MIT_ID,
		LetterAcceptanceStatus,
		ShowGantAftrAcceptance,
		ShowGrantWithoutAccOrReject,
		ShowGrantIfAccorReject
	)
	EXEC ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )
	
	---- Wealth report Doghnut chart
	IF @ControlMasterID=12
	BEGIN
		--Data For Doghnut Chart wealth Report
		/*
		SELECT  ((@ClosePrice/ETD.OptionRatioDivisor*ETD.OptionRatioMultiplier) *  ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) ) AS [ValueOfVested], ((@ClosePrice/ETD.OptionRatioDivisor * ETD.OptionRatioMultiplier) * ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfUnvested],INSTRUMENT_NAME,CurrencyAlias
		*/
		SELECT ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) AS [ValueOfVested],ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0) AS [ValueOfUnvested],INSTRUMENT_NAME,CurrencyAlias
		FROM #EMPLOYEE_TEMP_DATA ETD WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1 AND ETD.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) 
		OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
		GROUP BY MIT_ID,INSTRUMENT_NAME,CurrencyAlias
		/* , ETD.OptionRatioDivisor,ETD.OptionRatioMultiplier  */
		
		--Data For convert doghnut chart to table format
		/*
		SELECT INSTRUMENT_NAME +' ('+CurrencyAlias+')' AS [INSTRUMENT_NAME],((@ClosePrice/ETD.OptionRatioDivisor*ETD.OptionRatioMultiplier) *  ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) ) AS [ValueOfVested], ((@ClosePrice/ETD.OptionRatioDivisor * ETD.OptionRatioMultiplier) * ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfUnvested],(ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0)+ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfOutstanding]--,CurrencyAlias AS Currency
		*/
		SELECT INSTRUMENT_NAME +' ('+CurrencyAlias+')' AS [INSTRUMENT_NAME],ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) AS [ValueOfVested],ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0) AS [ValueOfUnvested],(ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0)+ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfOutstanding]--,CurrencyAlias AS Currency
		FROM #EMPLOYEE_TEMP_DATA ETD WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1AND ETD.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) 
		OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
		GROUP BY MIT_ID,INSTRUMENT_NAME,CurrencyAlias
		/* , ETD.OptionRatioDivisor,ETD.OptionRatioMultiplier */
		
	END
	ELSE IF @ControlMasterID=15 ---my Summary report for trasnposed table column and rows
	BEGIN
			/*
			SELECT INSTRUMENT_NAME , ((@ClosePrice/ETD.OptionRatioDivisor * ETD.OptionRatioMultiplier) * SUM(ISNULL(OptionsGranted,0)))AS Granted,((@ClosePrice/ETD.OptionRatioDivisor * ETD.OptionRatioMultiplier) * SUM(ISNULL(OptionsVested,0)) )AS Vested,  ((@ClosePrice/ETD.OptionRatioDivisor * ETD.OptionRatioMultiplier) * SUM(ISNULL(OptionsUnVested,0))) AS Unvested,(SUM(ISNULL(OptionsVested,0))+SUM(ISNULL(OptionsUnVested,0)))AS Outstanding
			*/
			SELECT INSTRUMENT_NAME ,SUM(ISNULL(OptionsGranted,0)) AS Granted,SUM(ISNULL(OptionsVested,0)) AS Vested,SUM(ISNULL(OptionsUnVested,0)) AS Unvested,(SUM(ISNULL(OptionsVested,0))+SUM(ISNULL(OptionsUnVested,0)))AS Outstanding
			FROM #EMPLOYEE_TEMP_DATA ETD WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1 AND ETD.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) 
			OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			GROUP BY MIT_ID,INSTRUMENT_NAME,CurrencyAlias
			/* ,ETD.OptionRatioDivisor,ETD.OptionRatioMultiplier */
			
	END
	ELSE IF @ControlMasterID=16 ---Exercise Transaction Status Report
	BEGIN
			
			SELECT TOP 3 X.[ExerciseDate],X.[ExerciseNumber],PlanName,FORMAT(DateOfGrant, 'dd-MMM-yyyy', 'en-us')AS DateOfGrant,X.[ExercisedQuantity],
				CASE WHEN X.PendingStatus=1 AND @ForMobile = 0 THEN '<h4 class="no-margin"><a  class="btn btn-gradient" style="border-radius:30px;padding:1px 20px;text-transform: capitalize;" href="../Employee/'+ ProcessLink +'">'+	 DISPLAY_NAME +'</a></h4>'
					 WHEN X.PendingStatus=1 AND @ForMobile = 1  THEN  DISPLAY_NAME
					 WHEN X.PendingStatus>1 AND @ForMobile = 0 THEN '<h4 class="no-margin"><a  class="btn btn-gradient" style="border-radius:30px;padding:1px 20px;text-transform: capitalize;" href="../Employee/InProcess.aspx">'+ DISPLAY_NAME +'</a></h4>'
					 WHEN X.PendingStatus>1 AND @ForMobile = 1  THEN  DISPLAY_NAME
					ELSE CASE WHEN X.MIT_ID IN(5,7) AND @ForMobile = 0  THEN '<h4 class="no-margin"><a  class="btn btn-warning" style="border-radius:30px;padding:1px 20px;text-transform: capitalize;" href="../Employee/InProcess.aspx">Payout</a></h4>'
						      WHEN X.MIT_ID IN(5,7) AND @ForMobile = 1  THEN 'Payout'
						 ELSE CASE WHEN @ForMobile = 0 THEN '<h4 class="no-margin"><a  class="btn btn-warning" style="border-radius:30px;padding:1px 20px;text-transform: capitalize;" href="../Employee/InProcess.aspx">Allotment</a></h4>'
							  ELSE 'Allotment'   
							  END
						 END		
		END AS [PendingFor],
	CNT
	FROM
	(
			SELECT FORMAT(ExerciseDate, 'dd-MMM-yyyy', 'en-us')AS [ExerciseDate],ISNULL(ExerciseNo,0) AS [ExerciseNumber],
			(SELECT TOP 1 S.SchemeTitle FROM Scheme S Inner join GrantRegistration GR ON S.ApprovalId=GR.ApprovalId
				INNER JOIN GrantOptions GOP on GOP.GrantRegistrationId=GR.GrantRegistrationId
				INNER JOIN GrantLeg GL ON GOP.GrantOptionId=GL.GrantOptionId AND GL.ID=SEO.GrantLegSerialNumber
			) AS PlanName,
			(SELECT TOP 1 GR.GrantDate FROM Scheme S Inner join GrantRegistration GR ON S.ApprovalId=GR.ApprovalId
				INNER JOIN GrantOptions GOP on GOP.GrantRegistrationId=GR.GrantRegistrationId
				INNER JOIN GrantLeg GL ON GOP.GrantOptionId=GL.GrantOptionId AND GL.ID=SEO.GrantLegSerialNumber
			) AS DateOfGrant,
			(SELECT SUM(ISNULL(ExercisedQuantity,0)) AS [ExercisedQuantity] FROM ShExercisedOptions SH WHERE SH.ExerciseNo=SEO.ExerciseNo) AS [ExercisedQuantity],
			--ISNULL(ExercisedQuantity,0) AS [ExercisedQuantity],
			(SELECT EXERCISE_STEPID  FROM FN_GET_EXERCISE_STEP_STATUS(SEO.ExerciseNo))AS PendingStatus,
			SEO.PaymentMode,

			CASE WHEN SEO.PaymentMode IS NULL THEN 1
					WHEN SEO.PaymentMode IS NOT NULL AND ISNULL(SEO.isFormGenerate,0)=0 THEN 2
					ELSE 3
			END AS DisplayOrder,

			CASE WHEN SEO.IsAutoExercised = 2 AND ISNULL(PaymentMode ,'')='' AND CONVERT(DATE, SEO.ExerciseDate) > CONVERT(DATE, GETDATE()) THEN 'Prevesting.aspx' ELSE 'InProcess.aspx'
			END AS ProcessLink,

			(SELECT COUNT(ExerciseId) AS CNT FROM ShExercisedOptions SH WHERE EmployeeID=@EmployeeID) AS CNT,
			ExerciseId, 
			ROW_NUMBER() OVER (partition by ExerciseNo ORDER BY ExerciseNo)AS RowNo,SEO.isFormGenerate,SEO.MIT_ID,
			(SELECT DISPLAY_NAME  FROM FN_GET_EXERCISE_STEP_STATUS(SEO.ExerciseNo)) AS DISPLAY_NAME
			FROM ShExercisedOptions SEO 
			WHERE EmployeeID=@EmployeeID
				
		)X WHERE RowNo=1
		ORDER BY X.ExerciseNumber DESC

	END 
	ELSE IF @ControlMasterID=20 ---Price Trend Report
	BEGIN
			---Temp Table for NSE
			DECLARE @CurrencyAlias VARCHAR(20)
			DECLARE @ListedYN CHAR(1)

			SELECT @CurrencyAlias= CurrencyAlias 
			FROM CURRENCYMASTER CR 
			INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CR.CurrencyID = CIM.CurrencyID

			SELECT @ListedYN=ISNULL(ListedYN,'')
			FROM CompanyParameters

			DECLARE @IsNYSE INT
			SELECT @IsNYSE=COUNT(*)
			FROM
			(
				SELECT TOP 1 FMVPriceId FROM FMVSharePrices WHERE StockExchange = 'B' and ISNULL(Volume,0.00) = 0 ORDER BY PriceDate DESC
			)X 

			SELECT CONVERT(VARCHAR(9), PriceDate, 6) AS [DATE],ClosePrice ,@IsNYSE AS IsNYSE,@CurrencyAlias AS CurrencyAlias,@ListedYN AS IsListed 
			FROM FMVSharePrices
			WHERE DATEDIFF(DAY, PriceDate, GETDATE()) < 90 
			AND StockExchange = 'N' AND @ListedYN='Y'
			ORDER BY PriceDate ASC 

			SELECT CONVERT(VARCHAR(9), PriceDate, 6) AS [DATE],ClosePrice ,@IsNYSE AS IsNYSE,@CurrencyAlias AS CurrencyAlias,@ListedYN AS IsListed
			FROM FMVSharePrices
			WHERE DATEDIFF(DAY, PriceDate, GETDATE()) < 90 
			AND StockExchange = 'B' AND @ListedYN='Y'
			ORDER BY PriceDate ASC

			--***********Unlisted Company FMV Details
			SELECT  *
			FROM
			(
				SELECT TOP 5 CONVERT(VARCHAR(9), [FMV_FromDate], 6) AS [DATE],FMV AS ClosePrice,'' AS IsNYSE,@CurrencyAlias AS CurrencyAlias,@ListedYN AS IsListed,[FMV_FromDate] FROM FMVForUnlisted WHERE @ListedYN='N' ORDER BY [FMV_FromDate] DESC
			)X ORDER BY X.[FMV_FromDate] ASC
			
	END
	ELSE IF @ControlMasterID=21 ---OGA Status Report
	BEGIN

			DECLARE @STATUS  AS VARCHAR(5)
			SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS	

			SELECT TOP 3 Y.[DateOfGrant],
				CASE WHEN (ISNULL(Y.LetterAcceptanceStatus,'')='' OR ISNULL(Y.LetterAcceptanceStatus,'')='P') AND CONVERT(DATE,Y.LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 
						CASE WHEN @ForMobile = 0 THEN
						'<h4 class="no-margin"><a id="lnkeGrant'+CAST(Row AS VARCHAR)+'" class="btn btn-default" style="border-radius:30px;padding:0.5px 20px;text-transform: capitalize;"  href="../Employee/OnlineGrants.aspx">Expired</a></h4>'
						ELSE 'Expired' END 
					 WHEN ISNULL(Y.LetterAcceptanceStatus,'')='A' THEN 
						CASE WHEN @ForMobile = 0 THEN
						'<h4 class="no-margin"><a id="lnkeGrant'+CAST(Row AS VARCHAR)+'" class="btn btn-success" style="border-radius:30px;padding:0.5px 20px;text-transform: capitalize;"  href="../Employee/OnlineGrants.aspx">Accepted</a></h4>'
						ELSE 'Accepted' END 
					 WHEN ISNULL(Y.LetterAcceptanceStatus,'')='P' THEN 
						CASE WHEN @ForMobile = 0 THEN
						'<h4 class="no-margin"><a id="lnkeGrant'+CAST(Row AS VARCHAR)+'" class="btn btn-gradient" style="border-radius:30px;padding:0.5px 20px;text-transform: capitalize;"  href="../Employee/OnlineGrants.aspx">Pending</a></h4>'
						ELSE 'Pending' END 
					 WHEN ISNULL(Y.LetterAcceptanceStatus,'')='R' THEN 
						CASE WHEN @ForMobile = 0 THEN
						'<h4 class="no-margin"><a id="lnkeGrant'+CAST(Row AS VARCHAR)+'" class="btn btn-default" style="border-radius:30px;padding:0.5px 20px;text-transform: capitalize;" href="../Employee/OnlineGrants.aspx">Rejected</a></h4>'
						ELSE 'Rejected' END 
				ELSE
					 CASE WHEN @ForMobile = 0 
						THEN '<h4 class="no-margin"><a id="lnkeGrant'+CAST(Row AS VARCHAR)+'" class="btn btn-warning" style="border-radius:30px;padding:0.5px 20px;text-transform: capitalize;"  href="../Employee/OnlineGrants.aspx">Pending</a></h4>'
						ELSE 'Pending' END
				END AS [Status],Y.CNT
			FROM
			(
				SELECT  DateOfGrant,LetterAcceptanceStatus,LastAcceptanceDate,X.CNT,ROW_NUMBER() OVER (order by GrantStatus,GrantDate DESC)AS Row
				FROM
				(
					SELECT --SchemeName AS [Instrument Name], 
					FORMAT(GrantDate, 'dd-MMM-yyyy', 'en-us') AS [DateOfGrant],
					 --LetterCode AS [Grant ID], 
				
					CASE WHEN (ISNULL(LetterAcceptanceStatus,'')='' OR ISNULL(LetterAcceptanceStatus,'')='P') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 4 --Expired
						 WHEN ISNULL(LetterAcceptanceStatus,'')='A' THEN 2
						 WHEN ISNULL(LetterAcceptanceStatus,'')='P' THEN 1
						 WHEN ISNULL(LetterAcceptanceStatus,'')='R' THEN 3
					END AS GrantStatus,(SELECT COUNT(GAMUID) FROM GrantAccMassUpload WHERE employeeId = @EmployeeId AND MailSentStatus = 1AND MailSentDate IS NOT NULL) AS CNT,*
				
					FROM GrantAccMassUpload 
					WHERE employeeId = @EmployeeId 
					AND MailSentStatus = 1
					AND MailSentDate IS NOT NULL
				
				)X WHERE (@STATUS=2 AND (X.GrantStatus<>3 OR X.GrantStatus<>4)) OR @STATUS IN(1,3,4)
				--ORDER BY X.GrantStatus,X.GrantDate DESC
			)Y ORDER BY Y.Row
	END
	ELSE IF @ControlMasterID=22 ---My Summary Report On Report Dashboard
	BEGIN
			SELECT INSTRUMENT_NAME ,SUM(ISNULL(OptionsGranted,0)) AS [Granted],SUM(ISNULL(OptionsVested,0)) AS [Vested],SUM(ISNULL(OptionsUnVested,0)) AS [UnVested],SUM(ISNULL(OptionsExercised,0)) AS [Exercised],SUM(ISNULL(PendingForApproval,0)) AS [PendingForApproval],SUM(ISNULL(OptionsCancelled,0)) AS [Cancelled],SUM(ISNULL(OptionsLapsed,0)) AS [Lapsed] 
			FROM #EMPLOYEE_TEMP_DATA WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1) OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			GROUP BY MIT_ID,INSTRUMENT_NAME
	END
	ELSE IF @ControlMasterID=23 ---Designed widget as Reports All Dashboard pages links 
	BEGIN
			--SELECT M.DisplayName,
			--'<a id="'+M.DisplayName+'" href="'+M.MenuUrl+'" class="btn btn-sm btn-link Fa-Icon"><img src="../App_Themes/ESOP-UI/assets/website/images/view.png" width="20px" height="20px"/></a>' AS MenuLink
			--FROM 
			--MenuSubMenu M
			--WHERE ISNULL(IsShownOnDashboard,0)=1
			SELECT 'My Summary Report'AS ReportName,'<img height="20px" style="cursor: pointer;" src="../App_Themes/ESOP-UI/assets/website/images/Download.png" onclick="GetOptionSummaryReport(true);"/>' AS LnkDownload
			UNION
			SELECT 'My Exercise Report' AS ReportName,'<img height="20px" style="cursor: pointer;" src="../App_Themes/ESOP-UI/assets/website/images/Download.png" onclick="ExportReport(''Excel'');"/>' AS LnkDownload
	END
	ELSE IF @ControlMasterID=24 ---Designed widget as WHAT IS Next 
	BEGIN
			DECLARE @FINALVESTINGDATE VARCHAR(MAX)
			DECLARE @FINALEXPIRAYDATE VARCHAR(MAX)

			SELECT TOP 1 @FINALVESTINGDATE=GRANTLEG.FINALVESTINGDATE 
			FROM GRANTLEG INNER JOIN GRANTOPTIONS ON GRANTLEG.GRANTOPTIONID = GRANTOPTIONS.GRANTOPTIONID 
			WHERE GRANTOPTIONS.EMPLOYEEID=@EmployeeID 
			AND GRANTLEG.FINALVESTINGDATE >= (SELECT MAX(FINALVESTINGDATE) FROM GRANTLEG WHERE FINALVESTINGDATE <=GETDATE())

			SELECT TOP 1 @FINALEXPIRAYDATE=GRANTLEG.FINALEXPIRAYDATE 
			FROM GRANTLEG INNER JOIN GRANTOPTIONS ON GRANTLEG.GRANTOPTIONID = GRANTOPTIONS.GRANTOPTIONID 
			WHERE GRANTOPTIONS.EMPLOYEEID=@EmployeeID
			AND GRANTLEG.FINALEXPIRAYDATE >= (SELECT MAX(FINALEXPIRAYDATE) FROM GRANTLEG WHERE FINALEXPIRAYDATE <=GETDATE())
	
			IF(LEN(@FINALVESTINGDATE)>0)
			BEGIN
					SET @FINALVESTINGDATE= '<li class="list-group-item"><a id="LnkVesting" href="../EmployeeReports/MySummaryReport.aspx" >Vesting due on '+CAST(FORMAT(CAST(@FINALVESTINGDATE AS DATE), 'dd-MMM-yyyy', 'en-us') AS VARCHAR)+'</a></li>'
			END
			ELSE
			BEGIN
					SET @FINALVESTINGDATE= '<li class="list-group-item">No Vesting due in next year</li>'
			END

	
			IF(LEN(@FINALEXPIRAYDATE)>0)
			BEGIN
					SET @FINALEXPIRAYDATE ='<li class="list-group-item"><a id="LnkFinalExpiray" href="../EmployeeReports/MySummaryReport.aspx" >Expiry due on  '+CAST(FORMAT(CAST(@FINALEXPIRAYDATE AS DATE), 'dd-MMM-yyyy', 'en-us') AS VARCHAR)+'</a></li>' --FORMAT(DateOfGrant, 'dd-MMM-yyyy', 'en-us')
			END
			BEGIN
					SET @FINALEXPIRAYDATE ='<li class="list-group-item">No Expiray due in next year</li>'
			END
			SELECT CONCAT('<ul class="list-group">',@FINALVESTINGDATE, @FINALEXPIRAYDATE,'</ul>') AS WhatIsNextLinks
			--SELECT X.WhatIsNextLinks
			--FROM
			--(
				
			--	SELECT 1 AS DisplayOrder, @FINALVESTINGDATE AS WhatIsNextLinks
			--	UNION
			--	SELECT 2 AS DisplayOrder, @FINALEXPIRAYDATE AS WhatIsNextLinks
			--)X ORDER BY DisplayOrder
	END
	ELSE IF @ControlMasterID=17 AND @ForMobile = 1 ---Designed widget TODO 
	BEGIN

		DECLARE @UrlID INT
		DECLARE @UrlAliase NVARCHAR(100)
		DECLARE @Url NVARCHAR(300)
		DECLARE @RTN_LINK_HTML NVARCHAR(MAX)=''
		DECLARE @Percentage INT
		DECLARE @UrlIDNominee INT=0
		DECLARE @UrlIDAcceptGrant INT=0
		DECLARE @PendingAcceptGrantCnt INT=0
		DECLARE @IsPersonalDetailUpdated INT=0
		DECLARE @URLPersonalDetailUpdated INT=0
		DECLARE @CNT INT=0
		
		
		IF EXISTS(SELECT * FROM MENUSUBMENU WHERE UPPER(MENUNAME)='NOMINATION' AND ISACTIVE=1)
			BEGIN
				SELECT @UrlAliase=URL_ALIASE,@Url=[URL]
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND URL LIKE '%../Employee/Nomination.aspx%'
				
			END
			--*****************************************************************************

			SELECT @IsPersonalDetailUpdated=SUM(X.DateOfJoining + X.Grade + X.SecondaryEmailID + X.CountryName + X.EmployeePhone + X.EmployeeEmail + X.EmployeeAddress + X.PANNumber + X.Department + X.ResidentialStatus +X.[Location] + X.Insider + X.SBU --+ X.WardNumber 
				+ X.Entity + X.COST_CENTER + X.TAX_IDENTIFIER_COUNTRY + X.TAX_IDENTIFIER_STATE + X.EmployeeDesignation + X.BROKER_DEP_TRUST_CMP_NAME + X.BROKER_DEP_TRUST_CMP_ID + X.BROKER_ELECT_ACC_NUM + X.DPRecord + X.DepositoryName + X.DematAccountType + X.DepositoryParticipantNo + X.DepositoryIDNumber + X.ClientIDNumber )
				FROM 
				(
						SELECT
						CASE WHEN LEN(ISNULL(DateOfJoining,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='DateOfJoining' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DateOfJoining,

						CASE WHEN LEN(ISNULL(Grade,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='Grade' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS Grade,

						CASE WHEN LEN(ISNULL(SecondaryEmailID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='SecondaryEmailID' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS SecondaryEmailID,

						CASE WHEN LEN(ISNULL(CountryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE CPD.Datafield='CountryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS CountryName,

						CASE WHEN LEN(ISNULL(EmployeePhone,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeePhone' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS EmployeePhone,

						CASE WHEN LEN(ISNULL(EmployeeEmail,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeEmail' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS EmployeeEmail,

						CASE WHEN LEN(ISNULL(EmployeeAddress,''))=0 AND  (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeAddress' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS EmployeeAddress,

						CASE WHEN LEN(ISNULL(PANNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='PANNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS PANNumber,

						CASE WHEN LEN(ISNULL(Department,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Department' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS Department,

						CASE WHEN LEN(ISNULL(ResidentialStatus,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ResidentialStatus' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS ResidentialStatus,

						CASE WHEN LEN(ISNULL([Location],''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Location' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS [Location],

						CASE WHEN LEN(ISNULL(Insider,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Insider' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS Insider,

						CASE WHEN LEN(ISNULL(SBU,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='SBU' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS SBU,

						--CASE WHEN LEN(ISNULL(WardNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='WardNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						--ELSE 0
						--END AS WardNumber,

						CASE WHEN LEN(ISNULL(Entity,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='Entity' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS Entity,

						CASE WHEN LEN(ISNULL(COST_CENTER,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='COST_CENTER' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS COST_CENTER,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_COUNTRY,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_COUNTRY' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_COUNTRY,

						CASE WHEN LEN(ISNULL(TAX_IDENTIFIER_STATE,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE   CPD.Datafield='TAX_IDENTIFIER_STATE' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS TAX_IDENTIFIER_STATE,

						CASE WHEN LEN(ISNULL(EmployeeDesignation,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='EmployeeDesignation' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS EmployeeDesignation,

						CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_NAME,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_NAME' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL AND (SELECT COUNT(MIT_ID) FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID IN(3,4))>0)>0  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_NAME,

						CASE WHEN LEN(ISNULL(EUB.BROKER_DEP_TRUST_CMP_ID,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_DEP_TRUST_CMP_ID' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL AND (SELECT COUNT(MIT_ID) FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID IN(3,4))>0)>0  THEN 1
						ELSE 0
						END AS BROKER_DEP_TRUST_CMP_ID,

						CASE WHEN LEN(ISNULL(EUB.BROKER_ELECT_ACC_NUM,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='BROKER_ELECT_ACC_NUM' AND CPD.ADS_CHECK_EXERCISE='Y' AND CPD.MIT_ID IS NULL AND (SELECT COUNT(MIT_ID) FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID IN(3,4))>0)>0  THEN 1
						ELSE 0
						END AS BROKER_ELECT_ACC_NUM,

						CASE WHEN LEN(ISNULL(EUD.DPRecord,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DPRecord' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DPRecord,

						CASE WHEN LEN(ISNULL(EUD.DepositoryName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryName' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DepositoryName,

						CASE WHEN LEN(ISNULL(EUD.DematAccountType,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DematAccountType' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DematAccountType,

						CASE WHEN LEN(ISNULL(EUD.DepositoryParticipantName,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryParticipantNo' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DepositoryParticipantNo,

						CASE WHEN LEN(ISNULL(EUD.DepositoryIDNumber,''))=0 AND ISNULL(EUD.DepositoryIDNumber,'')='N' AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='DepositoryIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS DepositoryIDNumber,

						CASE WHEN LEN(ISNULL(EUD.ClientIDNumber,''))=0 AND (SELECT COUNT(*) FROM ConfigurePersonalDetails CPD WHERE  CPD.Datafield='ClientIDNumber' AND CPD.Check_Exercise='Y' AND CPD.MIT_ID IS NULL)>0  THEN 1
						ELSE 0
						END AS ClientIDNumber


				FROM EmployeeMaster EM
				LEFT JOIN Employee_UserBrokerDetails EUB ON EM.EmployeeID=EUB.EMPLOYEE_ID AND ISNULL(EUB.IS_ACTIVE,0)=1
				LEFT JOIN Employee_UserDematDetails EUD ON EM.EmployeeID=EUD.EmployeeID AND ISNULL(EUD.IsActive,0)=1
				WHERE EM.EmployeeID=@EmployeeId
				
				)X

		---***********************IF Pending Grant Acceptance then exclude from result**************************
			SELECT @Percentage=SUM(CAST(PercentageOfShare AS DECIMAL)) FROM NomineeDetails WHERE UserID=@EmployeeId AND ISNULL(IsActive,0)=1 GROUP BY UserID
			SELECT @PendingAcceptGrantCnt=COUNT(*) FROM GrantAccMassUpload WHERE EmployeeID=@EmployeeId AND ISNULL(LetterAcceptanceStatus,'')='P' AND CONVERT(DATE,LASTACCEPTANCEDATE) >= CONVERT(DATE,GETDATE())

			
			SELECT
				N.URL_ALIASE,
				CASE WHEN ISNULL(@Percentage,0)=100 THEN 'Completed'
				ELSE 'Pending' END AS STATUS,N.URL FROM (SELECT URL_ALIASE,URL
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND ISNULL(ISACTIVE,0)=1 AND URL LIKE '%../Employee/Nomination.aspx%')N
			UNION
			SELECT
				U.URL_ALIASE,
				CASE WHEN @IsPersonalDetailUpdated = 0 THEN 'Completed'
				ELSE 'Pending' END AS STATUS, U.URL FROM (SELECT URL_ALIASE,URL
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND ISNULL(ISACTIVE,0)=1 AND URL LIKE '%../Employee/UserProfile.aspx%')U
			UNION
			SELECT
				O.URL_ALIASE,
				CASE WHEN @PendingAcceptGrantCnt = 0 THEN 'Completed'
				ELSE 'Pending' END AS STATUS,
				O.URL FROM (SELECT URL_ALIASE,URL
				FROM DASHBOARD_WIDGETS_URLS_MAPPING
				WHERE CONTROL_MASTER_ID=17 AND ISNULL(ISACTIVE,0)=1 AND URL LIKE '%../Employee/OnlineGrants.aspx%')O
	END
	ELSE IF (@ControlMasterID=13 OR @ControlMasterID=14) AND @ForMobile = 1  ---Designed widget Ctl_Banner_Top_Left /  Ctl_Banner_Top_Right
	BEGIN
		--SELECT WIDGET_HTML_CONTENT FROM DASHBOARD_CONTROLS_MASTER WHERE CONTROL_MASTER_ID = @ControlMasterID		
		SELECT  13 AS CONTROL_MASTER_ID, REPLACE(ISNULL(WIDGET_HTML_CONTENT,''),'@CompanyID',@CompanyID) as Content,  REPLACE(ISNULL(concat(concat(replace((select SiteUrl from companymaster),'Login.aspx',''),'Uploads/@CompanyID/HomeBoxes/@CompanyID'), '.jpg'),''), '@CompanyID',@CompanyID) as BannerPath
		FROM DASHBOARD_CONTROLS_MASTER DCMR WHERE DCMR.CONTROL_MASTER_ID = @ControlMasterID
		UNION ALL
		SELECT 14 AS CONTROL_MASTER_ID, REPLACE(ISNULL(WIDGET_HTML_CONTENT,''),'@CompanyID',@CompanyID) as Content,  REPLACE(ISNULL(concat(concat(replace((select SiteUrl from companymaster),'Login.aspx',''),'Uploads/@CompanyID/HomeBoxes/'), 'CEO Msg.jpg'),''), '@CompanyID',@CompanyID) as BannerPath
		FROM DASHBOARD_CONTROLS_MASTER DCM WHERE DCM.CONTROL_MASTER_ID = @ControlMasterID
	END

	DROP TABLE #EMPLOYEE_TEMP_DATA  
	DROP TABLE #OptionValueReport
	DROP TABLE #CancelledDataFromGrantLeg
	DROP TABLE #EMPLOYEE_INSTRUMENT_DATA
	
	SET NOCOUNT OFF;
END
GO
