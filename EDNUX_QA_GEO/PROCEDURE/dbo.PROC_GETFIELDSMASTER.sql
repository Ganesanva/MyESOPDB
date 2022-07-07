/****** Object:  StoredProcedure [dbo].[PROC_GETFIELDSMASTER]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETFIELDSMASTER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETFIELDSMASTER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GETFIELDSMASTER]
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		MDF_ID, FIELD_NAME 
	FROM 
		MST_DYNAMIC_FIELD
	
	SET NOCOUNT OFF;
	
END
GO
