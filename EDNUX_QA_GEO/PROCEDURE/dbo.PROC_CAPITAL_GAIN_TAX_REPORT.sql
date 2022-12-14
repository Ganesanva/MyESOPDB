/****** Object:  StoredProcedure [dbo].[PROC_CAPITAL_GAIN_TAX_REPORT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CAPITAL_GAIN_TAX_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CAPITAL_GAIN_TAX_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CAPITAL_GAIN_TAX_REPORT] 
      -- Add the parameters for the stored procedure here
      @DATABASE_NAME NVARCHAR(100),
      @EmployeeId NVARCHAR(100),
      @FROM_DATE VARCHAR (50),
      @TO_DATE VARCHAR (50),
      @TRUST_DB_NAME NVARCHAR(100),
      @EXERCISE_ID NVARCHAR(50)= NULL
AS
BEGIN
      /* SET NOCOUNT ON added to prevent extra result sets from*/
      /*interfering with SELECT statements.*/
      
		SET NOCOUNT ON;

		DECLARE @MAIN_QUERY VARCHAR(MAX)
		DECLARE @STR_WHERE_CONDITION VARCHAR(1000)
				
		SET @FROM_DATE  = CONVERT(DATE,@FROM_DATE)
		SET @TO_DATE  = CONVERT(DATE,@TO_DATE)	
		
				
		CREATE TABLE #CAPITAL_GAIN_TAX_DETAILS
		(			
			TrancheName VARCHAR(100), EmpId NVARCHAR(50), EmpName VARCHAR(200), ExerciseDate DATETIME, ResidentStatus VARCHAR(50), CompanyID NVARCHAR(50), 
			trancheCloseDate DATETIME, ExDateTime DATETIME, ExNum NVARCHAR (100), ExId NVARCHAR (100), TrancheId NUMERIC (18,0),
			OptionsEx NUMERIC (18,0), ExPrice DECIMAL(10,2), FMV DECIMAL(10,2), AvgPricePerTranche DECIMAL(10,2), SharesSold NUMERIC(18,0), 
			ValOfPerquisite NUMERIC(18,2), PerqTaxPercentage NUMERIC(18,6), ActualPerTax NUMERIC(18,2), TypeOfBankAccount NVARCHAR(100),
			TransChargesPaid NUMERIC(18,2), ServiceTaxontransachargesPaid NUMERIC(18,2), BrokerChargesPaid NUMERIC(18,2), 
			SerTaxonBrokerageChargesPaid NUMERIC(18,2), STTPaid NUMERIC(18,2), SEBIFeePaid NUMERIC(18,2), StampdutyPaid NUMERIC(18,2),	
			CashlessCharges NUMERIC(18,2), CAFillings NUMERIC(18,2), ServiceTaxOnCAFillingFees NUMERIC(18,2), BankCharges NUMERIC(18,2), 
			ServiceTaxonBankCharges NUMERIC(18,2), TaxType NVARCHAR(50), 
			TaxRateApplicable NUMERIC(18,6), CGTValue NUMERIC(18,2), CGT NUMERIC(18,6), OtherCharges NUMERIC(18,2), CGTCreatedDate DATETIME,
			CessTransactionCharges NUMERIC(18,2), CessBrokerageCharges NUMERIC(18,2), CessCAFillingCharges NUMERIC(18,2), CessBankCharges NUMERIC(18,2),
			CurrencyAlias NVARCHAR (50)		
			
		)
		
		DECLARE @STR_QUERY VARCHAR(MAX)
      
		SET @STR_QUERY = @TRUST_DB_NAME + '..CalcCapitalGainTaxForEmp ' + CHAR(39) + @DATABASE_NAME + CHAR(39) + ',' +
            CHAR(39) + @EmployeeId + CHAR(39) + ',' + CHAR(39) + @FROM_DATE + CHAR(39) + ',' + CHAR(39) + @TO_DATE + CHAR(39)
		
		INSERT INTO #CAPITAL_GAIN_TAX_DETAILS 
		(	
			TrancheName, EmpId, EmpName, ExerciseDate, ResidentStatus, CompanyID, trancheCloseDate, ExDateTime, ExNum, ExId, 
			TrancheId, OptionsEx, ExPrice, FMV, AvgPricePerTranche, SharesSold, ValOfPerquisite, PerqTaxPercentage, ActualPerTax, TypeOfBankAccount,
			TransChargesPaid, ServiceTaxontransachargesPaid, BrokerChargesPaid, SerTaxonBrokerageChargesPaid, STTPaid, SEBIFeePaid, StampdutyPaid,
			CashlessCharges, CAFillings, ServiceTaxOnCAFillingFees, BankCharges, ServiceTaxonBankCharges, TaxType, TaxRateApplicable, CGTValue,	
			CGT, OtherCharges, CGTCreatedDate, CessTransactionCharges, CessBrokerageCharges, CessCAFillingCharges, CessBankCharges
		)
		EXECUTE (@STR_QUERY)     
				
		SET @MAIN_QUERY = 
		' SELECT TrancheName, EmpId, EmpName, CGTD.ExerciseDate, ResidentStatus, CompanyID, trancheCloseDate, ExDateTime, ExNum, ExId, 
		TrancheId, OptionsEx, ExPrice, FMV, AvgPricePerTranche, SharesSold, ValOfPerquisite, dbo.FN_PQ_TAX_ROUNDING(PerqTaxPercentage) AS PerqTaxPercentage,
		ActualPerTax, TypeOfBankAccount,TransChargesPaid, ServiceTaxontransachargesPaid, BrokerChargesPaid, SerTaxonBrokerageChargesPaid, STTPaid, SEBIFeePaid, StampdutyPaid,
		CashlessCharges, CAFillings, ServiceTaxOnCAFillingFees, BankCharges, ServiceTaxonBankCharges, TaxType, dbo.FN_PQ_TAX_ROUNDING(TaxRateApplicable) AS TaxRateApplicable,
		CGTValue,dbo.FN_PQ_TAX_ROUNDING(CGT) AS CGT, OtherCharges, CGTCreatedDate, CessTransactionCharges, CessBrokerageCharges, CessCAFillingCharges, CessBankCharges, CM.CurrencyAlias
		FROM #CAPITAL_GAIN_TAX_DETAILS AS CGTD 
		INNER JOIN ShExercisedOptions SHO ON CGTD.ExId = SHO.ExerciseId
		INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON SHO.MIT_ID = CIM.MIT_ID
		INNER JOIN CurrencyMaster CM ON CIM.CurrencyID = CM.CurrencyID '
		
		IF(@EXERCISE_ID IS NOT NULL)
		BEGIN
			SET @STR_WHERE_CONDITION = 'WHERE ExId = '+ CHAR(39) + @EXERCISE_ID + CHAR(39)
		END

		/*PRINT (@MAIN_QUERY + @STR_WHERE_CONDITION)*/
		EXECUTE (@MAIN_QUERY + @STR_WHERE_CONDITION)
END
GO
