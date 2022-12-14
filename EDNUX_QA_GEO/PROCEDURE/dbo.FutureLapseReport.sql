/****** Object:  StoredProcedure [dbo].[FutureLapseReport]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FutureLapseReport]
GO
/****** Object:  StoredProcedure [dbo].[FutureLapseReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author : Chetan Chopkar
-- Create date : 23 Nov 2012
-- Description : Procedure is used for calculate future lapse reprot.
-- Modified By : <Santosh Panchal> on : 09/Aug/2013
-- Mantis Issue: 0004524,0004525
-- =============================================
CREATE PROCEDURE [dbo].[FutureLapseReport]
	-- Add the parameters for the stored procedure here
	@ExpiryDateFrom dateTime,
	@ExpiryDateTo dateTime
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	DECLARE @ApplyBonusTo CHAR, @ApplySplitTo CHAR, @DisplayAs CHAR,  @DisplaySplit cHar
	BEGIN
		SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo, @DisplayAs= DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy
	END
	
	-- For future lapse report queries
	BEGIN
		IF ((@DisplayAs = 'C') AND (@DisplaySplit='C'))	
			BEGIN
				--Future_GetConsolidated_LapsedDetails
				SELECT SC.SchemeTitle AS SchemeTitle, /*MIT.INSTRUMENT_NAME,*/
				--ISNULL(CIM.INS_DISPLY_NAME, 0) AS INSTRUMENT_NAME,
				
				CASE WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
					WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration, GL.Parent AS Parent,  
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId,  
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate,
				GL.GrantedOptions, SUM((GL.GrantedOptions * SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed,  
				'C' AS CSFlag  FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId  
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId  
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId  
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId  
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId  
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalExpirayDate >= @ExpiryDateFrom AND GL.FinalExpirayDate <= @ExpiryDateTo )  
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias, GL.GrantedOptions,GR.GrantDate, GR.GrantRegistrationId, GR.ExercisePrice,  
				GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity,GL.FinalvestingDate,GL.Parent 
				ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId
			END
		ELSE IF ((@DisplayAs = 'C') AND (@DisplaySplit = 'S'))
			--Future_GetConsolidated_LapsedDetails_BonusCon_SplitSep
			BEGIN
				SELECT SC.SchemeTitle AS SchemeTitle,
				CASE WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias,GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration,  'OB' AS parent,
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId,
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate, 
				GL.GrantedOptions, SUM( (GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 'S' AS CSFlag , GL.FinalExpirayDate AS FinalExpirayDate
				FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId  
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId  
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId  
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId  
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId  
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE ( GL.FinalExpirayDate >= @ExpiryDateFrom AND GL.FinalExpirayDate <= @ExpiryDateTo ) AND GL.parent IN ('N','B') AND IsOriginal='Y'  
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle,MIT.INSTRUMENT_NAME, CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias, GL.GrantedOptions,GR.GrantDate, GR.GrantRegistrationId, GR.ExercisePrice,    
				GOP.GrantedOptions,GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity,GL.FinalvestingDate    
				UNION ALL  
				SELECT  SC.SchemeTitle AS SchemeTitle, ISNULL(CIM.INS_DISPLY_NAME, 0) AS INSTRUMENT_NAME,CM.CurrencyName,CM.CurrencyAlias, GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration, 'SB' AS parent,
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId,   
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate
				, GL.GrantedOptions, SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate
				FROM  GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId  
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId  
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId  
				INNER Join EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId  
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId  
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalExpirayDate >= @ExpiryDateFrom AND GL.FinalExpirayDate <= @ExpiryDateTo ) AND GL.parent in ('S','B') AND IsSplit='Y'  
				GROUP By EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME, CM.CurrencyName,CM.CurrencyAlias, GL.GrantedOptions,GR.GrantDate, GR.GrantRegistrationId, GR.ExercisePrice,    
				GOP.GrantedOptions, GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity,GL.FinalvestingDate    
				ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId
			END
		ELSE IF ((@DisplayAs = 'S') AND (@DisplaySplit= 'C'))
			--Future_GetConsolidated_LapsedDetails_BonusSep_SplitCon
			BEGIN
				SELECT SC.SchemeTitle AS SchemeTitle,
				CASE WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration, 'OS' AS parent,
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId, 
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions, 
				GL.FinalvestingDate AS FinalVestingdate,  GL.GrantedOptions, 
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 
				'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate FROM GrantOptions AS GOP
				Inner Join GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				Inner join Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				Inner Join GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				Inner Join EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				Inner Join UserMaster AS UM  ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalExpirayDate >= @ExpiryDateFrom AND GL.FinalExpirayDate <= @ExpiryDateTo) 
				AND GL.parent IN ('N','S') AND IsOriginal='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias,GL.GrantedOptions, GR.GrantDate, GR.GrantRegistrationId, GR.ExercisePrice, 
				GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity, GL.FinalvestingDate 
				UNION ALL 
				SELECT SC.SchemeTitle AS SchemeTitle,
				CASE WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName, CM.CurrencyAlias, GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration, 'BS' AS parent,
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId, 
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions,
				GL.FinalvestingDate AS FinalVestingdate, GL.GrantedOptions, 
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 
				'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE ( GL.FinalExpirayDate >= @ExpiryDateFrom AND GL.FinalExpirayDate <= @ExpiryDateTo) 
				AND GL.parent in ('S','B') AND IsBonus='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias, GL.GrantedOptions, GR.GrantDate, GR.GrantRegistrationId, GR.ExercisePrice, 
				GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity, GL.FinalvestingDate 
				ORDER BY SchemeTitle, EmployeeId ASC,GrantOpId
			END
		ELSE
			--Future_GetSaperate_LapsedDetails
			BEGIN
				SELECT SC.SchemeTitle AS SchemeTitle,
				CASE WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantDate AS GrantDate, GR.GrantRegistrationId AS GrantRegistration, GL.Parent AS Parent,  
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, 
				EM.EmployeeName AS EmployeeName,GOP.GrantOptionId AS GrantOpId, UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate,  
				GL.ExercisableQuantity  AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate, GL.GrantedOptions, 
				(GL.GrantedOptions * SC.OptionRatioDivisor)/SC.OptionRatioMultiplier AS OptionsLapsed,  
				'S' AS CSFlag FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId  
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalExpirayDate >= @ExpiryDateFrom And GL.FinalExpirayDate <= @ExpiryDateTo)  
				ORDER BY SchemeTitle, EmployeeId ASC,GrantOpId ASC, Parent 
			END 
	END
END
GO
