/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_SUMMARY_DATA] 

@SchemeType NVARCHAR (1),
@SchemeId NVARCHAR (MAX)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @MAXID									INT, 
			@MINID									INT, 
			@ConditionVestID						VARCHAR(MAX) = '', 
			@ConditionExercisableQty				VARCHAR(MAX) = '',
			@ConditionFinalExercisableQty			VARCHAR(MAX) = '',
			@ConditionNoOfOptionsVested				VARCHAR(MAX) = ''

	SET @MAXID = (SELECT MAX(GrantLegId) FROM GrantLeg)
	SET @MINID = (SELECT MIN(GrantLegId) FROM GrantLeg)

	/* Create temp table #SP_REPORT_DATA table */
	CREATE TABLE #SP_REPORT_DATA
	(
		OptionsGranted		INT,
		OptionsVested		INT,
		OptionsExercised	INT,
		OptionsCancelled	INT,
		OptionsLapsed		INT,
		OptionsUnVested		INT,
		PendingForApproval	INT,
		GrantOptionId		VARCHAR(500),
		GrantLegId			INT,
		SchemeId			VARCHAR(500),
		GrantRegistrationId	VARCHAR(500),
		Employeeid			VARCHAR(500),
		employeename		VARCHAR(500),
		SBU					VARCHAR(500),
		AccountNo			VARCHAR(500),
		PANNumber			VARCHAR(50),
		Entity				VARCHAR(500),
		[Status]			VARCHAR(500),
		GrantDate			DATETIME,
		VestingType			VARCHAR(50),
		ExercisePrice		NUMERIC(18,2),
		VestingDate			DATETIME,
		ExpirayDate			DATETIME,
		Parent_Note			VARCHAR(50),
		UnvestedCancelled	INT,
		VestedCancelled		INT,
		INSTRUMENT_NAME NVARCHAR (500),CurrencyName NVARCHAR (100),COST_CENTER VARCHAR (100),Department VARCHAR (50),Location VARCHAR (100),
		EmployeeDesignation VARCHAR (100),Grade VARCHAR (50),ResidentialStatus VARCHAR (50),CountryName VARCHAR (100), CurrencyAlias VARCHAR (20),
		MIT_ID INT, CancellationReason NVARCHAR (500)
	)
	
	/* Insert data in #SP_REPORT_DATA table */
	-- EXEC SP_REPORT_DATA '1990-01-01', '2018-03-12'
	DECLARE @FROMDATE DATETIME = '1990-01-01', @TODATE DATETIME = GETDATE()
	INSERT INTO #SP_REPORT_DATA
	EXEC SP_REPORT_DATA @FROMDATE, @TODATE
	
	/* Create temp table #TEMP_ADDITIONAL_EXERCISED_QTY table */
	CREATE TABLE #TEMP_ADDITIONAL_EXERCISED_QTY
	(
		GrantOptionId			VARCHAR(500),
		GrantLegId				INT,	
		AdditionalExercisedQty	INT
	)
	
	SELECT * INTO #VW_ExercisedQuantity FROM VW_ExercisedQuantity
	
	/* Insert data in #TEMP_ADDITIONAL_EXERCISED_QTY table */
	SELECT DISTINCT GOPA.BaseGrantOptionId, AssociatedGrantOptionId INTO #GrantOptionIdAssociationWithEx
	FROM GrantOptionIdAssociation GOPA INNER JOIN #VW_ExercisedQuantity VWEX ON VWEX.GrantOptionId = GOPA.AssociatedGrantOptionId AND 
	VWEX.GrantLegId = GOPA.AssociationToVestId

	INSERT INTO #TEMP_ADDITIONAL_EXERCISED_QTY
	SELECT GrantOptionId, GrantLegId,SUM(ExercisedQuantity) FROM 
	(
		SELECT VWEXD.GrantOptionId, VWEXD.GrantLegId, SUM(VWEXD.ExercisedQuantity) AS ExercisedQuantity 
		FROM VW_ExercisedQuantity VWEXD INNER JOIN #GrantOptionIdAssociationWithEx GOPIA ON GOPIA.BaseGrantOptionId = VWEXD.GrantOptionId
		GROUP BY VWEXD.GrantOptionId, VWEXD.GrantLegId
		
		UNION ALL
		
		SELECT GOPIA.BaseGrantOptionId, VWEXD.GrantLegId, SUM(VWEXD.ExercisedQuantity) 
		FROM VW_ExercisedQuantity VWEXD INNER JOIN #GrantOptionIdAssociationWithEx GOPIA ON GOPIA.AssociatedGrantOptionId = VWEXD.GrantOptionId
		GROUP BY GOPIA.BaseGrantOptionId, VWEXD.GrantLegId
		
	) TEMP_OUTPUT GROUP BY GrantOptionId, GrantLegId
	
	/* Create temp table #PROC_GET_EMPLOYEE_QTR_EXD_DATA table */
	CREATE TABLE #PROC_GET_EMPLOYEE_QTR_EXD_DATA
	(
		SR_NO INT, 
		Financial_Quarters NVARCHAR (100), 
		ExercisedQuantity NUMERIC (38, 0), 
		GrantOptionId VARCHAR (100), 
		EmployeeId VARCHAR (20), 
		RNO BIGINT
	)

	SELECT 
		GrantOptionId, GrantLegId, CancelledQuantity
	INTO #VW_CancelledQuantityOfPerformance
	FROM 
		VW_CancelledQuantity WHERE PERF_CancelledQuantity = CancelledQuantity and CancelledQuantity > 0
	
	--UPDATE SRD SET SRD.OptionsCancelled = SRD.OptionsCancelled + ISNULL(VWCN.CancelledQuantity,0)
	SELECT GOPA.BaseGrantOptionId, GOPA.AssociatedGrantOptionId, VWCN.GrantLegId, GOPA.AssociatedGrantOptionQty INTO #TEMP_ADDITIONAL_CANCELLED_QTY
	FROM VW_CancelledQuantity VWCN
	INNER JOIN GrantOptionIdAssociation GOPA ON GOPA.AssociatedGrantOptionId = VWCN.GrantOptionId AND GOPA.AssociationToVestId = VWCN.GrantLegId
	WHERE VWCN.CancelledQuantity <> 0
	
	UPDATE SRD SET SRD.OptionsCancelled = SRD.OptionsCancelled + ISNULL(TACQ.AssociatedGrantOptionQty,0)
	--SELECT SRD.GrantOptionId, SRD.GrantLegId, SRD.OptionsCancelled, ISNULL(TACQ.AssociatedGrantOptionQty,0)
	FROM #SP_REPORT_DATA SRD INNER JOIN #TEMP_ADDITIONAL_CANCELLED_QTY TACQ ON 
	TACQ.BaseGrantOptionId = SRD.GrantOptionId AND TACQ.GrantLegId = SRD.GrantLegId

	/* Create temp table #SP_REPORT_DATA_FLTERED table and insert data */
	SELECT * INTO #SP_REPORT_DATA_FLTERED FROM
	(
		SELECT
			OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, employeename, SBU, AccountNo, PANNumber, Entity, [Status],	GrantDate,	VestingType, ExercisePrice, VestingDate, ExpirayDate, Parent_Note, UnvestedCancelled, VestedCancelled,
			GOPA.BaseGrantOptionId, ISNULL(GOPA.AssociatedGrantOptionQty, 0) AS AssociatedGrantOptionQty, (SELECT TOP 1 SharePriceAsOnDateOfGrant FROM GrantOptionIdAssociation WHERE BaseGrantOptionId = SPR.GrantOptionId) AS SharePriceAsOnDateOfGrant
		FROM #SP_REPORT_DATA AS SPR
		LEFT OUTER JOIN GrantOptionIdAssociation AS GOPA ON SPR.GrantOptionId = GOPA.BaseGrantOptionId AND SPR.GrantLegId = GOPA.AssociationToVestId
		WHERE GrantOptionId NOT IN (SELECT ISNULL(AssociatedGrantOptionId, '') FROM GrantOptionIdAssociation)
		
	)AS SP_REPORT_DATA_FLTERED 
	
	/* Creating table for getting All Schemes and Live Schemes*/
	CREATE TABLE #FILTERED_SCHEMES(
		SchemeId NVARCHAR (MAX) )
		
	/* Inserting data into ##FILTERED_SCHEMES table depending upon Scheme Type*/
	IF(@SchemeType = '0')
		BEGIN
			INSERT INTO #FILTERED_SCHEMES SELECT DISTINCT(SchemeId) FROM GrantLeg
		END
	ELSE
		BEGIN
			INSERT INTO #FILTERED_SCHEMES
				SELECT 
					DISTINCT SchemeId
				FROM 
					GrantLeg
				WHERE 
					((CASE WHEN VestingType = 'P' AND IsPerfBased ='N' AND GrantedOptions <> (CancelledQuantity + ExercisedQuantity + ExercisableQuantity + UnapprovedExerciseQuantity + LapsedQuantity) THEN  GrantedOptions ELSE ExercisableQuantity END)  + UnapprovedExerciseQuantity) > 0
		END

	/* Prepare dynamic columns */
	WHILE(@MINID <= @MAXID)
	BEGIN
		SET @ConditionVestID = @ConditionVestID + ',' + 'MAX(CASE WHEN row_no='+ CONVERT(VARCHAR(5),@MINID) +' THEN VestingDate END ) AS [Vesting Date: ' + CONVERT(VARCHAR(5),@MINID) + ']'
		SET @ConditionExercisableQty = @ConditionExercisableQty + ',' + 'SUM(CASE WHEN row_no='+ CONVERT(VARCHAR(5),@MINID) +' THEN ISNULL(OptionsGranted, 0) ELSE 0 END ) AS [Vesting - ' + CONVERT(VARCHAR(5),@MINID) + ' : Quantity scheduled to vest]'
		SET @ConditionFinalExercisableQty = @ConditionFinalExercisableQty + ',' + 'SUM(CASE WHEN row_no='+ CONVERT(VARCHAR(5),@MINID) +' THEN ISNULL((FinalOptionsGranted + AssociatedGrantOptionQty), FinalOptionsGranted) ELSE 0 END ) AS [Vesting - ' + CONVERT(VARCHAR(5),@MINID) + ' : Final Quantity vested]'
		SET @ConditionNoOfOptionsVested = @ConditionNoOfOptionsVested  + '+[Vesting - ' + CONVERT(VARCHAR(5),@MINID) + ' : Final Quantity vested]'
		SET @MINID = @MINID + 1
	END

	/* Prepare dynamic query */
	DECLARE @Query NVARCHAR(MAX)
	DECLARE @Query2 NVARCHAR (MAX)
	DECLARE @Where_Clause NVARCHAR (MAX)

	SET @Query = 
	'
		;WITH CTE_tbl AS
		(
			SELECT 
					VestingDate, GL.GrantOptionId, GL.AssociatedGrantOptionQty,SharePriceAsOnDateOfGrant,
					ISNULL(AQTY.AdditionalExercisedQty, OptionsExercised)  AS OptionsExercised, OptionsCancelled, OptionsGranted, 
					((OptionsVested + OptionsExercised + (OptionsCancelled - ISNULL(AQTYCN.AssociatedGrantOptionQty,0))  + OptionsLapsed + PendingForApproval) - GL.UnvestedCancelled - ISNULL(VW_CQP.CancelledQuantity, 0)) AS FinalOptionsGranted, OptionsLapsed,
					ROW_NUMBER() OVER(PARTITION BY GL.GrantOptionId order by GL.GrantLegId) as row_no, ISNULL(AQTY.GrantLegId, GL.GrantLegId) AS GrantLegId
			FROM 
					#SP_REPORT_DATA_FLTERED AS GL 
			LEFT OUTER JOIN #TEMP_ADDITIONAL_EXERCISED_QTY AS AQTY ON GL.GrantOptionId = AQTY.GrantOptionId AND GL.GrantLegId = AQTY.GrantLegId
			LEFT OUTER JOIN #TEMP_ADDITIONAL_CANCELLED_QTY AS AQTYCN ON GL.GrantOptionId = AQTYCN.BaseGrantOptionId AND GL.GrantLegId = AQTYCN.GrantLegId
			LEFT OUTER JOIN #VW_CancelledQuantityOfPerformance VW_CQP ON VW_CQP.GrantOptionId = GL.GrantOptionId AND VW_CQP.GrantLegId = GL.GrantLegId
		)
		
		SELECT * INTO #TEMP_GRANT_DATA FROM
		(
			SELECT 
					*,
					('+ RIGHT(@ConditionNoOfOptionsVested, LEN(@ConditionNoOfOptionsVested) - 1) +') AS [NoOfOptionsVested], 
					(('+ RIGHT(@ConditionNoOfOptionsVested, LEN(@ConditionNoOfOptionsVested) - 1) +') - OptionsExercised) AS NoOfOptionsNotYetExercisedTillDate,
					((ISNULL(AssociatedGrantOptionQty, 0) + OptionsGranted) - OptionsExercised - CancelledOptions - TotalLapsedOptions) AS NoOfOptionsLeftToExercise
			FROM 
			( 
				SELECT 
					GrantOptionId
					'+@ConditionVestID+' 
					'+@ConditionExercisableQty+' 
					'+@ConditionFinalExercisableQty+'
					,SUM(OptionsGranted) AS OptionsGranted
					,SUM(OptionsExercised) AS OptionsExercised
					,SUM(AssociatedGrantOptionQty) AS AssociatedGrantOptionQty
					,SUM(OptionsExercised) AS NoOfOptionsExercisedTillDate
					,SUM(OptionsCancelled) AS CancelledOptions
					,SUM(OptionsLapsed) AS TotalLapsedOptions
					,MAX(SharePriceAsOnDateOfGrant) AS SharePriceAsOnDateOfGrant
				FROM 
					CTE_tbl
				GROUP BY 
					GrantOptionId
			)AS SUB
		)AS TEMP_GRANT_DATA
		'
		IF(@SchemeId = '---ALL SCHEMES---')
		BEGIN
			SET @Where_Clause = ' WHERE EM.Deleted = 0;'
		END
		ELSE
		BEGIN
			SET @Where_Clause = ' WHERE SC.SchemeId =' + CHAR(39)+ @SchemeId + CHAR(39) + ' AND  EM.Deleted = 0;'
		END
		
		SET @Query2 =
		/* Get Financial year and Exercised Quantity data */
		'INSERT INTO #PROC_GET_EMPLOYEE_QTR_EXD_DATA
		EXEC PROC_GET_EMPLOYEE_QTR_EXD_DATA

		SELECT	DISTINCT
				dense_RANK() OVER (ORDER BY TGA.GrantOptionId) AS ID, 
				EM.EmployeeID, EM.EmployeeName, (CASE WHEN EM.DateOfTermination IS NULL THEN ''Live'' ELSE ''Separated'' END) AS Status, EM.DateOfTermination, 
				ISNULL(RT.Reason,'''') AS ReasonForTermination,
				EM.DateOfJoining, EM.Department, EM.EmployeeEmail, EM.Grade, EM.EmployeeDesignation, 
				SC.SchemeTitle, 
				GR.GrantDate, GR.ExercisePrice,
				TGA.*,EQED.SR_NO, EQED.[Financial_Quarters], EQED.ExercisedQuantity
		FROM GrantOptions AS GOP 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeID = EM.EmployeeID
				LEFT OUTER JOIN ReasonForTermination AS RT ON EM.ReasonForTermination = RT.ID
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId = GR.GrantRegistrationId
				INNER JOIN Scheme AS SC ON GOP.SchemeId = SC.SchemeId
				INNER JOIN #TEMP_GRANT_DATA AS TGA ON GOP.GrantOptionId = TGA.GrantOptionId
				LEFT OUTER JOIN #PROC_GET_EMPLOYEE_QTR_EXD_DATA AS EQED ON TGA.GrantOptionId = EQED.GrantOptionId
				INNER JOIN #FILTERED_SCHEMES AS FS ON SC.SchemeId = FS.SchemeId ' + @Where_Clause + ' DROP TABLE #TEMP_GRANT_DATA'

	EXEC (@Query + @Query2)
	--PRINT @Query
	--PRINT @Query2
	--PRINT @Where_Clause
	DROP TABLE #FILTERED_SCHEMES
	DROP TABLE #SP_REPORT_DATA_FLTERED
	DROP TABLE #SP_REPORT_DATA
	DROP TABLE #PROC_GET_EMPLOYEE_QTR_EXD_DATA
	
	SET NOCOUNT OFF;	
END
GO
