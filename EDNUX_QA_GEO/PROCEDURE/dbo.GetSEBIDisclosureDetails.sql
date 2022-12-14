/****** Object:  StoredProcedure [dbo].[GetSEBIDisclosureDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetSEBIDisclosureDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetSEBIDisclosureDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***************************************************************************************************   
Author:  <Chetan Tembhre>      
Create date: <20 Mar 2013>      
Description -1. SEBI Disclosure Report Query
2. Any other employee who receives a grant in any one year of option amounting to 5% or more of option granted during that year 
Modified By: <Chetan Tembhre>
Modified Date: <28-Mar-2013>
Description: As issue no 0004149: Issue raised by Nehat
Modified By: <Santosh P>
Modified Date: <28-May-2013>
Description: As issue no 0004319,0004320
Modified By: <Chetan T & Santosh P>
Modified Date: <30-May-2013>
Description1: As issue no 0004325
Description2: Options Vested = Vested Quantity as on "To Date" + Vested Cancelled Quantity during the given period
                              +Vested Lapsed Quantity during the given period + Exercised Quantity during the given period (Allotted + Pending for Approval)
							  -	Vested Quantity as on From Date
This procedure should be execute after execution of SP_REPORT_DATA procedure
EXEC GetSEBIDisclosureDetails '01/01/1990','03/21/2013'
***************************************************************************************************/
CREATE PROCEDURE [dbo].[GetSEBIDisclosureDetails]
	@FromDate DATETIME,
	@ToDate DATETIME
