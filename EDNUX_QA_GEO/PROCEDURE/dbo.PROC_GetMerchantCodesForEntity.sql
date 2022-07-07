/****** Object:  StoredProcedure [dbo].[PROC_GetMerchantCodesForEntity]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetMerchantCodesForEntity]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetMerchantCodesForEntity]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROCEDURE [dbo].[PROC_GetMerchantCodesForEntity] 
		AS
		BEGIN
			SELECT DISTINCT GrantRegistrationId, '' AS Entity, '' AS Merchant_Code FROM GrantRegistration
		END




GO
