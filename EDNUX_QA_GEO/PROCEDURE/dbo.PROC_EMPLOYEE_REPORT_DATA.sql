/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_REPORT_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_REPORT_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_REPORT_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_REPORT_DATA] (@EmployeeId VARCHAR(50), @DisplayPram VARCHAR(10) = NULL, @DateParm DATE = NULL )
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @ORDER_BY AS VARCHAR(1000)
	
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
		MIT_ID INT, LetterAcceptanceStatus NCHAR(1), CancellationReason NVARCHAR(500)
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
	EXEC ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )	
	--PRINT ( @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY )
	DROP TABLE #EMPLOYEE_TEMP_DATA  
	DROP TABLE #OptionValueReport
	DROP TABLE #CancelledDataFromGrantLeg
	
	SET NOCOUNT OFF;
END
GO
