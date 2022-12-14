/****** Object:  StoredProcedure [dbo].[Proc_getvalidateexercisedata]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_getvalidateexercisedata]
GO
/****** Object:  StoredProcedure [dbo].[Proc_getvalidateexercisedata]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_getvalidateexercisedata](@Employeeid VARCHAR(5000), 
                                                     @SchemeId   VARCHAR(5000)) 
--exec Proc_getvalidateexercisedata '327',''
AS 
  BEGIN 
--- for scheme id 
IF  (@SchemeId = '') or (@SchemeId is null)
	begin
		SET @SchemeId ='%%'
	end
ELSE
	SET @SchemeId = @SchemeId

--- for employee id 
IF  (@Employeeid ='') or (@Employeeid is null)
	SET @Employeeid ='%%'
ELSE
	SET @Employeeid = @Employeeid 
--SELECT @ROUNDTAXAMT=CP.RoundupPlace_TaxAmt,@ROUNDTAXABLVAL=CP.RoundupPlace_TaxableVal,@ROUNDFMV=CP.RoundupPlace_FMV from CompanyParameters CP 

select * into #tempMain from (SELECT ex.exerciseno AS [Exercise number/Application number], 
             ex.exerciseid 
             AS [Exercise ID], 
             convert(text,ex.employeeid) 
             AS [Employee ID], 
             emp.employeename 
             AS [Employee Name], 
             sch.schemetitle 
             AS [Scheme Name], 
             gl.GrantRegistrationId  AS [Grant Registration ID], 
             REPLACE(CONVERT(VARCHAR(11), grantregistration.grantdate, 106), ' ', '/')  AS [Grant Date], 
             gl.grantoptionid AS [Grant Option ID], 
             ex.exercisedquantity * sch.optionratiodivisor / sch.optionratiomultiplier  AS [Options Exercised], 
             ex.exerciseprice AS [Exercise Price], 
             (Isnull(ex.exercisedquantity * sch.optionratiodivisor / sch.optionratiomultiplier, 0) * ex.exerciseprice)  AS [Amount Paid],
             
     
        
             REPLACE(CONVERT(VARCHAR(11), ex.exercisedate, 106), ' ', '/') AS [Exercise Date], 
             ex.fmvprice AS fmv, ex.perqstvalue AS [Perquiste Value], CAST(ex.perqstpayable  AS numeric(18,2)) AS [Perquisite Tax payable], 
               gl.grantlegid AS [Grant vest period id],
             REPLACE(CONVERT(VARCHAR(11), vestingperiod.vestingdate, 106), ' ', '/') AS [Vesting Date], 
             --CASE 
             --  WHEN emp.residentialstatus = 'R' THEN 'Resident Indian' 
             --  WHEN emp.residentialstatus = 'N' THEN 'Non Resident' 
             --  WHEN emp.residentialstatus = 'F' THEN 'Foreign National' 
             --END 
             --AS [Residential Status], 
             emp.EmployeeEmail as [Email Address],
             emp.employeeaddress  AS [Employee Address],
             pm.paymodename AS [Payment mode], 
             ex.lotnumber, 
                     REPLACE(CONVERT(VARCHAR(11), ex.receiveddate, 106), ' ', '/') AS receiveddate, 
           
             CASE 
               WHEN ex.validationstatus = 'N' THEN '' 
               ELSE ex.validationstatus 
             END 
             AS validationstatus, 
             '' 
             AS revarsalreason, 
             ex.exerciseformreceived, 
             CASE 
               WHEN ex.exerciseformreceived = 'Y' THEN 'Yes' 
               ELSE 'No' 
             END 
             AS exformreceivedstatus 
      FROM   shexercisedoptions AS ex 
             LEFT JOIN paymentmaster pm 
               ON ex.paymentmode = pm.paymentmode 
             INNER JOIN employeemaster AS emp 
               ON ex.employeeid = emp.employeeid 
                  AND ex.employeeid LIKE ''+ @Employeeid +''
                  
             INNER JOIN grantleg AS gl 
               ON ex.grantlegserialnumber = gl.id 
             INNER JOIN grantregistration 
               ON gl.grantregistrationid = grantregistration.grantregistrationid
             
             INNER JOIN vestingperiod 
               ON gl.grantregistrationid = vestingperiod.grantregistrationid AND gl.grantlegid = vestingperiod.vestingperiodno 
             INNER JOIN scheme AS sch 
               ON gl.schemeid = sch.schemeid 
                  AND sch.schemeid LIKE ''+ @SchemeId +''
                 
      WHERE  ( ex.validationstatus <> 'V' ) 
             AND ( ex.ACTION = 'A' ) 
             
     ) as T1
     
   
-----demat details        
select * into #tempDemat from(     
select #tempMain.[Exercise number/Application number], tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematACType as [Demat A/C Type],tr.DepositoryParticipantName as [Name of Depository Participant (DP)],tr.DPIDNo as [Depository ID],tr.ClientNo as [Client ID],tr.PANNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.Mobile as [Mobile Number] from ShTransactionDetails tr inner join #tempMain on tr.ExerciseNo=#tempMain.[Exercise number/Application number] and (tr.ActionType='P' or tr.STATUS='P')
union select #tempMain.[Exercise number/Application number],tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematAcType as [Demat A/C Type],tr.DPName as [Name of Depository Participant (DP)],tr.DPId as [Depository ID],tr.ClientId as [Client ID],tr.PanNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.MobileNumber as [Mobile Number] from TransactionDetails_CashLess tr inner join #tempMain on tr.ExerciseNo=#tempMain.[Exercise number/Application number] and tr.STATUS='P'
union select #tempMain.[Exercise number/Application number],tr.DPRecord as [Name as in Depository Participant (DP) records],tr.DepositoryName as [Name of Depository],tr.DematAcType as [Demat A/C Type],tr.DPName as [Name of Depository Participant (DP)],tr.DPId as [Depository ID],tr.ClientId as [Client ID],tr.PanNumber as [PAN],case when tr.ResidentialStatus='R' Then 'Resident Indian' when tr.ResidentialStatus='N' Then 'Non Resident' when tr.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],tr.Nationality,tr.Location,tr.MobileNumber as [Mobile Number] from Transaction_Details tr inner join #tempMain on tr.Sh_ExerciseNo=#tempMain.[Exercise number/Application number]and tr.STATUS='S'
) as T1
--select * from #tempDemat
select * into #tempExerciseNo from(select distinct(#tempMain.[Exercise number/Application number])as [Exercise number/Application number] from #tempMain where #tempMain.[Exercise number/Application number] not in (select #tempDemat.[Exercise number/Application number] from #tempDemat)) as TempExNo
--select * from #tempExerciseNo
INSERT  INTO  #tempDemat  
SELECT #tempExerciseNo.[Exercise number/Application number], EMPDET.DPRecord AS [Name as in Depository Participant (DP) records],EMPDET.DepositoryName as [Name of Depository],EMPDET.DematAccountType as [Demat A/C Type],EMPDET.DepositoryParticipantNo as [Name of Depository Participant (DP)],EMPDET.DepositoryIDNumber as [Depository ID],EMPDET.ClientIDNumber as [Client ID],EMPDET.PANNumber as [PAN],case when EMPDET.ResidentialStatus='R' Then 'Resident Indian' when EMPDET.ResidentialStatus='N' Then 'Non Resident' when EMPDET.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],NULL as Nationality,EMPDET.Location,NULL as [Mobile Number] from EMPDET_With_EXERCISE EMPDET inner Join #tempExerciseNo on EMPDET.ExerciseNo=#tempExerciseNo.[Exercise number/Application number]


SELECT * INTO #tempEMPMASTR FROM(SELECT DISTINCT(#tempMain.[Exercise number/Application number]) AS [Exercise number/Application number],CONVERT(varchar(50),#tempMain.[Employee ID])as [Employee ID]  from #tempMain where #tempMain.[Exercise number/Application number] not in (select #tempDemat.[Exercise number/Application number] from #tempDemat)) as TempExNo
--select * from #tempEMPMASTR

INSERT  INTO  #tempDemat  
SELECT #tempEMPMASTR.[Exercise number/Application number], EMP.DPRecord AS [Name as in Depository Participant (DP) records],EMP.DepositoryName as [Name of Depository],EMP.DematAccountType as [Demat A/C Type],EMP.DepositoryParticipantNo as [Name of Depository Participant (DP)],EMP.DepositoryIDNumber as [Depository ID],EMP.ClientIDNumber as [Client ID],EMP.PANNumber as [PAN],case when EMP.ResidentialStatus='R' Then 'Resident Indian' when EMP.ResidentialStatus='N' Then 'Non Resident' when EMP.ResidentialStatus='F' then 'Foreign National' END as [Residential Status],NULL as Nationality,EMP.Location,EMP.Mobile as [Mobile Number] from EmployeeMaster EMP inner Join #tempEMPMASTR on EMP.EmployeeID =#tempEMPMASTR.[Employee ID] 


----offline payment details 
--cheque payment details
select * into #tempChq from(
select distinct(tr.ExerciseNo), tr.PaymentNameEX as[Cheque No (Exercise amount)],tr.DrawnOn as [Cheque Date (Exercise amount)],tr.BankName as [Bank Name drawn on (Exercise amount)],tr.PaymentNamePQ as [Cheque No (Perquisite tax)],tr.PerqAmt_DrownOndate as [Cheque Date (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name drawn on (Perquisite tax)]   from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='Q' and (tr.ActionType='P' or tr.STATUS='P')
) as TempCheque
--dd payment details
select * into #tempDD from (
select distinct(tr.ExerciseNo), tr.PaymentNameEX as[Demand Draft  (DD) No (Exercise amount)],tr.DrawnOn as [DD Date (Exercise amount)],tr.BankName as [Bank Name drawn on (Exercise amount)],tr.PaymentNamePQ as [Demand Draft  (DD) No (Perquisite tax)],tr.PerqAmt_DrownOndate as [DD Date (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name drawn on (Perquisite tax)]   from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='D' and (tr.ActionType='P' or tr.STATUS='P')
) as TempDD
--wire transfer payment details
select * into #tempWired from (
select distinct(tr.ExerciseNo), tr.PaymentNameEX as [Wire Transfer No (Exercise amount)], tr.IBANNo as [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)],tr.BankName as [Bank Name transferred from (Exercise amount)],tr.Branch as [Bank Address(Exercise amount)],tr.AccountNo as [Bank Account No  (Exercise amount)],tr.DrawnOn as [Wire Transfer Date (Exercise amount)],tr.PaymentNamePQ as [Wire Transfer No (Perquisite tax)],tr.IBANNoPQ as [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name transferred from (Perquisite tax)],tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)],tr.PerqAmt_DrownOndate as [Wire Transfer Date (Perquisite tax)] from ShTransactionDetails tr inner join  SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='W' and (tr.ActionType='P' or tr.STATUS='P')
) as TempWr
--RTGS payment details
select * into #tempRTGS from (
select distinct(tr.ExerciseNo), tr.PaymentNameEX as[RTGS/NEFT No (Exercise amount)],tr.BankName as [Bank Name transferred from (Exercise amount)],tr.Branch as [Bank Address (Exercise amount)] ,tr.AccountNo as [Bank Account No  (Exercise amount)],tr.DrawnOn as [Payment Date (Exercise amount)],tr.PaymentNamePQ as [RTGS/NEFT No (Perquisite tax)],tr.PerqAmt_BankName as [Bank Name transferred from (Perquisite tax)],tr.PerqAmt_Branch as [Bank Address (Perquisite tax)],tr.PerqAmt_BankAccountNumber as [Bank Account No  (Perquisite tax)] ,tr.PerqAmt_DrownOndate as [Payment Date (Perquisite tax)]  from ShTransactionDetails tr inner join SHEXERCISEDOPTIONS she on tr.ExerciseNo=she.ExerciseNo and she.PaymentMode='R' and (tr.ActionType='P' or tr.STATUS='P')
) as TempRTGS
---online payment details
select * into #tempNTBank from (
SELECT DISTINCT tr.sh_ExerciseNo as ExerciseNo,tr.bankreferenceno AS [Transaction ID],pb.bankname AS [Bank Name transferred from],tr.uniquetransactionno AS [UTRNo], 
tr.bankaccountno  AS [Bank Account No],tr.transaction_date    AS[Payment Date] FROM   transaction_details tr INNER JOIN shexercisedoptions she ON tr.sh_ExerciseNo = she.exerciseno AND she.paymentmode = 'N' 
LEFT OUTER JOIN paymentbankmaster PB ON tr.bankid = pb.bankid WHERE TR.Transaction_Date = (SELECT MAX(TED.Transaction_Date) FROM Transaction_Details TED WHERE TED.Sh_ExerciseNo = TR.Sh_ExerciseNo)
) as TempNTBank

UPDATE #tempmain set [Amount Paid] = (ESD.FaceValue * ESD.SharesIssued)
, [Perquiste Value] = (SEO.FMVPrice-ESD.FaceValue) * SharesIssued
FROM #tempmain
INNER JOIN ShExercisedOptions SEO ON SEO.ExerciseId = #tempMain.[Exercise ID] 
INNER JOIN ExerciseSARDetails ESD ON ESD.ExerciseSARid = SEO.ExerciseSARid 


DECLARE @ROUNDTAXAMT AS int,@ROUNDTAXABLVAL AS int,@ROUNDFMV AS int,@ROUNDEXERCISEAMOUNT AS int
--SELECT @AmountPaid = CONVERT(INT, RoundupPlace_ExerciseAmount) from CompanyParameters CP
SELECT @ROUNDTAXAMT=CONVERT(INT, CP.RoundupPlace_TaxAmt),@ROUNDTAXABLVAL=CONVERT(INT, CP.RoundupPlace_TaxableVal),
@ROUNDFMV=CONVERT(INT, CP.RoundupPlace_FMV),@ROUNDEXERCISEAMOUNT = CONVERT(INT,CP.RoundupPlace_ExerciseAmount) from CompanyParameters CP 
exec('SELECT #tempmain.[Exercise number/Application number], 
       #tempmain.[Exercise ID], 
       #tempmain.[Employee ID], 
       #tempmain.[Employee Name], 
       #tempmain.[Scheme Name], 
       #tempmain.[Grant Registration ID], 
       #tempmain.[Grant Date], 
       #tempmain.[Grant Option ID], 
       #tempmain.[Options Exercised], 
       #tempmain.[Exercise Price], 
       convert(numeric(18,'+ @ROUNDEXERCISEAMOUNT + '), #tempmain.[Amount Paid]) as [Amount Paid], 
       #tempmain.[Exercise Date], 
       convert(numeric(18,'+ @ROUNDFMV + '),#tempmain.fmv) as FMV, 
        convert(numeric(18,'+ @ROUNDTAXABLVAL + '), #tempmain.[Perquiste Value]) AS [Perquiste Value], 
       convert(numeric(18,'+ @ROUNDTAXAMT + '),  #tempmain.[Perquisite Tax payable]) AS [Perquisite Tax payable], 
       #tempmain.[Grant vest period id], 
       #tempmain.[Vesting Date], 
       #tempmain.[Payment mode], 
       #tempmain.lotnumber, 
       #tempmain.validationstatus, 
       #tempmain.revarsalreason, 
       #tempmain.receiveddate, 
       #tempmain.exerciseformreceived, 
       #tempmain.exformreceivedstatus, 
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
       case when (#tempdemat.[Mobile Number] IS Not NULL AND (len(rtrim(ltrim(#tempdemat.[Mobile Number])))!= 0)) then '''' +  #tempdemat.[Mobile Number] END as [Mobile Number] ,
       #tempmain.[Email Address], 
       #tempmain.[Employee Address], 
       #tempchq.[Cheque No (Exercise amount)], 
       #tempchq.[Cheque Date (Exercise amount)], 
       #tempchq.[Bank Name drawn on (Exercise amount)], 
       #tempchq.[Cheque No (Perquisite tax)], 
       #tempchq.[Cheque Date (Perquisite tax)], 
       #tempchq.[Bank Name drawn on (Perquisite tax)], 
       #tempdd.[Demand Draft  (DD) No (Exercise amount)], 
       #tempdd.[DD Date (Exercise amount)], 
       #tempdd.[Bank Name drawn on (Exercise amount)]           AS 
       [(DD)Bank Name drawn on (Exercise amount)], 
       #tempdd.[Demand Draft  (DD) No (Perquisite tax)], 
       #tempdd.[DD Date (Perquisite tax)], 
       #tempdd.[Bank Name drawn on (Perquisite tax)]            AS 
       [(DD)Bank Name drawn on (Perquisite tax)], 
       case when ( #tempwired.[Wire Transfer No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim( #tempwired.[Wire Transfer No (Exercise amount)])))!= 0)) then '''' +   #tempwired.[Wire Transfer No (Exercise amount)] END as [Wire Transfer No (Exercise amount)] ,
      -- #tempwired.[Wire Transfer No (Exercise amount)], 
       case when ( #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(   #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)])))!= 0)) then '''' +     #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] END as   [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)] ,
       --#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)], 
       #tempwired.[Bank Name transferred from (Exercise amount)], 
       #tempwired.[Bank Address(Exercise amount)], 
       case when (#tempwired.[Bank Account No  (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[Bank Account No  (Exercise amount)])))!= 0)) then '''' + #tempwired.[Bank Account No  (Exercise amount)] END as  [Bank Account No  (Exercise amount)] ,
       --#tempwired.[Bank Account No  (Exercise amount)], 
       #tempwired.[Wire Transfer Date (Exercise amount)], 
       #tempwired.[Wire Transfer Date (Perquisite tax)], 
       case when (#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)])))!= 0)) then '''' + #tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)] END as [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],
       --#tempwired.[SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)], 
       #tempwired.[Bank Name transferred from (Perquisite tax)], 
       #tempwired.[Bank Address (Perquisite tax)], 
       case when (#tempwired.[Bank Account No  (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#tempwired.[Bank Account No  (Perquisite tax)])))!= 0)) then '''' + #tempwired.[Bank Account No  (Perquisite tax)] END as [Bank Account No  (Perquisite tax)],
       --#tempwired.[Bank Account No  (Perquisite tax)], 
       #tempwired.[Wire Transfer Date (Perquisite tax)], 
       case when (#temprtgs.[RTGS/NEFT No (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[RTGS/NEFT No (Exercise amount)])))!= 0)) then '''' + #temprtgs.[RTGS/NEFT No (Exercise amount)] END as [RTGS/NEFT No (Exercise amount)],
       --#temprtgs.[RTGS/NEFT No (Exercise amount)], 
       #temprtgs.[Bank Name transferred from (Exercise amount)] AS 
       [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], 
       #temprtgs.[Bank Address (Exercise amount)]               AS 
       [(RTGS/NEFT No)Bank Address (Exercise amount)], 
       case when (#temprtgs.[Bank Account No  (Exercise amount)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[Bank Account No  (Exercise amount)])))!= 0)) then '''' + #temprtgs.[Bank Account No  (Exercise amount)] END [(RTGS/NEFT No) Bank Account No  (Exercise amount)], 
      -- #temprtgs.[Bank Account No  (Exercise amount)]           AS 
      -- [(RTGS/NEFT No) Bank Account No  (Exercise amount)], 
       #temprtgs.[Payment Date (Exercise amount)]               AS 
       [(RTGS/NEFT No)Payment Date (Exercise amount)], 
       case when (#temprtgs.[RTGS/NEFT No (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[RTGS/NEFT No (Perquisite tax)])))!= 0)) then '''' + #temprtgs.[RTGS/NEFT No (Perquisite tax)] END [RTGS/NEFT No (Perquisite tax)], 
       --#temprtgs.[RTGS/NEFT No (Perquisite tax)], 
       #temprtgs.[Bank Name transferred from (Perquisite tax)]  AS 
       [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)], 
       #temprtgs.[Bank Address (Perquisite tax)]                AS 
       [(RTGS/NEFT No)Bank Address (Perquisite tax)], 
       case when (#temprtgs.[Bank Account No  (Perquisite tax)] IS Not NULL AND (len(rtrim(ltrim(#temprtgs.[Bank Account No  (Perquisite tax)])))!= 0)) then '''' + #temprtgs.[Bank Account No  (Perquisite tax)] END [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], 
       --#temprtgs.[Bank Account No  (Perquisite tax)]   AS  [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], 
       #temprtgs.[Payment Date (Perquisite tax)]                AS 
       [(RTGS/NEFT No) Payment Date (Perquisite tax)], 
       case when (#tempntbank.[Transaction ID] IS Not NULL AND (len(rtrim(ltrim(#tempntbank.[Transaction ID])))!= 0)) then '''' + #tempntbank.[Transaction ID] END [Transaction ID], 
       --#tempntbank.[Transaction ID], 
       #tempntbank.[Bank Name transferred from], 
       #tempntbank.[UTRNo], 
       #tempntbank.[Bank Account No], 
       #tempntbank.[Payment Date] 
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
            #tempntbank.exerciseno 
ORDER  BY #tempmain.[Exercise number/Application number]') 

End
GO
