-- =============================================
-- Author:		Vrushali Kamthe
-- Create date: 2018-10-05
-- Description:	It extracts data from Proc_getvalidateexercisedata_SSRS procedure and dumps it into
--===================================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_OnlineTransactionReport')
BEGIN
DROP PROCEDURE SP_OnlineTransactionReport
END
GO

create    PROCEDURE [dbo].[SP_OnlineTransactionReport]
	-- Add the parameters for the stored procedure here
	@DBName VARCHAR(50),
	@LinkedServer VARCHAR(50),
	@Employeeid VARCHAR(MAX), 
	@SchemeId   VARCHAR(MAX),
	@Activity CHAR,
	@ESOPVersion VARCHAR (50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @USEDB VARCHAR(max) ='USE [' + @DBName +  ']'; 
    EXECUTE(@USEDB)

	DECLARE @StrInsertQuery AS VARCHAR(max);
	DECLARE @ClearDataQuery AS VARCHAR(max) = 'DELETE FROM [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[OnlineTransactionReport]' ;
	EXEC(@ClearDataQuery);
	--PRINT(@ClearDataQuery);
	
	DECLARE @StrPopulateDataQuery AS VARCHAR(max) = 'EXECUTE [dbo].[Proc_getvalidateexercisedata_SSRS] ''' + @Employeeid + ''', ''' + @SchemeId + ''', 
	''' + @Activity + '''';
	EXECUTE(@StrPopulateDataQuery);
	--PRINT(@StrPopulateDataQuery);

	IF(@ESOPVersion = 'Global')
	BEGIN
		 SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[OnlineTransactionReport]([Exercise number/Application number],
		 [Exercise ID], [Employee ID], [Employee Name], [Country], [Scheme Name],	[Grant Registration ID], [Grant Date], [Grant Option ID],
		 [Options Exercised], [Exercise Price], [Amount Paid], [Exercise Date], fmv, [Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate], 
		 [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], [Payment mode], PaymentMode, lotnumber, validationstatus, revarsalreason, 
		 receiveddate, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited, PaymentDepositedDate, IsPaymentConfirmed,
		 PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed,
		 AllotmentGeneratedReversedDate, MIT_ID, [INSTRUMENT_NAME], [Name as in Depository Participant (DP) records], [Name of Depository],
		 [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID],	pan, [Residential Status], nationality,
		 location, [Mobile Number], [Broker Company Name], [Broker Company Id],	[Broker Electronic Account Number],	[Email Address], [Employee Address],
		 [Cheque No (Exercise amount)],	[Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)], [Cheque No (Perquisite tax)],
		 [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)],	[CHEQUE_Bank_Address_Exercise_amount], [CHEQUE_Bank_Account_No_Exercise_amount],
		 [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax], [CHEQUE_Bank_Account_No_Perquisite_tax], [CHEQUE_PeqTxTypOfBnkAC],
		 [Demand Draft  (DD) No (Exercise amount)], [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], 
		 [Demand Draft  (DD) No (Perquisite tax)], [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount],
		 [DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax], [DD_Bank_Account_No_Perquisite_tax],
		 [DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)], [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)], [Bank Name transferred from (Exercise amount)], 
		 [Bank Account No  (Exercise amount)], [Wire Transfer Date (Exercise amount)], [Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],
		 [Bank Name transferred from (Perquisite tax)],	[Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)], [WT_Bank_Address_Exercise_amount],
		 [WT_Bank_Account_No_Exercise_amount], [WT_ExAmtTypOfBnkAC], [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax],	[WT_PeqTxTypOfBnkAC],
		 [RTGS/NEFT No (Exercise amount)], [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)],
		 [(RTGS/NEFT No)Payment Date (Exercise amount)], [RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)],
		 [(RTGS/NEFT No)Bank Address (Perquisite tax)],	[(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)],
		 [RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC], [RTGS_Bank_Address_Perquisite_tax],
		 [RTGS_Bank_Account No_Perquisite_tax],	[RTGS_PeqTxTypOfBnkAC],	[Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No],
		 [Payment Date], [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider,
		 ReasonForTermination, SBU, [Entity as on Date of Grant], [Entity as on Date of Exercise])
					(SELECT [Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name], [Country], [Scheme Name],	[Grant Registration ID], [Grant Date],
		 [Grant Option ID],	[Options Exercised], [Exercise Price], [Amount Paid], [Exercise Date], fmv,	[Perquiste Value], [Perquisite Tax payable], 
		 [Perq_Tax_rate], [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], [Payment mode], PaymentMode, lotnumber, validationstatus, 
		 revarsalreason, receiveddate, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited, PaymentDepositedDate, IsPaymentConfirmed,
		 PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, AllotmentGenerateDate, IsAllotmentGeneratedReversed,
		 AllotmentGeneratedReversedDate, MIT_ID, [INSTRUMENT_NAME], [Name as in Depository Participant (DP) records], [Name of Depository],
		 [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID],	pan, [Residential Status], nationality,
		 location, [Mobile Number], [Broker Company Name], [Broker Company Id],	[Broker Electronic Account Number],	[Email Address], [Employee Address],
		 [Cheque No (Exercise amount)],	[Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)], [Cheque No (Perquisite tax)],
		 [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)],	[CHEQUE_Bank_Address_Exercise_amount], [CHEQUE_Bank_Account_No_Exercise_amount],
		 [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax], [CHEQUE_Bank_Account_No_Perquisite_tax], [CHEQUE_PeqTxTypOfBnkAC],
		 [Demand Draft  (DD) No (Exercise amount)], [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], 
		 [Demand Draft  (DD) No (Perquisite tax)], [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount],
		 [DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax], [DD_Bank_Account_No_Perquisite_tax],
		 [DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)], [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)], [Bank Name transferred from (Exercise amount)], 
		 [Bank Account No  (Exercise amount)], [Wire Transfer Date (Exercise amount)], [Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)],
		 [Bank Name transferred from (Perquisite tax)],	[Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)], [WT_Bank_Address_Exercise_amount],
		 [WT_Bank_Account_No_Exercise_amount], [WT_ExAmtTypOfBnkAC], [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax],	[WT_PeqTxTypOfBnkAC],
		 [RTGS/NEFT No (Exercise amount)], [(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)],
		 [(RTGS/NEFT No)Payment Date (Exercise amount)], [RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)],
		 [(RTGS/NEFT No)Bank Address (Perquisite tax)],	[(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)],
		 [RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC], [RTGS_Bank_Address_Perquisite_tax],
		 [RTGS_Bank_Account No_Perquisite_tax],	[RTGS_PeqTxTypOfBnkAC],	[Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No],
		 [Payment Date], [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider,
		 ReasonForTermination, SBU, [Entity as on Date of Grant], [Entity as on Date of Exercise] FROM OnlineTransactionData WITH (NOLOCK))';	 

		 EXEC(@StrInsertQuery);
		 --PRINT(@StrInsertQuery);
 END
 ELSE
 BEGIN
		 SET @StrInsertQuery = 'INSERT INTO [' + @LinkedServer + '].[' + @DBName +  '].[dbo].[OnlineTransactionReport]([Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name], [Country], [Scheme Name], 
	[Grant Registration ID], [Grant Date], [Grant Option ID], [Options Exercised], [Exercise Price], [Amount Paid], [Exercise Date], fmv, 
	[Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate], [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], 
	[Payment mode], lotnumber, validationstatus, revarsalreason, receiveddate, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited, 
	PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, 
	AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, [Name as in Depository Participant (DP) records], 
	[Name of Depository], [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID], pan, [Residential Status], 
	nationality, location, [Mobile Number], [Broker Company Name], [Broker Company Id], [Broker Electronic Account Number], [Email Address], 
	[Employee Address], [Cheque No (Exercise amount)], [Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)], 
	[Cheque No (Perquisite tax)], [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)], [CHEQUE_Bank_Address_Exercise_amount], 
	[CHEQUE_Bank_Account_No_Exercise_amount], [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax], [CHEQUE_Bank_Account_No_Perquisite_tax], 
	[CHEQUE_PeqTxTypOfBnkAC], [Demand Draft  (DD) No (Exercise amount)], [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], 
	[Demand Draft  (DD) No (Perquisite tax)], [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount], 
	[DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax], [DD_Bank_Account_No_Perquisite_tax], 
	[DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)], [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)], 
	[Bank Name transferred from (Exercise amount)], [Bank Account No  (Exercise amount)], [Wire Transfer Date (Exercise amount)], 
	[Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)], [Bank Name transferred from (Perquisite tax)], 
	[Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)], [WT_Bank_Address_Exercise_amount], [WT_Bank_Account_No_Exercise_amount], 
	[WT_ExAmtTypOfBnkAC], [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax], [WT_PeqTxTypOfBnkAC], [RTGS/NEFT No (Exercise amount)], 
	[(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)], 
	[(RTGS/NEFT No)Payment Date (Exercise amount)], [RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)], 
	[(RTGS/NEFT No)Bank Address (Perquisite tax)], [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)], 
	[RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC], [RTGS_Bank_Address_Perquisite_tax], 
	[RTGS_Bank_Account No_Perquisite_tax], [RTGS_PeqTxTypOfBnkAC], [Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No], 
	[Payment Date], [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, 
	ReasonForTermination, SBU)
					(SELECT [Exercise number/Application number], [Exercise ID], [Employee ID], [Employee Name], [Country], [Scheme Name], 
	[Grant Registration ID], [Grant Date], [Grant Option ID], [Options Exercised], [Exercise Price], [Amount Paid], [Exercise Date], fmv, 
	[Perquiste Value], [Perquisite Tax payable], [Perq_Tax_rate], [Equivalent Exercise Quantity], [Grant vest period id], [Vesting Date], 
	[Payment mode], lotnumber, validationstatus, revarsalreason, receiveddate, exerciseformreceived, exformreceivedstatus, IsPaymentDeposited, 
	PaymentDepositedDate, IsPaymentConfirmed, PaymentConfirmedDate, IsExerciseAllotted, ExerciseAllotedDate, IsAllotmentGenerated, 
	AllotmentGenerateDate, IsAllotmentGeneratedReversed, AllotmentGeneratedReversedDate, [Name as in Depository Participant (DP) records], 
	[Name of Depository], [Demat A/C Type], [Name of Depository Participant (DP)], [Depository ID], [Client ID], pan, [Residential Status], 
	nationality, location, [Mobile Number], [Broker Company Name], [Broker Company Id], [Broker Electronic Account Number], [Email Address], 
	[Employee Address], [Cheque No (Exercise amount)], [Cheque Date (Exercise amount)], [Bank Name drawn on (Exercise amount)], 
	[Cheque No (Perquisite tax)], [Cheque Date (Perquisite tax)], [Bank Name drawn on (Perquisite tax)], [CHEQUE_Bank_Address_Exercise_amount], 
	[CHEQUE_Bank_Account_No_Exercise_amount], [CHEQUE_ExAmtTypOfBnkAC], [CHEQUE_Bank_Address_Perquisite_tax], [CHEQUE_Bank_Account_No_Perquisite_tax], 
	[CHEQUE_PeqTxTypOfBnkAC], [Demand Draft  (DD) No (Exercise amount)], [DD Date (Exercise amount)], [(DD)Bank Name drawn on (Exercise amount)], 
	[Demand Draft  (DD) No (Perquisite tax)], [DD Date (Perquisite tax)], [(DD)Bank Name drawn on (Perquisite tax)], [DD_Bank_Address_Exercise_amount], 
	[DD_Bank_Account_No_Exercise_amount], [DD_ExAmtTypOfBnkAC], [DD_Bank_Address_Perquisite_tax], [DD_Bank_Account_No_Perquisite_tax], 
	[DD_PeqTxTypOfBnkAC], [Wire Transfer No (Exercise amount)], [SWIFT (BIC)/ABN Routing IBAN No (Exercise amount)], 
	[Bank Name transferred from (Exercise amount)], [Bank Account No  (Exercise amount)], [Wire Transfer Date (Exercise amount)], 
	[Wire Transfer Date (Perquisite tax)], [SWIFT (BIC)/ABN Routing IBAN No (Perquisite tax)], [Bank Name transferred from (Perquisite tax)], 
	[Bank Address (Perquisite tax)], [Bank Account No  (Perquisite tax)], [WT_Bank_Address_Exercise_amount], [WT_Bank_Account_No_Exercise_amount], 
	[WT_ExAmtTypOfBnkAC], [WT_Bank_Address_Perquisite_tax], [WT_Bank_Account_No_Perquisite_tax], [WT_PeqTxTypOfBnkAC], [RTGS/NEFT No (Exercise amount)], 
	[(RTGS/NEFT No)Bank Name transferred from (Exercise amount)], [(RTGS/NEFT No) Bank Account No  (Exercise amount)], 
	[(RTGS/NEFT No)Payment Date (Exercise amount)], [RTGS/NEFT No (Perquisite tax)], [(RTGS/NEFT No)Bank Name transferred from (Perquisite tax)], 
	[(RTGS/NEFT No)Bank Address (Perquisite tax)], [(RTGS/NEFT No) Bank Account No  (Perquisite tax)], [(RTGS/NEFT No) Payment Date (Perquisite tax)], 
	[RTGS_Bank_Address_Exercise_amount], [RTGS_Bank_Account_No_Exercise_amount], [RTGS_ExAmtTypOfBnkAC], [RTGS_Bank_Address_Perquisite_tax], 
	[RTGS_Bank_Account No_Perquisite_tax], [RTGS_PeqTxTypOfBnkAC], [Transaction ID], [Bank Name transferred from], [UTRNo], [Bank Account No], 
	[Payment Date], [Account number], ConfStatus, DateOfJoining, DateOfTermination, Department, EmployeeDesignation, Entity, Grade, Insider, 
	ReasonForTermination, SBU FROM OnlineTransactionData WITH (NOLOCK))';	 

		 EXEC(@StrInsertQuery);
 END
	 
 DECLARE @StrUpdateQuery AS VARCHAR(max) = 'Update [' + @LinkedServer + '].[' + @DBName +  ']. [dbo].[OnlineTransactionReport] 
 SET PushDate = ''' + CONVERT (CHAR (50), GetDate(), 121) +'''';
 EXEC(@StrUpdateQuery);
 --PRINT(@StrUpdateQuery);

 SET @ClearDataQuery = 'DELETE FROM [dbo].[OnlineTransactionData]' ;
 EXEC(@ClearDataQuery);
 --PRINT(@ClearDataQuery);

END
GO

