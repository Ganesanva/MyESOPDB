/****** Object:  StoredProcedure [dbo].[PROC_GetPerformanceDetail]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPerformanceDetail]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPerformanceDetail]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetPerformanceDetail] --83
@NoOfDays VARCHAR(10)
AS
BEGIN
DECLARE @TO_DATE DATETIME = (SELECT  REPLACE(CONVERT(VARCHAR(10), GETDATE(),102),'.','-'))
DECLARE @Vesting_Date DATETIME=(SELECT CONVERT(DATE, DATEADD(DAY,(CONVERT(INT,@NoOfDays)),Convert(DATE ,GETDATE()))))
PRINT(@Vesting_Date)

CREATE TABLE #SP_REPORT_DATA
(
	OptionsGranted		NUMERIC,		OptionsVested		NUMERIC,		OptionsExercised	NUMERIC,		OptionsCancelled	NUMERIC,
	OptionsLapsed		NUMERIC,		OptionsUnVested		NUMERIC,		PendingForApproval	NUMERIC,		GrantOptionId		VARCHAR(100),
	GrantLegId			DECIMAL(10,0),	SchemeId			VARCHAR(50),	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename		VARCHAR(75),	SBU					VARCHAR(200),	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity				VARCHAR(200),	[Status]			VARCHAR(9),		GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice		NUMERIC,		VestingDate			DATETIME,		ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled	NUMERIC,		VestedCancelled		NUMERIC,		INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER			VARCHAR(200),	Department			VARCHAR(200),	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade				VARCHAR(200),	ResidentialStatus	CHAR(1),		CountryName			VARCHAR(50),	CurrencyAlias 		VARCHAR(50),
	MIT_ID 				INT,			CancellationReason  VARCHAR(100)
)

INSERT INTO #SP_REPORT_DATA
EXEC SP_REPORT_DATA '1900-01-01',@TO_DATE

CREATE TABLE #SP_REPORT_DATA1
(	
	ID INT IDENTITY(1,1) NOT NULL,		OptionsGranted		NUMERIC,		OptionsVested		NUMERIC,		OptionsExercised	NUMERIC,			OptionsCancelled	NUMERIC,
	OptionsLapsed		NUMERIC,		OptionsUnVested		NUMERIC,		PendingForApproval	NUMERIC,		GrantOptionId		VARCHAR(100),
	GrantLegId			DECIMAL(10,0),	SchemeId			VARCHAR(50),	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename		VARCHAR(75),	SBU					VARCHAR(200),	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity				VARCHAR(200),	[Status]			VARCHAR(9),		GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice		NUMERIC,		VestingDate			DATETIME,		ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled	NUMERIC,		VestedCancelled		NUMERIC,		INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER			VARCHAR(200),	Department			VARCHAR(200),	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade				VARCHAR(200),	ResidentialStatus	CHAR(1),		CountryName			VARCHAR(50),	CurrencyAlias VARCHAR(50),
	MIT_ID 				INT,			CancellationReason  VARCHAR(100),	GrantLegSerialNo	NUMERIC
)

INSERT INTO #SP_REPORT_DATA1 (

OptionsGranted,OptionsVested,OptionsExercised,OptionsCancelled,OptionsLapsed,OptionsUnVested,PendingForApproval,GrantOptionId,
GrantLegId,SchemeId,GrantRegistrationId,Employeeid,employeename,SBU,AccountNo,PANNumber,Entity,[Status],GrantDate,VestingType,
ExercisePrice,VestingDate,ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,INSTRUMENT_NAME,CurrencyName,COST_CENTER,
Department,Location,EmployeeDesignation,Grade,	ResidentialStatus,CountryName,CurrencyAlias,MIT_ID,CancellationReason)

SELECT 
OptionsGranted,OptionsVested,OptionsExercised,OptionsCancelled,OptionsLapsed,OptionsUnVested,PendingForApproval,GrantOptionId,
GrantLegId,SchemeId,GrantRegistrationId,Employeeid,employeename,SBU,AccountNo,PANNumber,Entity,[Status],GrantDate,VestingType,
ExercisePrice,VestingDate,ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,INSTRUMENT_NAME,CurrencyName,COST_CENTER,
Department,Location,EmployeeDesignation,Grade,ResidentialStatus,CountryName,CurrencyAlias,MIT_ID,CancellationReason	
FROM
#SP_REPORT_DATA SRD
WHERE 
	 SRD.VestingDate=@Vesting_Date
  	 
	
UPDATE #SP_REPORT_DATA1 SET GrantLegSerialNo=GL.ID
FROM #SP_REPORT_DATA1 SRD INNER JOIN GrantLeg GL
on SRD.GrantLegId=GL.GrantLegId AND SRD.GrantOptionId=GL.GrantOptionId
AND GL.VestingType = (CASE WHEN SRD.VestingType='PerFormance Based' THEN 'P' ELSE 'T' END)


SELECT 

	SRD.Employeeid AS [EmployeeId],
	convert(VARCHAR(20),SRD.GrantDate,106) AS [Grant Date], 
	SRD.SchemeId AS [Scheme Name],
	SRD.ExercisePrice AS [Exercise Price],   
	convert(VARCHAR(20),SRD.VestingDate,106) AS [Date Of Vesting],
	SRD.OptionsUnVested AS [Options Scheduled To Vest],
	(SRD.OptionsUnVested*100)/Gr.GrantedOptions AS[Percentage Of Options To Vest],
	NULL AS [Actual Number Of Options To Vest],
	NULL AS [Treatment Of Balance Options],
	NULL AS [EDUploadStatus],
	NULL AS	[EDRemarks]
FROM
	#SP_REPORT_DATA1 SRD 	
	INNER JOIN 
	GrantLeg GL ON SRD.GrantLegSerialNo=GL.ID 	
	INNER JOIN GrantOptions Gr ON Gr.GrantOptionId=GL.GrantOptionId
	AND	Gr.GrantOptionId = GL.GrantOptionId
	AND SRD.GrantOptionId=Gr.GrantOptionId    	
WHERE 
	GL.VestingType = 'P' 
END

GO
