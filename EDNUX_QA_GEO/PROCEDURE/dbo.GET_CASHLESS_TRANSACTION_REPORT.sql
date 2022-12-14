/****** Object:  StoredProcedure [dbo].[GET_CASHLESS_TRANSACTION_REPORT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_CASHLESS_TRANSACTION_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[GET_CASHLESS_TRANSACTION_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_CASHLESS_TRANSACTION_REPORT]    
( 
 @EmployeeID			   VARCHAR(50) = NULL, 
 @TrustDBNameCompanyID     VARCHAR(50) = NULL 
)    
AS    
BEGIN
		
-- Declare variable
DECLARE @CompanyID VARCHAR(50)
DECLARE @SelectQuery VARCHAR(MAX)
--DECLARE @ROUNDTAX  INT
--DECLARE @FaceValue VARCHAR(10)
--SELECT @ROUNDTAX = cp.RoundupPlace_TaxAmt,@FaceValue=FaceVaue FROM CompanyParameters cp 

Select @CompanyID= DB_NAME();
SELECT @EmployeeID = EmployeeID FROM EmployeeMaster WHERE LoginId = @EmployeeID AND Deleted = 0 

CREATE TABLE #TblCASHLESS_EXERCISE_DETAILS
(
	SR_NO INT IDENTITY(1,1),
	EXERCISE_NO NVARCHAR(500),
	EXERCISE_ID BIGINT,
	ExerciseDate DATETIME,
	SchemeName NVARCHAR (500),
	OPTION_EXERCISE NUMERIC(18,0),
	CURRENCY NVARCHAR(50),
	EXERCISE_PRICE NUMERIC(18,9),
	FMV_PRICE NUMERIC(18,9),
	EXERCISE_AMT NUMERIC(18,9),
	TAX_AMOUNT NUMERIC(18,9),
	TOTAL_PAYBL_AMT NUMERIC(18,9),
	CASHLESS_MODE NVARCHAR(50),
	TOTAL_CASHLESS_CHARGE NUMERIC(18,9),
	TOTAL_DUE NUMERIC(18,9),
	SELLING_PRICE NUMERIC(18,9),
	SHARE_SOLD NUMERIC(18,0),
	TOTAL_SELL_PROCEED NUMERIC(18,9),
	NET_AMT_TR_BANK NUMERIC(18,9),
	BAL_SHARE_TR_DB_ACC NUMERIC(18,0),
	trancheId BIGINT,
	BrokerId BIGINT,
	ExerciseMethod Char(2),
	MIT_ID INT
)


CREATE TABLE #TblEXERCISE_DETAILS
(
	EXERCISE_NO NVARCHAR(250),
	EXERCISE_ID Nvarchar(250),
	OPTION_EXERCISE NUMERIC(18,6),
	CURRENCY NVARCHAR(50),
	EXERCISE_PRICE NUMERIC(18,6),
	FMV_PRICE NUMERIC(18,6),
	EXERCISE_AMT NUMERIC(18,6),
	TAX_AMOUNT NUMERIC(18,6),
	TOTAL_PAYBL_AMT NUMERIC(18,6),
	CASHLESS_MODE NVARCHAR(50)
)

CREATE TABLE #ExerciesDetails(
	ExerciseId BIGINT,	
	ExerciseDate DATETIME,
	ExerciseNo NVARCHAR(500),
	SchemeName NVARCHAR (500),	
	DateOfGrant DATETIME,
	GrantRegistrationId NVARCHAR (500),	
	OptionsExercised NUMERIC(18,0),
	ExercisedAmount NUMERIC(18,9),	
	TaxAmount NUMERIC(18,9),	
	TotalAmountPayable NUMERIC(18,9),	
	TrustType NVARCHAR(250),
	ExercisePrice NUMERIC(18,9),
	Perq_Tax_rate NUMERIC(18,9),
	FMVPrice NUMERIC(18,9),
	PerquisiteValue NUMERIC(18,9),
	MIT_ID BIGINT,
	Currency NVARCHAR(50),
	PaymentMode NVARCHAR(50)
)

SET @SelectQuery =
 'SELECT DISTINCT  Exercised.ExercisedId as ExerciseId ,CONVERT(varchar(10), Exercised.ExercisedDate, 101) as ExerciseDate, Exercised.ExerciseNo, Scheme.SchemeTitle as SchemeName, 
		GrantRegistration.GrantDate as DateOfGrant , GrantRegistration.GrantRegistrationId, Exercised.ExercisedQuantity as OptionsExercised,   
        Exercised.ExercisedPrice *Exercised.ExercisedQuantity as ExercisedAmount ,  
        ISNULL(Exercised.PerqstPayable,0) as TaxAmount, ''0'' as TotalAmountPayable, scheme.TrustType,   Exercised.ExercisedPrice, Null as Perq_Tax_rate,  
        ISNULL(Exercised.FMVPrice,0) as FMVPrice,ISNULL( Exercised.PerqstValue ,0) as PerquisiteValue,
		Exercised.PaymentMode,Exercised.MIT_ID,CM.CurrencyAlias
        FROM GrantLeg INNER JOIN  ' + @CompanyID + '..Exercised ON GrantLeg.ID = Exercised.GrantLegSerialNumber  
					  INNER JOIN  GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId  
					  INNER JOIN  Scheme ON GrantLeg.SchemeId = Scheme.SchemeId    
					  INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID=Exercised.MIT_ID
					  INNER JOIN CurrencyMaster CM ON CIM.CurrencyID=CM.CurrencyID
					  INNER JOIN '+@TrustDBNameCompanyID+'..TrancheConsolidation TC ON TC.Exercisenumber = Exercised.ExerciseNo
					  INNER JOIN '+@TrustDBNameCompanyID+'..Tranche T ON T.TrancheId = TC.TrancheId
        WHERE  Exercised.PaymentMode in (''P'',''A'')  AND T.CompanyId = '''+@CompanyID+'''
			   AND GrantLeg.GrantOptionId in(SELECT GrantOptionId FROM GrantOptions WHERE EmployeeId='''+@EmployeeID+''')   
		ORDER BY ExerciseNo DESC'


/*Get all exercise data*/
INSERT INTO #ExerciesDetails(
	ExerciseId ,	
	ExerciseDate ,
	ExerciseNo ,
	SchemeName ,	
	DateOfGrant,
	GrantRegistrationId ,	
	OptionsExercised ,
	ExercisedAmount ,	
	TaxAmount ,	
	TotalAmountPayable ,	
	TrustType ,
	ExercisePrice ,
	Perq_Tax_rate ,
	FMVPrice ,
	PerquisiteValue ,PaymentMode,MIT_ID,Currency

)
   EXEC(@SelectQuery)     

	
	/* Get Exercise Details*/
	INSERT INTO #TblCASHLESS_EXERCISE_DETAILS (EXERCISE_NO,EXERCISE_ID,OPTION_EXERCISE,CURRENCY,EXERCISE_PRICE,FMV_PRICE,EXERCISE_AMT,TAX_AMOUNT,TOTAL_PAYBL_AMT,CASHLESS_MODE,ExerciseDate, SchemeName, MIT_ID )
	SELECT 
		ED.ExerciseNo ,
		ED.ExerciseId ,	
		ED.OptionsExercised ,
		ED.Currency AS Currency,
		ED.ExercisePrice,
		ED.FMVPrice ,
		ED.ExercisedAmount ,
		ED.TaxAmount AS TaxAmount ,
		ED.ExercisedAmount + ED.TaxAmount AS TotalPayblAmount,		
		CASE WHEN ED.Paymentmode = 'P' THEN 'Sell Partial' WHEN ED.Paymentmode = 'A' THEN 'Sell All' ELSE ''END AS CashlessMode,
		ED.ExerciseDate ,
		ED.SchemeName, 
		ED.MIT_ID	
	FROM 
		 #ExerciesDetails ED	
	GROUP BY
		ED.ExerciseNo ,
		ED.ExerciseId ,	
		ED.OptionsExercised ,
		ED.Currency,
		ED.ExercisePrice,
		ED.FMVPrice ,
		ED.ExercisedAmount ,
		ED.TaxAmount ,
		ED.Paymentmode,
		ED.ExerciseDate ,
		ED.SchemeName,
		ED.MIT_ID 
	

	SELECT EXERCISE_NO AS ExerciseNo,EXERCISE_ID AS ExerciseId, OPTION_EXERCISE AS OptionsExercised, CURRENCY AS Currency, EXERCISE_PRICE AS ExercisePrice, FMV_PRICE AS FMVPrice,
	EXERCISE_AMT AS ExerciseAmount, TAX_AMOUNT AS TaxAmount, TOTAL_PAYBL_AMT AS TotalAmountPayable, CASHLESS_MODE AS CashlessMode, 
	TOTAL_CASHLESS_CHARGE AS TotalCashlessCharges, TOTAL_DUE AS TotalDues, SELLING_PRICE AS SellingPrice, SHARE_SOLD AS SharesSold, TOTAL_SELL_PROCEED AS TotalSaleProceeds,
	NET_AMT_TR_BANK AS NetAmountTransfToBank, BAL_SHARE_TR_DB_ACC AS BalSharesTransfToDBAcc, ExerciseDate, SchemeName, MIT_ID
	FROM #TblCASHLESS_EXERCISE_DETAILS

	exec GET_PAGEWISE_FIELD_DETAILS @PageName='MyCashlessTransactionReport'

	DROP TABLE #TblCASHLESS_EXERCISE_DETAILS
	DROP TABLE #TblEXERCISE_DETAILS
	DROP TABLE #ExerciesDetails
 
END
GO
