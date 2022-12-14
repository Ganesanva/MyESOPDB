/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyParameters]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetCompanyParameters]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetCompanyParameters]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetCompanyParameters]  
AS
BEGIN
	SET NOCOUNT ON;   
	
	SELECT ISNULL( PreqTax_ExchangeType,'')AS PreqTax_ExchangeType, 
	ISNULL(PreqTax_Shareprice,'')AS PreqTax_Shareprice,ISNULL( PreqTax_Calculateon,'')AS PreqTax_Calculateon ,
	ISNULL(prqustcalcon,'') AS prqustcalcon FROM companyparameters
END
GO
