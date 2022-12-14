/****** Object:  StoredProcedure [dbo].[PROC_EXCHANGE_DATA_MYESOP_AND_CLIENT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EXCHANGE_DATA_MYESOP_AND_CLIENT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EXCHANGE_DATA_MYESOP_AND_CLIENT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EXCHANGE_DATA_MYESOP_AND_CLIENT](@DateParam DATE = NULL,@EmployeeID VARCHAR(200)= NULL )

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @FROM_DATE AS VARCHAR(50) = NULL, @TO_DATE AS VARCHAR(50) = NULL

	SET @TO_DATE = @DateParam

	SET @EmployeeID=NULL
	IF @FROM_DATE IS NULL OR LTRIM(RTRIM(@FROM_DATE)) = ''
			SET @FROM_DATE = CONVERT(DATE, '2009-01-01')
		ELSE
			SET @FROM_DATE = CONVERT(DATE, @FROM_DATE)

	IF @TO_DATE IS NULL OR LTRIM(RTRIM(@TO_DATE)) = ''
		SET @TO_DATE = CONVERT(DATE, GETDATE())
	ELSE
		SET @TO_DATE = CONVERT(DATE, @TO_DATE)

	DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
	SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
	DECLARE @UnVestedOptionsGranted VARCHAR(50), @UnVestedOptionsExercised VARCHAR(50), @UnVestedOptionsCancelled VARCHAR(50)			
	DECLARE @OptionsGranted VARCHAR(50), @OptionsExercised VARCHAR(50), @OptionsCancelled VARCHAR(50)			
	
	DECLARE @STR_SQL1 VARCHAR(MAX), @STR_SQL2 VARCHAR(MAX), @STR_SQL3 VARCHAR(MAX)

	IF(@ApplyBonusTo='V')
		BEGIN
			IF(@ApplySplitTo='V')
			BEGIN
			-- Set Parameter GrantedQuantity, ExercisedQuantity, CancelledQuantity,
				SET @OptionsGranted='GrantLeg.GrantedQuantity'
				SET @OptionsExercised='GrantLeg.ExercisedQuantity'
				SET @OptionsCancelled='GrantLeg.CancelledQuantity'
				SET @UnVestedOptionsGranted = 'GL_UnVested.GrantedQuantity'
				SET @UnVestedOptionsExercised = 'GL_UnVested.ExercisedQuantity'
				SET @UnVestedOptionsCancelled = 'GL_UnVested.CancelledQuantity'
			END
			ELSE 
			BEGIN
			-- Set Parameter SplitQuantity, SplitExercisedQuantity, SplitCancelledQuantity, 
				SET @OptionsGranted='GrantLeg.SplitQuantity'
				SET @OptionsExercised='GrantLeg.SplitExercisedQuantity'
				SET @OptionsCancelled='GrantLeg.SplitCancelledQuantity'
				SET @UnVestedOptionsGranted = 'GL_UnVested.SplitQuantity'
				SET @UnVestedOptionsExercised = 'GL_UnVested.SplitExercisedQuantity'
				SET @UnVestedOptionsCancelled = 'GL_UnVested.SplitCancelledQuantity'
			END
		END
	ELSE
		BEGIN
		-- Set Parameter BonusSplitQuantity, BonusSplitExercisedQuantity, BonusSplitCancelledQuantity, 
			SET @OptionsGranted='GrantLeg.BonusSplitQuantity'
			SET @OptionsExercised='GrantLeg.BonusSplitExercisedQuantity'
			SET @OptionsCancelled='GrantLeg.BonusSplitCancelledQuantity'
			SET @UnVestedOptionsGranted = 'GL_UnVested.BonusSplitQuantity'
			SET @UnVestedOptionsExercised = 'GL_UnVested.BonusSplitExercisedQuantity'
			SET @UnVestedOptionsCancelled = 'GL_UnVested.BonusSplitCancelledQuantity'
		END
	DECLARE @TEMP_GUID VARCHAR(100) = REPLACE((SELECT NEWID()), '-', '_')	

	IF (LEN(@EmployeeID) > 0)
	BEGIN
		SET @EmployeeID = ' WHERE EMPLOYEEID = '''+@EmployeeID+''''		
	END
	ELSE
		SET @EmployeeID = ''
	
	EXECUTE ('SELECT * INTO ##VW_GRANT_LEG_DETAILS_EXCHANGE_DATA_MYESOP_' + @TEMP_GUID + ' FROM VW_GRANT_LEG_DETAILS_EXCHANGE_DATA_MYESOP ' + @EmployeeID)

	IF (LEN(@EmployeeID) > 0 OR @EmployeeID IS NOT NULL)
	BEGIN	
		SET @EmployeeID = REPLACE(@EmployeeID , 'WHERE','AND')		
	END
	ELSE
		SET @EmployeeID = ''
	
	EXECUTE('SELECT * INTO ##VW_CancelledQuantity_' + @TEMP_GUID + ' FROM VW_CancelledQuantity WHERE GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +'''' + @EmployeeID)	
	
	
	SET @STR_SQL1 =
	'
		SELECT 
			ID,
			EmployeeId,
			ISNULL(Grade,'''') AS Grade, 
			ISNULL(EmployeeStatus,'''') AS Status, 
			ISNULL(SchemeTitle,'''') AS SchemeTitle,
			ISNULL(GrantDate,'''') AS GrantDate, 
			ExercisePrice,
			ISNULL(GrantedOptions,0) AS GrantQuantity, 
			((ISNULL(GrantQuantity,0) - (ISNULL(ExercisedQuantity,0) + ISNULL(OptionsCancelled,0) + ISNULL(LapsedQuantity,0) + ISNULL(OptionsUnVested,0)))) AS OptionsVestedAndExercisable,
			NULL AS ExercisedPricePerUnit,
			ISNULL(VestingDate,'''') AS VestingDate, 
			ISNULL(OriginalExpiryDate,'''') AS ExpiryDate, 
			--NULL AS OptionsVestedAndExercisable,
			ISNULL(OptionsUnVested,0) AS OptionsUnVested, 
			(ISNULL(OptionsCancelled,0) + ISNULL(LapsedQuantity,0)) AS LapsedQuantity, 
			NULL AS ExercisedDate, 
			NULL AS ExercisedQuantity, 
			NULL AS PerqstPayable,
			NULL AS PerqstValue,
			NULL AS FMVPrice,
			UnapprovedExerciseQuantity
			
		FROM 
		(
			SELECT
			GrantLeg.ID,
			GrantLeg.EmployeeId,
			GrantLeg.Grade,
			GrantLeg.EmployeeStatus,
			GrantLeg.EmployeeName,
			GrantLeg.ExercisedQuantity, '
			+ @OptionsGranted + ' AS GrantedOptions,
			GrantLeg.FinalVestingDate AS VestingDate,
			GrantLeg.FinalExpirayDate AS OriginalExpiryDate,
			--EX.ExercisedDate,
			--EX.ExercisedQuantity AS EX_ExercisedQuantity,
			--EX.ExercisedPrice as EX_ExercisedPrice,
			--((EX.BONUSSPLITEXERCISEDQUANTITY * SCH.OptionRatioMultiplier)/ SCH.OptionRatioDivisor) AS  SharesAlloted,
			'''' FolioNumber,
			CASE WHEN SCH.LockInPeriod = ''0'' THEN ''No lock in period''  WHEN SCH.LockInPeriodStartsFrom = ''E'' THEN ''Lock in''+'' ''+CONVERT(VARCHAR(1000),SCH.LockInPeriod) + '' months from the date of Exercise'' ELSE ''Lock in '' + CONVERT(VARCHAR(1000), SCH.LockInPeriod) + '' months from the date of Vesting''  END AS LockInPeriod,
			GrantLeg.LapsedQuantity,
			GrantLeg.UnapprovedExerciseQuantity,
	'

	SET @STR_SQL2 = 
	'
			ISNULL((SELECT	
						CASE WHEN GL_UnVested.VestingType = ''P'' THEN
							CASE WHEN GL_UnVested.FINALVESTINGDATE >  '''+ @TO_DATE +''' THEN 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN
									SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0)
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END
							ELSE 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN 
									SUM(' + @UnVestedOptionsGranted  + ' - (' + @UnVestedOptionsCancelled  + ' + GL_UnVested.LAPSEDQUANTITY +  ' + @UnVestedOptionsExercised  + ' + GL_UnVested.UNAPPROVEDEXERCISEQUANTITY)) 
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END 
							END 
						ELSE --THIS MEANS GrantLeg.VestingType = ''T''
							CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN 
								SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0)							
							ELSE 
								0
							END			
						END
					FROM	GrantLeg AS GL_UnVested
							INNER JOIN GrantRegistration AS GR_UnVested ON GR_UnVested.GrantRegistrationId = GL_UnVested.GrantRegistrationId					
							LEFT OUTER JOIN PerformanceBasedGrant PFG ON PFG.GrantLegID = GL_UnVested.GrantLegId AND PFG.GrantOptionID = GL_UnVested.GrantOptionId
					WHERE	(GR_UnVested.GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''') AND
							GL_UnVested.grantregistrationId  = GrantLeg.GrantRegistrationId AND GL_UnVested.GrantOptionId = GrantLeg.GrantOptionId AND 
							GL_UnVested.GrantLegId = GrantLeg.GrantLegId and GL_UnVested.VestingType= GrantLeg.VestingType
					GROUP BY GL_UnVested.VestingType, GL_UnVested.FinalVestingDate, GL_UnVested.IsPerfBased,GL_UnVested.GrantLegId,GL_UnVested.GrantOptionId),0) AS OptionsUnVested, 
		'

		SET @STR_SQL3 =
			 @OptionsCancelled + ' AS OptionsCancelled, 
			GrantLeg.GrantLegID,
			CASE WHEN ''' + @DisplayAs + '''=''S'' THEN CASE WHEN GrantLeg.Parent =''N'' THEN ''Original'' ELSE ''Bonus'' END ELSE ''---'' END AS PARENT,
			'''' AnyVariationInTerms,
			'''' Sign,
			'''' Remarks,
			'''' InstrumentType,
			GrantLeg.SchemeID,
			GR.GrantDate,
			GrantLeg.GrantOptionId,
			GR.ExercisePrice as ExercisePrice,
			SCH.SchemeTitle,
			--ISNULL(EX.PerqstPayable,0) AS PerqstPayable,
			--ISNULL(EX.PerqstValue,0) AS PerqstValue,
			--ISNULL(EX.FMVPrice,0) AS FMVPrice,
			ISNULL(GrantLeg.ExercisableQuantity,0) AS ExercisableQuantity,
			ISNULL(GrantLeg.GrantedQuantity,0) AS GrantQuantity
			 

		FROM 
			##VW_GRANT_LEG_DETAILS_EXCHANGE_DATA_MYESOP_' + @TEMP_GUID + ' GrantLeg
			--LEFT OUTER JOIN Exercised EX ON EX.GrantLegSerialNumber = GrantLeg.ID
			INNER JOIN Scheme AS SCH ON GrantLeg.SchemeId = SCH.SchemeId
			LEFT OUTER JOIN VestingPeriod VP ON VP.GrantRegistrationId = GrantLeg.GrantRegistrationId AND VP.SchemeId = GrantLeg.SchemeId AND VP.VestingType = GrantLeg.VestingType AND VP.VestingPeriodNo = GrantLeg.GrantLegId
			INNER JOIN GrantRegistration GR on GR.GrantRegistrationId = GrantLeg.GrantRegistrationId
			WHERE GR.GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +'''' + @EmployeeID + '
		) AS OUT_PUT ORDER BY  EmployeeName, VestingDate
	'

--PRINT @STR_SQL1
--PRINT @STR_SQL2
--PRINT @STR_SQL3
CREATE TABLE #VestingTemp
(
		ID NUMERIC(18,0),
		EmployeeId VARCHAR(20),
		Grade VARCHAR(200), 
		[Status] VARCHAR(200) , 
		SchemeTitle VARCHAR(200),
		GrantDate DATETIME, 
		ExercisePrice NUMERIC(10,2),
		GrantQuantity VARCHAR(100), 
		OptionsVestedAndExercisable NUMERIC(10,0),
		ExercisedPricePerUnit NUMERIC(10,2) ,
		VestingDate DATETIME, 
		ExpiryDate DATETIME, 
		OptionsUnVested NUMERIC(10,0), 
		LapsedQuantity NUMERIC(10,0),
		ExercisedDate DATETIME, 
		ExercisedQuantity NUMERIC(10,0), 
		PerqstPayable NUMERIC(10,0),
		PerqstValue NUMERIC(10,0),
		FMVPrice NUMERIC(10,2),
		UnapprovedExerciseQuantity NUMERIC(10,0)
)

INSERT INTO #VestingTemp(ID,EmployeeId,Grade,Status,SchemeTitle,GrantDate,ExercisePrice,GrantQuantity,OptionsVestedAndExercisable, ExercisedPricePerUnit,VestingDate,ExpiryDate,OptionsUnVested , LapsedQuantity ,ExercisedDate, ExercisedQuantity , PerqstPayable ,PerqstValue ,FMVPrice,UnapprovedExerciseQuantity )
EXEC (@STR_SQL1 + @STR_SQL2 + @STR_SQL3)

--SELECT * FROM #VestingTemp
CREATE TABLE #ExercisedTemp
(
		ID NUMERIC(18,0),
		EmployeeId VARCHAR(20),
		Grade VARCHAR(200), 
		[Status] VARCHAR(200) , 
		SchemeTitle VARCHAR(200),
		GrantDate DATETIME, 
		ExercisePrice NUMERIC(10,2) ,
		GrantQuantity VARCHAR(100), 
		OptionsVestedAndExercisable NUMERIC(10,0),
		ExercisedPricePerUnit NUMERIC(10,2) ,
		VestingDate DATETIME, 
		ExpiryDate DATETIME, 
		OptionsUnVested NUMERIC(10,0), 
		LapsedQuantity NUMERIC(10,0),
		ExercisedDate DATETIME, 
		ExercisedQuantity NUMERIC(10,0), 
		PerqstPayable NUMERIC(10,0),
		PerqstValue NUMERIC(10,0),
		FMVPrice NUMERIC(10,2),
		UnapprovedExerciseQuantity NUMERIC(10,0)
)

INSERT INTO #ExercisedTemp(ID,EmployeeId,Grade,Status,SchemeTitle,GrantDate,ExercisePrice,GrantQuantity,OptionsVestedAndExercisable, ExercisedPricePerUnit,VestingDate,ExpiryDate,OptionsUnVested , LapsedQuantity ,ExercisedDate, ExercisedQuantity , PerqstPayable ,PerqstValue ,FMVPrice,UnapprovedExerciseQuantity )

SELECT GL.ID, EM.EmployeeID,EM.Grade,
CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live' 
       WHEN  EM.ReasonForTermination IS NOT NULL AND CONVERT(DATE, EM.DateOfTermination) > CONVERT(DATE, GETDATE()) THEN 'Live' 
	   ELSE 'Separated' END AS Status,
(SELECT TOP 1 SH.SchemeTitle FROM Scheme SH INNER JOIN GrantOptions GOP ON GOP.SchemeId=SH.SchemeId) AS SchemeTitle,
NULL AS GrantDate,
NULL AS ExercisedPricePerUnit,
NULL AS GrantQuantity,
NULL AS OptionsVestedAndExercisable, 
ExercisedPrice,
NULL AS VestingDate,
NULL AS ExpiryDate,
NULL AS OptionsUnVested, 
NULL AS LapsedQuantity ,
ExercisedDate, 
EX.ExercisedQuantity , 
EX.PerqstPayable ,
EX.PerqstValue ,
EX.FMVPrice, 
NULL AS UnapprovedExerciseQuantity 
FROM Exercised EX
INNER JOIN GrantLeg GL ON GL.ID=EX.GrantLegSerialNumber
INNER JOIN GrantRegistration GR on GR.GrantRegistrationId = GL.GrantRegistrationId
INNER JOIN GrantOptions GOL ON GOL.GrantOptionId=GL.GrantOptionId
INNER JOIN EmployeeMaster EM ON EM.EmployeeID=GOL.EmployeeId
WHERE (Ex.ExercisedDate<=@TO_DATE) AND (GR.GrantDate BETWEEN @FROM_DATE AND @TO_DATE)

END

SELECT TOP 5000 X.EmployeeId,Grade,Status,SchemeTitle,GrantDate,GrantQuantity,ExercisePrice,VestingDate,ExpiryDate,OptionsVestedAndExercisable,OptionsUnVested,LapsedQuantity, 
ExercisedDate,ExercisedPricePerUnit, ExercisedQuantity , PerqstPayable ,PerqstValue ,FMVPrice
FROM
(
	SELECT ID,EmployeeId,Grade,Status,SchemeTitle,GrantDate,ExercisePrice,GrantQuantity,OptionsVestedAndExercisable, ExercisedPricePerUnit,VestingDate,ExpiryDate,OptionsUnVested , LapsedQuantity ,ExercisedDate, ExercisedQuantity , PerqstPayable ,PerqstValue ,FMVPrice,UnapprovedExerciseQuantity FROM #VestingTemp
	UNION ALL
	SELECT ID,EmployeeId,Grade,Status,SchemeTitle,GrantDate,ExercisePrice,GrantQuantity,OptionsVestedAndExercisable, ExercisedPricePerUnit,VestingDate,ExpiryDate,OptionsUnVested , LapsedQuantity ,ExercisedDate, ExercisedQuantity , PerqstPayable ,PerqstValue ,FMVPrice,UnapprovedExerciseQuantity  FROM #ExercisedTemp
)X

ORDER BY X.EmployeeId,X.ID

DROP TABLE #VestingTemp
DROP TABLE #ExercisedTemp
GO
