IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_ExerciseReport')
BEGIN
DROP PROCEDURE SP_ExerciseReport
END
GO

CREATE    PROCEDURE [dbo].[SP_ExerciseReport]
@DBName VARCHAR (50), @LinkedServer VARCHAR (50), @FromDate DATETIME, @ToDate DATETIME, @ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport]';
    EXECUTE (@ClearDataQuery);
    IF (@ESOPVersion = 'Global')
        BEGIN

		CREATE TABLE #ExerciseReportTemp(
	[EmployeeID] [varchar](20) NULL,
	[Instrument_Name] [varchar](500) NULL,
	[CountryName] [varchar](50) NULL,
	[ExercisePrice] [numeric](10, 2) NULL,
	[CurrencyName] [varchar](50) NULL,
	[SharesArised] [numeric](18, 0) NULL,
	[SARExerciseAmount] [numeric](18, 6) NULL,
	[ExercisedId] [numeric](18, 0) NULL,
	[EmployeeName] [varchar](100) NULL,
	[GrantRegistrationId] [varchar](20) NULL,
	[GrantoptionId] [varchar](100) NULL,
	[GrantDate] [datetime] NULL,
	[ExercisedQuantity] [numeric](18, 0) NULL,
	[SharesAlloted] [numeric](18, 0) NULL,
	[ExercisedDate] [datetime] NULL,
	[ExercisedPrice] [numeric](10, 2) NULL,
	[SchemeTitle] [varchar](50) NULL,
	[OptionRatioMultiplier] [numeric](18, 0) NULL,
	[schemeid] [varchar](50) NULL,
	[OptionRatioDivisor] [numeric](18, 0) NULL,
	[SharesIssuedDate] [datetime] NULL,
	[DateOfPayment] [datetime] NULL,
	[Parent] [char](20) NULL,
	[VestingDate] [datetime] NULL,
	[GrantLegId] [decimal](10, 0) NULL,
	[FBTValue] [numeric](10, 2) NULL,
	[Cash] [varchar](50) NULL,
	[SAR_PerqValue] [numeric](18, 2) NULL,
	[FaceValue] [numeric](18, 2) NULL,
	[FACE_VALUE] [numeric](18, 2) NULL,
	[PerqstValue] [numeric](18, 6) NULL,
	[PerqstPayable] [numeric](18, 6) NULL,
	[FMVPrice] [numeric](18, 6) NULL,
	[FBTdays] [int] NULL,
	[TravelDays] [int] NULL,
	[PaymentMode] [varchar](50) NULL,
	[PerqTaxRate] [numeric](18, 6) NULL,
	[ExerciseNo] [numeric](18, 0) NULL,
	[Exercise_Amount] [numeric](18, 6) NULL,
	[Date_of_Payment] [datetime] NULL,
	[AccountNumber] [varchar](20) NULL,
	[ConfStatus] [char](10) NULL,
	[DateOfJoining] [datetime] NULL,
	[DateOfTermination] [datetime] NULL,
	[Department] [varchar](200) NULL,
	[EmployeeDesignation] [varchar](200) NULL,
	[Entity] [varchar](200) NULL,
	[Grade] [varchar](200) NULL,
	[Insider] [char](1) NULL,
	[ReasonForTermination] [varchar](200) NULL,
	[SBU] [varchar](200) NULL,
	[ResidentialStatus] [varchar](100) NULL,
	[Itcircle_WardNumber] [varchar](15) NULL,
	[DepositoryName] [varchar](200) NULL,
	[DepositoryParticipatoryName] [varchar](200) NULL,
	[ConfirmationDate] [datetime] NULL,
	[NameasPerDPRecord] [varchar](50) NULL,
	[EmployeeAddress] [varchar](500) NULL,
	[EmployeeEmail] [varchar](500) NULL,
	[EmployeePhone] [varchar](20) NULL,
	[Pan_GirNumber] [varchar](20) NULL,
	[DematacType] [varchar](20) NULL,
	[DPPdNumber] [varchar](20) NULL,
	[ClientIdNumber] [varchar](20) NULL,
	[Location] [varchar](200) NULL,
	[LotNumber] [varchar](20) NULL,
	[CurrencyAlias] [varchar](50) NULL,
	[MIT_ID] [int] NULL,
	[SettlmentPrice] [numeric](18, 6) NULL,
	[StockApprValue] [numeric](18, 6) NULL,
	[CashPayoutValue] [numeric](18, 6) NULL,
	[ShareAriseApprValue] [numeric](18, 6) NULL,
	[LWD] [datetime] NULL,
	[COST_CENTER] [varchar](200) NULL,
	[Status] [varchar](10) NULL,
	[BROKER_DEP_TRUST_CMP_ID] [varchar](200) NULL,
	[BROKER_DEP_TRUST_CMP_NAME] [varchar](200) NULL,
	[BROKER_ELECT_ACC_NUM] [varchar](200) NULL,
	[Country] [varchar](50) NULL,
	[State] [varchar](100) NULL,
	[EquivalentShares] [numeric](18, 0) NULL
	) 
            SET @StrInsertQuery = 'INSERT INTO #ExerciseReportTemp(EmployeeID, Instrument_Name, CountryName, 
			ExercisePrice, CurrencyName, SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantoptionId, GrantDate, 
			ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, schemeid, OptionRatioDivisor, SharesIssuedDate, 
			DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE, PerqstValue, PerqstPayable, FMVPrice,
            FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus,
            DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,
            ResidentialStatus, Itcircle_WardNumber, DepositoryName, DepositoryParticipatoryName, ConfirmationDate, NameasPerDPRecord,
            EmployeeAddress, EmployeeEmail, EmployeePhone, Pan_GirNumber, DematacType, DPPdNumber, ClientIdNumber, Location, LotNumber,
            CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue, ShareAriseApprValue, LWD, COST_CENTER, Status, 
			BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares)
			EXECUTE dbo.PROC_CRExerciseReport ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''',''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
            print @StrInsertQuery
			EXECUTE (@StrInsertQuery);
			SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport](EmployeeID, Instrument_Name, CountryName, 
			ExercisePrice, CurrencyName, SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantoptionId, GrantDate, 
			ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, schemeid, OptionRatioDivisor, SharesIssuedDate, 
			DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE, PerqstValue, PerqstPayable, FMVPrice,
            FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus,
            DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,
            ResidentialStatus, Itcircle_WardNumber, DepositoryName, DepositoryParticipatoryName, ConfirmationDate, NameasPerDPRecord,
            EmployeeAddress, EmployeeEmail, EmployeePhone, Pan_GirNumber, DematacType, DPPdNumber, ClientIdNumber, Location, LotNumber,
            CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue, ShareAriseApprValue, LWD, COST_CENTER, Status, 
			BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares)
			SELECT EmployeeID, Instrument_Name, CountryName, 
			ExercisePrice, CurrencyName, SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantoptionId, GrantDate, 
			ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, schemeid, OptionRatioDivisor, SharesIssuedDate, 
			DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE, PerqstValue, PerqstPayable, FMVPrice,
            FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus,
            DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,
            ResidentialStatus, Itcircle_WardNumber, DepositoryName, DepositoryParticipatoryName, ConfirmationDate, NameasPerDPRecord,
            EmployeeAddress, EmployeeEmail, EmployeePhone, Pan_GirNumber, DematacType, DPPdNumber, ClientIdNumber, Location, LotNumber,
            CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue, ShareAriseApprValue, LWD, COST_CENTER, Status, 
			BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares FROM #ExerciseReportTemp';
           print @StrInsertQuery
		   EXECUTE (@StrInsertQuery);
        END
    ELSE
        BEGIN
            CREATE TABLE #TEMP (
                EMPLOYEEID                  VARCHAR (20)   ,
                COUNTRYNAME                 VARCHAR (50)   ,
                SHARESARISED                NUMERIC (18, 0),--
                SAREXERCISEAMOUNT           NUMERIC (18, 6),
                EXERCISEDID                 NUMERIC (18, 0),
                EMPLOYEENAME                VARCHAR (100)  ,
                GRANTREGISTRATIONID         VARCHAR (20)   ,
                GRANTOPTIONID               VARCHAR (100)  ,
                GRANTDATE                   DATETIME       ,
                EXERCISEDQUANTITY           NUMERIC (18, 0),
                SHARESALLOTED               NUMERIC (18, 0),
                EXERCISEDDATE               DATETIME       ,
                EXERCISEDPRICE              NUMERIC (10, 2),
                SCHEMETITLE                 VARCHAR (50)   ,
                OPTIONRATIOMULTIPLIER       NUMERIC (18, 0),
                SCHEMEID                    VARCHAR (50)   ,
                OPTIONRATIODIVISOR          NUMERIC (18, 0),
                SHARESISSUEDDATE            DATETIME       ,
                DATEOFPAYMENT               DATETIME       ,
                PARENT                      CHAR (20)      , -- changed from 10 to 20 
                VESTINGDATE                 DATETIME       ,
                GRANTLEGID                  DECIMAL (10, 0),
                FBTVALUE                    NUMERIC (10, 2),
                CASH                        VARCHAR (50)   ,
                SAR_PERQVALUE               NUMERIC (18, 2),
                FACEVALUE                   NUMERIC (18, 2),
                PERQSTVALUE                 NUMERIC (18, 6),
                PERQSTPAYABLE               NUMERIC (18, 6),
                FMVPRICE                    NUMERIC (18, 6),
                FBTDAYS                     INT ,---NUMERIC (10, 0),
                TRAVELDAYS                  INT            ,
                PAYMENTMODE                 VARCHAR (50)   ,
                PERQTAXRATE                 NUMERIC (18, 6),
                EXERCISENO                  NUMERIC (18, 0),
                EXERCISE_AMOUNT             NUMERIC (18, 6),
                [DATE OF PAYMENT]           DATETIME       ,
                [ACCOUNT NUMBER]            VARCHAR (20)   ,
                CONFSTATUS                  CHAR (10)      ,
                DATEOFJOINING               DATETIME       ,
                DATEOFTERMINATION           DATETIME       ,
                DEPARTMENT                  VARCHAR (200)  ,
                EMPLOYEEDESIGNATION         VARCHAR (200)  ,
                ENTITY                      VARCHAR (200)  ,
                GRADE                       VARCHAR (200)  ,
                INSIDER                     CHAR (1)       ,
				REASONFORTERMINATION        VARCHAR (200)  ,
                SBU                         VARCHAR (200)  ,
                RESIDENTIALSTATUS           VARCHAR (100)  ,
                ITCIRCLE_WARDNUMBER         VARCHAR (15)   ,
                DEPOSITORYNAME              VARCHAR (200)  ,
                DEPOSITORYPARTICIPATORYNAME VARCHAR (200)  ,
                CONFIRMATIONDATE            DATETIME       ,
                NAMEASPERDPRECORD           VARCHAR (50)   ,
                EMPLOYEEADDRESS             VARCHAR (500)  ,
                EMPLOYEEEMAIL               VARCHAR (500)  ,
                EMPLOYEEPHONE               VARCHAR (20)   ,
                PAN_GIRNUMBER               VARCHAR (20)   ,
                dematactype                 VARCHAR (20)   ,
                dpidnumber                  VARCHAR (20)   ,
                clientidnumber              VARCHAR (20)   ,
                location                    VARCHAR (200)  ,
                LotNumber                   VARCHAR (20)   
            );
            SET @StrInsertQuery = 'INSERT INTO #TEMP EXECUTE dbo.PROC_CRExerciseReport ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''',''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
            print @StrInsertQuery
			EXECUTE (@StrInsertQuery);
            SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport] (EMPLOYEEID, COUNTRYNAME, SHARESARISED,	
			SAREXERCISEAMOUNT, EXERCISEDID,	EMPLOYEENAME, GRANTREGISTRATIONID, GRANTOPTIONID, GRANTDATE, EXERCISEDQUANTITY,	SHARESALLOTED, EXERCISEDDATE,	
			EXERCISEDPRICE, SCHEMETITLE, OPTIONRATIOMULTIPLIER,	SCHEMEID, OPTIONRATIODIVISOR, SHARESISSUEDDATE,	DATEOFPAYMENT,	PARENT,	VESTINGDATE,	
			GRANTLEGID,	FBTVALUE, CASH, SAR_PERQVALUE, FACEVALUE, PERQSTVALUE, PERQSTPAYABLE, FMVPRICE,	FBTDAYS, TRAVELDAYS, PAYMENTMODE, PERQTAXRATE, 
			EXERCISENO,	EXERCISE_AMOUNT, ACCOUNTNUMBER,	CONFSTATUS,	DATEOFJOINING,	DATEOFTERMINATION,	DEPARTMENT,	EMPLOYEEDESIGNATION,
			ENTITY,	GRADE, INSIDER,	REASONFORTERMINATION, SBU, RESIDENTIALSTATUS, ITCIRCLE_WARDNUMBER, DEPOSITORYNAME, DEPOSITORYPARTICIPATORYNAME,
			CONFIRMATIONDATE, NAMEASPERDPRECORD, EMPLOYEEADDRESS, EMPLOYEEEMAIL, EMPLOYEEPHONE, PAN_GIRNUMBER, dematactype, DPPdNumber ,clientidnumber,
			location, LotNumber)
			SELECT EMPLOYEEID, COUNTRYNAME, SHARESARISED,	
			SAREXERCISEAMOUNT, EXERCISEDID,	EMPLOYEENAME, GRANTREGISTRATIONID, GRANTOPTIONID, GRANTDATE, EXERCISEDQUANTITY,	SHARESALLOTED, EXERCISEDDATE,	
			EXERCISEDPRICE, SCHEMETITLE, OPTIONRATIOMULTIPLIER,	SCHEMEID, OPTIONRATIODIVISOR, SHARESISSUEDDATE, [DATE OF PAYMENT] AS DATEOFPAYMENT,	PARENT,	VESTINGDATE,	
			GRANTLEGID,	FBTVALUE, CASH, SAR_PERQVALUE, FACEVALUE, PERQSTVALUE, PERQSTPAYABLE, FMVPRICE,	FBTDAYS, TRAVELDAYS, PAYMENTMODE, PERQTAXRATE, 
			EXERCISENO,	EXERCISE_AMOUNT, [ACCOUNT NUMBER] AS ACCOUNTNUMBER,	CONFSTATUS,	DATEOFJOINING,	DATEOFTERMINATION,	DEPARTMENT,	EMPLOYEEDESIGNATION,
			ENTITY,	GRADE, INSIDER,	REASONFORTERMINATION, SBU, RESIDENTIALSTATUS, ITCIRCLE_WARDNUMBER, DEPOSITORYNAME, DEPOSITORYPARTICIPATORYNAME,
			CONFIRMATIONDATE, NAMEASPERDPRECORD, EMPLOYEEADDRESS, EMPLOYEEEMAIL, EMPLOYEEPHONE, PAN_GIRNUMBER, dematactype, dpidnumber,	clientidnumber,
			location, LotNumber FROM #TEMP';
            PRINT (@StrInsertQuery);
            EXECUTE (@StrInsertQuery);
        END
    DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport] 
			SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''
			, PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (50), GetDate(), 121)) + '''';
			EXECUTE (@StrUpdateQuery);
END
GO

