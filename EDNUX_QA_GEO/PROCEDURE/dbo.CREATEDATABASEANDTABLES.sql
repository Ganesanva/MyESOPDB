/****** Object:  StoredProcedure [dbo].[CREATEDATABASEANDTABLES]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CREATEDATABASEANDTABLES]
GO
/****** Object:  StoredProcedure [dbo].[CREATEDATABASEANDTABLES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[CREATEDATABASEANDTABLES] 
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @StrInsertQuery AS VARCHAR (MAX);
	
	CREATE TABLE #MASTER_DATABASES (NAME VARCHAR(100))
	SET @StrInsertQuery = 'INSERT INTO #MASTER_DATABASES (NAME) SELECT NAME FROM ['+@LinkedServer+'].MASTER.SYS.DATABASES WHERE NAME = ''' + @DBName + '''';
	EXECUTE(@StrInsertQuery);

	IF(NOT EXISTS(SELECT * FROM #MASTER_DATABASES WHERE NAME = @DBName))
    BEGIN
       DECLARE @CreateDB VARCHAR(max) ='[' + @LinkedServer + '].tempdb.dbo.sp_executesql N''CREATE DATABASE ' +  @DBName + ''';';
       EXECUTE(@CreateDB)
    END

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
	EXECUTE(@USEDB)

	IF(OBJECT_ID(N'dbo.OnlineTransactionData', N'U') IS NULL)
    BEGIN
		CREATE TABLE OnlineTransactionData
		(
		  [Exercise number/Application number] NUMERIC (18, 0), [Exercise ID] NUMERIC (18, 0), [Employee ID] NVARCHAR(500), [Employee Name] VARCHAR (75)
		, [Country] VARCHAR (50), [Scheme Name] VARCHAR (50), [Grant Registration ID] VARCHAR (20), [Grant Date] DATETIME, [Grant Option ID] VARCHAR (100)
		, [Options Exercised] NUMERIC (18, 0), [Exercise Price] NUMERIC (18, 2), [Amount Paid] NUMERIC (37, 2), [Exercise Date] DATETIME
		, fmv NUMERIC (18, 2), [Perquiste Value] NUMERIC (18, 2), [Perquisite Tax payable] NUMERIC (18, 2), [Perq_Tax_rate] NUMERIC (18, 6)
		, [Equivalent Exercise Quantity] NUMERIC (38, 0), [Grant vest period id] DECIMAL (10, 0), [Vesting Date] DATETIME, [Payment mode] VARCHAR (20)
		, PaymentMode VARCHAR (1), lotnumber VARCHAR (20), validationstatus VARCHAR (1), revarsalreason VARCHAR (1), receiveddate DATETIME
		, exerciseformreceived VARCHAR (10), exformreceivedstatus VARCHAR (3), IsPaymentDeposited BIT, PaymentDepositedDate DATETIME
		, IsPaymentConfirmed BIT, PaymentConfirmedDate DATETIME, IsExerciseAllotted BIT, ExerciseAllotedDate DATETIME
		, IsAllotmentGenerated BIT, AllotmentGenerateDate DATETIME, IsAllotmentGeneratedReversed BIT, AllotmentGeneratedReversedDate DATETIME
		, MIT_ID INT, [INSTRUMENT_NAME] NVARCHAR (500), [Name as in Depository Participant (DP) records] VARCHAR (50), [Name of Depository] VARCHAR (200)
		, [Demat A/C Type] VARCHAR (50), [Name of Depository Participant (DP)] VARCHAR (200), [Depository ID] VARCHAR (50), [Client ID] TEXT
		, pan VARCHAR (50), [Residential Status] VARCHAR (16), nationality VARCHAR (100), location VARCHAR (200), [Mobile Number] VARCHAR (51)
		, [Broker Company Name] VARCHAR (200), [Broker Company Id] VARCHAR (200),[Broker Electronic Account Number] VARCHAR (200), [Email Address] VARCHAR (500)
		, [Employee Address] VARCHAR (500), [Cheque No (Exercise amount)] VARCHAR (100), [Cheque Date (Exercise amount)] DATETIME, [Bank Name drawn on (Exercise amount)] VARCHAR (200)
		, [Cheque No (Perquisite tax)] VARCHAR (100), [Cheque Date (Perquisite tax)] DATETIME, [Bank Name drawn on (Perquisite tax)] VARCHAR (200), [CHEQUE_Bank_Address_Exercise_amount] VARCHAR (200)
		, [CHEQUE_Bank_Account_No_Exercise_amount] VARCHAR (50), [CHEQUE_ExAmtTypOfBnkAC] VARCHAR (150), [CHEQUE_Bank_Address_Perquisite_tax] VARCHAR (200)
		, [CHEQUE_Bank_Account_No_Perquisite_tax] VARCHAR (50), [CHEQUE_PeqTxTypOfBnkAC] VARCHAR (150), [Demand Draft  (DD) No (Exercise amount)] VARCHAR (100)
		, [DD Date (Exercise amount)] DATETIME, [(DD)Bank Name drawn on (Exercise amount)] VARCHAR (200), [Demand Draft  (DD) No (Perquisite tax)] VARCHAR (100)
		, [DD Date (Perquisite tax)] DATETIME, [(DD)Bank Name drawn on (Perquisite tax)] VARCHAR (200), [DD_Bank_Address_Exercise_amount] VARCHAR (200)
		, [DD_Bank_Account_No_Exercise_amount] VARCHAR (50), [DD_ExAmtTypOfBnkAC] VARCHAR (150), [DD_Bank_Address_Perquisite_tax] VARCHAR (200)
		, [DD_Bank_Account_No_Perquisite_tax] VARCHAR (50), [DD_PeqTxTypOfBnkAC] VARCHAR (150), [Wire Transfer No (Exercise amount)] VARCHAR (101)
		, [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] VARCHAR (101),[Bank Name transferred from (Exercise amount)] VARCHAR (200), [Bank Account No  (Exercise amount)] VARCHAR (51)
		, [Wire Transfer Date (Exercise amount)] DATETIME, [Wire Transfer Date (Perquisite tax)] DATETIME, [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] VARCHAR (101)
		, [Bank Name transferred from (Perquisite tax)] VARCHAR (200), [Bank Address (Perquisite tax)] VARCHAR (200), [Bank Account No  (Perquisite tax)] VARCHAR (51)
		, [WT_Bank_Address_Exercise_amount] VARCHAR (200), [WT_Bank_Account_No_Exercise_amount] VARCHAR (50), [WT_ExAmtTypOfBnkAC] VARCHAR (150)
		, [WT_Bank_Address_Perquisite_tax] VARCHAR (200), [WT_Bank_Account_No_Perquisite_tax] VARCHAR (50), [WT_PeqTxTypOfBnkAC] VARCHAR (150)
		, [RTGS/NEFT No (Exercise amount)] VARCHAR (101), [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)] VARCHAR (200), [(RTGS/NEFT No) Bank Account No  (Exercise amount)] VARCHAR (51)
		, [(RTGS/NEFT No)Payment Date (Exercise amount)] DATETIME,[RTGS/NEFT No (Perquisite tax)] VARCHAR (101), [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)] VARCHAR (200)
		, [(RTGS/NEFT No)Bank Address (Perquisite tax)] VARCHAR (200), [(RTGS/NEFT No) Bank Account No  (Perquisite tax)] VARCHAR (51), [(RTGS/NEFT No) Payment Date (Perquisite tax)] DATETIME
		, [RTGS_Bank_Address_Exercise_amount] VARCHAR (200), [RTGS_Bank_Account_No_Exercise_amount] VARCHAR (50), [RTGS_ExAmtTypOfBnkAC] VARCHAR (150)
		, [RTGS_Bank_Address_Perquisite_tax] VARCHAR (200), [RTGS_Bank_Account No_Perquisite_tax] VARCHAR (50), [RTGS_PeqTxTypOfBnkAC] VARCHAR (150)
		, [Transaction ID] VARCHAR (101), [Bank Name transferred from] VARCHAR (100), [UTRNo] VARCHAR (30), [Bank Account No] INT, [Payment Date] DATETIME
		, [Account number] VARCHAR (20), ConfStatus CHAR (1), DateOfJoining DATETIME, DateOfTermination DATETIME, Department VARCHAR (200)
		, EmployeeDesignation VARCHAR (200), Entity VARCHAR (200), Grade VARCHAR (200), Insider CHAR (1), ReasonForTermination VARCHAR (50), SBU VARCHAR (200),[Entity as on Date of Grant] VARCHAR(100),[Entity as on Date of Exercise] VARCHAR(100)
		)
	END

	--EXECUTE('USE TestDestination') at [10.10.60.54]
EXECUTE(' USE [' +@DBName + ']
			IF(OBJECT_ID(N''dbo.GrantConsolidatedReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[GrantConsolidatedReport]
				(
					SchemeName                  NVARCHAR(150),	GrantRegistrationId         NVARCHAR(150),	GrantDate                   DATETIME,
					ExercisePrice               NUMERIC(10,2),	ParentNote                  NVARCHAR(10),	OptionsGranted              NUMERIC(18,0),
					OptionsVested               NUMERIC(18,0),	OptionsUnVested             NUMERIC(18,0),	OptionsExercised            NUMERIC(18,0),
					OptionsCancelled            NUMERIC(18,0),	OptionsLapsed               NUMERIC(18,0),	FromDate                    DATETIME,
					ToDate                      DATETIME,		PushDate                    DATETIME
				)
			END
			IF(OBJECT_ID(N''dbo.GrantSummaryReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[GrantSummaryReport]
				(
					SchemeName                  NVARCHAR(150),	GrantRegistrationId         NVARCHAR(150),	EmployeeId                  NVARCHAR(150),
					EmployeeName                NVARCHAR(250),	GrantOptionId               NVARCHAR(100),	ParentNote                  NVARCHAR(10),
					GrantDate                   DATETIME,		ExercisePrice               NUMERIC(10,2),	Status                      NVARCHAR(100),
					OptionsGranted              NUMERIC(18,0),
					OptionsVested               NUMERIC(18,0),
					OptionsUnVested             NUMERIC(18,0),
					OptionsExercised            NUMERIC(18,0),
					OptionsCancelled            NUMERIC(18,0),
					OptionsLapsed               NUMERIC(18,0),
					SBU                         NVARCHAR(100),
					Entity                      NVARCHAR(100),
					AccountNo                   NVARCHAR(100),  
					FromDate                    DATETIME,
					ToDate                      DATETIME,
					PushDate                    DATETIME
				)
			END

			IF(OBJECT_ID(N''dbo.VestWiseReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[VestWiseReport]
				(
					SchemeName                  NVARCHAR(150),
					EmployeeId                  NVARCHAR(150),
					EmployeeName                NVARCHAR(250),
					Status                      NVARCHAR(100),
					GrantDate                   DATETIME,
					GrantLegId                  NUMERIC(18,0),
					GrantRegistrationId         NVARCHAR(150),
					GrantOptionId               NVARCHAR(100),
					ParentNote                  NVARCHAR(10),
					OptionsGranted              NUMERIC(18,0),
					VestingType                 NVARCHAR(100),
					VestingDate                 DATETIME,
					ExpiryDate                  DATETIME,
					ExercisePrice               NUMERIC(10,2),
					OptionsVested               NUMERIC(18,0),
					PendingForApproval          NUMERIC(18,0),
					OptionsUnVested             NUMERIC(18,0),
					OptionsExercised            NUMERIC(18,0),
					OptionsCancelled            NUMERIC(18,0),
					OptionsLapsed               NUMERIC(18,0),
					UnvestedCancelled           NUMERIC(18,2),
					VestedCancelled             NUMERIC(18,2),  
					FromDate                    DATETIME,
					ToDate                      DATETIME,
					PushDate                    DATETIME
				)
			END

			IF(OBJECT_ID(N''dbo.ExerciseReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[ExerciseReport]
				(
					EmployeeID	                VARCHAR(20),
					Instrument_Name	            VARCHAR(500),
					CountryName	                VARCHAR(50),
					ExercisePrice	            NUMERIC(10,2),
					CurrencyName	            VARCHAR(50),
					SharesArised	            NUMERIC(18,0),
					SARExerciseAmount           NUMERIC(18,6),
					ExercisedId	                NUMERIC(18,0),
					EmployeeName	            VARCHAR(100),
					GrantRegistrationId	        VARCHAR(20),
					GrantoptionId	            VARCHAR(100),
					GrantDate	                DATETIME,
					ExercisedQuantity           NUMERIC(18,0),
					SharesAlloted	            NUMERIC(18,0),
					ExercisedDate	            DATETIME,
					ExercisedPrice	            NUMERIC(10,2),
					SchemeTitle	                VARCHAR(50),
					OptionRatioMultiplier       NUMERIC(18,0),
					schemeid	                VARCHAR(50),
					OptionRatioDivisor	        NUMERIC(18,0),
					SharesIssuedDate	        DATETIME,
					DateOfPayment	            DATETIME,
					Parent	                    CHAR(20),
					VestingDate	                DATETIME,
					GrantLegId	                DECIMAL(10,0),
					FBTValue	                NUMERIC(10,2),
					Cash	                    VARCHAR(50),
					SAR_PerqValue	            NUMERIC(18,2),
					FaceValue	                NUMERIC(18,2),
					FACE_VALUE	                NUMERIC(18,2),
					PerqstValue	                NUMERIC(18,6),
					PerqstPayable	            NUMERIC(18,6),
					FMVPrice	                NUMERIC(18,6),
					FBTdays	                    INT,
					TravelDays	                INT	,
					PaymentMode	                VARCHAR(50),
					PerqTaxRate	                NUMERIC(18,6),
					ExerciseNo	                NUMERIC(18,0),
					Exercise_Amount	            NUMERIC(18,6),
					Date_of_Payment	            DATETIME,
					AccountNumber	            VARCHAR(20),
					ConfStatus	                CHAR(10),
					DateOfJoining	            DATETIME,
					DateOfTermination	        DATETIME,
					Department	                VARCHAR(200),
					EmployeeDesignation	        VARCHAR(200),
					Entity	                    VARCHAR(200),
					Grade	                    VARCHAR(200),
					Insider	                    CHAR(1),
					ReasonForTermination        VARCHAR(200),
					SBU	                        VARCHAR(200),
					ResidentialStatus	        VARCHAR(100),
					Itcircle_WardNumber	        VARCHAR(15),
					DepositoryName	            VARCHAR(200),
					DepositoryParticipatoryName	VARCHAR(200),
					ConfirmationDate	        DATETIME,
					NameasPerDPRecord	        VARCHAR(50),
					EmployeeAddress	            VARCHAR(500),
					EmployeeEmail	            VARCHAR(500),
					EmployeePhone	            VARCHAR(20),
					Pan_GirNumber	            VARCHAR(20),
					DematacType	                VARCHAR(20),
					DPPdNumber	                VARCHAR(20),
					ClientIdNumber	            VARCHAR(20),
					Location	                VARCHAR(200),
					LotNumber	                VARCHAR(20),
					CurrencyAlias	            VARCHAR(50),
					MIT_ID	                    INT,
					SettlmentPrice	            NUMERIC(18,6),
					StockApprValue	            NUMERIC(18,6),
					CashPayoutValue          	NUMERIC(18,6),
					ShareAriseApprValue	        NUMERIC(18,6),
					LWD	                        DATETIME,
					COST_CENTER	                VARCHAR(200),
					Status	                    VARCHAR(10),
					BROKER_DEP_TRUST_CMP_ID	    VARCHAR(200),
					BROKER_DEP_TRUST_CMP_NAME	VARCHAR(200),
					BROKER_ELECT_ACC_NUM	    VARCHAR(200),
					Country	                    VARCHAR(50),
					State	                    VARCHAR(100),
					EquivalentShares	        NUMERIC(18,0),  
					FromDate                    DATETIME,
					ToDate                      DATETIME,
					PushDate                    DATETIME	
				)
			END

			IF(OBJECT_ID(N''dbo.PersonalStatusReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[PersonalStatusReport]
				(
					EMPLOYEEID	              VARCHAR(20),
					LOGINID	                  VARCHAR(20),
					EMPLOYEENAME	          VARCHAR(75),
				    SecondaryEmailID	      VARCHAR(500),
					Mobile	                  VARCHAR(20),
					State	                  VARCHAR(100),
					Nationality	              VARCHAR(100),
					confirmn_Dt	              DATETIME,
					COUNTRYNAME	              VARCHAR(50),
					EMPLOYEEDESIGNATION	      VARCHAR(200),
					EMPLOYEEEMAIL	          VARCHAR(500),
					DATEOFJOINING	          DATETIME,
					GRADE	                  VARCHAR(200),
					LOCATION	              VARCHAR(200),
					Status	                  VARCHAR(10),
					DATEOFTERMINATION      	  DATETIME,
					ResidentialStatus	      VARCHAR(50),---
					SBU	                      VARCHAR(200),
					ENTITY	                  VARCHAR(200),
					ACCOUNTNO	              VARCHAR(20),
					DEPARTMENT	              VARCHAR(200),
					PANNUMBER	              VARCHAR(15),--
					DEPOSITORYPARTICIPANTNO	  VARCHAR(150),
					DEPOSITORYNAME	          VARCHAR(20),
					DEPOSITORYIDNUMBER	      VARCHAR(50),
					CONFSTATUS	              CHAR(1),
					CLIENTIDNUMBER	          VARCHAR(20),
					WARDNUMBER	              VARCHAR(15),
					EMPLOYEEADDRESS	          VARCHAR(500),
					EMPLOYEEPHONE	          VARCHAR(20),
					Insider	                  CHAR(2),
					DematAccountType	      VARCHAR(15),
					LWD	                      DATETIME,
					DPRECORD	              VARCHAR(50),
					REASONFORTERMINATION	  VARCHAR(20),
					BROKER_DEP_TRUST_CMP_NAME VARCHAR(200),
					BROKER_DEP_TRUST_CMP_ID	  VARCHAR(200),
					BROKER_ELECT_ACC_NUM	  VARCHAR(200),
					COST_CENTER	              VARCHAR(200),  
					PushDate                  DATETIME	
				)
			END
    
			IF(OBJECT_ID(N''dbo.CancellationData'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE CancellationData
				(
					Expr1                 NUMERIC(18,0),
					GrantOptionId         VARCHAR(100),
					INSTRUMENT_NAME       NVARCHAR(500),
					ExercisePrice         NUMERIC(18,2),
					CurrencyName          VARCHAR(50),
					CurrencyAlias         VARCHAR(50),
					GrantDate             DATETIME,
					VestID                DECIMAL(10,0),
					VestingDate           DATETIME,
					FinalVestingDate      DATETIME,
					FinalExpirayDate      DATETIME,
					ExpirayDate           DATETIME,	
					CancelledDate         DATETIME,
					Expr2                 VARCHAR(100),
					EmployeeID            VARCHAR(20),
					EmployeeName          VARCHAR(75),
					DateOfTermination     DATETIME,
					SchemeTitle           VARCHAR(50),
					GrantRegistrationId   VARCHAR(20),
					OptionRatioDivisor    NUMERIC(18,0),
					OptionRatioMultiplier NUMERIC(18,0),
					GrantLegSerialNumber  NUMERIC(18,0),
					CancelledQuantity     NUMERIC(18,0),
					CancellationReason    VARCHAR(100),
					Status                VARCHAR(50),
					VestedUnVested        VARCHAR(50),
					OptionsCancelled      NUMERIC(18,0),
					Flag                  CHAR(1),
					Note                  VARCHAR(100),  
					FromDate              DATETIME,
					ToDate                DATETIME,
					PushDate              DATETIME
				)
			END
		
			IF(OBJECT_ID(N''dbo.LapseData'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE LapseData
				(
					MIT_ID				BIGINT,
					INSTRUMENT_NAME		VARCHAR(500),
					CurrencyAlias		VARCHAR(50),	
					VestingPeriodId		NUMERIC(18,0),	
					VestingDate			DATETIME,
					SchemeTitle			VARCHAR(50),	
					GrantDate			DATETIME,	
					GrantRegistration	VARCHAR(20),
					ExercisePrice		NUMERIC(18,2),
					EmployeeId			VARCHAR(20),
					EmployeeName		VARCHAR(75),
					GrantOpId			VARCHAR(100),
					STATUS				VARCHAR(50),
					ExpiryDate			DATETIME,
					OptionsLapsed		NUMERIC(18,0),
					parent				VARCHAR(10),
					CSFlag				CHAR(1),
					FromDate            DATETIME,
					ToDate              DATETIME,
					PushDate            DATETIME
				)
			END

			IF(OBJECT_ID(N''dbo.PoolBalance'', N''U'') IS NULL)
			BEGIN
				Create Table PoolBalance
				(
					SCHEMEID           VARCHAR(50),
					SCHEMETITLE        VARCHAR(50),
					ApprovalId        VARCHAR(20),
					NOOFOPTIONSGRANTED NUMERIC(18,0),
					EXERCISEDQUANTITY  NUMERIC(18,0),
					SHAREISSUE         NUMERIC(18,6),
					MIT_ID             BIGINT,
					IS_INSTRUMENT      INT,  
					PushDate           DATETIME
				)
			END

			IF(OBJECT_ID(N''dbo.ShareHolderApprovalData'', N''U'') IS NULL)
			BEGIN
				Create Table ShareHolderApprovalData
				(
					ApprovalId        VARCHAR(20),
					ApprovalDate	   DATETIME,
					NumberOfShares	   NUMERIC(18,0),
					AvailableShares    NUMERIC(18,0),
					AdditionalShares   NUMERIC(18,0),
					PushDate           DATETIME
				)
			END
      
			IF(OBJECT_ID(N''dbo.SchemeParameters'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE dbo.SchemeParameters
				(
					ApprovalId                VARCHAR(20),
					SchemeId                  VARCHAR(50),
					Status                    VARCHAR(1),
					SchemeTitle               VARCHAR(50),
					AdjustResidueOptionsIn    VARCHAR(1),
					VestingOverPeriodOffset   NUMERIC(18, 0),
					VestingStartOffset        NUMERIC(18, 0),
					VestingFrequency          NUMERIC(18, 0),
					LockInPeriod              NUMERIC(18, 0),
					LockInPeriodStartsFrom    VARCHAR(1),
					OptionRatioMultiplier     NUMERIC(18, 0),
					OptionRatioDivisor        NUMERIC(18, 0),
					ExercisePeriodOffset      NUMERIC(18, 0),
					ExercisePeriodStartsAfter VARCHAR(1),
					PeriodUnit                CHAR(1),
					LastUpdatedBy             VARCHAR(20),
					LastUpdatedOn             DATETIME,
					TrustType                 CHAR(10),
					IsPaymentModeRequired     TINYINT,
					PaymentModeEffectiveDate  DATE,
					UnVestedCancelledOptions  VARCHAR(1),
					VestedCancelledOptions    VARCHAR(1),
					LapsedOptions             VARCHAR(1),
					IsPUPEnabled              BIT,
					DisplayExPrice            BIT,
					DisplayExpDate            BIT,
					DisplayPerqVal            BIT,
					DisplayPerqTax            BIT,
					PUPEXEDPAYOUTPROCESS      BIT,
					PUPFORMULAID              INT,
					IS_ADS_SCHEME             BIT,
					IS_ADS_EX_OPTS_ALLOWED    BIT,
					MIT_ID                    INT,
					IS_AUTO_EXERCISE_ALLOWED  CHAR(1),
					CALCULATE_TAX             NVARCHAR(200),
					CALCUALTE_TAX_PRIOR_DAYS  INT,
					ROUNDING_UP               TINYINT,
					FRACTION_PAID_CASH        TINYINT,  
					PushDate                  DATETIME
				)
			END
      
			IF(OBJECT_ID(N''dbo.LinkedGrantRegistration'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].LinkedGrantRegistration
				(
					ApprovalId                 VARCHAR(20),
					SchemeId                   VARCHAR(50),
					GrantApprovalId            VARCHAR(20),
					GrantRegistrationId        VARCHAR(20),
					ApprovalStatus             VARCHAR(1),
					GrantDate                  DATETIME,
					ExercisePrice              NUMERIC(18, 2),
					IsPerformanceBasedIncluded CHAR(10),
					LastUpdatedBy              VARCHAR(20),
					LastUpdatedOn              DATETIME,
					Apply_SAR                  CHAR(1),
					Merchant_Code              VARCHAR(50),
					Contributiion_Frequency    VARCHAR(50),
					ContriBution_Period        INT,
					MinContriAmt               DECIMAL(18, 2),
					MaxContAmt                 DECIMAL(18, 2),
					ContributionMultiples      DECIMAL(18, 0),
					StartDate                  DATETIME,
					LastDate                   DATETIME,
					BankIntRate                DECIMAL(18, 2),
					IntrestAmtCalcAs           VARCHAR(50),
					FirstMailFre               INT,
					RemMailFre                 INT,
					NonPayAllow                INT,
					EmailRemXDays              INT,
					EmailCompCR                VARCHAR(50),
					SpecificDate               DATETIME,
					CompoundIntFreq            VARCHAR(50),
					AccountType                VARCHAR(50),
					Apply_SAYE                 CHAR(10),
					ContristartDate            DATETIME,
					SARS_PRICE                 NVARCHAR(50),
					ExercisePriceINR           NUMERIC(18, 2),  
					PushDate                   DATETIME
				)
			END
      
			IF(OBJECT_ID(N''dbo.LinkedVestingPeriod'', N''U'') IS NULL)
			BEGIN
				Create Table LinkedVestingPeriod
				(
					ApprovalId                       VARCHAR(20),
					SchemeId                         VARCHAR(50),
					GrantApprovalId                  VARCHAR(20),
					GrantRegistrationId              VARCHAR(20),
					VestingPeriodId                  NUMERIC(18, 0),
					VestingDate                      DATETIME,
					ExpiryDate                       DATETIME,
					VestingType                      CHAR(1),
					OptionTimePercentage             NUMERIC(5, 2),
					OptionPerformancePercentage      NUMERIC(5, 2),
					VestingPeriodNo                  NUMERIC(18, 0),
					LastUpdatedBy                    VARCHAR(20),
					LastUpdatedOn                    DATETIME,
					FBTValue                         NUMERIC(10, 2),
					AdjustResidueInTimeOrPerformance CHAR(1),  
					PushDate                         DATETIME
				)
			END
			
			IF(OBJECT_ID(N''dbo.LinkedFMVForUnlisted'', N''U'') IS NULL)
			BEGIN
				Create Table LinkedFMVForUnlisted
				(
					FMV          NUMERIC(18, 2),
					FMV_FromDate DATETIME,
					FMV_Todate   DATETIME,
					CreatedBy    NVARCHAR(50),
					Updatedon    DATETIME,  
					PushDate     DATETIME
				)
			END
			IF(OBJECT_ID(N''dbo.LinkedFMVSharePrices'', N''U'') IS NULL)
			BEGIN
				  CREATE TABLE LinkedFMVSharePrices
				  (
					FMVPriceID numeric(18, 0),
					StockExchange char(1),
					StockExchangeCode varchar(max),
					TransactionDate datetime,
					OpenPrice numeric(18, 2),
					HighPrice numeric(18, 2),
					LowPrice numeric(18, 2),
					PriceDate datetime,
					ClosePrice numeric(18, 2),
					Volume numeric(18, 2),
					LastUpdatedBy varchar(20),
					LastUpdatedOn datetime,
					PushDate datetime
					)
			END

			IF(OBJECT_ID(N''dbo.LinkedSharePrices'', N''U'') IS NULL)
			BEGIN
				Create Table LinkedSharePrices
				(
					PriceID           NUMERIC(18, 0),
					StockExchangeCode VARCHAR(max),
					TransactionDate   DATETIME,
					OpenPrice         NUMERIC(18, 2),
					HighPrice         NUMERIC(18, 2),
					LowPrice          NUMERIC(18, 2),
					PriceDate         DATETIME,
					ClosePrice        NUMERIC(18, 2),
					LastUpdatedBy     VARCHAR(20),
					LastUpdatedOn     DATETIME,  
					PushDate          DATETIME
				)
			END
				
			IF(OBJECT_ID(N''dbo.LinkedBonus'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE dbo.LinkedBonus
				(
					BonusId         VARCHAR(60),
					Note            VARCHAR(100),
					RatioMultiplier NUMERIC(18, 0),
					RatioDivisor    NUMERIC(18, 0),
					BonusGrantDate  DATETIME,
					ApplicableFor   VARCHAR(1),
					LastUpdatedBy   VARCHAR(20),
					LastUpdatedOn   DATETIME,
					Status          CHAR(1),  
					PushDate        DATETIME
				)
			END

			IF(OBJECT_ID(N''dbo.LinkedSplit'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE dbo.LinkedSplit
				(
					SplitId               VARCHAR(60),
					ApprovalStatus        VARCHAR(1),
					Note                  VARCHAR(100),
					RatioMultiplier       NUMERIC(18, 0),
					RatioDivisor          NUMERIC(18, 0),
					SplitDate             DATETIME,
					SplitFactor           NUMERIC(10, 2),
					Status                CHAR(1),
					ApplicableFor         VARCHAR(1),
					LastUpdatedBy         VARCHAR(20),
					LastUpdatedOn         DATETIME,
					ApplySplitToAll       CHAR(1),
					ApplySplitToVested    CHAR(1),
					ApplySplitToUnvested  CHAR(1),
					ApplySplitToExercised CHAR(1),
					ApplySplitToLapsed    CHAR(1),
					ApplySplitToCancelled CHAR(1),
					Approved              CHAR(1),  
					PushDate              DATETIME
				)
			END
			IF(OBJECT_ID(N''dbo.OnlineTransactionReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE OnlineTransactionReport 
				(
				[Exercise number/Application number]                         NUMERIC (18, 0),
				[Exercise ID]                                                NUMERIC (18, 0),
				[Employee ID]                                                NVARCHAR (500) ,
				[Employee Name]                                              VARCHAR (75)   ,
				[Country]                                                    VARCHAR (50)   ,
				[Scheme Name]                                                VARCHAR (50)   ,
				[Grant Registration ID]                                      VARCHAR (20)   ,
				[Grant Date]                                                 DATETIME       ,
				[Grant Option ID]                                            VARCHAR (100)  ,
				[Options Exercised]                                          NUMERIC (18, 0),
				[Exercise Price]                                             NUMERIC (18, 2),
				[Amount Paid]                                                NUMERIC (37, 2),
				[Exercise Date]                                              DATETIME       ,
				fmv                                                          NUMERIC (18, 2),
				[Perquiste Value]                                            NUMERIC (18, 2),
				[Perquisite Tax payable]                                     NUMERIC (18, 2),
				[Perq_Tax_rate]                                              NUMERIC (18, 6),
				[Equivalent Exercise Quantity]                               NUMERIC (38, 0),
				[Grant vest period id]                                       DECIMAL (10, 0),
				[Vesting Date]                                               DATETIME       ,
				[Payment mode]                                               VARCHAR (20)   ,
				PaymentMode                                                  VARCHAR (1)    ,
				lotnumber                                                    VARCHAR (20)   ,
				validationstatus                                             VARCHAR (1)    ,
				revarsalreason                                               VARCHAR (1)    ,
				receiveddate                                                 DATETIME       ,
				exerciseformreceived                                         VARCHAR (10)   ,
				exformreceivedstatus                                         VARCHAR (3)    ,
				IsPaymentDeposited                                           BIT            ,
				PaymentDepositedDate                                         DATETIME       ,
				IsPaymentConfirmed                                           BIT            ,
				PaymentConfirmedDate                                         DATETIME       ,
				IsExerciseAllotted                                           BIT            ,
				ExerciseAllotedDate                                          DATETIME       ,
				IsAllotmentGenerated                                         BIT            ,
				AllotmentGenerateDate                                        DATETIME       ,
				IsAllotmentGeneratedReversed                                 BIT            ,
				AllotmentGeneratedReversedDate                               DATETIME       ,
				MIT_ID                                                       INT            ,
				[INSTRUMENT_NAME]                                            NVARCHAR (500) ,
				[Name as in Depository Participant (DP) records]             VARCHAR (50)   ,
				[Name of Depository]                                         VARCHAR (200)  ,
				[Demat A/C Type]                                             VARCHAR (50)   ,
				[Name of Depository Participant (DP)]                        VARCHAR (200)  ,
				[Depository ID]                                              VARCHAR (50)   ,
				[Client ID]                                                  TEXT           ,
				pan                                                          VARCHAR (50)   ,
				[Residential Status]                                         VARCHAR (16)   ,
				nationality                                                  VARCHAR (100)  ,
				location                                                     VARCHAR (200)  ,
				[Mobile Number]                                              VARCHAR (51)   ,
				[Broker Company Name]                                        VARCHAR (200)  ,
				[Broker Company Id]                                          VARCHAR (200)  ,
				[Broker Electronic Account Number]                           VARCHAR (200)  ,
				[Email Address]                                              VARCHAR (500)  ,
				[Employee Address]                                           VARCHAR (500)  ,
				[Cheque No (Exercise amount)]                                VARCHAR (100)  ,
				[Cheque Date (Exercise amount)]                              DATETIME       ,
				[Bank Name drawn on (Exercise amount)]                       VARCHAR (200)  ,
				[Cheque No (Perquisite tax)]                                 VARCHAR (100)  ,
				[Cheque Date (Perquisite tax)]                               DATETIME       ,
				[Bank Name drawn on (Perquisite tax)]                        VARCHAR (200)  ,
				[CHEQUE_Bank_Address_Exercise_amount]                        VARCHAR (200)  ,
				[CHEQUE_Bank_Account_No_Exercise_amount]                     VARCHAR (50)   ,
				[CHEQUE_ExAmtTypOfBnkAC]                                     VARCHAR (150)  ,
				[CHEQUE_Bank_Address_Perquisite_tax]                         VARCHAR (200)  ,
				[CHEQUE_Bank_Account_No_Perquisite_tax]                      VARCHAR (50)   ,
				[CHEQUE_PeqTxTypOfBnkAC]                                     VARCHAR (150)  ,
				[Demand Draft  (DD) No (Exercise amount)]                    VARCHAR (100)  ,
				[DD Date (Exercise amount)]                                  DATETIME       ,
				[(DD)Bank Name drawn on (Exercise amount)]                   VARCHAR (200)  ,
				[Demand Draft  (DD) No (Perquisite tax)]                     VARCHAR (100)  ,
				[DD Date (Perquisite tax)]                                   DATETIME       ,
				[(DD)Bank Name drawn on (Perquisite tax)]                    VARCHAR (200)  ,
				[DD_Bank_Address_Exercise_amount]                            VARCHAR (200)  ,
				[DD_Bank_Account_No_Exercise_amount]                         VARCHAR (50)   ,
				[DD_ExAmtTypOfBnkAC]                                         VARCHAR (150)  ,
				[DD_Bank_Address_Perquisite_tax]                             VARCHAR (200)  ,
				[DD_Bank_Account_No_Perquisite_tax]                          VARCHAR (50)   ,
				[DD_PeqTxTypOfBnkAC]                                         VARCHAR (150)  ,
				[Wire Transfer No (Exercise amount)]                         VARCHAR (101)  ,
				[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)]          VARCHAR (101)  ,
				[Bank Name transferred from (Exercise amount)]               VARCHAR (200)  ,
				[Bank Account No  (Exercise amount)]                         VARCHAR (51)   ,
				[Wire Transfer Date (Exercise amount)]                       DATETIME       ,
				[Wire Transfer Date (Perquisite tax)]                        DATETIME       ,
				[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)]           VARCHAR (101)  ,
				[Bank Name transferred from (Perquisite tax)]                VARCHAR (200)  ,
				[Bank Address (Perquisite tax)]                              VARCHAR (200)  ,
				[Bank Account No  (Perquisite tax)]                          VARCHAR (51)   ,
				[WT_Bank_Address_Exercise_amount]                            VARCHAR (200)  ,
				[WT_Bank_Account_No_Exercise_amount]                         VARCHAR (50)   ,
				[WT_ExAmtTypOfBnkAC]                                         VARCHAR (150)  ,
				[WT_Bank_Address_Perquisite_tax]                             VARCHAR (200)  ,
				[WT_Bank_Account_No_Perquisite_tax]                          VARCHAR (50)   ,
				[WT_PeqTxTypOfBnkAC]                                         VARCHAR (150)  ,
				[RTGS/NEFT No (Exercise amount)]                             VARCHAR (101)  ,
				[(RTGS/NEFT No)Bank Name transferred from (Exercise amount)] VARCHAR (200)  ,
				[(RTGS/NEFT No) Bank Account No  (Exercise amount)]          VARCHAR (51)   ,
				[(RTGS/NEFT No)Payment Date (Exercise amount)]               DATETIME       ,
				[RTGS/NEFT No (Perquisite tax)]                              VARCHAR (101)  ,
				[(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)]  VARCHAR (200)  ,
				[(RTGS/NEFT No)Bank Address (Perquisite tax)]                VARCHAR (200)  ,
				[(RTGS/NEFT No) Bank Account No  (Perquisite tax)]           VARCHAR (51)   ,
				[(RTGS/NEFT No) Payment Date (Perquisite tax)]               DATETIME       ,
				[RTGS_Bank_Address_Exercise_amount]                          VARCHAR (200)  ,
				[RTGS_Bank_Account_No_Exercise_amount]                       VARCHAR (50)   ,
				[RTGS_ExAmtTypOfBnkAC]                                       VARCHAR (150)  ,
				[RTGS_Bank_Address_Perquisite_tax]                           VARCHAR (200)  ,
				[RTGS_Bank_Account No_Perquisite_tax]                        VARCHAR (50)   ,
				[RTGS_PeqTxTypOfBnkAC]                                       VARCHAR (150)  ,
				[Transaction ID]                                             VARCHAR (101)  ,
				[Bank Name transferred from]                                 VARCHAR (100)  ,
				[UTRNo]                                                      VARCHAR (30)   ,
				[Bank Account No]                                            INT            ,
				[Payment Date]                                               DATETIME       ,
				[Account number]                                             VARCHAR (20)   ,
				ConfStatus                                                   CHAR (1)       ,
				DateOfJoining                                                DATETIME       ,
				DateOfTermination                                            DATETIME       ,
				Department                                                   VARCHAR (200)  ,
				EmployeeDesignation                                          VARCHAR (200)  ,
				Entity                                                       VARCHAR (200)  ,
				Grade                                                        VARCHAR (200)  ,
				Insider                                                      CHAR (1)       ,
				ReasonForTermination                                         VARCHAR (50)   ,
				SBU                                                          VARCHAR (200)  ,
				[Entity as on Date of Grant]                                 VARCHAR (100)  ,
				[Entity as on Date of Exercise]                              VARCHAR (100)  ,
				[PushDate]													 DATETIME
			)
		END
		IF(OBJECT_ID(N''dbo.LinkedShareRegister'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE LinkedShareRegister
			(
				ShareRegisterID int,
				TrustID int,
				ClientId varchar(20),
				DateOfTransaction datetime,
				Particular varchar(max),
				NumberOfShares bigint,
				ClosingBalance decimal(26, 2),
				TypeOfTransaction varchar(50),
				Comments varchar(50),
				ActiveStatus bit,
				DeleteStatus bit,
				CreatedOn datetime,
				CreatedBy varchar(50),
				ModifiedOn datetime,
				ModifiedBy varchar(50),
				PushDate datetime
			)
		END
		IF(OBJECT_ID(N''dbo.LinkedSubShareRegMaster'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE LinkedSubShareRegMaster
			(
				SubShareRegID int,
				RegID varchar(100),
				SeqID int,
				CompanyID varchar(100),
				SchemeID varchar(100),
				GrantRegID varchar(100),
				ExercisePrice decimal(18, 2),
				ClosingBal bigint,
				CreatedOn datetime,
				CreatedBy varchar(100),
				InstrumentTypeID int,
				SelectionFilter char(1),
				PushDate datetime
			)
		END
		IF(OBJECT_ID(N''dbo.UserLoginHistoryReport'', N''U'') IS NULL)
			BEGIN
				CREATE TABLE [dbo].[UserLoginHistoryReport]
				(
					SN							VARCHAR(256),
					UserId						VARCHAR(20),
					LoginDate					DATETIME,
					LogOutDate					DATETIME,
					FromDate                    DATETIME,
					ToDate                      DATETIME,
					PushDate                    DATETIME
				)
		END
		IF(OBJECT_ID(N''dbo.GrantAccMassUploadMaster'', N''U'') IS NULL)
		BEGIN
				CREATE TABLE [dbo].[GrantAccMassUploadMaster]
				(
						GAMUID [int],
						[EmployeeID] [varchar](50),
						[SchemeName] [varchar](100),
						[LetterCode] [varchar](100),
						[GrantDate] [datetime],
						[GrantType] [varchar](100),
						[NoOfOptions] [numeric](18, 0),
						[Currency] [varchar](50) NULL,
						[ExercisePrice] [numeric](18, 2),
						[FirstVestDate] [datetime],
						[NoOfVests] [numeric](18, 0),
						[VestingFrequency] [numeric](18, 0),
						[VestingPercentage] [varchar](100),
						[Adjustment] [char](1),
						[CompanyName] [varchar](100),
						[CompanyAddress] [varchar](500),
						[LotNumber] [varchar](10),
						[LastAcceptanceDate] [datetime],
						[LetterAcceptanceStatus] [char](1),
						[LetterAcceptanceDate] [datetime],
						[GrantLetterName] [varchar](100),
						PushDate                    DATETIME
				)
		END

		IF(OBJECT_ID(N''dbo.GrantAccMassUploadDetails'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE [dbo].[GrantAccMassUploadDetails]
			(
				GAMUID [int],
				[LetterCode] [varchar](100),
				[VestPeriod] [int],
				[VestingDate] [datetime],
				[NoOfOptions] [numeric](18, 0),
				PushDate                    DATETIME
			)
		END
		IF(OBJECT_ID(N''dbo.MobilityData'', N''U'') IS NULL)
		BEGIN
		CREATE TABLE [dbo].[MobilityData]
		(
					[SRNO] [int],
					[Field] [nvarchar](200),
					[EmployeeId] [nvarchar](200),
					[EmployeeName] [nvarchar](200),
					[Status] [nvarchar](200),
					[CurrentDetails] [nvarchar](200),
					[FromDate] [date],
					[Moved To] [nvarchar](200),
					[From Date of Movement] [date],
					PushDate                DATETIME
		) 
		END
		--IF(OBJECT_ID(N''dbo.FairValueCalculation'', N''U'') IS NULL)
		--BEGIN
		--		CREATE TABLE [dbo].[FairValueCalculation]
		--		(
		--			[AGRMID] [int],
		--			[GRS_GRANT_REGISTRATION_ID] [varchar](50),
		--			[GRS_GRANT_DATE] [datetime],
		--			[GRS_EXERCISE_PRICE] [numeric](9, 2),
		--			[PRICING_FORMULA] [varchar](50),
		--			[VESTING_TYPE] [char](1),
		--			[OPTION_FAIR_VALUE] [numeric](18, 9),
		--			[OPTION_INTRINSIC_VALUE] [numeric](18, 9),
		--			[MARKET_PRICE_FOR_FAIR_VALUE] [numeric](18, 9),
		--			[MARKET_PRICE_FOR_INTRINSIC_VALUE] [numeric](18, 9),
		--			[EXPECTED_LIFE] [numeric](18, 9),
		--			[VOLATILITY] [numeric](18, 9),
		--			[RISK_FREE_INTEREST_RATE] [numeric](18, 9),
		--			[DIVIDEND_YIELD] [numeric](18, 9),
		--			[DIVIDEND_YIELD_DIVD] [numeric](18, 9),
		--			[DIVIDEND_YIELD_MARKET_PRICE] [numeric](18, 9),
		--			PushDate                DATETIME
		--		)
		--END
		IF(OBJECT_ID(N''dbo.FairValueCalculation'', N''U'') IS NULL)
		BEGIN
					CREATE TABLE [dbo].[FairValueCalculation](
				[SCH_SCHEME_ID] [varchar](50),
				[SCH_SCHEME_TITLE] [varchar](50),
				[SCH_OPTION_RATIO_MULTIPLIER] [numeric](9, 2),
				[SCH_OPTION_RATIO_DIVISOR] [numeric](9, 2),
				[GRS_GRANT_REGISTRATION_ID] [varchar](50),
				[GRS_GRANT_DATE] [datetime],
				[GRS_EXERCISE_PRICE] [numeric](9, 2),
				[GRS_IS_PERFORMANCE_BASED_INCLUDED] [char](10),
				[VPD_VESTING_PERIOD_ID] [int],
				[VPD_VESTING_DATE] [datetime],
				[VPD_EXPIRY_DATE] [datetime],
				[VPD_VESTING_TYPE] [char](1),
				[VPD_OPTION_TIME_PERCENTAGE] [numeric](9, 2),
				[VPD_OPTION_PERFORMANCE_PERCENTAGE] [numeric](9, 2),
				[VPD_VESTING_PERIOD_NO] [int],
				[GOP_GRANT_OPTION_ID] [varchar](100),
				[GOP_GRANTED_OPTIONS] [numeric](9, 2),
				[GOP_EMPLOYEEID] [varchar](20),
				[EMP_EMPLOYEE_NAME] [varchar](100),
				[GL_ID] [bigint],
				[GL_GRANT_LEG_ID] [int],
				[GL_SPLIT_QUANTITY] [bigint],
				[GL_BONUS_SPLIT_QUANTITY] [bigint],
				[GL_ACC_VESTING_DATE] [datetime],
				[GL_ACC_EXPIRAY_DATE] [datetime],
				[GL_SEPERATION_VESTING_DATE] [datetime],
				[GL_SEPERATION_CANCELLATION_DATE] [datetime],
				[GL_FINAL_VESTING_DATE] [datetime],
				[GL_FINAL_EXPIRAY_DATE] [datetime],
				[GL_CANCELLATION_DATE] [datetime],
				[GL_CANCELLATION_REASON] [varchar](100),
				[GL_CANCELLED_QUANTITY] [bigint],
				[GL_SPLIT_CANCELLED_QUANTITY] [bigint],
				[GL_BONUS_SPLIT_CANCELLED_QUANTITY] [bigint],
				[GL_UNAPPROVED_EXERCISE_QUANTITY] [bigint],
				[GL_EXERCISED_QUANTITY] [bigint],
				[GL_SPLIT_EXERCISED_QUANTITY] [bigint],
				[GL_BONUS_SPLIT_EXERCISED_QUANTITY] [bigint],
				[GL_EXERCISABLE_QUANTITY] [bigint],
				[GL_UNVESTED_QUANTITY] [bigint],
				[GL_LAPSED_QUANTITY] [numeric](9, 2),
				[GL_IS_PERFBASED] [char](1),
				[GL_IS_ORIGINAL] [char](1),
				[GL_IS_BONUS] [char](1),
				[GL_IS_SPLIT] [char](1),
				[SETTLEMENT_OF_OPTIONS] [char](1),
				[PRICING_FORMULA] [varchar](50),
				[NO_OF_VESTS] [int],
				[VEST_PERCENT] [numeric](9, 2),
				[TIME_BASED_VEST_PERCENT] [numeric](9, 2),
				[PERFORMANCE_BASED_VEST_PERCENT] [numeric](9, 2),
				[VESTING_FEQUENCY] [char](1),
				[VESIING_FREQUENCY_VALUE] [numeric](9, 2),
				[VESTING_AFTER_1_YEAR] [bit],
				[EXERCISE_PERIOD] [numeric](9, 2),
				[EXERCISE_PERIOD_FREQ] [char](1),
				[EXERCISE_PERIOD_FROM] [char](1),
				[MULTIPLE_EXSERCISE_PERIOD] [bit],
				[MULT_EXERCISE_PERIOD_VALUE] [numeric](9, 2),
				[TRUST_ROUTE] [char](1),
				[RATIO_OPTION] [int],
				[RATIO_SHARE] [int],
				[MARKET_PRICE_PER_VEST] [numeric](18, 9),
				[MARKET_PRICE_IV] [numeric](18, 9),
				[EXPECTED_LIFE_PER_VEST] [numeric](18, 9),
				[VOLATILITY_PER_VEST] [numeric](18, 9),
				[RFIR_PER_VEST] [numeric](18, 9),
				[DIVIDEND_PER_VEST] [numeric](18, 9),
				[FAIR_VALUE_PER_VEST] [numeric](18, 9),
				[FV_INCREMENTAL] [numeric](18, 9),
				[INTRINSIC_VALUE_PER_VEST] [numeric](18, 9),
				[IV_INCREMENTAL] [numeric](18, 9),
				[DIVIDEND_YIELD_DIVD] [numeric](18, 9),
				[DIVIDEND_YIELD_MARKET_PRICE] [numeric](18, 9),
				[IS_MRKT_LINKED] [bit],
				[IS_MU_MKT_FV] [bit],
				[IS_MU_MKT_IV] [bit],
				PushDate DATETIME
			) 
		END
		IF(OBJECT_ID(N''dbo.LinkedGrantLeg'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE [dbo].[LinkedGrantLeg]
			(
				[ID] [numeric](18, 0),
				[ApprovalId] [varchar](20),
				[SchemeId] [varchar](50),
				[GrantApprovalId] [varchar](20),
				[GrantRegistrationId] [varchar](20),
				[GrantDistributionId] [varchar](20),
				[GrantOptionId] [varchar](100),
				[VestingPeriodId] [numeric](18, 0),
				[GrantDistributedLegId] [numeric](18, 0),
				[GrantLegId] [decimal](10, 0),
				[Counter] [numeric](18, 0),
				[VestingType] [char](1),
				[VestingDate] [datetime],
				[ExpirayDate] [datetime],
				[GrantedOptions] [numeric](18, 0),
				[GrantedQuantity] [numeric](18, 0),
				[SplitQuantity] [numeric](18, 0),
				[BonusSplitQuantity] [numeric](18, 0),
				[Parent] [char](1),
				[AcceleratedVestingDate] [datetime],
				[AcceleratedExpirayDate] [datetime],
				[SeperatingVestingDate] [datetime],
				[SeperationCancellationDate] [datetime],
				[FinalVestingDate] [datetime],
				[FinalExpirayDate] [datetime],
				[CancellationDate] [datetime],
				[CancellationReason] [varchar](100),
				[CancelledQuantity] [numeric](18, 0),
				[SplitCancelledQuantity] [numeric](18, 0),
				[BonusSplitCancelledQuantity] [numeric](18, 0),
				[UnapprovedExerciseQuantity] [numeric](18, 0),
				[ExercisedQuantity] [numeric](18, 0),
				[SplitExercisedQuantity] [numeric](18, 0),
				[BonusSplitExercisedQuantity] [numeric](18, 0),
				[ExercisableQuantity] [numeric](18, 0),
				[UnvestedQuantity] [numeric](18, 0),
				[Status] [char](1),
				[ParentID] [varchar](20),
				[LapsedQuantity] [numeric](18, 0),
				[IsPerfBased] [char](1),
				[SeparationPerformed] [char](1),
				[ExpiryPerformed] [char](1),
				[VestMailSent] [char](1),
				[ExpiredMailSent] [char](1),
				[LastUpdatedBy] [varchar](20),
				[LastUpdatedOn] [datetime],
				[IsOriginal] [char](1),
				[IsBonus] [char](1),
				[IsSplit] [char](1),
				[TEMPEXERCISABLEQUANTITY] [numeric](18, 0),
				[PerVestingQuantity] [numeric](18, 0),
				PushDate [Datetime]
			)
		END

		IF(OBJECT_ID(N''dbo.SchemeSeperationRule'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE [dbo].[SchemeSeparationRule]
			(
				[ApprovalId] [varchar](20),
				[SchemeId] [varchar](50),
				[SeperationRuleId] [numeric](18, 0),
				[VestedOptionsLiveFor] [numeric](18, 0),
				[IsVestingOfUnvestedOptions] [char](1),
				[UnvestedOptionsLiveFor] [numeric](18, 0),
				[VestedOptionsLiveTillExercisePeriod] [char](1),
				[PeriodUnit] [char](1),
				[IsRuleBypassed] [char](1),
				[Status] [char](1),
				[OthersReason] [varchar](30),
				[PushDate] [Datetime]
			)
		END

		IF(OBJECT_ID(N''dbo.SeparationRule'', N''U'') IS NULL)
		BEGIN
			CREATE TABLE [dbo].[SeparationRule]
			(
				[SeperationRuleId] [numeric](10, 0),
				[Reason] [varchar](30),
				[PushDate] [Datetime]
			)
		END
	') AT [EDREPORTSERVER]

END
GO
