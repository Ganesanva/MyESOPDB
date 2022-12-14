/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_REPORT_DATA_UI]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_REPORT_DATA_UI]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_REPORT_DATA_UI]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_REPORT_DATA_UI] (@EmployeeId VARCHAR(50), @DisplayPram VARCHAR(10) = NULL, @DateParm DATE = NULL )
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @ORDER_BY AS VARCHAR(1000)
	Declare @CompanyID AS VARCHAR(100)
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

	SET @EmployeeID=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)	
	SET @CompanyID= (SELECT CompanyID FROM COMPANYMASTER)
    -- Insert statements for procedure here
    
    CREATE TABLE #EMPLOYEE_TEMP_DATA 
    (			
		OptionsGranted NUMERIC(18,0), OptionsVested NUMERIC(18,0), OptionsExercised NUMERIC(18,0), OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0), OptionsUnVested NUMERIC(18,0), PendingForApproval NUMERIC(18,0), 
		GrantOptionId NVARCHAR(100),GrantLegId NUMERIC(18,0), SchemeId NVARCHAR(150), GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150), EmployeeName NVARCHAR(250), SBU NVARCHAR(100) NULL, AccountNo NVARCHAR(100) NULL, PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100), GrantDate DATETIME, VestingType NVARCHAR(100), ExercisePrice numeric(10,2), VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), 
		VestingFrequency VARCHAR(5), -- Add column for Option vest Report
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
		MIT_ID INT, LetterAcceptanceStatus NCHAR(1), CancellationReason NVARCHAR(500), NoOfOptions NUMERIC(18,0)
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
	
	/*SELECT * FROM #EMPLOYEE_TEMP_DATA*/
	--Actual Vesting till date % = Vestwise (Vested+ pending for approval+ Exercised+ Lapsed + Vested cancelled) / Total granted for that grant id
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
		GL.CancellationDate, GL.CancellationReason, GL.GrantOptionId, GL.GrantLegId, CASE WHEN GL.VestingType = 'T' THEN 'Time Based' ELSE 'Performance Based' END VestingType
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
			SELECT GAM.LetterCode, GAM.IsGlGenerated,GAM.LetterAcceptanceStatus				
				  INTO #GrantAccMassUpload FROM GrantAccMassUpload AS GAM ' + @WHERE_OGA_CONDITION + '
			
			UPDATE ETD
			SET 
				ETD.IsGlGenerated = GAM.IsGlGenerated,
				ETD.LetterAcceptanceStatus = GAM.LetterAcceptanceStatus,
				ETD.IsEGrantsEnabled = ' + @IS_EGRANTS_ENABLED + '
			FROM
				#EMPLOYEE_TEMP_DATA AS ETD
				INNER JOIN #GrantAccMassUpload AS GAM ON GAM.LetterCode = ETD.GrantOptionId

			UPDATE ETD
			SET 
				ETD.NoOfOptions = GAMUD.NoOfOptions
				
			FROM
				GrantAccMassUpload AS GAM 
				INNER JOIN GrantAccMassUploadDet as GAMUD ON GAMUD.GAMUID=GAM.GAMUID 
				INNER JOIN #EMPLOYEE_TEMP_DATA AS ETD ON ETD.GrantOptionId=GAM.LetterCode AND ETD.GrantLegId=GAMUD.VestPeriod
		
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
			ETD.Grade, ETD.ResidentialStatus, ETD.CountryName, ETD.CurrencyAlias, ETD.MIT_ID,
				(CASE 
				 WHEN ETD.LetterAcceptanceStatus = ''A'' then ''ACCEPTED''
				 WHEN ETD.LetterAcceptanceStatus = ''P'' then ''PENDING''
				 WHEN ETD.LetterAcceptanceStatus = ''R'' then ''REJECTED'' 
			END) AS LetterAcceptanceStatus,
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
	EXEC ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )	
	--PRINT ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )
	SELECT * INTO #FINALDATA FROM
	(
		SELECT MIT_ID, INSTRUMENT_NAME, SchemeId, GrantDate, GrantOptionId, LetterAcceptanceStatus, 
		CurrencyAlias, ExercisePrice, VestingDate, OptionsGranted, 
		OptionsVested, OptionsUnVested, PendingForApproval,OptionsExercised, ValueOfGrantedOptions, 
		ValueOfVestedOptions, ValueOfUnvestedOptions, OptionsCancelled, OptionsLapsed, ExpiryDate,
		CASE WHEN UPPER(VestingType)='PERFORMANCE BASED' THEN 'Performance Based'
		ELSE 'Time Based' END VestingType,
		UnvestedCancelled, VestedCancelled ,GrantLegId,NoOfOptions
		FROM #EMPLOYEE_TEMP_DATA WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1) OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0) 
	)	AS #FINAL_REPORT_DATA
	
			--level 1 start from here
		DECLARE @level1 TABLE
		(
			MIT_ID int , INSTRUMENT_NAME nvarchar(100),  currency varchar(50), vested NUMERIC(18,0), granted NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
			valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0),UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2)
		)
		INSERT INTO @level1
		SELECT DISTINCT 
			ETD1.MIT_ID, ETD1.INSTRUMENT_NAME,  ETD1.CurrencyAlias AS currency, SUM(ETD1.OptionsVested) AS vested, SUM(ETD1.OptionsGranted) AS granted, SUM(ETD1.OptionsUnVested) AS unvested,
			SUM(ETD1.OptionsExercised) AS exercised,SUM(ETD1.PendingForApproval) AS PendingForApproval, SUM(ETD1.ValueOfGrantedOptions) AS valueForGrant, SUM(ETD1.ValueOfVestedOptions) AS valueForVested, SUM(ETD1.ValueOfUnvestedOptions) AS valueForUnvested,
			SUM(ETD1.OptionsCancelled) AS cancelled, SUM(ETD1.OptionsLapsed) AS lapsed,SUM(UnvestedCancelled) As UnvestedCancelled ,Sum(VestedCancelled ) As VestedCancelled
		FROM
			#FINALDATA ETD1 WHERE(@IS_EGRANTS_ENABLED=1 AND ETD1.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
		GROUP BY
			ETD1.MIT_ID, ETD1.INSTRUMENT_NAME,  ETD1.CurrencyAlias
		--level 1 ends here

		--level 2 start from here 
	DECLARE @level2 TABLE
	(
		MIT_ID int , SchemeTitle nvarchar(100),  currency varchar(50), granted NUMERIC(18,0), vested NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
		valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0),UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2)
	)
	INSERT INTO @level2
	SELECT DISTINCT 
		level2.MIT_ID,level2.SchemeId AS SchemeTitle, level2.CurrencyAliAS AS currency,SUM(level2.OptionsGranted) AS granted,SUM(level2.OptionsVested) AS vested, SUM(level2.OptionsUnVested) AS unvested,
		SUM(level2.OptionsExercised) AS exercised,SUM(level2.PendingForApproval) AS PendingForApproval, SUM(level2.ValueOfGrantedOptions) AS valueForGrant, SUM(level2.ValueOfVestedOptions) AS valueForVested, SUM(level2.ValueOfUnvestedOptions) AS valueForUnvested,
		SUM(level2.OptionsCancelled) AS cancelled, SUM(level2.OptionsLapsed) AS lapsed,SUM(UnvestedCancelled) As UnvestedCancelled ,Sum(VestedCancelled ) As VestedCancelled
	FROM
		#FINALDATA level2 WHERE(@IS_EGRANTS_ENABLED=1 AND level2.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		level2.MIT_ID,level2.SchemeId,level2.CurrencyAliAS	
	--level 2 ends here

	--level 3 start from here
	
	DECLARE @level3 TABLE
	(
		MIT_ID INT , SchemeTitle nvarchar(150),[date] datetime, grantId nvarchar(100), acceptance nchar(1), currency varchar(20), exercisePrice numeric(10,2),
		granted NUMERIC(18,0), vested NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
		valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0), VestingType VARCHAR(100),UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2)
	)
	INSERT INTO @level3
	SELECT DISTINCT 
		level3.MIT_ID,level3.SchemeId,level3.GrantDate AS [date], level3.GrantOptionId AS grantId, level3.LetterAcceptanceStatus AS acceptance, level3.CurrencyAlias AS currency, level3.ExercisePrice AS exercisePrice,
		SUM(level3.OptionsGranted) AS granted, SUM(level3.OptionsVested) AS vested, SUM(level3.OptionsUnVested) AS unvested, SUM(level3.OptionsExercised) AS exercised,SUM(level3.PendingForApproval) AS PendingForApproval, 
		SUM(level3.ValueOfGrantedOptions) AS valueForGrant,
		SUM(level3.ValueOfVestedOptions) AS valueForVested, SUM(level3.ValueOfUnvestedOptions) AS valueForUnvested, SUM(level3.OptionsCancelled) AS cancelled, SUM(level3.OptionsLapsed) AS lapsed, level3.VestingType AS VestingType
		,SUM(UnvestedCancelled) As UnvestedCancelled ,Sum(VestedCancelled ) As VestedCancelled
	FROM
		#FINALDATA level3 WHERE(@IS_EGRANTS_ENABLED=1 AND level3.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		level3.MIT_ID,level3.SchemeId,level3.GrantDate, level3.GrantOptionId,level3.LetterAcceptanceStatus, level3.CurrencyAlias,level3.ExercisePrice, level3.VestingType
	--level 3 ends here

	--level 4 start from here
	DECLARE @level4 TABLE
	(
		MIT_ID INT , SchemeTitle nvarchar(150),grantDate datetime, grantId nvarchar(100),vestingDate datetime, granted NUMERIC(18,0),  vested NUMERIC(18,0), unvested numeric(18,0),
		exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2),valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0),
		expiryDate datetime,VestingType VARCHAR(100),UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2),Totalgranted NUMERIC(18,0) ,GrantLegId NUMERIC(18,0), NoOfOptions NUMERIC(18,0)
	)
	INSERT INTO @level4
	SELECT DISTINCT 
		vesting.MIT_ID, vesting.SchemeId,vesting.GrantDate, vesting.GrantOptionId, vesting.VestingDate AS vestingDate, SUM(vesting.OptionsGranted) AS granted, SUM(vesting.OptionsVested) AS vested, 
		SUM(vesting.OptionsUnVested) AS unvested, SUM(vesting.OptionsExercised) AS exercised, SUM(vesting.PendingForApproval) AS PendingForApproval, 
		SUM(vesting.ValueOfGrantedOptions) AS valueForGrant,SUM(vesting.ValueOfVestedOptions) AS valueForVested,SUM(vesting.ValueOfUnvestedOptions) AS valueForUnvested,SUM(vesting.OptionsCancelled) AS cancelled,
		SUM(vesting.OptionsLapsed) AS lapsed,vesting.ExpiryDate AS expiryDate,VestingType,SUM(UnvestedCancelled) As UnvestedCancelled ,Sum(VestedCancelled ) As VestedCancelled,0 As Totalgranted ,vesting.GrantLegId,IsNULL(vesting.NoOfOptions,0)
	FROM
		#FINALDATA vesting WHERE(@IS_EGRANTS_ENABLED=1 AND vesting.GrantOptionId in(select LetterCode from GrantAccMassUpload WHERE MailSentStatus=1 AND MailSentDate IS NOT NULL and EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		vesting.MIT_ID, vesting.SchemeId,vesting.GrantDate,vesting.GrantOptionId, vesting.VestingDate,vesting.GrantLegId,vesting.NoOfOptions,	
		vesting.ExpiryDate, vesting.VestingType
	HAVING SUM(vesting.OptionsGranted) NOT IN (0)
	--level 4 ends here
	
	Update @level4
	SET Totalgranted=T.TotalGranted
	FROM @level4 as L4 Inner join (Select Sum(granted) As TotalGranted,grantId from @level4
	GROUP BY MIT_ID,SchemeTitle,GrantDate, grantId,grantDate) As T on L4.grantId=T.grantId

		


	SELECT distinct * FROM @level1 as level1 --FOR json AUTO) as level1
	SELECT distinct * FROM @level2 as level2 --FOR json AUTO) as level2
	SELECT distinct MIT_ID,SchemeTitle,REPLACE(CONVERT(VARCHAR, ISNULL([date],''),106),' ','-') AS [date], grantId, 
	CASE WHEN @IS_EGRANTS_ENABLED=1 THEN
		CASE WHEN (ISNULL(acceptance,'')='' OR ISNULL(acceptance,'')='P') AND  CONVERT(DATE,(SELECT TOP 1 GAMU.LastAcceptanceDate FROM GrantAccMassUpload GAMU WHERE GAMU.LetterCode=grantId)) < CONVERT(DATE,GETDATE()) THEN 'Expired'
			 WHEN ISNULL(acceptance,'')='P' THEN 'Pending'
			 WHEN ISNULL(acceptance,'')='A' THEN 'Accepted'
			 WHEN ISNULL(acceptance,'')='R' THEN 'Rejected'
			 ELSE 'Pending' END
	ELSE 'Not Applicable' 
	END AS acceptance, 
		 currency,  exercisePrice,
		 Sum(granted) as granted, Sum(vested) as vested,Sum(unvested) as unvested, Sum(exercised) as exercised,Sum(PendingForApproval) As PendingForApproval, Sum(valueForGrant) As valueForGrant,Sum(valueForVested) AS valueForVested, Sum(valueForUnvested) AS valueForUnvested, Sum(cancelled) as cancelled, Sum(lapsed) As lapsed ,Sum( UnvestedCancelled) As UnvestedCancelled , Sum(VestedCancelled) as VestedCancelled FROM @level3 as level3 --FOR json AUTO) as level3
	Group by MIT_ID,SchemeTitle,grantId,acceptance,REPLACE(CONVERT(VARCHAR, ISNULL([date],''),106),' ','-'),currency
	, exercisePrice
	
	
	IF @CompanyID='Embassy'
	BEGIN
			SELECT level4.MIT_ID, level4.SchemeTitle ,REPLACE(CONVERT(VARCHAR, ISNULL(level4.GrantDate,''),106),' ','-')AS GrantDate, 
			level4.grantId, REPLACE(CONVERT(VARCHAR, ISNULL(level4.vestingDate,''),106),' ','-') AS vestingDate, level4.granted,  
			level4.vested,  level4.unvested, level4.exercised, level4.PendingForApproval, level4.valueForGrant,
			level4.valueForVested, level4.valueForUnvested, level4.cancelled, level4.lapsed,	
			CASE WHEN IS_AUTO_EXERCISE_ALLOWED=1  	
					THEN 'NA'  ELSE 
					REPLACE(CONVERT(VARCHAR, ISNULL(level4.expiryDate,''),106),' ','-') END AS expiryDate, level4.VestingType ,UnvestedCancelled, VestedCancelled,Totalgranted,CASE WHEN (granted >0) THEN Convert(Numeric(18,2), Round(((granted/Totalgranted)*100),2)) Else Convert(Numeric(18,2),0) END AS VestingDue
	, CASE WHEN (granted >0) THEN Convert(Numeric(18,2), Round((((vested+exercised +PendingForApproval+lapsed+VestedCancelled)/Totalgranted)*100),2)) Else Convert(Numeric(18,2),0) END AS [ActualVestingtilldate]

					FROM @level4 as level4  INNER JOIN SCHEME S ON level4.SchemeTitle=S.SchemeId 
					--WHERE S.IS_AUTO_EXERCISE_ALLOWED = 1--FOR json AUTO) as level4
					ORDER BY level4.vestingDate
			END
			ELSE
			BEGIN
					SELECT level4.MIT_ID, level4.SchemeTitle ,REPLACE(CONVERT(VARCHAR, ISNULL(level4.GrantDate,''),106),' ','-')AS GrantDate, level4.grantId, REPLACE(CONVERT(VARCHAR, ISNULL(level4.vestingDate,''),106),' ','-') AS vestingDate, level4.granted,  level4.vested, level4.unvested, level4.exercised, level4.PendingForApproval, level4.valueForGrant, 
					  level4.valueForVested, level4.valueForUnvested, level4.cancelled, level4.lapsed,		REPLACE(CONVERT(VARCHAR, ISNULL(level4.expiryDate,''),106),' ','-')  AS expiryDate, level4.VestingType ,UnvestedCancelled, VestedCancelled,Totalgranted,CASE WHEN (granted >0) THEN Convert(Numeric(18,2), Round(((granted/Totalgranted)*100),2)) Else Convert(Numeric(18,2),0) END AS VestingDue
	, CASE WHEN (granted >0) THEN Convert(Numeric(18,2), Round((((vested+exercised +PendingForApproval+lapsed+VestedCancelled)/Totalgranted)*100),2)) Else Convert(Numeric(18,2),0) END AS [ActualVestingtilldate],NoOfOptions
					FROM @level4 as level4 
					ORDER BY level4.vestingDate ,level4.VestingType
					
			END

		DROP TABLE #EMPLOYEE_TEMP_DATA  
		DROP TABLE #OptionValueReport
		DROP TABLE #CancelledDataFromGrantLeg
		
		SET NOCOUNT OFF;
	END
GO
