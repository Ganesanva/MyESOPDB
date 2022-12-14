/****** Object:  StoredProcedure [dbo].[PROC_UPDATEPAYMODE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATEPAYMODE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATEPAYMODE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATEPAYMODE]
	@IsEnable CHAR,
	@Description VARCHAR(100),
	@PayModeName VARCHAR(100)	
AS
BEGIN

	UPDATE 
		PAYMENTMASTER 
	SET 
		IsEnable = @IsEnable ,
		[Description] = @Description 
	WHERE 
		PayModeName = @PayModeName


	IF(@IsEnable = 'N')
	BEGIN	
			
		/*UNCHECK OR DELETE THE ROLE PRIVILEGES RECORD FOR CR PAYMENT GATEWAY TRANSACTION STATUS UPDATE IS UNCHECKED*/
		IF EXISTS (SELECT SM.* FROM RolePrivileges AS RP INNER JOIN ScreenActions AS SA ON RP.ScreenActionId = SA.ScreenActionId
				INNER JOIN ScreenMaster As SM ON SA.ScreenId = SM.ScreenId WHERE UPPER(SM.Name) = 'PAYMENT GATEWAY TRANSACTION STATUS UPDATE')
		BEGIN
				
			DELETE FROM 
				RolePrivileges 
			WHERE 
				ScreenActionId IN 
				(
					SELECT 
						DISTINCT SA.ScreenActionId 
					FROM 
						RolePrivileges AS RP 
						INNER JOIN ScreenActions AS SA ON RP.ScreenActionId= SA.ScreenActionId
						INNER JOIN ScreenMaster As SM ON SA.ScreenId= SM.ScreenId 
					WHERE 
						UPPER(SM.Name) = 'PAYMENT GATEWAY TRANSACTION STATUS UPDATE'
				)
		
		END

	END		
END

GO
