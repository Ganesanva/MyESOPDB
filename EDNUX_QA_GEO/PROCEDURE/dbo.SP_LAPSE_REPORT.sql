/****** Object:  StoredProcedure [dbo].[SP_LAPSE_REPORT]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_LAPSE_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[SP_LAPSE_REPORT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_LAPSE_REPORT] (@FROMDATE DATE, @TODATE DATE) AS  
   
   
BEGIN  
   
	DECLARE @DisplayAs AS CHAR(1)
	DECLARE @DisplaySplit AS CHAR(1)
 SELECT  @DisplayAs = UPPER(DisplayAs), @DisplaySplit = UPPER(DisplaySplit) FROM BonusSplitPolicy  
   
 IF(@DisplayAs = 'C' AND @DisplaySplit = 'C')  
  BEGIN  
   SELECT MIT.MIT_ID, (CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME	ELSE MIT.INSTRUMENT_NAME END) AS INSTRUMENT_NAME,CM.CurrencyAlias, GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration,   
   GrantRegistration.ExercisePrice AS ExercisePrice, EmployeeMaster.EmployeeId AS EmployeeId, EmployeeMaster.EmployeeName AS EmployeeName,   
   GrantOptions.GrantOptionId AS GrantOpId, EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
   SUM((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) AS OptionsLapsed, '---' AS parent, 'C' AS CSFlag   
   FROM GrantOptions 
   
   INNER JOIN GrantRegistration ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID  
    
   WHERE ( GrantLeg.FinalExpirayDate BETWEEN  @FromDate  AND  @ToDate)   
   GROUP BY EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle,MIT.MIT_ID,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyAlias, GrantRegistration.ExercisePrice,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,   
   GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice,   
   GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate     
   HAVING SUM(GrantLeg.LapsedQuantity) > 0   
   ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId   
      
  END  
    
 ELSE IF (@DisplayAs = 'C' AND @DisplaySplit = 'S')  
  BEGIN  
	   SELECT  MIT.MIT_ID,(CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME	ELSE MIT.INSTRUMENT_NAME	END) AS INSTRUMENT_NAME,CM.CurrencyAlias,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration,   
	   GrantRegistration.ExercisePrice AS ExercisePrice, EmployeeMaster.EmployeeId AS EmployeeId, EmployeeMaster.EmployeeName as EmployeeName,   
	   GrantOptions.GrantOptionId AS GrantOpId, EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
	   SUM((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) AS OptionsLapsed, 'OB' AS parent, 'S' AS CSFlag  	   
	   FROM GrantOptions 
	   
	   INNER JOIN GrantRegistration  ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
	   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
	   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
	   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
	   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
	   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
	   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID   
	  
	   WHERE ( GrantLeg.FinalExpirayDate BETWEEN @FromDate AND @ToDate)   
	   AND GrantLeg.parent IN ('N','B') AND IsOriginal='Y'  
	   GROUP BY EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle,MIT.MIT_ID,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyAlias, GrantRegistration.ExercisePrice,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,   
	   GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice,   
	   GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate     
	   HAVING SUM(GrantLeg.LapsedQuantity) > 0   
     
   UNION ALL   
  
   SELECT MIT.MIT_ID,(CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME	ELSE MIT.INSTRUMENT_NAME END) AS INSTRUMENT_NAME,CM.CurrencyAlias, GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration,   
   GrantRegistration.ExercisePrice AS ExercisePrice, EmployeeMaster.EmployeeId AS EmployeeId, EmployeeMaster.EmployeeName AS EmployeeName,   
   GrantOptions.GrantOptionId AS GrantOpId, EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
   SUM((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) AS OptionsLapsed, 'SB' AS parent, 'S' AS CSFlag  
   FROM GrantOptions 
   
   INNER JOIN GrantRegistration ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID   
   
   WHERE ( GrantLeg.FinalExpirayDate BETWEEN @FromDate AND @ToDate)   
   AND GrantLeg.parent IN ('S','B') AND IsSplit='Y'   
   GROUP BY EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle,MIT.MIT_ID,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyAlias, GrantRegistration.ExercisePrice,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,   
   GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice,   
   GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate     
   HAVING SUM(GrantLeg.LapsedQuantity) > 0   
   ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId       
  END  
    
 ELSE IF (@DisplayAs = 'S' AND @DisplaySplit = 'C')  
  BEGIN  
   SELECT  MIT.MIT_ID,(CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME	ELSE MIT.INSTRUMENT_NAME END) AS INSTRUMENT_NAME,CM.CurrencyAlias, GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration,   
   GrantRegistration.ExercisePrice AS ExercisePrice, EmployeeMaster.EmployeeId AS EmployeeId, EmployeeMaster.EmployeeName AS EmployeeName,   
   GrantOptions.GrantOptionId AS GrantOpId, EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
   SUM((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) AS OptionsLapsed, 'OS' AS parent, 'S' AS CSFlag   
   FROM GrantOptions 
   
   INNER JOIN GrantRegistration ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID   
   
   WHERE ( GrantLeg.FinalExpirayDate BETWEEN @FromDate AND @ToDate)   
   AND GrantLeg.parent IN ('N','S') AND IsOriginal='Y'   
   GROUP BY EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle,MIT.MIT_ID, MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyAlias, GrantRegistration.ExercisePrice,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,  
   GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice,   
   GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate     
   HAVING SUM(GrantLeg.LapsedQuantity) > 0   
     
   UNION ALL   
  
   SELECT  MIT.MIT_ID,(CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN 	CIM.INS_DISPLY_NAME	ELSE MIT.INSTRUMENT_NAME END) AS INSTRUMENT_NAME,CM.CurrencyAlias, GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration,   
   GrantRegistration.ExercisePrice AS ExercisePrice, EmployeeMaster.EmployeeId AS EmployeeId, EmployeeMaster.EmployeeName AS EmployeeName,   
   GrantOptions.GrantOptionId AS GrantOpId, EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
   SUM((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) AS OptionsLapsed, 'BS' AS parent, 'S' AS CSFlag   
   FROM GrantOptions 
   
   INNER JOIN GrantRegistration ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID   
   
   WHERE ( GrantLeg.FinalExpirayDate BETWEEN @FromDate AND @ToDate)   
   AND GrantLeg.parent IN ('S','B') AND IsBonus='Y'   
   GROUP BY EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle,MIT.MIT_ID,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyAlias, GrantRegistration.ExercisePrice,GrantLeg.VestingPeriodId,GrantLeg.VestingDate,  
   GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice,   
   GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate     
   HAVING SUM(GrantLeg.LapsedQuantity) > 0   
   ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId        
  END  
   
 ELSE   
  BEGIN  
   SELECT MIT.MIT_ID,(CASE WHEN ISNull(CIM.INS_DISPLY_NAME,'') != '' THEN CIM.INS_DISPLY_NAME ELSE MIT.INSTRUMENT_NAME	END) AS INSTRUMENT_NAME,CM.CurrencyAlias, GrantLeg.VestingPeriodId,GrantLeg.VestingDate,Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate,   
   GrantRegistration.GrantRegistrationId AS GrantRegistration,GrantRegistration.ExercisePrice AS ExercisePrice,  
   EmployeeMaster.EmployeeId AS EmployeeId, GrantLeg.Parent AS Parent, EmployeeMaster.EmployeeName AS EmployeeName,GrantOptions.GrantOptionId AS GrantOpId,   
   EmployeeMaster.DateOfTermination AS STATUS, GrantLeg.FinalExpirayDate AS ExpiryDate,   
  (GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier AS OptionsLapsed, 'S' AS CSFlag   
   FROM GrantOptions   
   
   INNER JOIN GrantRegistration ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId   
   INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId   
   INNER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId   
   INNER JOIN EmployeeMaster ON GrantOptions.EmployeeId=EmployeeMaster.EmployeeId   
   INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON Scheme.MIT_ID = MIT.MIT_ID  
   INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON Scheme.MIT_ID=CIM.MIT_ID  
   INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID   
   
   WHERE ( GrantLeg.FinalExpirayDate BETWEEN @FromDate AND @ToDate)   
   AND GrantLeg.LapsedQuantity > 0   
   ORDER BY SchemeTitle, EmployeeId ASC,GrantOpId ASC,Parent       
  END  
END   
 
GO
