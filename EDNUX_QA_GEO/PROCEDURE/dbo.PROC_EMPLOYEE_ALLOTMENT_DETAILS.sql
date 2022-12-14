/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_ALLOTMENT_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_EMPLOYEE_ALLOTMENT_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_EMPLOYEE_ALLOTMENT_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_EMPLOYEE_ALLOTMENT_DETAILS] (
@EmployeeId VARCHAR(50),
@ExerciseNo INT = NULL,
@MIT_ID INT = NULL

)
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	
	DECLARE @ToDate AS VARCHAR(50)
	DECLARE @OptionGranted AS VARCHAR(50)
	DECLARE @ISLISTED AS CHAR(1) = (SELECT UPPER(ListedYN) FROM CompanyParameters)
	DECLARE @ClosePrice AS NUMERIC(18,2)
	DECLARE @SQL_QUERY AS VARCHAR(MAX)
	DECLARE @WHERE_CONDITION AS VARCHAR(MAX)
	DECLARE @FACEVALUE AS NUMERIC (18,2)
		
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @EmployeeId=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeId AND Deleted=0) 

	SELECT @ToDate = CONVERT(DATE,GETDATE())
	SELECT @FACEVALUE = FaceVaue FROM CompanyParameters
    
    IF (@ISLISTED = 'Y')	
		SET @ClosePrice = (SELECT SharePrices.ClosePrice FROM SharePrices WHERE (SharePrices.PriceDate = (SELECT Max(PriceDate) FROM SharePrices)))
	ELSE
		SET @ClosePrice = (SELECT FMV FROM FMVForUnlisted WHERE (CONVERT(DATE,FMVForUnlisted.FMV_FromDate) <= CONVERT(DATE,@ToDate) AND CONVERT(DATE,FMVForUnlisted.FMV_Todate) >= CONVERT(DATE,@ToDate))) 
		
    -- Insert statements for procedure here
    
    CREATE TABLE #EMPLOYEE_TEMP_OPTION_EXERCISED	
    (	
		EmployeeID NVARCHAR(50), CountryName NVARCHAR(300), ExercisePrice NUMERIC(18,2), Sharesarised NUMERIC(18,2), SARExerciseAmount NUMERIC(18,2), ExercisedId NVARCHAR(50), EmployeeName NVARCHAR(100), 	GrantRegistrationId NVARCHAR(100), GrantOptionId NVARCHAR(100), GrantDate DATETIME , 
		ExercisedQuantity NUMERIC(18,2), SharesAlloted NUMERIC(18,2), ExercisedDate DATETIME, ExercisedPrice NUMERIC(18,2), SchemeTitle NVARCHAR(100),OptionRatioMultiplier NUMERIC(18,2), SchemeId NVARCHAR(100), OptionRatioDivisor NUMERIC(18,2), 
		SharesIssuedDate DATETIME, DateOfPayment DATETIME, Parent NVARCHAR(10), VestingDate DATETIME, GrantLegId NVARCHAR(10), FBTValue NUMERIC(18,2), Cash NVARCHAR(10), SAR_PerqValue NVARCHAR(20), FaceValue NVARCHAR(20), FACE_VALUE NVARCHAR(10), PerqstValue NVARCHAR(20), PerqstPayable NUMERIC(18,6), 
		FMVPrice NVARCHAR(20), FBTdays NVARCHAR(10), TravelDays NVARCHAR(10), PaymentMode NVARCHAR(30), PerqTaxRate NVARCHAR(20), ExerciseNo NVARCHAR(50), Exercise_Amount NVARCHAR(20), Date_of_Payment DATETIME, Account_number NVARCHAR(50), ConfStatus NVARCHAR(50), 
		DateOfJoining DATETIME, DateOfTermination DATETIME, Department NVARCHAR(300), EmployeeDesignation NVARCHAR(300), Entity NVARCHAR(300), Grade NVARCHAR(300), Insider NVARCHAR(300), ReasonForTermination NVARCHAR(300), SBU NVARCHAR(300), ResidentialStatus NVARCHAR(300),
		Itcircle_Wardnumber NVARCHAR(300), DepositoryName NVARCHAR(100), DepositoryParticipatoryname NVARCHAR(100), ConfirmationDate DATETIME, NameAsperDpRecord NVARCHAR(100), EmployeeAddress NVARCHAR(300), EmployeeEmail NVARCHAR(100), 
		EmployeePhone NVARCHAR(100), Pan_Girnumber NVARCHAR(15), DematACType NVARCHAR(50), DpIdNumber NVARCHAR(50), ClientIdNumber NVARCHAR(50), Location NVARCHAR(300), 
		MarketPrice NUMERIC(18,2), IsSARApplied NVARCHAR(10), lotnumber VARCHAR(50), INSTRUMENT_NAME NVARCHAR (50), CurrencyName NVARCHAR (20), CurrencyAlias VARCHAR (20), MIT_ID INT,
		SettlmentPrice NUMERIC(18,6), StockApprValue NUMERIC(18,6), CashPayoutValue NUMERIC(18,6), ShareAriseApprValue NUMERIC(18,6),
		LWD DATETIME,COST_CENTER NVARCHAR(50),	[status] NVARCHAR(50),	BROKER_DEP_TRUST_CMP_ID VARCHAR (500),	BROKER_DEP_TRUST_CMP_NAME NVARCHAR(50),	BROKER_ELECT_ACC_NUM NVARCHAR(50), Country NVARCHAR(50), State NVARCHAR(50), EquivalentShares INT, 
		OptionGranted NUMERIC(18,0), TrustType NVARCHAR(50), LockInPeriod NUMERIC(18,2),GrossPayOutValue NUMERIC(18,6),CALCULATE_TAX NVARCHAR(200)
	)
	
	INSERT INTO #EMPLOYEE_TEMP_OPTION_EXERCISED 
	(
		EmployeeID, INSTRUMENT_NAME, CountryName, ExercisePrice, CurrencyName, Sharesarised, SARExerciseAmount, ExercisedId, EmployeeName, GrantRegistrationId, GrantOptionId, GrantDate, 
		ExercisedQuantity, SharesAlloted, ExercisedDate, ExercisedPrice, SchemeTitle, OptionRatioMultiplier, SchemeId, OptionRatioDivisor, 
		SharesIssuedDate, DateOfPayment, Parent, VestingDate, GrantLegId, FBTValue, Cash, SAR_PerqValue, FaceValue, FACE_VALUE, PerqstValue, PerqstPayable, 
		FMVPrice, FBTdays, TravelDays, PaymentMode, PerqTaxRate, ExerciseNo, Exercise_Amount, Date_of_Payment, Account_number, ConfStatus, 
		DateOfJoining , DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU, ResidentialStatus,
		Itcircle_Wardnumber, DepositoryName, DepositoryParticipatoryname, ConfirmationDate, NameAsperDpRecord, EmployeeAddress, EmployeeEmail, 
		EmployeePhone, Pan_Girnumber, DematACType, DpIdNumber, ClientIdNumber, Location, lotnumber, CurrencyAlias, MIT_ID,
		SettlmentPrice, StockApprValue, CashPayoutValue, ShareAriseApprValue, LWD,COST_CENTER,[status],	BROKER_DEP_TRUST_CMP_ID, BROKER_DEP_TRUST_CMP_NAME, BROKER_ELECT_ACC_NUM, Country, [State], EquivalentShares 

	)
	EXECUTE PROC_CRExerciseReport '1900-01-01', @ToDate, @EmployeeId
	--EXECUTE PROC_CRExerciseReport '1900-01-01', '2018-02-22', '119577'	
	UPDATE TD SET IsSARApplied = GR.Apply_SAR FROM #EMPLOYEE_TEMP_OPTION_EXERCISED AS TD 
	INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = TD.GrantRegistrationId
	
	UPDATE TD SET MarketPrice = @ClosePrice FROM #EMPLOYEE_TEMP_OPTION_EXERCISED AS TD 
	
	UPDATE #EMPLOYEE_TEMP_OPTION_EXERCISED 
	SET OptionGranted = GOP.GrantedOptions, LockInPeriod = SC.LockInPeriod, TrustType=(CASE WHEN SC.TrustType ='N' THEN 0 ELSE 1 END)
	FROM GrantOptions GOP INNER JOIN #EMPLOYEE_TEMP_OPTION_EXERCISED ETOE
	ON ETOE.GrantOptionId = GOP.GrantOptionId AND ETOE.SchemeId = GOP.SchemeId 
	INNER JOIN Scheme SC On GOP.SchemeId=SC.SchemeId	  	
	
	IF @ExerciseNo IS NULL	
	
	SELECT
		  MIT_ID, ExerciseNo, REPLACE(CONVERT(VARCHAR, ISNULL(ExercisedDate,''),106),' ','-') AS ExercisedDate, INSTRUMENT_NAME, SUM(CONVERT(FLOAT, ISNULL(ExercisedQuantity ,0))) AS PendingForApproval, TrustType
	FROM 
		#EMPLOYEE_TEMP_OPTION_EXERCISED	
	Group BY
			 MIT_ID, ExerciseNo, ExercisedDate, INSTRUMENT_NAME, TrustType            
	ORDER BY
			 ExerciseNo, ExercisedDate ASC		
		ELSE
		
	SELECT DISTINCT
			ISNULL(ED.PaymentMode,'') AS PaymentMode, REPLACE(CONVERT(VARCHAR, ISNULL(FD.ExercisedDate,''), 106), ' ','-') AS 'Exercise Date', SUM(CAST(ISNULL(FD.ExercisedQuantity,0) AS FLOAT)) AS 'Options Exercised',
			CASE WHEN ED.CALCULATE_TAX='rdoActualTax' THEN SUM(ISNULL(FD.ShareAriseApprValue,0)) ELSE CASE WHEN ED.CALCULATE_TAX='rdoTentativeTax' THEN SUM(ISNULL(ED.TentShareAriseApprValue,0)) ELSE '0' END END AS 'Share_Arise_Appreciation_Value', 
			SUM(CAST(ISNULL(FD.Exercise_Amount, 0)AS FLOAT)) AS 'Exercise Amount Payable',
			CASE WHEN ED.CALCULATE_TAX='rdoActualTax' THEN SUM((ISNULL(FD.PerqstPayable,0))+(ISNULL(FD.CashPayoutValue ,0))) ELSE CASE WHEN ED.CALCULATE_TAX='rdoTentativeTax' THEN SUM((ISNULL(ED.TentativePerqstPayable,0))+(ISNULL(ED.TentativeCashPayoutValue,0))) ELSE '0' END END  AS GrossPayOutValue,
			CASE WHEN ED.CALCULATE_TAX='rdoActualTax' THEN SUM(ISNULL(FD.PerqstPayable,0)) ELSE CASE WHEN ED.CALCULATE_TAX='rdoTentativeTax' THEN SUM(ISNULL(ED.TentativePerqstPayable,0)) ELSE '0' END END  AS 'Tax_Payable', 
			CASE WHEN ED.CALCULATE_TAX='rdoActualTax' THEN SUM(ISNULL(FD.CashPayoutValue ,0)) ELSE CASE WHEN ED.CALCULATE_TAX='rdoTentativeTax' THEN SUM(ISNULL(ED.TentativeCashPayoutValue,0)) ELSE '0' END END AS 'Net_CashpayOut_Value', 
			REPLACE(CONVERT(VARCHAR,ISNULL(FD.SharesIssuedDate,''),106),' ','-') AS 'Date of allottment',

			--ADD DEMAT RECORD FOR OFFLINE PAYMENTMODE	
			ISNULL(STD.DPRecord,'') AS 'Name_As_In_DPRecord_For_Offline',
			CASE WHEN ISNULL(STD.DepositoryName,'')='N' THEN 'NSDL' ELSE CASE WHEN ISNULL(STD.DepositoryName,'')='C' THEN 'CDSL' ELSE '' END END AS 'Name_Of_Depository_For_Offline', 
			CASE WHEN ISNULL(STD.DematACType,'')='R' THEN 'Repatriable' ELSE CASE WHEN ISNULL(STD.DematACType,'')='NR' THEN 'Non Repatriable' ELSE CASE WHEN ISNULL(STD.DematACType,'')='N' THEN 'Non Repatriable' ELSE CASE WHEN ISNULL(STD.DematACType,'')='A' THEN 'Not Applicable' ELSE '' END END END END AS 'Demat_A/C_Type_For_Offline', 
			ISNULL(STD.DepositoryParticipantName,'') AS 'Depository_Participant_Name_For_Offline',
			ISNULL(STD.DPIDNo,'') AS 'Depository_Participant_Id_For_Offline', 
			ISNULL(STD.ClientNo,'') AS 'Demat_A/C_No_For_Offline',
			
			--ADD DEMAT RECORD FOR ONLINE PAYMENTMODE	
            ISNULL(TD.DPRecord,'') AS 'Name_As_In_DPRecord_For_Online',
			CASE WHEN ISNULL(TD.DepositoryName,'')='N' THEN 'NSDL' ELSE CASE WHEN ISNULL(TD.DepositoryName,'')='C' THEN 'CDSL' ELSE '' END END AS 'Name_Of_Depository_For_Online',
			CASE WHEN ISNULL(TD.DematACType,'') ='R' THEN 'Repatriable' ELSE CASE WHEN ISNULL(TD.DematACType,'')='NR' THEN 'Non Repatriable' ELSE CASE WHEN ISNULL(TD.DematACType,'') ='N' THEN ' Non Repatriable' ELSE CASE WHEN ISNULL(TD.DematACType,'') ='A' THEN 'Not Applicable' ELSE '' END END END END AS 'Demat_A/C_Type_For_Online', 
			ISNULL(TD.DPName,'') AS 'Depository_Participant_Name_For_Online',
			ISNULL(TD.DPID,'') AS 'Depository_Participant_Id_For_Online', 
			ISNULL(TD.ClientId,'') AS 'Demat_A/C_No_For_Online',

			--ADD DEMAT RECORD FOR CASHLESS PAYMENTMODE
            ISNULL(TDC.DPRecord,'') AS 'Name_As_In_DPRecord_For_Cashless', 
			CASE WHEN ISNULL(TDC.DepositoryName ,'')='N' THEN 'NSDL' ELSE CASE WHEN ISNULL(TDC.DepositoryName ,'')='C' THEN 'CDSL' ELSE '' END END AS 'Name_Of_Depository_For_Cashless', 
			CASE WHEN ISNULL(TDC.DematAcType,'')='R' THEN 'Repatriable' ELSE CASE WHEN ISNULL(TDC.DematACType,'')='NR' THEN 'Non Repatriable' ELSE CASE WHEN ISNULL(TDC.DematACType,'')='N' THEN 'Non Repatriable' ELSE CASE WHEN ISNULL(TDC.DematACType,'')='A' THEN 'Not Applicable' ELSE '' END END END END AS 'Demat_A/C_Type_For_Cashless', 
			ISNULL(TDC.DPName,'') AS 'Depository_Participant_Name_For_Cashless',
			ISNULL(TDC.DPId,'') AS 'Depository_Participant_Id_For_Cashless', 
			ISNULL(TDC.ClientId,'') AS 'Demat_A/C_No_For_Cashless',

			--ADD BROKER RECORD FOR OFFLINE PAYMENTMODE
			ISNULL(STD.BROKER_DEP_TRUST_CMP_NAME,'') AS 'Broker/Depository_Trust_Company_Name_For_Offline', ISNULL(STD.BROKER_DEP_TRUST_CMP_ID,'') AS 'Broker/Depository_Trust_Company_ID_For_Offline', ISNULL(STD.BROKER_ELECT_ACC_NUM,'') AS 'Broker/Electronic_Account_Number_For_Offline',

			--ADD BROKER RECORD FOR ONLINE PAYMENTMODE
			ISNULL(TD.BROKER_DEP_TRUST_CMP_NAME,'') AS 'Broker/Depository_Trust_Company_Name_For_Online', ISNULL(TD.BROKER_DEP_TRUST_CMP_ID,'') AS 'Broker/Depository_Trust_Company_ID_For_Online', ISNULL(TD.BROKER_ELECT_ACC_NUM,'') AS 'Broker/Electronic_Account_Number__For_Online',
			
			--ADD BROKER RECORD FOR CASHLESS PAYMENTMODE
		    CASE WHEN TDC.BROKER_DEP_TRUST_CMP_NAME IS NULL THEN ISNULL(EBD.BROKER_DEP_TRUST_CMP_NAME,'') ELSE ISNULL(TDC.BROKER_DEP_TRUST_CMP_NAME,'') END AS 'Broker/Depository_Trust_Company_Name_For_Cashless',
			CASE WHEN TDC.BROKER_DEP_TRUST_CMP_ID IS NULL THEN ISNULL(EBD.BROKER_DEP_TRUST_CMP_ID,'') ELSE ISNULL(TDC.BROKER_DEP_TRUST_CMP_ID,'') END AS 'Broker/Depository_Trust_Company_ID_For_Cashless',
			CASE WHEN TDC.BROKER_ELECT_ACC_NUM IS NULL THEN ISNULL(EBD.BROKER_ELECT_ACC_NUM,'') ELSE ISNULL(TDC.BROKER_ELECT_ACC_NUM,'') END AS 'Broker/Electronic_Account_Number_For_Cashless',
			
			ISNULL(FD.EmployeeName,'') AS	'Employee Name', ISNULL(TDC.BankName,'') AS 'Bank Name', ISNULL(TDC.BankBranchName,'') AS 'Bank Branch Name', ISNULL(TDC.BankBranchAddress,'') AS 'Bank Branch Address',
			ISNULL(TDC.BankAccountNo,'') AS 'Bank Account Number', ISNULL(TOB.TypeOfBankAcName,'') AS 'Type Of Bank Account', ISNULL(TDC.IFSCCode,'') AS 'IFSC Code',
			 
			ISNULL(TD.BankReferenceNo,'') AS 'Transaction Id', REPLACE(CONVERT(VARCHAR, ISNULL(TD.Transaction_Date,''), 106),' ','-') AS 'Transaction Date', ISNULL(PBM.BankName,'') AS 'Online Bank Name', ISNULL(TD.BankAccountNo,'') AS N_Bank_Account_No,
			ISNULL(STD.Branch,'') AS N_Bank_Branch_Address,	
			
			ISNULL(TD.BankReferenceNo,'') AS 'Tax_Transaction Id', REPLACE(CONVERT(VARCHAR, ISNULL(TD.Transaction_Date,''), 106),' ','-') AS 'Tax_Transaction Date', ISNULL(PBM.BankName,'') AS 'Tax_Online Bank Name', ISNULL(TD.BankAccountNo,'') AS N_Bank_Account_No,
			ISNULL(STD.Branch,'') AS N_Bank_Branch_Address,	
			
			ISNULL(STD.PaymentNameEX,'') AS 'Cheque Number', REPLACE(CONVERT(VARCHAR, ISNULL(STD.DrawnOn,''),106),' ','-') AS 'Cheque Date', ISNULL(STD.BankName,'') AS 'Ex_BankName', 
			ISNULL(STD.PaymentNameEX,'') AS 'Demand Draft Number', REPLACE(CONVERT(VARCHAR, ISNULL(STD.DrawnOn,''), 106),' ','-') AS 'Demand Draft Date', ISNULL(STD.BankName,'') AS 'DD BankName', 
			ISNULL(STD.PaymentNameEX,'') AS 'RTGS/NEFT NO.', REPLACE(CONVERT(VARCHAR, ISNULL(STD.DrawnOn,''),106),' ','-') AS 'NEFT Transaction Date', ISNULL(STD.BankName,'') AS 'NEFT Bank Name', ISNULL(STD.AccountNo, '') AS 'NEFT Bank Account No', ISNULL(STD.Branch,'') AS 'NEFT Bank Branch Address',
			ISNULL(STD.PaymentNameEX,'') AS 'Wire Transfer/Remittance No.', ISNULL(STD.IBANNo,'') AS 'SWIFT(BIC)/ABN Routing IBAN No', REPLACE(CONVERT(VARCHAR, ISNULL(STD.DrawnOn,''), 106),' ','-') AS 'Wire Transaction date',  ISNULL(STD.BankName,'') AS 'Wire Bank Name', ISNULL(STD.AccountNo, '') AS 'Wire Bank Account No', ISNULL(STD.Branch, '') AS 'Wire Bank Branch address',
			
			ISNULL(STD.PaymentNamePQ,'') AS TAX_ChequeNumber, ISNULL(REPLACE(CONVERT(VARCHAR, STD.PerqAmt_DrownOndate,106),' ','-'),'') AS TAX_ChequeDate, ISNULL(STD.PerqAmt_BankName,'') AS TAX_BankName,
			ISNULL(STD.PaymentNamePQ,'') AS TAX_Demand_Draft_Number, ISNULL(REPLACE(CONVERT(VARCHAR, STD.PerqAmt_DrownOndate,106),' ','-'),'') AS TAX_Demand_Draft_Date, ISNULL(STD.PerqAmt_BankName,'') AS TAX_Demand_Draft_BankName,
			ISNULL(STD.PaymentNamePQ,'') AS TAX_NEFT_NO, ISNULL(REPLACE(CONVERT(VARCHAR, STD.PerqAmt_DrownOndate,106),' ','-'),'') AS TAX_PaymentDate , ISNULL(STD.PerqAmt_BankName,'') AS TAX_NEFT_BankName, ISNULL(STD.PerqAmt_BankAccountNumber, '') AS TAX_NEFT_AccNo, ISNULL(STD.PerqAmt_Branch,'') AS TAX_NEFT_Bank_Branch,
			ISNULL(STD.PaymentNamePQ,'') AS TAX_Wire_Transfer, ISNULL(STD.IBANNoPQ,'') AS TAX_IBAN_NO, ISNULL(REPLACE(CONVERT(VARCHAR, STD.PerqAmt_DrownOndate,106),' ','-'),'') AS TAX_Wire_Transafer_date, ISNULL(STD.PerqAmt_BankName,'') AS TAX_Wire_BankName, ISNULL(STD.PerqAmt_BankAccountNumber, '') AS TAX_Wire_Bank_AccNo, ISNULL(STD.PerqAmt_Branch,'') AS TAX_W_Bank_Branch,
			ISNULL(ED.CALCULATE_TAX,'') AS CALCULATE_TAX
			
	    FROM 
			#EMPLOYEE_TEMP_OPTION_EXERCISED AS FD
			LEFT JOIN Exercised AS ED ON ED.ExercisedId = FD.ExercisedId		
			LEFT JOIN ShTransactionDetails AS STD ON  STD.ExerciseNo = FD.ExerciseNo
			LEFT JOIN TransactionDetails_CashLess AS TDC ON TDC.ExerciseNo = FD.ExerciseNo
			LEFT JOIN Transaction_Details AS TD ON TD.ExerciseNo = FD.ExerciseNo 
			LEFT JOIN paymentbankmaster AS PBM  ON PBM.BankID = TD.bankID	
			LEFT JOIN Employee_UserBrokerDetails EBD ON EBD.EMPLOYEE_ID= FD.EmployeeID
			LEFT JOIN TypeOfBankAc TOB ON TOB.TypeOfBankAcID=TDC.accounttype 
				
	   WHERE 
			FD.ExerciseNo = @ExerciseNo and FD.MIT_ID = @MIT_ID
	   GROUP BY  
				ED.PaymentMode,FD.ExercisedDate,FD.SharesIssuedDate,STD.DPRecord,STD.DepositoryName,STD.DematACType,				
				STD.DepositoryParticipantName,STD.DPIDNo,STD.ClientNo,FD.EmployeeName,				
				TDC.BankName,TDC.BankBranchName,TDC.BankBranchAddress,TDC.BankAccountNo,TOB.TypeOfBankAcName,TDC.IFSCCode,
				TD.BankReferenceNo,TD.Transaction_Date,PBM.BankName,TD.BankAccountNo,STD.Branch,
				STD.PaymentNameEX,STD.DrawnOn,STD.BankName,STD.AccountNo,STD.IBANNo,STD.PaymentNamePQ,STD.PerqAmt_DrownOndate,
				STD.PerqAmt_BankName,STD.PerqAmt_BankAccountNumber,STD.PerqAmt_Branch,STD.IBANNoPQ,
				STD.BROKER_DEP_TRUST_CMP_NAME, STD.BROKER_DEP_TRUST_CMP_ID, STD.BROKER_ELECT_ACC_NUM,TD.DPRecord,TD.DepositoryName,TD.DematACType,
				TD.DPName,TD.DPID,TD.ClientId,TD.BROKER_DEP_TRUST_CMP_NAME,TD.BROKER_DEP_TRUST_CMP_ID,TD.BROKER_ELECT_ACC_NUM,TDC.DPRecord,TDC.DepositoryName,
				TDC.DematAcType,TDC.DPName,TDC.DPId,TDC.ClientId,TDC.BROKER_DEP_TRUST_CMP_NAME,TDC.BROKER_DEP_TRUST_CMP_ID,TDC.BROKER_ELECT_ACC_NUM,EBD.BROKER_DEP_TRUST_CMP_NAME,EBD.BROKER_DEP_TRUST_CMP_ID,EBD.BROKER_ELECT_ACC_NUM,
				ED.CALCULATE_TAX,GrossPayOutValue
					
	DROP TABLE #EMPLOYEE_TEMP_OPTION_EXERCISED  
	
	SET NOCOUNT OFF;
END
GO
