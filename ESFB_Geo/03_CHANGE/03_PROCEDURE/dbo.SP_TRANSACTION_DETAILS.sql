DROP PROCEDURE IF EXISTS [dbo].[SP_TRANSACTION_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[SP_TRANSACTION_DETAILS]    Script Date: 18-07-2022 16:38:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_TRANSACTION_DETAILS]      
      (@EXERCISENO VARCHAR(50))
AS
BEGIN

	  DECLARE @FaceValue VARCHAR(10)
      SELECT @FaceValue=FaceVaue FROM   COMPANYPARAMETERS cp 
	  DECLARE @sqlQuery VARCHAR(5000) 
	  -- Payement details
      --SELECT pb.BankName  as BankName,
      --[MerchantreferenceNo],[BankReferenceNo],[Merchant_Code],[Sh_ExerciseNo],[TransactionType],[Amount],[Item_Code],[Payment_status],[Transaction_Status],[Transaction_Date],[Tax_Amount],[Failure Reson],
      --[ErrorCode],[transactionfees],[FailureReson],[ExerciseNo],[BankAccountNo],[DPRecord],[DepositoryName],[DematAcType],[DPName],[DPId],[ClientId],[PanNumber],[Nationality],[ResidentialStatus]
      --[Location],[MobileNumber],[CountryCode],[STATUS],[ActionType],td.[bankid],[TPSLTransID],[UniqueTransactionNo],[IS_MAIL_SENT],[SecondaryEmailID] ,CountryMaster.[CountryName], COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM
      --FROM TRANSACTION_DETAILS td LEFT OUTER JOIN paymentbankmaster pb on td.bankid = pb.BankID  
      --LEFT OUTER JOIN CountryMaster on td.CountryName=CountryMaster.CountryAliasName
      --WHERE Sh_ExerciseNo=@EXERCISENO and td.Payment_status ='S';     
      
	  SELECT distinct [PaymentMode],pb.BankName as BankName,
[MerchantreferenceNo],[BankReferenceNo],[Merchant_Code],[Sh_ExerciseNo],[TransactionType],[Amount],[Item_Code],[Payment_status],[Transaction_Status],[Transaction_Date],[Tax_Amount],[Failure Reson],
[ErrorCode],[transactionfees],[FailureReson],she.[ExerciseNo],[BankAccountNo],[DPRecord],[DepositoryName],[DematAcType],[DPName],[DPId],[ClientId],[PanNumber],[Nationality],[ResidentialStatus]
,[Location],[MobileNumber],[CountryCode],[STATUS],[ActionType],td.[bankid],[TPSLTransID],[UniqueTransactionNo],[IS_MAIL_SENT],[SecondaryEmailID] ,CountryMaster.[CountryName], COST_CENTER, BROKER_DEP_TRUST_CMP_NAME, BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM
FROM TRANSACTION_DETAILS td
Inner join SHEXERCISEDOPTIONS SHE on she.ExerciseNo=Sh_ExerciseNo
LEFT OUTER JOIN paymentbankmaster pb on td.bankid = pb.BankID
LEFT OUTER JOIN CountryMaster on td.CountryName=CountryMaster.CountryAliasName
WHERE Sh_ExerciseNo=@EXERCISENO and td.Payment_status ='S';
      
		-- Total Amount and Tax details
		 SELECT X.INSTRUMENT_NAME ,X.ExerciseAmount,X.ExercisedQuantity, X.PerqusiteTax, X.PerqusiteTax AS TotalTax, SUM(X.ExerciseAmount + X.PerqusiteTax) AS TotalAmount,ISNULL(X.StockApprValue,0) as StockApprValue,ISNULL(x.ShareAriseApprValue,0) as ShareAriseApprValue,X.NETCashPayout
		 FROM(
		 SELECT distinct
				CASE WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(SUM(she.TentShareAriseApprValue),SUM(she.ShareAriseApprValue)) * @FaceValue )                
                WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoActualTax' THEN (ISNULL(SUM(she.ShareAriseApprValue),0) * @FaceValue )	 ELSE 	                 
                SUM(she.ExercisePrice*she.ExercisedQuantity) END  as  ExerciseAmount,sum(isnull(she.PerqstPayable,0)) as PerqusiteTax ,MIT.INSTRUMENT_NAME,SUM(SHE.ExercisedQuantity) as ExercisedQuantity,
				 CASE WHEN SCHE.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SUM(SHE.TentativeStockApprValue),0)
				   WHEN SCHE.CALCULATE_TAX = 'rdoActualTax' THEN SUM(SHE.StockApprValue) ELSE 0 END AS StockApprValue,
				     SUM(ShareAriseApprValue) as ShareAriseApprValue,
		 CASE WHEN SCHE.MIT_ID = 6 then  ISNULL(SUM(SHE.CashPayoutValue),0) else 0 end as NETCashPayout
    
    	 FROM SHEXERCISEDOPTIONS SHE
		 	  JOIN GRANTLEG GL ON SHE.GrantlegSerialNumber = GL.ID 			  
			  JOIN SCHEME SCHE ON GL.SCHEMEID = SCHE.SCHEMEID 
			  LEFT OUTER JOIN MST_INSTRUMENT_TYPE MIT ON SCHE.MIT_ID=MIT.MIT_ID
         WHERE SHE.EXERCISENO=@ExerciseNo
         GROUP BY SCHE.MIT_ID,SCHE.CALCULATE_TAX
		 , she.ExerciseDate, MIT.INSTRUMENT_NAME,she.ExercisedQuantity,StockApprValue)X
		 GROUP BY X.ExerciseAmount,X.PerqusiteTax, X.INSTRUMENT_NAME,X.ExercisedQuantity,X.StockApprValue,x.ShareAriseApprValue,X.NETCashPayout

		 SELECT GL.GrantOptionId, SHE.ExerciseDate, SHE.ExercisedQuantity, ExercisePrice FROM SHEXERCISEDOPTIONS SHE
				JOIN GRANTLEG GL ON SHE.GrantlegSerialNumber = GL.ID 	
		 WHERE EXERCISENO=@ExerciseNo
END
GO


