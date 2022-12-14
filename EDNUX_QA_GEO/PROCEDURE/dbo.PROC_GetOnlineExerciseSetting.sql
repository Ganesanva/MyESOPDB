/****** Object:  StoredProcedure [dbo].[PROC_GetOnlineExerciseSetting]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetOnlineExerciseSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetOnlineExerciseSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetOnlineExerciseSetting]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ISNULL(IS_SHOW_SHAREALLOTED, 0) AS IS_SHOW_SHAREALLOTED,ISNULL(IS_SHOW_CASHPAYOUT, 0) AS IS_SHOW_CASHPAYOUT
	FROM CompanyParameters

	SET NOCOUNT OFF;
END
GO
