DROP PROCEDURE [dbo].[GetEmployee_PersonalStatusReportData]
GO

/****** Object:  StoredProcedure [dbo].[GetEmployee_PersonalStatusReportData]    Script Date: 18-07-2022 18:31:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[GetEmployee_PersonalStatusReportData]
(
	@Status varchar(20)
)
AS
BEGIN
	DECLARE @SqlStatement VARCHAR(MAX),@SqlConditionsLive VARCHAR(MAX),@SqlConditionsSeparate VARCHAR(MAX)
	SET @SqlStatement=' SELECT EM.EMPLOYEEID, LOGINID, EMPLOYEENAME,Mobile,State,Nationality,confirmn_Dt, CM.COUNTRYNAME AS COUNTRYNAME, EMPLOYEEDESIGNATION,  
		EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION,EM.SecondaryEmailID,
		CASE WHEN (LWD IS null) THEN ''Live'' 
			 WHEN (LWD > CAST(CAST(GETDATE() AS DATE)AS DATETIME)) THEN ''Live''
		     WHEN (LWD =''1900-01-01 00:00:00.000'') THEN ''Live'' 
			 WHEN (CONVERT(DATE,LWD) < CONVERT(DATE, DATEOFTERMINATION)) THEN ''Live'' 
			 ELSE ''Separate''END AS [Status], 
		CASE WHEN (DATEOFTERMINATION=''1900-01-01 00:00:00.000'') THEN NULL ELSE DATEOFTERMINATION END AS DATEOFTERMINATION,
		CASE WHEN (RESIDENTIALSTATUS=''R'') THEN ''Resident Indian''
			 WHEN (RESIDENTIALSTATUS=''N'') THEN ''Non Resident Indian''
			 WHEN (RESIDENTIALSTATUS=''F'') THEN ''Foreign National'' END [Residential Status],
		SBU, ENTITY, ACCOUNTNO, DEPARTMENT, PANNUMBER,
		(CASE WHEN (DEPOSITORYPARTICIPANTNO IS NULL OR DEPOSITORYPARTICIPANTNO = '''' ) THEN EUD.DepositoryParticipantName ELSE DEPOSITORYPARTICIPANTNO END) AS DEPOSITORYPARTICIPANTNO,
		CASE WHEN EUD.DEPOSITORYNAME = ''N'' THEN ''NSDL'' 
			 WHEN EUD.DEPOSITORYNAME = ''C'' THEN ''CDSL'' 
				ELSE EUD.DEPOSITORYNAME END AS  DEPOSITORYNAME,
		EUD.DEPOSITORYIDNUMBER, CONFSTATUS, EUD.CLIENTIDNUMBER,
		(CASE WHEN (WARDNUMBER=''undefined'') THEN '''' ELSE EM.WARDNUMBER END ) AS WARDNUMBER, 
		 EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, 
		(CASE WHEN (EUD.DematAccountType IS NULL) THEN NULL
			WHEN (EUD.DematAccountType = ''R'') THEN ''Repatriable'' 
			WHEN (EUD.DematAccountType = ''N'') THEN ''Non Repatriable'' 
			WHEN (EUD.DematAccountType = ''A'') THEN ''Not Applicable''
			ELSE 
			EUD.DematAccountType END) AS DematAccountType, 
			EUD.DPRecord,
		(CASE WHEN (LWD IS NULL) THEN NULL 
			  WHEN (LWD = ''1900-01-01 00:00:00.000'') THEN NULL
			ELSE LWD END) AS LWD  '
	--For Status = Live 
	IF (@Status = 'Live')
	BEGIN
		SET @SqlConditionsLive=' , NULL AS REASONFORTERMINATION,EUB.BROKER_DEP_TRUST_CMP_NAME,EUB.BROKER_DEP_TRUST_CMP_ID,EUB.BROKER_ELECT_ACC_NUM,COST_CENTER							 
							 FROM EMPLOYEEMASTER AS EM LEFT OUTER JOIN COUNTRYMASTER AS CM ON EM.COUNTRYNAME=CM.COUNTRYALIASNAME
							 LEFT OUTER JOIN Employee_UserDematDetails AS EUD on EM.EmployeeID = EUD.EmployeeID and ISNULL(EUD.IsActive,0)=1 
							 LEFT OUTER JOIN Employee_UserBrokerDetails AS EUB ON EM.EmployeeID = EUB.EMPLOYEE_ID and ISNULL(EUB.IS_ACTIVE,0)=1
							 WHERE  (NEWEMPLOYEEID IS NULL) AND (Deleted = ''0'') 
							 AND ((DATEOFTERMINATION IS NULL) OR (LWD IS NULL OR LWD = ''1900-01-01 00:00:00.000''))
							 '
	   SET @SqlStatement = @SqlStatement + @SqlConditionsLive
	END
	
	--For Status = 'Separate'
	ELSE IF(@Status = 'Separate')	
	BEGIN
	  SET @SqlConditionsSeparate= ' , REASONFORTERMINATION.REASON AS REASONFORTERMINATION,EUB.BROKER_DEP_TRUST_CMP_NAME,
							EUB.BROKER_DEP_TRUST_CMP_ID,EUB.BROKER_ELECT_ACC_NUM, COST_CENTER
							FROM EMPLOYEEMASTER AS EM LEFT OUTER JOIN COUNTRYMASTER AS CM ON EM.COUNTRYNAME=CM.COUNTRYALIASNAME
							LEFT OUTER JOIN Employee_UserDematDetails AS EUD ON EM.EmployeeID = EUD.EmployeeID and ISNULL(EUD.IsActive,0)=1 
							LEFT OUTER JOIN Employee_UserBrokerDetails AS EUB ON EM.EmployeeID = EUB.EMPLOYEE_ID and ISNULL(EUB.IS_ACTIVE,0)=1
							,REASONFORTERMINATION 
							WHERE REASONFORTERMINATION.ID=EM.REASONFORTERMINATION 
							AND (NEWEMPLOYEEID IS NULL) AND (Deleted = ''0'')
							AND (LWD IS NOT NULL) AND (DATEOFTERMINATION IS NOT NULL)
							  '
	 SET @SqlStatement = @SqlStatement + @SqlConditionsSeparate			 
	END
	
	 --For Status : All
	ELSE IF(@Status = 'All')
	BEGIN
		SET @SqlConditionsLive=' ,NULL AS REASONFORTERMINATION, EUB.BROKER_DEP_TRUST_CMP_NAME, EUB.BROKER_DEP_TRUST_CMP_ID, EUB.BROKER_ELECT_ACC_NUM,COST_CENTER
							 FROM EMPLOYEEMASTER AS EM LEFT OUTER JOIN COUNTRYMASTER AS CM ON EM.COUNTRYNAME=CM.COUNTRYALIASNAME
							 LEFT OUTER JOIN Employee_UserDematDetails AS EUD on EM.EmployeeID = EUD.EmployeeID and ISNULL(EUD.IsActive,0)=1 
							 LEFT OUTER JOIN Employee_UserBrokerDetails AS EUB ON EM.EmployeeID = EUB.EMPLOYEE_ID and ISNULL(EUB.IS_ACTIVE,0)=1
							 WHERE  (NEWEMPLOYEEID IS NULL) AND (Deleted = ''0'') 
							 AND ((DATEOFTERMINATION IS NULL) OR (LWD IS NULL OR LWD = ''1900-01-01 00:00:00.000''))'

		SET @SqlConditionsSeparate= ' ,REASONFORTERMINATION.REASON AS REASONFORTERMINATION,EUB.BROKER_DEP_TRUST_CMP_NAME,EUB.BROKER_DEP_TRUST_CMP_ID,EUB.BROKER_ELECT_ACC_NUM,COST_CENTER
							FROM EMPLOYEEMASTER AS EM LEFT OUTER JOIN COUNTRYMASTER AS CM ON EM.COUNTRYNAME=CM.COUNTRYALIASNAME
							LEFT OUTER JOIN Employee_UserDematDetails AS EUD on EM.EmployeeID = EUD.EmployeeID and ISNULL(EUD.IsActive,0)=1 
							LEFT OUTER JOIN Employee_UserBrokerDetails AS EUB ON EM.EmployeeID = EUB.EMPLOYEE_ID and ISNULL(EUB.IS_ACTIVE,0)=1
							,REASONFORTERMINATION 
							WHERE REASONFORTERMINATION.ID=EM.REASONFORTERMINATION 
							AND (NEWEMPLOYEEID IS NULL) AND (Deleted = ''0'')
							AND (LWD IS NOT NULL) AND (DATEOFTERMINATION IS NOT NULL)
							'					 
		SET @SqlStatement = @SqlStatement + @SqlConditionsLive
						    + ' UNION ALL ' 
							+ @SqlStatement + @SqlConditionsSeparate
	END
   --PRINT @SqlStatement
   EXEC (@SqlStatement)
END
GO


