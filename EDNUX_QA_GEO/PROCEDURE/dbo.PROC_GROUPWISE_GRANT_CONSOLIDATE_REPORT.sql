/****** Object:  StoredProcedure [dbo].[PROC_GROUPWISE_GRANT_CONSOLIDATE_REPORT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GROUPWISE_GRANT_CONSOLIDATE_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GROUPWISE_GRANT_CONSOLIDATE_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GROUPWISE_GRANT_CONSOLIDATE_REPORT](@SelectType VARCHAR(30), @FROM_DATE DATE = NULL, @TO_DATE DATE = NULL)
AS
BEGIN
	
	DECLARE @SQL_QUERY AS VARCHAR(MAX), @GROUP_BY VARCHAR(1000), @COLUMN_NAME VARCHAR(500)
	DECLARE @EmployeeId AS VARCHAR(20)
	DECLARE @DisplayPram AS CHAR(1)
	
	SET NOCOUNT ON;
	
	CREATE TABLE #GROUPWISE_GRANT_CONSOLIDATE_DATA
	(
		OptionsGranted NUMERIC(18,0), OptionsVested NUMERIC(18,0), OptionsUnVested NUMERIC(18,0), OptionsExercised NUMERIC(18,0), OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0),  PendingForApproval NUMERIC(18,0), GrantOptionId NVARCHAR(100), GrantLegId NUMERIC(18,0), SchemeId NVARCHAR(150), GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150), EmployeeName NVARCHAR(250), SBU NVARCHAR(100) NULL, AccountNo NVARCHAR(100) NULL, PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100), GrantDate DATETIME, VestingType NVARCHAR(100), ExercisePrice numeric(10,2), VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), 		
		Location VARCHAR(200), Grade VARCHAR(200), UnvestedCancelled NUMERIC(18,0), VestedCancelled NUMERIC(18,0),
		INSTRUMENT_NAME VARCHAR(100), CurrencyName VARCHAR(100),
		COST_CENTER VARCHAR(100), Department VARCHAR(100), EmployeeDesignation VARCHAR(100), ResidentialStatus VARCHAR(100),
		CountryName NVARCHAR (100), CurrencyAlias NVARCHAR (50),MIT_ID INT,CancellationReason NVARCHAR (1000)
	)
	
	IF(@FROM_DATE IS NULL)
		BEGIN
			-- GET TODAY'S DATE	
			SELECT @FROM_DATE = CONVERT(DATE,GETDATE())
		END
	ELSE
		BEGIN
			-- SELECT DATE FROM PICKER
			SELECT @FROM_DATE = @FROM_DATE
		END
		
    IF(@TO_DATE IS NULL)
		BEGIN
			-- GET TODAY'S DATE	
			SELECT @TO_DATE = CONVERT(DATE,GETDATE())
		END
	ELSE
		BEGIN
			-- SELECT DATE FROM PICKER
			SELECT @TO_DATE = @TO_DATE
		END
		
	-- FETCH DETAILS FROM SP_REPORT_DATA AND INSERT THE SAME IN #GROUPWISE_GRANT_CONSOLIDATE_DATA TABLE		
	INSERT INTO #GROUPWISE_GRANT_CONSOLIDATE_DATA
	(
		OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber,
		Entity, [Status], GrantDate, VestingType, ExercisePrice, VestingDate, ExpiryDate, Parent_Note, UnvestedCancelled, VestedCancelled, INSTRUMENT_NAME, CurrencyName,
		COST_CENTER, Department,Location, EmployeeDesignation, Grade, ResidentialStatus,CountryName,CurrencyAlias,MIT_ID,CancellationReason
	)

	--SELECT * FROM #GROUPWISE_GRANT_CONSOLIDATE_DATA
	EXECUTE SP_REPORT_DATA '1900-01-01', @TO_DATE, NULL, NULL
	/* EXECUTE SP_REPORT_DATA '1900-01-01','2017-11-06',NULL,NULL*/

	
	--UPDATE DETAILS FOR GROUPWISE_GRANT_CONSOLIDATE_REPORT : SelectType
	UPDATE 		TD 
	SET 		Location = EM.Location, Grade = EM.Grade 
	FROM 		#GROUPWISE_GRANT_CONSOLIDATE_DATA AS TD 
	INNER JOIN 	EmployeeMaster AS EM ON TD.Employeeid = EM.EmployeeID

    IF(UPPER(@SelectType) = 'LOCATION')
	BEGIN
		SET @GROUP_BY = ' GROUP BY Location, GrantRegistrationId, INSTRUMENT_NAME, CurrencyName, SchemeId, GrantDate, ExercisePrice, CurrencyAlias ORDER BY Location ASC'
		SET @COLUMN_NAME = 'Location AS Type, ' 
	END
	
	ELSE IF(UPPER(@SelectType) = 'ENTITY')
	BEGIN
		SET @GROUP_BY = ' GROUP BY Entity, GrantRegistrationId, INSTRUMENT_NAME, CurrencyName, SchemeId, GrantDate, ExercisePrice, CurrencyAlias ORDER BY Entity ASC'
		SET @COLUMN_NAME = 'Entity AS Type, ' 
	END
	
	ELSE IF(UPPER(@SelectType) = 'SBU')
	BEGIN
		SET @GROUP_BY = ' GROUP BY SBU, GrantRegistrationId, INSTRUMENT_NAME, CurrencyName, SchemeId, GrantDate, ExercisePrice, CurrencyAlias  ORDER BY SBU ASC'
		SET @COLUMN_NAME = 'SBU AS Type, ' 
	END
	
	ELSE IF(UPPER(@SelectType) = 'GRADE ')
	BEGIN
		SET @GROUP_BY = ' GROUP BY Grade, GrantRegistrationId, INSTRUMENT_NAME, CurrencyName, SchemeId, GrantDate, ExercisePrice, CurrencyAlias  ORDER BY Grade ASC'
		SET @COLUMN_NAME = 'Grade AS Type, ' 
	END
	
	SET @SQL_QUERY = 
			' SELECT '+ @COLUMN_NAME +'SUM(OptionsGranted) AS OptionsGranted, SUM(OptionsVested) AS OptionsVested, SUM(OptionsExercised) AS OptionsExercised, 
			SUM(OptionsCancelled) AS OptionsCancelled, SUM(OptionsLapsed) AS OptionsLapsed, SUM(OptionsUnVested) AS  OptionsUnVested, SUM(PendingForApproval) AS PendingForApproval, INSTRUMENT_NAME, CurrencyName,
			SchemeId, GrantRegistrationId, GrantDate, ExercisePrice , CurrencyAlias	 
			FROM #GROUPWISE_GRANT_CONSOLIDATE_DATA '
	
	EXECUTE (@SQL_QUERY + @GROUP_BY)	
	--PRINT (@SQL_QUERY + @GROUP_BY)	
END

GO
