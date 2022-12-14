/****** Object:  StoredProcedure [dbo].[PROC_PRINT_EXERCISE_FORM_OFFLINE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PRINT_EXERCISE_FORM_OFFLINE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PRINT_EXERCISE_FORM_OFFLINE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_PRINT_EXERCISE_FORM_OFFLINE]
(
	@USER_ID		VARCHAR(20),
	@Exercise_No	VARCHAR(10)	
)
 AS
 BEGIN
	SET NOCOUNT ON;

	SELECT EM.PANNumber,EM.employeename,EM.employeeid, EM.employeeaddress, EM.employeephone, EM.employeeemail, EM.Location, EM.Nationality,
	 EM.lwd,EM.AccountNo, EM.payrollcountry, EM.Tax_slab,EM.BROKER_ELECT_ACC_NUM ,TC.BankName,TC.BankBranchName,TC.BankBranchAddress,TC.BankAccountNo,
	(SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = TC.AccountType) AS AccountType,TC.IFSCCode,
	TC.DPRecord,TC.DepositoryName,TC.DematAcType,TC.DPName AS DepositoryParticipantName,TC.DPId AS DpIdNo,TC.ClientId AS ClientNo
	FROM employeemaster EM left join shexercisedOptions EO on EM.EmployeeID = EO.EmployeeID left join TransactionDetails_CashLess TC on EO.ExerciseNo = TC.ExerciseNo
	WHERE  em.LoginId = @USER_ID AND EO.ExerciseNo = @Exercise_No AND EM.DELETED = 0;

	--SELECT PANNumber,employeename,employeeid, employeeaddress, employeephone, employeeemail, lwd,AccountNo, 
	--payrollcountry, Tax_slab,BROKER_ELECT_ACC_NUM 
	--FROM 
	--	employeemaster 
	--WHERE  LoginId = @USER_ID  AND DELETED = 0; 

	DECLARE @Nationality VARCHAR(100)
	DECLARE @Location VARCHAR(100)
	DECLARE @CountryName VARCHAR(100)
	DECLARE @residentialstatus VARCHAR(100)


	SELECT  @Location=EM.Location, @Nationality=EM.Nationality,
	@CountryName=CountryMaster.CountryName,@residentialstatus=EM.ResidentialStatus
	FROM employeemaster EM 
	left join shexercisedOptions EO on EM.EmployeeID = EO.EmployeeID 
	LEFT JOIN CountryMaster on EM.CountryName=CountryMaster.CountryAliasName 
	WHERE  em.LoginId = @USER_ID AND EO.ExerciseNo = @Exercise_No AND EM.DELETED = 0;

	 
	DECLARE @FaceValue VARCHAR(10)
	Declare @RoundupPlace_ExerciseAmount as integer,@RoundFMV as integer,@RoundTax as integer,@RoundTaxable as integer,@Query as Nvarchar(max)

	SELECT 
		@RoundupPlace_ExerciseAmount=RoundupPlace_ExerciseAmount,@RoundFMV=cp.RoundupPlace_FMV,@RoundTax=cp.RoundupPlace_TaxAmt,@RoundTaxable=cp.RoundupPlace_TaxableVal ,@FaceValue=FaceVaue
	FROM 
		CompanyParameters cp  
		SET @Query='SELECT	GRANTREGISTRATION.SCHEMEID AS SCHEMENAME,GRANTREGISTRATION.GRANTDATE AS GRANTDATE,  
		(SELECT SUM(GL.GRANTEDOPTIONS) FROM   GRANTLEG GL WHERE  GL.GRANTOPTIONID = GRANTLEG.GRANTOPTIONID) 
		AS OPTIONSGRANTED,   SUM(SHEXERCISEDOPTIONS.EXERCISEDQUANTITY) AS OPTIONSEXERCISED,
		SUM(SHEXERCISEDOPTIONS.EXERCISEDQUANTITY) AS SharedOptionsExercised,
		ShExercisedOptions.EXERCISEPRICE, 	
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SHEXERCISEDOPTIONS.TentativeFMVPrice	AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN CAST(SHEXERCISEDOPTIONS.TentativeFMVPrice	AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))
		ELSE CAST(SHEXERCISEDOPTIONS.FMVPRICE AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundFMV)+'))END AS FMV, 		
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(isnull(SHEXERCISEDOPTIONS.TentativeSettlmentPrice ,0)AS NUMERIC(18,2))
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN CAST(isnull(SHEXERCISEDOPTIONS.TentativeSettlmentPrice,0) AS NUMERIC(18,2))
		ELSE CAST(isnull(SHEXERCISEDOPTIONS.SETTLMENTPRICE,0) AS NUMERIC(18,2))END AS SETTLEMENTPRICE,		   
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstValue) 
		AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) 
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstValue) 
		AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) 
		ELSE CAST(SUM(SHEXERCISEDOPTIONS.PERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+'))
		 END AS PERQVALUE,  
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN ISNULL(CAST(SUM(SHE.TentativePerqstValue)  AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')),
		CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstPayable) AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')))
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN ISNULL(CAST(SUM(SHE.TentativePerqstValue)  AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')),
		CAST(SUM(SHEXERCISEDOPTIONS.TentativePerqstPayable) 
	    AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')))
		ELSE ISNULL(CAST(SUM(SHE.PERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+')),
		CAST(SUM(SHEXERCISEDOPTIONS.PERQSTPAYABLE)  AS NUMERIC(18,'+CONVERT(VARCHAR,@RoundTax)+'))) END AS PERQTAX, 
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' 
		THEN CAST(SUM(isnull(SHEXERCISEDOPTIONS.TentShareAriseApprValue,0))  AS NUMERIC(18,0))
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' 
		THEN CAST(SUM(isnull(SHEXERCISEDOPTIONS.TentShareAriseApprValue,0))  AS NUMERIC(18,0))
		ELSE CAST(SUM (ISNULL(SHEXERCISEDOPTIONS.ShareAriseApprValue,0))  AS NUMERIC(18,0)) END AS ShareAriseApprValue,  
		CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' 
		THEN CAST(SUM(isnull(SHEXERCISEDOPTIONS.TentativeStockApprValue,0))  AS NUMERIC(18,2))
		WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' 
		THEN CAST(SUM(isnull(SHEXERCISEDOPTIONS.TentativeStockApprValue,0))  AS NUMERIC(18,2))
		ELSE CAST(SUM (ISNULL(SHEXERCISEDOPTIONS.StockApprValue,0))  AS NUMERIC(18,2)) END AS StockApprValue,
	    SHEXERCISEDOPTIONS.EXERCISENO, 					    
	    CASE WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 AND SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN SUM(ISNULL(SHEXERCISEDOPTIONS.TentShareAriseApprValue,SHEXERCISEDOPTIONS.ShareAriseApprValue) * '+@FaceValue+' )
				WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 AND SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN SUM(ISNULL(SHEXERCISEDOPTIONS.TentShareAriseApprValue,SHEXERCISEDOPTIONS.ShareAriseApprValue) * '+@FaceValue+' )
				   WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 AND SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' THEN SUM(ISNULL(SHEXERCISEDOPTIONS.ShareAriseApprValue,0) * '+@FaceValue+' )
			 ELSE  CAST((SUM(SHEXERCISEDOPTIONS.EXERCISEDQUANTITY) * ShExercisedOptions.EXERCISEPRICE) AS DECIMAL(38,'+CONVERT(VARCHAR,@RoundupPlace_ExerciseAmount)+')) END AS EXERCISEAMOUNT,
	    MAX(SHEXERCISEDOPTIONS.EXERCISEDATE)   AS EXERCISEDATE,   GRANTLEG.FINALVESTINGDATE AS VESTINGDATE,  
	    CASE WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoActualTax'' AND ISNULL(SHEXERCISEDOPTIONS.PaymentMode,'''')='''' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativePERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) WHEN SHEXERCISEDOPTIONS.CALCULATE_TAX = ''rdoTentativeTax'' THEN CAST(SUM(SHEXERCISEDOPTIONS.TentativePERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) ELSE CAST(SUM(SHEXERCISEDOPTIONS.PERQSTVALUE) AS NUMERIC(18,'+CONVERT(VARCHAR,@ROUNDTAXABLE)+')) END AS PAYOUTAMOUNT,  
	    0 AS GROSSPAYOUTAMOUNT,CASE WHEN GRANTREGISTRATION.ExercisePriceINR IS NULL THEN 0 ELSE 1 END AS  ExerciseINRFlag,
		 CASE WHEN SHEXERCISEDOPTIONS.MIT_ID = 6 THEN
		 SUM(CONVERT(DECIMAL(10,2),SHEXERCISEDOPTIONS.CashPayoutValue))
		 ELSE 
		 SUM(ISNULL(SHEXERCISEDOPTIONS.StockApprValue,0)-ISNULL(SHEXERCISEDOPTIONS.PERQSTPAYABLE,0)) END
		  AS CashPayoutValue,
		ISNULL(TAX_SEQUENCENO,0) AS TAX_SEQUENCENO 
	    FROM	SHEXERCISEDOPTIONS        INNER JOIN GRANTLEG          
	    ON GRANTLEG.ID = SHEXERCISEDOPTIONS.GRANTLEGSERIALNUMBER      
	    INNER JOIN GRANTREGISTRATION          ON GRANTLEG.GRANTREGISTRATIONID = GRANTREGISTRATION.GRANTREGISTRATIONID 
	    INNER JOIN SCHEME AS SCHE ON GRANTLEG.SCHEMEID=SCHE.SCHEMEID
        LEFT JOIN ShExercisedOptions_Exception AS SHE ON shexercisedoptions.ExerciseId = SHE.ExerciseId	      
	    WHERE  ( SHEXERCISEDOPTIONS.EXERCISENO = '+@Exercise_No +')  GROUP  BY
	    ShExercisedOptions.EXERCISEPRICEINR,ShExercisedOptions.EXERCISEPRICE,GRANTREGISTRATION.EXERCISEPRICEINR,SHE.TentativePerqstValue,SHE.PERQSTVALUE,GRANTREGISTRATION.GRANTREGISTRATIONID,      
	    GRANTREGISTRATION.SCHEMEID, GRANTREGISTRATION.GRANTDATE, ISNULL(ShExercisedOptions.PaymentMode,''''),  GRANTREGISTRATION.EXERCISEPRICE, 
	    SHEXERCISEDOPTIONS.FMVPRICE, SHEXERCISEDOPTIONS.TentativeSettlmentPrice,SHEXERCISEDOPTIONS.SETTLMENTPRICE,
		     SHEXERCISEDOPTIONS.EXERCISENO, GRANTLEG.GRANTOPTIONID, 
	    GRANTLEG.FINALVESTINGDATE, SHEXERCISEDOPTIONS.TentativeFMVPrice, SHEXERCISEDOPTIONS.TentativePerqstValue,
	    SHEXERCISEDOPTIONS.MIT_ID,SHEXERCISEDOPTIONS.CALCULATE_TAX,GRANTLEG.FINALVESTINGDATE, SHEXERCISEDOPTIONS.TentativeFMVPrice, SHEXERCISEDOPTIONS.TentativePerqstValue,
	    SHEXERCISEDOPTIONS.MIT_ID,SHEXERCISEDOPTIONS.CALCULATE_TAX,SHEXERCISEDOPTIONS.SETTLMENTPRICE , SHEXERCISEDOPTIONS.CashPayoutValue,ISNULL(TAX_SEQUENCENO,0)
		ORDER BY TAX_SEQUENCENO '
	    
	    exec (@Query);

		
		  PRINT  (@Query);

		Declare @CID NVARCHAR(50)
		SET @CID=''
		DECLARE @Resd_Status VARCHAR(1)
		Select @CID=CompanyID  From CompanyMaster
		Print @CID
		IF(UPPER(@CID)='INFOSYS1')
		BEGIN
			Print 'Step1'
			--SELECT shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, shtransactiondetails.nationality,  shtransactiondetails.location, shtransactiondetails.ibanno, shtransactiondetails.paymentnameex as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq, shtransactiondetails.perqamt_drownondate as CheckDatePq, shtransactiondetails.dprecord, shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, shtransactiondetails.accountno, shtransactiondetails.exerciseno, shtransactiondetails.clientno, shtransactiondetails.depositoryparticipantname, shtransactiondetails.dpidno, shtransactiondetails.depositoryname, shtransactiondetails.dematactype, shtransactiondetails.residentialstatus, shtransactiondetails.pannumber, shtransactiondetails.ibannopq, shtransactiondetails.drawnon as CheckDateEx, shtransactiondetails.bankname as BankNameEx, shtransactiondetails.FathersName, CountryMaster.countryname,  shtransactiondetails.Branch, shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.ExAmtTypOfBnkAC) as ExAmtTypOfBnkAC, shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, shexercisedoptions.Cash, shtransactiondetails.COST_CENTER, shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME, shtransactiondetails.BROKER_DEP_TRUST_CMP_ID, shtransactiondetails.BROKER_ELECT_ACC_NUM  FROM   shexercisedoptions  INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno  LEFT OUTER JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName  WHERE  shtransactiondetails.exerciseno = @Exercise_No; 
			
			SELECT distinct shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, 
			CASE WHEN (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.Nationality WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')Then TC.Nationality WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.Nationality is not null)Then TC.Nationality  else '' END As Nationality,
			CASE WHEN (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.residentialstatus WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')Then TC.residentialstatus WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.residentialstatus is not null)Then TC.residentialstatus   else @residentialstatus END As residentialstatus,
			CASE WHEN (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.location WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')Then TC.Location WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.Location is not null)Then TC.Location   else '' END As location,
			 shtransactiondetails.ibanno, TD.BankReferenceNo as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq, TD.Transaction_Date as CheckDatePq, TD.Amount AS ExAmountPayble,TD.Tax_Amount AS TaxPayable,
			CASE WHEN (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.dprecord WHEN (shexercisedoptions.PaymentMode='P')Then TC.DPRecord WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPRecord is not null)Then TC.DPRecord   else '' END As DPRecord,
			CASE when (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.DepositoryName WHEN (shexercisedoptions.PaymentMode='P')Then  TC.DepositoryName WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DepositoryName is not null)Then TC.DepositoryName else '' END As DepositoryName,
			CASE when (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.DematAcType  WHEN (shexercisedoptions.PaymentMode='P')Then TC.DematAcType WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DematAcType is not null)Then TC.DematAcType  else '' END As DematAcType,
			CASE when (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.DepositoryParticipantName WHEN (shexercisedoptions.PaymentMode='P') Then TC.DPName WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPName is not null) THEN TC.DPName  else '' END As DepositoryParticipantName,
			CASE when (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.DPIDNo WHEN (shexercisedoptions.PaymentMode='P') Then TC.DPId WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPId is not null) THEN TC.DPId else '' END As DpIdNo,
			CASE when (shexercisedoptions.PaymentMode='N')Then shtransactiondetails.ClientNo WHEN (shexercisedoptions.PaymentMode='P') Then TC.ClientId WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.ClientId is not null) THEN TC.ClientId  else '' END As ClientNo,
			shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, shtransactiondetails.accountno, shtransactiondetails.exerciseno,shtransactiondetails.IbanNo,
			TC.BankName,TC.BankBranchName,TC.BankBranchAddress,TC.BankAccountNo,(SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = TC.AccountType) AS AccountType,TC.IFSCCode,
			TC.IBANNo,shtransactiondetails.pannumber, shtransactiondetails.IbanNopq, shtransactiondetails.drawnon as CheckDateEx, shtransactiondetails.bankname as BankNameEx, 
			--shtransactiondetails.FathersName, 
			CountryMaster.countryname,  shtransactiondetails.Branch, shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = TD.bankid) as ExAmtTypOfBnkAC, shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber, 
			(select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, shexercisedoptions.Cash, shtransactiondetails.COST_CENTER, shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME, shtransactiondetails.BROKER_DEP_TRUST_CMP_ID, shtransactiondetails.BROKER_ELECT_ACC_NUM  
			
			FROM   shexercisedoptions  LEFT JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno 
			LEFT JOIN Transaction_Details TD ON shexercisedoptions.exerciseno = TD.Sh_ExerciseNo 
			LEFT join TransactionDetails_CashLess TC on shexercisedoptions.ExerciseNo = TC.ExerciseNo 
			LEFT JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName 
			WHERE  shexercisedoptions.exerciseno = @Exercise_No

			SELECT residentialpaymentmode.exerciseformtext1, residentialpaymentmode.exerciseformtext2 ,residentialpaymentmode.exerciseformtext3 FROM   residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)   
			SELECT @Resd_Status = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE  shtransactiondetails.exerciseno = @Exercise_No) IF( ( @Resd_Status = 'R' ) OR ( @Resd_Status = '' ) OR ( @Resd_Status IS NULL ) ) 	SELECT RIPERQVALUE AS CALPERQVALUE,  RIPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'N' )   SELECT NRIPERQVALUE AS CALPERQVALUE,  NRIPERQTAX   AS CALPERQTAX , P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'F' )  SELECT FNPERQVALUE AS CALPERQVALUE,  FNPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P SELECT residentialpaymentmode.ADS_EX_FORM_TEXT_1, residentialpaymentmode.ADS_EX_FORM_TEXT_2 FROM residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No) AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)
		END
		ELSE 
		BEGIN
			Print 'Step2';
			--SELECT shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, shtransactiondetails.nationality,  
			--shtransactiondetails.location, shtransactiondetails.ibanno, 
			--shtransactiondetails.paymentnameex as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq,
			-- shtransactiondetails.perqamt_drownondate as CheckDatePq, shtransactiondetails.dprecord, 
			-- shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, 
			-- shtransactiondetails.accountno, shtransactiondetails.exerciseno, shtransactiondetails.clientno, 
			-- shtransactiondetails.depositoryparticipantname, shtransactiondetails.dpidno, shtransactiondetails.depositoryname,
			--  shtransactiondetails.dematactype, shtransactiondetails.residentialstatus, shtransactiondetails.pannumber, 
			--  shtransactiondetails.ibannopq, shtransactiondetails.drawnon as CheckDateEx, shtransactiondetails.bankname as BankNameEx,
			--   shtransactiondetails.FathersName, CountryMaster.countryname,  shtransactiondetails.Branch, 
			--   shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc 
			--   where TypeOfBankAcID = shtransactiondetails.ExAmtTypOfBnkAC) as ExAmtTypOfBnkAC, 
			--   shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber,
			--    (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, 
			--	shexercisedoptions.Cash, shtransactiondetails.COST_CENTER, shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME,
			--	 shtransactiondetails.BROKER_DEP_TRUST_CMP_ID, shtransactiondetails.BROKER_ELECT_ACC_NUM  
			--	 FROM   shexercisedoptions  
			--	 INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno 
			--	 LEFT OUTER JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName  
			--	 LEFT JOIN Transaction_Details TD ON shexercisedoptions.exerciseno = TD.Sh_ExerciseNo 
			--     LEFT join TransactionDetails_CashLess TC on shexercisedoptions.ExerciseNo = TC.ExerciseNo 
			--	WHERE  shexercisedoptions.exerciseno = @Exercise_No

			with NoOfOptions_CTE(NoOfOptions,exerciseno)
			As
			(select sum(ExercisedQuantity) as NoOfOptions ,exerciseno from shexercisedoptions 
			WHERE  shexercisedoptions.exerciseno = @Exercise_No group by exerciseno)

			SELECT distinct shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, 
			CASE WHEN (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')
			Then shtransactiondetails.Nationality WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')
			Then TC.Nationality WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.Nationality is not null)Then TC.Nationality  
			else @Nationality END As Nationality,
			
			CASE WHEN (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')
			Then shtransactiondetails.residentialstatus WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')
			Then TC.residentialstatus WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.residentialstatus is not null)
			Then TC.residentialstatus   else @residentialstatus END As residentialstatus,
			
			CASE WHEN (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' 
			or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')
			Then shtransactiondetails.location 
			WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')
			Then TC.Location WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.Location is not null)Then TC.Location   
			else @Location END As location,
			 shtransactiondetails.PaymentNameEX as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq, 
			format(shtransactiondetails.PerqAmt_DrownOndate ,'dd-MMM-yyyy') as CheckDatePq, TD.Amount AS ExAmountPayble,TD.Tax_Amount AS TaxPayable,
			CASE WHEN (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.dprecord WHEN (shexercisedoptions.PaymentMode='P')Then TC.DPRecord WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPRecord is not null)Then TC.DPRecord   else '' END As DPRecord,
			CASE when (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.DepositoryName WHEN (shexercisedoptions.PaymentMode='P')Then  TC.DepositoryName WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DepositoryName is not null)Then TC.DepositoryName else '' END As DepositoryName,
			CASE when (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.DematAcType  WHEN (shexercisedoptions.PaymentMode='P')Then TC.DematAcType WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DematAcType is not null)Then TC.DematAcType  else '' END As DematAcType,
			CASE when (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.DepositoryParticipantName WHEN (shexercisedoptions.PaymentMode='P') Then TC.DPName WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPName is not null) THEN TC.DPName  else '' END As DepositoryParticipantName,
			CASE when (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.DPIDNo WHEN (shexercisedoptions.PaymentMode='P') Then TC.DPId WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.DPId is not null) THEN TC.DPId else '' END As DpIdNo,
			CASE when (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')Then shtransactiondetails.ClientNo 
			WHEN (shexercisedoptions.PaymentMode='P') Then TC.ClientId WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.ClientId is not null) THEN TC.ClientId  else '' END As ClientNo,
			shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, shtransactiondetails.accountno, shtransactiondetails.exerciseno,
			TC.BankName,TC.BankBranchName,TC.BankBranchAddress,TC.BankAccountNo,(SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = TC.AccountType) AS AccountType,TC.IFSCCode,
			Case WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A') then
			TC.IBANNo
			else
			shtransactiondetails.IBANNo end as IBANNo,
			shtransactiondetails.pannumber, shtransactiondetails.ibannopq, format(shtransactiondetails.drawnon ,'dd-MMM-yyyy')as CheckDateEx, shtransactiondetails.bankname as BankNameEx, 
			--shtransactiondetails.FathersName,
			
			CASE WHEN (shexercisedoptions.PaymentMode='N' or shexercisedoptions.PaymentMode='Q' 
			or shexercisedoptions.PaymentMode='D' 
			or  shexercisedoptions.PaymentMode='I' or shexercisedoptions.PaymentMode='R' or shexercisedoptions.PaymentMode='W')
			Then CountryMaster.CountryName 
			WHEN (shexercisedoptions.PaymentMode='P' OR shexercisedoptions.PaymentMode='A')
			Then TCCM.CountryName
			WHEN (ISNULL(shexercisedoptions.PaymentMode,'')='' AND TC.Location is not null)Then TDCM.CountryName  
			else @CountryName END As CountryName,  
			 
			 shtransactiondetails.Branch, shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = TD.bankid) as ExAmtTypOfBnkAC, shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber, 
			(select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, shexercisedoptions.Cash, 
			shtransactiondetails.COST_CENTER, 

			Case WHEN (shexercisedoptions.PaymentMode='P') then 
			 TC.BROKER_DEP_TRUST_CMP_NAME 
			else 
			  shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME end as BROKER_DEP_TRUST_CMP_NAME,

			  Case WHEN (shexercisedoptions.PaymentMode='P') then 
			 TC.BROKER_DEP_TRUST_CMP_ID 
			else 
			  shtransactiondetails.BROKER_DEP_TRUST_CMP_ID end as BROKER_DEP_TRUST_CMP_ID,

			    Case WHEN (shexercisedoptions.PaymentMode='P') then 
			 TC.BROKER_ELECT_ACC_NUM 
			else 
			  shtransactiondetails.BROKER_ELECT_ACC_NUM end as BROKER_ELECT_ACC_NUM,
			  Case WHEN (shexercisedoptions.PaymentMode='N') then
TD.UniqueTransactionNo
else
'' end as UniqueTransactionNoex,
Case WHEN (shexercisedoptions.PaymentMode='N') then
TD.UniqueTransactionNo
else
'' end as UniqueTransactionNopq,NoOfOptions_CTE.NoOfOptions
			
			FROM   shexercisedoptions  LEFT JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno 
			LEFT JOIN Transaction_Details TD ON  TD.Sh_ExerciseNo  = shexercisedoptions.exerciseno
			LEFT join TransactionDetails_CashLess TC on shexercisedoptions.ExerciseNo = TC.ExerciseNo 
			LEFT JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName 
			LEFT JOIN CountryMaster TDCM on TD.CountryName=TDCM.CountryAliasName 
			LEFT JOIN CountryMaster TCCM on TC.CountryName=TCCM.CountryAliasName 
			LEfT JOIN NoOfOptions_CTE  on NoOfOptions_CTE.ExerciseNo = shexercisedoptions.exerciseno
			WHERE  shexercisedoptions.exerciseno = @Exercise_No
			
		
			SELECT residentialpaymentmode.exerciseformtext1, residentialpaymentmode.exerciseformtext2 ,residentialpaymentmode.exerciseformtext3 FROM   residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)   
			SELECT @Resd_Status = (SELECT distinct shtransactiondetails.residentialstatus 
			FROM   shexercisedoptions 
			INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE  shtransactiondetails.exerciseno = @Exercise_No) IF( ( @Resd_Status = 'R' ) OR ( @Resd_Status = '' ) OR ( @Resd_Status IS NULL ) ) 	SELECT RIPERQVALUE AS CALPERQVALUE,  RIPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'N' )   SELECT NRIPERQVALUE AS CALPERQVALUE,  NRIPERQTAX   AS CALPERQTAX , P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'F' )  SELECT FNPERQVALUE AS CALPERQVALUE,  FNPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P SELECT residentialpaymentmode.ADS_EX_FORM_TEXT_1, residentialpaymentmode.ADS_EX_FORM_TEXT_2 FROM residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No) AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)

			--Print 'Step1'
			----SELECT shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, shtransactiondetails.nationality,  shtransactiondetails.location, shtransactiondetails.ibanno, shtransactiondetails.paymentnameex as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq, shtransactiondetails.perqamt_drownondate as CheckDatePq, shtransactiondetails.dprecord, shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, shtransactiondetails.accountno, shtransactiondetails.exerciseno, shtransactiondetails.clientno, shtransactiondetails.depositoryparticipantname, shtransactiondetails.dpidno, shtransactiondetails.depositoryname, shtransactiondetails.dematactype, shtransactiondetails.residentialstatus, shtransactiondetails.pannumber, shtransactiondetails.ibannopq, shtransactiondetails.drawnon as CheckDateEx, shtransactiondetails.bankname as BankNameEx, shtransactiondetails.FathersName, CountryMaster.countryname,  shtransactiondetails.Branch, shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.ExAmtTypOfBnkAC) as ExAmtTypOfBnkAC, shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, shexercisedoptions.Cash, shtransactiondetails.COST_CENTER, shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME, shtransactiondetails.BROKER_DEP_TRUST_CMP_ID, shtransactiondetails.BROKER_ELECT_ACC_NUM  FROM   shexercisedoptions  INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno  LEFT OUTER JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName  WHERE  shtransactiondetails.exerciseno = @Exercise_No; 
			--SELECT shexercisedoptions.paymentmode, shtransactiondetails.paymentnamepq as CheckNoPerq, shtransactiondetails.nationality,  shtransactiondetails.location, shtransactiondetails.ibanno, TD.BankReferenceNo as CheckNoEx, shtransactiondetails.perqamt_bankname as BankNamePq, TD.Transaction_Date as CheckDatePq, TD.Amount AS ExAmountPayble,TD.Tax_Amount AS TaxPayable,
			--shtransactiondetails.dprecord, shtransactiondetails.perqamt_branch, shtransactiondetails.branch, shtransactiondetails.perqamt_bankaccountnumber, shtransactiondetails.accountno, shtransactiondetails.exerciseno, shtransactiondetails.clientno, shtransactiondetails.depositoryparticipantname, shtransactiondetails.dpidno, shtransactiondetails.depositoryname, shtransactiondetails.dematactype, 
			--shtransactiondetails.residentialstatus, shtransactiondetails.pannumber, shtransactiondetails.ibannopq, shtransactiondetails.drawnon as CheckDateEx, shtransactiondetails.bankname as BankNameEx, shtransactiondetails.FathersName, CountryMaster.countryname,  shtransactiondetails.Branch, shtransactiondetails.AccountNo, (select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = TD.bankid) as ExAmtTypOfBnkAC, shtransactiondetails.PerqAmt_Branch, shtransactiondetails.PerqAmt_BankAccountNumber, 
			--(select TypeOfBankAcName from TypeOfBankAc where TypeOfBankAcID = shtransactiondetails.PeqTxTypOfBnkAC) as PeqTxTypOfBnkAC, shexercisedoptions.Cash, shtransactiondetails.COST_CENTER, shtransactiondetails.BROKER_DEP_TRUST_CMP_NAME, shtransactiondetails.BROKER_DEP_TRUST_CMP_ID, shtransactiondetails.BROKER_ELECT_ACC_NUM  FROM   shexercisedoptions  LEFT JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno LEFT JOIN Transaction_Details TD ON shexercisedoptions.exerciseno = TD.Sh_ExerciseNo LEFT OUTER JOIN CountryMaster on ShTransactionDetails.CountryName=CountryMaster.CountryAliasName WHERE  shtransactiondetails.exerciseno = @Exercise_No

			--SELECT residentialpaymentmode.exerciseformtext1, residentialpaymentmode.exerciseformtext2 ,residentialpaymentmode.exerciseformtext3 FROM   residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)   
			--SELECT @Resd_Status = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE  shtransactiondetails.exerciseno = @Exercise_No) IF( ( @Resd_Status = 'R' ) OR ( @Resd_Status = '' ) OR ( @Resd_Status IS NULL ) ) 	SELECT RIPERQVALUE AS CALPERQVALUE,  RIPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'N' )   SELECT NRIPERQVALUE AS CALPERQVALUE,  NRIPERQTAX   AS CALPERQTAX , P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P IF( @Resd_Status = 'F' )  SELECT FNPERQVALUE AS CALPERQVALUE,  FNPERQTAX   AS CALPERQTAX, P.IS_PERQ_VAL_CALN_REQUIRED AS PUP_CALCPERQVALUE, P.IS_PREQ_TAX_CALN_REQUIRED AS PUP_CALCPERQTAX FROM   COMPANYPARAMETERS, PUP_PARAMETER P SELECT residentialpaymentmode.ADS_EX_FORM_TEXT_1, residentialpaymentmode.ADS_EX_FORM_TEXT_2 FROM residentialpaymentmode INNER JOIN residentialtype  ON residentialpaymentmode.residentialtype_id = residentialtype.id  INNER JOIN paymentmaster ON residentialpaymentmode.paymentmaster_id = paymentmaster.id WHERE  paymentmaster.paymentmode = (SELECT distinct shexercisedoptions.paymentmode FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No) AND residentialtype.residentialstatus = (SELECT distinct shtransactiondetails.residentialstatus FROM   shexercisedoptions INNER JOIN shtransactiondetails ON shexercisedoptions.exerciseno = shtransactiondetails.exerciseno WHERE shtransactiondetails.exerciseno = @Exercise_No)

			SELECT Tax_Title ,BASISOFTAXATION,PERQVALUE,TENTATIVEPERQVALUE FROM EXERCISE_TAXRATE_DETAILS WHERE EXERCISE_NO = @Exercise_No
		END
      
	SET NOCOUNT OFF;
END
GO
