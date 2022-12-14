/****** Object:  StoredProcedure [dbo].[GetUnderwaterOptionsDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetUnderwaterOptionsDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetUnderwaterOptionsDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************************   
Author:  <Chetan Tembhre>      
Create date: <28 Mar 2013>      
Description -1. Underwater Options Report Details
EXEC GetUnderwaterOptionsDetails 
***************************************************************************************************/
CREATE PROCEDURE [dbo].[GetUnderwaterOptionsDetails]
AS
BEGIN

	SET NOCOUNT ON; 
	DECLARE @CompanyName VARCHAR(50),@ClosingMarketPrice DECIMAL(18,2)
	DECLARE @ClosingPrice DECIMAL(18,2)
	SET @ClosingPrice=(SELECT SharePrices.ClosePrice FROM SharePrices WHERE  PriceDate = (SELECT MAX(PriceDate) FROM SharePrices))
	SET @CompanyName=(SELECT CompanyName FROM CompanyMaster)
	CREATE TABLE #TempUnderWaterOptionsDetails 
	(
	   Ind INT IDENTITY(1,1),
	   SchemeID VARCHAR(50),
	   SchemeTitle VARCHAR(50),
	   GrantDate DATETIME,
	   OptionsGranted DECIMAL(18),
	   VestedOptions DECIMAL(18),
	   UnVestedOptions DECIMAL(18),
	   TotalOptionsVestedandUnVested DECIMAL(18),
	   ExercisePrice DECIMAL(18,2),
	   OptionRatioDivisor INT,
	   OptionRatioMultiplier INT,
	   InstrumentName VARCHAR(50),
	   CurrencyName VARCHAR(50)
	 )
	DECLARE @MinID INT,@MaxID INT,@SchemeId VARCHAR(50),@OptionRatioDivisor INT, @OptionRatioMultiplier INT,
			@GrantDate DATETIME,@ExercisePrice DECIMAL(18,2),@VestedOptions DECIMAL(18),@UnVestedOptions DECIMAL(18)
	-- SELECT Scheme which is based on condition ExercisePrice>ClosingPrice
	INSERT INTO #TempUnderWaterOptionsDetails (InstrumentName,CurrencyName,SchemeID,SchemeTitle,OptionRatioDivisor,OptionRatioMultiplier,OptionsGranted,GrantDate,ExercisePrice)
				SELECT  MIT.INSTRUMENT_NAME,CM.CurrencyName,SCH.SchemeId,SCH.SchemeTitle,SCH.OptionRatioDivisor,SCH.OptionRatioMultiplier,
				(SUM(GL.GrantedOptions)*OptionRatioDivisor/OptionRatioMultiplier),GR.GrantDate,GR.ExercisePrice
				FROM  GrantRegistration GR
						 INNER JOIN Scheme SCH ON GR.SchemeId = SCH.SchemeId
						 INNER JOIN GrantOptions GOS ON GOS.GrantRegistrationId = GR.GrantRegistrationId
						 INNER JOIN GrantLeg GL ON GOS.GrantOptionId = GL.GrantOptionId
						 INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SCH.MIT_ID = MIT.MIT_ID
						 INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SCH.MIT_ID=CIM.MIT_ID
						 INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID
					WHERE  GR.ExercisePrice> @ClosingPrice
				GROUP  BY MIT.INSTRUMENT_NAME,CM.CurrencyName, SCH.SchemeId, SCH.SchemeTitle,SCH.OptionRatioDivisor,SCH.OptionRatioMultiplier,GR.GrantDate,GR.ExercisePrice
				ORDER  BY GR.GrantDate,SCH.SchemeId,GR.ExercisePrice

	SELECT @MINID=MIN(Ind),@MAXID=MAX(Ind) FROM #TempUnderWaterOptionsDetails
	WHILE (@MINID<=@MAXID)
		BEGIN
			SELECT @SchemeId=SchemeID,@OptionRatioDivisor=OptionRatioDivisor,@OptionRatioMultiplier=OptionRatioMultiplier,@GrantDate=GrantDate,@ExercisePrice=ExercisePrice FROM #TempUnderWaterOptionsDetails WHERE Ind=@MinID
			-- Vested Options
			SET @VestedOptions = (
									SELECT ISNULL(SUM(GL.ExercisableQuantity)*@OptionRatioDivisor/@OptionRatioMultiplier,0)
									FROM  GrantRegistration GR
										  INNER JOIN Scheme SCH ON GR.SchemeId = SCH.SchemeId
										  INNER JOIN GrantOptions GOS ON GOS.GrantRegistrationId = GR.GrantRegistrationId
										  INNER JOIN GrantLeg GL ON GOS.GrantOptionId = GL.GrantOptionId
										  INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SCH.MIT_ID = MIT.MIT_ID
										  INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SCH.MIT_ID=CIM.MIT_ID
										  INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID
									WHERE GR.ExercisePrice =@ExercisePrice AND SCH.SchemeId=@SchemeId AND (GETDATE() BETWEEN GL.FinalVestingDate AND GL.FinalExpirayDate)
										  AND GR.GrantDate=@GrantDate	
								  )
			-- UnVested Options
			SET @UnVestedOptions= ( 
									SELECT
								    ISNULL(SUM(GL.ExercisableQuantity)*@OptionRatioDivisor/@OptionRatioMultiplier,0)
								    FROM  GrantRegistration GR
										  INNER JOIN Scheme SCH ON GR.SchemeId = SCH.SchemeId
										  INNER JOIN GrantOptions GOS ON GOS.GrantRegistrationId = GR.GrantRegistrationId
										  INNER JOIN GrantLeg GL ON GOS.GrantOptionId = GL.GrantOptionId
										INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SCH.MIT_ID = MIT.MIT_ID
										INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SCH.MIT_ID=CIM.MIT_ID
										INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID
									WHERE GR.ExercisePrice=@ExercisePrice AND SCH.SchemeId=@SchemeId AND (GETDATE() <= GL.FinalVestingDate)
										   AND GR.GrantDate=@GrantDate
								 
								  )
			UPDATE #TempUnderWaterOptionsDetails SET VestedOptions=@VestedOptions,UnVestedOptions=@UnVestedOptions,TotalOptionsVestedandUnVested=(@VestedOptions+@UnVestedOptions)
												  WHERE Ind=@MinID	
			SET @MinID=@MinID+1
		END

	SELECT InstrumentName,CurrencyName,SchemeID,SchemeTitle,GrantDate, ExercisePrice,VestedOptions,UnVestedOptions,TotalOptionsVestedandUnVested,OptionsGranted
	,ISNULL(@ClosingPrice,0) AS ClosingMarketPrice,@CompanyName AS Company
	FROM #TempUnderWaterOptionsDetails 
	IF EXISTS (SELECT *  FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#TempSBIDisclosureDetails'))      
		BEGIN      
			DROP TABLE #TempUnderWaterOptionsDetails
		END 
 END
GO
