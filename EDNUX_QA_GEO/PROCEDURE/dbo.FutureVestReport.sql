/****** Object:  StoredProcedure [dbo].[FutureVestReport]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[FutureVestReport]
GO
/****** Object:  StoredProcedure [dbo].[FutureVestReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author : Chetan Chopkar
-- Create date : 26 Nov 2012
-- Description : Procedure is used for calculate future vest reprot.
-- Modified By : <Santosh Panchal> on : 09/Aug/2013
-- =============================================
CREATE PROCEDURE [dbo].[FutureVestReport]
	-- Add the parameters for the stored procedure here
	@VestingFromDate dateTime,
	@VestingToDate dateTime
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
	
	-- For future vest  report queries
	BEGIN
		IF ((@DisplayAs = 'C') AND (@DisplaySplit='C'))	
			BEGIN
				--Future_GetConsolidated_VestDetails
				SELECT SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,  
				CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration,
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, 
				GOP.GrantOptionId AS GrantOpId, UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, 
				GL.ExercisableQuantity  AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate, GL.VestingType AS TypeofVesting,GL.GrantedOptions,
				SUM((GL.GrantedOptions * SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed,
				 GL.Parent AS Parent, 'C' AS CSFlag FROM GrantOptions as GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, GL.GrantedOptions, GR.GrantDate,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias, GR.GrantRegistrationId, 
				GR.ExercisePrice, GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity, GL.FinalvestingDate, GL.VestingType,
				GL.Parent ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId
			END
		ELSE IF ((@DisplayAs = 'C') AND (@DisplaySplit = 'S'))
			BEGIN
			--Future_GetConsolidated_VestDetails_BonusCon_SplitSep
				SELECT SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration,  
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, 
				GOP.GrantOptionId AS GrantOpId, UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate,
				GL.ExercisableQuantity AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate,GL.VestingType AS TypeofVesting, GL.GrantedOptions,
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) as OptionsLapsed, 
				'OB' AS parent, 'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate
				FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM  ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) AND GL.parent IN ('N','B') AND IsOriginal='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, GL.GrantedOptions,GR.GrantDate,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME, CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId, 
				GR.ExercisePrice, GOP.GrantedOptions,GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity, GL.FinalvestingDate,GL.VestingType   
				UNION ALL 
				SELECT SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration,  
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, 
				GOP.GrantOptionId AS GrantOpId, UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate,
				GL.ExercisableQuantity AS Vestedoptions, GL.FinalvestingDate AS FinalVestingdate,GL.VestingType AS TypeofVesting, GL.GrantedOptions, 
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 
				'SB' AS parent, 'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate 
				FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) AND GL.parent IN ('S','B') AND IsSplit='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, GL.GrantedOptions,GR.GrantDate,MIT.INSTRUMENT_NAME, CIM.INS_DISPLY_NAME, CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId, 
				GR.ExercisePrice, GOP.GrantedOptions,GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate,
				GL.ExercisableQuantity, GL.FinalvestingDate,GL.VestingType    
				ORDER BY SchemeTitle, EmployeeId ASC, GrantOpId
			END
		ELSE IF ((@DisplayAs = 'S') AND (@DisplaySplit= 'C'))
			BEGIN
			--Future_GetConsolidated_Vested_BonusSep_SplitCon
				SELECT SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration, 
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId,  EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId, 
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity AS Vestedoptions, 
				GL.FinalvestingDate AS FinalVestingdate,GL.VestingType AS TypeofVesting, GL.GrantedOptions, 
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) AS OptionsLapsed, 
				'OS' AS parent, 'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate 
				From GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) AND GL.parent IN ('N','S') AND IsOriginal='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, GL.GrantedOptions, GR.GrantDate,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME, CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId, 
				GR.ExercisePrice, GOP.GrantOptionId, UM.IsUserActive, GL.ExercisableQuantity, GL.FinalvestingDate,GL.VestingType, GL.FinalExpirayDate
				UNION ALL 
				SELECT SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName,CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration, 
				GR.ExercisePrice AS ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId, 
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity AS Vestedoptions,
				GL.FinalvestingDate AS FinalVestingdate,GL.VestingType AS TypeofVesting, GL.GrantedOptions, 
				SUM((GL.GrantedOptions*SC.OptionRatioDivisor)/SC.OptionRatioMultiplier) as OptionsLapsed, 
				'BS' AS parent, 'S' AS CSFlag, GL.FinalExpirayDate AS FinalExpirayDate
				FROM GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR ON GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) AND GL.parent IN ('S','B') AND IsBonus='Y' 
				GROUP BY EM.EmployeeId, EM.EmployeeName, SC.SchemeTitle, GL.GrantedOptions, GR.GrantDate,MIT.INSTRUMENT_NAME,CIM.INS_DISPLY_NAME,CM.CurrencyName,CM.CurrencyAlias, GR.GrantRegistrationId, 
				GR.ExercisePrice, GOP.GrantOptionId, UM.IsUserActive, GL.FinalExpirayDate, GL.ExercisableQuantity, GL.FinalvestingDate ,GL.VestingType
				ORDER BY SchemeTitle,EmployeeId ASC, GrantOpId 
			END
		ELSE
			BEGIN
			--Future_GetSaperate_VestDetails
				Select SC.SchemeTitle AS SchemeTitle, GR.GrantDate AS GrantDate,
				CASE 
				WHEN CIM.INS_DISPLY_NAME = '' THEN MIT.INSTRUMENT_NAME
				WHEN CIM.INS_DISPLY_NAME IS NULL THEN MIT.INSTRUMENT_NAME ELSE CIM.INS_DISPLY_NAME END AS INSTRUMENT_NAME,
				CM.CurrencyName, CM.CurrencyAlias, GR.GrantRegistrationId AS GrantRegistration, GR.ExercisePrice AS 
				ExercisePrice, EM.EmployeeId AS EmployeeId, EM.EmployeeName AS EmployeeName, GOP.GrantOptionId AS GrantOpId, 
				UM.IsUserActive AS Status, GL.FinalExpirayDate AS ExpiryDate, GL.ExercisableQuantity  AS Vestedoptions,
				GL.FinalvestingDate AS FinalVestingdate,GL.VestingType AS TypeofVesting, GL.GrantedOptions,
				(GL.GrantedOptions * SC.OptionRatioDivisor)/SC.OptionRatioMultiplier AS OptionsLapsed, GL.Parent AS Parent, 
				'S' AS CSFlag From GrantOptions AS GOP
				INNER JOIN GrantRegistration AS GR On GOP.GrantRegistrationId=GR.GrantRegistrationId 
				INNER JOIN Scheme AS SC ON GR.SchemeId=SC.SchemeId 
				INNER JOIN GrantLeg AS GL ON GOP.GrantOptionId=GL.GrantOptionId 
				INNER JOIN EmployeeMaster AS EM ON GOP.EmployeeId=EM.EmployeeId 
				INNER JOIN UserMaster AS UM ON UM.EmployeeId= EM.EmployeeId 
				INNER JOIN MST_INSTRUMENT_TYPE AS MIT ON SC.MIT_ID = MIT.MIT_ID
				INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON SC.MIT_ID=CIM.MIT_ID
				INNER JOIN CurrencyMaster AS CM ON CIM.CurrencyID=CM.CurrencyID	
				WHERE (GL.FinalVestingDate >= @VestingFromDate AND GL.FinalVestingDate <= @VestingToDate) 
				ORDER BY SchemeTitle, EmployeeId ASC,GrantOpId ASC, Parent 			
			END
	END	
END
GO
