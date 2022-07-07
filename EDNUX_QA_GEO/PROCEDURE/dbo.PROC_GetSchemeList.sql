/****** Object:  StoredProcedure [dbo].[PROC_GetSchemeList]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetSchemeList]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetSchemeList]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetSchemeList]
AS
BEGIN
	SET NOCOUNT ON
		SELECT Schemeid, SchemeTitle AS SchemeName  FROM Scheme
	SET NOCOUNT OFF
END
GO
