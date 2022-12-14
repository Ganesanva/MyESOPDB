/****** Object:  StoredProcedure [dbo].[PROC_GetCDSLSetting]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCDSLSetting]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCDSLSetting]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetCDSLSetting]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT ISNULL(CDSLSettings, '1') AS CDSLSettings
	FROM CompanyParameters

	SET NOCOUNT OFF;
END
GO
