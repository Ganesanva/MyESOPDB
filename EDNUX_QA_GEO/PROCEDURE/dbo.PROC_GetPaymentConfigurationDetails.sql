/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentConfigurationDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPaymentConfigurationDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPaymentConfigurationDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetPaymentConfigurationDetails]
  
AS
BEGIN
	SELECT * FROM PaymentGatewayParameters
END       
GO
