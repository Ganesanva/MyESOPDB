/****** Object:  StoredProcedure [dbo].[PROC_GetTenFMVtxInptRpt]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetTenFMVtxInptRpt]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetTenFMVtxInptRpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetTenFMVtxInptRpt] --1
@NoOfDays VARCHAR(10)
AS

DECLARE @TO_DATE DATETIME = (SELECT  REPLACE(CONVERT(VARCHAR(10), GETDATE(),102),'.','-'))
DECLARE @Vesting_Date DATETIME=(SELECT CONVERT(DATE, DATEADD(DAY,(CONVERT(INT,@NoOfDays)),Convert(DATE ,GETDATE()))))
PRINT(@Vesting_Date)

CREATE TABLE #SP_REPORT_DATA
(
	OptionsGranted			BIGINT,			OptionsVested		BIGINT,			OptionsExercised	BIGINT,			OptionsCancelled	BIGINT,
	OptionsLapsed			BIGINT,			OptionsUnVested		BIGINT,	   		PendingForApproval	BIGINT,			GrantOptionId		VARCHAR(100),
	GrantLegId				DECIMAL(10,0),	SchemeId			VARCHAR(50),	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename			VARCHAR(75),	SBU					VARCHAR(200),	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity					VARCHAR(200),	[Status]			VARCHAR(9), 	GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice			NUMERIC(18, 6),			VestingDate			DATETIME,  		ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled		BIGINT,			VestedCancelled		BIGINT,			INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER				VARCHAR(200),	Department			VARCHAR(200),	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade					VARCHAR(200),	ResidentialStatus	CHAR(1),		CountryName			VARCHAR(50),	CurrencyAlias 		VARCHAR(50),
	MIT_ID 					INT,			CancellationReason 	VARCHAR(100),	FMVPrice 			NUMERIC(18,6), 	PerqstValue 		NUMERIC(18,6),
	PerqstPayable 			NUMERIC(18,6),	Perq_Tax_rate 		numeric(18, 6),	TentativeFMVPrice 	NUMERIC(18,6),	TentativePerqstValue NUMERIC(18,6),
	TentativePerqstPayable 	NUMERIC(18,6),	TaxFlag 			CHAR(1)	
)

INSERT INTO #SP_REPORT_DATA 
(
	OptionsGranted,OptionsVested,OptionsExercised,OptionsCancelled,
	OptionsLapsed,OptionsUnVested,PendingForApproval,GrantOptionId,
	GrantLegId,SchemeId,GrantRegistrationId,Employeeid,
	employeename,SBU,AccountNo,PANNumber,
	Entity,[Status],GrantDate,VestingType,
	ExercisePrice,VestingDate,ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,
	INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location,EmployeeDesignation,
	Grade,ResidentialStatus,CountryName,CurrencyAlias,MIT_ID,CancellationReason
)
	
EXEC SP_REPORT_DATA '1900-01-01',@TO_DATE,null,'C'

CREATE TABLE #SP_REPORT_DATA1
(	
	ID INT IDENTITY(1,1) NOT NULL,
	OptionsGranted			BIGINT,			OptionsVested		BIGINT,			OptionsExercised	BIGINT,			OptionsCancelled	BIGINT,
	OptionsLapsed			BIGINT,			OptionsUnVested		BIGINT,	   		PendingForApproval	BIGINT,			GrantOptionId		VARCHAR(100),
	GrantLegId				DECIMAL(10,0),	SchemeId			VARCHAR(50),	GrantRegistrationId VARCHAR(20),	Employeeid			VARCHAR(20),
	employeename			VARCHAR(75),	SBU					VARCHAR(200),	AccountNo			VARCHAR(20),	PANNumber			VARCHAR(10),
	Entity					VARCHAR(200),	[Status]			VARCHAR(9), 	GrantDate			DATETIME,		VestingType			VARCHAR(17),
	ExercisePrice			NUMERIC(18, 6),			VestingDate			DATETIME,  		ExpirayDate			DATETIME,		Parent_Note			VARCHAR(3),
	UnvestedCancelled		BIGINT,			VestedCancelled		BIGINT,			INSTRUMENT_NAME		NVARCHAR(500),	CurrencyName		VARCHAR(50),
	COST_CENTER				VARCHAR(200),	Department			VARCHAR(200),	Location			VARCHAR(200),	EmployeeDesignation VARCHAR(200),
	Grade					VARCHAR(200),	ResidentialStatus	CHAR(1),		CountryName			VARCHAR(50),	CurrencyAlias 		VARCHAR(50),
	MIT_ID 					INT,			CancellationReason 	VARCHAR(100),	FMVPrice 			NUMERIC(18,6), 	PerqstValue 		NUMERIC(18,6),
	PerqstPayable 			NUMERIC(18,6),	Perq_Tax_rate 		numeric(18, 6),	TentativeFMVPrice 	NUMERIC(18,6),	TentativePerqstValue NUMERIC(18,6),
	TentativePerqstPayable 	NUMERIC(18,6),	TaxFlag 			CHAR(1),		IncidentDate        DATETIME ,		GrantLegSerialNo		BIGINT,
	TEMP_VESTING_DATE DateTime ,TEMP_EXERCISE_DATE Datetime		,TotalGranted	BIGINT
)

INSERT INTO #SP_REPORT_DATA1 
(
	OptionsGranted,OptionsVested,OptionsExercised,OptionsCancelled,
	OptionsLapsed,OptionsUnVested,PendingForApproval,GrantOptionId,
	GrantLegId,SchemeId,GrantRegistrationId,Employeeid,
	employeename,SBU,AccountNo,PANNumber,
	Entity,[Status],GrantDate,VestingType,
	ExercisePrice,VestingDate,ExpirayDate,Parent_Note,
	UnvestedCancelled,VestedCancelled,INSTRUMENT_NAME,CurrencyName,
	COST_CENTER,Department,Location,EmployeeDesignation,Grade,ResidentialStatus,
	CountryName,CurrencyAlias,MIT_ID,TEMP_VESTING_DATE,TEMP_EXERCISE_DATE
)

SELECT 

	OptionsGranted,OptionsGranted,OptionsExercised,OptionsCancelled,
	OptionsLapsed,OptionsUnVested,PendingForApproval,GrantOptionId,
	GrantLegId,SchemeId,GrantRegistrationId,Employeeid,
	employeename,SBU,AccountNo,PANNumber,Entity,	
	[Status],GrantDate,VestingType,ExercisePrice,VestingDate,
	ExpirayDate,Parent_Note,UnvestedCancelled,VestedCancelled,
	INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,
	Location,EmployeeDesignation,Grade,ResidentialStatus,
	CountryName,CurrencyAlias,MIT_ID,VestingDate,VestingDate
	
FROM 

#SP_REPORT_DATA SRD

WHERE SRD.VestingDate=@Vesting_Date	

UPDATE #SP_REPORT_DATA1 SET GrantLegSerialNo=GL.ID
FROM #SP_REPORT_DATA1 SRD INNER JOIN GrantLeg GL
on SRD.GrantLegId=GL.GrantLegId AND SRD.GrantOptionId=GL.GrantOptionId

CREATE TABLE #TEMP_GRANT_OPTION
(
	GRANT_OPTION_ID NVARCHAR(100),
	SUM_GRANTED_OPTION NUMERIC(18,0)
)

INSERT INTO #TEMP_GRANT_OPTION (GRANT_OPTION_ID, SUM_GRANTED_OPTION)
SELECT GrantOptionId, SUM(GrantedOptions) FROM GrantLeg GROUP BY GrantOptionId

UPDATE S1 
	SET S1.TotalGranted = TGO.SUM_GRANTED_OPTION	
FROM #SP_REPORT_DATA1 AS S1
INNER JOIN #TEMP_GRANT_OPTION AS TGO ON TGO.GRANT_OPTION_ID = S1.GrantOptionId


-------------------------- Calculate FMV ---------------------------------------------

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
	--AND TFD.GrantLegSerialNo =TAED.GrantLegSerialNo
	AND  CONVERT(date, TFD.VESTINGDATE) =  CONVERT(date, TAED.VESTINGDATE)
		 
IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_FMV_DETAILS')
DROP TABLE TEMP_FMV_DETAILS

 -------------------------- Calculate Perquisite Value ---------------------------------------------
		   
DECLARE @PERQ_VALUE_TYPE dbo.TYPE_PERQ_VALUE
--Select * from @PERQ_VALUE_TYPE
		--INSERT INTO @PERQ_VALUE_TYPE SELECT MIT_ID, EmployeeId, ExercisePrice, ExercisableQuantity, CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END, ExercisableQuantity, GrantedOptions , GETDATE(), GrantOptionId, GrantDate, FinalVestingDate FROM #TEMP_AUTOEXERCISED_DETAILS
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
ON  TPD.EMPLOYEE_ID = TAED.EmployeeId 
AND TPD.INSTRUMENT_ID = TAED.MIT_ID 
AND TPD.EXERCISE_PRICE = TAED.ExercisePrice 
AND TPD.OPTION_VESTED = TAED.OptionsVested 
AND TPD.FMV_VALUE = CASE TAED.TAXFLAG WHEN 'A' THEN TAED.FMVPrice ELSE TAED.TentativeFMVPrice END 
--AND TPD.OPTION_EXERCISED = TAED.OptionsVested 
--AND TPD.OPTION_EXERCISED = TAED.OptionsExercised  --------
AND TPD.GRANTED_OPTIONS = TAED.OptionsGranted 
AND CONVERT(date, TPD.EXERCISE_DATE) = TAED.VestingDate 
AND TPD.GRANTOPTIONID = TAED.GrantOptionId 
AND CONVERT(date, TPD.GRANTDATE) = CONVERT(date, TAED.GrantDate) 
--AND CONVERT(date, TPD.VESTINGDATE) = CONVERT(date, TAED.VestingDate)
AND TPD.TEMP_EXERCISEID=TAED.ID
AND  CONVERT(date, TPD.VESTINGDATE) =  CONVERT(date, TAED.VESTINGDATE)


DECLARE @PERQ_VALUE_RESULT dbo.TYPE_PERQ_FORAUTOEXERCISE

INSERT INTO @PERQ_VALUE_RESULT
		SELECT 
			INSTRUMENT_ID, EMPLOYEE_ID, FMV_VALUE, PERQ_VALUE, EVENTOFINCIDENCE, GRANTDATE, VESTINGDATE, 
			EXERCISE_DATE, GRANTOPTIONID, GRANTLEGSERIALNO, TEMP_EXERCISEID						
		FROM 
			TEMP_PERQUISITE_DETAILS


--SELECT * FROM @PERQ_VALUE_RESULT 
		
IF EXISTS (SELECT * FROM SYS.tables WHERE name = 'TEMP_PERQUISITE_DETAILS')
DROP TABLE TEMP_PERQUISITE_DETAILS  
	
	  ----------------------------------------------------------------------------------------------------------------------
 --SELECT * FROM #SP_REPORT_DATA1

  
---------------------------------------------------------Tax Calculation----------------------------------------------------

DECLARE @TYPE_PERQ_VALUE_AUTO_EXE dbo.TYPE_PERQ_VALUE_AUTO_EXE

INSERT INTO @TYPE_PERQ_VALUE_AUTO_EXE 
Select 
 		SRD.MIT_ID,SRD.Employeeid,SRD.ExercisePrice,SRD.OptionsVested,CASE TAXFLAG WHEN 'A' THEN FMVPrice ELSE TentativeFMVPrice END,
 		SRD.OptionsGranted,SRD.OptionsGranted,SRD.TEMP_EXERCISE_DATE ,SRD.GrantOptionId, SRD.GrantDate,SRD.TEMP_VESTING_DATE,SRD.GrantLegSerialNo,Null,Null, SRD.ID
FROM 	#SP_REPORT_DATA1 SRD

--SELECT * FROM @TYPE_PERQ_VALUE_AUTO_EXE

EXEC PROC_GET_TAXFORAUTOEXERCISE @PERQ_DETAILS = @TYPE_PERQ_VALUE_AUTO_EXE, @PERQ_RESULT = @PERQ_VALUE_RESULT,@ISTEMPLATE=1	

----------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

select @cols = STUFF((SELECT distinct ',' + QUOTENAME(p.TAX_HEADING) 
                    from
                     TEMP_GET_TAXDETAILS p                        
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')    
        
       
        
DECLARE @ColumnName AS NVARCHAR(max)
SELECT 
	@ColumnName=isnull(@ColumnName + ',','') + quotename(TAX_HEADING) 
FROM 
	(SELECT DISTINCT TAX_HEADING FROM TEMP_GET_TAXDETAILS) AS TaxHeadings        


set @query = 'SELECT EmployeeID,convert(DATETIME,GRANT_DATE,101) ,convert(DATETIME,VESTING_DATE,101),[Country],Convert(VARCHAR(20), FROM_DATE,106) AS FROM_DATE,Convert(VARCHAR(20),TO_DATE,106) AS TO_DATE,
(case when VESTING_DATE=TO_DATE then datediff(day,convert(DATETIME,FROM_DATE,101),convert(DATETIME,TO_DATE,101)) else 
datediff(day,convert(DATETIME,FROM_DATE,101),convert(DATETIME,TO_DATE,101)) + 1 end) as NoofDays,TOTAL_PERK_VALUE, ' + @ColumnName + ',totalTax,TEMP_EXERCISEID from 
             (
                 select p.EmployeeID,p.FROM_DATE,p.TO_DATE,p.VESTING_DATE,p.GRANT_DATE,TOTAL_PERK_VALUE,p.[Country],a.totalTax,p.TAX_HEADING,p.TAX_AMOUNT,a.TEMP_EXERCISEID
                 from
                 		
                 		((select 
                         [Country]
                        ,EmployeeID                        
                        ,FROM_DATE
                        ,TO_DATE
                        ,VESTING_DATE
                        ,GRANT_DATE
                        ,sum(TAX_AMOUNT) totalTax
                        ,GRANTLEGSERIALNO
                        ,TEMP_EXERCISEID                       
                       	from
                     	TEMP_GET_TAXDETAILS 
                     	group by
                     	[Country]
                        ,EmployeeID                        
                        ,FROM_DATE
                        ,TO_DATE
                        ,VESTING_DATE
                        ,GRANT_DATE
                        ,GRANTLEGSERIALNO
                        ,TEMP_EXERCISEID
                        )   
                     	a 
                 
                 join
                 
                         (select 
                         [Country]
                        ,EmployeeID
                        ,TAX_HEADING
                        ,TAX_AMOUNT
                        ,FROM_DATE
                        ,TO_DATE
                        ,VESTING_DATE
                        ,GRANT_DATE
                        ,TOTAL_PERK_VALUE 
                        ,GRANTLEGSERIALNO
                        ,TEMP_EXERCISEID                                             
                       from
                     	TEMP_GET_TAXDETAILS) p
                     	
                     	on a.EmployeeID=p.EmployeeID
                     	and a.FROM_DATE=p.FROM_DATE
                     	and a.TO_DATE=p.TO_DATE
                     	and a.VESTING_DATE=p.VESTING_DATE
                     	and a.GRANT_DATE=p.GRANT_DATE 
                     	and a.GRANTLEGSERIALNO=p.GRANTLEGSERIALNO
                     	and a.TEMP_EXERCISEID=p.TEMP_EXERCISEID
                     	)
                     	
                                         		
    					
            ) x
            pivot 
            (
                min(TAX_AMOUNT)
                for TAX_HEADING in (' + @ColumnName + ')
            ) p '








SET @ColumnName = (SELECT  + ' CONVERT(VARCHAR(200), '''') ' + REPLACE(@ColumnName, ',',', CONVERT(VARCHAR(200), '''') '))

IF EXISTS (SELECT * FROM SYS.tables WHERE name = '##TEMPTxHeadings2')
BEGIN
	Print 'Exists'
	DROP TABLE ##TEMPTxHeadings2  
END

EXEC ('SELECT * INTO ##TEMPTxHeadings2 FROM ( SELECT CONVERT(VARCHAR(200), '''') AS EmpID, CONVERT(datetime, '''',101) AS GRANT_DATE,CONVERT(datetime, '''',101) AS VESTING_DATE,CONVERT(VARCHAR(200), '''') AS Country,CONVERT(VARCHAR(20), '''',106) AS FromDate, CONVERT(VARCHAR(20), '''',106) AS Todate, CONVERT(VARCHAR(200), '''') AS NoofDays ,CONVERT(VARCHAR(200), '''') AS [Apportioned perquisite value (CUR)], ' + @ColumnName + ' ,CONVERT(VARCHAR(200), '''') AS [Total Tentative Tax],CONVERT(VARCHAR(200), '''') AS TEMP_EXERCISEID ) AS OUT_PUT ')
--EXEC ('SELECT * INTO ##TEMPTxHeadings2 FROM ( SELECT CONVERT(VARCHAR(200), '''') AS EmpID, CONVERT(datetime, '''',101) AS GRANT_DATE,CONVERT(datetime, '''',101) AS VESTING_DATE,CONVERT(VARCHAR(200), '''') AS Country,CONVERT(VARCHAR(200), '''') AS FromDate, CONVERT(VARCHAR(200), '''') AS Todate, CONVERT(VARCHAR(200), '''') AS NoofDays ,CONVERT(VARCHAR(200), '''') AS [Apportioned perquisite value (CUR)], ' + @ColumnName + ' ,CONVERT(VARCHAR(200), '''') AS [Total Tentative Tax] ) AS OUT_PUT ')
--DROP TABLE ##TEMPTxHeadings2

INSERT INTO ##TEMPTxHeadings2
EXECUTE sp_executesql @query
--SELECT * FROM ##TEMPTxHeadings2   
 	        
SELECT 
	SRD1.ID,
	SRD1.Employeeid AS [EmployeeId], 
	emp.LoginID AS [Old Employee ID],	
	NULL AS [Transfer Date],
	SRD1.employeename AS [Employee name],
	SRD1.SchemeId AS [SchemeName],
	--CONVERT(VARCHAR(50), SRD1.ExercisePrice) AS [ExercisePrice],
	SRD1.ExercisePrice AS [ExercisePrice],
	SRD1.Entity AS [Company],
	SRD1.Status AS [Quit/ Active],
	convert(VARCHAR(20),SRD1.GrantDate,106)AS [GrantDate],
	convert(VARCHAR(20),SRD1.VestingDate,106)AS [DateOfVesting],
	DATEDIFF(day,SRD1.GrantDate ,SRD1.VestingDate) AS [Total Grant Period Days],
	convert(VARCHAR(20),SRD1.VestingDate,106) AS [Date of Exercise],	
	SRD1.TotalGranted AS [Number of Units granted],
	CASE When SRD1.OptionsCancelled >0 THEN (SRD1.OptionsVested - SRD1.OptionsCancelled) ELSE  SRD1.OptionsVested END AS [Number of Units vested],
	SRD1.OptionsCancelled AS [Options Cancelled],	
	SRD1.CurrencyName AS Currency,
	CASE WHEN SRD1.FMVPrice IS NOT NULL THEN SRD1.FMVPrice ELSE  SRD1.TentativeFMVPrice END AS [FMV],		
	CASE WHEN SRD1.PerqstValue IS NOT NULL THEN SRD1.PerqstValue ELSE  SRD1.TentativePerqstValue END  AS [Perquisite value], 
	
   	T.* ,
   	   	
    NULL AS [Changes in column no],
    NULL AS [Infosys Remarks]	
	FROM  #SP_REPORT_DATA1 SRD1
	LEFT join ##TEMPTxHeadings2 T ON SRD1.Employeeid=T.EmpID
   	AND T.VESTING_DATE=SRD1.TEMP_VESTING_DATE
	AND T.GRANT_DATE=SRD1.GrantDate	
	and T.TEMP_EXERCISEID=SRD1.ID
	INNER JOIN 
	EmployeeMaster emp ON SRD1.Employeeid=emp.EmployeeID
	INNER JOIN SCHEME SCH ON SCH.SchemeId=SRD1.SchemeId
	ORDER BY SRD1.ID asc,CONVERT(VARCHAR(20),T.FromDate,106)desc
 
    
    SELECT max(m.EmpCount) totRecCount FROM(
SELECT count(d.SchemeId) EmpCount,d.SchemeId,d.Employeeid,d.DateOfVesting,d.GrantDate,d.ID FROM
	(
SELECT distinct
	SRD1.Employeeid AS [EmployeeId],
	SRD1.GrantDate AS [GrantDate],
	SRD1.VestingDate AS [DateOfVesting],	    
    T.VESTING_DATE,
    T.GRANT_DATE,
    SRD1.ID,    
    SRD1.SchemeId,T.FromDate,T.Todate
	FROM  #SP_REPORT_DATA1 SRD1
	
	 join
	##TEMPTxHeadings2 T ON SRD1.Employeeid=T.EmpID
	AND T.VESTING_DATE=SRD1.TEMP_VESTING_DATE
	AND T.GRANT_DATE=SRD1.GrantDate	
	AND T.TEMP_EXERCISEID=SRD1.ID
	GROUP BY 
	SRD1.Employeeid,
	SRD1.GrantDate,
	SRD1.VestingDate,
	T.VESTING_DATE,
    T.GRANT_DATE,
    SRD1.SchemeId,T.FromDate,T.Todate,SRD1.ID
    )d GROUP BY d.SchemeId,d.Employeeid,d.DateOfVesting,d.GrantDate,d.ID)m

DROP TABLE ##TEMPTxHeadings2
GO
