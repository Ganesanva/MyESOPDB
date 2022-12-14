/****** Object:  StoredProcedure [dbo].[PROC_PRINT_EMPLOYEE_MASTER_CASHLESS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PRINT_EMPLOYEE_MASTER_CASHLESS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PRINT_EMPLOYEE_MASTER_CASHLESS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PRINT_EMPLOYEE_MASTER_CASHLESS]
(
	@ExerciseId		VARCHAR(20),
	@EmployeeId		VARCHAR(20),
	@PaymentMode    VARCHAR(20)
)
AS
	BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		EmployeeName, Employeeid, EmployeeAddress, EmployeePhone, EmployeeEmail, Lwd, payrollcountry, Tax_slab,BROKER_ELECT_ACC_NUM 
	FROM 
		EmployeeMaster 
	WHERE 
		LoginId = @EmployeeId AND DELETED = 0;
	
	DECLARE @FaceValue VARCHAR(10)
	DECLARE @RoundupPlace_ExerciseAmount as integer, @RoundFMV AS INTEGER, @RoundTax AS INTEGER, @RoundTaxable AS INTEGER, @Query AS VARCHAR(7000) 
 
	
	SELECT @RoundupPlace_ExerciseAmount=RoundupPlace_ExerciseAmount,
		@RoundFMV = cp.RoundupPlace_FMV, @RoundTax = cp.RoundupPlace_TaxAmt, @RoundTaxable = cp.RoundupPlace_TaxableVal ,@FaceValue= ISNULL(FaceVaue,0)
	FROM 
		CompanyParameters cp  
	
	SET @Query='SELECT grantregistration.schemeid AS schemename, grantregistration.grantdate AS grantdate, (SELECT Sum(GL.grantedoptions) FROM   grantleg GL WHERE  GL.grantoptionid = grantleg.grantoptionid) AS optionsgranted,  
			Sum(shexercisedoptions.exercisedquantity) AS optionsexercised, grantregistration.ExercisePrice AS exerciseprice,  
            CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SHEXERCISEDOPTIONS.TentativeFMVPrice 
		AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))ELSE CAST(SHEXERCISEDOPTIONS.FMVPRICE AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))END AS FMV, 
		
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SHEXERCISEDOPTIONS.TentativeSettlmentPrice AS NUMERIC(18,2))ELSE CAST(SHEXERCISEDOPTIONS.SETTLMENTPRICE AS NUMERIC(18,2))END AS SETTLEMENTPRICE,
		   
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstValue) 
		AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) ELSE CAST(SUM(SHEXERCISEDOPTIONS.PERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+'))
		 END AS PERQVALUE,  
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(CAST(SUM(SHE.TentativePerqstValue)  AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')),
		CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstPayable) 
	    AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+'))) ELSE ISNULL(CAST(SUM(SHE.PERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')),
		CAST(SUM(SHEXERCISEDOPTIONS.PERQSTPAYABLE)  AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+'))) END AS PERQTAX, 
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativeStockApprValue)  AS NUMERIC(18,2)) ELSE CAST(SUM(SHEXERCISEDOPTIONS.StockApprValue)  AS NUMERIC(18,2)) END AS StockApprValue,  
	    SHEXERCISEDOPTIONS.EXERCISENO, CASE WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 AND SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN SUM(ISNULL(SHEXERCISEDOPTIONS.TentShareAriseApprValue,SHEXERCISEDOPTIONS.ShareAriseApprValue) * '+@FaceValue+' )
		WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 AND SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(ISNULL(SHEXERCISEDOPTIONS.ShareAriseApprValue,0) * '+@FaceValue+' )
		ELSE  CAST((SUM(SHEXERCISEDOPTIONS.EXERCISEDQUANTITY) * ShExercisedOptions.EXERCISEPRICE) AS DECIMAL(38,'+CONVERT(VARCHAR,@RoundupPlace_ExerciseAmount)+')) END AS EXERCISEAMOUNT, 
		grantleg.vestingdate AS VestingDate, Max(shexercisedoptions.exercisedate) as exercisedate,CASE WHEN grantregistration.ExercisePriceINR IS NULL THEN 0 ELSE 1 END AS  ExerciseINRFlag 
        FROM   shexercisedoptions 
        INNER JOIN grantleg ON grantleg.id = shexercisedoptions.grantlegserialnumber
        INNER JOIN grantregistration ON grantleg.grantregistrationid = grantregistration.grantregistrationid
		INNER JOIN SCHEME AS SCHE ON GRANTLEG.SCHEMEID=SCHE.SCHEMEID
        LEFT JOIN ShExercisedOptions_Exception AS SHE ON shexercisedoptions.ExerciseId = SHE.ExerciseId
        WHERE  ( shexercisedoptions.exerciseno = '+@ExerciseId+' ) GROUP  BY SHE.TentativePerqstValue,SHE.PERQSTVALUE,grantregistration.grantregistrationid, grantregistration.schemeid, grantregistration.grantdate, shexercisedoptions.exercisepriceINR, shexercisedoptions.exerciseprice,grantregistration.exercisepriceINR, grantregistration.exerciseprice, shexercisedoptions.fmvprice, 
        shexercisedoptions.exerciseno, grantleg.vestingdate, grantleg.grantoptionid , shexercisedoptions.TentativeFMVPrice, shexercisedoptions.TentativePerqstValue, shexercisedoptions.TentativePerqstPayable,shexercisedoptions.MIT_ID,SHEXERCISEDOPTIONS.CALCULATE_TAX,SHEXERCISEDOPTIONS.SETTLMENTPRICE , SHEXERCISEDOPTIONS.CashPayoutValue,shexercisedoptions.TentativeSettlmentPrice,SHEXERCISEDOPTIONS.TentativeCashPayoutValue' 

            EXEC (@Query); 
            
            SELECT 
				[ExerciseNo], [EmployeeName], [BankName], [BankBranchName], [BankBranchAddress], [BankAccountNo], TypeOfBankAc.TypeOfBankAcName AS AccountType,
				[IFSCCode], [IBANNo], [DPRecord], [DepositoryName], [DematAcType], [DPName], [DPId], [ClientId], 
				[PanNumber], [Nationality], transactiondetails_cashless.[residentialstatus], [Location], [MobileNumber], 
				[LastUpdatedBy], [lastUpdatedOn], [ActionType], [CountryCode], [STATUS], [CorrespondentBankName], [CorrespondentBankAddress], 
				[CorrespondentBankAccNo], [CorrespondentBankSwiftCodeABA], SecondaryEmailID, CountryMaster.CountryName 
            FROM 
				TransactionDetails_CashLess 
				INNER JOIN TypeOfBankAc ON transactiondetails_cashless.accounttype = TypeOfBankAc.TypeOfBankAcID
				LEFT OUTER JOIN CountryMaster ON TransactionDetails_CashLess.CountryName = CountryMaster.CountryAliasName 
			WHERE 
				(ExerciseNo = @ExerciseId)  
            
			SELECT 
				residentialpaymentmode.exerciseformtext1, residentialpaymentmode.exerciseformtext2, residentialpaymentmode.exerciseformtext3 
			FROM 
				residentialpaymentmode 
				INNER JOIN residentialtype ON residentialpaymentmode.residentialtype_id = residentialtype.id 
				INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id 
			WHERE
				paymentmaster.paymentmode = @EmployeeId AND residentialtype.residentialstatus = (SELECT distinct transactiondetails_cashless.residentialstatus FROM transactiondetails_cashless WHERE transactiondetails_cashless.exerciseno = @ExerciseId) 
            
            DECLARE @Resd_Status VARCHAR(1) 

            SELECT @Resd_Status = (SELECT distinct transactiondetails_cashless.residentialstatus FROM transactiondetails_cashless WHERE transactiondetails_cashless.exerciseno = @ExerciseId ) 
            
			IF( ( @Resd_Status = 'R' ) OR ( @Resd_Status = '' ) OR ( @Resd_Status IS NULL ) ) 
				SELECT riperqvalue AS calperqvalue, riperqtax   AS calperqtax FROM   companyparameters 
			IF( @Resd_Status = 'N' ) 
				SELECT nriperqvalue AS calperqvalue, nriperqtax   AS calperqtax FROM   companyparameters 
            IF( @Resd_Status = 'F' ) 
				SELECT fnperqvalue AS calperqvalue, fnperqtax   AS calperqtax FROM   companyparameters;

		SELECT 
			CM.CompanyName, CM.CompanyAddress, CP.ExcersiseFormText1, CP.ExcersiseFormText2, CP.FBTPayBy 
		FROM 
			CompanyMaster AS CM
			INNER JOIN CompanyParameters AS CP ON CP.CompanyID = CM.CompanyID
			
	SET NOCOUNT OFF;
END
GO
