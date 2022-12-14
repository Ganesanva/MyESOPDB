/****** Object:  StoredProcedure [dbo].[Load_PersonalStatus_rpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Load_PersonalStatus_rpt]
GO
/****** Object:  StoredProcedure [dbo].[Load_PersonalStatus_rpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[Load_PersonalStatus_rpt] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@Status varchar(20) = 'All',
	@ESOPVersion VARCHAR (50)=NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatus_rpt]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatus_rpt]   (EMPLOYEEID, LOGINID, EMPLOYEENAME, 
				Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME, EMPLOYEEDESIGNATION,
                EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION, Status, DATEOFTERMINATION, ResidentialStatus, SBU, ENTITY, ACCOUNTNO,
                DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER, WARDNUMBER,
                EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, LWD, DPRECORD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME,
                BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER,RowInsrtDttm,RowUpdtDttm)
				EXECUTE [dbo].[GetEmployee_PersonalStatusReportData_rpt] ''' + @Status + '''';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #PERSONALSTATUS (
                EMPLOYEEID                VARCHAR (20) ,
                LOGINID                   VARCHAR (20) ,
                EMPLOYEENAME              VARCHAR (75) ,
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
                LWD                       DATETIME     ,
                REASONFORTERMINATION      VARCHAR (20) ,
                BROKER_DEP_TRUST_CMP_NAME VARCHAR (200),
                BROKER_DEP_TRUST_CMP_ID   VARCHAR (200),
                BROKER_ELECT_ACC_NUM      VARCHAR (200),
                COST_CENTER               VARCHAR (200),
				RowInsrtDttm			  DATETIME     ,
				RowUpdtDttm				  DATETIME     

            );
            SET @StrInsertQuery = 'INSERT INTO #PERSONALSTATUS(EMPLOYEEID,LOGINID,EMPLOYEENAME,
				 COUNTRYNAME,EMPLOYEEDESIGNATION,EMPLOYEEEMAIL,DATEOFJOINING,GRADE,LOCATION,Status,DATEOFTERMINATION,
				 [Residential Status],SBU,ENTITY,ACCOUNTNO,DEPARTMENT,PANNUMBER,DEPOSITORYPARTICIPANTNO,DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,
				 WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,LWD,REASONFORTERMINATION,BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER,RowInsrtDttm,RowUpdtDttm) EXECUTE [dbo].[GetEmployee_PersonalStatusReportData_rpt] ''' + @Status + '''';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatus_rpt]   (EMPLOYEEID,LOGINID, EMPLOYEENAME,
				 COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING,GRADE, LOCATION,Status, DATEOFTERMINATION,
				 ResidentialStatus,SBU,ENTITY,ACCOUNTNO,DEPARTMENT, PANNUMBER,DEPOSITORYPARTICIPANTNO,DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,
				 WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,LWD,REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER,RowInsrtDttm,RowUpdtDttm)
				 SELECT EMPLOYEEID,LOGINID,EMPLOYEENAME,COUNTRYNAME,EMPLOYEEDESIGNATION,EMPLOYEEEMAIL,DATEOFJOINING,GRADE,LOCATION,Status,
				 DATEOFTERMINATION, [Residential Status] AS ResidentialStatus,SBU,ENTITY,ACCOUNTNO,DEPARTMENT,PANNUMBER,DEPOSITORYPARTICIPANTNO,
				 DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,LWD,
				 REASONFORTERMINATION,BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER,RowInsrtDttm,RowUpdtDttm FROM #PERSONALSTATUS';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    --DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport] SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
    --EXECUTE (@StrUpdateQuery);
END
GO
