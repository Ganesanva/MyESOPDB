/****** Object:  UserDefinedFunction [dbo].[FN_GET_QUANTITYWithSCHEME]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_QUANTITYWithSCHEME]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_QUANTITYWithSCHEME]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Amin>
-- Create date: <09 Sep 2012>
-- Description:   <FUNCTION created to fetch quantity as per the requirement>  
-- Test exectution : SELECT dbo.FN_GET_QUANTITYWithSCHEME('ESOP 2007','OPTIONS_UNVESTED') AS OPTIONS_UNVESTED

CREATE FUNCTION [dbo].[FN_GET_QUANTITYWithSCHEME]
(
      @SCHEME_NAME varchar(500),
      @QUANTITY_OF varchar(50)
)
RETURNS NUMERIC(18,2)

AS      
BEGIN
	DECLARE @OptionsGranted				AS NUMERIC(18,4)
	DECLARE @OptionsVested				AS NUMERIC(18,4)	
	DECLARE @OptionsUnVested			AS NUMERIC(18,4)	
	DECLARE @OptionsExercised			AS NUMERIC(18,4)
	DECLARE @OptionsCancelled			AS NUMERIC(18,4)
	DECLARE @OptionsLapsed				AS NUMERIC(18,4)
	DECLARE @FinalQty					AS NUMERIC(18,2)
	DECLARE @strOptionsGranted			AS VARCHAR(50)
	DECLARE @strOptionsVested			AS VARCHAR(50)
	DECLARE @strOptionsUnVested			AS VARCHAR(50)
	DECLARE @strOptionsExercised		AS VARCHAR(50)
	DECLARE @strOptionsCancelled		AS VARCHAR(50)
	DECLARE @strOptionsLapsed			AS VARCHAR(50)
	
	set @strOptionsGranted		= 'OPTIONS_GRANTED'
	set @strOptionsVested		= 'OPTIONS_VESTED'
	set @strOptionsUnVested		= 'OPTIONS_UNVESTED'
	set @strOptionsExercised	= 'OPTIONS_EXERCISED'
	set @strOptionsCancelled	= 'OPTIONS_CANCELLED'
	set @strOptionsLapsed		= 'OPTIONS_LAPSED'
	
	--Options Granted
	SELECT	@OptionsGranted = Sum((GrantLeg.SplitQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier)
			FROM GrantRegistration
			INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId
			INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId
			LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId
	WHERE (GRANTOPTIONS.SCHEMEID IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,',')))
   
	--OptionsVestedAndExercisable
	SELECT	@OptionsVested = Sum(((GrantLeg.ExercisableQuantity+GrantLeg.UnapprovedExerciseQuantity)*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier)
			FROM GrantRegistration
			INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId
			INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId
			LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId
	WHERE	(GRANTOPTIONS.SCHEMEID IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,','))) 
			AND (GrantLeg.FinalVestingDate<=GETDATE()
			AND GrantLeg.FinalExpirayDate>=GETDATE()) 

	--Options Exercised   
	SELECT	@OptionsExercised = Sum((Exercised.SplitExercisedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier)
			FROM GrantRegistration
			INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId
			INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId
			LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId
			LEFT OUTER JOIN Exercised ON GrantLeg.ID=Exercised.GrantLegSerialNumber
	WHERE	(GRANTOPTIONS.SCHEMEID IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,',')))   
			AND (Exercised.SharesIssuedDate<=GETDATE())

	--Options Cancelled
	SELECT	@OptionsCancelled = Sum((GrantLeg.SplitCancelledQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier)
			FROM GrantRegistration
			INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId
			INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId
			LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId
	WHERE	(GRANTOPTIONS.SCHEMEID IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,',')))   
			AND (GrantLeg.CancellationDate<=GETDATE())

	--options lapsed  
	SELECT	@OptionsLapsed = Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier)
			FROM GrantRegistration
			INNER JOIN Scheme ON GrantRegistration.SchemeId=Scheme.SchemeId
			INNER JOIN GrantOptions ON GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId
			LEFT OUTER JOIN GrantLeg ON GrantOptions.GrantOptionId=GrantLeg.GrantOptionId
	WHERE	(GRANTOPTIONS.SCHEMEID IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,',')))
			AND (GrantLeg.FinalExpirayDate<=GETDATE())


	IF(@QUANTITY_OF = 'OPTIONS_GRANTED')
		BEGIN 
			set @FinalQty = @OptionsGranted
		END
	
	ELSE IF(@QUANTITY_OF = 'OPTIONS_VESTED')
		BEGIN 
			set @FinalQty = @OptionsVested
		END
	
	ELSE IF(@QUANTITY_OF = 'OPTIONS_UNVESTED')
		BEGIN 
			SET  @OptionsUnVested = @OptionsGranted - (@OptionsVested + @OptionsExercised + @OptionsCancelled + @OptionsLapsed )
			set @FinalQty = @OptionsUnVested
		END
	
	ELSE IF(@QUANTITY_OF = 'OPTIONS_EXERCISED')
		BEGIN 
			set @FinalQty = @OptionsExercised
		END
		
	ELSE IF(@QUANTITY_OF = 'OPTIONS_CANCELLED')
		BEGIN 
			set @FinalQty =@OptionsCancelled
		END		
		
	ELSE IF(@QUANTITY_OF = 'OPTIONS_LAPSED')
		BEGIN 
			set @FinalQty = @OptionsLapsed 
		END		
		
RETURN @FinalQty 
END
GO
