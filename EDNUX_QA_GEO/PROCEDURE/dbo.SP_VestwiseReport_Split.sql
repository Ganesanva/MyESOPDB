/****** Object:  StoredProcedure [dbo].[SP_VestwiseReport_Split]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_VestwiseReport_Split]
GO
/****** Object:  StoredProcedure [dbo].[SP_VestwiseReport_Split]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*	Author      : SUJEET DAS
	CREATED DATE: 09-July-2019				    
	Description : This script is used to store SP_REPORT_DATA ("SEPRATE" view) into VestwiseReport_Split.
*/

--IF OBJECT_ID('dbo.VestwiseReport_Split') IS NOT NULL
--	DROP TABLE dbo.VestwiseReport_Split
--GO
-- =============================================
-- Author			:<Author,,Name>
-- Description		:For SP_VestwiseReport_Split
-- Create date		:24-06-2022
-- VersionNumber	:10.0.2
-- DBVersion		:Global	
-- Server			:ENC
-- =============================================

CREATE      PROCEDURE [dbo].[SP_VestwiseReport_Split]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@FromDate VARCHAR(50),
	@ToDate VARCHAR(50),
	@ESOPVersion VARCHAR(50) = NULL
AS
BEGIN


 BEGIN TRY	
	DECLARE @USEDB AS VARCHAR (MAX) = 'USE [' + @DBName + ']';
    EXECUTE (@USEDB);
	DECLARE @StrInsertQuery AS VARCHAR (MAX);
	DECLARE @StrUpdateQuery AS VARCHAR (MAX);
	DECLARE @ClearDataQuery AS VARCHAR (MAX);
	SET XACT_ABORT ON;
	SET @ClearDataQuery = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split]';
	PRINT (@ClearDataQuery)
	EXECUTE (@ClearDataQuery);

	--CREATE TABLE #VESTWISE_TEMP_DATA 
	--(
	--			OptionsGranted			NUMERIC(10),	
	--			OptionsVested			NUMERIC(10),
	--			OptionsExercised		NUMERIC(10),
	--			OptionsCancelled		NUMERIC(10),
	--			OptionsLapsed 			NUMERIC(10),
	--			OptionsUnVested			NUMERIC(10),
	--			PendingForApproval		NUMERIC(10),
	--			GrantOptionId			VARCHAR(100), 
	--			GrantLegId				DECIMAL(10),
	--			SchemeId				VARCHAR(50),
	--			GrantRegistrationId		VARCHAR(20),
	--			Employeeid				VARCHAR(20),
	--			Employeename			VARCHAR(75),	
	--			SBU						VARCHAR(200),
	--			AccountNo				VARCHAR(20),
	--			PANNumber				VARCHAR(10),
	--			Entity					VARCHAR(200),
	--			Status					VARCHAR(20),
	--			GrantDate				DATETIME,
	--			VestingType				CHAR(20),
	--			ExercisePrice			NUMERIC(9),
	--			VestingDate				DATETIME,
	--			ExpirayDate				DATETIME,
	--			Parent_Note				CHAR(20),
	--			UnVestedCancelled		NUMERIC(10),
	--			VestedCancelled			NUMERIC(10),
	--			INSTRUMENT_NAME         NVARCHAR(1000),
	--			CurrencyName			VARCHAR(50),
	--			COST_CENTER				VARCHAR(200),
	--			Department				VARCHAR(200),
	--			Location				VARCHAR(200),
	--			EmployeeDesignation		VARCHAR(200),
	--			Grade					VARCHAR(200),
	--			ResidentialStatus		CHAR(1),
	--			CountryName				VARCHAR(50),
	--			CurrencyAlias			VARCHAR(50),
	--			MIT_ID					INT NOT NULL,
	--			CancellationReason		VARCHAR(100),
	--			FromDate				DATETIME,
	--			ToDate					DATETIME,
	--			PushDate				DATETIME
	--)
	IF(@ESOPVersion = 'Global')
	
		BEGIN	
		print('In Global')				;
			--CREATE TABLE VestwiseReport_Split
			--(
			--	OptionsGranted			NUMERIC(10) NOT NULL,	
			--	OptionsVested			NUMERIC(10) NOT NULL,
			--	OptionsExercised		NUMERIC(10) NOT NULL,
			--	OptionsCancelled		NUMERIC(10) NOT NULL,
			--	OptionsLapsed 			NUMERIC(10) NOT NULL,
			--	OptionsUnVested			NUMERIC(10) NOT NULL,
			--	PendingForApproval		NUMERIC(10) NOT NULL,
			--	GrantOptionId			VARCHAR(100) NOT NULL, 
			--	GrantLegId				DECIMAL(10) NOT NULL,
			--	SchemeId				VARCHAR(50),
			--	GrantRegistrationId		VARCHAR(20),
			--	Employeeid				VARCHAR(20) NOT NULL,
			--	Employeename			VARCHAR(75),	
			--	SBU						VARCHAR(200),
			--	AccountNo				VARCHAR(20),
			--	PANNumber				VARCHAR(10),
			--	Entity					VARCHAR(200),
			--	Status					VARCHAR(20),
			--	GrantDate				DATETIME,
			--	VestingType				CHAR(20),
			--	ExercisePrice			NUMERIC(9),
			--	VestingDate				DATETIME,
			--	ExpirayDate				DATETIME,
			--	Parent_Note				CHAR(20),
			--	UnVestedCancelled		NUMERIC(10) NOT NULL,
			--	VestedCancelled			NUMERIC(10) NOT NULL,
			--	INSTRUMENT_NAME         NVARCHAR(1000) NOT NULL,
			--	CurrencyName			VARCHAR(50) NOT NULL,
			--	COST_CENTER				VARCHAR(200),
			--	Department				VARCHAR(200),
			--	Location				VARCHAR(200),
			--	EmployeeDesignation		VARCHAR(200),
			--	Grade					VARCHAR(200),
			--	ResidentialStatus		CHAR(1),
			--	CountryName				VARCHAR(50),
			--	CurrencyAlias			VARCHAR(50) NOT NULL,
			--	MIT_ID					INT NOT NULL,
			--	CancellationReason		VARCHAR(100)			
			--)
			CREATE TABLE #VestwiseReport_Split(
				[OptionsGranted] [numeric](18, 0) NULL,
				[OptionsVested] [numeric](18, 0) NULL,
				[OptionsExercised] [numeric](18, 0) NULL,
				[OptionsCancelled] [numeric](18, 0) NULL,
				[OptionsLapsed] [numeric](18, 0) NULL,
				[OptionsUnVested] [numeric](18, 0) NULL,
				[PendingForApproval] [numeric](18, 0) NULL,
				[GrantOptionId] [varchar](100) NULL,
				[GrantLegId] [decimal](10, 0) NULL,
				[SchemeId] [varchar](50) NULL,
				[GrantRegistrationId] [varchar](20) NULL,
				[Employeeid] [varchar](20) NULL,
				[Employeename] [varchar](75) NULL,
				[SBU] [varchar](200) NULL,
				[AccountNo] [varchar](20) NULL,
				[PANNumber] [varchar](10) NULL,
				[Entity] [varchar](200) NULL,
				[Status] [varchar](20) NULL,
				[GrantDate] [datetime] NULL,
				[VestingType] [char](20) NULL,
				[ExercisePrice] [numeric](18, 2) NULL,
				[VestingDate] [datetime] NULL,
				[ExpirayDate] [datetime] NULL,
				[Parent_Note] [char](20) NULL,
				[UnVestedCancelled] [numeric](18, 0) NULL,
				[VestedCancelled] [numeric](18, 0) NULL,
				[INSTRUMENT_NAME] [nvarchar](500) NULL,
				[CurrencyName] [varchar](50) NULL,
				[COST_CENTER] [varchar](200) NULL,
				[Department] [varchar](200) NULL,
				[Location] [varchar](200) NULL,
				[EmployeeDesignation] [varchar](200) NULL,
				[Grade] [varchar](200) NULL,
				[ResidentialStatus] [char](1) NULL,
				[CountryName] [varchar](50) NULL,
				[CurrencyAlias] [varchar](50) NULL,
				[MIT_ID] [int] NULL,
				[CancellationReason] [varchar](100) NULL,
				[FromDate] [datetime] NULL,
				[ToDate] [datetime] NULL,
				[PushDate] [datetime] NULL
			) ON [PRIMARY]


			
			SET XACT_ABORT ON;
			INSERT INTO #VestwiseReport_Split
			(OptionsGranted, OptionsVested,OptionsExercised,OptionsCancelled,OptionsLapsed,OptionsUnVested,PendingForApproval
			,GrantOptionId,GrantLegId,SchemeId,GrantRegistrationId,Employeeid,Employeename
			,SBU,AccountNo,PANNumber,Entity,Status,GrantDate
			,VestingType,ExercisePrice,VestingDate,ExpirayDate,Parent_Note,UnVestedCancelled
			,VestedCancelled,INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location
			,EmployeeDesignation,Grade,ResidentialStatus,CountryName,CurrencyAlias,MIT_ID
			,CancellationReason)
			EXECUTE SP_REPORT_DATA_SH6 @FromDate,@ToDate,'S';
			----*EXECUTE SP_REPORT_DATA @FromDate,@ToDate,'S';-- 24-06-2022



			--SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split]
			--(
			--	OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId,
			--	GrantRegistrationId, Employeeid, Employeename, SBU, AccountNo, PANNumber, Entity, Status, GrantDate, VestingType, ExercisePrice, VestingDate, ExpirayDate,
			--	Parent_Note, UnVestedCancelled, VestedCancelled, INSTRUMENT_NAME, CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus,
			--	CountryName, CurrencyAlias, MIT_ID, CancellationReason
			--)
			--EXECUTE SP_REPORT_DATA @FROM_DATE =''' + @FromDate + 
			--''' ,@TO_DATE =''' + @ToDate + ''', @DisplayParm = ''S''';


			SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split]
			(
				OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId,
				GrantRegistrationId, Employeeid, Employeename, SBU, AccountNo, PANNumber, Entity, Status, GrantDate, VestingType, ExercisePrice, VestingDate, ExpirayDate,
				Parent_Note, UnVestedCancelled, VestedCancelled, INSTRUMENT_NAME, CurrencyName, COST_CENTER, Department, Location, EmployeeDesignation, Grade, ResidentialStatus,
				CountryName, CurrencyAlias, MIT_ID, CancellationReason
			)
			SELECT OptionsGranted, OptionsVested,OptionsExercised,OptionsCancelled,OptionsLapsed,OptionsUnVested,PendingForApproval
			,GrantOptionId,GrantLegId,SchemeId,GrantRegistrationId,Employeeid,Employeename
			,SBU,AccountNo,PANNumber,Entity,Status,GrantDate
			,VestingType,ExercisePrice,VestingDate,ExpirayDate,Parent_Note,UnVestedCancelled
			,VestedCancelled,INSTRUMENT_NAME,CurrencyName,COST_CENTER,Department,Location
			,EmployeeDesignation,Grade,ResidentialStatus,CountryName,CurrencyAlias,MIT_ID
			,CancellationReason
			FROM #VestwiseReport_Split'

			PRINT (@StrInsertQuery);

			EXECUTE (@StrInsertQuery);

			--EXEC  SP_REPORT_DATA @Fromdate, @Todate, NULL, 'S'			
			
			SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split] 
			SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) 
			+ ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) 
			+ ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
			EXECUTE (@StrUpdateQuery);
		END

		ELSE
 
		BEGIN
		
		--CREATE TABLE VestwiseReport_Split
		--(
		--	OptionsGranted			NUMERIC(10) NOT NULL,	
		--	OptionsVested			NUMERIC(10) NOT NULL,
		--	OptionsExercised		NUMERIC(10) NOT NULL,
		--	OptionsCancelled		NUMERIC(10) NOT NULL,
		--	OptionsLapsed 			NUMERIC(10) NOT NULL,
		--	OptionsUnVested			NUMERIC(10) NOT NULL,
		--	PendingForApproval		NUMERIC(10) NOT NULL,
		--	GrantOptionId			VARCHAR(100) NOT NULL, 
		--	GrantLegId				DECIMAL(10) NOT NULL,
		--	SchemeId				VARCHAR(50),
		--	GrantRegistrationId		VARCHAR(20),
		--	Employeeid				VARCHAR(20) NOT NULL,
		--	Employeename			VARCHAR(75),	
		--	SBU						VARCHAR(200),
		--	AccountNo				VARCHAR(20),
		--	PANNumber				VARCHAR(10),
		--	Entity					VARCHAR(200),
		--	Status					VARCHAR(20),
		--	GrantDate				DATETIME,
		--	VestingType				CHAR(20),
		--	ExercisePrice			NUMERIC(9),
		--	VestingDate				DATETIME,
		--	ExpirayDate				DATETIME,
		--	Parent_Note				CHAR(20),
		--	UnVestedCancelled		NUMERIC(10) NOT NULL,
		--	VestedCancelled			NUMERIC(10) NOT NULL,
		--)
		print('In MyESOPs');
		
		SET XACT_ABORT ON;
		SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split] 
		(
			OptionsGranted, OptionsVested, OptionsExercised, OptionsCancelled, OptionsLapsed, OptionsUnVested, PendingForApproval, GrantOptionId, GrantLegId, SchemeId,
			GrantRegistrationId, Employeeid, Employeename, SBU, AccountNo, PANNumber, Entity, Status, GrantDate, VestingType, ExercisePrice, VestingDate, ExpirayDate,
			Parent_Note, UnVestedCancelled, VestedCancelled
		)
		EXECUTE SP_REPORT_DATA @FROM_DATE =''' + @FromDate + 
		''' ,@TO_DATE =''' + @ToDate + ''', @DisplayParm = ''S''';
		--EXEC  SP_REPORT_DATA @Fromdate, @Todate, NULL, 'S'
		PRINT(@strInsertQuery);
		EXECUTE (@StrInsertQuery);
		PRINT('Success');

		SET @StrUpdateQuery = 'Update [' + @LinkedServer + '].[' + @DBName + '].[dbo].[VestwiseReport_Split] 
		SET FromDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @FromDate, 23)) 
		+ ''', ToDate = ''' + CONVERT (VARCHAR (50), CONVERT (VARCHAR (50), @ToDate, 23)) 
		+ ''', PushDate = ''' + CONVERT (VARCHAR (50), CONVERT (CHAR (10), GetDate(), 126)) + '''';
		EXECUTE (@StrUpdateQuery);
    END

	     
	 	           
 END TRY 

BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS  ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage;  

		ROLLBACK TRANSACTION
END CATCH
END
GO
