DROP PROCEDURE IF EXISTS [dbo].[PROC_GETOFFLINEUSERTRANSACTIONDETAILS]
GO

/****** Object:  StoredProcedure [dbo].[PROC_GETOFFLINEUSERTRANSACTIONDETAILS]    Script Date: 18-07-2022 15:06:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GETOFFLINEUSERTRANSACTIONDETAILS]	
	(@ExerciseNo AS VARCHAR (50))
AS
	
BEGIN
	SET NOCOUNT ON;
		 DECLARE @FaceValue VARCHAR(10)
		 SELECT @FaceValue=FaceVaue FROM COMPANYPARAMETERS cp 
        -- Payment Transaction details
		 SELECT 
			   Distinct [PaymentMode],[Cheque_DDNo],[BankName],sht.[DrawnOn],[WriteTransferNo],[Cheque_DDNo_FBT],[BankName_FBT],[DrawnOn_FBT],[PerqAmt_ChequeNo],[PerqAmt_DrownOndate],[PerqAmt_WireTransfer],[PerqAmt_BankName],[PerqAmt_Branch],[PerqAmt_BankAccountNumber],[Branch],[AccountNo],[PaymentNameEX],[PaymentNamePQ],[IBANNo],[IBANNoPQ],[ExAmtTypOfBnkAC],[PeqTxTypOfBnkAC],she.[PerqstPayable]
		 FROM 
			  ShTransactionDetails as sht LEFT OUTER JOIN CountryMaster AS cm ON sht.CountryName=cm.CountryAliasName
			  LEFT JOIN ShExercisedOptions as she on she.ExerciseNo =  sht.ExerciseNo
		 WHERE
			  sht.ExerciseNo=@ExerciseNo

		-- Total Amount and Tax details
		 SELECT X.INS_DISPLY_NAME AS INSTRUMENT_NAME ,
		 X.ExerciseAmount,X.ExercisedQuantity ,
		( CASE WHEN( X.PerqusiteTax < 0) THEN 0 ELSE   X.PerqusiteTax END) AS PerqusiteTax,
		 
		  ( CASE WHEN( X.PerqusiteTax < 0) THEN 0 ELSE   X.PerqusiteTax END)
		 
		 AS TotalTax,
		  SUM(X.ExerciseAmount +  CASE WHEN( X.PerqusiteTax < 0) THEN 0 ELSE   X.PerqusiteTax END ) AS TotalAmount,ISNULL(X.StockApprValue,0) as StockApprValue
		 FROM(
		 SELECT distinct
				CASE WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(SUM(she.TentShareAriseApprValue),SUM(she.ShareAriseApprValue)) * @FaceValue )                
                WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoActualTax' THEN (ISNULL(SUM(she.ShareAriseApprValue),0) * @FaceValue )	 ELSE 	                 
                SUM(she.ExercisePrice*she.ExercisedQuantity) END  as  ExerciseAmount,sum(isnull(she.PerqstPayable,0)) as PerqusiteTax ,INS_DISPLY_NAME,SUM(SHE.ExercisedQuantity) as ExercisedQuantity
				, CASE WHEN SCHE.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SUM(SHE.TentativeStockApprValue),0)
				   WHEN SCHE.CALCULATE_TAX = 'rdoActualTax' THEN SUM(SHE.StockApprValue) ELSE 0 END AS StockApprValue,
				   SUM(ShareAriseApprValue) as ShareAriseApprValue,CASE WHEN SCHE.MIT_ID = 6 then ISNULL(SUM(SHE.CashPayoutValue),0) else 0 end as NETCashPayout
    	 FROM SHEXERCISEDOPTIONS SHE		 	  
			 INNER JOIN GRANTLEG GL ON SHE.GrantlegSerialNumber = GL.ID 			  
			 INNER JOIN SCHEME SCHE ON GL.SCHEMEID = SCHE.SCHEMEID 
			 INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID=SHE.MIT_ID
		     INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID = SHE.MIT_ID
         WHERE SHE.EXERCISENO=@ExerciseNo
         GROUP BY SCHE.MIT_ID,SCHE.CALCULATE_TAX
		 , she.ExerciseDate, INS_DISPLY_NAME,she.ExercisedQuantity)X
		 GROUP BY X.ExerciseAmount,X.PerqusiteTax, INS_DISPLY_NAME,X.ExercisedQuantity,X.StockApprValue,x.ShareAriseApprValue,X.NETCashPayout


		 SELECT GL.GrantOptionId, SHE.ExerciseDate, SHE.ExercisedQuantity, ExercisePrice FROM SHEXERCISEDOPTIONS SHE
				JOIN GRANTLEG GL ON SHE.GrantlegSerialNumber = GL.ID 	
		 WHERE EXERCISENO=@ExerciseNo

		 SELECT Tax_Title ,BASISOFTAXATION,PERQVALUE,TENTATIVEPERQVALUE FROM EXERCISE_TAXRATE_DETAILS WHERE EXERCISE_NO = @ExerciseNo
		 

		 
	 SET NOCOUNT OFF;
END
GO


