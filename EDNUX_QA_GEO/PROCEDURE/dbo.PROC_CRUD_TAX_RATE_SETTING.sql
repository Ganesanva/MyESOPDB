/****** Object:  StoredProcedure [dbo].[PROC_CRUD_TAX_RATE_SETTING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_TAX_RATE_SETTING]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_TAX_RATE_SETTING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_TAX_RATE_SETTING]
(	 
	@TRSC_ID					BIGINT =Null,
	@Tax_Head_Id				INT =NULL, 
	@MIT_ID						INT =Null,
	@TAXRATE_LIVE_EMPLOYEE		DECIMAL(18,6) =Null,
	@TAXRATE_SEPRATED_EMPLOYEE	DECIMAL(18,6) =Null,
	@RESIDENTIAL_ID				BIGINT=NULL,
	@COUNTRY_ID					BIGINT =Null,
	@CREATED_BY					NVARCHAR(50)=Null,
	@ACTION						NVARCHAR(50),
	@STATE_ID					BIGINT = Null,
	@EMPLOYEE_ID			    NVARCHAR(250)= NULL
	
 )
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TextHead VARCHAR(10)
	DECLARE @SqlQuery VARCHAR(1000)
	DECLARE @IS_TAXRATEAPPLICABLE INT 
	DECLARE @Count INT
	SET @Count = 0
	IF (@Tax_Head_Id=0)
	   SET @IS_TAXRATEAPPLICABLE =0

   	IF (@Tax_Head_Id!=0)
	   SET @IS_TAXRATEAPPLICABLE =1
	   
	   
	SET @TextHead='NA'
	
	BEGIN TRY		
	--	BEGIN TRANSACTION
 		IF(@Residential_ID =0 AND @Country_ID =0)
		BEGIN 
			SET @Residential_ID=NULL
			SET @Country_ID=NULL
			SELECT @count=count(Tax_Head_Id) FROM TAX_RATE_SETTING_CONFIG WHERE ((Tax_Head_Id) = (@Tax_Head_Id) and (Tax_Head_Id)>'0') AND (isnull( RESIDENTIAL_ID,0)=isnull(@Residential_ID,0)) AND (isnull(COUNTRY_ID,0) = isnull(@Country_ID,0)) AND MIT_ID = @MIT_ID AND TAX_RATE_STATUS_DETAILS = 1
	    END 
	    
		IF(@Country_ID =0 AND @Residential_ID >0)
		BEGIN 
			SET @Country_ID=NULL
			SELECT @count=count(Tax_Head_Id) FROM TAX_RATE_SETTING_CONFIG WHERE ((Tax_Head_Id) = (@Tax_Head_Id) and (Tax_Head_Id)>'0') AND (RESIDENTIAL_ID = @Residential_ID ) AND MIT_ID = @MIT_ID AND TAX_RATE_STATUS_DETAILS = 1
		END	
	
		IF(@Residential_ID =0 AND @Country_ID >0)
		BEGIN 
			SET @Residential_ID=NULL			
			SELECT @count=count(Tax_Head_Id) FROM TAX_RATE_SETTING_CONFIG WHERE ((Tax_Head_Id) = (@Tax_Head_Id) and (Tax_Head_Id)>'0') AND (COUNTRY_ID = @Country_ID) AND MIT_ID = @MIT_ID AND TAX_RATE_STATUS_DETAILS = 1
	    END 	
		
				
		IF(UPPER(@ACTION)='ADD')
		BEGIN		
		   --	IF NOT EXISTS(SELECT Tax_Head_Id FROM TAX_RATE_SETTING_CONFIG WHERE ((Tax_Head_Id) = (@Tax_Head_Id) and (Tax_Head_Id)>'0'))
		        IF (@Count=0)
				BEGIN
				
					IF (@IS_TAXRATEAPPLICABLE = 0 AND @RESIDENTIAL_ID IS NOT NULL)
  					BEGIN 					
						UPDATE TAX_RATE_SETTING_CONFIG SET TAX_RATE_STATUS_DETAILS = 0 WHERE MIT_ID = @MIT_ID AND RESIDENTIAL_ID = @RESIDENTIAL_ID
					END 
					
					IF (@IS_TAXRATEAPPLICABLE = 0 AND @COUNTRY_ID IS NOT NULL)
  					BEGIN 					
						UPDATE TAX_RATE_SETTING_CONFIG SET TAX_RATE_STATUS_DETAILS = 0 WHERE MIT_ID = @MIT_ID AND COUNTRY_ID = @COUNTRY_ID
					END
					
            		IF (@IS_TAXRATEAPPLICABLE = 1 AND @RESIDENTIAL_ID IS NOT NULL)
  					BEGIN 					
						UPDATE TAX_RATE_SETTING_CONFIG SET TAX_RATE_STATUS_DETAILS = 0 WHERE MIT_ID = @MIT_ID AND RESIDENTIAL_ID = @RESIDENTIAL_ID AND Tax_Head_Id = 0
					END 
					
					IF (@IS_TAXRATEAPPLICABLE = 1 AND @COUNTRY_ID IS NOT NULL)
  					BEGIN 					
						UPDATE TAX_RATE_SETTING_CONFIG SET TAX_RATE_STATUS_DETAILS = 0 WHERE MIT_ID = @MIT_ID AND COUNTRY_ID = @COUNTRY_ID AND Tax_Head_Id = 0
					END

					INSERT INTO TAX_RATE_SETTING_CONFIG 
						( MIT_ID,TAX_HEADING,Tax_Head_Id,IS_TAXRATEAPPLICABLE,RESIDENTIAL_ID,COUNTRY_ID,IS_ACTIVE,STATE_ID, CREATED_BY,CREATED_ON,UPDATED_BY, UPDATED_ON,TAX_RATE_STATUS_DETAILS)		
					VALUES
						(@MIT_ID,@TextHead,@Tax_Head_Id,@IS_TAXRATEAPPLICABLE,@RESIDENTIAL_ID,@COUNTRY_ID,0,@STATE_ID,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE(),1)
						
								
						INSERT INTO TAX_RATE_EMP_MAP (
						TRSC_ID,EMPLOYEE_ID,TAXRATE_LIVE_EMPLOYEE,TAXRATE_SEPRATED_EMPLOYEE,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON)
	                    VALUES(SCOPE_IDENTITY(),@EMPLOYEE_ID,@TAXRATE_LIVE_EMPLOYEE,@TAXRATE_SEPRATED_EMPLOYEE,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE() )
			
					IF(@@ROWCOUNT > 0)
						BEGIN						
							SELECT @@IDENTITY AS TRSC_ID ,'Record Inserted Successfully.'	AS Msg		
						
						END
					ELSE
						BEGIN				
						SELECT '0' AS TRSC_ID ,'Record insertion failed'	AS Msg				
					END
				END
			ELSE
				BEGIN
			   		SELECT '0' AS TRSC_ID ,'Tax Heading already exist.'	AS Msg	
				END		
		END
		ELSE IF(UPPER(@ACTION)='UPDATE')
		BEGIN		
             UPDATE TAX_RATE_SETTING_CONFIG 
			 SET  RESIDENTIAL_ID=@RESIDENTIAL_ID, COUNTRY_ID=@COUNTRY_ID
			 WHERE TAX_RATE_SETTING_CONFIG.TRSC_ID=@TRSC_ID	
			

			 UPDATE TAX_RATE_EMP_MAP 
			 SET TAXRATE_LIVE_EMPLOYEE = @TAXRATE_LIVE_EMPLOYEE, TAXRATE_SEPRATED_EMPLOYEE=@TAXRATE_SEPRATED_EMPLOYEE,
			UPDATED_BY=@CREATED_BY,UPDATED_ON=GETDATE()
			 WHERE TAX_RATE_EMP_MAP.TRSC_ID=@TRSC_ID	
											
			IF(@@ROWCOUNT > 0)
			BEGIN		
				SELECT @TRSC_ID AS TRSC_ID ,'Record Updated Successfully.'	AS Msg								
			END				
		END
		ELSE IF(UPPER(@ACTION)='GET')
		BEGIN
			IF(@RESIDENTIAL_ID IS NULL AND @COUNTRY_ID IS NULL)
			BEGIN	
		
				SELECT 
					TRSC.TRSC_ID,MTRT.TAX_HEADING,TRM.TAXRATE_LIVE_EMPLOYEE,TRM.TAXRATE_SEPRATED_EMPLOYEE,TRSC.RESIDENTIAL_ID,TRSC.COUNTRY_ID,'''' As STATUS
				FROM 
					TAX_RATE_SETTING_CONFIG TRSC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT ON TRSC.MIT_ID=MIT.MIT_ID
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TRSC.TRSC_ID=TRM.TRSC_ID   
					INNER JOIN MST_TAX_RATE_TITLE MTRT ON TRSC.Tax_Head_Id=MTRT.MTH_ID 
				WHERE 
					TRSC.MIT_ID=@MIT_ID  AND ISNULL(TRSC.RESIDENTIAL_ID ,0)=0 AND ISNULL(TRSC.COUNTRY_ID,0)=0 AND ISNULL(TRM.Employee_ID,'')=''

			END
			ELSE IF(@RESIDENTIAL_ID > 0  AND @COUNTRY_ID IS NULL)
			BEGIN					
				SELECT 
					TRSC.TRSC_ID,CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' ELSE MTRT.TAX_HEADING END AS TAX_HEADING,RT.[Description] As STATUS ,CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' 
					ELSE CAST (CONVERT(DECIMAL(18,6),TRM.TAXRATE_LIVE_EMPLOYEE) AS VARCHAR(10))  END AS TAXRATE_LIVE_EMPLOYEE,CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' 
					ELSE CAST (CONVERT(DECIMAL(18,6),TRM.TAXRATE_SEPRATED_EMPLOYEE) AS VARCHAR(10))  END AS TAXRATE_SEPRATED_EMPLOYEE,RESIDENTIAL_ID,COUNTRY_ID
				FROM 
					TAX_RATE_SETTING_CONFIG TRSC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT ON TRSC.MIT_ID=MIT.MIT_ID
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TRSC.TRSC_ID=TRM.TRSC_ID   
					INNER JOIN ResidentialType RT ON TRSC.RESIDENTIAL_ID= RT.ID
					LEFT JOIN MST_TAX_RATE_TITLE MTRT ON TRSC.Tax_Head_Id=MTRT.MTH_ID 
				WHERE TRSC.MIT_ID=@MIT_ID  AND ISNULL(TRSC.COUNTRY_ID,0)=0 AND TRSC.TAX_RATE_STATUS_DETAILS = 1 AND ISNULL(TRM.Employee_ID,'')=''

			END
			ELSE IF(@RESIDENTIAL_ID IS NULL AND @COUNTRY_ID > 0)
			BEGIN							
				SELECT 
					TRSC.TRSC_ID, CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' ELSE MTRT.TAX_HEADING END AS TAX_HEADING,CM.[CountryName] As Status ,CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' 
					ELSE CAST (CONVERT(DECIMAL(18,6),TRM.TAXRATE_LIVE_EMPLOYEE) AS VARCHAR(10))  END AS TAXRATE_LIVE_EMPLOYEE,CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' 
					ELSE CAST (CONVERT(DECIMAL(18,6),TRM.TAXRATE_SEPRATED_EMPLOYEE) AS VARCHAR(10))  END AS TAXRATE_SEPRATED_EMPLOYEE,RESIDENTIAL_ID,COUNTRY_ID
				    FROM TAX_RATE_SETTING_CONFIG TRSC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT ON TRSC.MIT_ID=MIT.MIT_ID
					INNER JOIN TAX_RATE_EMP_MAP TRM ON TRSC.TRSC_ID=TRM.TRSC_ID  
					INNER JOIN CountryMaster CM ON TRSC.COUNTRY_ID= CM.ID
					LEFT JOIN MST_TAX_RATE_TITLE MTRT ON TRSC.Tax_Head_Id=MTRT.MTH_ID 
				WHERE TRSC.MIT_ID=@MIT_ID  AND ISNULL(TRSC.RESIDENTIAL_ID,0)=0 AND TRSC.TAX_RATE_STATUS_DETAILS = 1 AND ISNULL(TRM.Employee_ID,'')=''
			END
												
		END
		ELSE IF(UPPER(@ACTION)='READ')
		BEGIN
			SELECT 
				TRSC.TRSC_ID, CASE WHEN TRSC.IS_TAXRATEAPPLICABLE =0 THEN 'NA' ELSE MTRT.TAX_HEADING END AS TAX_HEADING, TRM.TAXRATE_LIVE_EMPLOYEE,TRM.TAXRATE_SEPRATED_EMPLOYEE,TRSC.RESIDENTIAL_ID,TRSC.COUNTRY_ID
			FROM 
				TAX_RATE_SETTING_CONFIG TRSC  
				INNER JOIN TAX_RATE_EMP_MAP TRM ON TRSC.TRSC_ID=TRM.TRSC_ID  
				INNER JOIN 	MST_TAX_RATE_TITLE MTRT ON TRSC.Tax_Head_Id=MTRT.MTH_ID 
			WHERE	
				TRSC.TRSC_ID=@TRSC_ID 				
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
