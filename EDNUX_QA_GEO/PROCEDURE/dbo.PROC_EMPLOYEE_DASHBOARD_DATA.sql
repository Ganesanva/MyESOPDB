/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_DASHBOARD_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_DASHBOARD_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_DASHBOARD_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_DASHBOARD_DATA] 
	@EmployeeId VARCHAR(50),
	@Dashboard_Type VARCHAR(50),
	@DisplayPram VARCHAR(10) = NULL, 
	@DateParm DATE = NULL,
	@FMVTrend_Flag char(2) = NULL
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @IS_COMPANY_WITH_FMV AS CHAR(1) = (SELECT  UPPER(FMV_BASEDON) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @ORDER_BY AS VARCHAR(1000)
	Declare @CompanyID varchar(50)
	SELECT @CompanyID = DB_NAME()
	DECLARE @CheckUnderWaterConfig VARCHAR(5)
	DECLARE @File_UploadType AS CHAR(1)
	DECLARE @FMV_BASEDON char(1)  
	DECLARE @DATE_ DATETIME
	DECLARE @AnnuncerName AS NVARCHAR(200)
	DECLARE @AnnuncerDesignation AS  NVARCHAR(200)
	DECLARE @AnnuncementText AS NVARCHAR(1000)

	
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
		INSTRUMENT_NAME NVARCHAR (100), CurrencyName NVARCHAR (100), COST_CENTER VARCHAR (250), Department VARCHAR (250),
		Location VARCHAR (100), EmployeeDesignation VARCHAR (100), Grade VARCHAR (50), ResidentialStatus VARCHAR (50), CountryName VARCHAR (100), CurrencyAlias VARCHAR (20),
		MIT_ID INT, LetterAcceptanceStatus NCHAR(1), CancellationReason NVARCHAR(500) ,FMV  NUMERIC(18,2) NULL,NoOfOptions NUMERIC(18,0)
		/* ,OptionRatioMultiplier NUMERIC(18,9) NULL ,OptionRatioDivisor NUMERIC(18,9) NULL */
	)

 CREATE TABLE #TEMPFMVTREND_SCHEME_DATA
 (			
		FMV NUMERIC(18,9),FMV_FromDate DATETIME,FMV_Todate DATETIME,CreatedBy NVARCHAR(100),Updatedon DATETIME,Scheme_Id VARCHAR(50)
 )

CREATE TABLE #TEMPEMPLOYEEWISE_SCHEME
 (			
		SchemeId VARCHAR(50),EmployeeID VARCHAR(50), CurrencyAlias VARCHAR (20)
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
		INSTRUMENT_NAME , CurrencyName , COST_CENTER , Department, Location , EmployeeDesignation , Grade, ResidentialStatus , CountryName, CurrencyAlias,
		MIT_ID, CancellationReason		
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
		
			DECLARE @ACSID INT	,@ACC_STATUS INT
			SET @ACSID = (SELECT ACSID FROM OGA_CONFIGURATIONS)

			IF @ACSID = 2
			  BEGIN				
				UPDATE GrantAccMassUpload
				SET 
				LetterAcceptanceDate=CreatedOn,
				LetterAcceptanceStatus = 'A',
				LastUpdatedBy = 'Admin',
				LastUpdatedOn=GETDATE()
				WHERE LastAcceptanceDate <= GETDATE() 
				AND LetterAcceptanceStatus = 'P'
				 
			  END
	ELSE IF( @ACSID=3)
	BEGIN
	UPDATE GrantAccMassUpload
	SET
	LetterAcceptanceDate=GrantDate,
	LastUpdatedBy = 'Admin',
	LastUpdatedOn=GETDATE()
	WHERE LetterAcceptanceStatus = 'A'AND LetterAcceptanceDate IS NULL
	END

	
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
	--SELECT @ToDate
	IF (@ISLISTED = 'Y')	
		SET @ClosePrice = (SELECT SharePrices.ClosePrice FROM SharePrices WHERE (SharePrices.PriceDate = (SELECT Max(PriceDate) FROM SharePrices)))
	
	
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
	IF (@ISLISTED = 'Y')	
BEGIN
	UPDATE TD SET 
		ValueOfGrantedOptions = CASE WHEN TD.OptionsGranted * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsGranted * (@ClosePrice - TD.ExercisePrice) END,
		ValueOfVestedOptions = CASE WHEN TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) END,
		ValueOfUnvestedOptions = CASE WHEN TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice)END
		FROM 
		#EMPLOYEE_TEMP_DATA AS TD 

