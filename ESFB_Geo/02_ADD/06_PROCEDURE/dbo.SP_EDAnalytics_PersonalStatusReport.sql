-- =============================================
-- Author:		Akshay Kadam
-- Create date: 2021-03-31
-- Description:	<Description,,>
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_EDAnalytics_PersonalStatusReport')
BEGIN
DROP PROCEDURE SP_EDAnalytics_PersonalStatusReport
END
GO

create   PROCEDURE [dbo].[SP_EDAnalytics_PersonalStatusReport] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@Status varchar(20) = 'All',
	@ESOPVersion VARCHAR (50)=NULL,
	@FROMDATE DATETIME=NULL,
	@TODATE DATETIME=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[EDAnalytics].[dbo].['+@DBName+'_PersonalStatusReport]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
			 CREATE TABLE #PERSONALSTATUSGlobal (
                EMPLOYEEID                VARCHAR (20) ,
                LOGINID                   VARCHAR (20) ,
                EMPLOYEENAME              VARCHAR (75) ,
                FATHERSNAME               VARCHAR (50) ,
				Mobile					  VARCHAR (20), 
				State					  VARCHAR (100),
				Nationality				  VARCHAR (100), 
				confirmn_Dt				  DATETIME,
                COUNTRYNAME               VARCHAR (50) ,
                EMPLOYEEDESIGNATION       VARCHAR (200),
                EMPLOYEEEMAIL             VARCHAR (500),
                DATEOFJOINING             DATETIME     ,
                GRADE                     VARCHAR (200),
                LOCATION                  VARCHAR (200),
                Status                    VARCHAR (10) ,
                DATEOFTERMINATION         DATETIME     ,
                [Residential Status]      VARCHAR (50) ,
                SBU                       VARCHAR (200),
                ENTITY                    VARCHAR (200),
                ACCOUNTNO                 VARCHAR (20) ,
                DEPARTMENT                VARCHAR (200),
                PANNUMBER                 VARCHAR (15) ,
                DEPOSITORYPARTICIPANTNO   VARCHAR (150),
                DEPOSITORYNAME            VARCHAR (20) ,
                DEPOSITORYIDNUMBER        VARCHAR (50) ,
                CONFSTATUS                CHAR (1)     ,
                CLIENTIDNUMBER            VARCHAR (20) ,
                WARDNUMBER                VARCHAR (15) ,
                EMPLOYEEADDRESS           VARCHAR (500),
                EMPLOYEEPHONE             VARCHAR (20) ,
                Insider                   CHAR (2)     ,
                DematAccountType          VARCHAR (15) ,
				DPRecord				  VARCHAR (50) ,
                LWD                       DATETIME     ,
                REASONFORTERMINATION      VARCHAR (20) ,
                BROKER_DEP_TRUST_CMP_NAME VARCHAR (200),
                BROKER_DEP_TRUST_CMP_ID   VARCHAR (200),
                BROKER_ELECT_ACC_NUM      VARCHAR (200),
                COST_CENTER               VARCHAR (200)
            );

            SET @StrInsertQuery = 'INSERT INTO #PERSONALSTATUSGlobal(EMPLOYEEID, LOGINID, EMPLOYEENAME,  
			Mobile, State, Nationality, confirmn_Dt,
             COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status,
             DATEOFTERMINATION, [Residential Status], SBU, ENTITY, ACCOUNTNO, DEPARTMENT,PANNUMBER,
             DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER,
             WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, DPRecord, LWD, REASONFORTERMINATION,
             BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER ) 
			 EXECUTE [dbo].[GetEmployee_PersonalStatusReportData] ''' + @Status + '''';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[EDAnalytics].[dbo].['+@DBName+'_PersonalStatusReport]
			(EMPLOYEEID, LOGINID, EMPLOYEENAME, FATHERSNAME,Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status, DATEOFTERMINATION,
				 ResidentialStatus, SBU, ENTITY, ACCOUNTNO, DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER,WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, DPRecord,LWD,REASONFORTERMINATION,BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID,
				 BROKER_ELECT_ACC_NUM,COST_CENTER)
				 SELECT EMPLOYEEID, LOGINID, EMPLOYEENAME, FATHERSNAME, Mobile, State, Nationality, confirmn_Dt,
				 COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status,
				 DATEOFTERMINATION, [Residential Status] As ResidentialStatus, SBU, ENTITY, ACCOUNTNO, DEPARTMENT,PANNUMBER,
				 DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER,
				 WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, DPRecord, LWD, REASONFORTERMINATION,
				 BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER FROM #PERSONALSTATUSGlobal';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #PERSONALSTATUS (
                EMPLOYEEID                VARCHAR (20) ,
                LOGINID                   VARCHAR (20) ,
                EMPLOYEENAME              VARCHAR (75) ,
                FATHERSNAME               VARCHAR (50) ,
				Mobile					  VARCHAR (20), 
				State					  VARCHAR (100),
				Nationality				  VARCHAR (100), 
				confirmn_Dt				  DATETIME,
                COUNTRYNAME               VARCHAR (50) ,
                EMPLOYEEDESIGNATION       VARCHAR (200),
                EMPLOYEEEMAIL             VARCHAR (500),
                DATEOFJOINING             DATETIME     ,
                GRADE                     VARCHAR (200),
                LOCATION                  VARCHAR (200),
                Status                    VARCHAR (10) ,
                DATEOFTERMINATION         DATETIME     ,
                [Residential Status]      VARCHAR (50) ,
                SBU                       VARCHAR (200),
                ENTITY                    VARCHAR (200),
                ACCOUNTNO                 VARCHAR (20) ,
                DEPARTMENT                VARCHAR (200),
                PANNUMBER                 VARCHAR (15) ,
                DEPOSITORYPARTICIPANTNO   VARCHAR (150),
                DEPOSITORYNAME            VARCHAR (20) ,
                DEPOSITORYIDNUMBER        VARCHAR (50) ,
                CONFSTATUS                CHAR (1)     ,
                CLIENTIDNUMBER            VARCHAR (20) ,
                WARDNUMBER                VARCHAR (15) ,
                EMPLOYEEADDRESS           VARCHAR (500),
                EMPLOYEEPHONE             VARCHAR (20) ,
                Insider                   CHAR (2)     ,
                DematAccountType          VARCHAR (15) ,
				DPRecord				  VARCHAR (15) ,
                LWD                       DATETIME     ,
                REASONFORTERMINATION      VARCHAR (20) ,
                BROKER_DEP_TRUST_CMP_NAME VARCHAR (200),
                BROKER_DEP_TRUST_CMP_ID   VARCHAR (200),
                BROKER_ELECT_ACC_NUM      VARCHAR (200),
                COST_CENTER               VARCHAR (200)
            );
            SET @StrInsertQuery = 'INSERT INTO #PERSONALSTATUS(EMPLOYEEID, LOGINID, EMPLOYEENAME, Mobile, State, Nationality, confirmn_Dt,
				  COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status, DATEOFTERMINATION,
				 [Residential Status], SBU, ENTITY, ACCOUNTNO, DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER,
				 WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, DPRecord, LWD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER) EXECUTE [dbo].[GetEmployee_PersonalStatusReportData] ''' + @Status + '''';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[EDAnalytics].[dbo].['+@DBName+'_PersonalStatusReport] (EMPLOYEEID,LOGINID,EMPLOYEENAME,
				 FATHERSNAME, COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status, DATEOFTERMINATION, ResidentialStatus, SBU, ENTITY, ACCOUNTNO, DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER,
					WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, LWD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM,COST_CENTER)
				 SELECT EMPLOYEEID,LOGINID,EMPLOYEENAME, FATHERSNAME,COUNTRYNAME,EMPLOYEEDESIGNATION,EMPLOYEEEMAIL,DATEOFJOINING,GRADE,LOCATION,Status,
				 DATEOFTERMINATION, [Residential Status] AS ResidentialStatus,SBU,ENTITY,ACCOUNTNO,DEPARTMENT,PANNUMBER,DEPOSITORYPARTICIPANTNO,
				 DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER, WARDNUMBER, EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, LWD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,
				 BROKER_ELECT_ACC_NUM,COST_CENTER FROM #PERSONALSTATUS';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[EDAnalytics].[dbo].['+@DBName+'_PersonalStatusReport] SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + ''', FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), @FROMDATE, 126)) + ''', ToDate= ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), @TODATE, 126)) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO

