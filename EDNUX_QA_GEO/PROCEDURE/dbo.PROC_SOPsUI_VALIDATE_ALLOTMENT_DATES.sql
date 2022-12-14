/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_ALLOTMENT_DATES]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SOPsUI_VALIDATE_ALLOTMENT_DATES]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SOPsUI_VALIDATE_ALLOTMENT_DATES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SOPsUI_VALIDATE_ALLOTMENT_DATES] 
	
	@SOPSsUI_GET_ALLOTMENT_DATA SOPSsUI_GET_ALLOTMENT_DATA READONLY
AS
BEGIN
	
	SET NOCOUNT ON;
		
	CREATE TABLE #TEMP_EXERCISED_ID_AVALABLE
	(
		TEIA_EXERCISED_ID NVARCHAR(100)
	)
	
	INSERT INTO #TEMP_EXERCISED_ID_AVALABLE 
	SELECT EXERCISED_ID FROM @SOPSsUI_GET_ALLOTMENT_DATA
	
	DELETE TEIA
	FROM #TEMP_EXERCISED_ID_AVALABLE AS TEIA
	INNER JOIN Exercised AS EXED ON CONVERT(NVARCHAR(100), EXED.ExercisedId) = TEIA.TEIA_EXERCISED_ID
 	
	SELECT EXERCISED_ID AS 'IDs', 'Remove duplicate User IDs from Excel.' AS 'Message' FROM @SOPSsUI_GET_ALLOTMENT_DATA GROUP BY EXERCISED_ID HAVING COUNT(EXERCISED_ID)>1
	UNION ALL
	SELECT EXERCISED_ID AS 'IDs', 'Allotment date is null or Not in expected format.' AS 'Message' FROM @SOPSsUI_GET_ALLOTMENT_DATA WHERE (ALLOTMENT_DATE IS NULL)
	UNION ALL
	SELECT EXERCISED_ID AS 'IDs', 'Allotment date should be less or equal to Today''s date' AS 'Message' FROM @SOPSsUI_GET_ALLOTMENT_DATA WHERE (CONVERT(DATE,ALLOTMENT_DATE) > CONVERT(DATE,GETDATE())) AND (ALLOTMENT_DATE IS NOT NULL)
	UNION ALL
	SELECT TEIA_EXERCISED_ID AS 'IDs', 'Exercised Id not avaiable in table. Please remove from Excel.' AS 'Message' FROM #TEMP_EXERCISED_ID_AVALABLE

	SET NOCOUNT OFF;				
END
GO
