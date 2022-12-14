/****** Object:  StoredProcedure [dbo].[PROC_EmpTxTemp]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EmpTxTemp]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EmpTxTemp]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EmpTxTemp] --0
@NoOfDays VARCHAR(10)

AS

DECLARE @TO_DATE DATETIME = (SELECT  REPLACE(CONVERT(VARCHAR(10), GETDATE(),102),'.','-'))
DECLARE @Vesting_Date DATETIME=(SELECT CONVERT(DATE, DATEADD(DAY,(CONVERT(INT,@NoOfDays)),Convert(DATE ,GETDATE()))))

CREATE TABLE #SP_REPORT_DATA
(
	OptionsGranted		BIGINT,			OptionsVested		BIGINT,
	OptionsExercised	BIGINT,			OptionsCancelled	BIGINT,
	OptionsLapsed		BIGINT,			OptionsUnVested		BIGINT,
	PendingForApproval	BIGINT,			GrantOptionId		VARCHAR(100),
	GrantLegId			DECIMAL(10,0),	SchemeId			VARCHAR(50),
	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename		VARCHAR(75),	SBU					VARCHAR(200),
	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity				VARCHAR(200),	[Status]			VARCHAR(9),
	GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice		BIGINT,			VestingDate			DATETIME,
	ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled	BIGINT,			VestedCancelled		BIGINT,
	INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER			VARCHAR(200),	Department			VARCHAR(200),
	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade				VARCHAR(200),	ResidentialStatus	CHAR(1),
	CountryName			VARCHAR(50),	CurrencyAlias VARCHAR(50),
	MIT_ID 				INT,			CancellationReason VARCHAR(100),
	
	FMVPrice NUMERIC(18,6), 
	PerqstValue NUMERIC(18,6),
	PerqstPayable NUMERIC(18,6),
	Perq_Tax_rate numeric(18, 6),
	TentativeFMVPrice NUMERIC(18,6),
	TentativePerqstValue NUMERIC(18,6),
	TentativePerqstPayable NUMERIC(18,6),
	TaxFlag CHAR(1)	
)

INSERT INTO #SP_REPORT_DATA (OptionsGranted,OptionsVested,
OptionsExercised,OptionsCancelled,
OptionsLapsed,OptionsUnVested,
PendingForApproval,
GrantOptionId,
GrantLegId,SchemeId,
GrantRegistrationId,Employeeid,
employeename,SBU,
AccountNo,PANNumber,
Entity,	
[Status],
GrantDate,VestingType,
ExercisePrice,VestingDate,
ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,

INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location,EmployeeDesignation,
Grade,	ResidentialStatus,
CountryName,
CurrencyAlias,MIT_ID,CancellationReason)
EXEC SP_REPORT_DATA '1900-01-01',@TO_DATE

CREATE TABLE #SP_REPORT_DATA1
(	
	ID INT IDENTITY(1,1) NOT NULL,
	OptionsGranted		BIGINT,			OptionsVested		BIGINT,
	OptionsExercised	BIGINT,			OptionsCancelled	BIGINT,
	OptionsLapsed		BIGINT,			OptionsUnVested		BIGINT,
	PendingForApproval	BIGINT,			GrantOptionId		VARCHAR(100),
	GrantLegId			DECIMAL(10,0),	SchemeId			VARCHAR(50),
	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename		VARCHAR(75),	SBU					VARCHAR(200),
	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity				VARCHAR(200),	[Status]			VARCHAR(9),
	GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice		BIGINT,			VestingDate			DATETIME,
	ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled	BIGINT,			VestedCancelled		BIGINT,
	INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER			VARCHAR(200),	Department			VARCHAR(200),
	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade				VARCHAR(200),	ResidentialStatus	CHAR(1),
	CountryName			VARCHAR(50),	CurrencyAlias VARCHAR(50),
	MIT_ID 				INT,			CancellationReason VARCHAR(100),
	
	FMVPrice NUMERIC(18,6), 
	PerqstValue NUMERIC(18,6),
	PerqstPayable NUMERIC(18,6),
	Perq_Tax_rate numeric(18, 6),
	TentativeFMVPrice NUMERIC(18,6),
	TentativePerqstValue NUMERIC(18,6),
	TentativePerqstPayable NUMERIC(18,6),
	TaxFlag CHAR(1)	,
	IncidentDate DATETIME,
	GrantLegSerialNo		BIGINT,
	TEMP_VESTING_DATE DateTime ,TEMP_EXERCISE_DATE Datetime
)

INSERT INTO #SP_REPORT_DATA1 (

OptionsGranted,OptionsVested,
OptionsExercised,OptionsCancelled,
OptionsLapsed,OptionsUnVested,
PendingForApproval,
GrantOptionId,
GrantLegId,SchemeId,
GrantRegistrationId,Employeeid,
employeename,SBU,
AccountNo,PANNumber,
Entity,	
[Status],
GrantDate,VestingType,
ExercisePrice,VestingDate,
ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,

INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location,EmployeeDesignation,
Grade,	ResidentialStatus,
CountryName,
CurrencyAlias,MIT_ID)

SELECT 
OptionsGranted,OptionsVested,
OptionsExercised,OptionsCancelled,
OptionsLapsed,OptionsUnVested,
PendingForApproval,
GrantOptionId,
GrantLegId,SchemeId,
GrantRegistrationId,Employeeid,
employeename,SBU,
AccountNo,PANNumber,
Entity,	
[Status],
GrantDate,VestingType,
ExercisePrice,VestingDate,
ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,

INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location,EmployeeDesignation,
Grade,	ResidentialStatus,
CountryName,
CurrencyAlias,MIT_ID
	
FROM 

#SP_REPORT_DATA SRD
WHERE 
	 SRD.VestingDate=@Vesting_Date 
	 
----------------------Update GrantLegSerialNo--------------------------------------------	 
	
UPDATE #SP_REPORT_DATA1 SET GrantLegSerialNo=GL.ID
FROM #SP_REPORT_DATA1 SRD INNER JOIN GrantLeg GL
on SRD.GrantLegId=GL.GrantLegId AND SRD.GrantOptionId=GL.GrantOptionId

------------------------------------------------------------------------------------------

------------------------------Update SP report-----------------
UPDATE #SP_REPORT_DATA1
SET TEMP_VESTING_DATE=dateadd(day,AE.EXERCISE_AFTER_DAYS-SCH.CALCUALTE_TAX_PRIOR_DAYS,SRD.VestingDate),
TEMP_EXERCISE_DATE=dateadd(day,AE.EXERCISE_AFTER_DAYS-SCH.CALCUALTE_TAX_PRIOR_DAYS,SRD.VestingDate)
FROM	
		#SP_REPORT_DATA1 SRD Inner join GrantLeg GL On Gl.SchemeId=SRD.SchemeId AND SRD.GrantLegSerialNo=GL.ID
		Inner join AUTO_EXERCISE_CONFIG AE On AE.SchemeId=SRD.SchemeId
		Inner join Scheme SCH on SRD.SchemeId=sch.SchemeId


---------------------------------------------------------------
	
----------------------------- Calculate FMV ---------------------------------------------

Declare @RoundupPlace_TaxableVal 	VARCHAR(5),
		@RoundingParam_TaxableVal 	VARCHAR(5),
		@RoundingParam_FMV 			VARCHAR(5),
		@RoundupPlace_FMV 			VARCHAR(5)
		
SELECT @RoundupPlace_TaxableVal = RoundupPlace_TaxableVal, @RoundingParam_TaxableVal = RoundingParam_TaxableVal, @RoundingParam_FMV = RoundingParam_FMV,@RoundupPlace_FMV = RoundupPlace_FMV FROM CompanyParameters
		
		
DECLARE @FMV_VALUE_TYPE dbo.TYPE_FMV_VALUE
INSERT INTO 	@FMV_VALUE_TYPE 
Select 
		SRD.MIT_ID,SRD.Employeeid,SRD.GrantOptionId,SRD.GrantDate,TEMP_VESTING_DATE, TEMP_EXERCISE_DATE
FROM	
		#SP_REPORT_DATA1 SRD 

EXEC PROC_GET_FMV_VALUE @EMPLOYEE_DETAILS = @FMV_VALUE_TYPE		    
	     
UPDATE 	
    TAED     
SET  TAED.FMVPrice = CASE TFD.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,
	 TAED.TentativeFMVPrice = CASE TFD.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TFD.FMV_VALUE, @RoundingParam_FMV, @RoundupPlace_FMV) ELSE NULL END,							
	 TAED.TaxFlag = TFD.TAXFLAG
	 --,TAED.VestingDate=TFD.VestingDate
		 
FROM 
	#SP_REPORT_DATA1 AS TAED	
INNER JOIN 
	TEMP_FMV_DETAILS TFD	 
ON  TFD.INSTRUMENT_ID = TAED.MIT_ID AND TFD.EMPLOYEE_ID = TAED.EmployeeId AND TFD.GRANTOPTIONID = TAED.GrantOptionId 
	AND  CONVERT(date, TFD.GRANTDATE) =  CONVERT(date, TAED.GrantDate)	
	AND  CONVERT(date, TFD.VESTINGDATE) =  CONVERT(date, TAED.TEMP_VESTING_DATE)
		 
IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_FMV_DETAILS')
DROP TABLE TEMP_FMV_DETAILS

 -------------------------- Calculate Perquisite Value ---------------------------------------------
		   
DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE
INSERT INTO @PERQ_VALUE_TYPE 
Select 
		SRD.MIT_ID,SRD.Employeeid,SRD.ExercisePrice,SRD.OptionsVested,CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END,SRD.OptionsGranted,SRD.OptionsGranted,SRD.TEMP_VESTING_DATE, SRD.GrantOptionId, SRD.GrantDate,SRD.TEMP_VESTING_DATE ,SRD.GrantLegSerialNo,NULL,NULL,SRD.ID 
FROM 	#SP_REPORT_DATA1 SRD 

		
EXEC PROC_GET_PERQUISITE_VALUE @EMPLOYEE_DETAILS = @PERQ_VALUE_TYPE	
				
UPDATE 
	 TAED 
SET  TAED.PerqstValue = CASE TAED.TAXFLAG WHEN 'A' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
	 TAED.PerqstPayable = CASE TAED.TAXFLAG WHEN 'A' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18, 6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.VestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END,
	 TAED.TentativePerqstValue = CASE TAED.TAXFLAG WHEN 'T' THEN dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) ELSE NULL END,
	 TAED.TentativePerqstPayable = CASE TAED.TAXFLAG WHEN 'T' THEN (SELECT dbo.FN_ROUND_VALUE(SUM(CONVERT(NUMERIC(18, 6), TAX_AMOUNT)), @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal) AS TAX_AMOUNT FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeId, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.VestingDate), CONVERT(date, TPD.EXERCISE_DATE))) ELSE NULL END,
	 TAED.Perq_Tax_rate = (SELECT dbo.FN_PQ_TAX_ROUNDING(SUM(TAX_RATE)) AS TAX_RATE FROM FN_GET_TENTATIVE_TAX (TAED.MIT_ID, TAED.EmployeeID, TAED.FMVPrice, dbo.FN_ROUND_VALUE(TPD.PERQ_VALUE, @RoundingParam_TaxableVal, @RoundupPlace_TaxableVal), TPD.EVENTOFINCIDENCE, CONVERT(date, TAED.GrantDate), CONVERT(date, TAED.VestingDate), CONVERT(date, TPD.EXERCISE_DATE)))
FROM 
	#SP_REPORT_DATA1 AS TAED
INNER JOIN 
	TEMP_PERQUISITE_DETAILS TPD 
ON  TPD.EMPLOYEE_ID = TAED.EmployeeId AND TPD.INSTRUMENT_ID = TAED.MIT_ID 
AND TPD.EXERCISE_PRICE = TAED.ExercisePrice 
AND TPD.OPTION_VESTED = TAED.OptionsVested 
AND TPD.FMV_VALUE = CASE TAED.TAXFLAG WHEN 'A' THEN TAED.FMVPrice ELSE TAED.TentativeFMVPrice END 
--AND TPD.OPTION_EXERCISED = TAED.OptionsVested 
AND TPD.GRANTED_OPTIONS = TAED.OptionsGranted  
AND TPD.GRANTOPTIONID = TAED.GrantOptionId 
AND CONVERT(date, TPD.GRANTDATE) = CONVERT(date, TAED.GrantDate) 
AND CONVERT(date, TPD.EXERCISE_DATE) = CONVERT(date, TAED.TEMP_VESTING_DATE)
AND  CONVERT(date, TPD.VESTINGDATE) =  CONVERT(date, TAED.TEMP_VESTING_DATE)
 		
IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')
DROP TABLE TEMP_PERQUISITE_DETAILS  
	
----------------------------------------------------------------------------------------------------------------------
 
	CREATE TABLE #MobilityDetails
	(	
	ID1 INT IDENTITY(1,1) NOT NULL,
	ID INT,
   	   	Country NVARCHAR(250),
		FromDate datetime,
		Todate DATETIME,
		employeeId VARCHAR(50) NULL,
		GrantDate DATETIME,
		VestingDate	DATETIME,
		GrantLegSerialNo BIGINT
	)
	
	Declare @MN_VALUE INT,@MX_VALUE INT
	Declare @FromDate datetime
	Declare @ToDate DATETIME
	Declare @GrantDate DATETIME
	Declare @VestingDate datetime
	Declare @EmployeeID nvarchar(50)
	DECLARE @GrantLegSerialNo BIGINT	
	Declare @IncId INT	
   
	
	SELECT @MN_VALUE = MIN(ID),@MX_VALUE = MAX(ID) FROM #SP_REPORT_DATA1	
		WHILE(@MN_VALUE <= @MX_VALUE)
		BEGIN
		
   SELECT @FromDate = @Vesting_Date,@ToDate = @Vesting_Date,@EmployeeID = Employeeid,@GrantDate=GrantDate,@VestingDate=VestingDate,@GrantLegSerialNo=GrantLegSerialNo
			FROM 
				#SP_REPORT_DATA1 
			WHERE
				ID = @MN_VALUE
   
  INSERT INTO #MobilityDetails(ID,employeeId,Country,FromDate,Todate,GrantDate,VestingDate,GrantLegSerialNo)
	EXEC PROC_GET_EMP_MOBILITY_DETAILS @EmployeeID, @FromDate,@ToDate,@GrantDate,@VestingDate,@GrantLegSerialNo
		
		SET @MN_VALUE = @MN_VALUE + 1 
	   	END
 
	
SELECT DISTINCT MD.employeeId AS [EmpNo],SRD1.TentativePerqstValue AS [Perquisitevalue],
convert(VARCHAR(20),SRD1.VestingDate,106) AS [DateofPerquisite value],
MD.Country AS [Country],
NULL AS [EmployeeTaxrate],
NULL AS [EmployeeSSrate],
NULL AS [CompanyTaxrate],
NULL AS [CompanySSrate],
NULL AS [MaximumCompanySScapping],
NULL AS	[Remarks],
NULL AS [EDUploadStatus],
NULL AS [EDRemarks],
SRD1.GrantLegSerialNo
FROM #MobilityDetails MD JOIN #SP_REPORT_DATA1 SRD1
ON MD.employeeId=SRD1.Employeeid AND
MD.GrantDate=SRD1.GrantDate
AND MD.VestingDate=SRD1.VestingDate
AND MD.GrantLegSerialNo=SRD1.GrantLegSerialNo

GO
