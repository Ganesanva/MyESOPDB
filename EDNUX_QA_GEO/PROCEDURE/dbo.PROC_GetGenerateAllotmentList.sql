/****** Object:  StoredProcedure [dbo].[PROC_GetGenerateAllotmentList]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetGenerateAllotmentList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetGenerateAllotmentList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetGenerateAllotmentList] 
	@FromDate VARCHAR(50),
	@TODate VARCHAR(50)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @STR_SQL1 VARCHAR(MAX) , @WHERE_CLAUSE_IN_MAIN AS VARCHAR(MAX), @PaymentMode VARCHAR(50), @STR_FINAL VARCHAR(MAX) ,
			@ParmDate VARCHAR (500)
	
	SET @ParmDate = ''
	
	IF(@FromDate<>'') AND (@TODate<>'')
	BEGIN
		SET @ParmDate = ' AND (CONVERT(DATE,SEO.ExerciseDate) BETWEEN CONVERT(DATE,'''+@FromDate+''') AND CONVERT(DATE,'''+@TODate+'''))'
	END
	
	--PRINT @ParmDate
	
	SET @STR_SQL1 = 
		'
			SELECT DISTINCT SC.SchemeTitle, GR.GrantDate, EM.EmployeeID, EM.EmployeeName, SEO.ExerciseNo, SEO.ExerciseId, SEO.ExercisedQuantity,
			(CASE
				WHEN SEO.PaymentMode = ''Q'' THEN ''Cheque''
				WHEN SEO.PaymentMode = ''D'' THEN ''Demand Draft''
				WHEN SEO.PaymentMode = ''W'' THEN ''Wire Transfer''
				WHEN SEO.PaymentMode = ''R'' THEN ''RTGS'' 
				WHEN SEO.PaymentMode = ''I'' THEN ''Direct Debit''
				WHEN SEO.PaymentMode = ''F'' THEN ''Funding'' 
				WHEN SEO.PaymentMode = ''N'' THEN ''Online'' 
				END 
			) AS PaymentMode, 
			SEO.ExercisePrice, SEO.ExerciseDate, SEO.PerqstPayable, 
			(CASE 
				WHEN ((SEO.paymentmode = ''D'' OR SEO.paymentmode = ''Q'' OR SEO.paymentmode = ''R'' OR SEO.paymentmode = ''W'' OR SEO.paymentmode = ''I'') AND (SHOFF.DPIDNo IS NOT NULL OR SHOFF.DPIDNo!='''')) THEN SHOFF.DPIDNo 
				WHEN ((SEO.paymentmode = ''A'' OR SEO.paymentmode = ''P'') AND (SHCASH.DPId IS NOT NULL OR SHCASH.DPId!='''')) THEN SHCASH.DPId 
				WHEN (SEO.paymentmode = ''N'' AND (SHON.DPId IS NOT NULL OR SHON.DPId!='''')) THEN SHON.DPId 
				ELSE (EM.DepositoryIDNumber) 
			END) AS  DepositoryIDNumber,
			(CASE
				WHEN ((SEO.paymentmode = ''D'' OR SEO.paymentmode = ''Q'' OR SEO.paymentmode = ''R'' OR SEO.paymentmode = ''W'' OR SEO.paymentmode = ''I'') AND (SHOFF.DepositoryParticipantName IS NOT NULL OR SHOFF.DepositoryParticipantName!='''')) THEN SHOFF.DepositoryParticipantName 
				WHEN ((SEO.paymentmode = ''A'' OR SEO.paymentmode = ''P'') AND (SHCASH.DPName IS NOT NULL OR SHCASH.DPName!='''')) THEN SHCASH.DPName 
				WHEN (SEO.paymentmode = ''N'' AND (SHON.DPName IS NOT NULL OR SHON.DPName!='''')) THEN SHON.DPName 
				ELSE (EM.DepositoryParticipantNo)
			END) AS DepositoryParticipantNo, 
			(CASE 
				WHEN ((SEO.paymentmode = ''D'' OR SEO.paymentmode = ''Q'' OR SEO.paymentmode = ''R'' OR SEO.paymentmode = ''W'' OR SEO.paymentmode = ''I'') AND 	(SHOFF.ClientNo IS NOT NULL OR SHOFF.ClientNo!='''')) THEN SHOFF.ClientNo 
				WHEN ((SEO.paymentmode = ''A'' OR SEO.paymentmode = ''P'') AND (SHCASH.ClientId IS NOT NULL OR SHCASH.ClientId!='''')) THEN SHCASH.ClientId 
				WHEN (SEO.paymentmode = ''N'' AND (SHON.ClientId IS NOT NULL OR SHON.ClientId!='''')) THEN SHON.ClientId 
				ELSE EM.ClientIDNumber 
			END) AS  ClientIDNumber, 
			(CASE
				WHEN ((SEO.paymentmode = ''D'' OR SEO.paymentmode = ''Q'' OR SEO.paymentmode = ''R'' OR SEO.paymentmode = ''W'' OR SEO.paymentmode = ''I'') AND (SHOFF.DepositoryName IS NOT NULL OR SHOFF.DepositoryName!='''')) THEN 
					CASE WHEN SHOFF.DepositoryName=''N'' THEN ''NSDL'' 
						 WHEN SHOFF.DepositoryName=''C'' THEN ''CDSL'' 
						ELSE SHOFF.DepositoryName
					END    
				WHEN ((SEO.paymentmode = ''A'' OR SEO.paymentmode = ''P'') AND (SHCASH.DepositoryName IS NOT NULL OR SHCASH.DepositoryName!='''')) THEN
					CASE WHEN SHCASH.DepositoryName=''N'' THEN ''NSDL'' 
						 WHEN SHCASH.DepositoryName=''C'' THEN ''CDSL'' 
						 ELSE SHCASH.DepositoryName
					END
				WHEN (SEO.paymentmode = ''N'' AND (SHON.DepositoryName IS NOT NULL OR SHON.DepositoryName!='''')) THEN
					CASE WHEN SHON.DepositoryName=''N'' THEN ''NSDL'' 
						 WHEN SHON.DepositoryName=''C'' THEN ''CDSL'' 
						 ELSE SHON.DepositoryName 
					END
				ELSE
					CASE WHEN EM.DepositoryName=''N'' THEN ''NSDL'' 
						 WHEN EM.DepositoryName=''C'' THEN ''CDSL'' 
						ELSE EM.DepositoryName 
					END
			END) AS DepositoryName, 
			SEO.ExerciseFormReceived, PM.Exerciseform_Submit, SEO.ValidationStatus, SEO.LotNumber, SEO.IsAllotmentGenerated, SEO.IsAllotmentGeneratedReversed, EM.EmployeeEmail, EM.ResidentialStatus 
			FROM ShExercisedOptions AS SEO 
			INNER JOIN GrantLeg AS GL ON GL.ID = SEO.GrantLegSerialNumber 
			INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = SEO.EmployeeID 
			INNER JOIN GrantRegistration AS GR ON GR.GrantRegistrationId = GL.GrantRegistrationId 
			INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
			INNER JOIN PaymentMaster AS PM ON PM.PaymentMode = SEO.PaymentMode 
			LEFT OUTER JOIN shtransactiondetails SHOFF ON SEO.ExerciseNo = SHOFF.ExerciseNo 
			LEFT OUTER JOIN transactiondetails_funding SHFUND ON SEO.ExerciseNo = SHFUND.ExerciseNO 
			LEFT OUTER JOIN transaction_details SHON ON SEO.ExerciseNo = SHON.exerciseno 
			LEFT OUTER JOIN transactiondetails_cashless SHCASH ON SEO.ExerciseNo = SHCASH.ExerciseNo 
			WHERE (SEO.PaymentMode NOT IN (''A'',''P'')) AND (LEN(ISNULL(SEO.LotNumber,'''')) = 0) 
		'
	--=== AND condition base on exercise process setting data	
	
	BEGIN			
		---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, Y AND Y)
		IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y'))
			BEGIN
				SET @PaymentMode = NULL
				SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'Y')
				SET @PaymentMode = (@PaymentMode + '''')	
			    --PRINT 'CASE 1'
				SET @WHERE_CLAUSE_IN_MAIN = ' AND ((SEO.exerciseformreceived = ''Y'' AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 2'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 3'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 4'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 5'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 6'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 7'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 8'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''N'',''Y'') AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
			END
			
		---FOR COMBINATION OF NTrustsRecOfEXeForm, NTrustDepositOfPayInstrument, NTrustPayRecConfirmation, NTrustGenShareTransList (Y, Y, Y AND N)
		IF EXISTS(SELECT PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N'))
			BEGIN
				SET @PaymentMode = NULL
				SELECT @PaymentMode=COALESCE(@PaymentMode + ''',''', '''') + PaymentMode FROM ExerciseProcessSetting WHERE (NTrustsRecOfEXeForm = 'Y'  AND NTrustDepositOfPayInstrument = 'Y' AND NTrustPayRecConfirmation = 'Y' AND NTrustGenShareTransList = 'N')
				SET @PaymentMode = (@PaymentMode + '''')	
				--PRINT 'CASE 9'
				SET @WHERE_CLAUSE_IN_MAIN = ' AND ((SEO.exerciseformreceived = ''Y'' AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 10'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 11'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 12'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  = ''Y'' AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 13'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 14'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited = 1 AND SEO.IsPaymentConfirmed IN (0,1) AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
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
					SET @WHERE_CLAUSE_IN_MAIN = ' AND ('
				--PRINT 'CASE 15'
				SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (SEO.exerciseformreceived  IN (''Y'',''N'') AND SEO.IsPaymentDeposited IN (0,1) AND SEO.IsPaymentConfirmed = 1 AND SEO.IsAllotmentGenerated = 0 AND SC.TrustType IN (''N'',''CCNonTC'', ''CCNonTCCSA'', ''CCNonTCCSP'', ''CCNonTCCB'') AND SEO.PaymentMode IN (' + @PaymentMode + '))'
				
			END
	END		
		
	SET @WHERE_CLAUSE_IN_MAIN =  @WHERE_CLAUSE_IN_MAIN + ') ' + @ParmDate +  ' ORDER BY SEO.ExerciseId DESC '
	SET @STR_FINAL = @STR_SQL1 + @WHERE_CLAUSE_IN_MAIN 

	EXECUTE (@STR_FINAL)
	--PRINT (@STR_FINAL)
END
GO
