/****** Object:  StoredProcedure [dbo].[PROC_GETSCHEMEID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETSCHEMEID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETSCHEMEID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETSCHEMEID]
AS
BEGIN
	SELECT '---ALL---' SchemeId
	UNION
	SELECT DISTINCT SchemeId FROM Scheme WHERE IsPUPEnabled='1'
END
GO
