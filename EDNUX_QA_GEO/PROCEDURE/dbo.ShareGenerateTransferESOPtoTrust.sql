/****** Object:  StoredProcedure [dbo].[ShareGenerateTransferESOPtoTrust]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ShareGenerateTransferESOPtoTrust]
GO
/****** Object:  StoredProcedure [dbo].[ShareGenerateTransferESOPtoTrust]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec ShareGenerateTransferESOPtoTrust
CREATE  PROCEDURE [dbo].[ShareGenerateTransferESOPtoTrust]
AS
      BEGIN
SELECT * INTO #TEMP1 FROM (
SELECT grantleg.schemeid                           AS SchemeName, 
       grantregistration.grantdate                 AS GrantDate, 
       employeemaster.employeeid                   AS EmployeeId, 
       employeemaster.employeename                 AS EmployeeName, 
       shexercisedoptions.exercisedquantity, 
       shexercisedoptions.exerciseprice, 
       shexercisedoptions.exerciseno, 
       shexercisedoptions.exerciseid, 
       shexercisedoptions.exercisedate, 
       (CASE shexercisedoptions.CALCULATE_TAX WHEN 'rdoActualTax' THEN ISNULL(shexercisedoptions.perqstpayable, 0)
                               WHEN 'rdoTentativeTax' THEN ISNULL(shexercisedoptions.TentativePerqstPayable, ISNULL(shexercisedoptions.perqstpayable, 0)) ELSE 0 END) AS PerquisiteTax,
       ShExercisedOptions.PaymentMode,
       ShExercisedOptions.exerciseformreceived,
       ShExercisedOptions.IsPaymentDeposited,
       ShExercisedOptions.IsPaymentConfirmed, 
       ShExercisedOptions.IsAllotmentGenerated,
       sch.TrustType,grantregistration.grantregistrationid,
       sch.MIT_ID as InstrumentTypeID        
 FROM   shexercisedoptions INNER JOIN employeemaster ON shexercisedoptions.employeeid = employeemaster.employeeid 
                                      INNER JOIN grantleg ON shexercisedoptions.grantlegserialnumber = grantleg.id 
                                      INNER JOIN grantregistration ON grantleg.grantregistrationid = grantregistration.grantregistrationid 
                                      INNER JOIN scheme sch ON sch.schemeid = grantleg.schemeid 
WHERE  ((shexercisedoptions.CALCULATE_TAX = 'rdoActualTax' AND shexercisedoptions.fmvprice IS NOT NULL) OR (shexercisedoptions.CALCULATE_TAX = 'rdoTentativeTax' AND (shexercisedoptions.fmvprice IS NOT NULL OR shexercisedoptions.TentativeFMVPrice IS NOT NULL)))
       AND sch.trusttype IN ( 'TC', 'TCOnly', 'TCLSA', 'TCLSP','TCLB', 'TCandCLSA', 'TCandCLSP', 'TCandCLB') 
       AND shexercisedoptions.paymentmode NOT IN ('A','P') ) AS T1


ALTER TABLE #TEMP1 ADD ID  int identity (1,1)      
ALTER TABLE #TEMP1 ADD DepositoryName varchar(50)
ALTER TABLE #TEMP1 ADD DPID varchar(50)
ALTER TABLE #TEMP1 ADD DPAccount varchar(50)
ALTER TABLE #TEMP1 ADD DepositoryParticipantName varchar(50)
ALTER TABLE #TEMP1 ADD BROKER_DEP_TRUST_CMP_NAME NVARCHAR(50)
ALTER TABLE #TEMP1 ADD BROKER_DEP_TRUST_CMP_ID NVARCHAR(50)
ALTER TABLE #TEMP1 ADD BROKER_ELECT_ACC_NUM NVARCHAR(50)

DECLARE @MINIDT INT,
          @MAXIDT INT,
            @EXERCISENO INT,
            @EXERCISEID INT,
            @PAYMENT_MODE CHAR,
            @EXERCISEFORMREQUIRED CHAR,
            @EMPLOYEEID VARCHAR (50) 
            
      

SELECT @MINIDT = MIN(ID), @MAXIDT = MAX(ID) FROM #TEMP1 
        
       WHILE @MINIDT <= @MAXIDT
       BEGIN
         SELECT @EMPLOYEEID=EmployeeID, @EXERCISENO=ExerciseNo,@EXERCISEID=ExerciseId,@PAYMENT_MODE=PaymentMode  FROM #TEMP1 WHERE ID=@MINIDT
         SELECT @EXERCISEFORMREQUIRED=PM.Exerciseform_Submit from PaymentMaster PM WHERE PM.PaymentMode=@PAYMENT_MODE
         IF (@PAYMENT_MODE is null or @PAYMENT_MODE='') AND EXISTS(SELECT * FROM PaymentMaster WHERE Exerciseform_Submit <> 'Y') BEGIN SET @EXERCISEFORMREQUIRED='N'   END
         

         IF (@PAYMENT_MODE='N')
            BEGIN 
				 IF( EXISTS(SELECT * FROM Transaction_Details WHERE Sh_ExerciseNo=@EXERCISENO AND payment_status = 'S' ))
				 BEGIN
                   UPDATE #TEMP1 SET DepositoryName=TD.DepositoryName,DPID=TD.DPId,DPAccount=TD.ClientId,DepositoryParticipantName=TD.DPName,BROKER_DEP_TRUST_CMP_NAME=TD.BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID=TD.BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM=TD.BROKER_ELECT_ACC_NUM   FROM Transaction_Details TD WHERE TD.Sh_ExerciseNo=@EXERCISENO and #TEMP1.ID = @MINIDT   AND TD.payment_status = 'S' 
                 END
                 ELSE  DELETE #TEMP1 WHERE #TEMP1.ID = @MINIDT
                 
             END
             ELSE IF (@PAYMENT_MODE='Q' OR @PAYMENT_MODE='W' OR @PAYMENT_MODE='R' OR @PAYMENT_MODE='D' )AND  EXISTS(SELECT * FROM ShTransactionDetails WHERE ExerciseNo=@EXERCISENO)
             BEGIN
                   UPDATE #TEMP1 SET DepositoryName=TD.DepositoryName,DPID=TD.DPIDNo,DPAccount=TD.ClientNo,DepositoryParticipantName=TD.DepositoryParticipantName,BROKER_DEP_TRUST_CMP_NAME=TD.BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID=TD.BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM=TD.BROKER_ELECT_ACC_NUM  FROM ShTransactionDetails TD WHERE TD.ExerciseNo=@EXERCISENO and #TEMP1.ID = @MINIDT
             END
             ELSE IF @EXERCISEFORMREQUIRED ='N' AND EXISTS(SELECT * FROM EMPDET_with_Exercise WHERE ExerciseNo=@EXERCISENO)
                            UPDATE #TEMP1 SET DepositoryName=TD.DepositoryName,DPID=TD.DepositoryIDNumber,DPAccount=TD.ClientIDNumber,DepositoryParticipantName=TD.DepositoryParticipantNo,BROKER_DEP_TRUST_CMP_NAME=TD.BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID=TD.BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM=TD.BROKER_ELECT_ACC_NUM  FROM EMPDET_with_Exercise TD WHERE TD.ExerciseNo=@EXERCISENO  and ID = @MINIDT
                 ELSE UPDATE #TEMP1 SET DepositoryName=EM.DepositoryName,DPID=EM.DepositoryIDNumber,DPAccount=EM.ClientIDNumber,DepositoryParticipantName=EM.DepositoryParticipantNo,BROKER_DEP_TRUST_CMP_NAME=EM.BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID=EM.BROKER_DEP_TRUST_CMP_ID,BROKER_ELECT_ACC_NUM=EM.BROKER_ELECT_ACC_NUM  FROM Employeemaster EM WHERE EM.Employeeid=@EMPLOYEEID AND ExerciseNo=@EXERCISENO  and ID = @MINIDT
            
            
            SET @PAYMENT_MODE =''       
            SET @MINIDT = @MINIDT + 1
     END
	
	DECLARE @STR_SQL AS VARCHAR(MAX) , @WHERE_CLAUSE_IN_MAIN AS VARCHAR(MAX), @PaymentMode VARCHAR(500)

BEGIN             
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
			PRINT 'CASE 1'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived = ''Y'' AND IsPaymentDeposited = 1 AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
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
			PRINT 'CASE 2'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited = 1 AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 3'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 4'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 5'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited = 1 AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 6'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited = 1 AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 7'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 8'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''N'',''Y'') AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 9'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived = ''Y'' AND IsPaymentDeposited = 1 AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
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
			PRINT 'CASE 10'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited = 1 AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 11'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
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
			PRINT 'CASE 12'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  = ''Y'' AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 13'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited = 1 AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 14'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited = 1 AND IsPaymentConfirmed IN (0,1) AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
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
			PRINT 'CASE 15'	
			SET @WHERE_CLAUSE_IN_MAIN = @WHERE_CLAUSE_IN_MAIN + ' (exerciseformreceived  IN (''Y'',''N'') AND IsPaymentDeposited IN (0,1) AND IsPaymentConfirmed = 1 AND IsAllotmentGenerated = 0 AND TrustType IN (''TC'', ''TCLSA'', ''TCLSP'', ''TCLB'', ''TCOnly'', ''TCandCLSA'', ''TCandCLSP'', ''TCandCLB'', ''CCSA'', ''CCSP'', ''CCB'') AND PaymentMode IN (' + @PaymentMode + '))'
			
		END
END
            
EXECUTE ('SELECT SchemeName, GrantDate ,EmployeeId,EmployeeName,ExercisedQuantity,ExercisePrice,ExerciseNo,ExerciseId,ExerciseDate,PerquisiteTax,DepositoryName=CASE  DepositoryName WHEN ''N'' THEN ''NSDL'' WHEN ''C'' THEN ''CDSL''ELSE '''' END ,DPID,DPAccount,DepositoryParticipantName,grantregistrationid, InstrumentTypeID,BROKER_DEP_TRUST_CMP_NAME,BROKER_DEP_TRUST_CMP_ID, BROKER_ELECT_ACC_NUM FROM #TEMP1 ' + @WHERE_CLAUSE_IN_MAIN)
     
 
DROP TABLE #TEMP1      
     
END  
GO
