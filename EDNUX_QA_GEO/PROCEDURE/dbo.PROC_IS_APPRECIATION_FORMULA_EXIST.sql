/****** Object:  StoredProcedure [dbo].[PROC_IS_APPRECIATION_FORMULA_EXIST]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_IS_APPRECIATION_FORMULA_EXIST]
GO
/****** Object:  StoredProcedure [dbo].[PROC_IS_APPRECIATION_FORMULA_EXIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_IS_APPRECIATION_FORMULA_EXIST]
(	   
	@MIT_ID INT = NULL,
	@SCHEME_ID NVARCHAR(100) = NULL	
 )
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY	
	
		SELECT COUNT(*) AS FORMULAEXIST FROM APPERCIATION_FORMULA_CONFIG WHERE SCHEME_ID = @SCHEME_ID AND MIT_ID = @MIT_ID --AND IS_FORMULA_APPLIED = 1
		
	END TRY
	BEGIN CATCH	
		RETURN 0
	END CATCH
	
	SET NOCOUNT OFF;
END
GO
