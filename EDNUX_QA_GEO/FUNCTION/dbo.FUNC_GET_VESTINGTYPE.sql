/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_VESTINGTYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FUNC_GET_VESTINGTYPE]
GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_GET_VESTINGTYPE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FUNC_GET_VESTINGTYPE] (
			@GrantOptionId VARCHAR(100),
			@GrantLegId NUMERIC(10,0))
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @VestingType VARCHAR(30),
			@Cnt int,
			@VestType CHAR(1)
			
			
	SELECT @Cnt = COUNT(*) FROM GrantLeg WHERE GrantOptionId =  @GrantOptionId and GrantLegId = @GrantLegId
	
	IF @Cnt > 1
	BEGIN
		SET @VestingType = 'Time / Performance Based'
	END	
	ELSE
	BEGIN
		SELECT @VestingType = CASE WHEN VestingType = 'T' THEN 'Time Based' WHEN VestingType = 'P' THEN 'Performance Based' ELSE '' END 
		FROM GrantLeg
		WHERE GrantOptionId =  @GrantOptionId and GrantLegId = @GrantLegId
	END
	RETURN @VestingType	
END
GO
