/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_QTR_EXD_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EMPLOYEE_QTR_EXD_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EMPLOYEE_QTR_EXD_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMPLOYEE_QTR_EXD_DATA] 
    
AS
BEGIN
	SET NOCOUNT ON;
	
	/* Insert data in #VW_AdditionalExercisedQuantity table */
	SELECT DISTINCT GOPA.BaseGrantOptionId, GOPA.AssociationToVestId, VWEX.ExercisedQuantity AS AssociatedGrantOptionQty, VWEX.ExercisedDate INTO #GrantOptionIdAssociation
	FROM GrantOptionIdAssociation GOPA INNER JOIN VW_ExercisedQuantity VWEX ON VWEX.GrantOptionId = GOPA.AssociatedGrantOptionId AND 
	VWEX.GrantLegId = GOPA.AssociationToVestId
	
	/* Create temp table #VW_ExercisedQuantity table */
	CREATE TABLE #VW_ExercisedQuantity
	(
		VW_SR_NO INT IDENTITY(1,1),
		ExercisedDate DATETIME,
		ExercisedQuantity INT, 
		GrantOptionId	VARCHAR(200),
		GrantRegistrationId	VARCHAR(200),
		SchemeId	VARCHAR(200),
		GrantDate	DATETIME,
		GrantLegId	INT,
		VestingType	VARCHAR(10),
		Parent	VARCHAR(100),
		EmployeeId	VARCHAR(200),

	)

	/* Insert data in #VW_ExercisedQuantity table */
	INSERT INTO #VW_ExercisedQuantity (ExercisedDate,ExercisedQuantity, GrantOptionId,GrantRegistrationId,SchemeId,GrantDate,GrantLegId,VestingType,Parent,EmployeeId)
	SELECT ExercisedDate,ExercisedQuantity, GrantOptionId,GrantRegistrationId,SchemeId,GrantDate,GrantLegId,VestingType,Parent,EmployeeId FROM VW_ExercisedQuantity ORDER BY ExercisedDate

	/* Create temp table #TEMP_QUARTERSWISE_DATA table */
	CREATE TABLE #TEMP_QUARTERSWISE_DATA
	(
		SR_NO INT IDENTITY(1,1),
		Financial_Quarters NVARCHAR(100)
	)

	DECLARE @SDATE DATE = (SELECT MIN(ExercisedDate) FROM #VW_ExercisedQuantity)
	DECLARE @EDATE DATE = (SELECT MAX(ExercisedDate) FROM #VW_ExercisedQuantity)
	
	/* CTE to get financial years */
	;with rs as
	(
	   select   1 r,@SDATE s
	   union all 
	   select r+1, DATEADD(qq,1,s)  from rs where r<=datediff(qq,@SDATE,@EDATE)
	)
	
	/* Insert data in #TEMP_QUARTERSWISE_DATA table */
	INSERT INTO #TEMP_QUARTERSWISE_DATA 
	SELECT	
		CASE LEFT(DATENAME(MM,S),10) 
			WHEN 'April' THEN 'Q1' + ' ' + CAST(YEAR(S) AS VARCHAR) + '-' + CAST(YEAR(S) + 1 AS VARCHAR)
			WHEN 'July' THEN 'Q2'  + ' ' + CAST(YEAR(S) AS VARCHAR) + '-' + CAST(YEAR(S) + 1 AS VARCHAR)
			WHEN 'October' THEN 'Q3'  + ' ' + CAST(YEAR(S) AS VARCHAR) + '-' + CAST(YEAR(S) + 1 AS VARCHAR)
			WHEN 'January' THEN 'Q4'  + ' ' + CAST(YEAR(S) - 1 AS VARCHAR) + '-' + CAST(YEAR(S) AS VARCHAR)
			END  AS Financial_Quarters	
	FROM RS
	
	/* Create temp table #TEMP_QUARTERSWISE_EXERCISED_DATA and insert data */	
	DECLARE @Q1_START_MONTH		INT = (SELECT MONTH(MIN([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 1),
			@Q1_END_MONTH		INT = (SELECT MONTH(MAX([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 1),
			@Q2_START_MONTH		INT = (SELECT MONTH(MIN([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 2),
			@Q2_END_MONTH		INT = (SELECT MONTH(MAX([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 2),
			@Q3_START_MONTH		INT = (SELECT MONTH(MIN([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 3),
			@Q3_END_MONTH		INT = (SELECT MONTH(MAX([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 3),
			@Q4_START_MONTH		INT = (SELECT MONTH(MIN([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 4),
			@Q4_END_MONTH		INT = (SELECT MONTH(MAX([MONTH])) FROM FinancialYearSetup WHERE [Quarter] = 4)
			
	SELECT * INTO #TEMP_QUARTERSWISE_EXERCISED_DATA FROM
	(
		SELECT  'Q1 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR) Quarters, * FROM #VW_ExercisedQuantity where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q1_START_MONTH AND @Q1_END_MONTH
		UNION
		SELECT  'Q2 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR), * FROM #VW_ExercisedQuantity where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q2_START_MONTH AND @Q2_END_MONTH
		UNION
		SELECT  'Q3 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR), * FROM #VW_ExercisedQuantity where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q3_START_MONTH AND @Q3_END_MONTH
		UNION
		SELECT  'Q4 ' +CAST(YEAR(ExercisedDate) - 1 as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) as VARCHAR), * FROM #VW_ExercisedQuantity where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q4_START_MONTH AND @Q4_END_MONTH
		UNION
		SELECT  'Q1 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR), 0, ExercisedDate, AssociatedGrantOptionQty, BaseGrantOptionId, '', '', GETDATE(), AssociationToVestId, '', '', '' FROM #GrantOptionIdAssociation where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q1_START_MONTH AND @Q1_END_MONTH
		UNION
		SELECT  'Q2 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR), 0, ExercisedDate, AssociatedGrantOptionQty, BaseGrantOptionId, '', '', GETDATE(), AssociationToVestId, '', '', '' FROM #GrantOptionIdAssociation where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q2_START_MONTH AND @Q2_END_MONTH
		UNION
		SELECT  'Q3 ' +CAST(YEAR(ExercisedDate) as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) + 1 as VARCHAR), 0, ExercisedDate, AssociatedGrantOptionQty, BaseGrantOptionId, '', '', GETDATE(), AssociationToVestId, '', '', '' FROM #GrantOptionIdAssociation where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q3_START_MONTH AND @Q3_END_MONTH
		UNION
		SELECT  'Q4 ' +CAST(YEAR(ExercisedDate) - 1 as VARCHAR) + '-' + CAST(YEAR(ExercisedDate) as VARCHAR), 0, ExercisedDate, AssociatedGrantOptionQty, BaseGrantOptionId, '', '', GETDATE(), AssociationToVestId, '', '', '' FROM #GrantOptionIdAssociation where CAST(MONTH(ExercisedDate) as INT) BETWEEN  @Q4_START_MONTH AND @Q4_END_MONTH
	 
	) AS ExercisedData

	/* Get final output */
	SELECT 
			QD.SR_NO, QD.Financial_Quarters, SUM(ExercisedQuantity) AS ExercisedQuantity, QED.GrantOptionId, EmployeeId, ROW_NUMBER() OVER(Partition by Financial_Quarters ORDER BY Financial_Quarters) AS RNO
	FROM 
			#TEMP_QUARTERSWISE_DATA AS QD 
	LEFT OUTER JOIN 
			#TEMP_QUARTERSWISE_EXERCISED_DATA AS QED ON QD.Financial_Quarters = QED.Quarters
	WHERE QED.GrantOptionId NOT IN (SELECT ISNULL(AssociatedGrantOptionId, '') FROM GrantOptionIdAssociation)
	GROUP BY QD.SR_NO, QD.Financial_Quarters, QED.GrantOptionId, EmployeeId
	ORDER BY SR_NO

	SET NOCOUNT OFF;
END
GO
