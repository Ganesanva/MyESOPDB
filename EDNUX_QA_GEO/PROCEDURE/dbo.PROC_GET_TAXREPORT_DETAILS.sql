/****** Object:  StoredProcedure [dbo].[PROC_GET_TAXREPORT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TAXREPORT_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TAXREPORT_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_TAXREPORT_DETAILS] 
(
  @FROM_DATE AS VARCHAR(50)    = NULL, 
  @TO_DATE AS VARCHAR(50)      = NULL, 
  @EMPLOYEE_ID AS VARCHAR(100) = NULL 
)
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE @RoundupPlace_TaxableVal VARCHAR(5), @RoundingParam_TaxableVal VARCHAR(5), @RoundingParam_FMV VARCHAR(5),
	        @RoundupPlace_FMV VARCHAR(5)
	
	IF(ISNULL(@FROM_DATE, '') = '')	  
	  SELECT @FROM_DATE = CAST('1990-01-01' AS DATETIME)
	  
	IF(ISNULL(@TO_DATE, '') = '')	  
	  SELECT @TO_DATE = CAST(GETDATE() AS DATETIME)
	
	CREATE TABLE #EMPLOYEE_TEMP_DATA 
    (			
		OptionsGranted NUMERIC(18,0), OptionsVested NUMERIC(18,0), OptionsExercised NUMERIC(18,0), OptionsCancelled NUMERIC(18,0), 
		OptionsLapsed NUMERIC(18,0), OptionsUnVested NUMERIC(18,0), PendingForApproval NUMERIC(18,0), 
		GrantOptionId NVARCHAR(100),GrantLegId NUMERIC(18,0), SchemeId NVARCHAR(150), GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150), EmployeeName NVARCHAR(250), SBU NVARCHAR(100) NULL, AccountNo NVARCHAR(100) NULL, PANNumber NVARCHAR(50) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100), GrantDate DATETIME, VestingType NVARCHAR(100), ExercisePrice numeric(10,2), VestingDate DATETIME,
		ExpiryDate DATETIME, Parent_Note NVARCHAR(10), VestingFrequency VARCHAR(5), LapseDate DATETIME, CancelledDate DATETIME, CancelledReasion NVARCHAR(200),
		MarketPrice NUMERIC (18,2), UnvestedOptionsLiveFor NUMERIC(18,0), VestedOptionsLiveFor NUMERIC(18,0), IsVestingOfUnvestedOptions NVARCHAR(10), PeriodUnit NVARCHAR(10),
		AmountPayableOnExercise NUMERIC (18,2), LastDateToExercise DATETIME, UnvestedCancellationDate DATETIME,	ValueOfGrantedOptions NUMERIC(18,2), 
		ValueOfVestedOptions NUMERIC(18,2), ValueOfUnvestedOptions NUMERIC(18,2), UnvestedCancelled NUMERIC(18,2), VestedCancelled NUMERIC(18,2), IsGlGenerated BIT, 
		IsEGrantsEnabled BIT, INSTRUMENT_NAME NVARCHAR (100), CurrencyName NVARCHAR (100), COST_CENTER VARCHAR (50), Department VARCHAR (50),
		Location VARCHAR (100), EmployeeDesignation VARCHAR (100), Grade VARCHAR (50), ResidentialStatus VARCHAR (50), CountryName VARCHAR (100), 
		CurrencyAlias VARCHAR (20), MIT_ID INT,
		
		FMVPrice NVARCHAR(20), PerqstValue NVARCHAR(20), PerqstPayableOnGrantDate NVARCHAR(20), PerqstPayableOnVestingDate NVARCHAR(20), PerqstPayableOnExerciseDate NVARCHAR(20)
	)
	
	
	INSERT INTO #EMPLOYEE_TEMP_DATA 
	(
		OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, 
		GrantOptionId, GrantLegId, SchemeId, GrantRegistrationId, Employeeid, EmployeeName, SBU, AccountNo, PANNumber,
		Entity, [Status], GrantDate, VestingType, ExercisePrice, VestingDate, ExpiryDate, Parent_Note, UnvestedCancelled, VestedCancelled,
		INSTRUMENT_NAME , CurrencyName , COST_CENTER , Department, Location , EmployeeDesignation , Grade, ResidentialStatus , CountryName, CurrencyAlias, MIT_ID
	)
	EXECUTE SP_REPORT_DATA @FROM_DATE, @TO_DATE
	
	SELECT @RoundupPlace_TaxableVal = RoundupPlace_TaxableVal, @RoundingParam_TaxableVal = RoundingParam_TaxableVal, @RoundingParam_FMV = RoundingParam_FMV,@RoundupPlace_FMV = RoundupPlace_FMV FROM CompanyParameters
       
       
	UPDATE #EMPLOYEE_TEMP_DATA SET FMVPrice = NULL, PerqstValue = NULL
	
	DECLARE @CASE_1_TYPE_FMV_VALUE dbo.TYPE_FMV_VALUE
	INSERT INTO @CASE_1_TYPE_FMV_VALUE SELECT MIT_ID, EmployeeID, GrantOptionId, CONVERT(DATE, GrantDate), CONVERT(DATE, VestingDate), CONVERT(DATE, GETDATE()) FROM #EMPLOYEE_TEMP_DATA ETD WHERE ETD.EmployeeID = CASE WHEN @EMPLOYEE_ID = '---All Employees---' THEN ETD.EmployeeID ELSE @EMPLOYEE_ID END
	EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @CASE_1_TYPE_FMV_VALUE, @CalledFrom = 'SSRSReport'
	
	UPDATE ETD SET 
		 ETD.FMVPrice = dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV)							
	FROM #EMPLOYEE_TEMP_DATA AS ETD
		 INNER JOIN TEMP_FMV_DETAILS TFD ON TFD.INSTRUMENT_ID = ETD.MIT_ID AND TFD.EMPLOYEE_ID = ETD.EmployeeID AND TFD.GRANTOPTIONID = ETD.GrantOptionId AND CONVERT(DATE, TFD.GRANTDATE) = CONVERT(DATE, ETD.GrantDate) AND CONVERT(DATE, TFD.VESTINGDATE) = CONVERT(DATE, ETD.VestingDate) AND CONVERT(DATE, TFD.EXERCISE_DATE) = CONVERT(DATE, GETDATE())
	
	IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_FMV_DETAILS')
			DROP TABLE TEMP_FMV_DETAILS
			
		
    DECLARE @CASE_1_TYPE_PERQ_VALUE dbo.TYPE_PERQ_VALUE	
    INSERT INTO @CASE_1_TYPE_PERQ_VALUE SELECT MIT_ID, EmployeeID, ExercisePrice, ISNULL(OptionsVested, 0) + ISNULL(PendingForApproval, 0), FMVPrice, ISNULL(OptionsVested, 0) + ISNULL(PendingForApproval, 0), OptionsGranted, GETDATE(), GrantOptionId, GrantDate, VestingDate FROM #EMPLOYEE_TEMP_DATA ETD WHERE ETD.EmployeeID = CASE WHEN @EMPLOYEE_ID = '---All Employees---' THEN ETD.EmployeeID ELSE @EMPLOYEE_ID END	
	EXEC PROC_GET_PERQUISITE_VALUE @EMPLOYEE_DETAILS = @CASE_1_TYPE_PERQ_VALUE, @CalledFrom = 'SSRSReport'


    UPDATE ETD SET 
		 ETD.PerqstValue = dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal)							
	FROM #EMPLOYEE_TEMP_DATA AS ETD
	     INNER JOIN TEMP_PERQUISITE_DETAILS TPD ON TPD.EMPLOYEE_ID = ETD.EmployeeID AND TPD.INSTRUMENT_ID = ETD.MIT_ID AND TPD.EXERCISE_PRICE = ETD.ExercisePrice AND TPD.OPTION_VESTED = ISNULL(ETD.OptionsVested, 0) + ISNULL(ETD.PendingForApproval, 0) AND TPD.FMV_VALUE = ETD.FMVPrice AND TPD.OPTION_EXERCISED = ISNULL(ETD.OptionsVested, 0) + ISNULL(ETD.PendingForApproval, 0) AND TPD.GRANTED_OPTIONS = ETD.OptionsGranted 
	     AND CONVERT(DATE, TPD.EXERCISE_DATE) = CONVERT(DATE,GETDATE())                   --CONVERT(DATE, ETOE.ExercisedDate)
	     AND ETD.GrantOptionId = TPD.GRANTOPTIONID AND CONVERT(date, ETD.GrantDate) = CONVERT(date, TPD.GRANTDATE) AND CONVERT(date, ETD.VestingDate) = CONVERT(date, TPD.VESTINGDATE)
	
	IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')
		DROP TABLE TEMP_PERQUISITE_DETAILS
		
   
     UPDATE ETD SET
		   ETD.PerqstPayableOnGrantDate = 
				   CASE WHEN (SELECT TOP 1 EVENT_OF_INCIDENCE_ID FROM PERQUISITE_FORMULA_CONFIG AS FFC               
				              WHERE((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,CONVERT(date, GETDATE()))) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,CONVERT(date, GETDATE()))))) = 1003 
				        THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18, 6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (ETD.MIT_ID, ETD.EmployeeID, ETD.FMVPrice, dbo.FN_ROUND_VALUE(ETD.PerqstValue, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), 1003, CONVERT(date, ETD.GrantDate), CONVERT(date, ETD.VestingDate), CONVERT(date, GETDATE())))
				        ELSE '0' 
				   END,
		   ETD.PerqstPayableOnVestingDate = 
				   CASE WHEN (SELECT TOP 1 EVENT_OF_INCIDENCE_ID FROM PERQUISITE_FORMULA_CONFIG AS FFC              
					          WHERE((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,CONVERT(date, GETDATE()))) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,CONVERT(date, GETDATE()))))) = 1001 
					    THEN 
							 (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18, 6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (ETD.MIT_ID, ETD.EmployeeID, ETD.FMVPrice, dbo.FN_ROUND_VALUE(ETD.PerqstValue, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), 1001, CONVERT(date, ETD.GrantDate), CONVERT(date, ETD.VestingDate), CONVERT(date, GETDATE())))
					    ELSE '0' 
				   END,
		   -- On exercise Date Remaining
 		   ETD.PerqstPayableOnExerciseDate = 
				   CASE WHEN (SELECT TOP 1 EVENT_OF_INCIDENCE_ID FROM PERQUISITE_FORMULA_CONFIG AS FFC               
				              WHERE((CONVERT(DATE, FFC.APPLICABLE_FROM_DATE) <= CONVERT(DATE,CONVERT(date, GETDATE()))) AND (CONVERT(DATE, ISNULL(FFC.APPLICABLE_TO_DATE, GETDATE())) >=  CONVERT(DATE,CONVERT(date, GETDATE()))))) = 1002 
				        THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18, 6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (ETD.MIT_ID, ETD.EmployeeID, ETD.FMVPrice, dbo.FN_ROUND_VALUE(ETD.PerqstValue, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), 1002, CONVERT(date, ETD.GrantDate), CONVERT(date, ETD.VestingDate), CONVERT(date, GETDATE())))
				        ELSE '0' 
				   END		   
     FROM #EMPLOYEE_TEMP_DATA ETD	
   		
   		
      SELECT ETD.INSTRUMENT_NAME, ETD.SchemeId AS SchemeTitle, ETD.GrantRegistrationId, ETD.EmployeeID, ETD.EmployeeName, ETD.[Status], ETD.GrantOptionId, ETD.GrantDate, ETD.CountryName, ETD.ExercisePrice, SUM(ISNULL(ETD.OptionsGranted,0)) AS OptionsGranted, 
			(SUM(ISNULL(ETD.OptionsVested,0)) + SUM(ISNULL(ETD.PendingForApproval,0))) AS  OptionsVested, SUM(ISNULL(ETD.OptionsExercised,0)) AS ExercisedQuantity, ETD.CurrencyAlias, SUM(CONVERT(NUMERIC(18, 6), ISNULL(PerqstPayableOnGrantDate,0))) AS PerqstPayableOnGrantDate, 
			SUM(CONVERT(NUMERIC(18, 6), ISNULL(PerqstPayableOnVestingDate,0))) AS PerqstPayableOnVestingDate, SUM(CONVERT(NUMERIC(18, 6), ISNULL(PerqstPayableOnExerciseDate,0))) AS PerqstPayableOnExerciseDate
     FROM #EMPLOYEE_TEMP_DATA ETD           
     WHERE ETD.EmployeeID = CASE WHEN @EMPLOYEE_ID = '---All Employees---' THEN ETD.EmployeeID ELSE @EMPLOYEE_ID END
     GROUP BY ETD.GrantOptionId, ETD.INSTRUMENT_NAME, ETD.SchemeId, ETD.GrantRegistrationId, ETD.EmployeeID, ETD.EmployeeName, ETD.[Status], ETD.GrantOptionId, ETD.GrantDate, ETD.CountryName, ETD.ExercisePrice,ETD.CurrencyAlias  
     
	SET NOCOUNT OFF;
END
GO
