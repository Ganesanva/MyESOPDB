DROP PROCEDURE IF EXISTS [dbo].[SP_REPORT_DATA]
GO
/****** Object:  StoredProcedure [dbo].[SP_REPORT_DATA]    Script Date: 19-07-2022 14:28:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_REPORT_DATA] (@FROM_DATE AS VARCHAR(50) = NULL, @TO_DATE AS VARCHAR(50) = NULL, @EMPLOYEE_ID AS VARCHAR(100)= NULL, @DisplayParm AS CHAR(1) = NULL)
AS     
BEGIN

	DECLARE @STR_SQL1 VARCHAR(MAX)
	DECLARE @STR_SQL2 VARCHAR(MAX)
	DECLARE @STR_SQL_FINAL VARCHAR(MAX)
	
	DECLARE @STR_EMPLOYEEID AS VARCHAR(200), @STR_ORDERBY AS VARCHAR(105)
	
	DECLARE @APPLICABLE_DATE VARCHAR(100)
    DECLARE @PERF_OPTION_CANCELLATION VARCHAR(20)

    SELECT @APPLICABLE_DATE = CompanyParameters.PERF_OPT_CAN_TREAT_APP_DT, @PERF_OPTION_CANCELLATION=CompanyParameters.PERF_OPT_CAN_TREAT_ON FROM CompanyParameters
	
	SET @STR_EMPLOYEEID = ''
	
	IF @FROM_DATE IS NULL OR LTRIM(RTRIM(@FROM_DATE)) = ''
		SET @FROM_DATE = CONVERT(DATE, '1990-01-01')
	ELSE
		SET @FROM_DATE = CONVERT(DATE, @FROM_DATE)
		
	IF @TO_DATE IS NULL OR LTRIM(RTRIM(@TO_DATE)) = ''
		SET @TO_DATE = CONVERT(DATE, GETDATE())
	ELSE
		SET @TO_DATE = CONVERT(DATE, @TO_DATE)
	
	IF @EMPLOYEE_ID IS NOT NULL AND @EMPLOYEE_ID <> ''
		BEGIN
			SET @STR_EMPLOYEEID = ' WHERE EMPLOYEEID = ' + CHAR(39) + @EMPLOYEE_ID + CHAR(39)	
		END
	ELSE 
		SET @EMPLOYEE_ID = ''
		
	--VIEW FOR GETTING EXERCISEDQUANTITY
	IF NOT EXISTS(SELECT 1 FROM SYS.VIEWS WHERE NAME = 'VW_ExercisedQuantity')
		BEGIN
			EXEC
				('
					CREATE VIEW VW_ExercisedQuantity
						AS 
							SELECT	Exercised.ExercisedDate, 
									CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
										CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
											SUM(Exercised.ExercisedQuantity)
										ELSE 
											SUM(Exercised.SplitExercisedQuantity)
										END
									ELSE
										SUM(Exercised.BonusSplitExercisedQuantity)
									END AS ExercisedQuantity,
									GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
							FROM	GrantRegistration 
									INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
									INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
									INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
									INNER JOIN Exercised ON GrantLeg.ID = Exercised.GrantLegSerialNumber    
							GROUP BY Exercised.ExercisedDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, Exercised.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId
                ')
        END        
        
    --VIEW FOR GETTING CANCELLEDQUANTITY

    IF NOT EXISTS(SELECT 1 FROM SYS.VIEWS WHERE NAME = 'VW_CancelledQuantity')
		BEGIN
			EXEC
				('					
					CREATE VIEW VW_CancelledQuantity
						AS 
					SELECT	Cancelled.CancelledDate, 
							CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
								CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
									SUM(Cancelled.CancelledQuantity)
								ELSE 
									SUM(Cancelled.SplitCancelledQuantity)
								END
							ELSE
								SUM(Cancelled.BonusSplitCancelledQuantity)
							END AS CancelledQuantity,
							GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.IsPerfBased, ISNULL(PerformanceBasedGrant.LastUpdatedOn,NULL) AS PERF_LastUpdatedOn,
							ISNULL(PerformanceBasedGrant.NumberOfOptionsAvailable,0) AS PERF_NumberOfOptionsAvailable, ISNULL(PerformanceBasedGrant.CancelledQuantity,0) AS PERF_CancelledQuantity, ISNULL(PerformanceBasedGrant.NumberOfOptionsGranted,0) AS PERF_NumberOfOptionsGranted, GrantLeg.Parent,							
							CASE 						
							
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,'''+ @APPLICABLE_DATE +'''))
									THEN
										(
								CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
									CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
										SUM(Cancelled.CancelledQuantity)
									ELSE 
										SUM(Cancelled.SplitCancelledQuantity)
									END
								ELSE
									SUM(Cancelled.BonusSplitCancelledQuantity)
											END
										) 					
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED'')				
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,'''+ @APPLICABLE_DATE +'''))					
									THEN	 
										(
											''0''
										)								
								WHEN (CONVERT(DATE,cancelled.CancelledDate) < CONVERT(DATE,MAX(GrantLeg.FinalVestingDate))) 						
									THEN	 
										(
											CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
												CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
													SUM(Cancelled.CancelledQuantity)
												ELSE 
													SUM(Cancelled.SplitCancelledQuantity)
												END
											ELSE
												SUM(Cancelled.BonusSplitCancelledQuantity)
											END
										) 					
								 ELSE 0
							END AS UnVestedCancelled,
							
							CASE 
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''UNVESTED_CANCELLED'')
										AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,'''+ @APPLICABLE_DATE +'''))
									THEN
										(
											''0''
										) 		
								WHEN ((IsPerfBased = ''1'') AND (UPPER(GrantLeg.VestingType) = ''P'') AND (Cancelled.CancellationType = ''P'') AND (UPPER('''+ @PERF_OPTION_CANCELLATION +''') = ''VESTED_CANCELLED'')
									AND CONVERT(DATE,Cancelled.CancelledDate) >= CONVERT(DATE,'''+ @APPLICABLE_DATE +'''))
								  THEN
									(
								CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
									CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
										SUM(Cancelled.CancelledQuantity)
									ELSE 
										SUM(Cancelled.SplitCancelledQuantity)
									END
								ELSE
									SUM(Cancelled.BonusSplitCancelledQuantity)
										END
									)
								WHEN (cancelled.CancelledDate >= MAX(GrantLeg.FinalVestingDate))
								  THEN
									(
										CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
											CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
												SUM(Cancelled.CancelledQuantity)
											ELSE 
												SUM(Cancelled.SplitCancelledQuantity)
											END
										ELSE
											SUM(Cancelled.BonusSplitCancelledQuantity)
										END
									)	
									ELSE 0
							END AS VestedCancelled,
									
							GrantOptions.EmployeeId,GrantLeg.FinalVestingDate
					FROM	GrantRegistration 
							INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
							INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
							INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
							INNER JOIN Cancelled ON GrantLeg.ID = Cancelled.GrantLegSerialNumber
							LEFT OUTER JOIN PerformanceBasedGrant ON PerformanceBasedGrant.GrantLegID = GrantLeg.GrantLegId AND PerformanceBasedGrant.GrantOptionID = GrantLeg.GrantOptionId
						GROUP BY Cancelled.CancelledDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, Cancelled.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.IsPerfBased, PerformanceBasedGrant.LastUpdatedOn,PerformanceBasedGrant.NumberOfOptionsAvailable, PerformanceBasedGrant.CancelledQuantity, PerformanceBasedGrant.NumberOfOptionsGranted, GrantLeg.Parent, GrantOptions.EmployeeId, GrantLeg.FinalVestingDate,Cancelled.CancellationType	
				')
        END
        
    --VIEW FOR GETTING UNAPPROVEDQUANTITY (i.e. Pending for Approval)
	
    IF NOT EXISTS(SELECT 1 FROM SYS.VIEWS WHERE NAME = 'VW_UnApprovedQuantity')
		BEGIN
			EXEC
				('					
					CREATE VIEW VW_UnApprovedQuantity
						AS 
							SELECT	ShExercisedOptions.ExerciseDate, 
									CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = ''V'' THEN 
										CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = ''V'' THEN 
											SUM(ShExercisedOptions.ExercisedQuantity)
										ELSE 
											SUM(ShExercisedOptions.SplitExercisedQuantity)
										END
									ELSE
										SUM(ShExercisedOptions.BonusSplitExercisedQuantity)
									END AS ExerciseQuantity,
									GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
							FROM	GrantRegistration 
									INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
									INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
									INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 
									INNER JOIN ShExercisedOptions ON GrantLeg.ID = ShExercisedOptions.GrantLegSerialNumber    
							GROUP BY ShExercisedOptions.ExerciseDate, GrantOptions.GrantOptionId, GrantRegistration.GrantRegistrationId, Scheme.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId, ShExercisedOptions.GrantLegSerialNumber, GrantLeg.VestingType, GrantLeg.Parent, GrantOptions.EmployeeId 
				')
        END

-- Set Parameter for applicable Bonus and Split for particular company
BEGIN
SET NOCOUNT ON; 
	DECLARE @ApplyBonusTo VARCHAR(10), @ApplySplitTo VARCHAR(10), @DisplayAs VARCHAR(10), @DisplaySplit VARCHAR(10)
	SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
	DECLARE @OptionsGranted VARCHAR(50), @OptionsExercised VARCHAR(50), @OptionsCancelled VARCHAR(50)			
	DECLARE @UnVestedOptionsGranted VARCHAR(50), @UnVestedOptionsExercised VARCHAR(50), @UnVestedOptionsCancelled VARCHAR(50)			
    
    IF(@DisplayParm IS NOT NULL)
    BEGIN 
		SET @DisplayAs = UPPER(@DisplayParm)
		SET @DisplaySplit = UPPER(@DisplayParm)
	END
	ELSE
		SET @DisplayParm = ''
	
	DECLARE @DYNAMIC_TABLE_NAME AS VARCHAR(500)
	SET @DYNAMIC_TABLE_NAME = ''
	SET @DYNAMIC_TABLE_NAME = 'DYNAMIC_REPORT_' + REPLACE(@FROM_DATE,'-','_') + '_' + REPLACE(@TO_DATE,'-','_')
	
	IF (@EMPLOYEE_ID <> '')
		SET @DYNAMIC_TABLE_NAME = @DYNAMIC_TABLE_NAME + '_' + @EMPLOYEE_ID
		
	IF (@DisplayParm <> '')
		SET @DYNAMIC_TABLE_NAME = @DYNAMIC_TABLE_NAME + '_' + @DisplayParm
		

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
SET NOCOUNT OFF; 
-- Set Parameter  for applicable Bonus and Split for particular company [END]
END

IF EXISTS(SELECT NAME FROM SYS.tables WHERE name = + @DYNAMIC_TABLE_NAME)
BEGIN
	EXECUTE ('SELECT * FROM ' + @DYNAMIC_TABLE_NAME)
END
ELSE
BEGIN
DECLARE @TEMP_GUID VARCHAR(100) = REPLACE((SELECT NEWID()), '-', '_')

--CREATE GLOBAL TEMP TABLE BASED ON VIEWS
BEGIN
SET NOCOUNT ON; 
	IF (LEN(@STR_EMPLOYEEID) > 0)
	BEGIN
		SET @STR_EMPLOYEEID = REPLACE(@STR_EMPLOYEEID , 'WHERE','AND')
	END
	EXEC ('SELECT * INTO ##VW_CancelledQuantity_' + @TEMP_GUID + ' FROM VW_CancelledQuantity WHERE GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +'''' + @STR_EMPLOYEEID)
	EXEC ('SELECT * INTO ##VW_ExercisedQuantity_' + @TEMP_GUID + ' FROM VW_ExercisedQuantity  WHERE GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +'''' + @STR_EMPLOYEEID)
	EXEC ('SELECT * INTO ##VW_UnApprovedQuantity_' + @TEMP_GUID + ' FROM VW_UnApprovedQuantity WHERE GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +'''' + @STR_EMPLOYEEID)
	IF (LEN(@STR_EMPLOYEEID) > 0)
	BEGIN
		SET @STR_EMPLOYEEID = REPLACE(@STR_EMPLOYEEID , 'AND','WHERE')
	END
SET NOCOUNT OFF; 	
END

---When "displayAs" is "CONSOLIDATED" view
IF(@DisplayAs = 'C') 

BEGIN

		SET @STR_SQL1 =     
		'SELECT OptionsGranted, 
				((OptionsGranted - (OptionsExercised + OptionsCancelled + OptionsLapsed + ISNULL(OptionsUnVested,0))) - [Pending For Approval]) AS OptionsVested, 
				OptionsExercised, OptionsCancelled, OptionsLapsed, ISNULL(OptionsUnVested,0) AS OptionsUnVested, [Pending For Approval],
				GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId,     
				Employeeid,employeename, SBU, AccountNo, PANNumber,Entity, Status, GrantDate, [Vesting Type], ExercisePrice, VestingDate, ExpirayDate, ''---'' as Parent_Note, UnvestedCancelled, VestedCancelled,
				INSTRUMENT_NAME, CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus, CountryName, CurrencyAlias, MIT_ID, '''' CancellationReason
		INTO ' + @DYNAMIC_TABLE_NAME + ' FROM          
		(    
		 SELECT	SUM(' + @OptionsGranted  + ') AS OptionsGranted,
					ISNULL((SELECT	
						CASE WHEN GL_UnVested.VestingType = ''P'' THEN
							CASE WHEN GL_UnVested.FINALVESTINGDATE >  '''+ @TO_DATE +''' THEN 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN
									SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0)
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END
							ELSE 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN 
									SUM(' + @UnVestedOptionsGranted  + ' - (' + @UnVestedOptionsCancelled  + ' + GL_UnVested.LAPSEDQUANTITY +  ' + @UnVestedOptionsExercised  + ' + GL_UnVested.UNAPPROVEDEXERCISEQUANTITY)) 
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END 
							END 
						ELSE --THIS MEANS GrantLeg.VestingType = ''T''
							CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN 
								SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0)							
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
					GROUP BY GL_UnVested.VestingType, GL_UnVested.FinalVestingDate, GL_UnVested.IsPerfBased,GL_UnVested.GrantLegId,GL_UnVested.GrantOptionId),0) AS OptionsUnVested,'

		SET @STR_SQL2 =			
		'			ISNULL((SELECT ISNULL(SUM(vw_Ex.ExercisedQuantity),0) FROM ##VW_ExercisedQuantity_' + @TEMP_GUID + ' vw_Ex WHERE vw_Ex.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Ex.ExercisedDate) <= CONVERT(DATE, '''+ @TO_DATE +''') AND vw_Ex.GrantOptionId = GrantLeg.GrantOptionId AND vw_Ex.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Ex.SchemeId = GrantLeg.SchemeId AND vw_Ex.GrantLegId = GrantLeg.GrantLegId AND vw_Ex.VestingType = GrantLeg.VestingType),0) AS OptionsExercised,            			
					ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType),0) AS OptionsCancelled,
					CASE WHEN GrantLeg.FinalExpirayDate<= ''' + @TO_DATE + '''THEN SUM(GRANTLEG.LapsedQuantity) ELSE 0 END AS OptionsLapsed,
					ISNULL((SELECT ISNULL(SUM(vw_Un.ExerciseQuantity),0) FROM ##VW_UnApprovedQuantity_' + @TEMP_GUID + ' vw_Un WHERE vw_Un.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE,vw_Un.ExerciseDate) <= CONVERT(DATE,'''+ @TO_DATE +''') AND vw_Un.GrantOptionId = GrantLeg.GrantOptionId AND vw_Un.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Un.SchemeId = GrantLeg.SchemeId AND vw_Un.GrantLegId = GrantLeg.GrantLegId AND vw_Un.VestingType = GrantLeg.VestingType),0) AS ''Pending For Approval'',                        
					--OptionsVested ARE CALUCUATED BASED ON THE ABOVE QUANTITIES, 
					GrantLeg.GrantOptionId, GrantLeg.GrantLegId, GrantLeg.SchemeId, GrantLeg.GrantRegistrationId,                
					Employeemaster.Employeeid, Employeemaster.employeename, EmployeeMaster.SBU, EmployeeMaster.AccountNo, EmployeeMaster.PANNumber, EmployeeMaster.Entity, EmployeeMaster.COST_CENTER,
					EmployeeMaster.Department, EmployeeMaster.Location, EmployeeMaster.EmployeeDesignation, EmployeeMaster.Grade, EmployeeMaster.ResidentialStatus, CONM.CountryName AS CountryName,
					CASE WHEN EmployeeMaster.ReasonForTermination IS NULL THEN ''Live'' WHEN  EmployeeMaster.ReasonForTermination IS NOT NULL AND CONVERT(DATE, Employeemaster.LWD) > CONVERT(DATE, GETDATE()) THEN ''Live'' ELSE ''Separated'' END AS Status,
					GrantRegistration.GrantDate,CASE WHEN Grantleg.VestingType = ''T'' Then ''Time Based'' Else ''PerFormance Based'' End AS ''Vesting Type'',    
					GrantRegistration.ExercisePrice, Grantleg.FinalVestingDate as VestingDate, Grantleg.FinalExpirayDate as ExpirayDate,
					ISNULL((SELECT SUM(vw_Cn.UnVestedCancelled) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType),0) AS UnvestedCancelled,
					ISNULL((SELECT SUM(vw_Cn.VestedCancelled) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType),0) AS VestedCancelled,
					CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MST.INSTRUMENT_NAME END AS INSTRUMENT_NAME, CM.CurrencyName, CM.CurrencyAlias, MST.MIT_ID
					
		 FROM       GrantRegistration 
					INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
					INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
					INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 						
					INNER JOIN Employeemaster ON Employeemaster.employeeid = GrantOptions.Employeeid
					INNER JOIN MST_INSTRUMENT_TYPE MST ON Scheme.MIT_ID = MST.MIT_ID
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON Scheme.MIT_ID=CIM.MIT_ID
					LEFT OUTER JOIN CurrencyMaster CM ON CIM.CurrencyID=CM.CurrencyID
					LEFT OUTER JOIN CountryMaster CONM ON Employeemaster.CountryName = CONM.CountryAliasName  
					
		 WHERE     (GrantRegistration.GrantDate BETWEEN '''+@FROM_DATE+''' AND '''+@TO_DATE+''')
		 GROUP BY	GrantLeg.GrantOptionId, GrantLeg.GrantRegistrationId, GrantLeg.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId,
					Employeemaster.Employeeid, Employeemaster.employeename, EmployeeMaster.SBU, EmployeeMaster.AccountNo, EmployeeMaster.PANNumber, EmployeeMaster.Entity, EmployeeMaster.COST_CENTER,
					EmployeeMaster.Department, EmployeeMaster.Location, EmployeeMaster.EmployeeDesignation, EmployeeMaster.Grade, EmployeeMaster.ResidentialStatus,
					EmployeeMaster.CountryName, CONM.CountryName,CONM.CountryAliasName,
					Employeemaster.ReasonForTermination,  GrantRegistration.GrantDate, Grantleg.VestingType,
					GrantRegistration.ExercisePrice, Grantleg.FinalVestingDate, Grantleg.FinalExpirayDate, GrantLeg.IsPerfBased,
					MST.INSTRUMENT_NAME, CM.CurrencyName, CM.CurrencyAlias, MST.MIT_ID, CIM.INS_DISPLY_NAME, EmployeeMaster.LWD
		)    
		AS OUTPUT_DATA 
		'
END		

--------------------------------------------------------------------------------------------------------------------------------------------
-----When "displayAs" is "SEPRATE" view
ELSE IF(@DisplayAs = 'S') 

BEGIN

		SET @STR_SQL1 =     
		'SELECT OptionsGranted, 
				((OptionsGranted - (OptionsExercised + OptionsCancelled + OptionsLapsed + ISNULL(OptionsUnVested,0))) - [Pending For Approval]) AS OptionsVested, 
				OptionsExercised, OptionsCancelled, OptionsLapsed, ISNULL(OptionsUnVested,0) AS OptionsUnVested, [Pending For Approval],
				GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId,     
				Employeeid,employeename, SBU, AccountNo, PANNumber,Entity,Status,GrantDate, [Vesting Type], ExercisePrice, VestingDate, ExpirayDate, CASE WHEN Parent_Note = ''N'' THEN ''Original'' ELSE ''Bonus'' END as Parent_Note, UnVestedCancelled, VestedCancelled, 
				INSTRUMENT_NAME , CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus, 
				CountryName, CurrencyAlias, MIT_ID, '''' CancellationReason
		INTO ' + @DYNAMIC_TABLE_NAME + ' FROM           
		(    
		 SELECT	SUM(' + @OptionsGranted  + ') AS OptionsGranted,
					ISNULL((SELECT	
						CASE WHEN GL_UnVested.VestingType = ''P'' THEN
							CASE WHEN GL_UnVested.FINALVESTINGDATE >  '''+ @TO_DATE +''' THEN 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN
									SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0)
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END
							ELSE 
								CASE WHEN GL_UnVested.ISPERFBASED = ''N'' THEN 
									SUM(' + @UnVestedOptionsGranted  + ' - (' + @UnVestedOptionsCancelled  + ' + GL_UnVested.LAPSEDQUANTITY +  ' + @UnVestedOptionsExercised  + ' + GL_UnVested.UNAPPROVEDEXERCISEQUANTITY)) 
								ELSE 
									CASE WHEN CONVERT(DATE,GL_UnVested.FINALVESTINGDATE) > CONVERT(DATE,'''+ @TO_DATE +''') THEN
										(SELECT SUM(PFG_INNER.CancelledQuantity + PFG_INNER.NumberOfOptionsGranted) FROM PerformanceBasedGrant PFG_INNER WHERE PFG_INNER.GrantLegID = GL_UnVested.GrantLegId AND PFG_INNER.GrantOptionID = GL_UnVested.GrantOptionId) - (ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE 0 END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0) + ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0))
									ELSE
										SUM(PFG.NumberOfOptionsAvailable - (PFG.CancelledQuantity + PFG.NumberOfOptionsGranted + ISNULL(PFG.NumberOfOptionsTransferred,0)))  
									END
								END 
							END 
						ELSE --THIS MEANS GrantLeg.VestingType = ''T''
							CASE WHEN GL_UnVested.FINALVESTINGDATE > '''+ @TO_DATE +''' THEN 
								SUM(' + @UnVestedOptionsGranted  + ') - ISNULL((SELECT CASE WHEN vw_Cn.IsPerfBased = ''1'' THEN CASE WHEN vw_Cn.PERF_LastUpdatedOn > '''+ @TO_DATE +''' THEN SUM(vw_Cn.PERF_NumberOfOptionsAvailable - (vw_Cn.PERF_CancelledQuantity + vw_Cn.PERF_NumberOfOptionsGranted)) ELSE SUM(vw_Cn.PERF_CancelledQuantity) END ELSE ISNULL(SUM(vw_Cn.CancelledQuantity),0)  END CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE, vw_Cn.CancelledDate)<= CONVERT(DATE,'''+ @TO_DATE +''')  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType, vw_Cn.IsPerfBased,vw_Cn.PERF_LastUpdatedOn),0)							
							ELSE 
								0
							END			
						END
					FROM	GrantLeg AS GL_UnVested 
							INNER JOIN GrantRegistration AS GR_UnVested ON GR_UnVested.GrantRegistrationId = GL_UnVested.GrantRegistrationId					
							LEFT OUTER JOIN PerformanceBasedGrant PFG ON PFG.GrantLegID = GL_UnVested.GrantLegId AND PFG.GrantOptionID = GL_UnVested.GrantOptionId
					WHERE	(GR_UnVested.GrantDate BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''') AND
							GL_UnVested.grantregistrationId  = GrantLeg.GrantRegistrationId AND GL_UnVested.GrantOptionId = GrantLeg.GrantOptionId AND 
							GL_UnVested.GrantLegId = GrantLeg.GrantLegId and GL_UnVested.VestingType= GrantLeg.VestingType AND GL_UnVested.Parent = GrantLeg.Parent
					GROUP BY GL_UnVested.VestingType, GL_UnVested.FinalVestingDate, GL_UnVested.IsPerfBased, GL_UnVested.Parent,GL_UnVested.GrantLegId,GL_UnVested.GrantOptionId),0) AS OptionsUnVested,
		'

		SET @STR_SQL2 =			
		'			ISNULL((SELECT ISNULL(SUM(vw_Ex.ExercisedQuantity),0) FROM ##VW_ExercisedQuantity_' + @TEMP_GUID + ' vw_Ex WHERE vw_Ex.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Ex.ExercisedDate<= '''+ @TO_DATE +''' AND vw_Ex.GrantOptionId = GrantLeg.GrantOptionId AND vw_Ex.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Ex.SchemeId = GrantLeg.SchemeId AND vw_Ex.GrantLegId = GrantLeg.GrantLegId AND vw_Ex.VestingType = GrantLeg.VestingType AND vw_Ex.Parent = GrantLeg.Parent),0) AS OptionsExercised,            			
					ISNULL((SELECT SUM(vw_Cn.CancelledQuantity) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType),0) AS OptionsCancelled,
					CASE WHEN GrantLeg.FinalExpirayDate<= ''' + @TO_DATE + '''THEN SUM(GRANTLEG.LapsedQuantity) ELSE 0 END AS OptionsLapsed,
					ISNULL((SELECT ISNULL(SUM(vw_Un.ExerciseQuantity),0) FROM ##VW_UnApprovedQuantity_' + @TEMP_GUID + ' vw_Un WHERE vw_Un.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND CONVERT(DATE,vw_Un.ExerciseDate) <= CONVERT(DATE,'''+ @TO_DATE +''') AND vw_Un.GrantOptionId = GrantLeg.GrantOptionId AND vw_Un.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Un.SchemeId = GrantLeg.SchemeId AND vw_Un.GrantLegId = GrantLeg.GrantLegId AND vw_Un.VestingType = GrantLeg.VestingType AND vw_Un.Parent = GrantLeg.Parent),0) AS ''Pending For Approval'',                        
					--OptionsVested ARE CALUCUATED BASED ON THE ABOVE QUANTITIES, 
					GrantLeg.GrantOptionId, GrantLeg.GrantLegId, GrantLeg.SchemeId, GrantLeg.GrantRegistrationId,                
					Employeemaster.Employeeid, Employeemaster.employeename, EmployeeMaster.SBU, EmployeeMaster.AccountNo, EmployeeMaster.PANNumber, EmployeeMaster.Entity, EmployeeMaster.COST_CENTER,
					EmployeeMaster.Department, EmployeeMaster.Location, EmployeeMaster.EmployeeDesignation, EmployeeMaster.Grade, EmployeeMaster.ResidentialStatus, 
					CONM.CountryName AS CountryName,   
					CASE WHEN EmployeeMaster.ReasonForTermination IS NULL THEN ''Live'' WHEN  EmployeeMaster.ReasonForTermination IS NOT NULL AND CONVERT(DATE, Employeemaster.LWD) > CONVERT(DATE, GETDATE()) THEN ''Live'' ELSE ''Separated'' END AS Status,      
					GrantRegistration.GrantDate,
					CASE WHEN Grantleg.VestingType = ''T'' Then ''Time Based'' Else ''PerFormance Based'' End AS ''Vesting Type'',    
					GrantRegistration.ExercisePrice, Grantleg.FinalVestingDate as VestingDate, Grantleg.FinalExpirayDate as ExpirayDate, GrantLeg.Parent as Parent_Note,
					ISNULL((SELECT SUM(vw_Cn.UnVestedCancelled) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType),0) AS UnvestedCancelled,
					ISNULL((SELECT SUM(vw_Cn.VestedCancelled) CancelledQuantity FROM ##VW_CancelledQuantity_' + @TEMP_GUID + ' vw_Cn WHERE vw_Cn.GrantDate  BETWEEN '''+ @FROM_DATE +''' AND '''+ @TO_DATE +''' AND vw_Cn.CancelledDate<= '''+ @TO_DATE +'''  AND vw_Cn.GrantOptionId = GrantLeg.GrantOptionId AND vw_Cn.GrantRegistrationId = GrantLeg.GrantRegistrationId AND vw_Cn.SchemeId = GrantLeg.SchemeId AND vw_Cn.GrantLegId = GrantLeg.GrantLegId AND vw_Cn.VestingType = GrantLeg.VestingType AND vw_Cn.Parent = GrantLeg.Parent GROUP BY vw_Cn.VestingType),0) AS VestedCancelled,
					CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MST.INSTRUMENT_NAME END AS INSTRUMENT_NAME , 
					CM.CurrencyName,CM.CurrencyAlias, MST.MIT_ID
					
		 FROM       GrantRegistration 
					INNER JOIN Scheme ON GrantRegistration.SchemeId = Scheme.SchemeId 
					INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId 
					INNER JOIN GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId 						
					INNER JOIN Employeemaster ON Employeemaster.employeeid = GrantOptions.Employeeid
					INNER JOIN MST_INSTRUMENT_TYPE MST ON Scheme.MIT_ID = MST.MIT_ID
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON Scheme.MIT_ID = CIM.MIT_ID
					LEFT OUTER JOIN CurrencyMaster CM ON CIM.CurrencyID = CM.CurrencyID
					LEFT OUTER JOIN CountryMaster CONM ON Employeemaster.CountryName = CONM.CountryAliasName
					
					
		 WHERE     (GrantRegistration.GrantDate BETWEEN '''+@FROM_DATE+''' AND '''+@TO_DATE+''')
		 GROUP BY	GrantLeg.GrantOptionId, GrantLeg.GrantRegistrationId, GrantLeg.SchemeId, GrantRegistration.GrantDate, GrantLeg.GrantLegId,
					Employeemaster.Employeeid, Employeemaster.employeename, EmployeeMaster.SBU, EmployeeMaster.AccountNo, EmployeeMaster.PANNumber, EmployeeMaster.Entity, EmployeeMaster.COST_CENTER,
					EmployeeMaster.Department, EmployeeMaster.Location, EmployeeMaster.EmployeeDesignation, EmployeeMaster.Grade, EmployeeMaster.ResidentialStatus,
					EmployeeMaster.CountryName,CONM.CountryName,CONM.CountryAliasName,
					Employeemaster.ReasonForTermination,  GrantRegistration.GrantDate, Grantleg.VestingType,
					GrantRegistration.ExercisePrice, Grantleg.FinalVestingDate, Grantleg.FinalExpirayDate, GrantLeg.IsPerfBased, GrantLeg.Parent,
					MST.INSTRUMENT_NAME, CM.CurrencyName, CM.CurrencyAlias, MST.MIT_ID, CIM.INS_DISPLY_NAME, EmployeeMaster.LWD
		)    
		AS OUTPUT_DATA 
		'

	END

	SET @STR_ORDERBY = ' ORDER BY  Schemeid, GrantDate, GrantRegistrationId, Employeeid, VestingDate, ExpirayDate, GrantOptionId '

	--PRINT @STR_SQL1 
	--PRINT @STR_SQL2
	--PRINT @STR_EMPLOYEEID 
	--PRINT @STR_ORDERBY
	SET @STR_SQL_FINAL = (@STR_SQL1 + @STR_SQL2 + @STR_EMPLOYEEID + @STR_ORDERBY)
	SET NOCOUNT ON; 
	EXECUTE (@STR_SQL_FINAL)
	EXECUTE ('SELECT * FROM ' + @DYNAMIC_TABLE_NAME)
	SET NOCOUNT OFF; 

	--DROP GLOBAL TEMP TABLE
	BEGIN
		EXEC ('DROP TABLE ##VW_CancelledQuantity_'  + @TEMP_GUID)
		EXEC ('DROP TABLE ##VW_ExercisedQuantity_'  + @TEMP_GUID)
		EXEC ('DROP TABLE ##VW_UnApprovedQuantity_' + @TEMP_GUID)
	END
END

END
GO


