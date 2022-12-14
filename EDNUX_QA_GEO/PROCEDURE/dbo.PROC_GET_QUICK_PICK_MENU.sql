/****** Object:  StoredProcedure [dbo].[PROC_GET_QUICK_PICK_MENU]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_QUICK_PICK_MENU]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_QUICK_PICK_MENU]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_QUICK_PICK_MENU]

AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT 
		EMPD.EHD_ID,
		EMPD.BoxID,
		EMPD.NAME,
		CASE WHEN LEN(ISNULL(EMPD.DISPLAY_NAME,''))>0 THEN EMPD.DISPLAY_NAME ELSE EMPD.NAME END AS  DISPLAY_NAME,
	    CONVERT(BIT,EMPD.SHOW) AS SHOW,
		EMPD.RedirectUrl,
		EMPD.Type
	FROM 
		EmployeeHomeBoxes_Details AS EMPD INNER JOIN 
		EmployeeHomeBoxes AS EMP ON EMPD.BOXID = EMP.BOXID 
	WHERE 
		UPPER(EMP.NAME) = 'QUICK PICKS'
	
	SET NOCOUNT OFF;
END
GO
