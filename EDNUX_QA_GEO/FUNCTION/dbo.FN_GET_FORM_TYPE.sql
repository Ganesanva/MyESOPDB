/****** Object:  UserDefinedFunction [dbo].[FN_GET_FORM_TYPE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_FORM_TYPE]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_FORM_TYPE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_FORM_TYPE]
(
      @PaymentMode_ID		BIGINT,
	  @MIT_ID				INT = NULL,	
	  @ExerciseNo	  		VARCHAR(20)= NULL 
)
RETURNS NVARCHAR(500)
AS      
BEGIN
		
		DECLARE @FORM_TYPE NVARCHAR(1000) 
		SET @FORM_TYPE = ''
	
	
		DECLARE @Type VARCHAR(20)
		DECLARE @format VARCHAR(20)

		SELECT @format='''at''';

		SELECT  @Type =CASE WHEN (UPPER( PAYMENTMODE_BASED_ON)='RDOCOMPANYLEVEL') THEN 'Company' 
				WHEN (UPPER( PAYMENTMODE_BASED_ON)='RDOCOUNTRY') THEN 'Country'
				WHEN (UPPER( PAYMENTMODE_BASED_ON)='RDORESIDENT') THEN 'Resident' Else '' END 
		FROM 
			COMPANY_INSTRUMENT_MAPPING 
		WHERE MIT_ID = @MIT_ID	

		SELECT TOP 1
			 @FORM_TYPE =MCC.CODE_NAME
			 --,PM.PayModeName,RP.DYNAMIC_FORM_DISPLAY_NAME
		FROM
			 ResidentialPaymentMode RP INNER JOIN PaymentMaster PM ON RP.PaymentMaster_Id=PM.Id AND RP.MIT_ID=@MIT_ID AND PM.Id=@PaymentMode_ID
			 INNER JOIN MST_COM_CODE MCC ON MCC_ID=RP.DYNAMIC_FORM AND RP.MIT_ID=@MIT_ID 
		WHERE MIT_ID=@MIT_ID AND PM.Id=@PaymentMode_ID AND RP.PAYMENT_MODE_CONFIG_TYPE=@Type
	

		--SELECT ISNULL(IS_UPLOAD_EXERCISE_FORM,0) AS IS_UPLOAD_EXERCISE_FORM,FORMAT(IS_UPLOAD_EXERCISE_FORM_ON, 'dd-MMM-yyyy '+@format+' hh:mm tt', 'en-US') AS IS_UPLOAD_EXERCISE_FORM_ON,ISNULL(isFormGenerate,0) AS isFormGenerate FROM ShExercisedOptions WHERE ExerciseId = @ExerciseNo

	 
	RETURN @FORM_TYPE
END
GO
