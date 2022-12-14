/****** Object:  StoredProcedure [dbo].[CRUD_ExepCashlessTranCharges]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CRUD_ExepCashlessTranCharges]
GO
/****** Object:  StoredProcedure [dbo].[CRUD_ExepCashlessTranCharges]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CRUD_ExepCashlessTranCharges]
(
	@ExerciseId 							VARCHAR(50), 
	@EmployeeId 							VARCHAR(50),
    @PerquisiteValue						DECIMAL (18,6) = NULL,
    @PerqTax								DECIMAL(18,6) = NULL,
    @PerquisiteTaxPaid						DECIMAL(18,6) = NULL,
    @CashlessCharges						DECIMAL(18,6) = NULL,
    @CAFilling								DECIMAL(18,6) = NULL,
    @ServiceTaxOnCAFilling					DECIMAL(18,6) = NULL,
	@CessOnCAFillingFees					DECIMAL(18,6) = NULL,
    @BankCharges							DECIMAL(18,6) = NULL,
    @ServiceTaxOnBankCharges				DECIMAL (18,6) = NULL,
	@CessOnBankChargesFillingFees			DECIMAL (18,6) = NULL,
    @CapitalGainValue						DECIMAL( 18,6) = NULL,
	@CapitalTaxRateApplicable				DECIMAL (18,6) = NULL,
	@CapitalGainTax							DECIMAL(18,6) = NULL,
	@SaleDate								DATETIME  = NULL,
    @UserName								VARCHAR(50),
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
 
	IF NOT EXISTS(SELECT 1 FROM CashlessExceptionalChargesUpdation WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId))	
		BEGIN
			
				-- Insert Details into Main Table id Exercise id not available.
				INSERT INTO [dbo].[CashlessExceptionalChargesUpdation]
				([ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees], [BankCharges], 
				[ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], [CreatedBy], [CreateDate], [LastUpdatedBy], [LastUpdatedOn],
				TrancheNo, EmployeeName, ExerciseNo, SharesSold, TransactionCharges, ServiceTaxOnTransactionCharges, CessOnTransactionCharges, BrokerageCharges, ServiceTaxOnBrokerageCharges, CessOnBrokerageCharges, STT,
				SEBIFee, StampDuty, CashBalanceAvailableInBrokerAccount,SellingPrice,Field1Filling,Field2Filling,Field3Filling,Field4Filling,Field5Filling,BrokerField1,BrokerField2,
				BrokerField3,BrokerField4,BrokerField5 )

				VALUES 
				(@ExerciseId, @EmployeeId, @PerquisiteValue, @PerqTax, @PerquisiteTaxPaid, @CashlessCharges, @CAFilling, @ServiceTaxOnCAFilling, @CessOnCAFillingFees, @BankCharges,
	 			@ServiceTaxOnBankCharges, @CessOnBankChargesFillingFees, @CapitalGainValue, @CapitalTaxRateApplicable, @CapitalGainTax, @SaleDate, 'U', @UserName, GETDATE(), @UserName, GETDATE(),
	 			@TrancheNo, @EmployeeName, @ExerciseNo, @SharesSold, @TransactionCharges, @ServiceTaxOnTransactionCharges, @CessOnTransactionCharges, @BrokerageCharges, @ServiceTaxOnBrokerageCharges, @CessOnBrokerageCharges, @STT,
				@SEBIFee, @StampDuty, @CashBalanceAvailableInBrokerAccount,@SellingPrice,@Field1Filling,@Field2Filling,@Field3Filling,@Field4Filling,@Field5Filling,@BrokerField1,@BrokerField2,@BrokerField3,@BrokerField4,@BrokerField5)
				
				-- Insert into History table
				INSERT INTO [dbo].[CashlessExceptionalChargesUpdationHistory]
				([UpdationChargesID], [ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees],
				[BankCharges], [ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], [LastUpdatedBy], [LastUpdatedOn],
				TrancheNo, EmployeeName, ExerciseNo, SharesSold, TransactionCharges, ServiceTaxOnTransactionCharges, CessOnTransactionCharges, BrokerageCharges, ServiceTaxOnBrokerageCharges, CessOnBrokerageCharges, STT,
				SEBIFee, StampDuty, CashBalanceAvailableInBrokerAccount,SellingPrice,Field1Filling,Field2Filling,Field3Filling,Field4Filling,Field5Filling,BrokerField1,BrokerField2,
				BrokerField3,BrokerField4,BrokerField5)
				SELECT [UpdationChargesID], [ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees],
				[BankCharges], [ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], @UserName, GETDATE(),
	 			@TrancheNo, @EmployeeName, @ExerciseNo, @SharesSold, @TransactionCharges, @ServiceTaxOnTransactionCharges, @CessOnTransactionCharges, @BrokerageCharges, @ServiceTaxOnBrokerageCharges, @CessOnBrokerageCharges, @STT,
				@SEBIFee, @StampDuty, @CashBalanceAvailableInBrokerAccount,@SellingPrice,@Field1Filling,@Field2Filling,@Field3Filling,@Field4Filling,@Field5Filling,@BrokerField1,@BrokerField2,@BrokerField3,@BrokerField4,@BrokerField5
				FROM [dbo].[CashlessExceptionalChargesUpdation]	 WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
			
				DECLARE @UpdationChargesID VARCHAR(50)
				SET @UpdationChargesID = (SELECT UpdationChargesID FROM CashlessExceptionalChargesUpdation WHERE ExerciseId = @ExerciseId AND EmployeeId = @EmployeeId)

				UPDATE CashlessExceptionalChargesUpdationHistory SET UpdationChargesID = @UpdationChargesID WHERE ExerciseId = @ExerciseId AND EmployeeId = @EmployeeId AND UpdationChargesID IS NULL
			
			SET @Result=1
			
		END
	ELSE 
		BEGIN
	           
				-- Update details in Master table
				-- if details sends empty or null from execel then keep original as it is
	                                             
				IF @PerquisiteValue IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET PerquisiteValue = @PerquisiteValue WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	           
				IF @PerqTax IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET PerqTax = @PerqTax WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	            
				IF @PerquisiteTaxPaid  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET PerquisiteTaxPaid = @PerquisiteTaxPaid WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	            
				IF @CashlessCharges IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CashlessCharges = @CashlessCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	            
				IF @CAFilling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CAFilling = @CAFilling WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	                       
				IF @ServiceTaxOnCAFilling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET ServiceTaxOnCAFilling = @ServiceTaxOnCAFilling WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
				
				IF @CessOnCAFillingFees IS NOT NULL
				BEGIN
					UPDATE CashlessExceptionalChargesUpdation SET CessOnCAFillingFees = @CessOnCAFillingFees WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
	                       
				IF @BankCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET BankCharges = @BankCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END

				IF @ServiceTaxOnBankCharges IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET ServiceTaxOnBankCharges = @ServiceTaxOnBankCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
				
				IF @CessOnBankChargesFillingFees IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CessOnBankChargesFillingFees = @CessOnBankChargesFillingFees WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
		
				IF @CapitalGainValue IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CapitalGainValue = @CapitalGainValue WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END             
	                       
				IF @CapitalTaxRateApplicable IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CapitalTaxRateApplicable = @CapitalTaxRateApplicable WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END  
				
				IF @CapitalGainTax  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CapitalGainTax = @CapitalGainTax WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				
				IF @TrancheNo IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET TrancheNo = @TrancheNo WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @EmployeeName  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET EmployeeName = @EmployeeName WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @ExerciseNo  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET ExerciseNo = @ExerciseNo WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @SharesSold  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET SharesSold = @SharesSold WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @TransactionCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET TransactionCharges = @TransactionCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @ServiceTaxOnTransactionCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET ServiceTaxOnTransactionCharges = @ServiceTaxOnTransactionCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @CessOnTransactionCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CessOnTransactionCharges = @CessOnTransactionCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @BrokerageCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET BrokerageCharges = @BrokerageCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				
				IF @ServiceTaxOnBrokerageCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET ServiceTaxOnBrokerageCharges = @ServiceTaxOnBrokerageCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @CessOnBrokerageCharges  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CessOnBrokerageCharges = @CessOnBrokerageCharges WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @STT  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET STT = @STT WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @SEBIFee  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET SEBIFee = @SEBIFee WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @StampDuty  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET StampDuty = @StampDuty WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END 
				
				IF @CashBalanceAvailableInBrokerAccount  IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET CashBalanceAvailableInBrokerAccount = @CashBalanceAvailableInBrokerAccount WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
				END
				
			    IF @SellingPrice IS NOT NULL 
				BEGIN 
					  UPDATE CashlessExceptionalChargesUpdation  SET SellingPrice =@SellingPrice  WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END 
				
				IF @Field1Filling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET Field1Filling=@Field1Filling WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END 
	               
				IF @Field2Filling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET Field2Filling=@Field2Filling WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END
	               
				IF @Field3Filling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET Field3Filling=@Field3Filling WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END
	               
				IF @Field4Filling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET Field4Filling=@Field4Filling WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END  
	               
				IF @Field5Filling IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET Field5Filling=@Field5Filling WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END 
	               
				IF @BrokerField1 IS NOT NULL 
				BEGIN 
					UPDATE CashlessExceptionalChargesUpdation SET BrokerField1=@BrokerField1 WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END
	               
				IF @BrokerField2 IS NOT NULL 
				BEGIN 
					 UPDATE CashlessExceptionalChargesUpdation SET BrokerField2=@BrokerField2 WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				END   
	               
				IF @BrokerField3 IS NOT NULL 
				BEGIN 
					 UPDATE CashlessExceptionalChargesUpdation SET BrokerField3=@BrokerField3 WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				 END   
	               
				 IF @BrokerField4 IS NOT NULL 
				 BEGIN 
				      UPDATE CashlessExceptionalChargesUpdation SET BrokerField4=@BrokerField4 WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				 END   
	               
				 IF @BrokerField5 IS NOT NULL 
				 BEGIN 
					  UPDATE CashlessExceptionalChargesUpdation SET BrokerField5=@BrokerField5 WHERE ExerciseID=@ExerciseID AND EmployeeID=@EmployeeID 
				 END   

				UPDATE  CashlessExceptionalChargesUpdation SET LastUpdatedBy = @UserName, LastUpdatedOn = GETDATE() WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)                      

				-- Insert into History table
				INSERT INTO [dbo].[CashlessExceptionalChargesUpdationHistory]
				([UpdationChargesID], [ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees],
				[BankCharges], [ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], [LastUpdatedBy], [LastUpdatedOn],
				TrancheNo, EmployeeName, ExerciseNo, SharesSold, TransactionCharges, ServiceTaxOnTransactionCharges, CessOnTransactionCharges, BrokerageCharges, ServiceTaxOnBrokerageCharges, CessOnBrokerageCharges, STT,
				SEBIFee, StampDuty, CashBalanceAvailableInBrokerAccount,SellingPrice,Field1Filling,Field2Filling,Field3Filling,Field4Filling,Field5Filling,BrokerField1,BrokerField2,
	            BrokerField3,BrokerField4,BrokerField5)
				SELECT [UpdationChargesID], [ExerciseId], [EmployeeId], [PerquisiteValue], [PerqTax], [PerquisiteTaxPaid], [CashlessCharges], [CAFilling], [ServiceTaxOnCAFilling], [CessOnCAFillingFees],
				[BankCharges], [ServiceTaxOnBankCharges], [CessOnBankChargesFillingFees], [CapitalGainValue], [CapitalTaxRateApplicable], [CapitalGainTax], [SaleDate], [IdStatus], @UserName, GETDATE(),
				TrancheNo, EmployeeName, ExerciseNo, SharesSold, TransactionCharges, ServiceTaxOnTransactionCharges, CessOnTransactionCharges, BrokerageCharges, ServiceTaxOnBrokerageCharges, CessOnBrokerageCharges, STT,
				SEBIFee, StampDuty, CashBalanceAvailableInBrokerAccount,@SellingPrice,@Field1Filling,@Field2Filling,@Field3Filling,@Field4Filling,@Field5Filling,@BrokerField1,@BrokerField2,@BrokerField3,@BrokerField4,@BrokerField5
				FROM [dbo].[CashlessExceptionalChargesUpdation]	 WHERE (ExerciseId = @ExerciseId) AND (EmployeeId = @EmployeeId)
								      				                             
				SET @Result=1
	                       
		END 
END
GO
