/****** Object:  StoredProcedure [dbo].[CRUD_ExepCashlessTranChargesHistory]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CRUD_ExepCashlessTranChargesHistory]
GO
/****** Object:  StoredProcedure [dbo].[CRUD_ExepCashlessTranChargesHistory]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CRUD_ExepCashlessTranChargesHistory]
(
	@ExerciseId								VARCHAR(50), 
	@EmployeeId								VARCHAR(50),
    @PerquisiteValue						DECIMAL (18,6) = NULL,
    @PerqTax								DECIMAL (18,6) = NULL,
    @PerquisiteTaxPaid						DECIMAL (18,6) = NULL,
    @CashlessCharges						DECIMAL (18,6) = NULL,
    @CAFilling								DECIMAL (18,6) = NULL,
    @ServiceTaxOnCAFilling					DECIMAL (18,6) = NULL,
	@CessOnCAFillingFees					DECIMAL (18,6) = NULL,
    @BankCharges							DECIMAL (18,6) = NULL,
    @ServiceTaxOnBankCharges				DECIMAL (18,6) = NULL,
	@CessOnBankChargesFillingFees			DECIMAL (18,6) = NULL,
    @CapitalGainValue						DECIMAL (18,6)= NULL,
	@CapitalTaxRateApplicable				DECIMAL (18,6) = NULL,
	@CapitalGainTax							DECIMAL (18,6) = NULL,
	@SaleDate 								DATETIME = NULL,
    @UserName 								VARCHAR(50),
    @TrancheNo								INT = NULL,
	@EmployeeName							VARCHAR(100),
	@ExerciseNo								INT = NULL,
	@SharesSold								DECIMAL(18,6) = NULL,
	@TransactionCharges						DECIMAL(18,6) = NULL,
	@ServiceTaxOnTransactionCharges			DECIMAL(18,6) = NULL,
	@CessOnTransactionCharges				DECIMAL(18,6) = NULL,
	@BrokerageCharges						DECIMAL(18,6) = NULL,
	@ServiceTaxOnBrokerageCharges			DECIMAL(18,6) = NULL,
	@CessOnBrokerageCharges					DECIMAL(18,6) = NULL,
	@STT									DECIMAL(18,6) = NULL,
	@SEBIFee								DECIMAL(18,6) = NULL,
	@StampDuty								DECIMAL(18,6) = NULL,
	@CashBalanceAvailableInBrokerAccount	DECIMAL(18,6) = NULL,
	@SellingPrice                           DECIMAL(18,2)=NULL,
	@Field1Filling							DECIMAL(18,2)=NULL,
	@Field2Filling							DECIMAL(18,2)=NULL,
	@Field3Filling							DECIMAL(18,2)=NULL,
	@Field4Filling							DECIMAL(18,2)=NULL,
	@Field5Filling							DECIMAL(18,2)=NULL,
	@BrokerField1							DECIMAL(18,2)=NULL,
	@BrokerField2							DECIMAL(18,2)=NULL,
	@BrokerField3							DECIMAL(18,2)=NULL,
	@BrokerField4							DECIMAL(18,2)=NULL,
	@BrokerField5							DECIMAL(18,2)=NULL,
    @Result									INT OUTPUT
)
AS    
BEGIN  

SET @Result=0

	-- Insert Details into Main Table id Exercise id not available.
	INSERT INTO [dbo].[CashlessExceptionalChargesUpdationHistory]
	([ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees], [BankCharges], 
	[ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], [LastUpdatedBy], [LastUpdatedOn],
	TrancheNo, EmployeeName, ExerciseNo, SharesSold, TransactionCharges, ServiceTaxOnTransactionCharges, CessOnTransactionCharges, BrokerageCharges, ServiceTaxOnBrokerageCharges, CessOnBrokerageCharges, STT,
	SEBIFee, StampDuty, CashBalanceAvailableInBrokerAccount,SellingPrice,Field1Filling,Field2Filling,Field3Filling,Field4Filling,Field5Filling,BrokerField1,BrokerField2
	,BrokerField3,BrokerField4,BrokerField5)
	VALUES 
	(@ExerciseId, @EmployeeId, @PerquisiteValue, @PerqTax, @PerquisiteTaxPaid, @CashlessCharges, @CAFilling, @ServiceTaxOnCAFilling, @CessOnCAFillingFees, @BankCharges,
	@ServiceTaxOnBankCharges, @CessOnBankChargesFillingFees, @CapitalGainValue, @CapitalTaxRateApplicable, @CapitalGainTax, @SaleDate, 'O', @UserName, GETDATE(),
	@TrancheNo, @EmployeeName, @ExerciseNo, @SharesSold, @TransactionCharges, @ServiceTaxOnTransactionCharges, @CessOnTransactionCharges, @BrokerageCharges, @ServiceTaxOnBrokerageCharges, @CessOnBrokerageCharges, @STT,
	@SEBIFee, @StampDuty, @CashBalanceAvailableInBrokerAccount,@SellingPrice,@Field1Filling,@Field2Filling,@Field3Filling,@Field4Filling,@Field5Filling,@BrokerField1,@BrokerField2,@BrokerField3,@BrokerField4,@BrokerField5)
	
	SET @Result=1
			
END
GO
