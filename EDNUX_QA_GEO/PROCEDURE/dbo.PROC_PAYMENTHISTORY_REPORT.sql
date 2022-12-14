/****** Object:  StoredProcedure [dbo].[PROC_PAYMENTHISTORY_REPORT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PAYMENTHISTORY_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PAYMENTHISTORY_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_PAYMENTHISTORY_REPORT]  
(
	@CompanyID		VARCHAR(100),     
    @UserID         VARCHAR(20),      
    @ExerciseNo     VARCHAR(50)              
)       
AS  
BEGIN  
	
	SET NOCOUNT ON  
    /* Declare local variables  */
    DECLARE  @SqlString VARCHAR(4000),  @Count INT,  @PaymentMode VARCHAR(10)  

    CREATE TABLE #TempEX (INSTRUMENT_NAME VARCHAR(200),CurrencyAlias NVARCHAR(50),ExercisedQuantity  NUMERIC(18,0), ExercisedDate DATETIME,ExercisedPrice numeric(18,2),ExerciseNo VARCHAR(100),PerqstValue DECIMAL(18,2),PerqstPayable DECIMAL(18,2),FMVPrice DECIMAL(18,2),PaymentMode VARCHAR(100),SchemeId VARCHAR(100),GrantRegistrationId VARCHAR(100),GrantDate DATETIME,ExercisedId varchar(50))  

    IF (UPPER(@CompanyID)='FOURINT')  
    BEGIN  
		ALTER TABLE #TempEX ALTER COLUMN ExercisedPrice numeric(18,3)  
	END  
	CREATE TABLE #TempOff (PaymentNameEX VARCHAR(100),PaymentNamePQ VARCHAR(100),DrawnOn DATETIME,BankName VARCHAR(100),PerqAmt_DrownOndate DATETIME,PerqAmt_BankName VARCHAR(100),ExerciseNo VARCHAR(100))  
        
	CREATE TABLE #TEMPOnL (BankReferenceNo VARCHAR(100),Transaction_Date DATETIME,ExerciseNo VARCHAR(100))  
        
	Select @Count = COUNT(Exerciseno) from Exercised where Exerciseno = @ExerciseNo    
  
	IF @Count > 0  
		
		BEGIN  
			SET @SqlString = 'SELECT  DISTINCT   
									 CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,CM.CurrencyAlias, Exercised.ExercisedQuantity, Exercised.ExercisedDate, Exercised.ExercisedPrice,
									 Exercised.ExerciseNo, ' +
									 ' CASE WHEN Scheme.CALCULATE_TAX = ''rdoActualTax'' THEN Exercised.PerqstValue ELSE Exercised.TentativePerqstValue END AS PerqstValue, '+  
									 ' CASE WHEN Scheme.CALCULATE_TAX = ''rdoActualTax'' THEN Exercised.PerqstPayable ELSE Exercised.TentativePerqstPayable END AS PerqstPayable, '+
									 ' CASE WHEN Scheme.CALCULATE_TAX = ''rdoActualTax'' THEN Exercised.FMVPrice ELSE Exercised.TentativeFMVPrice END AS FMVPrice, '+
                                     ' CASE WHEN Exercised.PaymentMode = ''D'' then ''DD'' WHEN Exercised.PaymentMode = ''Q'' THEN ''CHEQUE'' WHEN Exercised.PaymentMode = ''R'' THEN ''RTGS'' WHEN Exercised.PaymentMode = ''W'' THEN ''WireTransfer'' WHEN Exercised.PaymentMode = ''N'' THEN ''Online''  WHEN Exercised.PaymentMode = ''I'' THEN ''Direct Debit'' WHEN Exercised.PaymentMode = ''X'' THEN ''Not Applicable'' END, Scheme.SchemeId, GrantRegistration.GrantRegistrationId, GrantRegistration.GrantDate,Exercised.exercisedid '+  
                                     ' FROM Exercised INNER JOIN GrantLeg ON Exercised.GrantLegSerialNumber = GrantLeg.ID INNER JOIN GrantOptions ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId INNER JOIN '+  
                                     'GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId AND GrantOptions.SchemeId = Scheme.SchemeId AND GrantRegistration.SchemeId = Scheme.SchemeId INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID=Scheme.MIT_ID INNER JOIN Scheme SH ON MIT.MIT_ID=SH.MIT_ID ' +  
                                     'INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON Exercised.MIT_ID = CIM.MIT_ID  '+
                                     'INNER JOIN CurrencyMaster CM ON CM.CurrencyID = CIM.CurrencyID '+
                                     'WHERE     (Exercised.ExerciseNo = ' +@ExerciseNo+')  '  
                                       
            INSERT INTO #TempEX(INSTRUMENT_NAME,CurrencyAlias,ExercisedQuantity , ExercisedDate ,ExercisedPrice ,ExerciseNo ,PerqstValue ,PerqstPayable ,FMVPrice ,PaymentMode ,SchemeId ,GrantRegistrationId ,GrantDate ,ExercisedId)  
            EXEC(@SqlString)  
            /*PRINT @SqlString              */
		END  
      ELSE  
		BEGIN  
			Set @SqlString ='SELECT   DISTINCT
									CASE WHEN ISNULL(CIM.INS_DISPLY_NAME,'''') != '''' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME END AS INSTRUMENT_NAME,
									CM.CurrencyAlias,ShExercisedOptions.ExercisedQuantity, ShExercisedOptions.ExerciseDate, ShExercisedOptions.ExercisePrice, ShExercisedOptions.ExerciseNo,  ' +  
                                    ' CASE WHEN Scheme.CALCULATE_TAX = ''rdoTentativeTax'' THEN ShExercisedOptions.TentativePerqstPayable ELSE ShExercisedOptions.PerqstPayable END AS PerqstPayable,
									 CASE WHEN Scheme.CALCULATE_TAX = ''rdoTentativeTax'' THEN  ShExercisedOptions.TentativePerqstValue ELSE ShExercisedOptions.PerqstValue END AS PerqstValue,
									 CASE WHEN Scheme.CALCULATE_TAX = ''rdoTentativeTax'' THEN ShExercisedOptions.TentativeFMVPrice ELSE ShExercisedOptions.FMVPrice END AS FMVPrice,
                                     CASE WHEN ShExercisedOptions.PaymentMode = ''D'' then ''DD'' WHEN ShExercisedOptions.PaymentMode = ''Q'' THEN ''CHEQUE'' WHEN ShExercisedOptions.PaymentMode = ''R'' THEN ''RTGS'' WHEN ShExercisedOptions.PaymentMode = ''W'' THEN ''WireTransfer'' WHEN ShExercisedOptions.PaymentMode = ''N'' THEN ''Online'' WHEN ShExercisedOptions.PaymentMode = ''I'' THEN ''Direct Debit'' WHEN ShExercisedOptions.PaymentMode = ''X'' THEN ''Not Applicable'' END,  
                                     Scheme.SchemeId,  ' +  
                                    'GrantRegistration.GrantRegistrationId, GrantRegistration.GrantDate,ShExercisedOptions.exerciseid ' +  
                                    'FROM GrantOptions INNER JOIN ' +  
                                    'GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId INNER JOIN ' +  
                                    'Scheme ON GrantOptions.SchemeId = Scheme.SchemeId AND GrantRegistration.SchemeId = Scheme.SchemeId INNER JOIN ' +  
                                    'GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId AND Scheme.SchemeId = GrantLeg.SchemeId INNER JOIN ' +  
                                    ' ShExercisedOptions ON GrantLeg.ID = ShExercisedOptions.GrantLegSerialNumber INNER JOIN MST_INSTRUMENT_TYPE MIT ON MIT.MIT_ID=Scheme.MIT_ID INNER JOIN Scheme SH ON MIT.MIT_ID=SH.MIT_ID ' +  
                                    'INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON ShExercisedOptions.MIT_ID = CIM.MIT_ID  '+
                                    'INNER JOIN CurrencyMaster CM ON CM.CurrencyID = CIM.CurrencyID '+
                                    ' WHERE (ShExercisedOptions.ExerciseNo = '+@ExerciseNo+')' 

            INSERT INTO #TempEX(INSTRUMENT_NAME,CurrencyAlias,ExercisedQuantity,ExercisedDate ,ExercisedPrice ,ExerciseNo ,PerqstPayable,PerqstValue,FMVPrice ,PaymentMode ,SchemeId ,GrantRegistrationId ,GrantDate,ExercisedId )   

            EXEC(@SqlString)  
            /*Print @SqlString       */
		END  
        
      Select @Count = COUNT(Exerciseno) from Exercised where Exerciseno = @ExerciseNo   
      if(@Count)>0  
      BEGIN  
            select  @PaymentMode =  PaymentMode from Exercised where Exerciseno =@ExerciseNo  
            if (@PaymentMode='D') OR @PaymentMode ='Q' OR @PaymentMode='R' OR @PaymentMode ='W' OR @PaymentMode ='I'  
            BeGin  
                  set @SqlString ='INSERT INTO #TempOff (PaymentNameEX ,PaymentNamePQ ,DrawnOn ,BankName ,PerqAmt_DrownOndate ,PerqAmt_BankName,ExerciseNo )  
                                          SELECT DISTINCT   
             CASE WHEN ((UPPER('''+@CompanyID+'''))=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.Cheque_DDNo   
            ELSE ShTransactionDetails.PaymentNameEX END AS PaymentNameEX,   
             CASE WHEN ((UPPER('''+@CompanyID+'''))=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.Cheque_DDNo_FBT  
              ELSE ShTransactionDetails.PaymentNamePQ END AS PaymentNamePQ,  
             ShTransactionDetails.DrawnOn, ShTransactionDetails.BankName,   
             CASE WHEN ((UPPER('''+@CompanyID+'''))=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.DrawnOn_FBT   
              ELSE ShTransactionDetails.PerqAmt_DrownOndate END AS PerqAmt_DrownOndate,  
             CASE WHEN ((UPPER('''+@CompanyID+'''))=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.BankName_FBT  
              ELSE ShTransactionDetails.PerqAmt_BankName END AS PerqAmt_BankName,  
             ShTransactionDetails.ExerciseNo '+  
                                          ' FROM Exercised INNER JOIN ' +  
                                          ' ShTransactionDetails ON Exercised.ExerciseNo = ShTransactionDetails.ExerciseNo ' +  
                                          ' WHERE  (Exercised.ExerciseNo = '+@ExerciseNo+')'  
                  EXEC(@SqlString)  
                  /*Print @SqlString*/
  
            END  
            Else if @PaymentMode = 'N'   
            BEGIN  
                  set @SqlString = 'INSERT INTO #TEMPOnL (BankReferenceNo ,Transaction_Date ,ExerciseNo)   
                                                SELECT distinct Transaction_Details.BankReferenceNo, Transaction_Details.Transaction_Date,Transaction_Details.Sh_ExerciseNo as ExerciseNo  ' +  
                                           ' FROM         Exercised INNER JOIN  Transaction_Details ON Exercised.ExerciseNo = Transaction_Details.Sh_ExerciseNo ' +  
                                           ' WHERE Exercised.ExerciseNo ='+@ExerciseNo+' and Payment_status =''s'''  
                   EXEC(@SqlString)  
   			/*Print @SqlString*/
            END  
      END  
      ElSE  
      BEGIN  
              
            select  @PaymentMode =  PaymentMode from ShExercisedOptions where Exerciseno =@ExerciseNo  
            if (@PaymentMode='D') OR @PaymentMode ='Q' OR @PaymentMode='R' OR @PaymentMode ='W' OR @PaymentMode ='I'  
            BEGIN  
                  set @SqlString ='INSERT INTO #TempOff (PaymentNameEX ,PaymentNamePQ ,DrawnOn ,BankName ,PerqAmt_DrownOndate ,PerqAmt_BankName,ExerciseNo )  
                                          SELECT DISTINCT   
                                            CASE WHEN (UPPER('''+@CompanyID+''')=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.Cheque_DDNo   
                                              ELSE ShTransactionDetails.PaymentNameEX END AS PaymentNameEX,   
           CASE WHEN (UPPER('''+@CompanyID+''')=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.Cheque_DDNo_FBT  
              ELSE ShTransactionDetails.PaymentNamePQ END AS PaymentNamePQ, ShTransactionDetails.DrawnOn, ShTransactionDetails.BankName,    
           CASE WHEN (UPPER('''+@CompanyID+''')=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.DrawnOn_FBT   
              ELSE ShTransactionDetails.PerqAmt_DrownOndate END AS PerqAmt_DrownOndate,   
           CASE WHEN (UPPER('''+@CompanyID+''')=''IDFCRemovedForTimeBeing'') THEN ShTransactionDetails.BankName_FBT  
                                               ELSE ShTransactionDetails.PerqAmt_BankName END AS PerqAmt_BankName,  
                                          ShTransactionDetails.ExerciseNo ' +  
                                          ' FROM         ShExercisedOptions INNER JOIN ' +  
                                          'ShTransactionDetails ON ShExercisedOptions.ExerciseNo = ShTransactionDetails.ExerciseNo ' +  
                                          ' WHERE  (ShTransactionDetails.ExerciseNo = '+@ExerciseNo+')'  
                  EXEC(@SqlString)  
                    
            END  
            Else if @PaymentMode = 'N'   
            BEGIN  
                  set @SqlString = 'INSERT INTO #TEMPOnL (BankReferenceNo ,Transaction_Date ,ExerciseNo)  
                                            SELECT distinct Transaction_Details.BankReferenceNo, Transaction_Details.Transaction_Date,Transaction_Details.Sh_ExerciseNo as ExerciseNo ' +  
                                           ' FROM ShExercisedOptions INNER JOIN ' +  
                                           'Transaction_Details ON ShExercisedOptions.ExerciseNo = Transaction_Details.Sh_ExerciseNo '+  
                                           ' WHERE ShExercisedOptions.ExerciseNo ='+@ExerciseNo+' and Payment_status =''s'''  
                  EXEC(@SqlString)                    
                  /*Print @SqlString*/
            END  
              
              
      END  
                  --SET @SqlString ='Select Distinct  #TempEX.ExercisedQuantity  , #TempEX.ExercisedDate ,#TempEX.ExercisedPrice ,#TempEX.ExerciseNo ,#TempEX.PerqstValue ,#TempEX.PerqstPayable ,#TempEX.FMVPrice ,#TempEX.PaymentMode ,#TempEX.SchemeId ,#TempEX.GrantRegistrationId ,#TempEX.GrantDate,#TempEx.ExercisedId ,  
                  --                        #TempOff.PaymentNameEX ,#TempOff.PaymentNamePQ ,#TempOff.DrawnOn ,#TempOff.BankName ,#TempOff.PerqAmt_DrownOndate ,#TempOff.PerqAmt_BankName ,#TempOff.ExerciseNo,  
                  --                        #TEMPOnL.BankReferenceNo ,#TEMPOnL.Transaction_Date, #TEMPOnL.ExerciseNo from #TempEX LEFT OUTER JOIN  #TempOff ON #TempEX.ExerciseNo = #TempOff.ExerciseNo LEFT OUTER JOIN #TEMPOnL ON #TempEX.ExerciseNo =  #TEMPOnL.ExerciseNo'  
                    
                  SET @SqlString  = 'Select Distinct #TempEX.INSTRUMENT_NAME,#TempEX.CurrencyAlias,SUM(#TempEX.ExercisedQuantity ) as ExercisedQuantity , #TempEX.ExercisedDate ,#TempEX.ExercisedPrice ,#TempEX.ExerciseNo , #TempEX.ExercisedId AS ExerciseID , ' +  
               'SUM(#TempEX.PerqstValue) as PerqstValue ,SUM(#TempEX.PerqstPayable )as PerqstPayable ,SUM(#TempEX.FMVPrice) as FMVPrice ,#TempEX.PaymentMode ,#TempEX.SchemeId ,#TempEX.GrantRegistrationId ,#TempEX.GrantDate, ' +  
                                    '#TempOff.PaymentNameEX ,#TempOff.PaymentNamePQ ,#TempOff.DrawnOn ,#TempOff.BankName ,#TempOff.PerqAmt_DrownOndate ,#TempOff.PerqAmt_BankName ,#TempOff.ExerciseNo, ' +  
                                    '#TEMPOnL.BankReferenceNo ,#TEMPOnL.Transaction_Date, #TEMPOnL.ExerciseNo from #TempEX LEFT OUTER JOIN  #TempOff ON #TempEX.ExerciseNo = #TempOff.ExerciseNo LEFT OUTER JOIN #TEMPOnL ON #TempEX.ExerciseNo =  #TEMPOnL.ExerciseNo ' +  
         'GROUP BY #TempEX.INSTRUMENT_NAME,#TempEX.CurrencyAlias,#TempEX.ExercisedDate,#TempEX.ExercisedPrice ,#TempEX.ExerciseNo ,#TempEX.ExercisedId, #TempEX.PaymentMode ,#TempEX.SchemeId ,#TempEX.GrantRegistrationId ,#TempEX.GrantDate, ' +  
                                    '#TempOff.PaymentNameEX ,#TempOff.PaymentNamePQ ,#TempOff.DrawnOn ,#TempOff.BankName ,#TempOff.PerqAmt_DrownOndate ,#TempOff.PerqAmt_BankName ,#TempOff.ExerciseNo, ' +  
                                    '#TEMPOnL.BankReferenceNo ,#TEMPOnL.Transaction_Date, #TEMPOnL.ExerciseNo '   
  
                  EXEC (@SqlString)  
                  /*print(@SqlString)*/
END
GO
