/****** Object:  StoredProcedure [dbo].[PROC_GetConfigCLPayModeDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetConfigCLPayModeDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetConfigCLPayModeDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetConfigCLPayModeDetails]
AS
BEGIN
	SELECT CompanyID,IsSAPayModeAllowed,IsSPPayModeAllowed FROM CompanyParameters
END
GO
