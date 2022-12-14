/****** Object:  StoredProcedure [dbo].[GetGrantRegIDsForMapping]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetGrantRegIDsForMapping]
GO
/****** Object:  StoredProcedure [dbo].[GetGrantRegIDsForMapping]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetGrantRegIDsForMapping]
(
	@SchemeID VARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT GrantRegistrationId, ExercisePrice
	FROM GrantRegistration
	WHERE SchemeId = @SchemeID
	ORDER BY GrantDate DESC
	
	SET NOCOUNT OFF
END
GO
