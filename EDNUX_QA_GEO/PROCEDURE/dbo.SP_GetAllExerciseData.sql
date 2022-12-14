/****** Object:  StoredProcedure [dbo].[SP_GetAllExerciseData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetAllExerciseData]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetAllExerciseData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************
Modified By: Arpita Khot
Modified Date: 9.10.2013
Description: To Get all Exercise Data to perform Send Data to Cashless
exec SP_GetAllExerciseData '01/Feb/2017','08/Feb/2017','A','Y,N',4
*****************************************************************************************/
CREATE PROCEDURE [dbo].[SP_GetAllExerciseData]
(  
	@STARTDATE AS VARCHAR(11),
	@ENDDATE AS VARCHAR(11),
	@CASHLESSTYPE CHAR,
	@EXERCISEFORMRECEIVED VARCHAR(5),
	@INSTRUMENTID INT = NULL   
 )       
AS  
BEGIN  
SELECT 0 as IsSelected, ex.exerciseno,ex.exerciseid,ex.employeeid,   
		emp.employeename,   
		sch.schemetitle,   
		gop.grantregistrationid,  
		REPLACE(CONVERT(VARCHAR(11), grantregistration.grantdate, 106), ' ', '/') AS grantdate,   
		gop.grantoptionid,   
		convert(int, ex.exercisedquantity * sch.optionratiodivisor / sch.optionratiomultiplier)  
		AS   
		optionsexercised,   
		ex.exerciseprice,   
		convert(numeric(10,2), Isnull(ex.exercisedquantity * sch.optionratiodivisor /   
		sch.optionratiomultiplier, 0) * ex.exerciseprice )  
		AS amountpaid,   
         
		REPLACE(CONVERT(VARCHAR(11), ex.exercisedate, 106), ' ', '/') AS exercisedate,    
		CASE ex.CALCULATE_TAX WHEN 'rdoActualTax' THEN ex.fmvprice when 'rdoTentativeTax' THEN ISNULL(ex.TentativeFMVPrice, ex.fmvprice) END  
		AS fmvprice,  
		CASE ex.CALCULATE_TAX WHEN 'rdoActualTax' THEN ex.PerqstValue when 'rdoTentativeTax' THEN ISNULL(ex.TentativePerqstValue, ex.PerqstValue) END AS PerquisteValue,  
		CASE ex.CALCULATE_TAX WHEN 'rdoActualTax' THEN ex.PerqstPayable when 'rdoTentativeTax' THEN ISNULL(ex.TentativePerqstPayable, ex.PerqstPayable) END AS PerquisiteTaxpayable,   
		vestingperiod.vestingperiodid,  
		REPLACE(CONVERT(VARCHAR(11), vestingperiod.vestingdate, 106), ' ', '/') AS  vestingdate,   
          
		ISNULL(trc.DPRecord, EWE.DPRecord) AS NameAsinDepositoryParticipantRecords,  
		ISNULL(trc.DepositoryName, EWE.DepositoryName) AS NameOfDepository,   
		ISNULL(trc.DematACType, EWE.DematAccountType) AS DematACType,   
		ISNULL(trc.DPName, EWE.DepositoryParticipantNo) AS NameOfDepositoryParticipant,   
		ISNULL(trc.DPID, EWE.DepositoryIDNumber) AS DepositoryID,   
		ISNULL(trc.ClientID, EWE.ClientIDNumber) AS ClientID, 		  
		ISNULL(EWE.BROKER_DEP_TRUST_CMP_NAME, '') AS BrokerCompanyName,
		ISNULL(EWE.BROKER_DEP_TRUST_CMP_ID, '') AS BrokerCompanyID,
		ISNULL(EWE.BROKER_ELECT_ACC_NUM, '') AS BrokerElectAccountNo,
		emp.pannumber,   
		CASE WHEN emp.residentialstatus = 'R' THEN 'Resident Indian'   
		WHEN emp.residentialstatus = 'N' THEN 'Non Resident'  
		WHEN emp.residentialstatus = 'F' THEN 'Foreign National'  
		END  AS residentialstatus,    
		trc.Nationality AS nationality,		   
		emp.location,   
		trc.MobileNumber as mobile,   
		emp.employeeemail,   
		emp.employeeaddress,         
		pm.PayModeName AS paymentmode,   
		ex.lotnumber,   
		CASE WHEN ex.validationstatus = 'N' THEN ''  
		ELSE ex.validationstatus  
		END AS validationstatus,  
		ex.ExerciseFormReceived ,        
        
		REPLACE(CONVERT(VARCHAR(11), ex.ReceivedDate, 106), ' ', '/') AS ReceivedDate,          
		gl.grantlegid,  
		REPLACE(CONVERT(VARCHAR(11), gl.finalvestingdate, 106), ' ', '/') AS finalvestingdate,              
		sctQ.PaymentNameEX AS echequeno,  
		REPLACE(CONVERT(VARCHAR(11), sctQ.DrawnOn, 106), ' ', '/') AS echequedate,      
		sctQ.BankName   AS ebankname,  
		sctQ.PaymentNamePQ  AS pchequeno,  
		REPLACE(CONVERT(VARCHAR(11), sctQ.PerqAmt_DrownOndate , 106), ' ', '/')  AS pchequedate,         
		sctQ.PerqAmt_BankName  AS pbankname,  
		 
		sctD.PaymentNameEX AS eddno,  
		REPLACE(CONVERT(VARCHAR(11),  sctD.DrawnOn , 106), ' ', '/')  AS edddate,       
		sctD.BankName   AS eddbankname,  
		sctD.PaymentNamePQ  AS pddno,          
		REPLACE(CONVERT(VARCHAR(11), sctD.PerqAmt_DrownOndate , 106), ' ', '/') AS pdddate,   
		sctD.PerqAmt_BankName  AS pddbankname,   
			
		sctw.PaymentNameEX  AS ewtno,   
		sctw.IBANNo  AS ewswiftno,   
		sctw.BankName  AS ewbankname,  
		sctw.Branch AS ewbankaddress,    
		sctw.AccountNo AS ewbankaccountno,  
		REPLACE(CONVERT(VARCHAR(11), sctw.DrawnOn , 106), ' ', '/') AS ewtdate,         
		sctw.PaymentNamePQ AS pwtno,   
		sctw.IBANNoPQ AS pwswiftno,   
		sctw.PerqAmt_BankName AS pwbankname,   
		sctw.PerqAmt_Branch  AS pwbankaddress,   
		sctw.PerqAmt_BankAccountNumber AS pwbankaccountno,  
		REPLACE(CONVERT(VARCHAR(11),  sctw.PerqAmt_DrownOndate , 106), ' ', '/')AS pwtdate,            
	
		sctR.PaymentNameEX  AS ertgsno,   
		sctR.BankName AS ertgsbankname,   
		sctR.Branch AS ertgsbankaddress,   
		sctR.AccountNo AS ertgsbankaccountno,  
		REPLACE(CONVERT(VARCHAR(11),  sctR.DrawnOn, 106), ' ', '/')  AS ertgspaymentdate,        
		sctR.PaymentNamePQ  AS prtgsno,   
		sctR.PerqAmt_BankName  AS prtgsbankname,   
		sctR.PerqAmt_Branch  AS prtgsbankaddress,   
		sctR.PerqAmt_BankAccountNumber  AS prtgsbankaccountno,  
		REPLACE(CONVERT(VARCHAR(11),  sctR.PerqAmt_DrownOndate  , 106), ' ', '/')AS prtgspaymentdate,   

		 
		td.BankReferenceNo AS otransactionid,   
		pbm.BankName obankname,   
		td.BankAccountNo AS oaccountno,  
		REPLACE(CONVERT(VARCHAR(11),  td.Transaction_Date , 106), ' ', '/') AS opaymentdate,  
		'N' AS SentToCashless,
		mit.INSTRUMENT_NAME  
		   
		FROM   shexercisedoptions  ex   
		LEFT OUTER JOIN PaymentMaster pm  ON ex.PaymentMode = pm.PaymentMode   
		INNER JOIN employeemaster emp ON ex.employeeid = emp.employeeid   
		INNER JOIN grantleg  gl ON ex.grantlegserialnumber = gl.id   
		INNER JOIN grantregistration ON gl.grantregistrationid = grantregistration.grantregistrationid   
		INNER JOIN grantoptions  gop ON gl.grantoptionid = gop.grantoptionid   
		INNER JOIN vestingperiod ON gop.grantregistrationid = vestingperiod.grantregistrationid AND gl.grantlegid = vestingperiod.vestingperiodno   
		INNER JOIN scheme  sch ON gl.schemeid = sch.schemeid      
		LEFT OUTER JOIN TransactionDetails_CashLess trc ON ex.ExerciseNo=trc.ExerciseNo
		LEFT OUTER JOIN ShTransactionDetails sctQ  ON ex.ExerciseNo = sctQ.ExerciseNo AND Ex.PaymentMode='Q'  
		LEFT OUTER JOIN ShTransactionDetails sctD  ON ex.ExerciseNo = sctD.ExerciseNo AND Ex.PaymentMode='D'  
		LEFT OUTER JOIN ShTransactionDetails sctW  ON ex.ExerciseNo = sctW.ExerciseNo AND Ex.PaymentMode='W'   
		LEFT OUTER JOIN ShTransactionDetails sctR  ON ex.ExerciseNo= sctR.ExerciseNo AND Ex.PaymentMode='R'  
		LEFT OUTER JOIN Transaction_Details  td    ON ex.ExerciseNo = td.Sh_ExerciseNo    
		LEFT OUTER JOIN PaymentBankMaster PBM ON PBM.BankID=TD.BANKID  
		LEFT JOIN MST_INSTRUMENT_TYPE mit on mit.MIT_ID = sch.MIT_ID
		LEFT OUTER JOIN EMPDET_With_EXERCISE EWE ON EWE.ExerciseNo = ex.ExerciseNo
		
		WHERE (CONVERT(DATE, ex.ExerciseDate) BETWEEN CONVERT (DATE,@STARTDATE) AND CONVERT (DATE,@ENDDATE)) AND ex.PaymentMode=@CASHLESSTYPE   
		AND ex.exerciseid NOT IN(SELECT ExId FROM SentExercised) 
		AND ex.ExerciseFormReceived IN(SELECT Param FROM fn_MVParam(@EXERCISEFORMRECEIVED,','))
		AND sch.MIT_ID = CASE WHEN ISNULL(@INSTRUMENTID,0) = 0 THEN sch.MIT_ID ELSE @INSTRUMENTID END
		ORDER BY ex.ExerciseId   
END


GO
