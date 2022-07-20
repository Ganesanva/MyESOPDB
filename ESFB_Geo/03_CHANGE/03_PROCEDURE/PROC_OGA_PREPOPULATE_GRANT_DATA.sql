DROP PROCEDURE IF EXISTS [dbo].[PROC_OGA_PREPOPULATE_GRANT_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_OGA_PREPOPULATE_GRANT_DATA]    Script Date: 18-07-2022 15:12:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PROC_OGA_PREPOPULATE_GRANT_DATA]
	@POPULATE_DATA_FOR	VARCHAR(50),
	@GrantDateFrom	DATETIME,
	@GrantDateTo	DATETIME,
	@StartIndex		INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF (@POPULATE_DATA_FOR = 'MYESOPS_DATA')
	BEGIN
	
		/* Get comma seperated VestingPercentage from VestingPeriod */
		SELECT * INTO #TEMP_COMMA_SEPERATED_VEST_PER FROM
		(
			SELECT GrantRegistrationId, OptionTimePercentage = 
				STUFF((SELECT ', ' + CONVERT(VARCHAR(10), OptionPerformancePercentage)
					   FROM VestingPeriod VPB 
					   WHERE VPB.GrantRegistrationId = VPA.GrantRegistrationId 
					  FOR XML PATH('')), 1, 2, '')
			FROM VestingPeriod VPA
			GROUP BY GrantRegistrationId
		) AS TEMP

		/* Get first VestDate and NumberOfVesting from GrantLeg */
		SELECT * INTO #TEMP_FIRST_VEST FROM
		(
			SELECT MIN(GLx.VestingDate) AS FirstVestingDate, COUNT(VestingDate) AS NoOfVests, GLx.GrantOptionId FROM GrantLeg GLx
			JOIN 
			(
				SELECT GLy.GrantOptionId, MAX(VestingDate) AS max_total FROM GrantLeg GLy
				GROUP BY GLy.GrantOptionId
			) AS TempGL ON TempGL.GrantOptionId = GLx.GrantOptionId
			WHERE Parent = 'N'
			GROUP BY GLx.GrantOptionId
		) AS T_FIRST_VEST

		/* Get company details from CurrencyMaster */
		SELECT * INTO #TEMP_COMPANY_DETAILS FROM
		(
			SELECT CM.CompanyName, CM.CompanyAddress, CUR.CurrencyAlias FROM CompanyMaster AS CM
			INNER JOIN CurrencyMaster AS CUR ON CM.BaseCurrencyID = CUR.CurrencyID
		) AS #TEMP_COMPANY_DETAILS
		
		SELECT * INTO #EmployeeMaster FROM EmployeeMaster WHERE Deleted = 0
		
		--/* Prepopulated data from MyESOPs*/
		SELECT * INTO #FilteredRecords FROM
		(
			SELECT 
				EM.EmployeeId, EM.EmployeeName, 
				GR.SchemeId, GOP.GrantOptionId AS [LetterCode], REPLACE(CONVERT(NVARCHAR, GR.GrantDate, 106), '', '/') AS GrantDate, CASE WHEN GR.IsPerformanceBasedIncluded = '0' THEN 'Time Based' ELSE 'Performance Based' END AS [GrantType], 
				GOP.GrantedOptions AS NoOfOptions, TCM.CurrencyAlias, GR.ExercisePrice, 
				REPLACE(CONVERT(NVARCHAR, TFV.FirstVestingDate, 106), '', '/') AS FirstVestingDate, TFV.NoOfVests, 
				SC.VestingFrequency, 
				TCSV.OptionTimePercentage AS [First Vest Date], 
				SC.AdjustResidueOptionsIn, TCM.CompanyName, CONVERT(VARCHAR(5000), TCM.CompanyAddress) AS [Company Address],
				GR.GrantRegistrationId AS [Lot Number], 
				GR.GrantDate AS GrantDt
			FROM
			GrantRegistration GR 
			INNER JOIN GrantOptions AS GOP ON GOP.GrantRegistrationId = GR.GrantRegistrationId
			INNER JOIN #EmployeeMaster EM ON GOP.EmployeeId = EM.EmployeeID			
			INNER JOIN #TEMP_COMMA_SEPERATED_VEST_PER TCSV ON GR.GrantRegistrationId = TCSV.GrantRegistrationId
			INNER JOIN #TEMP_FIRST_VEST TFV ON GOP.GrantOptionId = TFV.GrantOptionId
			INNER JOIN Scheme SC ON GR.SchemeId = SC.SchemeId
			CROSS JOIN #TEMP_COMPANY_DETAILS AS TCM
			WHERE (CONVERT(DATE, GR.GrantDate) >= CONVERT(DATE, @GrantDateFrom) AND CONVERT(DATE, GR.GrantDate) <= CONVERT(DATE, @GrantDateTo))	
			
			)AS FilteredRecords 
		
		ALTER TABLE #FilteredRecords ADD RowID INT IDENTITY(1,1)
		
		DECLARE @EndIndex INT, @MaxIndex INT
		
		SET @MaxIndex = (SELECT MAX(RowID) FROM #FilteredRecords)
		
		/*If records are more than 1000 then it will pick records without @StartIndex and @EndIndex filters*/
		IF (@MaxIndex > 1000)
		BEGIN
		
			/* Divide data in chunks */
			IF NOT EXISTS(SELECT RowID FROM #FilteredRecords WHERE RowID >= (@StartIndex + 999000))
			BEGIN
				SET @EndIndex = @MaxIndex
			END
			ELSE
			BEGIN
				SET @EndIndex = (@StartIndex + 999000)
			END

			SELECT RowID, EmployeeId,EmployeeName, SchemeId, [LetterCode], GrantDate, [GrantType], NoOfOptions, CurrencyAlias, ExercisePrice, FirstVestingDate, NoOfVests, VestingFrequency, 
				   [First Vest Date], AdjustResidueOptionsIn, CompanyName, [Company Address], [Lot Number], CASE WHEN @MaxIndex = @EndIndex THEN '' ELSE 'MaxLimitReached' END AS MaxLimitReached
			FROM #FilteredRecords WHERE RowID >= @StartIndex AND RowID <= @EndIndex
			
		END
		ELSE
		BEGIN
			SELECT RowID, EmployeeId,EmployeeName, SchemeId, [LetterCode], GrantDate, [GrantType], NoOfOptions, CurrencyAlias, ExercisePrice, FirstVestingDate, NoOfVests, VestingFrequency, 
				   [First Vest Date], AdjustResidueOptionsIn, CompanyName, [Company Address], [Lot Number], '' AS MaxLimitReached
			FROM #FilteredRecords
		END
		
		DROP TABLE #TEMP_COMMA_SEPERATED_VEST_PER
		DROP TABLE #TEMP_FIRST_VEST
		DROP TABLE #TEMP_COMPANY_DETAILS
		
	END
	ELSE IF (@POPULATE_DATA_FOR = 'OGA_DATA')
	BEGIN
	
		SELECT EmployeeID, EmployeeName, '' AS MaxLimitReached  FROM EmployeeMaster WHERE (Deleted = 0)
		
	END
	
	/* Get Mapped fields from OGA_FIELD_MAPPINGS table */
	SELECT FIELD_NAME, MAPPED_FIELD FROM OGA_FIELD_MAPPINGS
		
	SET NOCOUNT OFF;
END
GO


