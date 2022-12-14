/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEME_AUDIT_TRAIL]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_SCHEME_AUDIT_TRAIL]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_SCHEME_AUDIT_TRAIL]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_SCHEME_AUDIT_TRAIL]
  @SchemeId VARCHAR(50) = NULL
AS
BEGIN
	SET NOCOUNT ON;	
			   
	SELECT 
		ATSAE_ID, AEC_ID, SchemeId, IS_UpDate, Field_Name, Old_value, New_Value, Created_By, Created_On, Updated_By, Updated_On
    FROM AUDIT_TRAIL_SCHEMEAUTOEXERCISE
                           
	SET NOCOUNT OFF;	
END
GO
