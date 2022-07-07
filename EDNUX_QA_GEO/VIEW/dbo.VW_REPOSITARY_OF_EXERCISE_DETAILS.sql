/****** Object:  View [dbo].[VW_REPOSITARY_OF_EXERCISE_DETAILS]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_REPOSITARY_OF_EXERCISE_DETAILS]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VW_REPOSITARY_OF_EXERCISE_DETAILS] 
AS	
	
	SELECT 
		MSTDUM.DOCUMENT_NAME, MSTDUMD.Exercise_NO, MSTDUMD.IS_UPLOADED, MSTDUMD.EmployeeID
	FROM
		MST_DOCUMENT_UPLOAD_MASTER AS MSTDUM 
		LEFT OUTER JOIN MST_Document_Upload_Master_Details AS MSTDUMD  ON MSTDUM.MDUM_ID = MSTDUMD.MDUM_ID
	WHERE 
		(MSTDUMD.EmployeeID IS NOT NULL) ' 
GO
