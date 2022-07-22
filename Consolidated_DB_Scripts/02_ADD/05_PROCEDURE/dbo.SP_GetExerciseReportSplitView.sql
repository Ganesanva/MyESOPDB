-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_GetExerciseReportSplitView')
BEGIN
DROP PROCEDURE SP_GetExerciseReportSplitView
END
GO

CREATE       PROCEDURE [dbo].[SP_GetExerciseReportSplitView]
	@DBName VARCHAR (50), 
	@LinkedServer VARCHAR (50), 
	@FromDate DATETIME, 
	@ToDate DATETIME, 
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
    DECLARE @StrInsertQuery AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    SET XACT_ABORT ON;
    DECLARE @ClearDataQuery AS VARCHAR (MAX) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport_Split]';
    EXECUTE (@ClearDataQuery);

	 IF (@ESOPVersion = 'Global')
        BEGIN

		CREATE TABLE #ExerciseReport_Split(
			[EmployeeID] [varchar](20) NULL,
			[CountryName] [varchar](50) NULL,
			[SharesArised] [numeric](18, 0) NULL,
			[SARExerciseAmount] [numeric](18, 2) NULL,
			[ExercisedId] [numeric](18, 0) NULL,
			[EmployeeName] [varchar](75) NULL,
			[GrantRegistrationId] [varchar](20) NULL,
			[GrantOptionId] [varchar](100) NULL,
			[GrantDate] [datetime] NULL,
			[ExercisedQuantity] [numeric](18, 0) NULL,
			[SharesAlloted] [numeric](18, 0) NULL,
			[ExercisedDate] [datetime] NULL,
			[ExercisedPrice] [numeric](10, 2) NULL,
			[SchemeTitle] [varchar](50) NULL,
			[OptionRatioMultiplier] [numeric](18, 0) NULL,
			[SchemeId] [varchar](50) NULL,
			[OptionRatioDivisor] [numeric](18, 0) NULL,
			[SharesIssuedDate] [datetime] NULL,
			[DateOfPayment] [datetime] NULL,
			[Parent] [char](10) NULL,
			[VestingDate] [datetime] NULL,
			[GrantLegId] [decimal](10, 0) NULL,
			[FBTValue] [numeric](10, 2) NULL,
			[Cash] [varchar](50) NULL,
			[SAR_PerqValue] [numeric](18, 2) NULL,
			[FaceValue] [numeric](18, 2) NULL,
			[PerqstValue] [numeric](18, 6) NULL,
			[PerqstPayable] [numeric](18, 6) NULL,
			[FMVPrice] [numeric](18, 6) NULL,
			[FBTDays] [int] NULL,
			[TravelDays] [int] NULL,
			[PaymentMode] [varchar](20) NULL,
			[PerqTaxRate] [numeric](18, 6) NULL,
			[ExerciseNo] [numeric](18, 0) NULL,
			[Exercise_Amount] [numeric](18, 2) NULL,
			[Date_of_Payment] [datetime] NULL,
			[AccountNumber] [varchar](20) NULL,
			[ConfStatus] [char](1) NULL,
			[DateOfJoining] [datetime] NULL,
			[DateOfTermination] [datetime] NULL,
			[Department] [varchar](200) NULL,
			[EmployeeDesignation] [varchar](200) NULL,
			[Entity] [varchar](200) NULL,
			[Grade] [varchar](200) NULL,
			[Insider] [char](1) NULL,
			[ReasonForTermination] [varchar](50) NULL,
			[SBU] [varchar](200) NULL,
			[Residentialstatus] [varchar](50) NULL,
			[Itcircle_wardnumber] [varchar](15) NULL,
			[depositoryname] [varchar](20) NULL,
			[depositoryparticipatoryname] [varchar](150) NULL,
			[Confirmationdate] [datetime] NULL,
			[Nameasperdprecord] [varchar](50) NULL,
			[Employeeaddress] [varchar](500) NULL,
			[Employeeemail] [varchar](500) NULL,
			[EmployeePhone] [varchar](20) NULL,
			[Pan_girnumber] [varchar](10) NULL,
			[Dematactype] [varchar](20) NULL,
			[Dpidnumber] [varchar](20) NULL,
			[Clientidnumber] [varchar](16) NULL,
			[Location] [varchar](200) NULL,
			[INSTRUMENT_NAME] [nvarchar](1000) NULL,
			[ExercisePrice] [numeric](18, 2) NULL,
			[CurrencyName] [varchar](50) NULL,
			[FACE_VALUE] [numeric](18, 2) NULL,
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
			[State] [nvarchar](600) NULL,
			[EquivalentShares] [numeric](18, 2) NULL,
			[FromDate] [datetime] NULL,
			[ToDate] [datetime] NULL,
			[PushDate] [datetime] NULL
		) ON [PRIMARY]

		INSERT INTO #ExerciseReport_Split
		(EmployeeID, INSTRUMENT_NAME,CountryName,ExercisePrice, CurrencyName,SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle,
		OptionRatioMultiplier, SchemeId, OptionRatioDivisor, SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE,PerqstValue, PerqstPayable, FMVPrice,
		FBTDays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade,
		Insider, ReasonForTermination, SBU, Residentialstatus, Itcircle_wardnumber, depositoryname, depositoryparticipatoryname, Confirmationdate, Nameasperdprecord, Employeeaddress, Employeeemail, EmployeePhone,
		Pan_girnumber,	Dematactype, Dpidnumber, Clientidnumber, Location, LotNumber, CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue,
		ShareAriseApprValue, LWD, COST_CENTER, Status, BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares)
		EXEC SP_ExerciseReportSplitViewQR @FromDate,@ToDate;

		 SET @StrInsertQuery ='INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport_Split] 
				(
					EmployeeID, INSTRUMENT_NAME,CountryName,ExercisePrice, CurrencyName,SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle,
					OptionRatioMultiplier, SchemeId, OptionRatioDivisor, SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE,PerqstValue, PerqstPayable, FMVPrice,
					FBTDays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade,
					Insider, ReasonForTermination, SBU, Residentialstatus, Itcircle_wardnumber, depositoryname, depositoryparticipatoryname, Confirmationdate, Nameasperdprecord, Employeeaddress, Employeeemail, EmployeePhone,
					Pan_girnumber,	Dematactype, Dpidnumber, Clientidnumber, Location, LotNumber, CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue,
					ShareAriseApprValue, LWD, COST_CENTER, Status, BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares
				)
				SELECT EmployeeID, INSTRUMENT_NAME,CountryName,ExercisePrice, CurrencyName,SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle,
					OptionRatioMultiplier, SchemeId, OptionRatioDivisor, SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE,PerqstValue, PerqstPayable, FMVPrice,
					FBTDays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade,
					Insider, ReasonForTermination, SBU, Residentialstatus, Itcircle_wardnumber, depositoryname, depositoryparticipatoryname, Confirmationdate, Nameasperdprecord, Employeeaddress, Employeeemail, EmployeePhone,
					Pan_girnumber,	Dematactype, Dpidnumber, Clientidnumber, Location, LotNumber, CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue,
					ShareAriseApprValue, LWD, COST_CENTER, Status, BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares
				FROM #ExerciseReport_Split'
         
		 --EXEC SP_ExerciseReportSplitViewQR ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''',''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
		 --SET @StrInsertQuery ='INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport_Split] 
			--	(
			--		EmployeeID, INSTRUMENT_NAME,CountryName,ExercisePrice, CurrencyName,SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle,
			--		OptionRatioMultiplier, SchemeId, OptionRatioDivisor, SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE,PerqstValue, PerqstPayable, FMVPrice,
			--		FBTDays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade,
			--		Insider, ReasonForTermination, SBU, Residentialstatus, Itcircle_wardnumber, depositoryname, depositoryparticipatoryname, Confirmationdate, Nameasperdprecord, Employeeaddress, Employeeemail, EmployeePhone,
			--		Pan_girnumber,	Dematactype, Dpidnumber, Clientidnumber, Location, LotNumber, CurrencyAlias, MIT_ID, SettlmentPrice, StockApprValue, CashPayoutValue,
			--		ShareAriseApprValue, LWD, COST_CENTER, Status, BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, State, EquivalentShares
			--	)	
			--	EXEC SP_ExerciseReportSplitViewQR ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''',''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
		PRINT (@StrInsertQuery);
		EXECUTE (@StrInsertQuery);
		END
	ELSE
		BEGIN
		SET @StrInsertQuery ='INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport_Split]
				(
					EmployeeID, CountryName, SharesArised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle,
					OptionRatioMultiplier, SchemeId, OptionRatioDivisor, SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, PerqstValue, PerqstPayable, FMVPrice,
					FBTDays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, AccountNumber, ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade,
					Insider, ReasonForTermination, SBU, Residentialstatus, Itcircle_wardnumber, depositoryname, depositoryparticipatoryname, Confirmationdate, Nameasperdprecord, Employeeaddress, Employeeemail, EmployeePhone,
					Pan_girnumber,	Dematactype, Dpidnumber, Clientidnumber, Location
				)	
				EXEC SP_ExerciseReportSplitViewQR ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''',''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''';
				EXECUTE (@StrInsertQuery);
		END

		 DECLARE @StrUpdateQuery AS VARCHAR (MAX) = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[ExerciseReport_Split] 
			SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) + ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) + '''
			, PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
			EXECUTE (@StrUpdateQuery);
END
GO

