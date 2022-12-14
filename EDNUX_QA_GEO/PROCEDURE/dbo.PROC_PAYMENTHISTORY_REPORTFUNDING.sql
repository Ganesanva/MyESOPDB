/****** Object:  StoredProcedure [dbo].[PROC_PAYMENTHISTORY_REPORTFUNDING]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_PAYMENTHISTORY_REPORTFUNDING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_PAYMENTHISTORY_REPORTFUNDING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_PAYMENTHISTORY_REPORTFUNDING]
      @CompanyID              VARCHAR(100),     -- Logged In Company ID sc.companyid
      @UserID                       VARCHAR(20),      -- entered  user id
      @ExerciseNo             varchar(50)      -- entered ExercisedNo
      
      
      AS
BEGIN
SET NOCOUNT ON

      ---- Declare local variables
      DECLARE @SqlString VARCHAR(2000),
                  @Count     Int,
                  @PaymentMode varchar(10)
            
            
            
    CREATE TABLE #TempEX (ExercisedQuantity  numeric(18,0), ExercisedDate DATETIME,ExercisedPrice numeric(18,2),ExerciseID VARCHAR(100),PerqstValue VARCHAR(100),PerqstPayable VARCHAR(100),FMVPrice VARCHAR(100),PaymentMode VARCHAR(100),SchemeId VARCHAR(100),GrantRegistrationId VARCHAR(100),GrantDate DATETIME,ExerciseNo VARCHAR(100))
      
      --CREATE TABLE #TempOff (PaymentNameEX VARCHAR(100),PaymentNamePQ VARCHAR(100),DrawnOn DATETIME,BankName VARCHAR(100),PerqAmt_DrownOndate DATETIME,PerqAmt_BankName VARCHAR(100),ExerciseNo VARCHAR(100))
      
      --CREATE TABLE #TEMPOnL (BankReferenceNo VARCHAR(100),Transaction_Date DATETIME,ExerciseNo VARCHAR(100))
      
      Select @Count =COUNT(Exerciseno) from Exercised where Exerciseno = @ExerciseNo  

      if @Count > 0
      BEGIN
            Set @SqlString = 'SELECT     Exercised.ExercisedQuantity, Exercised.ExercisedDate, Exercised.ExercisedPrice, Exercised.ExercisedId , Exercised.PerqstValue, Exercised.PerqstPayable , '+
                                     'Exercised.FMVPrice, CASE WHEN Exercised.PaymentMode = ''D'' then ''DEMAT'' WHEN Exercised.PaymentMode = ''Q'' THEN ''CHEQUE'' WHEN Exercised.PaymentMode = ''R'' THEN ''RTGS'' WHEN Exercised.PaymentMode = ''W'' THEN ''WireTransfer''  WHEN Exercised.PaymentMode = ''F'' THEN ''FUNDING''  END, Scheme.SchemeId, GrantRegistration.GrantRegistrationId, GrantRegistration.GrantDate, Exercised.ExerciseNo'+
                                     ' FROM         Exercised INNER JOIN GrantLeg ON Exercised.GrantLegSerialNumber = GrantLeg.ID INNER JOIN GrantOptions ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId INNER JOIN '+
                                     'GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId AND GrantOptions.SchemeId = Scheme.SchemeId AND GrantRegistration.SchemeId = Scheme.SchemeId ' +
                                     'WHERE     (Exercised.ExerciseNo = ' +@ExerciseNo+')  '
                                     
            INSERT INTO #TempEX(ExercisedQuantity  , ExercisedDate ,ExercisedPrice ,ExerciseID ,PerqstValue ,PerqstPayable ,FMVPrice ,PaymentMode ,SchemeId ,GrantRegistrationId ,GrantDate ,ExerciseNo ) 
            EXEC(@SqlString)
      END
      ELSE
      BEGIN
            Set @SqlString ='SELECT     ShExercisedOptions.ExercisedQuantity, ShExercisedOptions.ExerciseDate, ShExercisedOptions.ExercisePrice, ShExercisedOptions.ExerciseId ,  ' +
                                    'ShExercisedOptions.PerqstValue, ShExercisedOptions.PerqstPayable, ShExercisedOptions.FMVPrice,
                                     CASE WHEN ShExercisedOptions.PaymentMode = ''D'' then ''DEMAT'' WHEN ShExercisedOptions.PaymentMode = ''Q'' THEN ''CHEQUE'' WHEN ShExercisedOptions.PaymentMode = ''R'' THEN ''RTGS'' WHEN ShExercisedOptions.PaymentMode = ''W'' THEN ''WireTransfer''  WHEN ShExercisedOptions.PaymentMode = ''F'' THEN ''FUNDING''  END,
                                     Scheme.SchemeId,  ' +
                                    'GrantRegistration.GrantRegistrationId, GrantRegistration.GrantDate , ShExercisedOptions.ExerciseNo ' +
                                    'FROM         GrantOptions INNER JOIN ' +
                                    'GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId INNER JOIN ' +
                                    'Scheme ON GrantOptions.SchemeId = Scheme.SchemeId AND GrantRegistration.SchemeId = Scheme.SchemeId INNER JOIN ' +
                                    'GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId AND Scheme.SchemeId = GrantLeg.SchemeId INNER JOIN ' +
                                    ' ShExercisedOptions ON GrantLeg.ID = ShExercisedOptions.GrantLegSerialNumber ' +
                                    'WHERE     (ShExercisedOptions.ExerciseNo = '+@ExerciseNo+')'
            INSERT INTO #TempEX(ExercisedQuantity  , ExercisedDate ,ExercisedPrice ,ExerciseID ,PerqstValue ,PerqstPayable ,FMVPrice ,PaymentMode ,SchemeId ,GrantRegistrationId ,GrantDate ,ExerciseNo ) 
            EXEC(@SqlString)
      END
      
                  SET @SqlString ='Select  #TempEX.ExercisedQuantity  , #TempEX.ExercisedDate ,#TempEX.ExercisedPrice ,#TempEX.ExerciseID ,#TempEX.PerqstValue ,#TempEX.PerqstPayable ,#TempEX.FMVPrice ,#TempEX.PaymentMode ,#TempEX.SchemeId ,#TempEX.GrantRegistrationId ,#TempEX.GrantDate ,#TempEX.ExerciseNo
                                          from #TempEX '
                  EXEC (@SqlString)
END

GO
