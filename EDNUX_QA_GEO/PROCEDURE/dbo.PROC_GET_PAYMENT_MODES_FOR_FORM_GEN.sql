/****** Object:  StoredProcedure [dbo].[PROC_GET_PAYMENT_MODES_FOR_FORM_GEN]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PAYMENT_MODES_FOR_FORM_GEN]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PAYMENT_MODES_FOR_FORM_GEN]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_PAYMENT_MODES_FOR_FORM_GEN]
(	 
	 @MIT_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @PAYMENTMODE_BASED_ON NVARCHAR(50)
	
	SELECT @PAYMENTMODE_BASED_ON = PAYMENTMODE_BASED_ON FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID = @MIT_ID
	
	IF (UPPER(@PAYMENTMODE_BASED_ON) = 'RDOCOUNTRY')
	BEGIN
		SELECT X.PayModeName,RANK() OVER(ORDER BY X.PaymentModeName) AS ID, X.PaymentModeName FROM
		(
			SELECT 
				DISTINCT PM.PayModeName, 'Country level_'+ PM.PayModeName AS PaymentModeName
			FROM 
				ResidentialPaymentMode AS RPM	
			INNER JOIN PaymentMaster AS PM ON RPM.PaymentMaster_Id = PM.Id  
			INNER JOIN COUNTRY_PAYMENTMODE_MAPPING AS CPM ON CPM.RPM_ID = RPM.id 
			WHERE 
				UPPER(RPM.PAYMENT_MODE_CONFIG_TYPE) = 'COUNTRY' AND RPM.MIT_ID = @MIT_ID AND CPM.ACTIVE = 1
		)X
	END
	ELSE IF (UPPER(@PAYMENTMODE_BASED_ON) = 'RDORESIDENTSTATUS')
	BEGIN
	
		SELECT X.PayModeName,RANK() OVER(ORDER BY X.PaymentModeName) AS ID, X.PaymentModeName FROM
		(
			SELECT 
				DISTINCT PM.PayModeName, RT.[Description] +'_'+ PM.PayModeName AS PaymentModeName
			FROM  
				ResidentialPaymentMode AS RPM 
			INNER JOIN ResidentialType AS RT ON RPM.ResidentialType_Id = RT.id 
			INNER JOIN PaymentMaster AS PM ON RPM.PaymentMaster_Id = PM.Id 
			WHERE 
				RPM.MIT_ID = @MIT_ID AND UPPER(RPM.PAYMENT_MODE_CONFIG_TYPE) = 'RESIDENT' AND RPM.isActivated = 'Y'
		)X
	END
	ELSE
	BEGIN
		SELECT X.PayModeName,RANK() OVER(ORDER BY X.PaymentModeName) AS ID, X.PaymentModeName FROM
		(
			SELECT 
				DISTINCT PM.PayModeName, RT.[Description] +'_'+ PM.PayModeName AS PaymentModeName
			FROM 
				ResidentialPaymentMode AS RPM 
			INNER JOIN ResidentialType AS RT ON RPM.ResidentialType_Id = RT.id 
			INNER JOIN PaymentMaster AS PM ON RPM.PaymentMaster_Id = PM.Id 
			WHERE 
				RPM.MIT_ID = @MIT_ID AND UPPER(RPM.PAYMENT_MODE_CONFIG_TYPE) = 'COMPANY' AND RPM.isActivated = 'Y'
		)X
	END
	
	SET NOCOUNT OFF;
END
GO
