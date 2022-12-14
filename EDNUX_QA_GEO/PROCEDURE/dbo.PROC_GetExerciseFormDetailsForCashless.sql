/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseFormDetailsForCashless]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetExerciseFormDetailsForCashless]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetExerciseFormDetailsForCashless]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetExerciseFormDetailsForCashless]
(
	@TRUST_DB VARCHAR(20),
	@MIT_ID INT 
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	
	CREATE TABLE #TrustDetails
	(
		TrustID INT
	)
	
	DECLARE 
		@TrustID INT,
		@CurrentDB AS VARCHAR(100)
		
	
	SET @CurrentDB = (SELECT DB_NAME())
	
	
	
	INSERT INTO #TrustDetails
	EXEC ('SELECT TrustID FROM ' + @TRUST_DB + '..TRUST WHERE ClientCompany = ''' + @CurrentDB + '''')
	
	SET @TrustID = (SELECT TrustID FROM #TrustDetails)
	
	CREATE TABLE #CashlessEnableDetailsforTrust
	(	
		TrustCashlessID INT
		, SellTypeIDAll INT
		, SellTypeIDCoverExerciseDetails INT
		, ChargesPaidByID INT
		, CalulationBasedOnID INT
		, PricePerOptionAmt FLOAT
		, OnSellingPricePercent FLOAT
		, ExerciseFormID INT
		, RequiredTPlusDay FLOAT
		, NotRequiredManuallyandSchedulerID VARCHAR (50)
		, NotReqManuallyTPlusDay FLOAT
		, ApplicableNationalityToID INT
		, IndianNationals INT
		, NonResidentNationals INT
		, ForgienNationals INT
		, ApplicableForAll INT
		, FromDate DATETIME
		, ToDate DATETIME
		, XPercentValidation FLOAT
		, Allowpertax VARCHAR (10)
		, CCAFillFeeForINR DECIMAL (18, 2)
		, CCAFillFeeForNRI DECIMAL (18, 2)
		, CCAFillFeeForFN DECIMAL (18, 2)
		, ServiceTaxOnCCAFillFeeForINR DECIMAL (18, 2)
		, ServiceTaxOnCCAFillFeeForNRI DECIMAL (18, 2)
		, ServiceTaxOnCCAFillFeeForFN DECIMAL (18, 2)
		, BankChargesForINR DECIMAL (18, 2)
		, BankChargesForNRI DECIMAL (18, 2)
		, BankChargesForFN DECIMAL (18, 2)
		, ServiceTaxonBankChargesForINR DECIMAL (18, 2)
		, ServiceTaxonBankChargesForNRI DECIMAL (18, 2)
		, ServiceTaxonBankChargesForFN DECIMAL (18, 2)
		, DisplayEmpChargesCashlessBroker VARCHAR (50)
		, IndianNationalsforSP INT
		, NonResidentNationalsforSP INT
		, ForeignNationalsforSP INT
		, CessCAFillingINR DECIMAL (18, 2)
		, CessCAFillingNRI DECIMAL (18, 2)
		, CessCAFillingFN DECIMAL (18, 2)
		, CessBankChargesFillingINR DECIMAL (18, 2)
		, CessBankChargesFillingNRI DECIMAL (18, 2)
		, CessBankChargesFillingFN DECIMAL (18, 2)
	)

	INSERT INTO #CashlessEnableDetailsforTrust
	EXEC (@TRUST_DB + '..GetCashlessEnableDetailsforTrust ' + @TrustID)
	
	SELECT 'Cashless' AS PayModeName, CASE WHEN ExerciseFormID  = 1 THEN 'Y' ELSE 'N' END AS IsEnable FROM #CashlessEnableDetailsforTrust
	
	DROP TABLE #CashlessEnableDetailsforTrust
	DROP TABLE #TrustDetails
	
	EXEC PROC_GetExerciseFormDetails @MIT_ID
	
	SET NOCOUNT OFF;
END
GO
