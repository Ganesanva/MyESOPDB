/****** Object:  StoredProcedure [dbo].[PROC_GetEmpVestingReport]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetEmpVestingReport]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetEmpVestingReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetEmpVestingReport] 
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
	MIT_ID 				INT,			CancellationReason VARCHAR(100)
)

INSERT INTO #SP_REPORT_DATA
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
	GrantLegSerialNo	BIGINT
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
CurrencyAlias,MIT_ID,CancellationReason)

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
CurrencyAlias,MIT_ID,CancellationReason
	
FROM 

#SP_REPORT_DATA SRD
WHERE 
	 SRD.VestingDate=@Vesting_Date 	 
	
UPDATE #SP_REPORT_DATA1 SET GrantLegSerialNo=GL.ID
FROM #SP_REPORT_DATA1 SRD INNER JOIN GrantLeg GL
on SRD.GrantLegId=GL.GrantLegId AND SRD.GrantOptionId=GL.GrantOptionId

SELECT 

	SRD.Employeeid AS [EmployeeId], emp.LoginID AS [Old Employee ID],
	NULL AS [Date of change of Employee ID],SRD.employeename AS [Employee name],
	SRD.SchemeId AS [SchemeName],
	SRD.ExercisePrice AS [ExercisePrice],SRD.CurrencyName AS Currency,
	convert(VARCHAR(20),SRD.GrantDate,106) AS [GrantDate],convert(VARCHAR(20),SRD.VestingDate,106) AS [DateOfVesting],	
	DATEDIFF(day,SRD.GrantDate ,SRD.VestingDate) AS [Total Grant Period Days],
	convert(VARCHAR(20),SRD.VestingDate,106) AS [Date of Exercise],SRD.OptionsGranted AS [Number of Units granted],
	SRD.OptionsUnVested AS [OptionsScheduledToVest],
	(SRD.OptionsUnVested*100)/Gr.GrantedOptions AS[PercentageOfOptionsToVest],	
	--CASE when VP.VestingType='T' THEN OptionTimePercentage ELSE OptionPerformancePercentage END AS  [PercentageOfOptionsToVest],
	NULL AS [ActualNumberOfOptionsToVest], NULL AS [TreatmentOfBalanceOptions],SRD.OptionsCancelled AS [Options Cancelled],
	SRD.CancellationReason AS [Reason for Cancellation],SRD.Entity AS [Company],SRD.Status AS [Quit/ Active?], NULL AS [LongLeave], NULL AS [LongLeaveFrom] ,NULL AS [LongLeaveTo], NULL AS [VestingDateExtension]
FROM
	#SP_REPORT_DATA1 SRD 	
	INNER JOIN 
	GrantLeg GL ON SRD.GrantLegSerialNo=GL.ID join	
	GrantOptions Gr ON Gr.GrantOptionId=GL.GrantOptionId
	AND SRD.GrantOptionId=Gr.GrantOptionId join
	EmployeeMaster emp 
	ON SRD.Employeeid=emp.EmployeeID	
WHERE 
	SRD.VestingDate=@Vesting_Date
GO
