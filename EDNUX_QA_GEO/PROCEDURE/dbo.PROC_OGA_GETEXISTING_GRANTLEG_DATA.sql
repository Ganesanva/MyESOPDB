/****** Object:  StoredProcedure [dbo].[PROC_OGA_GETEXISTING_GRANTLEG_DATA]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_OGA_GETEXISTING_GRANTLEG_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_OGA_GETEXISTING_GRANTLEG_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_OGA_GETEXISTING_GRANTLEG_DATA]	
	@GRANTOPTIONID	VARCHAR(500)
AS 
BEGIN

	SET NOCOUNT ON;
    
    SELECT 
		GrantLegId, FinalVestingDate, GrantedQuantity, VestingType 
	FROM 
		GrantLeg  
	WHERE 
		GrantOptionId = @GRANTOPTIONID	
		
	SET NOCOUNT OFF;
END
GO
