/****** Object:  StoredProcedure [dbo].[PROC_OGA_GET_MAPPED_FIELDS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_OGA_GET_MAPPED_FIELDS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_OGA_GET_MAPPED_FIELDS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_OGA_GET_MAPPED_FIELDS]
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT FIELD_NAME AS FIELD_NAME, '@' + MAPPED_FIELD AS MAPPED_FIELD FROM OGA_FIELD_MAPPINGS WHERE MAPPED_FIELD IS NOT NULL
	
	SET NOCOUNT OFF;

END
GO
