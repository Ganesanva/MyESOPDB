/****** Object:  StoredProcedure [dbo].[PROC_GET_GRANTS_MAPPING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_GRANTS_MAPPING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_GRANTS_MAPPING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_GRANTS_MAPPING]
AS
BEGIN	

	SET NOCOUNT ON;

	SELECT 
		ROW_NUMBER() OVER(ORDER BY (SELECT GroupNumber)) AS 'Sr. No.',  GroupNumber, GrantRegistrationId, GrantOptionId, 
		FinalVestingDate, FinalExpiryDate 
	FROM 
		GrantMappingOnExNow
	ORDER BY GroupNumber,  GrantRegistrationId, GrantOptionId ASC

	SET NOCOUNT OFF;
END
GO
