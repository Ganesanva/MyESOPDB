/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GRANTACCMASS_UPLOAD]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OGA_GRANTACCMASS_UPLOAD]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_GRANTACCMASS_UPLOAD]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_OGA_GRANTACCMASS_UPLOAD]
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 EmployeeID, LetterCode, LetterAcceptanceStatus AS Status,LetterAcceptanceDate AS DateOfAction,
		 LastAcceptanceDate AS LastAcceptanceDate
		
		
	FROM 
		GrantAccMassUpload

	SET NOCOUNT OFF;

END
GO
