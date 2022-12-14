/****** Object:  StoredProcedure [dbo].[PROC_SET_TAXRATE_CONFIG_SETTING]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SET_TAXRATE_CONFIG_SETTING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SET_TAXRATE_CONFIG_SETTING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SET_TAXRATE_CONFIG_SETTING]
	(	 
		
		@MIT_ID					INT ,
		@EXCEPT_FOR_TAXRATE_VAL		TINYINT=NULL,
		@EXCEPT_FOR_TAXRATE	NVARCHAR(10)=NULL,
		@TYPE_SET_TAXRATE_EXCEPTIONS TYPE_SET_TAXRATE_EXCEPTIONS READONLY,
		@CREATED_BY				NVARCHAR(50)=Null		
		
		
	 )
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY		
	--	BEGIN TRANSACTION
		
						UPDATE COMPANY_INSTRUMENT_MAPPING
						SET EXCEPT_FOR_TAXRATE_VAL=@EXCEPT_FOR_TAXRATE_VAL ,EXCEPT_FOR_TAXRATE=@EXCEPT_FOR_TAXRATE
						WHERE MIT_ID =@MIT_ID							
						
						IF(@@ROWCOUNT >0)
						BEGIN															
						
								IF(@EXCEPT_FOR_TAXRATE_VAL =1)
								BEGIN										
										-- Exception Level
										UPDATE COMPANY_INSTRUMENT_MAPPING
										SET IS_TAXRATEEXCEPTION_ACTIVE =0	
																				
										UPDATE COMPANY_INSTRUMENT_MAPPING
										SET IS_TAXRATEEXCEPTION_ACTIVE =TSTE.ACTIVE
										FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN @TYPE_SET_TAXRATE_EXCEPTIONS TSTE
										ON CIM.MIT_ID= TSTE.MIT_ID										
										--IS_TAXRATEEXCEPTION_ACTIVE
								
								END
								ELSE
								BEGIN
										-- Company Level
										UPDATE COMPANY_INSTRUMENT_MAPPING
										SET IS_TAXRATE_ACTIVE =0	
										
										print 'company level '										
										
										UPDATE COMPANY_INSTRUMENT_MAPPING
										SET IS_TAXRATE_ACTIVE =1
										WHERE MIT_ID in (SELECT MIT_ID FROM @TYPE_SET_TAXRATE_EXCEPTIONS)
										
										--FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN @TYPE_SET_TAXRATE_EXCEPTIONS TSTE
										--ON CIM.MIT_ID= TSTE.MIT_ID
										
										print 'company level activate '
																					
								END															
								SELECT @MIT_ID AS MIT_ID ,'Record updated successfully.'	AS Msg
						
						END
						Else
						BEGIN
							SELECT '0' AS MIT_ID ,'Record update failed.'	AS Msg
						END
		
				
	--	COMMIT TRANSACTION	
	END TRY
	BEGIN CATCH
	--	ROLLBACK TRANSACTION
		RETURN 0
	END CATCH

	SET NOCOUNT OFF;
END
GO
