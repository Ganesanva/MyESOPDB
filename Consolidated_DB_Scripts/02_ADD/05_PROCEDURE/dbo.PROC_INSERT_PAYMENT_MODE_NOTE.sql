/****** Object:  StoredProcedure [dbo].[PROC_INSERT_PAYMENT_MODE_NOTE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERT_PAYMENT_MODE_NOTE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_PAYMENT_MODE_NOTE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_INSERT_PAYMENT_MODE_NOTE]

AS
BEGIN
	 SET NOCOUNT ON;
		
		CREATE TABLE #TEMP_PAYMENT_MODE
		(  
			ID INT IDENTITY(1,1) NOT NULL,
			RP_ID BIGINT,
			MITID BIGINT
		)   
		INSERT INTO #TEMP_PAYMENT_MODE (RP_ID, MITID)
		SELECT Id, MIT_ID
		FROM ResidentialPaymentMode
        WHERE Id NOT IN (SELECT RPMID FROM MST_PAYMENT_MODE_DISCLAIMER) AND isActivated='Y'

				
		DECLARE @MN_VALUE INT, @MX_VALUE INT
		SELECT @MN_VALUE = MIN(ID),@MX_VALUE = MAX(ID) FROM #TEMP_PAYMENT_MODE
		PRINT @MN_VALUE

		WHILE(@MN_VALUE <= @MX_VALUE)
		BEGIN
		     DECLARE @RP_NO AS NVARCHAR(100)
			 DECLARE @INSTRUMENT_NAME AS NVARCHAR(250)
			 DECLARE @MITID AS INT
			 DECLARE @PAYMENTMODE_BASED AS NVARCHAR(250)
			 DECLARE @PAYMENTMODE_RESIDENTIAL AS NVARCHAR(250)

			 SELECT @RP_NO = RP_ID, @MITID = MITID FROM #TEMP_PAYMENT_MODE WHERE ID = @MN_VALUE
			 PRINT @RP_NO

			 SELECT @PAYMENTMODE_BASED = PAYMENTMODE_BASED_ON FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID = @MITID
			 
			 IF(@PAYMENTMODE_BASED = 'rdoResidentStatus')
				BEGIN
					SET @PAYMENTMODE_RESIDENTIAL = 'Resident'
				END
			 ELSE IF(@PAYMENTMODE_BASED = 'rdoCompanyLevel')
				BEGIN
					SET @PAYMENTMODE_RESIDENTIAL = 'Company'
				END
			 ELSE IF(@PAYMENTMODE_BASED = 'rdoCountry')
				BEGIN
					SET @PAYMENTMODE_RESIDENTIAL = 'Country'
				END
			 ELSE 
				BEGIN
					SET @PAYMENTMODE_RESIDENTIAL = ''
				END
			 PRINT @PAYMENTMODE_RESIDENTIAL

			 SELECT @INSTRUMENT_NAME = INSTRUMENT_NAME FROM MST_INSTRUMENT_TYPE WHERE MIT_ID = @MITID

			 INSERT INTO MST_PAYMENT_MODE_DISCLAIMER(RPMID, ActualDisclaimerText, TentativeDisclaimerText, Is_ShowPaymentConfirmRecipt,Is_ShowTaxConfirmRecipt,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON)
			 SELECT RP.Id,
					CASE WHEN(RP.PaymentMaster_Id = 7 OR RP.ResidentialType_Id = 8 OR RP.ResidentialType_Id = 5 OR RP.ResidentialType_Id = 6 OR RP.ResidentialType_Id = 4 OR RP.ResidentialType_Id = 11) 
					     THEN '<p> I agree to make the payment towards the exercise amount and estimated tax into the designated bank accounts of the Company. </p>'
				         WHEN((DYNAMIC_FORM IS NULL OR DYNAMIC_FORM = 1048) AND RP.PaymentMaster_Id = 9) 
						 THEN '<p> I authorize the Trust to sell all the shares, to be allotted to me on exercise of my Indian Equity RSU and remit to me the net sale proceeds after deducting any amount payable and chargeable to me for the transaction. The Trust is also authorized to transfer the amount towards estimated tax to designated bank accounts of the Company.</p>'
						 WHEN((DYNAMIC_FORM IS NULL OR DYNAMIC_FORM = 1048) AND RP.PaymentMaster_Id = 10) 
						 THEN '<p> I authorize the Trust to sell the shares as required to cover the cost of exercise, from the shares to be allotted to me on exercise of my Indian Equity RSU and remit to me the net shares remaining and sale proceeds after deducting any amount payable and chargeable to me for the transaction. The Trust is also authorized to transfer the amount towards estimated tax to designated bank accounts of the Company.</p>'
						 WHEN(DYNAMIC_FORM = 1049 AND RP.PaymentMaster_Id = 9) 
						 THEN '<p> I authorize the designated broker -MSSB to sell all the shares, against the ADR shares to be allotted to me on exercise of shares and remit to me the net sale proceeds after deducting any amount payable and chargeable to me for the transaction. The broker is also authourized to transfer the amount towards exercise amount and estimated tax to designated bank accounts of the Company.</p>'
						 WHEN(DYNAMIC_FORM = 1049 AND RP.PaymentMaster_Id = 10) 
						 THEN '<p> I authorize the designated broker -MSSB to sell the shares as required to cover the cost of exercise, against the ADR shares to be allotted to me on exercise of shares and remit to me the net shares remaining and sale proceeds after deducting any amount payable and chargeable to me for the transaction. The broker is also authourized to transfer the amount towards exercise amount and estimated tax to designated bank accounts of the Company.</p>'
				         WHEN(RP.PaymentMaster_Id = 2)
						 THEN '<p>I confirm to exercise my Equity Share options and agree to make the payment towards the exercise amount and estimated tax into the designated bank accounts of the Company.</p>'
						 WHEN(RP.MIT_ID = 5 OR RP.MIT_ID = 7)
						 THEN '<p>I confirm to exercise my ' + @INSTRUMENT_NAME + 's and shall complete the payment</p>'
					ELSE '<p> Please select the payment mode to activate the check box and proceed further. </p>'
				    END,
					CASE WHEN(RP.PaymentMaster_Id = 2) 
						 THEN '<p>I confirm to exercise my Equity Share options and agree to make the payment towards the exercise amount and estimated tax into the designated bank accounts of the Company.</p>'
					ELSE '<p>I confirm to exercise my ' + @INSTRUMENT_NAME + ' and shall complete the payment and online process as required for valid exercise, once the actual FMV and estimated tax details are available.</p>'

				    END, 0, 0,'ADMIN',GETDATE(),'ADMIN',GETDATE()
			 FROM ResidentialPaymentMode RP
			 INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM
			 ON RP.MIT_ID = CIM.MIT_ID
			 WHERE CIM.IS_ENABLED = 1 AND RP.Id = @RP_NO AND RP.PAYMENT_MODE_CONFIG_TYPE = @PAYMENTMODE_RESIDENTIAL
			 
			
			SET @MN_VALUE = @MN_VALUE + 1

		END
		SELECT DB_NAME() CompanyName, * from #TEMP_PAYMENT_MODE
	 SET NOCOUNT OFF;	
END
GO
