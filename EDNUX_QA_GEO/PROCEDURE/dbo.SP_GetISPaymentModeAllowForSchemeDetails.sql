/****** Object:  StoredProcedure [dbo].[SP_GetISPaymentModeAllowForSchemeDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GetISPaymentModeAllowForSchemeDetails]
GO
/****** Object:  StoredProcedure [dbo].[SP_GetISPaymentModeAllowForSchemeDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GetISPaymentModeAllowForSchemeDetails]
   @MIT_ID INT = NULL
AS
BEGIN
	SELECT 
		RANK() OVER (ORDER BY SCHEMEID) [SRNO], SCHEMEID, SCHEMETITLE, ISPAYMENTMODEREQUIRED 
	FROM 
		SCHEME
	WHERE 
		MIT_ID = @MIT_ID 
END
GO
