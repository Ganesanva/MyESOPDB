/****** Object:  StoredProcedure [dbo].[SP_PersonalStatusReport]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_PersonalStatusReport]
GO
/****** Object:  StoredProcedure [dbo].[SP_PersonalStatusReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-04
-- Description:	<Description,,>
-- =============================================
CREATE      PROCEDURE [dbo].[SP_PersonalStatusReport] 
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
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN
		CREATE TABLE #PersonalStatusReportTemp(
	[EMPLOYEEID] [varchar](20) NULL,
	[LOGINID] [varchar](20) NULL,
	[EMPLOYEENAME] [varchar](75) NULL,
	[FATHERSNAME] [varchar](50) NULL,
	[Mobile] [varchar](20) NULL,
	[State] [varchar](100) NULL,
	[Nationality] [varchar](100) NULL,
	[confirmn_Dt] [datetime] NULL,
	[COUNTRYNAME] [varchar](50) NULL,
	[EMPLOYEEDESIGNATION] [varchar](200) NULL,
	[EMPLOYEEEMAIL] [varchar](500) NULL,
	[DATEOFJOINING] [datetime] NULL,
	[GRADE] [varchar](200) NULL,
	[LOCATION] [varchar](200) NULL,
	[SecondaryEmailID] [varchar](200) NULL,
	[Status] [varchar](10) NULL,
	[DATEOFTERMINATION] [datetime] NULL,
	[ResidentialStatus] [varchar](50) NULL,
	[SBU] [varchar](200) NULL,
	[ENTITY] [varchar](200) NULL,
	[ACCOUNTNO] [varchar](20) NULL,
	[DEPARTMENT] [varchar](200) NULL,
	[PANNUMBER] [varchar](15) NULL,
	[DEPOSITORYPARTICIPANTNO] [varchar](150) NULL,
	[DEPOSITORYNAME] [varchar](20) NULL,
	[DEPOSITORYIDNUMBER] [varchar](50) NULL,
	[CONFSTATUS] [char](1) NULL,
	[CLIENTIDNUMBER] [varchar](20) NULL,
	[WARDNUMBER] [varchar](15) NULL,
	[EMPLOYEEADDRESS] [varchar](500) NULL,
	[EMPLOYEEPHONE] [varchar](20) NULL,
	[Insider] [char](2) NULL,
	[DematAccountType] [varchar](15) NULL,
	[LWD] [VARCHAR](100) NULL,
	[DPRECORD] [varchar](50) NULL,
	[REASONFORTERMINATION] [varchar](20) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL,
	[COST_CENTER] [varchar](200) NULL
)


            SET @StrInsertQuery = 'INSERT INTO #PersonalStatusReportTemp(EMPLOYEEID, LOGINID, EMPLOYEENAME, 
				 Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME, EMPLOYEEDESIGNATION,
                EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION,SecondaryEmailID, Status, DATEOFTERMINATION, ResidentialStatus, SBU, ENTITY, ACCOUNTNO,
                DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER, WARDNUMBER,
                EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, DPRECORD, LWD , REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME,
                BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER)
				EXECUTE [dbo].[GetEmployee_PersonalStatusReportData] ''' + @Status + '''';
				exec GetEmployee_PersonalStatusReportData 'All'
            EXECUTE (@StrInsertQuery);
			SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport] (EMPLOYEEID, LOGINID, EMPLOYEENAME, 
				FATHERSNAME, Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME, EMPLOYEEDESIGNATION,
                EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION,SecondaryEmailID, Status, DATEOFTERMINATION, ResidentialStatus, SBU, ENTITY, ACCOUNTNO,
                DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER, WARDNUMBER,
                EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, LWD, DPRECORD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME,
                BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER)
				SELECT EMPLOYEEID, LOGINID, EMPLOYEENAME, 
				FATHERSNAME, Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME, EMPLOYEEDESIGNATION,
                EMPLOYEEEMAIL, DATEOFJOINING, GRADE, LOCATION,SecondaryEmailID, Status, DATEOFTERMINATION, ResidentialStatus, SBU, ENTITY, ACCOUNTNO,
                DEPARTMENT, PANNUMBER, DEPOSITORYPARTICIPANTNO, DEPOSITORYNAME, DEPOSITORYIDNUMBER, CONFSTATUS, CLIENTIDNUMBER, WARDNUMBER,
                EMPLOYEEADDRESS, EMPLOYEEPHONE, Insider, DematAccountType, LWD, DPRECORD, REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME,
                BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM, COST_CENTER FROM #PersonalStatusReportTemp';
            EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
		 CREATE TABLE #PERSONALSTATUS (
                EMPLOYEEID                VARCHAR (20) ,
                LOGINID                   VARCHAR (20) ,
                EMPLOYEENAME              VARCHAR (75) ,
                FATHERSNAME               VARCHAR (50) ,
				[Mobile]				  varchar(20) NULL,
				[State]					  varchar(100) NULL,
				[Nationality]			  varchar(100) NULL,
				[confirmn_Dt]			  datetime NULL,
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
				DPRECORD				  VARCHAR(50) NULL,
                REASONFORTERMINATION      VARCHAR (20) ,
                BROKER_DEP_TRUST_CMP_NAME VARCHAR (200),
                BROKER_DEP_TRUST_CMP_ID   VARCHAR (200),
                BROKER_ELECT_ACC_NUM      VARCHAR (200),
                COST_CENTER               VARCHAR (200)
            );
            SET @StrInsertQuery = 'INSERT INTO #PERSONALSTATUS(EMPLOYEEID,LOGINID,EMPLOYEENAME,
				  Mobile, State, Nationality, confirmn_Dt, COUNTRYNAME,EMPLOYEEDESIGNATION,EMPLOYEEEMAIL,DATEOFJOINING,GRADE,LOCATION,Status,DATEOFTERMINATION,
				 [Residential Status],SBU,ENTITY,ACCOUNTNO,DEPARTMENT,PANNUMBER,DEPOSITORYPARTICIPANTNO,DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,
				 WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,DPRECORD,LWD,REASONFORTERMINATION,BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER) EXECUTE [dbo].[GetEmployee_PersonalStatusReportData] ''' + @Status + '''';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport]   (EMPLOYEEID,LOGINID, EMPLOYEENAME,
				 FATHERSNAME, COUNTRYNAME, EMPLOYEEDESIGNATION, EMPLOYEEEMAIL, DATEOFJOINING,GRADE, LOCATION,Status, DATEOFTERMINATION,
				 ResidentialStatus,SBU,ENTITY,ACCOUNTNO,DEPARTMENT, PANNUMBER,DEPOSITORYPARTICIPANTNO,DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,
				 WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,LWD,REASONFORTERMINATION, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER)
				 SELECT EMPLOYEEID,LOGINID,EMPLOYEENAME,FATHERSNAME,COUNTRYNAME,EMPLOYEEDESIGNATION,EMPLOYEEEMAIL,DATEOFJOINING,GRADE,LOCATION,Status,
				 DATEOFTERMINATION, [Residential Status] AS ResidentialStatus,SBU,ENTITY,ACCOUNTNO,DEPARTMENT,PANNUMBER,DEPOSITORYPARTICIPANTNO,
				 DEPOSITORYNAME,DEPOSITORYIDNUMBER,CONFSTATUS,CLIENTIDNUMBER,WARDNUMBER,EMPLOYEEADDRESS,EMPLOYEEPHONE,Insider,DematAccountType,LWD,
				 REASONFORTERMINATION,BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM,COST_CENTER FROM #PERSONALSTATUS';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[PersonalStatusReport] SET PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
    EXECUTE (@StrUpdateQuery);
END
GO
