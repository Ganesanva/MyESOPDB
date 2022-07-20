DROP PROCEDURE [dbo].[PROC_GET_EMP_PERSONAL_DETAILS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EMP_PERSONAL_DETAILS]--'45909'
@LoginId NVARCHAR (100)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #EMP_TEMP_DATA
	(
		EmployeeID VARCHAR (20), LoginID VARCHAR (20), EmployeeName VARCHAR (750), EmployeeDesignation VARCHAR (200), EmployeeAddress VARCHAR (500),
		EmployeePhone VARCHAR (20), DateofJoining DATETIME, DateOfTermination DATETIME, Insider CHAR, ResidentialStatus CHAR,
		PANNumber VARCHAR (10), WardNumber VARCHAR (15), DematAccountType VARCHAR (15), DepositoryIDNumber VARCHAR (30),
		DepositoryParticipantNo VARCHAR (150), ClientIDNumber VARCHAR (16), EmployeeEmail VARCHAR (500), Grade VARCHAR (200),
		DepositoryName VARCHAR (10), ReasonForTermination NVARCHAR (200), BackOutTermination CHAR (200), Department VARCHAR (200),
		MLFV_DEPT_ID INT, Location VARCHAR (200), MLFV_LOC_ID NVARCHAR (50), SBU NVARCHAR (200), MLFV_SBU_ID NVARCHAR (50),
		Entity VARCHAR (200), MLFV_ENTITY_ID INT, AccountNo VARCHAR (20), ConfStatus CHAR, LWD DATETIME, Confirmn_Dt DATETIME,
		DPRecord VARCHAR (50), Mobile VARCHAR (20), SecondaryEmailID VARCHAR (50), CountryName VARCHAR (50), BROKER_DEP_TRUST_CMP_NAME VARCHAR (200),
		BROKER_DEP_TRUST_CMP_ID VARCHAR (200), BROKER_ELECT_ACC_NUM VARCHAR (200), COST_CENTER VARCHAR (200), MLFV_CC_ID INT,
		TAX_IDENTIFIER_COUNTRY NVARCHAR (100), TAX_IDENTIFIER_STATE NVARCHAR (100), Nationality  VARCHAR(50), FIELD1 NVARCHAR (400), FIELD2 NVARCHAR (400),
		FIELD3 NVARCHAR (400), FIELD4 NVARCHAR (400), FIELD5 NVARCHAR (400),FIELD6 NVARCHAR (400), FIELD7 NVARCHAR (400),
		FIELD8 NVARCHAR (400), FIELD9 NVARCHAR (400), FIELD10 NVARCHAR (400), IsValidBankAcc BIT,
		TAX_IDENTIFIER_COUNTRYName NVARCHAR (100),TAX_IDENTIFIER_STATEName NVARCHAR (100),DisplayCountryName NVARCHAR (100),EntityName NVARCHAR (100)
		,COSTCENTERName NVARCHAR (100)	,SBUName NVARCHAR (100),LocationName NVARCHAR (100),DepartmentName NVARCHAR (100)
	)
	
	/* print 'Step1' */
	
	INSERT INTO #EMP_TEMP_DATA  
	SELECT 
		EM.EmployeeID, LoginID, EM.EmployeeName, EmployeeDesignation, EmployeeAddress, EmployeePhone,
		CASE CONVERT(VARCHAR(10), DateofJoining, 101) WHEN '01/01/1900' THEN NULL ELSE DateofJoining END DateofJoining,
		DateOfTermination, Insider, ResidentialStatus, PANNumber, WardNumber, DematAccountType, DepositoryIDNumber, DepositoryParticipantNo, ClientIDNumber,
		EmployeeEmail, Grade, DepositoryName, ReasonForTermination, BackOutTermination,
		CASE  WHEN (SELECT IS_ADD_IN_LIST FROM MASTER_LIST_FLD_NAME WHERE MLFN_ID=4)=1
		THEN convert(nvarchar(20),MLFV_DEPT.MLFV_ID) ELSE 
			Department END AS Department, 
			ISNULL(MLFV_DEPT.MLFV_ID,0) AS [MLFV_DEPT_ID],
		CASE  WHEN (SELECT IS_ADD_IN_LIST FROM MASTER_LIST_FLD_NAME WHERE MLFN_ID=1)=1
		THEN convert(nvarchar(20),MLFV_LOCATION.MLFV_ID) ELSE 
			Location END AS Location,

		MLFV_LOCATION.MLFV_ID AS [MLFV_LOC_ID],
		CASE  WHEN (SELECT IS_ADD_IN_LIST FROM MASTER_LIST_FLD_NAME WHERE MLFN_ID=2)=1
		THEN convert(nvarchar(20),MLFV_SBU.MLFV_ID) ELSE 
			SBU END AS  SBU,

			MLFV_SBU.MLFV_ID AS [MLFV_SBU_ID],
		CASE  WHEN (SELECT IS_ADD_IN_LIST FROM MASTER_LIST_FLD_NAME WHERE MLFN_ID=3)=1
		THEN convert(nvarchar(20),MLFV_ENTITY.MLFV_ID) ELSE 
			Entity END AS Entity,
			ISNULL(MLFV_ENTITY.MLFV_ID,0) AS [MLFV_ENTITY_ID],
		AccountNo, ConfStatus, LWD, Confirmn_Dt, DPRecord, Mobile, SecondaryEmailID, CountryMaster.CountryAliasName, 
		BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM,
		
		CASE  WHEN (SELECT IS_ADD_IN_LIST FROM MASTER_LIST_FLD_NAME WHERE MLFN_ID=5)=1
		THEN convert(nvarchar(20),MLFV_CC.MLFV_ID) ELSE 
			COST_CENTER END AS COST_CENTER, 

			ISNULL(MLFV_CC.MLFV_ID,0) AS [MLFV_CC_ID],
		ISNULL(EM.TAX_IDENTIFIER_COUNTRY,'') AS TAX_IDENTIFIER_COUNTRY, ISNULL(TAX_IDENTIFIER_STATE,'') as TAX_IDENTIFIER_STATE, 
		EM.Nationality,
		ISNULL(Field1,0) AS FIELD1, ISNULL(Field2,0) AS FIELD2, ISNULL(Field3,0) AS FIELD3,
		ISNULL(Field4,0) AS FIELD4, ISNULL(Field5,0) AS FIELD5, ISNULL(Field6,0) AS FIELD6,
		ISNULL(Field7,0) AS FIELD7, ISNULL(Field8,0) AS FIELD8, ISNULL(Field9,0) AS FIELD9,
		ISNULL(Field10,0) AS FIELD10 , ISNULL(IsValidBankAcc,0) AS IsValidBankAcc,
		CM.CountryName AS TAX_IDENTIFIER_COUNTRYName, SM.STATE_NAME AS TAX_IDENTIFIER_STATEName ,CountryMaster.CountryName AS DisplayCountryName,
		MLFV_ENTITY.FIELD_VALUE AS EntityName,MLFV_CC.FIELD_VALUE AS COSTCENTERName ,MLFV_SBU.FIELD_VALUE AS SBUName,MLFV_LOCATION.FIELD_VALUE AS LocationName
		,MLFV_DEPT.FIELD_VALUE AS DepartmentName
    FROM
		EmployeeMaster EM
		LEFT OUTER JOIN CountryMaster ON EM.CountryName=CountryMaster.CountryAliasName
		LEFT OUTER JOIN CountryMaster CM ON EM.TAX_IDENTIFIER_COUNTRY=CONVERT(nvarchar(50), CM.ID)
		LEFT OUTER JOIN MST_STATES SM ON EM.TAX_IDENTIFIER_STATE= CONVERT(nvarchar(50),SM.MS_ID)
		LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_ENTITY ON  UPPER(EM.Entity) = CONVERT(nvarchar(50),MLFV_ENTITY.FIELD_VALUE) AND MLFV_ENTITY.MLFN_ID = 3
		LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_CC ON  UPPER(EM.COST_CENTER) =CONVERT(nvarchar(50),MLFV_CC.FIELD_VALUE) AND MLFV_CC.MLFN_ID = 5 
		LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_SBU ON  UPPER(EM.SBU) = CONVERT(nvarchar(50),MLFV_SBU.FIELD_VALUE) AND MLFV_SBU.MLFN_ID = 2
		LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_LOCATION ON  UPPER(EM.Location) = CONVERT(nvarchar(50),MLFV_LOCATION.FIELD_VALUE) AND MLFV_LOCATION.MLFN_ID = 1
		LEFT OUTER JOIN MASTER_LIST_FLD_VALUE AS MLFV_DEPT ON  UPPER(EM.Department) = CONVERT(nvarchar(50),MLFV_DEPT.FIELD_VALUE)  AND MLFV_DEPT.MLFN_ID = 4
	WHERE
		LoginID = @LoginId AND Deleted=0

	DECLARE @Emp_ID NVARCHAR(50) 
	DECLARE @Country_ID NVARCHAR(50)
	
	SELECT 
		@EMP_ID=EmployeeID FROM EmployeeMaster
	WHERE LoginID=@LoginId	AND Deleted=0
	/*
	IF EXISTS(SELECT SRNO FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@EMP_ID AND UPPER(Field)=('TAX IDENTIFIER COUNTRY'))
	BEGIN			
		
		SELECT @Country_ID=ID FROM CountryMaster
		WHERE CountryName IN (SELECT TOP(1) [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@EMP_ID AND UPPER(Field)=('TAX IDENTIFIER COUNTRY') ORDER BY SRNO DESC )		
	END
	ELSE
	BEGIN	

		IF EXISTS(SELECT EM.TAX_IDENTIFIER_COUNTRY FROM CountryMaster CM INNER JOIN EmployeeMaster EM ON CM.ID = CONVERT(INT, EM.TAX_IDENTIFIER_COUNTRY)
		WHERE  EmployeeId = @Emp_ID)	
		BEGIN
			SELECT @Country_ID=EM.TAX_IDENTIFIER_COUNTRY  FROM CountryMaster CM INNER JOIN EmployeeMaster EM ON CM.ID = CONVERT(INT, EM.TAX_IDENTIFIER_COUNTRY)
			WHERE  EmployeeId = @Emp_ID
		END
		ELSE
		BEGIN
			SELECT @Country_ID=0
		END				
		
	END*/
	--print @Country_ID
	--UPDATE #EMP_TEMP_DATA
	--SET TAX_IDENTIFIER_COUNTRY=@Country_ID
	--WHERE EmployeeID=@Emp_ID
	
	SELECT * FROM #EMP_TEMP_DATA
	
SET NOCOUNT OFF;
END

GO