AS
BEGIN
	SET NOCOUNT ON; 
	CREATE TABLE #TEMP_DATA 
    (			
		OptionsGranted numeric(18,0), OptionsVested  numeric(18,0), OptionsExercised numeric(18,0),OptionsCancelled numeric(18,0), 
		OptionsLapsed numeric(18,0), OptionsUnVested numeric(18,0), [Pending For Approval] numeric(18,0), GrantOptionId NVARCHAR(100),
		GrantLegId numeric(18,0),SchemeId NVARCHAR(150),GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150),employeename NVARCHAR(250), SBU NVARCHAR(100) NULL,AccountNo NVARCHAR(100) NULL,PANNumber NVARCHAR(100) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100),GrantDate DATETIME,[Vesting Type] NVARCHAR(100), ExercisePrice numeric(10,2),VestingDate DATETIME,
		ExpirayDate DATETIME, Parent_Note NVARCHAR(10), UnvestedCancelled numeric(18,0), VestedCancelled numeric(18,0),
		INSTRUMENT_NAME NVARCHAR(200), CurrencyName NVARCHAR(50), COST_CENTER NVARCHAR(200), Department NVARCHAR(200), Location NVARCHAR(200), 
		EmployeeDesignation NVARCHAR(200), Grade NVARCHAR(200), ResidentialStatus NVARCHAR(10), CountryName NVARCHAR(100), CurrencyAlias NVARCHAR(200), 
		MIT_ID NVARCHAR(10), CancellationReason NVARCHAR(200)
    )

    CREATE TABLE #TEMP_DATA1 
    (			
		OptionsGranted numeric(18,0), OptionsVested  numeric(18,0), OptionsExercised numeric(18,0),OptionsCancelled numeric(18,0), 
		OptionsLapsed numeric(18,0), OptionsUnVested numeric(18,0), [Pending For Approval] numeric(18,0), GrantOptionId NVARCHAR(100),
		GrantLegId numeric(18,0),SchemeId NVARCHAR(150),GrantRegistrationId NVARCHAR(150),  
		Employeeid NVARCHAR(150),employeename NVARCHAR(250), SBU NVARCHAR(100) NULL,AccountNo NVARCHAR(100) NULL,PANNumber NVARCHAR(100) NULL,
		Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100),GrantDate DATETIME,[Vesting Type] NVARCHAR(100), ExercisePrice numeric(10,2),VestingDate DATETIME,
		ExpirayDate DATETIME, Parent_Note NVARCHAR(10), UnvestedCancelled numeric(18,0), VestedCancelled numeric(18,0),
		INSTRUMENT_NAME NVARCHAR(200), CurrencyName NVARCHAR(50), COST_CENTER NVARCHAR(200), Department NVARCHAR(200), Location NVARCHAR(200), 
		EmployeeDesignation NVARCHAR(200), Grade NVARCHAR(200), ResidentialStatus NVARCHAR(10), CountryName NVARCHAR(100), CurrencyAlias NVARCHAR(200), 
		MIT_ID NVARCHAR(10), CancellationReason NVARCHAR(200)
    )
            
      --Insert data into Temp Table
      DECLARE @FROM_DATE AS VARCHAR(10)
      SET @FROM_DATE = CONVERT(VARCHAR(10),(SELECT CONVERT(DATE,@FromDate-1)))
      DECLARE @TO_DATE AS VARCHAR(10)
      SET @TO_DATE = CONVERT(VARCHAR(10),(SELECT CONVERT(DATE,@ToDate)))
      INSERT INTO #TEMP_DATA EXEC SP_REPORT_DATA '1900-01-01', @FROM_DATE
	  INSERT INTO #TEMP_DATA1 EXEC SP_REPORT_DATA '1900-01-01', @TO_DATE
	  
	CREATE TABLE #TempSBIDisclosureDetails 
	(
	   Ind INT IDENTITY(1,1),
	   SchemeTitle VARCHAR(50),
	   SchemeID VARCHAR(50),
	   OptionsGranted DECIMAL(18),
	   OptionsVested DECIMAL(18),
	   OptionsExercised DECIMAL(18), 
	   SharesExercised DECIMAL(18), 
	   OptionsLapsed DECIMAL(18),  
	   MoneyRelized DECIMAL(18,2),
	   OptionsCancelled DECIMAL(18),
	   OptionsInForce DECIMAL(18),
	   OptionsExercisedInForce DECIMAL(18), 
	   OptionsCancelledInForce DECIMAL(18),
	   OptionsLapsedInForce DECIMAL(18),
	   OptionsGrantedInForce DECIMAL(18),
	   OptionsVestedAndExercisable DECIMAL(18),
	   TotalOptionsLapsed DECIMAL(18),
	   TotalOptionsVested DECIMAL(18),
	   OptionRatioDivisor INT,
	   OptionRatioMultiplier INT,	   
	   WAEPForEPEqualMP DECIMAL(18), --ExercisedAmount/TotalShares as WAEPForEPLessMP
	   WAEPForEPLessMP DECIMAL(18),  -- ExercisedAmount/TotalShares as WAEPForEPLessMP
	   WAEPForEPMoreMP DECIMAL(18),  -- ExercisedAmount/TotalShares as WAEPForEPLessMP
	   EmployeeId VARCHAR(50),
	   EmpPerYrsOpsGrantedQty DECIMAL(18)
	   --Commented, used for checking value
	   --,OptionVestedasOnToDate DECIMAL(18),
	   --OptionsVestedasFromDate DECIMAL(18),
	   --PendingForApproval DECIMAL(18),
	   --VestedLapsedOptions DECIMAL(18),              
	   --VestedCancelledOptions DECIMAL(18),
	   --OptionsPendingasFromDate DECIMAL(18)
	 )
	INSERT INTO #TempSBIDisclosureDetails(SchemeID,SchemeTitle,OptionRatioDivisor,OptionRatioMultiplier)SELECT SchemeId,SchemeTitle,OptionRatioDivisor,OptionRatioMultiplier FROM Scheme 
	
	DECLARE @MINID INT,@MAXID INT
	DECLARE @SchemeTitle VARCHAR(50),@SchemeID VARCHAR(50),@OptionsGranted DECIMAL(18),@OptionsVested DECIMAL(18), @OptionsVestedasFromDate DECIMAL(18),@OptionsExercised DECIMAL(18),@SharesExercised DECIMAL(18), 
			@OptionsLapsed DECIMAL(18),@VestedLapsedOptions DECIMAL(18),@MoneyRelized DECIMAL(18,2),@OptionsCancelled DECIMAL(18),@VestedCancelledOptions DECIMAL(18),@OptionsExercisedInForce DECIMAL(18),@OptionsCancelledInForce DECIMAL(18),@OptionVestedAsOnToDate DECIMAL(18),
			@OptionsLapsedInForce DECIMAL(18),@OptionsGrantedInForce DECIMAL(18),@OptionsVestedAndExercisable DECIMAL(18),@OptionsPendingasFromDate DECIMAL(18), @OptionRatioDivisor INT,@OptionRatioMultiplier INT,
			@TotalShares DECIMAL(18),@ExAmtForEqualMp DECIMAL(18),@ExAmtForLessMp DECIMAL(18),@ExAmtForMoreMp DECIMAL(18),@OptionsUnVested DECIMAL(18), @PendingForApproval DECIMAL(18)

	SELECT @MINID=MIN(Ind),@MAXID=MAX(Ind) FROM #TempSBIDisclosureDetails
	
	WHILE (@MINID<=@MAXID)
		BEGIN
			SELECT @SchemeID=SchemeID,@OptionRatioDivisor=OptionRatioDivisor,@OptionRatioMultiplier=OptionRatioMultiplier FROM #TempSBIDisclosureDetails WHERE Ind=@MINID
			-- Options Granted
			SET @OptionsGranted=(SELECT SUM(GL.GrantedOptions) AS OptionsGranted  FROM GrantOptions GOS
									INNER JOIN GrantRegistration GR  ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
									INNER JOIN Scheme SCH  ON SCH.SchemeId=GOS.SchemeId  
									LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
								WHERE CONVERT(DATE,GR.GrantDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND SCH.SchemeId=@SchemeID )

			-- Options Vested 
			SET @OptionsVested =(SELECT SUM((GL.ExercisableQuantity * @OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsVested  FROM GrantOptions GOS 
									INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
									INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
									LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
								WHERE ((CONVERT(DATE,GL.FinalVestingDate) <= CONVERT(DATE,@ToDate)) AND (CONVERT(DATE,GL.FinalExpirayDate) >= CONVERT(DATE,@ToDate))    
										OR (CONVERT(DATE,GL.FinalVestingDate) >= CONVERT(DATE,@ToDate)) OR (CONVERT(DATE,GL.FinalExpirayDate) <= CONVERT(DATE,@ToDate)))  
										AND SCH.SchemeId=@SchemeID)
		   -- Option Vested as on To Date
			SET @OptionVestedAsOnToDate =(SELECT SUM(ISNULL( #TEMP_DATA1.OptionsVested,0)+ISNULL([Pending For Approval],0)) FROM #TEMP_DATA1 WHERE #TEMP_DATA1.SchemeId=@SchemeID)										 
           -- Option Vested as on From Date										
		    SET @OptionsVestedasFromDate =( SELECT SUM( ISNULL(OptionsVested,0)+ISNULL([Pending For Approval],0)) FROM #TEMP_DATA WHERE #TEMP_DATA.SchemeId=@SchemeID)
			-- Option Pending as on From Date
			--SET @OptionsPendingasFromDate =(SELECT SUM((GL.UnapprovedExerciseQuantity * @OptionRatioDivisor)/@OptionRatioMultiplier) AS PendingForApproval FROM GrantRegistration GR
			--										INNER JOIN Scheme SCH ON GR.SchemeId=SCH.SchemeId
			--										INNER JOIN GrantOptions GOS ON GOS.GrantRegistrationId=GR.GrantRegistrationId  
			--										LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId   
			--						WHERE  (CONVERT(DATE,GL.FinalVestingDate)<CONVERT(DATE,@FromDate))AND SCH.SchemeId=@SchemeID)
		    
            -- Options UnVested
            SET @OptionsUnVested =(SELECT  (ISNULL(SUM(GL.GrantedOptions),0) - (ISNULL(SUM(((GL.ExercisableQuantity + GL.UnapprovedExerciseQuantity) * @OptionRatioDivisor) / OptionRatioMultiplier), 0)     
                 + ISNULL(SUM(GL.ExercisedQuantity), 0) + ISNULL(SUM(GL.CancelledQuantity), 0) + ISNULL(SUM(GL.LapsedQuantity), 0)) )  AS OptionsUnVested  FROM GrantOptions GOS 
									INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
									INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
									LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
								WHERE  (CONVERT(DATE,@ToDate) <=CONVERT(DATE, GL.FinalExpirayDate))   AND SCH.SchemeId=@SchemeID)
			-- Options Exercised=Exercised.ExercisedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier
			-- SharesExercised =(Exercised.ExercisedQuantity) as SharesExercised
			-- MoneyRelized=(Exercised.ExercisedQuantity*GrantRegistration.ExercisePrice) -- MoneyRelized should be display as per rounding whichever is set for that
			SELECT	@OptionsExercised=SUM((E.ExercisedQuantity*@OptionRatioDivisor)/@OptionRatioMultiplier) ,  
					@SharesExercised=SUM(E.ExercisedQuantity),@MoneyRelized=SUM(E.ExercisedQuantity* E.ExercisedPrice)FROM GrantOptions GOS 
					INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
					INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId 
					LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
					LEFT OUTER JOIN Exercised E ON GL.Id=E.GrantLegSerialNumber  
			WHERE CONVERT(DATE,E.ExercisedDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate) AND SCH.SchemeId=@SchemeID

			--Options Lapased
			SET @OptionsLapsed=(SELECT SUM(((GL.LapsedQuantity)*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsLapsed  FROM GrantOptions GOS
										INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
										INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
										LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId 
									WHERE (CONVERT(DATE,GL.FinalExpirayDate) BETWEEN  CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate)) AND SCH.SchemeId=@SchemeID)

			-- Vested Lapsed Options
			SET @VestedLapsedOptions = (SELECT SUM(((GL.LapsedQuantity)*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsLapsed  FROM GrantOptions GOS
											INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
											INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
											LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId 
										WHERE (CONVERT(DATE,GL.FinalExpirayDate) BETWEEN  CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate)) 
										       AND(CONVERT(DATE,GL.FinalVestingDate) BETWEEN  CONVERT(DATE, @FromDate) AND CONVERT(DATE, @ToDate)) AND SCH.SchemeId=@SchemeID)
			
			--Options Cancelled,OptionsCancelledInForce
			--@OptionsCancelledInForce=SUM((GL.CancelledQuantity*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsCancelledInForce
			SET @OptionsCancelled=(SELECT SUM((GL.CancelledQuantity*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsCancelled FROM GrantOptions GOS
										INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
										INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
										LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
									WHERE CONVERT(DATE, GL.CancellationDate) BETWEEN CONVERT(DATE, @FromDate) and CONVERT(DATE, @ToDate) AND SCH.SchemeId=@SchemeID) 
			-- Vested Cancelled Options 
			SET @VestedCancelledOptions=(
											SELECT SUM(Temp.OptionsCancelled)  FROM 
											( 
												 SELECT CASE WHEN CONVERT(DATE,GL.CancellationDate) >= CONVERT(DATE,GL.FinalVestingDate) THEN SUM((GL.CancelledQuantity*@OptionRatioDivisor)/@OptionRatioMultiplier) 
															  ELSE 0 END AS OptionsCancelled FROM GrantOptions GOS
													INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
													INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
										 			LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
												WHERE CONVERT(DATE, GL.CancellationDate) BETWEEN CONVERT(DATE, @FromDate) and CONVERT(DATE, @ToDate) AND SCH.SchemeId=@SchemeID
												GROUP BY CONVERT(DATE,GL.CancellationDate),CONVERT(DATE,GL.FinalVestingDate)
										   )Temp
									  )
									
			--PendingForApproval
			SET @PendingForApproval =(SELECT SUM((GL.UnapprovedExerciseQuantity * @OptionRatioDivisor)/@OptionRatioMultiplier) AS PendingForApproval FROM GrantRegistration GR
													INNER JOIN Scheme SCH ON GR.SchemeId=SCH.SchemeId
													INNER JOIN GrantOptions GOS ON GOS.GrantRegistrationId=GR.GrantRegistrationId  
													LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId   
									WHERE (CONVERT(DATE,@ToDate) <=CONVERT(DATE, GL.FinalExpirayDate))  
									 AND SCH.SchemeId=@SchemeID)
            ------------- No Need to below commented code-----------------------------------------------------------------------------------------------------
			--OptionsGrantedInForce
			--SET @OptionsGrantedInForce=(SELECT SUM(GL.GrantedOptions) AS OptionsGrantedInForce FROM GrantOptions GOS
			--								INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
			--								INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
			--								LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
			--							WHERE CONVERT(DATE, GR.GrantDate)<= CONVERT(DATE,@ToDate) AND SCH.SchemeId=@SchemeID )

			--OptionsExercisedInForce
			--SET @OptionsExercisedInForce=(SELECT SUM((GrantLeg.CancelledQuantity*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsExercisedInForce FROM GrantOptions GOS
			--								INNER JOIN GrantRegistration ON GrantRegistration.GrantRegistrationId=GOS.GrantRegistrationId  
			--								INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
			--								LEFT OUTER JOIN GrantLeg ON GOS.GrantOptionId=GrantLeg.GrantOptionId  
			--								WHERE GrantLeg.CancellationDate < GrantLeg.FinalVestingDate AND SCH.SchemeId=@SchemeID AND
			--								GrantLeg.Id IN  (SELECT DISTINCT GrantLeg.Id  FROM GrantOptions 
			--												INNER JOIN GrantRegistration ON GrantRegistration.GrantRegistrationId=GrantOptions.GrantRegistrationId   
			--												INNER JOIN Scheme ON Scheme.SchemeId=GrantOptions.SchemeId  
			--												LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId  
			--												WHERE CONVERT(DATE,GrantLeg.FinalVestingDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate))) 

			--OptionsLapsedInForce
			--SET @OptionsLapsedInForce=( SELECT SUM(((GL.GrantedQuantity-GL.CancelledQuantity)*@OptionRatioDivisor)/@OptionRatioMultiplier) AS OptionsLapsedInForce FROM GrantOptions GOS
			--								INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
			--								INNER JOIN Scheme SCH ON SCH.SchemeId=GOS.SchemeId  
			--								LEFT OUTER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
			--							WHERE CONVERT(DATE, GL.FinalVestingDate) > CONVERT(DATE,@ToDate) AND SCH.SchemeId=@SchemeID)
			--SET @OptionsVestedAndExercisable = 0
			---------------------------------------------------------------------------------------------------------------------------------------------------									
			
			-- Total Share 
			SET @TotalShares=(SELECT SUM(GL.GrantedQuantity) AS TotalShares 
			FROM GrantOptions GOS
			INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GOS.GrantRegistrationId 
			INNER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId 
			INNER JOIN Scheme SCH ON GOS.SchemeId=SCH.SchemeId   
			WHERE (CONVERT(DATE, GR.GrantDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)) AND GOS.SchemeId=@SchemeID)

			-- Exercise Amount for WAEPForEPEqualMP
			SET @ExAmtForEqualMp=(SELECT SUM(GL.GrantedQuantity*GR.ExercisePrice) AS ExercisedAmountEqualMP FROM GrantRegistration GR
										INNER JOIN GrantOptions GOS ON  GR.GrantRegistrationId=GOS.GrantRegistrationId 
										INNER JOIN Scheme ON GOS.SchemeId=Scheme.SchemeId   
										INNER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId  
										INNER JOIN SharePrices SPS ON GR.GrantDate=SPS.PriceDate 
									WHERE (CONVERT(DATE,GR.GrantDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)) AND GR.ExercisePrice=SPS.ClosePrice AND GOS.SchemeId=@SchemeID )

			-- Exercise Amount for WAEPForEPLessMP
			SET @ExAmtForLessMp =(SELECT SUM(GL.GrantedQuantity*GR.ExercisePrice) AS ExercisedAmountLessMP From GrantRegistration GR
										INNER JOIN GrantOptions GOS ON GR.GrantRegistrationId=GOS.GrantRegistrationId  
										INNER JOIN Scheme ON GOS.SchemeId=Scheme.SchemeId 
										INNER JOIN GrantLeg GL ON GOS.GrantOptionId=GL.GrantOptionId 
										INNER JOIN SharePrices SPS ON GR.GrantDate=SPS.PriceDate  
									WHERE(CONVERT(DATE,GR.GrantDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate))
									AND GOS.SchemeId=@SchemeID AND GR.ExercisePrice < SPS.ClosePrice)

			-- Exercise Amount for WAEPForEPMoreMP
			SET @ExAmtForMoreMp=(SELECT SUM(GL.GrantedQuantity*GR.ExercisePrice) AS ExercisedAmountMoreMP FROM GrantRegistration GR
										INNER JOIN GrantOptions GOS On GR.GrantRegistrationId=GOS.GrantRegistrationId  
										INNER JOIN Scheme SCH On GOS.SchemeId=SCH.SchemeId   
										INNER JOIN GrantLeg GL On GOS.GrantOptionId=GL.GrantOptionId  
										INNER JOIN SharePrices SPS On GR.GrantDate=SPS.PriceDate  
									WHERE (GR.GrantDate BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)) 
									AND GR.ExercisePrice > SPS.ClosePrice AND GOS.SchemeId=@SchemeID)

			UPDATE #TempSBIDisclosureDetails SET OptionsGranted=ISNULL(@OptionsGranted,0),OptionsVested=ISNULL(@OptionsVested,0),OptionsExercised=ISNULL(@OptionsExercised,0),
											SharesExercised=ISNULL(@SharesExercised,0),MoneyRelized=ISNULL(@MoneyRelized,0),OptionsLapsed=ISNULL(@OptionsLapsed,0),
											OptionsCancelled=ISNULL(@OptionsCancelled,0),
											OptionsCancelledInForce=ISNULL(@OptionsCancelled,0),
											OptionsInForce=ISNULL(@OptionsUnVested,0)+ISNULL(@OptionsVested,0)+ISNULL(@PendingForApproval,0),TotalOptionsLapsed=(ISNULL(@OptionsLapsed,0)+ ISNULL(@OptionsCancelled,0)),
											TotalOptionsVested=ISNULL(@OptionVestedAsOnToDate,0)+ISNULL(@VestedCancelledOptions,0)+ISNULL(@OptionsLapsed,0)+ISNULL(@OptionsExercised,0)-(ISNULL(@OptionsVestedasFromDate,0)),
											WAEPForEPEqualMP=ROUND(ISNULL((@ExAmtForEqualMp/@TotalShares),0),0),
											WAEPForEPLessMP= ROUND(ISNULL((@ExAmtForLessMp/@TotalShares),0),0),WAEPForEPMoreMP =ROUND(ISNULL((@ExAmtForMoreMp/@TotalShares),0),0)
											--Commented Code,used for checking value
											--,OptionVestedasOnToDate=@OptionVestedAsOnToDate,OptionsVestedasFromDate= @OptionsVestedasFromDate,PendingForApproval=@PendingForApproval,VestedLapsedOptions= @VestedLapsedOptions,VestedCancelledOptions=@VestedCancelledOptions
											------------------------ No need to below commented code---------------------------------------
											--,OptionsLapsedInForce=ISNULL(@OptionsLapsedInForce,0),OptionsExercisedInForce=ISNULL(@OptionsExercisedInForce,0),OptionsGrantedInForce=ISNULL(@OptionsGrantedInForce,0),OptionsVestedAndExercisable=ISNULL(@OptionsVestedAndExercisable,0)
											-------------------------------------------------------------------------------------------------------
			WHERE Ind=@MINID 

			SET @MINID=@MINID+1
		END


	--Any other employee who receives a grant in any one year of option amounting to 5% or more of option granted during that year 
	DECLARE @TotalGrantedOptions DECIMAL(18)
	SET @TotalGrantedOptions=(SELECT SUM(GrantLeg.GrantedOptions) AS GrantedOptions  FROM GrantOptions
								INNER JOIN GrantRegistration On GrantRegistration.GrantRegistrationId=GrantOptions.GrantRegistrationId  
								INNER JOIN GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId  
								WHERE CONVERT(DATE,GrantRegistration.GrantDate) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate)) 
 
	INSERT INTO #TempSBIDisclosureDetails(EmployeeId,EmpPerYrsOpsGrantedQty)  
				SELECT GrantOptions.EmployeeId, SUM(GrantLeg.GrantedOptions) AS GrantedOptions  FROM GrantOptions
					INNER JOIN GrantRegistration On GrantRegistration.GrantRegistrationId=GrantOptions.GrantRegistrationId  
					INNER JOIN GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId  
				WHERE GrantRegistration.GrantDate BETWEEN CONVERT(DATE,@FromDate)  AND  CONVERT(DATE,@ToDate) 
				GROUP BY GrantOptions.EmployeeId 
				HAVING (SUM(GrantLeg.GrantedOptions)*100/@TotalGrantedOptions)>5
	 
	SELECT *FROM #TempSBIDisclosureDetails 

	IF EXISTS (SELECT *  FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#TempSBIDisclosureDetails'))      
		BEGIN      
			DROP TABLE #TempSBIDisclosureDetails      
		END
	IF EXISTS (SELECT *  FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#TEMP_DATA'))      
	BEGIN      
		DROP TABLE #TEMP_DATA      
	END
	IF EXISTS (SELECT *  FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID(N'tempdb..#TEMP_DATA1'))      
	BEGIN      
		DROP TABLE #TEMP_DATA1      
	END
 END


GO
