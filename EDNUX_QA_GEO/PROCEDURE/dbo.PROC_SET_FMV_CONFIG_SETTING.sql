/****** Object:  StoredProcedure [dbo].[PROC_SET_FMV_CONFIG_SETTING]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SET_FMV_CONFIG_SETTING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SET_FMV_CONFIG_SETTING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_SET_FMV_CONFIG_SETTING]
	(	 
		
		@MIT_ID					INT ,
		@EXCEPT_FOR_FMV_VAL		TINYINT=NULL,
		@EXCEPT_FOR_FMV	NVARCHAR(10)=NULL,
		@TYPE_SET_COMPANY_EXCEPTIONS TYPE_SET_COMPANY_EXCEPTIONS READONLY,
		@CREATED_BY				NVARCHAR(50)=Null		
		
		
	 )
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY		
	--	BEGIN TRANSACTION
		
						UPDATE COMPANY_INSTRUMENT_MAPPING
						SET EXCEPT_FOR_FMV_VAL=@EXCEPT_FOR_FMV_VAL ,EXCEPT_FOR_FMV=@EXCEPT_FOR_FMV
						WHERE MIT_ID =@MIT_ID						
						
						IF(@@ROWCOUNT >0)
						BEGIN
								IF(ISNULL(@EXCEPT_FOR_FMV,'')!='')
								BEGIN
								
											
										--Resident
										DECLARE @CIM_ID BIGINT
										DECLARE  @MIN INT
										DECLARE  @MAX INT
										DECLARE @ACTIVE TINYINT 
										Select  @CIM_ID=CIM.CIM_ID From COMPANY_INSTRUMENT_MAPPING CIM Where CIM.MIT_ID=@MIT_ID
										SELECT @MIN=MIN(ID) FROM @TYPE_SET_COMPANY_EXCEPTIONS
										SELECT @MAX=MAX(ID) FROM @TYPE_SET_COMPANY_EXCEPTIONS
										IF(UPPER(@EXCEPT_FOR_FMV)='R')
										BEGIN
											
											UPDATE COMPANY_INSTRUMENT_MAP_DETAILS
											SET  ACTIVE=0
											FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
											ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' AND CIM.MIT_ID=@MIT_ID
											WHERE CIM.MIT_ID=@MIT_ID AND CIMD.RESIDENTIAL_ID > 0  
											
											WHILE(@MIN<=@MAX)
											BEGIN
														DECLARE @RESIDENTIAL_ID BIGINT 											
														SELECT @RESIDENTIAL_ID=RESIDENTIAL_ID FROM @TYPE_SET_COMPANY_EXCEPTIONS WHERE ID= @MIN	
														SELECT @ACTIVE=ACTIVE FROM @TYPE_SET_COMPANY_EXCEPTIONS WHERE ID= @MIN							
														IF EXISTS(SELECT CIMD.CIMD_ID FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
														ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' WHERE CIM.MIT_ID=@MIT_ID And ISNULL(RESIDENTIAL_ID,0)=ISNULL(@RESIDENTIAL_ID,0) AND ISNULL(CIMD.CIM_ID,0)=ISNULL(@CIM_ID,0)  )
														BEGIN
																UPDATE COMPANY_INSTRUMENT_MAP_DETAILS
																SET RESIDENTIAL_ID =@RESIDENTIAL_ID,COUNTRY_ID=NULL, ACTIVE=@ACTIVE
																FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
																ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' AND CIM.MIT_ID=@MIT_ID
																WHERE CIM.MIT_ID=@MIT_ID AND CIMD.RESIDENTIAL_ID=@RESIDENTIAL_ID
														END
														ELSE
														BEGIN
														
															INSERT INTO COMPANY_INSTRUMENT_MAP_DETAILS (CIM_ID,RESIDENTIAL_ID,COUNTRY_ID,SETTING_TYPE,ACTIVE,CREATED_BY,CREATED_ON,UPDATED_BY, UPDATED_ON)
															VALUES(@CIM_ID,@RESIDENTIAL_ID,0,'FMV',@ACTIVE,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE())
															
														END
											
											SET @MIN=@MIN+1
											
											END
										END
										ELSE IF(UPPER(@EXCEPT_FOR_FMV)='C')
										BEGIN
										Print @EXCEPT_FOR_FMV
												UPDATE COMPANY_INSTRUMENT_MAP_DETAILS
												SET  ACTIVE=0
												FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
												ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' AND CIM.MIT_ID=@MIT_ID
												WHERE CIM.MIT_ID=@MIT_ID AND CIMD.COUNTRY_ID > 0
												
												WHILE(@MIN<=@MAX)
												BEGIN
												
												--Country
															DECLARE @COUNTRY_ID BIGINT 
															SELECT @COUNTRY_ID=COUNTRY_ID FROM @TYPE_SET_COMPANY_EXCEPTIONS WHERE ID= @MIN	
															SELECT @ACTIVE=ACTIVE FROM @TYPE_SET_COMPANY_EXCEPTIONS WHERE ID= @MIN							
															Print @EXCEPT_FOR_FMV
															print @COUNTRY_ID
															print @CIM_ID
															IF EXISTS(SELECT CIMD.CIMD_ID FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
															ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' WHERE CIM.MIT_ID=@MIT_ID AND ISNULL(COUNTRY_ID,0)=ISNULL(@COUNTRY_ID,0)  AND  ISNULL(CIMD.CIM_ID,0)=ISNULL(@CIM_ID ,0) )
															BEGIN
																	UPDATE COMPANY_INSTRUMENT_MAP_DETAILS
																	SET RESIDENTIAL_ID =@RESIDENTIAL_ID,COUNTRY_ID=@COUNTRY_ID, ACTIVE=@ACTIVE
																	FROM COMPANY_INSTRUMENT_MAPPING CIM INNER JOIN COMPANY_INSTRUMENT_MAP_DETAILS CIMD 
																	ON CIM.CIM_ID= CIMD.CIM_ID AND CIMD.SETTING_TYPE='FMV' AND CIM.MIT_ID=@MIT_ID
																	WHERE CIM.MIT_ID=@MIT_ID AND CIMD.COUNTRY_ID=@COUNTRY_ID
															END
															ELSE
															BEGIN
															
																INSERT INTO COMPANY_INSTRUMENT_MAP_DETAILS (CIM_ID,RESIDENTIAL_ID,COUNTRY_ID,SETTING_TYPE,ACTIVE,CREATED_BY,CREATED_ON,UPDATED_BY, UPDATED_ON)
																VALUES(@CIM_ID,0,@COUNTRY_ID,'FMV',@ACTIVE,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE())
																
															END
												
												SET @MIN=@MIN+1
												
												END
										
										END
										SELECT @MIT_ID AS MIT_ID ,'Record Inserted Successfully.'	AS Msg
										
								END
						
						END
						Else
						BEGIN
							SELECT '0' AS MIT_ID ,'Record Insertion Failed.'	AS Msg
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
