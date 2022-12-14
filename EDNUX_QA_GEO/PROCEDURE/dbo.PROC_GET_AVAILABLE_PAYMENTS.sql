/****** Object:  StoredProcedure [dbo].[PROC_GET_AVAILABLE_PAYMENTS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_AVAILABLE_PAYMENTS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_AVAILABLE_PAYMENTS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_AVAILABLE_PAYMENTS]
(
	 @LoginID      NVARCHAR(100), 
	 @MIT_ID       INT,
	 @PaymentType  NVARCHAR(MAX)
)
AS
BEGIN
	   SET NOCOUNT ON;			
		
	    DECLARE @PaymentTypeID NVARCHAR(MAX)
	    
	    SET @PaymentTypeID  = CASE WHEN UPPER(@PaymentType) = 'CASH' THEN '3' 
								   WHEN UPPER(@PaymentType) = 'CASH AND CASHLESS' THEN '3,9,10'  
								   WHEN UPPER(@PaymentType) = 'CASHLESS' THEN '9,10' 
						      END	    

		DECLARE @PAYMENTMODE_BASED_ON NVARCHAR(50)
		SELECT @PAYMENTMODE_BASED_ON = PAYMENTMODE_BASED_ON FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID = @MIT_ID		
		

		/*Print @PAYMENTMODE_BASED_ON*/
		IF(UPPER(@PAYMENTMODE_BASED_ON)=UPPER('RDOCOUNTRY'))
		BEGIN
			/*Print 'RDOCOUNTRY'*/
			DECLARE  @Emp_ID NVARCHAR 
			DECLARE @Country_ID NVARCHAR(50)
			SELECT @Emp_ID=EmployeeID FROM EmployeeMaster
			WHERE LoginID=@LoginID
			
			SELECT @EMP_ID=EmployeeID FROM EmployeeMaster
			WHERE LoginID=@LoginID	
			IF EXISTS(SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@LoginID AND UPPER(Field) =UPPER('Tax Identifier Country'))
			BEGIN
				SELECT @Country_ID=ID FROM CountryMaster
				WHERE CountryName in(SELECT top(1) [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@LoginID AND UPPER(Field) =UPPER('Tax Identifier Country') ORDER BY SRNO DESC )		
			END
			ELSE
			BEGIN					
				SELECT @Country_ID=ID FROM CountryMaster
				WHERE CountryAliasName in(SELECT CountryName FROM EmployeeMaster WHERE EmployeeId=@LoginID )		
			END
		
			/*print 'countryID'*/
			
		
			SELECT isnull(pm1.seqno,0) AS seqno, rp.Id, CASE WHEN pm2.PayModeName IS NULL THEN pm1.PayModeName ELSE pm2.PayModeName +  '-' + CASE WHEN pm1.PayModeName = 'Sell Partial' THEN 'Sell To Cover' WHEN pm1.PayModeName = 'Direct Debit' THEN 'Payroll dedcuction' ELSE  pm1.PayModeName END END AS PaymentModes, pm1.id AS PaymentID 
			FROM residentialpaymentmode rp 
				 INNER JOIN COUNTRY_PAYMENTMODE_MAPPING CPM ON CPM.RPM_ID=rp.id AND CPM.COUNTRY_ID=@Country_ID AND (rp.isactivated = 'Y' OR rp.PaymentMaster_Id in (SELECT * FROM FN_SPLIT_STRING(@PaymentTypeID, ','))) AND rp.MIT_ID=@MIT_ID
				 INNER JOIN paymentmaster pm1  ON (pm1.id = rp.paymentmaster_id)
				 LEFT OUTER JOIN paymentmaster pm2 ON (pm2.id = pm1.parentid) AND (pm2.isenable = 'Y') 
			WHERE MIT_ID = @MIT_ID AND isActivated = 'Y' And  CPM.ACTIVE=1  AND  CPM.COUNTRY_ID=@Country_ID AND PAYMENT_MODE_CONFIG_TYPE = CASE WHEN @PAYMENTMODE_BASED_ON = 'rdoResidentStatus' THEN 'Resident' 
																							 WHEN @PAYMENTMODE_BASED_ON = 'rdoCompanyLevel' THEN 'Company'  
																							 WHEN @PAYMENTMODE_BASED_ON = 'rdoCountry' THEN 'Country' 
																						END																						
																						
		

		END
		ELSE
		BEGIN

			/*Print 'NO RDOCOUNTRY'*/
			SELECT pm1.seqno, rp.Id, CASE WHEN pm2.PayModeName IS NULL THEN pm1.PayModeName ELSE pm2.PayModeName +  '-' + CASE WHEN pm1.PayModeName = 'Sell Partial' THEN 'Sell To Cover' WHEN pm1.PayModeName = 'Direct Debit' THEN 'Payroll dedcuction' ELSE  pm1.PayModeName END END AS PaymentModes, pm1.id AS PaymentID 
			FROM residentialpaymentmode rp 
				 INNER JOIN residentialtype rt ON (rp.residentialtype_id = rt.id) AND (rp.isactivated = 'Y' OR rp.PaymentMaster_Id in (SELECT * FROM FN_SPLIT_STRING(@PaymentTypeID, ',')))
				 INNER JOIN employeemaster em  ON (rt.residentialstatus = em.residentialstatus) AND (loginid = @LoginID)  AND (Deleted <> 1)
				 INNER JOIN paymentmaster pm1  ON (pm1.id = rp.paymentmaster_id)
				 LEFT OUTER JOIN paymentmaster pm2 ON (pm2.id = pm1.parentid) AND (pm2.isenable = 'Y') 
			WHERE MIT_ID = @MIT_ID AND isActivated = 'Y' AND PAYMENT_MODE_CONFIG_TYPE = CASE WHEN @PAYMENTMODE_BASED_ON = 'rdoResidentStatus' THEN 'Resident' 
																							 WHEN @PAYMENTMODE_BASED_ON = 'rdoCompanyLevel' THEN 'Company'  
																							 WHEN @PAYMENTMODE_BASED_ON = 'rdoCountry' THEN 'Country' 
																						END
		END
		
		
		
	   SET NOCOUNT OFF;	
END
GO