END
ELSE
BEGIN


 SELECT  @FMV_BASEDON = UPPER(FMV_BASEDON) FROM CompanyParameters
 
   IF(@FMV_BASEDON = 'S')
   BEGIN	
   UPDATE TD SET 
        FMV =  FMVUL.FMV,
		ValueOfGrantedOptions = CASE WHEN TD.OptionsGranted * (FMVUL.FMV - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsGranted * (FMVUL.FMV - TD.ExercisePrice) END,
		ValueOfVestedOptions = CASE WHEN TD.OptionsVested * (FMVUL.FMV - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsVested * (FMVUL.FMV - TD.ExercisePrice) END,
		ValueOfUnvestedOptions = CASE WHEN TD.OptionsUnVested * (FMVUL.FMV - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsUnVested * (FMVUL.FMV - TD.ExercisePrice)END
		FROM 
		#EMPLOYEE_TEMP_DATA AS TD 
		Inner JOIN FMVForUnlisted AS FMVUL
		ON FMVUL.Scheme_Id = TD.SchemeId
		 WHERE (CONVERT(DATE,FMVUL.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVUL.FMV_Todate) >= CONVERT(DATE,@ToDate))

   END
   ELSE 
   BEGIN

			IF EXISTS((SELECT FMV FROM FMVForUnlisted WHERE (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))  and  isnull(Scheme_Id,'')='')  )
				SET @ClosePrice = (SELECT FMV FROM FMVForUnlisted WHERE  isnull(Scheme_Id,'')='' AND   (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))) 
			ELSE
			    SET @ClosePrice = 0

				--select 1
				--select @ClosePrice
				--select 1

			UPDATE TD SET
			FMV = @ClosePrice ,
			ValueOfGrantedOptions = CASE WHEN TD.OptionsGranted * (@ClosePrice- TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsGranted * (@ClosePrice - TD.ExercisePrice) END,
			ValueOfVestedOptions = CASE WHEN TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsVested * (@ClosePrice - TD.ExercisePrice) END,
			ValueOfUnvestedOptions = CASE WHEN TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice) < 0 THEN 0 ELSE TD.OptionsUnVested * (@ClosePrice - TD.ExercisePrice)END
			FROM 
			#EMPLOYEE_TEMP_DATA AS TD ,FMVForUnlisted AS FMVUL
			WHERE (CONVERT(DATE,FMVUL.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVUL.FMV_Todate) >= CONVERT(DATE,@ToDate))
   END
   
END

	
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

				UPDATE ETD
			SET 
				ETD.NoOfOptions = GAMUD.NoOfOptions
				
			FROM
				GrantAccMassUpload AS GAM 
				INNER JOIN GrantAccMassUploadDet as GAMUD ON GAMUD.GAMUID=GAM.GAMUID 
		INNER JOIN #EMPLOYEE_TEMP_DATA AS ETD ON ETD.GrantOptionId=GAM.LetterCode AND ETD.GrantLegId=GAMUD.VestPeriod and
		SUBSTRING(ETD.VestingType,1,1) = GAMUD.VestingType
		
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
		COST_CENTER VARCHAR (250), 
		Department VARCHAR (250), 
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
	Print 'ss'
	print @SQL_QUERY + @WHERE_CONDITION + @ORDER_BY
		--using admin setting wise My grant widget hide or display
	update DASHBOARD_DASHBOARD_WIDGET_TYPE set IsActiveNewUI=@IS_EGRANTS_ENABLED where WIDGET_TYPE='NewUi OGA Status'
	   
	 IF Exists(SELECT TOP 1 DC.EmployeeId FROM DeferredCashGrant AS DC						
					    INNER JOIN UserMaster AS UM ON DC.EmployeeId = UM.EmployeeId 
						INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						WHERE (UM.UserId = @EmployeeId AND @EmployeeId NOT IN(Select EmployeeID from GrantOptions)) ORDER BY EM.DateOfTermination DESC)
                        BEGIN
						  SELECT DCM.*,TemplateName FROM  DASHBOARD_CONTROLS_MASTER DCM, DASHBOARD_DASHBOARD_TYPE DDT, 
							DASHBOARD_DASHBOARD_WIDGET_TYPE DDWT
							WHERE DCM.WIDGET_ID=DDWT.WIDGET_ID and DCM.DASHBOARD_TYPE=DDT.DASHBOARD_ID
							and DCM.DASHBOARD_TYPE=@Dashboard_Type and ISNULL(DDWT.IsActiveNewUI,0)=1
							AND UPPER(DCM.CONTROL_ID) IN('CTL_CASHPLAN','Ctl_CashPlan_Report','Ctl_NewUiBanner_Top_Right','Ctl_NewUiBanner_Top_Left') AND WidgetSequence > 0 ORDER BY WidgetSequence
						END

						ELSE

						BEGIN
						  SELECT DCM.*,TemplateName FROM  DASHBOARD_CONTROLS_MASTER DCM, DASHBOARD_DASHBOARD_TYPE DDT, 
							DASHBOARD_DASHBOARD_WIDGET_TYPE DDWT
							WHERE DCM.WIDGET_ID=DDWT.WIDGET_ID 
							and DCM.DASHBOARD_TYPE=DDT.DASHBOARD_ID
							and DCM.DASHBOARD_TYPE=@Dashboard_Type and ISNULL(DDWT.IsActiveNewUI,0)=1 AND WidgetSequence > 0 ORDER BY WidgetSequence
						END



	--SELECT DCM.*,TemplateName,1 FROM  DASHBOARD_CONTROLS_MASTER DCM, DASHBOARD_DASHBOARD_TYPE DDT, 
	--DASHBOARD_DASHBOARD_WIDGET_TYPE DDWT
	--WHERE DCM.WIDGET_ID=DDWT.WIDGET_ID 
	--and DCM.DASHBOARD_TYPE=DDT.DASHBOARD_ID
	--and DCM.DASHBOARD_TYPE=@Dashboard_Type and ISNULL(DDWT.IsActiveNewUI,0)=1

	if(@Dashboard_Type=1)
	BEGIN
	SELECT SUM(isnull(ValueOfVestedOptions,0)+isnull(ValueOfUnvestedOptions,0)) as ValueOfOutstanding ,
	isNULL(INSTRUMENT_NAME,'') as INSTRUMENT_NAME,isNULL(CurrencyAlias,'') as CurrencyAlias FROM   #EMPLOYEE_INSTRUMENT_DATA 
	WHERE Employeeid=@EmployeeId
	GROUP BY INSTRUMENT_NAME ,CurrencyAlias

	EXEC PROC_GET_EMP_PROFILE_PENDING_TASK_DETAILS @EmployeeId

	EXEC PROC_GET_EMP_PROFILE_CALCULATE_DETAILS @EmployeeId
	   
	if(1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
	BEGIN
	if( (SELECT Count (GrantOptionId)
				from #EMPLOYEE_INSTRUMENT_DATA	)>0)
				BEGIN
		SELECT * FROM( 	SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary') AS CONTROL_MASTER_ID, ISNULL(SUM(OptionsVested),0) OptionsVested ,isnull(SUM(OptionsUnVested),0) OptionsUnVested  ,
			isnull(SUM(OptionsExercised),0) OptionsExercised ,
			isnull(SUM(PendingForApproval),0) PendingForApproval,
			isnull(SUM(OptionsCancelled),0)  OptionsCancelled,
			isnull(SUM(OptionsLapsed),0) OptionsLapsed, INSTRUMENT_NAME,MIT_ID  FROM #EMPLOYEE_TEMP_DATA ETD 
					WHERE (ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA ))
				GROUP BY MIT_ID,INSTRUMENT_NAME,CurrencyAlias
			union
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary') AS CONTROL_MASTER_ID, isnull(SUM(OptionsVested),0) OptionsVested ,
			isnull(SUM(OptionsUnVested),0) OptionsUnVested  ,
			isnull(SUM(OptionsExercised),0) OptionsExercised ,isnull(SUM(PendingForApproval),0) PendingForApproval,
			isnull(SUM(OptionsCancelled),0)  OptionsCancelled,
			isnull(SUM(OptionsLapsed) ,0) OptionsLapsed, 'All' as INSTRUMENT_NAME,'0' as MIT_ID FROM #EMPLOYEE_TEMP_DATA ETD 
				WHERE (ETD.GrantOptionId in(SELECT GrantOptionId 
				from #EMPLOYEE_INSTRUMENT_DATA	)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED 
				AND @IS_EGRANTS_ENABLED=0)
				) as a
	
	END
	END 


	if(1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary_Scheme') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
	BEGIN
	if( (SELECT Count (GrantOptionId)	from #EMPLOYEE_INSTRUMENT_DATA	)>0)
	BEGIN
			SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary_Scheme') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(PendingForApproval) PendingForApproval,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed, SchemeId  FROM #EMPLOYEE_TEMP_DATA ETD 
					WHERE (ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA ))
				GROUP BY SchemeId,CurrencyAlias
			union
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_GrantSummary_Scheme') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(PendingForApproval) PendingForApproval,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed, 'All' as SchemeId FROM #EMPLOYEE_TEMP_DATA ETD 
				WHERE (ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA	)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED 
				AND @IS_EGRANTS_ENABLED=0)
				
	END
	END 



		IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiMyWealthReport')  
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
			SELECT * FROM
			(
				SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiMyWealthReport')   AS CONTROL_MASTER_ID,  
				ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) AS [ValueOfVested],
				ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0) AS [ValueOfUnvested],
				INSTRUMENT_NAME,
				CurrencyAlias,
				(ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0)+ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfOutstanding]
				FROM #EMPLOYEE_TEMP_DATA ETD WHERE (ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA ))
				GROUP BY MIT_ID,INSTRUMENT_NAME,CurrencyAlias
			)X 
		END

			IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiMyWealthReportSheme')  
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
			SELECT * FROM
			(
				SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiMyWealthReportSheme')   AS CONTROL_MASTER_ID,  
				ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0) AS [ValueOfVested],
				ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0) AS [ValueOfUnvested],
				SchemeId,
				CurrencyAlias,
				(ROUND(SUM(ISNULL(ValueOfVestedOptions,0)),0)+ROUND(SUM(ISNULL(ValueOfUnvestedOptions,0)),0)) AS [ValueOfOutstanding]
				FROM #EMPLOYEE_TEMP_DATA ETD WHERE (ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA ))
				GROUP BY SchemeId,CurrencyAlias
			)X 
		END


		IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiExerciseTransactionReport')  
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
			
				SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiExerciseTransactionReport')  AS CONTROL_MASTER_ID, X.[ExerciseDate],X.[ExerciseNumber],PlanName,
				FORMAT(DateOfGrant, 'dd-MMM-yyyy', 'en-us')AS DateOfGrant,X.[ExercisedQuantity],
										 (SELECT DISPLAY_NAME  FROM FN_GET_EXERCISE_STEP_STATUS(X.ExerciseNumber )) AS   [PendingFor],X.PendingStatus as ExerciseStep,
		CNT,X.[ExerciseNumber] as exerciseno,X.MIT_ID
		FROM
		(
				SELECT FORMAT(ExerciseDate, 'dd-MMM-yyyy', 'en-us')AS [ExerciseDate],
				ISNULL(ExerciseNo,0) AS [ExerciseNumber],
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

		IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiOGA_Status') 
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
			DECLARE @STATUS  AS VARCHAR(5)
			SELECT @STATUS = ACSID FROM OGA_CONFIGURATIONS
				SELECT 
				 (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiOGA_Status')  AS CONTROL_MASTER_ID,GAMUID, SchemeName, ExercisePrice,NoOfOptions,LetterCode, replace(convert(NVARCHAR, GrantDate, 106), ' ', '-') as GrantDate,  FORMAT(LetterAcceptanceDate, 'dd-MMM-yyyy hh:mm tt', 'en-US') AS LetterAcceptanceDate, 
				replace(convert(NVARCHAR, LastAcceptanceDate, 106), ' ', '-') as LastAcceptanceDate,
				CASE
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'Expired' 
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'Pending for Acceptance'
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'Pending for Acceptance / Rejection'
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'Accepted' 
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'Rejected'			
					ELSE 'Pending for Acceptance / Rejection' 
				END LetterAcceptanceStatus,			
					CASE WHEN CONVERT(DATE, GETDATE()) >= CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) THEN 1 ELSE 0 END AS ShowActionLinks,
				CONVERT(DATE, DATEADD(DAY, NoActionTill, CONVERT(DATE, GrantDate))) AS ActionAfter,
				CASE
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'E' 
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'PA'
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'PAR'
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'A' 
					WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'R'			
					ELSE 'NULL' 
				END LetterAcceptanceStatusFlag,
				@STATUS AS OGA_Configurations_Status,
				INS.MIT_ID,INS.INSTRUMENT_NAME,
				CASE
				WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'a' 
				WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS = '4' THEN 'd'
				WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS <> '4' THEN 'd'
				WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'c' 
				WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'b'			
				ELSE 'NULL' 
			END LetterAcceptanceStatusFlagorderbyonly
			FROM GrantAccMassUpload INNER JOIN Scheme sc on sc.SchemeId=GrantAccMassUpload.SchemeName
			INNER JOIN MST_INSTRUMENT_TYPE INS on INS.MIT_ID=sc.MIT_ID
			WHERE GrantAccMassUpload.EmployeeID = @EmployeeId
			AND MailSentStatus = 1
			AND MailSentDate IS NOT NULL
			ORDER BY LetterAcceptanceStatusFlagorderbyonly DESC ,cast(GrantDate  as date) DESC

		END

		IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MyActivities') 
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
		Select * ,CASE 
		WHEN  CreateDate  >= GETDATE() THEN 'Upcoming' 
		ELSE 'Past' 
		END AS Status, (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MyActivities')  AS CONTROL_MASTER_ID from ActivitiesMAster where ActivitiesMAster.EmployeeID=@EmployeeId
		END

	IF EXISTS(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID in ((SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Left')  ,(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Right') )
	AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID)
	BEGIN
			
		SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Left')  AS CONTROL_MASTER_ID, REPLACE(ISNULL(WIDGET_HTML_CONTENT,''),'@CompanyID',@CompanyID) as Content,  REPLACE(ISNULL(concat(concat(replace((SELECT SiteUrl from companymaster),'Login.aspx',''),'Uploads/@CompanyID/HomeBoxes/@CompanyID'), '.jpg'),''), '@CompanyID',@CompanyID) as BannerPath
		FROM DASHBOARD_CONTROLS_MASTER DCMR WHERE DCMR.CONTROL_MASTER_ID = (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Left')
		UNION ALL
		SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Right')  AS CONTROL_MASTER_ID, REPLACE(ISNULL(WIDGET_HTML_CONTENT,''),'@CompanyID',@CompanyID) as Content,  REPLACE(ISNULL(concat(concat(replace((SELECT SiteUrl from companymaster),'Login.aspx',''),'Uploads/@CompanyID/HomeBoxes/'), 'CEO Msg.jpg'),''), '@CompanyID',@CompanyID) as BannerPath
		FROM DASHBOARD_CONTROLS_MASTER DCM WHERE DCM.CONTROL_MASTER_ID =  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiBanner_Top_Right')
	END
		IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_CompanyAnnouncement')
			AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
		    Select @AnnuncerName=AnnuncerName,@AnnuncerDesignation=AnnuncerDesignation,@AnnuncementText=AnnuncementText from  MST_CompanyAnnouncement
			SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_OGA_CompanyAnnouncement') AS CONTROL_MASTER_ID,'Annuncer.png' AS AnnuncerImageName, 
				   REPLACE(ISNULL(concat(concat(replace((SELECT SiteUrl from companymaster),'Login.aspx',''),'Uploads/@CompanyID/'), 'Annuncer.png'),''), '@CompanyID',@CompanyID) as AnnuncerImagePath,
				  @AnnuncerName AS AnnuncerName,@AnnuncerDesignation AS AnnuncerDesignation,@AnnuncementText AS AnnuncementText 

		END

	if(1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
	BEGIN
			if( (SELECT Count (GrantOptionId)
				from #EMPLOYEE_INSTRUMENT_DATA	)>0)
				BEGIN
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed , SUM(OptionsVested+OptionsUnVested) AS TotalUnitGrants,
			ISNULL(SUM(ValueOfVestedOptions),0) ValueOfVestedOptions, SUM(PendingForApproval) PendingForApproval,
		   ISNULL( SUM(ValueOfUnvestedOptions),0) ValueOfUnvestedOptions, ISNULL( SUM(ValueOfVestedOptions+ValueOfUnvestedOptions),0) TotalValue,
			'All' as INSTRUMENT_NAME, '0' as MIT_ID
			FROM #EMPLOYEE_TEMP_DATA ETD 
				WHERE ( ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			UNION
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed , SUM(OptionsVested+OptionsUnVested) AS TotalUnitGrants,
			ISNULL(SUM(ValueOfVestedOptions),0) ValueOfVestedOptions, SUM(PendingForApproval) PendingForApproval,
		   ISNULL( SUM(ValueOfUnvestedOptions),0) ValueOfUnvestedOptions,ISNULL( SUM(ValueOfVestedOptions+ValueOfUnvestedOptions),0) TotalValue,
			 INSTRUMENT_NAME,MIT_ID
			FROM #EMPLOYEE_TEMP_DATA ETD 
			WHERE ( ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			Group by INSTRUMENT_NAME,MIT_ID
	END
	END

	if(1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport_Scheme') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
	BEGIN
			
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport_Scheme') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed , SUM(OptionsVested+OptionsUnVested) AS TotalUnitGrants,
			ISNULL(SUM(ValueOfVestedOptions),0) ValueOfVestedOptions, SUM(PendingForApproval) PendingForApproval,
		   ISNULL( SUM(ValueOfUnvestedOptions),0) ValueOfUnvestedOptions, ISNULL( SUM(ValueOfVestedOptions+ValueOfUnvestedOptions),0) TotalValue,
			'All' as SchemeId
			FROM #EMPLOYEE_TEMP_DATA ETD 
				WHERE ( ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			UNION
			SELECT  (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MYSummaryReport_Scheme') AS CONTROL_MASTER_ID, SUM(OptionsVested) OptionsVested ,SUM(OptionsUnVested) OptionsUnVested  ,
			SUM(OptionsExercised) OptionsExercised ,SUM(OptionsCancelled)  OptionsCancelled,
			SUM(OptionsLapsed) OptionsLapsed , SUM(OptionsVested+OptionsUnVested) AS TotalUnitGrants,
			ISNULL(SUM(ValueOfVestedOptions),0) ValueOfVestedOptions, SUM(PendingForApproval) PendingForApproval,
		   ISNULL( SUM(ValueOfUnvestedOptions),0) ValueOfUnvestedOptions,ISNULL( SUM(ValueOfVestedOptions+ValueOfUnvestedOptions),0) TotalValue,
			 SchemeId
			FROM #EMPLOYEE_TEMP_DATA ETD 
			WHERE ( ETD.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA)) 
				OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0)
			Group by SchemeId
	
	END

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where CONTROL_ID='Ctl_CashPlan') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID ))
    BEGIN
	  IF EXISTS(Select 1 From DeferredCashGrant where EmployeeId = @EmployeeID)	  
		BEGIN			
			 SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_CashPlan') AS CONTROL_MASTER_ID, 
			 ISNULL(SUM(GrantAmount),0) AS 'Total_Value_Granted', 
			 ISNULL(SUM(GrossPayoutAmount),0) AS 'Payout_Till_Date',
			  --CASE WHEN  ((Isnull(SUM(GrantAmount),0)-ISnull(SUM(GrossPayoutAmount),0)-isnull(SUM(PayOutRevesion),0))) < 0
			  -- THEN 0
			  -- ELSE ((Isnull(SUM(GrantAmount),0)-ISnull(SUM(GrossPayoutAmount),0)-isnull(SUM(PayOutRevesion),0))) end
			  -- AS 'PayOut_In_Further' 	
			 SUM(CASE WHEN (GrantAmount-GrossPayoutAmount-PayOutRevesion)>=0 THEN (GrantAmount-GrossPayoutAmount-PayOutRevesion) ELSE 0 END) AS 'PayOut_In_Further'		
			 FROM DeferredCashGrant WHERE EmployeeID in(@EmployeeID)
		END		
		
	END

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where CONTROL_ID='Ctl_QuickLinks') AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID ))
    BEGIN	 	
		SELECT (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_QuickLinks') AS CONTROL_MASTER_ID,DESCRIPTION,URL FROM WidgetQuicklinks where Active =1
	END
    
	END

	if(@Dashboard_Type=3)
	BEGIN
	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_MarketTrend')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
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

	
			SELECT 'Ctl_MarketTrend_NSE' CONTROL_MASTER_ID,  CONVERT(VARCHAR(9), PriceDate, 6) AS [DATE],ClosePrice ,@IsNYSE AS IsNYSE,@CurrencyAlias AS CurrencyAlias,@ListedYN AS IsListed 
			FROM FMVSharePrices
			WHERE DATEDIFF(DAY, PriceDate, GETDATE()) < 90 
			AND StockExchange = 'N' AND @ListedYN='Y'
			ORDER BY PriceDate ASC 

			SELECT  'Ctl_MarketTrend_BSE' CONTROL_MASTER_ID, CONVERT(VARCHAR(9), PriceDate, 6) AS [DATE],ClosePrice ,@IsNYSE AS IsNYSE,@CurrencyAlias AS CurrencyAlias,@ListedYN AS IsListed
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

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where 
	CONTROL_ID='Ctl_FMVTrend')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
		
		SELECT @FMV_BASEDON = FMV_BASEDON FROM CompanyParameters  
	

	    INSERT INTO #TEMPEMPLOYEEWISE_SCHEME(SchemeId,EmployeeID,CurrencyAlias)
		(SELECT DISTINCT GOP.SchemeId,EM.EmployeeID,ETD.CurrencyAlias FROM EmployeeMaster  EM   INNER JOIN GrantOptions GOP ON em.EmployeeID = GOP.EmployeeId , #EMPLOYEE_TEMP_DATA ETD 
		WHERE EM.EmployeeID = @EmployeeId)


		IF(@FMV_BASEDON = 'S')
		BEGIN
		IF(@FMVTrend_Flag = 'EF')
	    BEGIN
	        INSERT INTO  #TEMPFMVTREND_SCHEME_DATA (FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id)
			SELECT FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id  FROM FMVForUnlisted FMVU
			INNER JOIN #TEMPEMPLOYEEWISE_SCHEME TES ON TES.SchemeId = FMVU.Scheme_Id
			WHERE Scheme_Id IS NOT NULL		
			 
			ORDER BY FMVU.FMV_Todate ASC

	   END
	   ELSE
	   BEGIN
           SET  @DATE_ =  (SELECT DATEADD(year,-3,GETDATE()) )

			INSERT INTO  #TEMPFMVTREND_SCHEME_DATA (FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id)
			SELECT FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id  FROM FMVForUnlisted FMVU
			INNER JOIN #TEMPEMPLOYEEWISE_SCHEME TES ON TES.SchemeId = FMVU.Scheme_Id
			WHERE Scheme_Id IS NOT NULL	
			 AND  (CONVERT(DATE,FMV_FromDate) >= CONVERT(DATE,@DATE_) )
			ORDER BY FMVU.FMV_Todate ASC
			
	    END		 
		END
		ELSE	
		BEGIN
		IF(@FMVTrend_Flag = 'EF')
	    BEGIN
			INSERT INTO #TEMPFMVTREND_SCHEME_DATA
			(FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id)
			SELECT FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id  FROM FMVForUnlisted 
		    WHERE  isnull(Scheme_Id,'')=''
			ORDER BY FMV_Todate

		END
		ELSE
		BEGIN
		    SET  @DATE_ =  (SELECT DATEADD(year,-3,GETDATE()) )

		    INSERT INTO #TEMPFMVTREND_SCHEME_DATA
			(FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id)
			SELECT FMV,FMV_FromDate,FMV_Todate,CreatedBy,Updatedon,Scheme_Id  FROM FMVForUnlisted 
		   WHERE  isnull(Scheme_Id,'')=''
			AND  (CONVERT(DATE,FMV_FromDate) >= CONVERT(DATE,@DATE_) )
			ORDER BY FMV_Todate

		END
			
						
		END
	END


	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_View_Download')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
--SELECT 'Ctl_View_Download_Summary' CONTROL_MASTER_ID,'MY Summary Report' as ReportName

	--Summary Data------------


	SELECT * INTO #FINALDATA FROM
	(
		SELECT MIT_ID, INSTRUMENT_NAME, SchemeId, GrantDate, GrantOptionId, LetterAcceptanceStatus, 
		CurrencyAlias, ExercisePrice, VestingDate, OptionsGranted, 
		OptionsVested, OptionsUnVested, PendingForApproval,OptionsExercised, ValueOfGrantedOptions, 
		ValueOfVestedOptions, ValueOfUnvestedOptions, OptionsCancelled, OptionsLapsed, ExpiryDate,
		CASE WHEN UPPER(VestingType)='PERFORMANCE BASED' THEN 'Performance Based'
		ELSE 'Time Based' END VestingType,FMV,NoOfOptions,GrantLegId
		FROM #EMPLOYEE_TEMP_DATA 
		--WHERE (ISNULL(IsGlGenerated,0)=1 AND ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=1) OR (ISNULL(IsEGrantsEnabled,0)=@IS_EGRANTS_ENABLED AND @IS_EGRANTS_ENABLED=0) 
	)	AS #FINAL_REPORT_DATA
	
	
			--level 1 start from here
		DECLARE @level1 TABLE
		(
			MIT_ID int , INSTRUMENT_NAME nvarchar(100),  currency varchar(50), vested NUMERIC(18,0), granted NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
			valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0)
		)
		INSERT INTO @level1
		SELECT DISTINCT 
			ETD1.MIT_ID, ETD1.INSTRUMENT_NAME,  ETD1.CurrencyAlias AS currency, SUM(ETD1.OptionsVested) AS vested, SUM(ETD1.OptionsGranted) AS granted, SUM(ETD1.OptionsUnVested) AS unvested,
			SUM(ETD1.OptionsExercised) AS exercised,SUM(ETD1.PendingForApproval) AS PendingForApproval,ISNULL( SUM(ETD1.ValueOfGrantedOptions),0) AS valueForGrant, ISNULL( SUM(ETD1.ValueOfVestedOptions),0) AS valueForVested, ISnull( SUM(ETD1.ValueOfUnvestedOptions),0) AS valueForUnvested,
			SUM(ETD1.OptionsCancelled) AS cancelled, SUM(ETD1.OptionsLapsed) AS lapsed
		FROM
			#FINALDATA ETD1 
				WHERE(@IS_EGRANTS_ENABLED=1 AND ETD1.GrantOptionId in(select GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA WHERE  EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
		GROUP BY
			ETD1.MIT_ID, ETD1.INSTRUMENT_NAME,  ETD1.CurrencyAlias
		--level 1 ends here

		--level 2 start from here 
	DECLARE @level2 TABLE
	(
		MIT_ID int , SchemeTitle nvarchar(100),  currency varchar(50), granted NUMERIC(18,0), vested NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
		valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0)
	)
	INSERT INTO @level2
	SELECT DISTINCT 
		level2.MIT_ID,level2.SchemeId AS SchemeTitle, level2.CurrencyAliAS AS currency,SUM(level2.OptionsGranted) AS granted,SUM(level2.OptionsVested) AS vested, SUM(level2.OptionsUnVested) AS unvested,
		SUM(level2.OptionsExercised) AS exercised,SUM(level2.PendingForApproval) AS PendingForApproval, ISNULL( SUM(level2.ValueOfGrantedOptions),0) AS valueForGrant,  ISNULL(SUM(level2.ValueOfVestedOptions),0) AS valueForVested, ISNUll(SUM(level2.ValueOfUnvestedOptions),0) AS valueForUnvested,
		SUM(level2.OptionsCancelled) AS cancelled, SUM(level2.OptionsLapsed) AS lapsed
	FROM
		#FINALDATA level2
		WHERE(@IS_EGRANTS_ENABLED=1 AND level2.GrantOptionId in(select GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA WHERE  EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		level2.MIT_ID,level2.SchemeId,level2.CurrencyAliAS
	--level 2 ends here

	--level 3 start from here
	
	DECLARE @level3 TABLE
	(
		MIT_ID INT , SchemeTitle nvarchar(150),[date] datetime, grantId nvarchar(100), acceptance nchar(1), currency varchar(20), exercisePrice numeric(10,2),
		granted NUMERIC(18,0), vested NUMERIC(18,0), unvested NUMERIC(18,0),exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),
		valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2), valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0),FMV NUMERIC (18,2)
	)
	INSERT INTO @level3
	SELECT DISTINCT 
		level3.MIT_ID,level3.SchemeId,level3.GrantDate AS [date], level3.GrantOptionId AS grantId, level3.LetterAcceptanceStatus AS acceptance, level3.CurrencyAlias AS currency, level3.ExercisePrice AS exercisePrice,
		SUM(level3.OptionsGranted) AS granted, SUM(level3.OptionsVested) AS vested, SUM(level3.OptionsUnVested) AS unvested, SUM(level3.OptionsExercised) AS exercised,SUM(level3.PendingForApproval) AS PendingForApproval, 
		ISNULL(SUM(level3.ValueOfGrantedOptions),0) AS valueForGrant,
		ISNULL(SUM(level3.ValueOfVestedOptions),0) AS valueForVested, ISNUll( SUM(level3.ValueOfUnvestedOptions),0) AS valueForUnvested, 
		SUM(level3.OptionsCancelled) AS cancelled, SUM(level3.OptionsLapsed) AS lapsed, ISNULL(level3.FMV,0)
	FROM
		#FINALDATA level3 
		WHERE(@IS_EGRANTS_ENABLED=1 AND level3.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA WHERE  EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		level3.MIT_ID,level3.SchemeId,level3.GrantDate, level3.GrantOptionId,level3.LetterAcceptanceStatus, 
		level3.CurrencyAlias,level3.ExercisePrice,level3.FMV	
	--level 3 ends here

	--level 4 start from here
	DECLARE @level4 TABLE
	(
		MIT_ID INT , SchemeTitle nvarchar(150),grantDate datetime, grantId nvarchar(100),vestingDate datetime, granted NUMERIC(18,0),  vested NUMERIC(18,0), unvested numeric(18,0),
		exercised NUMERIC(18,0),PendingForApproval NUMERIC(18,0),valueForGrant NUMERIC(18,2), valueForVested NUMERIC(18,2),valueForUnvested NUMERIC(18,2),cancelled NUMERIC(18,0), lapsed NUMERIC(18,0),
		expiryDate datetime,VestingType VARCHAR(100),NoOfOptions NUMERIC(18,0),GrantLegId NUMERIC(18,0)
	)
	INSERT INTO @level4
	SELECT DISTINCT 
		vesting.MIT_ID, vesting.SchemeId,vesting.GrantDate, vesting.GrantOptionId, vesting.VestingDate AS vestingDate, SUM(vesting.OptionsGranted) AS granted, SUM(vesting.OptionsVested) AS vested, 
		SUM(vesting.OptionsUnVested) AS unvested, SUM(vesting.OptionsExercised) AS exercised, SUM(vesting.PendingForApproval) AS PendingForApproval, 
		ISNULL(SUM(vesting.ValueOfGrantedOptions),0) AS valueForGrant,ISNULL( SUM(vesting.ValueOfVestedOptions),0) AS valueForVested,ISNULL( SUM(vesting.ValueOfUnvestedOptions),0) AS valueForUnvested,SUM(vesting.OptionsCancelled) AS cancelled,
		SUM(vesting.OptionsLapsed) AS lapsed,vesting.ExpiryDate AS expiryDate, VestingType,IsNULL(vesting.NoOfOptions,0),
		GrantLegId
	FROM
		#FINALDATA vesting 
		WHERE(@IS_EGRANTS_ENABLED=1 AND vesting.GrantOptionId in(SELECT GrantOptionId from #EMPLOYEE_INSTRUMENT_DATA WHERE  EmployeeID=@EmployeeId)) OR (@IS_EGRANTS_ENABLED=0)
	GROUP BY
		vesting.MIT_ID, vesting.SchemeId,vesting.GrantDate,vesting.GrantOptionId, vesting.VestingDate,	
		vesting.ExpiryDate, vesting.VestingType	,vesting.NoOfOptions,vesting.GrantLegId
	--level 4 ends here

	
	SELECT distinct 'Ctl_View_Download_Summary_Level1' CONTROL_MASTER_ID,* FROM @level1 as level1 --FOR json AUTO) as level1
	SELECT distinct 'Ctl_View_Download_Summary_Level2' CONTROL_MASTER_ID,* FROM @level2 as level2 --FOR json AUTO) as level2
	SELECT distinct 'Ctl_View_Download_Summary_Level3' CONTROL_MASTER_ID, MIT_ID,SchemeTitle,REPLACE(CONVERT(VARCHAR, ISNULL([date],''),106),' ','-') AS [date], grantId, 
	CASE WHEN @IS_EGRANTS_ENABLED=1 THEN
		CASE WHEN (ISNULL(acceptance,'')='' OR ISNULL(acceptance,'')='P') AND  CONVERT(DATE,(SELECT TOP 1 GAMU.LastAcceptanceDate FROM GrantAccMassUpload GAMU WHERE GAMU.LetterCode=grantId)) < CONVERT(DATE,GETDATE()) THEN 'Expired'
			 WHEN ISNULL(acceptance,'')='P' THEN 'Pending'
			 WHEN ISNULL(acceptance,'')='A' THEN 'Accepted'
			 WHEN ISNULL(acceptance,'')='R' THEN 'Rejected'
			 ELSE 'Pending' END
	ELSE 'Not Applicable' 
	END AS acceptance, 
		 currency, exercisePrice,
		 granted, vested,unvested, exercised,PendingForApproval, valueForGrant,valueForVested,
		  valueForUnvested, cancelled, lapsed ,FMV FROM @level3 as level3 --FOR json AUTO) as level3
	
	SELECT  'Ctl_View_Download_Summary_Level4' CONTROL_MASTER_ID, MIT_ID, 
	SchemeTitle ,REPLACE(CONVERT(VARCHAR, ISNULL(level4.GrantDate,''),106),' ','-')AS GrantDate, 
	grantId,CASE WHEN GR.IsChkNote = 1 THEN  CASE WHEN level4.VestingDate >= GR.NoteDate THEN GR.Note  ELSE  
	REPLACE(CONVERT(VARCHAR, ISNULL(vestingDate,''),106),' ','-')  END    ELSE 
	REPLACE(CONVERT(VARCHAR, ISNULL(vestingDate,''),106),' ','-') END AS vestingDate,
	granted, vested, unvested, exercised,PendingForApproval, valueForGrant,valueForVested,valueForUnvested,cancelled,lapsed,
	REPLACE(CONVERT(VARCHAR, ISNULL(expiryDate,''),106),' ','-') AS expiryDate,VestingType ,IsNULL(NoOfOptions,0)as NoOfOptions
	FROM @level4 as level4 --FOR json AUTO) as level4
	INNER JOIN GrantOptions GOP on GOP.GrantOptionId = level4.grantId 
	INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId = GOP.GrantRegistrationId
	WHERE granted NOT IN (0)
	ORDER BY level4.vestingDate,GR.IsChkNote,GR.Note,GR.NoteDate,level4.GrantLegId

	-----End Summary Report
  
   

    END
IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_NewUiExerciseReport')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
      SELECT 'Ctl_View_Download_Exercise' CONTROL_MASTER_ID,'MY Exercise Report' AS  ReportName
	END

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_View_Download')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
      SELECT 'Ctl_View_Download_Summary' CONTROL_MASTER_ID,'MY Summary Report' AS  ReportName,@ISLISTED AS ISLISTED,@IS_COMPANY_WITH_FMV  AS IS_COMPANY_WITH_FMV
	END

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_SchemeWiseGrantReport')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
	BEGIN
	------Level1
	SELECT 'Ctl_SchemeWiseGrantReport_Level1' CONTROL_MASTER_ID,SUM(ISNULL(OptionsVested,0)) as OptionsVested,SUM(ISNULL(OptionsUnVested,0)) OptionsUnVested ,SUM(ISNULL(OptionsVested,0)+ISNULL(OptionsUnVested,0)) TotalUnitGrant,SUM(ISNULL(OptionsLapsed,0)) OptionsLapsed,
	SUM(ISNULL(ValueOfVestedOptions,0)) ValueOfVestedOptions,SUM(ISNULL(ValueOfUnvestedOptions,0)) ValueOfUnvestedOptions
	,SUM(ISNULL(ValueOfUnvestedOptions,0)+ISNULL(ValueOfVestedOptions,0)) TotalValueGrant ,SchemeTitle,Scheme.SchemeId
	FROM #EMPLOYEE_INSTRUMENT_DATA,Scheme WHERE Scheme.SchemeId=#EMPLOYEE_INSTRUMENT_DATA.SchemeId GROUP BY
	SchemeTitle,Scheme.SchemeId
	--Level2
	DECLARE @STATUS1  AS VARCHAR(5)
	SELECT @STATUS1 = ACSID FROM OGA_CONFIGURATIONS

	SELECT
	'Ctl_SchemeWiseGrantReport_Level2' CONTROL_MASTER_ID,SchemeTitle,LetterCode,GrantDate,ExercisePrice,CurrencyAlias,VestingType,	
	CASE
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') NOT IN ('A','R') AND CONVERT(DATE,LASTACCEPTANCEDATE) < CONVERT(DATE,GETDATE()) THEN 'Expired' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS1 = '4' THEN 'Pending for Acceptance'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'P' AND @STATUS1 <> '4' THEN 'Pending for Acceptance / Rejection'
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'A' THEN 'Accepted' 
			WHEN ISNULL(LETTERACCEPTANCESTATUS,'') = 'R' THEN 'Rejected'			
		    ELSE 'Pending for Acceptance / Rejection' 
		END LetterAcceptanceStatus	 
	FROM
	(SELECT  Scheme.SchemeId,SchemeTitle,GAU.LetterCode,GAU.GrantDate,GAU.ExercisePrice,CurrencyAlias,#EMPLOYEE_INSTRUMENT_DATA.VestingType,	
	GAU.LetterAcceptanceStatus,LASTACCEPTANCEDATE
	FROM #EMPLOYEE_INSTRUMENT_DATA,Scheme,GrantAccMassUpload GAU WHERE
	Scheme.SchemeId=#EMPLOYEE_INSTRUMENT_DATA.SchemeId  and LetterCode = GrantOptionId 
	GROUP BY
	Scheme.SchemeId,SchemeTitle,Scheme.SchemeId,GAU.LetterCode,GAU.GrantDate,GAU.ExercisePrice,CurrencyAlias,
	#EMPLOYEE_INSTRUMENT_DATA.VestingType,GAU.LetterAcceptanceStatus,LASTACCEPTANCEDATE) X

	--Level3
	SELECT 'Ctl_SchemeWiseGrantReport_Level3' CONTROL_MASTER_ID,Scheme.SchemeId,SchemeTitle,GAU.LetterCode,SUM(ISNULL(OptionsGranted,0)) OptionsGranted, SUM(ISNULL(OptionsVested,0)) OptionsVested,
	SUM(ISNULL(OptionsExercised,0)) OptionsExercised,
	SUM(ISNULL(OptionsUnVested,0)) OptionsUnVested, 
	SUM(ISNULL(PendingForApproval,0)) PendingForApproval,
	SUM(ISNULL(ValueOfGrantedOptions,0)) ValueOfGrantedOptions,
	SUM(ISNULL(ValueOfVestedOptions,0)) ValueOfVestedOptions, 
	SUM(ISNULL(ValueOfUnvestedOptions,0)) ValueOfUnvestedOptions
	FROM #EMPLOYEE_INSTRUMENT_DATA,Scheme,GrantAccMassUpload GAU WHERE
	Scheme.SchemeId=#EMPLOYEE_INSTRUMENT_DATA.SchemeId  and LetterCode = GrantOptionId
	GROUP BY Scheme.SchemeId,SchemeTitle,GAU.LetterCode 
	--Level4
	SELECT 'Ctl_SchemeWiseGrantReport_Level14' CONTROL_MASTER_ID, Scheme.SchemeId,SchemeTitle,GAU.LetterCode, VestingDate, 
		ExpiryDate, OptionsGranted, OptionsVested,OptionsExercised, OptionsUnVested, 
		PendingForApproval,ValueOfGrantedOptions, 
		ValueOfVestedOptions, 
		ValueOfUnvestedOptions
	FROM #EMPLOYEE_INSTRUMENT_DATA,Scheme,GrantAccMassUpload GAU WHERE
	Scheme.SchemeId=#EMPLOYEE_INSTRUMENT_DATA.SchemeId  and LetterCode = GrantOptionId 

	
	
	END
	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where 
	CONTROL_ID='Ctl_FMVTrend')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
	--- FMV TREND REPORT---

	SELECT  DISTINCT 'Ctl_FMVTrend' AS CONTROL_MASTER_ID 
	,FMV,CONVERT(VARCHAR, ISNULL(FMV_FromDate,''),106) as FMV_FromDate,
	(CONVERT(VARCHAR, ISNULL(FMV_Todate,''),106)  )as 
	FMV_Todate,Scheme_Id,CAST(CONVERT(varchar, ISNULL(FMV_Todate,''),106)   as DATE)as 
	FMV_TodateORDER,@IS_COMPANY_WITH_FMV  AS IS_COMPANY_WITH_FMV
	FROM #TEMPFMVTREND_SCHEME_DATA	
	ORDER BY  FMV_TodateORDER ASC
	
	IF(@FMV_BASEDON = 'S')
   BEGIN
	SELECT  DISTINCT 'Ctl_FMVTrend_Schemes' AS CONTROL_MASTER_ID ,TES.SchemeId,TES.CurrencyAlias  FROM #TEMPEMPLOYEEWISE_SCHEME  TES
    LEFT JOIN FMVForUnlisted
    ON  FMVForUnlisted.Scheme_Id = TES.SchemeId
	END
	 
	--- FMV TREND REPORT---
	END

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER WHERE CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID FROM DASHBOARD_CONTROLS_MASTER WHERE 
	CONTROL_ID='Ctl_CashPlan_Report')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
	   SELECT 'Ctl_CashPlan_Report' AS CONTROL_MASTER_ID,
	   Id,	Action,	PayoutTranchId,	DeferredCashGrant.EmployeeId,EmployeeNAme,SchemeName,GrantFinancialYear,GrantID,	   
	   CASE WHEN (GrantDate ='1900-01-01 00:00:00.000') THEN NULL
       ELSE (Isnull(GrantDate,'')) END AS GrantDate,
	   GrantAmount,Currency,
	   CASE WHEN (PayOutdueDate ='1900-01-01 00:00:00.000') THEN NULL
       ELSE (Isnull(PayOutdueDate,'')) END AS PayOutdueDate,
	   PayOutDistribution,
	   PayOutCategory,	GrossPayoutAmount,	TaxDeducted,NetPayoutAmount,
	   CASE WHEN (PayOutDate ='1900-01-01 00:00:00.000') THEN NULL
       ELSE (Isnull(PayOutDate,'')) END AS PayOutDate,
	   PayOutRevesion,	
	   CASE WHEN (DateOfRevision ='1900-01-01 00:00:00.000') THEN NULL
       ELSE (Isnull(DateOfRevision,'')) END AS DateOfRevision,
	   ReasoForRevision,CREATED_BY,CREATED_ON,	UPDATED_BY,	UPDATED_ON,
	   QueryExecutionON,StatusType,	Remark,
	   CASE WHEN  ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0))) <= 0
       THEN 0
       ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
       AS PayOutDue
	   FROM DeferredCashGrant
	   INNER JOIN UserMaster UM ON DeferredCashGrant.EmployeeId = UM.EmployeeId
	   WHERE DeferredCashGrant.EmployeeId in(@EmployeeId)

	END	

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER WHERE CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID FROM DASHBOARD_CONTROLS_MASTER WHERE 
	CONTROL_ID='Ctl_CashPlan_Report')
    AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
    BEGIN
	SELECT 'DeferredCashPlanReportColumnName' AS CONTROL_MASTER_ID,DCG_ID,DataColumnName,DisplayColumnName,IsActive,SequenceNo from MST_Deferred_Cash_Grant 
	WHERE IsActive = 1
	 
	END	

	--IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER WHERE CONTROL_MASTER_ID= (SELECT CONTROL_MASTER_ID FROM DASHBOARD_CONTROLS_MASTER WHERE 
	--CONTROL_ID='Ctl_QuickLinks')
 --   AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
 --   BEGIN
	--   SELECT 'QuickLinks' AS CONTROL_MASTER_ID,QID,DESCRIPTION,URL,ACTIVE,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON FROM WidgetQuicklinks WHERE ACTIVE = 1
	--END	

	IF (1=(SELECT COUNT(*) FROM DASHBOARD_DASHBOARD_WIDGET_TYPE,DASHBOARD_CONTROLS_MASTER where CONTROL_MASTER_ID=(select CONTROL_MASTER_ID from DASHBOARD_CONTROLS_MASTER where  CONTROL_ID='Ctl_CashlessTransactionReport')
		AND IsActiveNewUI=1 AND DASHBOARD_CONTROLS_MASTER.WIDGET_ID=DASHBOARD_DASHBOARD_WIDGET_TYPE.WIDGET_ID))
		BEGIN
		   DECLARE @ResultOut NVARCHAR(100), @parameters NVARCHAR(200), @STR NVARCHAR(600)
			SET @parameters=N'@CompanyID VARCHAR(40), @ResultOut NVARCHAR(100) output'
			SET @STR=N'Select @ResultOut=TC.EmployeeId  FROM TrustGlobal..TrancheConsolidation TC INNER JOIN ' + @CompanyID + '..Exercised CE on TC.Exercisenumber = CE.exerciseno WHERE EmployeeId = ' + CHAR(39) + @EmployeeId  + CHAR(39)
			EXEC sp_executesql @STR, @parameters, @CompanyID, @ResultOut OUTPUT 
			PRINT @ResultOut
			IF(ISNULL(@ResultOut,'0') <> '0')			
			BEGIN
			SELECT 'Ctl_CashlessTransactionReport' CONTROL_MASTER_ID,'MY Cashless Transaction Report' AS  ReportName
			END
		END

	END
	
	DROP TABLE #EMPLOYEE_TEMP_DATA  
	DROP TABLE #OptionValueReport
	DROP TABLE #CancelledDataFromGrantLeg
	DROP TABLE #EMPLOYEE_INSTRUMENT_DATA
	DROP TABLE #TEMPFMVTREND_SCHEME_DATA
	DROP TABLE #TEMPEMPLOYEEWISE_SCHEME
	SET NOCOUNT OFF;
END
GO
