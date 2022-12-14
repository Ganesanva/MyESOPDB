/****** Object:  StoredProcedure [dbo].[Proc_getvalidateexercisedata_SSRS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_getvalidateexercisedata_SSRS]
GO
/****** Object:  StoredProcedure [dbo].[Proc_getvalidateexercisedata_SSRS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE  PROCEDURE [dbo].[Proc_getvalidateexercisedata_SSRS](@Employeeid VARCHAR(MAX),@SchemeId   VARCHAR(MAX) , @Activity CHAR) 
AS 

BEGIN 
  
	DECLARE @WHERE_CLAUSE_EMPLOYEEID AS VARCHAR(1000), @WHERE_CLAUSE_SCHEMEID AS VARCHAR(1000), @FaceValue AS VARCHAR(10),@CompanyID AS VARCHAR(200)
	
	SET @WHERE_CLAUSE_EMPLOYEEID = ''
	SET @WHERE_CLAUSE_SCHEMEID = ''
	
	IF (@Employeeid <> '---All Employees---')
	BEGIN
		SET @WHERE_CLAUSE_EMPLOYEEID = ' AND ex.employeeid = ''' + @Employeeid + ''''
	END
	
	IF (@SchemeId <> '---All Schemes---')
	BEGIN
		SET @WHERE_CLAUSE_SCHEMEID = ' AND sch.schemeid = ''' + @SchemeId + ''''
	END
	
	CREATE TABLE #tempMain
		(
		[Exercise number/Application number] NUMERIC (18, 0)
		, [Exercise ID] NUMERIc
		, [Employee ID] TEXT
		, [Employee Name] VARCHAR (75)
		, Country VARCHAR (50)
		, Perq_Tax_rate NUMERIC (18, 6)
		, [Scheme Name] VARCHAR (50)
		, [Grant Registration ID] VARCHAR (20)
		, [Grant Date] DATETIME
		, [Grant Option ID] VARCHAR (100)
		, [Options Exercised] NUMERIC (18, 0)
		, [Exercise Price] NUMERIC (18, 2)
		, MIT_ID INT
		, INSTRUMENT_NAME NVARCHAR (500)
		, [Amount Paid] NUMERIC (37, 2)
		, [Equivalent Exercise Quantity] NUMERIC (38, 0)
		, [Exercise Date] DATETIME
		, fmv NUMERIC (18, 2)
		, [Perquiste Value] NUMERIC (18, 2)
		, [Perquisite Tax payable] NUMERIC (18, 2)
		, [Grant vest period id] DECIMAL (10, 0)
		, [Vesting Date] DATETIME
		, [Email Address] VARCHAR (500)
		, [Employee Address] VARCHAR (500)
		, [Payment mode] VARCHAR (20)
		, lotnumber VARCHAR (20)
		, receiveddate DATETIME
		, validationstatus VARCHAR (1)
		, revarsalreason VARCHAR (1)
		, exerciseformreceived VARCHAR (10)
		, exformreceivedstatus VARCHAR (3)
		, paymentmode VARCHAR (1)
		 ,Paymentdate DATETIME
		, IsPaymentDeposited BIT
		, PaymentDepositedDate DATETIME
		, IsPaymentConfirmed BIT
		, PaymentConfirmedDate DATETIME
		, IsExerciseAllotted BIT
		, ExerciseAllotedDate DATETIME
		, IsAllotmentGenerated BIT
		, AllotmentGenerateDate DATETIME
		, IsAllotmentGeneratedReversed BIT
		, AllotmentGeneratedReversedDate DATETIME
		, TrustType CHAR (10)
		, [Account number] varchar(20)	
		, ConfStatus char(1)
		, DateOfJoining datetime NULL
		, DateOfTermination datetime NULL
		, Department varchar(200)
		, EmployeeDesignation varchar(200)
		, Entity varchar(200)
		, Grade varchar(200)
		, Insider	varchar(200)	
		, ReasonForTermination varchar(200)
		, SBU	 varchar(200)
		, IS_UPLOAD_EXERCISE_FORM   varchar(200)
		, IS_UPLOAD_EXERCISE_FORM_ON varchar(200)
		, COMPANY_ID  VARCHAR(200)
		, [Settlment Price] NUMERIC (18, 2)
		, [Stock Appreciation Value] NUMERIC (18, 2)
		, [Cash Payout Value] NUMERIC (18, 2)
		, [Expiry Date] DATETIME
		)
	
	/*Get face value here to calculate amount paid for MIT_ID 6 */
    SELECT @FaceValue = cp.FaceVaue FROM companyparameters cp 
	SELECT @CompanyID=CompanyID FROM COMPANYMASTER 
	INSERT into #tempMain 
	EXEC ('SELECT	ex.exerciseno AS [Exercise number/Application number], 
					ex.exerciseid AS [Exercise ID], convert(text,ex.employeeid)  AS [Employee ID], emp.employeename AS [Employee Name],
					(SELECT CountryName FROM CountryMaster WHERE CountryAliasName = (
						CASE	WHEN ex.paymentmode = ''Q'' OR ex.paymentmode = ''D'' OR ex.paymentmode = ''W'' OR ex.paymentmode = ''R'' OR ex.paymentmode = ''I'' 
						
						THEN (CASE WHEN (SELECT ISNULL(CountryName,NULL) FROM ShTransactionDetails WHERE ExerciseNo = ex.exerciseno) <> NULL THEN (SELECT TOP 1 CountryName FROM ShTransactionDetails WHERE ExerciseNo = ex.exerciseno) ELSE (SELECT TOP 1 CountryName FROM EMPDET_With_EXERCISE WHERE ExerciseNo = ex.exerciseno) END)
								WHEN ex.paymentmode = ''A'' OR ex.paymentmode = ''P'' 
						THEN (CASE WHEN (SELECT ISNULL(CountryName,NULL) FROM TransactionDetails_CashLess WHERE ExerciseNo = ex.exerciseno) <> NULL THEN (SELECT TOP 1 CountryName FROM ShTransactionDetails WHERE ExerciseNo = ex.exerciseno) ELSE (SELECT TOP 1 CountryName FROM EMPDET_With_EXERCISE WHERE ExerciseNo = ex.exerciseno) END)
								WHEN ex.paymentmode = ''F'' 
						THEN (CASE WHEN (SELECT ISNULL(CountryName,NULL) FROM TransactionDetails_Funding WHERE ExerciseNo = ex.exerciseno) <> NULL THEN (SELECT TOP 1 CountryName FROM ShTransactionDetails WHERE ExerciseNo = ex.exerciseno) ELSE (SELECT TOP 1 CountryName FROM EMPDET_With_EXERCISE WHERE ExerciseNo = ex.exerciseno) END)
								WHEN ex.paymentmode = ''N'' 
						THEN (CASE WHEN (SELECT ISNULL(CountryName,NULL) FROM Transaction_Details WHERE sh_exerciseno = ex.exerciseno) <> NULL THEN (SELECT TOP 1 CountryName FROM ShTransactionDetails WHERE ExerciseNo = ex.exerciseno) ELSE (SELECT TOP 1 CountryName FROM EMPDET_With_EXERCISE WHERE ExerciseNo = ex.exerciseno) END)
						ELSE (SELECT TOP 1 CountryName FROM EMPDET_With_EXERCISE WHERE ExerciseNo = ex.exerciseno)END))									
						AS Country,
					ex.Perq_Tax_rate AS Perq_Tax_rate, sch.schemetitle AS [Scheme Name], 
					gl.GrantRegistrationId  AS [Grant Registration ID], grantregistration.grantdate AS [Grant Date], 
					gl.grantoptionid AS [Grant Option ID], ex.exercisedquantity  AS [Options Exercised], 
					ex.exerciseprice AS [Exercise Price], ex.MIT_ID, (CASE WHEN( ISNULL(CIM.INS_DISPLY_NAME,'''') = '''') THEN MAX (MST.INSTRUMENT_NAME) ELSE MAX (CIM.INS_DISPLY_NAME) END) AS ''INSTRUMENT_NAME'',
					
					CASE 
						 WHEN 
							ex.MIT_ID <> 6 AND grantregistration.Apply_SAR=''Y'' 
						 THEN 
							NULL 
						 WHEN
							 ex.MIT_ID = 6 AND ex.CALCULATE_TAX = ''rdoTentativeTax'' 
						 THEN 
							(ISNULL(SUM(ex.TentShareAriseApprValue),0) * '+@FaceValue+' ) 
						 WHEN
							 ex.MIT_ID = 6 AND ex.CALCULATE_TAX = ''rdoActualTax'' 
						 THEN 
							(ISNULL(SUM(ex.ShareAriseApprValue),0) * '+@FaceValue+' ) 
					ELSE  
						Isnull(ex.exercisedquantity, 0) * ex.exerciseprice 
					END AS [Amount Paid],
					 
					CASE 
						WHEN 
							ex.MIT_ID <> 6 AND MAX(grantregistration.apply_sar) = ''Y'' 
						THEN 
							SUM(ISNULL(ESD.sharesissued, 0)) 
						 WHEN
							 ex.MIT_ID = 6 AND ex.CALCULATE_TAX = ''rdoTentativeTax'' 
						 THEN 
							(ISNULL(SUM(ex.TentShareAriseApprValue),0)) 
						 WHEN
							 ex.MIT_ID = 6 AND ex.CALCULATE_TAX = ''rdoActualTax'' 
						 THEN 
							(ISNULL(SUM(ex.ShareAriseApprValue),0)) 
						ELSE 
							SUM((ISNULL(ex.splitexercisedquantity,0) *  ISNULL(sch.optionratiomultiplier,0) ) /  sch.optionratiodivisor ) 
					END AS [Equivalent Exercise Quantity],

					ex.exercisedate AS [Exercise Date], 					
					CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.fmvprice WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativeFMVPrice, ex.fmvprice) END,0)) AS  fmv,	 
					CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.perqstvalue WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativePerqstValue, ex.perqstvalue) END,0)) AS [Perquiste Value], 
					CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.PerqstPayable WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativePerqstPayable, ex.PerqstPayable) END,0)) AS [Perquisite Tax payable],					 
					gl.grantlegid AS [Grant vest period id],
					gl.FinalVestingDate AS [Vesting Date], 
					emp.EmployeeEmail as [Email Address],
					emp.employeeaddress  AS [Employee Address],
					pm.paymodename AS [Payment mode],					
					ex.lotnumber, 
					ex.receiveddate AS receiveddate, 
					CASE WHEN ex.validationstatus = ''N'' THEN '''' ELSE ex.validationstatus END AS validationstatus, 
					'''' AS revarsalreason, ex.exerciseformreceived, 
					CASE WHEN ex.exerciseformreceived = ''Y'' THEN ''Yes'' ELSE ''No'' END AS exformreceivedstatus,
					ex.paymentmode,PTD.Paymentdate, ex.IsPaymentDeposited, ex.PaymentDepositedDate, ex.IsPaymentConfirmed,ex.PaymentConfirmedDate,ex.IsExerciseAllotted,ex.ExerciseAllotedDate,ex.IsAllotmentGenerated,ex.AllotmentGenerateDate,ex.IsAllotmentGeneratedReversed,ex.AllotmentGeneratedReversedDate, sch.TrustType,
					emp.AccountNo,		
					emp.ConfStatus,
					emp.DateOfJoining,
					emp.DateOfTermination,
					emp.Department,
					emp.EmployeeDesignation,
					emp.Entity,
					emp.Grade,
					emp.Insider,	
					RFT.REASON,
					emp.SBU,	
					CASE  WHEN ISNULL(ex.IS_UPLOAD_EXERCISE_FORM,0)=1 AND (SELECT COUNT(*) FROM MST_EXERCISE_STEPS WHERE IS_ACTIVE=1 AND MST_EX_STEP_ID IN(4))>0 THEN ''Uploaded'' 
					WHEN ISNULL(ex.IS_UPLOAD_EXERCISE_FORM,0)=1 AND (SELECT COUNT(*) FROM MST_EXERCISE_STEPS WHERE IS_ACTIVE=1 AND MST_EX_STEP_ID IN(5))>0 THEN ''Accepted'' ELSE ''Pending''
				   END IS_UPLOAD_EXERCISE_FORM,
				ISNULL(REPLACE(CONVERT(char(11),ex.IS_UPLOAD_EXERCISE_FORM_ON,113), '' '',''-'') ,''-''),
					'''+@CompanyID+''',
				CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.SettlmentPrice WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativeSettlmentPrice, ex.SettlmentPrice) END,0)) AS [Settlment Price], 
				CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.StockApprValue WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativeStockApprValue, ex.StockApprValue) END,0)) AS [Stock Appreciation Value], 
				CONVERT(NUMERIC(18,2), ISNULL(CASE ex.CALCULATE_TAX WHEN ''rdoActualTax'' THEN ex.CashPayoutValue WHEN ''rdoTentativeTax'' THEN ISNULL(ex.TentativeCashPayoutValue, ex.CashPayoutValue) END,0)) AS [Cash Payout Value],
				gl.FinalExpirayDate AS [Expiry Date]
			FROM		
					shexercisedoptions AS ex
					LEFT JOIN ExerciseSARDetails AS ESD ON ex.ExerciseSARid=esd.ExerciseSARid  
					LEFT JOIN paymentmaster pm ON ex.paymentmode = pm.paymentmode 
					INNER JOIN employeemaster AS emp ON ex.employeeid = emp.employeeid ' + @WHERE_CLAUSE_EMPLOYEEID + '
					INNER JOIN grantleg AS gl ON ex.grantlegserialnumber = gl.id 					
					INNER JOIN grantregistration ON gl.grantregistrationid = grantregistration.grantregistrationid
					INNER JOIN vestingperiod ON gl.grantregistrationid = vestingperiod.grantregistrationid AND gl.grantlegid = vestingperiod.vestingperiodno 
					INNER JOIN scheme AS sch ON gl.schemeid = sch.schemeid ' + @WHERE_CLAUSE_SCHEMEID + ' AND sch.IsPUPEnabled <> 1
					INNER JOIN MST_INSTRUMENT_TYPE AS MST ON ex.MIT_ID = MST.MIT_ID
					INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON MST.MIT_ID = CIM.MIT_ID 					
					LEFT OUTER JOIN ReasonForTermination RFT ON RFT.ID = emp.ReasonForTermination
					LEFT JOIN PaymentSelectionDate PTD ON PTD.ExerciseNo = ex.exerciseno
			WHERE  ( ex.validationstatus <> ''V'' ) AND ( ex.ACTION = ''A'' ) OR ( ex.ACTION = ''P'' ) AND (CIM.IS_ENABLED = 1)			
			GROUP BY 
					ex.ExerciseNo,ex.ExerciseId,ex.EmployeeID,emp.EmployeeName,sch.SchemeTitle,gl.GrantRegistrationId,grantregistration.GrantDate,gl.GrantOptionId,
					Perq_Tax_rate,sch.OptionRatioDivisor,sch.OptionRatioMultiplier,ex.ExercisedQuantity,ex.ExercisePrice,grantregistration.Apply_SAR,ex.ExerciseDate,ex.FMVPrice, ex.TentativeFMVPrice,
					ex.PerqstValue, ex.TentativePerqstValue, ex.PerqstPayable,ex.TentativePerqstPayable,gl.GrantLegId,gl.FinalVestingDate,emp.EmployeeEmail,emp.EmployeeAddress,pm.PayModeName,ex.LotNumber,ex.ReceivedDate,
					ex.ValidationStatus,ex.ExerciseFormReceived, ex.paymentmode, PTD.Paymentdate,ex.IsPaymentDeposited, ex.PaymentDepositedDate, ex.IsPaymentConfirmed,ex.PaymentConfirmedDate,ex.IsExerciseAllotted,ex.ExerciseAllotedDate,
					ex.IsAllotmentGenerated,ex.AllotmentGenerateDate,ex.IsAllotmentGeneratedReversed,ex.AllotmentGeneratedReversedDate, sch.TrustType,ex.CALCULATE_TAX, ex.MIT_ID, CIM.INS_DISPLY_NAME,
					emp.AccountNo, emp.ConfStatus, emp.DateOfJoining, emp.DateOfTermination, emp.Department, emp.EmployeeDesignation, emp.Entity, emp.Grade, emp.Insider, RFT.REASON, emp.SBU,
					ex.IS_UPLOAD_EXERCISE_FORM,ex.IS_UPLOAD_EXERCISE_FORM_ON,ex.SettlmentPrice,ex.TentativeSettlmentPrice,ex.StockApprValue,ex.TentativeStockApprValue,ex.CashPayoutValue,ex.TentativeCashPayoutValue,gl.FinalExpirayDate

		')
     
	-----demat and Broker details        
	select * into #tempDemat from
	(
		select #tempMain.[Exercise number/Application number], tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematACType as [Demat A/C Type],tr.DepositoryParticipantName as [Name of Depository Participant (DP)],tr.DPIDNo as [Depository ID],tr.ClientNo as [Client ID],tr.PANNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.Mobile as [Mobile Number], tr.BROKER_DEP_TRUST_CMP_NAME AS [Broker Company Name], tr.BROKER_DEP_TRUST_CMP_ID AS [Broker Company ID], tr.BROKER_ELECT_ACC_NUM AS [Broker Electronic Account Number] from ShTransactionDetails tr inner join #tempMain on tr.ExerciseNo=#tempMain.[Exercise number/Application number] and (tr.ActionType='P' or tr.STATUS='P') AND #tempMain.paymentmode <> 'Online'
		union
		select #tempMain.[Exercise number/Application number],tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematAcType as [Demat A/C Type],tr.DPName as [Name of Depository Participant (DP)],tr.DPId as [Depository ID],tr.ClientId as [Client ID],tr.PanNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.MobileNumber as [Mobile Number], '' AS [Broker Company Name], '' AS [Broker Company ID], '' AS [Broker Electronic Account Number] from TransactionDetails_CashLess tr inner join #tempMain on tr.ExerciseNo=#tempMain.[Exercise number/Application number] and tr.STATUS='P' AND #tempMain.paymentmode <> 'Online'
		union
		select #tempMain.[Exercise number/Application number],tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematAcType as [Demat A/C Type],tr.DPName as [Name of Depository Participant (DP)],tr.DPId as [Depository ID],tr.ClientId as [Client ID],tr.PanNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.MobileNumber as [Mobile Number], tr.BROKER_DEP_TRUST_CMP_NAME AS [Broker Company Name], tr.BROKER_DEP_TRUST_CMP_ID AS [Broker Company ID], tr.BROKER_ELECT_ACC_NUM AS [Broker Electronic Account Number] from Transaction_Details tr inner join #tempMain on tr.Sh_ExerciseNo=#tempMain.[Exercise number/Application number]and tr.STATUS='S' AND #tempMain.paymentmode = 'Online'
	) as T1

	--select * from #tempDemat
	select * into #tempExerciseNo from(select distinct(#tempMain.[Exercise number/Application number])as [Exercise number/Application number] from #tempMain where #tempMain.[Exercise number/Application number] not in (select #tempDemat.[Exercise number/Application number] from #tempDemat)) as TempExNo

	--select * from #tempExerciseNo
	INSERT  INTO  #tempDemat SELECT #tempExerciseNo.[Exercise number/Application number], EMPDET.DPRecord AS [Name as in Depository Participant (DP) records],EMPDET.DepositoryName as [Name of Depository],EMPDET.DematAccountType as [Demat A/C Type],EMPDET.DepositoryParticipantNo as [Name of Depository Participant (DP)],EMPDET.DepositoryIDNumber as [Depository ID],EMPDET.ClientIDNumber as [Client ID],EMPDET.PANNumber as [PAN],case when EMPDET.ResidentialStatus='R' Then 'Resident Indian' when EMPDET.ResidentialStatus='N' Then 'Non Resident' when EMPDET.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],NULL as Nationality,EMPDET.Location,NULL as [Mobile Number],EMPDET.BROKER_DEP_TRUST_CMP_NAME AS [Broker Company Name], EMPDET.BROKER_DEP_TRUST_CMP_ID AS [Broker Company Id], EMPDET.BROKER_ELECT_ACC_NUM AS [Broker Electronic Account Number] from EMPDET_With_EXERCISE EMPDET inner Join #tempExerciseNo on EMPDET.ExerciseNo=#tempExerciseNo.[Exercise number/Application number]

	SELECT * INTO #tempEMPMASTR FROM(SELECT DISTINCT(#tempMain.[Exercise number/Application number]) AS [Exercise number/Application number],CONVERT(varchar(50),#tempMain.[Employee ID])as [Employee ID]  from #tempMain where #tempMain.[Exercise number/Application number] not in (select #tempDemat.[Exercise number/Application number] from #tempDemat)) as TempExNo
	--select * from #tempEMPMASTR

	INSERT  INTO  #tempDemat SELECT #tempEMPMASTR.[Exercise number/Application number], EMP.DPRecord AS [Name as in Depository Participant (DP) records],EMP.DepositoryName as [Name of Depository],EMP.DematAccountType as [Demat A/C Type],EMP.DepositoryParticipantNo as [Name of Depository Participant (DP)],EMP.DepositoryIDNumber as [Depository ID],EMP.ClientIDNumber as [Client ID],EMP.PANNumber as [PAN],case when EMP.ResidentialStatus='R' Then 'Resident Indian' when EMP.ResidentialStatus='N' Then 'Non Resident' when EMP.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],NULL as Nationality,EMP.Location,EMP.Mobile as [Mobile Number],EMP.BROKER_DEP_TRUST_CMP_NAME AS [Broker Company Name], EMP.BROKER_DEP_TRUST_CMP_ID AS [Broker Company Id], EMP.BROKER_ELECT_ACC_NUM AS [Broker Electronic Account Number] from EmployeeMaster EMP inner Join #tempEMPMASTR on EMP.EmployeeID =#tempEMPMASTR.[Employee ID] 

	----offline payment details 
	--cheque payment details
	select * into #tempChq from(select distinct(tr.ExerciseNo), ISNULL(tr.PaymentNameEX,tr.Cheque_DDNo) as[Cheque No (Exercise amount)],tr.DrawnOn as [Cheque Date (Exercise amount)],tr.BankName as [Bank Name drawn on (Exercise amount)], ISNULL(tr.PaymentNamePQ, tr.PerqAmt_ChequeNo) as [Cheque No (Perquisite tax)],tr.PerqAmt_DrownOndate as [Cheque Date (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name drawn on (Perquisite tax)], tr.Branch as [Bank Address (Exercise amount)] ,tr.AccountNo as [Bank Account No  (Exercise amount)], ISNULL(CONVERT(VARCHAR, tr.ExAmtTypOfBnkAc), tr.ExerciseBankType) as ExAmtTypOfBnkAc, tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)], ISNULL(CONVERT(VARCHAR,tr.PeqTxTypOfBnkAc), tr.PerqBankType) AS PeqTxTypOfBnkAc from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='Q' and (tr.ActionType='P' or tr.STATUS='P')) as TempCheque

	--dd payment details
	select * into #tempDD from (select distinct(tr.ExerciseNo), tr.PaymentNameEX as[Demand Draft  (DD) No (Exercise amount)],tr.DrawnOn as [DD Date (Exercise amount)],tr.BankName as [Bank Name drawn on (Exercise amount)],tr.PaymentNamePQ as [Demand Draft  (DD) No (Perquisite tax)],tr.PerqAmt_DrownOndate as [DD Date (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name drawn on (Perquisite tax)], tr.Branch as [Bank Address (Exercise amount)] ,tr.AccountNo as [Bank Account No  (Exercise amount)], tr.ExAmtTypOfBnkAc, tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)], tr.PeqTxTypOfBnkAc from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='D' and (tr.ActionType='P' or tr.STATUS='P')) as TempDD

	--wire transfer payment details
	select * into #tempWired from (select distinct(tr.ExerciseNo), tr.PaymentNameEX as [Wire Transfer No (Exercise amount)], tr.IBANNo as [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)],tr.BankName as [Bank Name transferred from (Exercise amount)],tr.DrawnOn as [Wire Transfer Date (Exercise amount)],tr.PaymentNamePQ as [Wire Transfer No (Perquisite tax)],tr.IBANNoPQ as [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name transferred from (Perquisite tax)],tr.PerqAmt_DrownOndate as [Wire Transfer Date (Perquisite tax)],tr.Branch as [Bank Address (Exercise amount)],tr.AccountNo as [Bank Account No  (Exercise amount)], tr.ExAmtTypOfBnkAc, tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)], tr.PeqTxTypOfBnkAC from ShTransactionDetails tr inner join  SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='W' and (tr.ActionType='P' or tr.STATUS='P')) as TempWr

	--RTGS payment details
	select * into #tempRTGS from (select distinct(tr.ExerciseNo), tr.PaymentNameEX as[RTGS/NEFT No (Exercise amount)],tr.BankName as [Bank Name transferred from (Exercise amount)],tr.DrawnOn as [Payment Date (Exercise amount)],tr.PaymentNamePQ as [RTGS/NEFT No (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name transferred from (Perquisite tax)],tr.PerqAmt_DrownOndate as [Payment Date (Perquisite tax)],tr.Branch as [Bank Address (Exercise amount)] ,tr.AccountNo as [Bank Account No  (Exercise amount)], tr.ExAmtTypOfBnkAC, tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)] , tr.PeqTxTypOfBnkAC from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='R' and (tr.ActionType='P' or tr.STATUS='P')) as TempRTGS

	---online payment details
	select * into #tempNTBank from (SELECT DISTINCT tr.sh_ExerciseNo as ExerciseNo,tr.TPSLTransID AS [Transaction ID],pb.bankname AS [Bank Name transferred from],tr.uniquetransactionno AS [UTRNo], tr.bankaccountno  AS [Bank Account No],tr.transaction_date AS [Payment Date], tr.TPSLTransID AS TPSLTransactionID,tr.MerchantreferenceNo  FROM  transaction_details tr INNER JOIN shexercisedoptions she ON tr.sh_ExerciseNo = she.exerciseno AND (she.paymentmode IN ('N','')) LEFT OUTER JOIN paymentbankmaster PB ON tr.bankid = pb.bankid WHERE TR.Transaction_Date = (SELECT MAX(TED.Transaction_Date) FROM Transaction_Details TED WHERE TED.Sh_ExerciseNo = TR.Sh_ExerciseNo)) as TempNTBank


	UPDATE #tempmain set 
		[Amount Paid] = (ESD.FaceValue * ESD.SharesIssued), 
		[Perquiste Value] = (SEO.FMVPrice-ESD.FaceValue) * SharesIssued
	FROM #tempmain
			INNER JOIN ShExercisedOptions SEO ON SEO.ExerciseId = #tempMain.[Exercise ID] 
			INNER JOIN ExerciseSARDetails ESD ON ESD.ExerciseSARid = SEO.ExerciseSARid 

	BEGIN

		DECLARE @STR_SQL AS VARCHAR(MAX) , @WHERE_CLAUSE_IN_MAIN AS VARCHAR(MAX), @PaymentMode VARCHAR(500), 
				@CALLED_FROM AS VARCHAR(20)

		SET @WHERE_CLAUSE_IN_MAIN = ''
		SET @CALLED_FROM = ''

		CREATE TABLE #TEMP_ExProcSetting
			(
				PaymentMode varchar(1)		
			)

		---ALL DATA
		IF @Activity = 'A'
			BEGIN
				INSERT INTO #TEMP_ExProcSetting SELECT DISTINCT PaymentMode FROM ExerciseProcessSetting		
				SET @WHERE_CLAUSE_IN_MAIN = ' '
			END
		---Receipt of Exercise form	
		ELSE IF @Activity = 'R'
			BEGIN
				INSERT INTO #TEMP_ExProcSetting SELECT DISTINCT PaymentMode FROM ExerciseProcessSetting WHERE TrustRecOfEXeForm = 'Y' OR NTrustsRecOfEXeForm = 'Y'		
				SET @WHERE_CLAUSE_IN_MAIN = ' WHERE #tempmain.exerciseformreceived  = ''N'''
			END
		ELSE
			BEGIN 	
				--Deposit of Payment Instruction
				IF @Activity = 'D'
					BEGIN
						INSERT INTO #TEMP_ExProcSetting SELECT DISTINCT PaymentMode FROM ExerciseProcessSetting WHERE TrustDepositOfPayInstrument = 'Y' OR NTrustDepositOfPayInstrument = 'Y'					
						---FOR COMBINATION OF NTrustsRecOfEXeForm AND NTrustDepositOfPayInstrument (Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')
								SET @WHERE_CLAUSE_IN_MAIN = ' WHERE (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm AND TrustDepositOfPayInstrument (Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
									
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
							
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm AND NTrustDepositOfPayInstrument (N AND Y)			
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END	
							
						---FOR COMBINATION OF TrustRecOfEXeForm AND TrustDepositOfPayInstrument (N AND Y)			
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END				
					END
					
				ELSE IF @Activity = 'C'
					BEGIN
						INSERT INTO #TEMP_ExProcSetting SELECT DISTINCT PaymentMode FROM ExerciseProcessSetting WHERE TrustPayRecConfirmation = 'Y' OR NTrustPayRecConfirmation = 'Y'								
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument AND NTrustPayRecConfirmation (Y, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')
								SET @WHERE_CLAUSE_IN_MAIN = ' WHERE (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument AND TrustPayRecConfirmation (Y, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
									
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
							
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument AND NTrustPayRecConfirmation (Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument AND TrustPayRecConfirmation (Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument AND NTrustPayRecConfirmation (N, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustsRecOfEXeForm, TrustDepositOfPayInstrument AND TrustPayRecConfirmation (N, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END	
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument AND NTrustPayRecConfirmation (N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument AND TrustPayRecConfirmation (N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 0 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END

					END
				ELSE IF @Activity = 'U'
					BEGIN
						INSERT INTO #TEMP_ExProcSetting SELECT DISTINCT PaymentMode FROM ExerciseProcessSetting	WHERE TrustPayRecConfirmation = 'Y' OR NTrustPayRecConfirmation = 'Y' OR TrustPayRecConfirmation = 'N' OR NTrustPayRecConfirmation = 'N'
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')	
								SET @WHERE_CLAUSE_IN_MAIN = ' WHERE (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList(Y, Y, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
									
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END	
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, N, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, N, Y AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, Y, Y AND Y )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, Y, Y AND Y )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, Y, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, N, Y AND Y )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, N, Y AND Y )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''N'',''Y'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, N, N AND Y)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'Y')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''N'',''Y'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, Y AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')	
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
									
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList(Y, Y, Y AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y'  AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
									
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
							END	
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, Y, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, N, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, N, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, N, Y AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (Y, N, Y AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'Y' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  = ''Y'' AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, Y, Y AND N )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, Y, Y AND N )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
						
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, Y, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, Y, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'Y' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited = 1 AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, N, Y AND N )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, N, Y AND N )
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'Y' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''Y'',''N'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed = 1 AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (N, N, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'N' AND NTrustDepositOfPayInstrument = 'N' AND NTrustPayRecConfirmation = 'N' AND NTrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''N'',''Y'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END
							
						---FOR COMBINATION OF TrustRecOfEXeForm, TrustDepositOfPayInstrument, TrustPayRecConfirmation, TrustGenShareTransList (N, N, N AND N)
						IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N'))
							BEGIN
								SET @PaymentMode = NULL
								SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (TrustRecOfEXeForm = 'N' AND TrustDepositOfPayInstrument = 'N' AND TrustPayRecConfirmation = 'N' AND TrustGenShareTransList = 'N')
								SET @PaymentMode = (@PaymentMode + '''')										
								
								IF(LEN(@WHERE_CLAUSE_IN_MAIN) > 0)
									SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' OR '
								ELSE
									SET @WHERE_CLAUSE_IN_MAIN = ' WHERE '
								
								SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (#tempmain.exerciseformreceived  IN (''N'',''Y'') AND #tempmain.IsPaymentDeposited IN (0,1) AND #tempmain.IsPaymentConfirmed IN (0,1) AND #tempmain.IsAllotmentGenerated = 1 AND #tempmain.TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND #tempmain.PaymentMode IN (' + @PaymentMode + '))'
								
							END			
					END
			END
	END
	--SELECT * FROM #TEMP_ExProcSetting
	SET @STR_SQL =
	'
	SELECT #tempmain.[Exercise number/Application number], 
		   #tempmain.[Exercise ID], 
		   #tempmain.[Employee ID], 
		   #tempmain.[Employee Name], 
           #tempmain.[Country],
		   #tempmain.[Scheme Name], 
		   #tempmain.[Grant Registration ID], 
		   #tempmain.[Grant Date], 
		   #tempmain.[Grant Option ID], 
		   #tempmain.[Options Exercised], 
		   #tempmain.[Exercise Price], 
		   #tempmain.[Amount Paid], 
		   #tempmain.[Exercise Date], 
		   #tempmain.fmv, 
		   #tempmain.[Perquiste Value], 
		   #tempmain.[Perquisite Tax payable], 
		   #tempmain.[Perq_Tax_rate],
		   #tempmain.[Equivalent Exercise Quantity],
		   #tempmain.[Grant vest period id], 
		   #tempmain.[Vesting Date], 
		   #tempmain.[Payment mode],
		   #tempmain.PaymentMode,
		   #tempmain.Paymentdate ,
		   #tempmain.lotnumber, 
		   #tempmain.validationstatus, 
		   #tempmain.revarsalreason, 
		   #tempmain.receiveddate, 
		   #tempmain.exerciseformreceived, 
		   #tempmain.exformreceivedstatus,
		   #tempmain.IsPaymentDeposited,
		   #tempmain.PaymentDepositedDate,
		   #tempmain.IsPaymentConfirmed,
		   #tempmain.PaymentConfirmedDate,
		   #tempmain.IsExerciseAllotted,
		   #tempmain.ExerciseAllotedDate,
		   #tempmain.IsAllotmentGenerated,
		   #tempmain.AllotmentGenerateDate,
		   #tempmain.IsAllotmentGeneratedReversed,
		   #tempmain.AllotmentGeneratedReversedDate, 
		   #tempmain.MIT_ID,
		   #tempmain.[INSTRUMENT_NAME],
		   #tempdemat.[Name as in Depository Participant (DP) records], 
		   #tempdemat.[Name of Depository], 
		   #tempdemat.[Demat A/C Type], 
		   #tempdemat.[Name of Depository Participant (DP)], 
		   #tempdemat.[Depository ID], 
		   CONVERT(TEXT, #tempdemat.[Client ID])                    AS [Client ID], 
		   #tempdemat.pan, 
		   #tempdemat.[Residential Status], 
		   #tempdemat.nationality, 
		   #tempdemat.location, 
		   CASE WHEN (#tempdemat.[Mobile Number] IS NOT NULL AND (LEN(RTRIM(LTRIM(#tempdemat.[Mobile Number])))!= 0)) THEN '''' +  #tempdemat.[Mobile Number] END as [Mobile Number] ,
		   #tempdemat.[Broker Company Name] ,
           #tempdemat.[Broker Company Id] ,
           #tempdemat.[Broker Electronic Account Number] ,
		   #tempmain.[Email Address], 
		   #tempmain.[Employee Address], 
		   #tempchq.[Cheque No (Exercise amount)], 
		   #tempchq.[Cheque Date (Exercise amount)], 
		   #tempchq.[Bank Name drawn on (Exercise amount)], 
		   #tempchq.[Cheque No (Perquisite tax)], 
		   #tempchq.[Cheque Date (Perquisite tax)], 
		   #tempchq.[Bank Name drawn on (Perquisite tax)], 
		   #tempchq.[Bank Address (Exercise amount)] AS [CHEQUE_Bank_Address_Exercise_amount],
		   #tempchq.[Bank Account No  (Exercise amount)] AS [CHEQUE_Bank_Account_No_Exercise_amount],       
		   ISNULL((SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE CONVERT(VARCHAR, TypeOfBankAcID) = CONVERT(VARCHAR,#tempchq.ExAmtTypOfBnkAC)),#tempchq.ExAmtTypOfBnkAC) AS [CHEQUE_ExAmtTypOfBnkAC],
		   #tempchq.[Bank Address (Perquisite tax)] AS [CHEQUE_Bank_Address_Perquisite_tax],
		   #tempchq.[Bank Account No  (Perquisite tax)] AS [CHEQUE_Bank_Account_No_Perquisite_tax],
		   ISNULL((SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE CONVERT(VARCHAR, TypeOfBankAcID) = CONVERT(VARCHAR,#tempchq.PeqTxTypOfBnkAC)),#tempchq.PeqTxTypOfBnkAC) AS [CHEQUE_PeqTxTypOfBnkAC],
		   #tempdd.[Demand Draft  (DD) No (Exercise amount)], 
		   #tempdd.[DD Date (Exercise amount)], 
		   #tempdd.[Bank Name drawn on (Exercise amount)] AS [(DD)Bank Name drawn on (Exercise amount)], 
		   #tempdd.[Demand Draft  (DD) No (Perquisite tax)], 
		   #tempdd.[DD Date (Perquisite tax)], 
		   #tempdd.[Bank Name drawn on (Perquisite tax)] AS [(DD)Bank Name drawn on (Perquisite tax)], 
		   #tempdd.[Bank Address (Exercise amount)] AS [DD_Bank_Address_Exercise_amount],
		   #tempdd.[Bank Account No  (Exercise amount)] AS [DD_Bank_Account_No_Exercise_amount],       
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #tempdd.ExAmtTypOfBnkAC) AS [DD_ExAmtTypOfBnkAC],
		   #tempdd.[Bank Address (Perquisite tax)] AS [DD_Bank_Address_Perquisite_tax],
		   #tempdd.[Bank Account No  (Perquisite tax)] AS [DD_Bank_Account_No_Perquisite_tax],
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #tempdd.PeqTxTypOfBnkAC) AS [DD_PeqTxTypOfBnkAC],
		   case when ( #tempwired.[Wire Transfer No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim( #tempwired.[Wire Transfer No (Exercise amount)])))!= 0)) then '''' +   #tempwired.[Wire Transfer No (Exercise amount)] END as [Wire Transfer No (Exercise amount)] ,
		   case when ( #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(   #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)])))!= 0)) then '''' +     #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] END as   [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] ,
		   #tempwired.[Bank Name transferred from (Exercise amount)], 
		   case when (#tempwired.[Bank Account No  (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[Bank Account No  (Exercise amount)])))!= 0)) then '''' + #tempwired.[Bank Account No  (Exercise amount)] END as  [Bank Account No  (Exercise amount)] ,
		   #tempwired.[Wire Transfer Date (Exercise amount)], 
		   #tempwired.[Wire Transfer Date (Perquisite tax)], 
		   case when (#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)])))!= 0)) then '''' + #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] END as [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],
		   #tempwired.[Bank Name transferred from (Perquisite tax)], 
		   #tempwired.[Bank Address (Perquisite tax)], 
		   case when (#tempwired.[Bank Account No  (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[Bank Account No  (Perquisite tax)])))!= 0)) then '''' + #tempwired.[Bank Account No  (Perquisite tax)] END as [Bank Account No  (Perquisite tax)],       
		   #tempwired.[Bank Address (Exercise amount)] AS [WT_Bank_Address_Exercise_amount],
		   #tempwired.[Bank Account No  (Exercise amount)] AS [WT_Bank_Account_No_Exercise_amount],       
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #tempwired.ExAmtTypOfBnkAC) AS [WT_ExAmtTypOfBnkAC],
		   #tempwired.[Bank Address (Perquisite tax)] AS [WT_Bank_Address_Perquisite_tax],
		   #tempwired.[Bank Account No  (Perquisite tax)] AS [WT_Bank_Account_No_Perquisite_tax],
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #tempwired.PeqTxTypOfBnkAC) AS [WT_PeqTxTypOfBnkAC],       
		   case when (#temprtgs.[RTGS/NEFT No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[RTGS/NEFT No (Exercise amount)])))!= 0)) then '''' + #temprtgs.[RTGS/NEFT No (Exercise amount)] END as [RTGS/NEFT No (Exercise amount)],
		   #temprtgs.[Bank Name transferred from (Exercise amount)] AS [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], 
		   case when (#temprtgs.[Bank Account No  (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[Bank Account No  (Exercise amount)])))!= 0)) then '''' + #temprtgs.[Bank Account No  (Exercise amount)] END [(RTGS/NEFT No) Bank Account No  (Exercise amount)], 
		   #temprtgs.[Payment Date (Exercise amount)] AS [(RTGS/NEFT No)Payment Date (Exercise amount)], 
		   case when (#temprtgs.[RTGS/NEFT No (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[RTGS/NEFT No (Perquisite tax)])))!= 0)) then '''' + #temprtgs.[RTGS/NEFT No (Perquisite tax)] END [RTGS/NEFT No (Perquisite tax)], 
		   #temprtgs.[Bank Name transferred from (Perquisite tax)]  AS [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)], 
		   #temprtgs.[Bank Address (Perquisite tax)]                AS [(RTGS/NEFT No)Bank Address (Perquisite tax)], 
		   case when (#temprtgs.[Bank Account No  (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[Bank Account No  (Perquisite tax)])))!= 0)) then '''' + #temprtgs.[Bank Account No  (Perquisite tax)] END [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], 
		   #temprtgs.[Payment Date (Perquisite tax)]                AS [(RTGS/NEFT No) Payment Date (Perquisite tax)], 
		   #temprtgs.[Bank Address (Exercise amount)] AS [RTGS_Bank_Address_Exercise_amount],
		   #temprtgs.[Bank Account No  (Exercise amount)] AS [RTGS_Bank_Account_No_Exercise_amount],       
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #temprtgs.ExAmtTypOfBnkAC) AS [RTGS_ExAmtTypOfBnkAC],
		   #temprtgs.[Bank Address (Perquisite tax)] AS [RTGS_Bank_Address_Perquisite_tax],
		   #temprtgs.[Bank Account No  (Perquisite tax)] AS [RTGS_Bank_Account No_Perquisite_tax],
		   (SELECT TypeOfBankAcName FROM TypeOfBankAc WHERE TypeOfBankAcID = #temprtgs.PeqTxTypOfBnkAC) AS [RTGS_PeqTxTypOfBnkAC],        
		   case when (#tempntbank.[Transaction ID] IS Not NULL AND (len(rtrim(ltrim(#tempntbank.[Transaction ID])))!= 0)) then '''' + #tempntbank.[Transaction ID] END [Transaction ID], 
		   #tempntbank.[Bank Name transferred from], 
		   #tempntbank.[UTRNo], 
		   #tempntbank.[Bank Account No], 
		   #tempntbank.[Payment Date],
		   #tempntbank.TPSLTransactionID,
		   #tempntbank.MerchantreferenceNo,
			#tempmain.[Account number],		
			#tempmain.ConfStatus,
			#tempmain.DateOfJoining,
			#tempmain.DateOfTermination,
			#tempmain.Department,
			#tempmain.EmployeeDesignation,
			#tempmain.Entity,
			#tempmain.Grade,
			#tempmain.Insider,		
			#tempmain.ReasonForTermination,		
			#tempmain.SBU,
			#tempmain.IS_UPLOAD_EXERCISE_FORM,
			#tempmain.IS_UPLOAD_EXERCISE_FORM_ON,
			#tempmain.COMPANY_ID,
			#tempmain.[Settlment Price], 
			#tempmain.[Stock Appreciation Value], 
			#tempmain.[Cash Payout Value],
			#tempmain.[Expiry Date]

	FROM   #tempmain 
		   LEFT OUTER JOIN #tempdemat 
			 ON #tempmain.[Exercise number/Application number] = 
				#tempdemat.[Exercise number/Application number] 
		   LEFT OUTER JOIN #tempchq 
			 ON #tempmain.[Exercise number/Application number] = #tempchq.exerciseno
			LEFT OUTER JOIN #tempdd 
			 ON #tempmain.[Exercise number/Application number] = #tempdd.exerciseno 
		   LEFT OUTER JOIN #tempwired 
			 ON #tempmain.[Exercise number/Application number] = 
				#tempwired.exerciseno 
		   LEFT OUTER JOIN #temprtgs 
			 ON #tempmain.[Exercise number/Application number] = 
				#temprtgs.exerciseno 
		   LEFT OUTER JOIN #tempntbank 
			 ON #tempmain.[Exercise number/Application number] = 
				#tempntbank.exerciseno ' 
	SET @STR_SQL = @STR_SQL + CASE WHEN @Activity = 'A' THEN ' LEFT OUTER ' ELSE ' INNER ' END 

	SET @STR_SQL = @STR_SQL +
		  'JOIN #TEMP_ExProcSetting
			 ON #TEMP_ExProcSetting.PaymentMode = #tempmain.PaymentMode
	 '		 
	+ 
	@WHERE_CLAUSE_IN_MAIN +
	' ORDER BY #tempmain.[Exercise number/Application number] ' 
	
	--EXECUTE (@STR_SQL)
	
	--Create tamp table for enter all record /  result into temp
	CREATE TABLE #ENTITY_TRANSACTIOREPORT
	(
	  [Exercise number/Application number] NUMERIC (18, 0), [Exercise ID] NUMERIC (18, 0), [Employee ID] NVARCHAR(500), [Employee Name] VARCHAR (75)
	, [Country] VARCHAR (50), [Scheme Name] VARCHAR (50), [Grant Registration ID] VARCHAR (20), [Grant Date] DATETIME, [Grant Option ID] VARCHAR (100)
	, [Options Exercised] NUMERIC (18, 0), [Exercise Price] NUMERIC (18, 2), [Amount Paid] NUMERIC (37, 2), [Exercise Date] DATETIME
	, fmv NUMERIC (18, 2), [Perquiste Value] NUMERIC (18, 2), [Perquisite Tax payable] NUMERIC (18, 2), [Perq_Tax_rate] NUMERIC (18, 6)
	, [Equivalent Exercise Quantity] NUMERIC (38, 0), [Grant vest period id] DECIMAL (10, 0), [Vesting Date] DATETIME, [Payment mode] VARCHAR (20)
	, PaymentMode VARCHAR (1),Paymentdate DATETIME, lotnumber VARCHAR (20), validationstatus VARCHAR (1), revarsalreason VARCHAR (1), receiveddate DATETIME
	, exerciseformreceived VARCHAR (10), exformreceivedstatus VARCHAR (3), IsPaymentDeposited BIT, PaymentDepositedDate DATETIME
	, IsPaymentConfirmed BIT, PaymentConfirmedDate DATETIME, IsExerciseAllotted BIT, ExerciseAllotedDate DATETIME
	, IsAllotmentGenerated BIT, AllotmentGenerateDate DATETIME, IsAllotmentGeneratedReversed BIT, AllotmentGeneratedReversedDate DATETIME
	, MIT_ID INT, [INSTRUMENT_NAME] NVARCHAR (500), [Name as in Depository Participant (DP) records] VARCHAR (50), [Name of Depository] VARCHAR (200)
	, [Demat A/C Type] VARCHAR (50), [Name of Depository Participant (DP)] VARCHAR (200), [Depository ID] VARCHAR (50), [Client ID] TEXT
	, pan VARCHAR (50), [Residential Status] VARCHAR (16), nationality VARCHAR (100), location VARCHAR (200), [Mobile Number] VARCHAR (51)
	, [Broker Company Name] VARCHAR (200), [Broker Company Id] VARCHAR (200),[Broker Electronic Account Number] VARCHAR (200), [Email Address] VARCHAR (500)
	, [Employee Address] VARCHAR (500), [Cheque No (Exercise amount)] VARCHAR (100), [Cheque Date (Exercise amount)] DATETIME, [Bank Name drawn on (Exercise amount)] VARCHAR (200)
	, [Cheque No (Perquisite tax)] VARCHAR (100), [Cheque Date (Perquisite tax)] DATETIME, [Bank Name drawn on (Perquisite tax)] VARCHAR (200), [CHEQUE_Bank_Address_Exercise_amount] VARCHAR (200)
	, [CHEQUE_Bank_Account_No_Exercise_amount] VARCHAR (50), [CHEQUE_ExAmtTypOfBnkAC] VARCHAR (150), [CHEQUE_Bank_Address_Perquisite_tax] VARCHAR (200)
	, [CHEQUE_Bank_Account_No_Perquisite_tax] VARCHAR (50), [CHEQUE_PeqTxTypOfBnkAC] VARCHAR (150), [Demand Draft  (DD) No (Exercise amount)] VARCHAR (100)
	, [DD Date (Exercise amount)] DATETIME, [(DD)Bank Name drawn on (Exercise amount)] VARCHAR (200), [Demand Draft  (DD) No (Perquisite tax)] VARCHAR (100)
	, [DD Date (Perquisite tax)] DATETIME, [(DD)Bank Name drawn on (Perquisite tax)] VARCHAR (200), [DD_Bank_Address_Exercise_amount] VARCHAR (200)
	, [DD_Bank_Account_No_Exercise_amount] VARCHAR (50), [DD_ExAmtTypOfBnkAC] VARCHAR (150), [DD_Bank_Address_Perquisite_tax] VARCHAR (200)
	, [DD_Bank_Account_No_Perquisite_tax] VARCHAR (50), [DD_PeqTxTypOfBnkAC] VARCHAR (150), [Wire Transfer No (Exercise amount)] VARCHAR (101)
	, [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] VARCHAR (101),[Bank Name transferred from (Exercise amount)] VARCHAR (200), [Bank Account No  (Exercise amount)] VARCHAR (51)
	, [Wire Transfer Date (Exercise amount)] DATETIME, [Wire Transfer Date (Perquisite tax)] DATETIME, [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] VARCHAR (101)
	, [Bank Name transferred from (Perquisite tax)] VARCHAR (200), [Bank Address (Perquisite tax)] VARCHAR (200), [Bank Account No  (Perquisite tax)] VARCHAR (51)
	, [WT_Bank_Address_Exercise_amount] VARCHAR (200), [WT_Bank_Account_No_Exercise_amount] VARCHAR (50), [WT_ExAmtTypOfBnkAC] VARCHAR (150)
	, [WT_Bank_Address_Perquisite_tax] VARCHAR (200), [WT_Bank_Account_No_Perquisite_tax] VARCHAR (50), [WT_PeqTxTypOfBnkAC] VARCHAR (150)
	, [RTGS/NEFT No (Exercise amount)] VARCHAR (101), [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)] VARCHAR (200), [(RTGS/NEFT No) Bank Account No  (Exercise amount)] VARCHAR (51)
	, [(RTGS/NEFT No)Payment Date (Exercise amount)] DATETIME,[RTGS/NEFT No (Perquisite tax)] VARCHAR (101), [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)] VARCHAR (200)
	, [(RTGS/NEFT No)Bank Address (Perquisite tax)] VARCHAR (200), [(RTGS/NEFT No) Bank Account No  (Perquisite tax)] VARCHAR (51), [(RTGS/NEFT No) Payment Date (Perquisite tax)] DATETIME
	, [RTGS_Bank_Address_Exercise_amount] VARCHAR (200), [RTGS_Bank_Account_No_Exercise_amount] VARCHAR (50), [RTGS_ExAmtTypOfBnkAC] VARCHAR (150)
	, [RTGS_Bank_Address_Perquisite_tax] VARCHAR (200), [RTGS_Bank_Account No_Perquisite_tax] VARCHAR (50), [RTGS_PeqTxTypOfBnkAC] VARCHAR (150)
	, [Transaction ID] VARCHAR (101), [Bank Name transferred from] VARCHAR (100), [UTRNo] VARCHAR (30), [Bank Account No] INT, [Payment Date] DATETIME
	, [Account number] VARCHAR (20), ConfStatus CHAR (1), DateOfJoining DATETIME, DateOfTermination DATETIME, Department VARCHAR (200)
	, EmployeeDesignation VARCHAR (200), Entity VARCHAR (200), Grade VARCHAR (200), Insider CHAR (1), ReasonForTermination VARCHAR (50), SBU VARCHAR (200),[Entity as on Date of Grant] VARCHAR(100),[Entity as on Date of Exercise] VARCHAR(100)
	,IS_UPLOAD_EXERCISE_FORM VARCHAR (200),IS_UPLOAD_EXERCISE_FORM_ON VARCHAR (200),COMPANY_ID VARCHAR(200), [Settlment Price] NUMERIC (18, 2), [Stock Appreciation Value] NUMERIC (18, 2), [Cash Payout Value] NUMERIC (18, 2),
	TPSLTransactionID VARCHAR(50),MerchantreferenceNo VARCHAR(100), [Expiry Date] DATETIME
	)
	--Enter all record / result into temp
	INSERT INTO #ENTITY_TRANSACTIOREPORT
	(
	[Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name]
	, [Country], [Scheme Name], [Grant Registration ID], [Grant Date], [Grant Option ID]
	, [Options Exercised] , [Exercise Price], [Amount Paid], [Exercise Date]
	, fmv, [Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate]
	, [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], [Payment mode]
	, PaymentMode,Paymentdate, lotnumber, validationstatus, revarsalreason, receiveddate
	, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited , PaymentDepositedDate
	, IsPaymentConfirmed , PaymentConfirmedDate, IsExerciseAllotted , ExerciseAllotedDate
	, IsAllotmentGenerated , AllotmentGenerateDate, IsAllotmentGeneratedReversed , AllotmentGeneratedReversedDate
	, MIT_ID, [INSTRUMENT_NAME], [Name as in Depository Participant (DP) records], [Name of Depository]
	, [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID]
	, pan, [Residential Status], nationality, location, [Mobile Number]
	, [Broker Company Name], [Broker Company Id], [Broker Electronic Account Number], [Email Address]
	, [Employee Address], [Cheque No (Exercise amount)], [Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)]
	, [Cheque No (Perquisite tax)], [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)], [CHEQUE_Bank_Address_Exercise_amount]
	, [CHEQUE_Bank_Account_No_Exercise_amount], [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax]
	, [CHEQUE_Bank_Account_No_Perquisite_tax], [CHEQUE_PeqTxTypOfBnkAC], [Demand Draft  (DD) No (Exercise amount)]
	, [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], [Demand Draft  (DD) No (Perquisite tax)]
	, [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount]
	, [DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax]
	, [DD_Bank_Account_No_Perquisite_tax], [DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)]
	, [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)],[Bank Name transferred from (Exercise amount)], [Bank Account No  (Exercise amount)]
	, [Wire Transfer Date (Exercise amount)], [Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)]
	, [Bank Name transferred from (Perquisite tax)], [Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)]
	, [WT_Bank_Address_Exercise_amount], [WT_Bank_Account_No_Exercise_amount], [WT_ExAmtTypOfBnkAC]
	, [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax], [WT_PeqTxTypOfBnkAC]
	, [RTGS/NEFT No (Exercise amount)], [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)]
	, [(RTGS/NEFT No)Payment Date (Exercise amount)],[RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)]
	, [(RTGS/NEFT No)Bank Address (Perquisite tax)], [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)]
	, [RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC]
	, [RTGS_Bank_Address_Perquisite_tax], [RTGS_Bank_Account No_Perquisite_tax], [RTGS_PeqTxTypOfBnkAC]
	, [Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No], [Payment Date],TPSLTransactionID,MerchantreferenceNo
	, [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department
	, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,IS_UPLOAD_EXERCISE_FORM,IS_UPLOAD_EXERCISE_FORM_ON,COMPANY_ID
	, [Settlment Price],[Stock Appreciation Value],[Cash Payout Value],[Expiry Date]	
	)EXECUTE (@STR_SQL)

--Create tamp table for Entity Fields
	CREATE TABLE #TEMP_ENTITY_DATA_SSRS
	(
		SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
		EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE
	)
--enter  entity fileds value

	INSERT INTO #TEMP_ENTITY_DATA_SSRS
	(
		SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
	)	
-- execute procedure to get entity fields value
	EXEC PROC_EMP_MOVEMENT_TRANSFER_REPORT 'Entity'

	--update #ENTITY_TRANSACTIOREPORT table [Entity Grant] column
   	UPDATE 
		 PRE SET PRE.[Entity as on Date of Grant]= TED.ENTITY
	FROM #ENTITY_TRANSACTIOREPORT AS PRE
   		INNER JOIN #TEMP_ENTITY_DATA_SSRS AS TED ON PRE.[Employee ID] = TED.EMPLOYEEID 
   		AND (CONVERT(DATE,PRE.[Grant Date]) >= CONVERT(DATE, ISNULL(TED.FROMDATE, PRE.[Grant Date])))
   		AND (CONVERT(DATE,PRE.[Grant Date]) <= CONVERT(DATE, ISNULL(TED.TODATE, PRE.[Grant Date])))
   	
	--update #ENTITY_TRANSACTIOREPORT table [Entity Exercise] column
    UPDATE 
		 PRE SET PRE.[Entity as on Date of Exercise] = TED.ENTITY
	FROM #ENTITY_TRANSACTIOREPORT AS PRE
   		INNER JOIN #TEMP_ENTITY_DATA_SSRS AS TED ON PRE.[Employee ID] = TED.EMPLOYEEID 
   		AND (CONVERT(DATE,PRE.[Exercise Date]) >= CONVERT(DATE, ISNULL(TED.FROMDATE, PRE.[Exercise Date])))
   		AND (CONVERT(DATE,PRE.[Exercise Date]) <= CONVERT(DATE, ISNULL(TED.TODATE, PRE.[Exercise Date])))
   	
	/* Code For Getting Instrument wise Payment mode*/
	--CREATE TABLE #TBLPaymentModeConfig
	--(
	--PaymentMode NVARCHAR(50),PayModeName NVARCHAR(50),IsOneProcessFlow BIT ,MIT_ID BIGINT
	--)
	/*Code to update Paymentmode and Upload and declaration status*/
	Print 'STEP1'
	UPDATE ET
	SET ET.[Payment mode]=CASE WHEN (PC.IsOneProcessFlow=1 AND ISNULL(ET.[Payment mode],'')<>'' AND IS_UPLOAD_EXERCISE_FORM ='Pending') THEN '' ELSe ET.[Payment mode]END
	,ET.[IS_UPLOAD_EXERCISE_FORM]=CASE WHEN (PC.IsOneProcessFlow=1 AND ISNULL(ET.[Payment mode],'')<>'' AND IS_UPLOAD_EXERCISE_FORM ='Pending') THEN '' ELSe ET.IS_UPLOAD_EXERCISE_FORM END
	FROM #ENTITY_TRANSACTIOREPORT ET INNER JOIN (
	SELECT distinct PM.PaymentMode,PM.PayModeName,RP.IsOneProcessFlow,CIM.MIT_ID FROM ResidentialPaymentMode RP 
	INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON RP.MIT_ID=CIM.MIT_ID AND RP.PAYMENT_MODE_CONFIG_TYPE=(
	CASE WHEN (CIM.PAYMENTMODE_BASED_ON='rdoResidentStatus') THEN 'Resident'
	WHEN(CIM.PAYMENTMODE_BASED_ON='rdoCompanyLevel') THEN 'Company' Else '' END	)
	INNER JOIN PaymentMaster PM ON RP.PaymentMaster_Id = PM.Id 
	WHERE  RP.isActivated='Y' AND RP.IsOneProcessFlow=1
	) PC ON ET.MIT_ID=PC.MIT_ID
	 
	Print 'STEP2' 

-- Finaly select temp table with effective column [Entity Exercise],[Entity Grant] with value
	SELECT  * FROM #ENTITY_TRANSACTIOREPORT
	INSERT INTO OnlineTransactionData
	([Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name]
	, [Country], [Scheme Name], [Grant Registration ID], [Grant Date], [Grant Option ID]
	, [Options Exercised] , [Exercise Price], [Amount Paid], [Exercise Date]
	, fmv, [Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate]
	, [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], [Payment mode]
	, PaymentMode, lotnumber, validationstatus, revarsalreason, receiveddate
	, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited , PaymentDepositedDate
	, IsPaymentConfirmed , PaymentConfirmedDate, IsExerciseAllotted , ExerciseAllotedDate
	, IsAllotmentGenerated , AllotmentGenerateDate, IsAllotmentGeneratedReversed , AllotmentGeneratedReversedDate
	, MIT_ID, [INSTRUMENT_NAME], [Name as in Depository Participant (DP) records], [Name of Depository]
	, [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID]
	, pan, [Residential Status], nationality, location, [Mobile Number]
	, [Broker Company Name], [Broker Company Id], [Broker Electronic Account Number], [Email Address]
	, [Employee Address], [Cheque No (Exercise amount)], [Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)]
	, [Cheque No (Perquisite tax)], [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)], [CHEQUE_Bank_Address_Exercise_amount]
	, [CHEQUE_Bank_Account_No_Exercise_amount], [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax]
	, [CHEQUE_Bank_Account_No_Perquisite_tax], [CHEQUE_PeqTxTypOfBnkAC], [Demand Draft  (DD) No (Exercise amount)]
	, [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], [Demand Draft  (DD) No (Perquisite tax)]
	, [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount]
	, [DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax]
	, [DD_Bank_Account_No_Perquisite_tax], [DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)]
	, [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)],[Bank Name transferred from (Exercise amount)], [Bank Account No  (Exercise amount)]
	, [Wire Transfer Date (Exercise amount)], [Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)]
	, [Bank Name transferred from (Perquisite tax)], [Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)]
	, [WT_Bank_Address_Exercise_amount], [WT_Bank_Account_No_Exercise_amount], [WT_ExAmtTypOfBnkAC]
	, [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax], [WT_PeqTxTypOfBnkAC]
	, [RTGS/NEFT No (Exercise amount)], [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)]
	, [(RTGS/NEFT No)Payment Date (Exercise amount)],[RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)]
	, [(RTGS/NEFT No)Bank Address (Perquisite tax)], [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)]
	, [RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC]
	, [RTGS_Bank_Address_Perquisite_tax], [RTGS_Bank_Account No_Perquisite_tax], [RTGS_PeqTxTypOfBnkAC]
	, [Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No], [Payment Date]
	, [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department
	, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,IS_UPLOAD_EXERCISE_FORM,IS_UPLOAD_EXERCISE_FORM_ON,COMPANY_ID
	, [Settlment Price],[Stock Appreciation Value],[Cash Payout Value]	)
    SELECT 
	[Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name]
	, [Country], [Scheme Name], [Grant Registration ID], [Grant Date], [Grant Option ID]
	, [Options Exercised] , [Exercise Price], [Amount Paid], [Exercise Date]
	, fmv, [Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate]
	, [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], [Payment mode]
	, PaymentMode, lotnumber, validationstatus, revarsalreason, receiveddate
	, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited , PaymentDepositedDate
	, IsPaymentConfirmed , PaymentConfirmedDate, IsExerciseAllotted , ExerciseAllotedDate
	, IsAllotmentGenerated , AllotmentGenerateDate, IsAllotmentGeneratedReversed , AllotmentGeneratedReversedDate
	, MIT_ID, [INSTRUMENT_NAME], [Name as in Depository Participant (DP) records], [Name of Depository]
	, [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID]
	, pan, [Residential Status], nationality, location, [Mobile Number]
	, [Broker Company Name], [Broker Company Id], [Broker Electronic Account Number], [Email Address]
	, [Employee Address], [Cheque No (Exercise amount)], [Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)]
	, [Cheque No (Perquisite tax)], [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)], [CHEQUE_Bank_Address_Exercise_amount]
	, [CHEQUE_Bank_Account_No_Exercise_amount], [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax]
	, [CHEQUE_Bank_Account_No_Perquisite_tax], [CHEQUE_PeqTxTypOfBnkAC], [Demand Draft  (DD) No (Exercise amount)]
	, [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], [Demand Draft  (DD) No (Perquisite tax)]
	, [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount]
	, [DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax]
	, [DD_Bank_Account_No_Perquisite_tax], [DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)]
	, [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)],[Bank Name transferred from (Exercise amount)], [Bank Account No  (Exercise amount)]
	, [Wire Transfer Date (Exercise amount)], [Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)]
	, [Bank Name transferred from (Perquisite tax)], [Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)]
	, [WT_Bank_Address_Exercise_amount], [WT_Bank_Account_No_Exercise_amount], [WT_ExAmtTypOfBnkAC]
	, [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax], [WT_PeqTxTypOfBnkAC]
	, [RTGS/NEFT No (Exercise amount)], [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)]
	, [(RTGS/NEFT No)Payment Date (Exercise amount)],[RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)]
	, [(RTGS/NEFT No)Bank Address (Perquisite tax)], [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)]
	, [RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC]
	, [RTGS_Bank_Address_Perquisite_tax], [RTGS_Bank_Account No_Perquisite_tax], [RTGS_PeqTxTypOfBnkAC]
	, [Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No], [Payment Date]
	, [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department
	, EmployeeDesignation, Entity, Grade, Insider, ReasonForTermination, SBU,IS_UPLOAD_EXERCISE_FORM,IS_UPLOAD_EXERCISE_FORM_ON,COMPANY_ID
	, [Settlment Price],[Stock Appreciation Value],[Cash Payout Value]	
	 FROM #ENTITY_TRANSACTIOREPORT
END

PRINT @WHERE_CLAUSE_IN_MAIN
DROP TABLE #TEMP_ExProcSetting
DROP TABLE #ENTITY_TRANSACTIOREPORT
GO
