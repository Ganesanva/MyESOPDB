/****** Object:  StoredProcedure [dbo].[PROC_GetConfigureContactUs]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetConfigureContactUs]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetConfigureContactUs]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetConfigureContactUs]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id,[Description], EmailId from ConfigureContactUs Order By [Id]
END					



GO
