/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PERQ_VALUE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_PERQ_VALUE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PERQ_VALUE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[PROC_CRUD_PERQ_VALUE]
(	 
	@PFC_ID					BIGINT = NULL,
	@FORMULA_NAME			VARCHAR(250) = NULL, 
	@MIT_ID					INT = NULL,
	@ISPERQUISITE_VALUE		TINYINT = NULL,
	@EVENT_OF_INCIDENCE_ID	BIGINT = NULL,
	@FORMULA_DESCRIPTION	NVARCHAR(500),
	@RESIDENTIAL_ID			BIGINT = NULL,
	@COUNTRY_ID				BIGINT = NULL,
	@APPLICABLE_FROM_DATE	DATETIME = NULL,	
	@ISPROPORTINATE_VALUE	TINYINT = NULL,
	@CREATED_BY				NVARCHAR(50) = NULL,
	@ACTION					NVARCHAR(50)			
 )
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY			
		IF(@Residential_ID = 0)
			SET @Residential_ID = NULL
	
		IF(@Country_ID = 0)
			SET @Country_ID = NULL
		
		DECLARE @APPLICABLE_TO_DATE DATETIME 
		SET @APPLICABLE_TO_DATE = NULL

		DECLARE @PFCID INT = 0
		DECLARE	@LOCKINGDATE DATETIME
		IF(UPPER(@ACTION) = 'ADD')
		BEGIN		
			SELECT @PFCID = PFC_ID,@LOCKINGDATE=APPLICABLE_FROM_DATE FROM PERQUISITE_FORMULA_CONFIG PFC WHERE PFC.Country_ID = ISNULL(@Country_ID,0) AND PFC.Residential_ID = ISNULL(@Residential_ID,0) ORDER BY PFC_ID DESC
								SELECT @LOCKINGDATE= Calc_PerqDt_From FROM CompanyParameters
						
			
							IF NOT EXISTS(SELECT PFC_ID FROM PERQUISITE_FORMULA_CONFIG PFC WHERE UPPER(FORMULA_NAME) = UPPER(@FORMULA_NAME))
								BEGIN
									INSERT INTO PERQUISITE_FORMULA_CONFIG (FORMULA_NAME,MIT_ID,ISPERQUISITE_VALUE,APPLICABLE_FROM_DATE,APPLICABLE_TO_DATE,EVENT_OF_INCIDENCE_ID,Residential_ID,Country_ID,FORMULA_DESCRIPTION, CREATED_BY,CREATED_ON,UPDATED_BY, UPDATED_ON)		
									VALUES(@FORMULA_NAME,@MIT_ID,@ISPERQUISITE_VALUE,@APPLICABLE_FROM_DATE,@APPLICABLE_TO_DATE,@EVENT_OF_INCIDENCE_ID,@Residential_ID,@Country_ID,@FORMULA_DESCRIPTION,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE())
									
									IF(@@ROWCOUNT > 0)
										BEGIN												
											SELECT @@IDENTITY AS PFC_ID, 'Record inserted successfully.'	AS Msg	
											UPDATE PERQUISITE_FORMULA_CONFIG SET APPLICABLE_TO_DATE = DATEADD(DAY,-1,@APPLICABLE_FROM_DATE) WHERE PFC_ID = @PFCID
										END
									Else
										BEGIN				
											SELECT '0' AS PFC_ID ,'Record insertion failed'	AS Msg					
										END
								END
							ELSE
								BEGIN
									SELECT '0' AS PFC_ID ,'Formula Alias name already exist.'	AS Msg
								END		
	
		END
		ELSE IF(UPPER(@ACTION)='UPDATE')
		BEGIN		
			-- UPDATE BASED ON @APPLICABLE_FROM_DATE
			DECLARE @ApplicableFrom_Date DATETIME
			SELECT TOP(1) @PFC_ID=PFC_ID, @ApplicableFrom_Date=APPLICABLE_FROM_DATE,@LOCKINGDATE = APPLICABLE_FROM_DATE FROM PERQUISITE_FORMULA_CONFIG WHERE  ISNull(COUNTRY_ID,0) = ISNULL(@Country_ID,0) And ISNull(Residential_ID,0)=ISNULL(@Residential_ID,0) AND MIT_ID=@MIT_ID ORDER BY PFC_ID DESC
			
			IF(@ApplicableFrom_Date = @APPLICABLE_FROM_DATE)
				BEGIN				
					UPDATE PERQUISITE_FORMULA_CONFIG 
					SET FORMULA_NAME=@FORMULA_NAME, MIT_ID=@MIT_ID,ISPERQUISITE_VALUE=@ISPERQUISITE_VALUE,EVENT_OF_INCIDENCE_ID=@EVENT_OF_INCIDENCE_ID,Residential_ID= ISNull(@Residential_ID,0),Country_ID=ISNull(@Country_ID,0),FORMULA_DESCRIPTION=@FORMULA_DESCRIPTION
					WHERE  PERQUISITE_FORMULA_CONFIG.PFC_ID=@PFC_ID							
					
								
				END
			ELSE
				BEGIN
					IF(@APPLICABLE_FROM_DATE >= @LOCKINGDATE  )
					BEGIN
						IF NOT EXISTS(SELECT PFC_ID FROM PERQUISITE_FORMULA_CONFIG PFC WHERE UPPER(FORMULA_NAME)=UPPER(@FORMULA_NAME) )
						BEGIN
							
							SET	@PFCID = @PFC_ID					
							INSERT INTO PERQUISITE_FORMULA_CONFIG (FORMULA_NAME,MIT_ID,ISPERQUISITE_VALUE,APPLICABLE_FROM_DATE,APPLICABLE_TO_DATE,EVENT_OF_INCIDENCE_ID,Residential_ID,Country_ID,FORMULA_DESCRIPTION, CREATED_BY,CREATED_ON,UPDATED_BY, UPDATED_ON)		
							VALUES(@FORMULA_NAME,@MIT_ID,@ISPERQUISITE_VALUE,@APPLICABLE_FROM_DATE,@APPLICABLE_TO_DATE,@EVENT_OF_INCIDENCE_ID,@Residential_ID,@Country_ID,@FORMULA_DESCRIPTION,@CREATED_BY,GETDATE(),@CREATED_BY,GETDATE())
							
							SET @PFC_ID=@@IDENTITY						
							IF(@@ROWCOUNT > 0)
								BEGIN	
									SELECT @PFC_ID AS PFC_ID, 'Record inserted successfully.'	AS Msg		
									UPDATE PERQUISITE_FORMULA_CONFIG SET APPLICABLE_TO_DATE = DATEADD(DAY,-1,@APPLICABLE_FROM_DATE) WHERE PFC_ID = @PFCID												
								END	
							ELSE
								BEGIN				
									SELECT '0' AS PFC_ID, 'Record insertion failed'	AS Msg						
								END														 
						END
						ELSE
						BEGIN
							SELECT '0' AS PFC_ID ,'Formula Alies name already exist.'	AS Msg
						END
						
					END
					ELSE
					BEGIN
						SELECT '0' AS PFC_ID ,'Applicable From date should be greater than '+REPLACE(CONVERT(VARCHAR, @LOCKINGDATE,106),' ','/') AS Msg	
					END
					
				END	
				
				IF(@@ROWCOUNT > 0)
				BEGIN	
					SELECT @PFC_ID AS PFC_ID, 'Record updated successfully.'	AS Msg														
				END
				ELSE
				BEGIN				
					SELECT '0' AS PFC_ID, 'Record update failed'	AS Msg					
				END						
						
		END
		ELSE IF(UPPER(@ACTION)='GET')
		BEGIN
			IF(@Residential_ID >0)
				BEGIN				
					SELECT 
						PFC.PFC_ID, FORMULA_NAME, Replace(PFC.FORMULA_DESCRIPTION,'@','') AS FORMULA_DESCRIPTION ,MIT.INSTRUMENT_NAME,PFC.MIT_ID,PFC.EVENT_OF_INCIDENCE_ID,EOFINCIDENCE.CODE_NAME AS EVENTOFINCIDENCE,
						CONVERT(VARCHAR, APPLICABLE_FROM_DATE,106) AS  APPLICABLE_FROM_DATE,CONVERT(VARCHAR, APPLICABLE_TO_DATE,106) AS APPLICABLE_TO_DATE
					FROM PERQUISITE_FORMULA_CONFIG PFC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT ON PFC.MIT_ID=MIT.MIT_ID
					INNER JOIN MST_COM_CODE EOFINCIDENCE ON EOFINCIDENCE.MCC_ID=  PFC.EVENT_OF_INCIDENCE_ID
					WHERE PFC.MIT_ID=@MIT_ID AND ISNULL( PFC.Country_ID,0) = 0 AND PFC.Residential_ID=@Residential_ID	
					ORDER BY PFC.PFC_ID DESC		
				END
			ELSE IF(@Country_ID >0)
				BEGIN								
					SELECT 
						PFC.PFC_ID, FORMULA_NAME, Replace(PFC.FORMULA_DESCRIPTION,'@','') AS FORMULA_DESCRIPTION,MIT.INSTRUMENT_NAME,PFC.MIT_ID,PFC.EVENT_OF_INCIDENCE_ID,EOFINCIDENCE.CODE_NAME AS EVENTOFINCIDENCE,
						CONVERT(VARCHAR, APPLICABLE_FROM_DATE,106) AS  APPLICABLE_FROM_DATE,CONVERT(VARCHAR, APPLICABLE_TO_DATE,106) AS APPLICABLE_TO_DATE
					FROM PERQUISITE_FORMULA_CONFIG PFC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT ON PFC.MIT_ID = MIT.MIT_ID
					INNER JOIN MST_COM_CODE EOFINCIDENCE ON EOFINCIDENCE.MCC_ID = PFC.EVENT_OF_INCIDENCE_ID
					WHERE PFC.MIT_ID=@MIT_ID AND ISNULL( PFC.Residential_ID,0) =0 AND PFC.Country_ID=@Country_ID	
					ORDER BY PFC.PFC_ID DESC		
				END
			ELSE 
				BEGIN			
					SELECT 
						PFC.PFC_ID, FORMULA_NAME, Replace(PFC.FORMULA_DESCRIPTION,'@','') AS FORMULA_DESCRIPTION,MIT.INSTRUMENT_NAME,PFC.MIT_ID,PFC.EVENT_OF_INCIDENCE_ID,EOFINCIDENCE.CODE_NAME AS EVENTOFINCIDENCE,
						CONVERT(VARCHAR, APPLICABLE_FROM_DATE,106) AS  APPLICABLE_FROM_DATE,CONVERT(VARCHAR, APPLICABLE_TO_DATE,106) AS APPLICABLE_TO_DATE
					FROM PERQUISITE_FORMULA_CONFIG PFC	
					INNER JOIN MST_INSTRUMENT_TYPE MIT On PFC.MIT_ID = MIT.MIT_ID
					INNER JOIN MST_COM_CODE EOFINCIDENCE ON EOFINCIDENCE.MCC_ID = PFC.EVENT_OF_INCIDENCE_ID
					WHERE PFC.MIT_ID=@MIT_ID AND ISNULL( PFC.Residential_ID,0) =0 AND ISNULL(PFC.Country_ID,0)=0
					ORDER BY PFC.PFC_ID DESC
				END				
		END
		ELSE IF(UPPER(@ACTION)='READ')
		BEGIN
		IF(@PFC_ID >0)
		BEGIN
			SELECT 
				PFC.PFC_ID, FORMULA_NAME, FORMULA_DESCRIPTION ,REPLACE(FORMULA_DESCRIPTION,'@','') As FORMULA ,PFC.MIT_ID,PFC.EVENT_OF_INCIDENCE_ID,REPLACE(CONVERT(VARCHAR, APPLICABLE_FROM_DATE,106),' ','/') As APPLICABLE_FROM_DATE,APPLICABLE_TO_DATE
			FROM PERQUISITE_FORMULA_CONFIG PFC	
			--WHERE ISNULL(PFC.COUNTRY_ID,0) = ISNULL(@Country_ID,0) And ISNULL(PFC.RESIDENTIAL_ID,0)=ISNULL(@Residential_ID,0) AND MIT_ID=@MIT_ID	
			WHERE PFC.PFC_ID=@PFC_ID
			ORDER BY PFC_ID DESC	
		
		END
		ELSE
		BEGIN
			SELECT 
				PFC.PFC_ID, FORMULA_NAME, FORMULA_DESCRIPTION ,REPLACE(FORMULA_DESCRIPTION,'@','') As FORMULA ,PFC.MIT_ID,PFC.EVENT_OF_INCIDENCE_ID,REPLACE(CONVERT(VARCHAR, APPLICABLE_FROM_DATE,106),' ','/') As APPLICABLE_FROM_DATE,APPLICABLE_TO_DATE
			FROM PERQUISITE_FORMULA_CONFIG PFC	
			WHERE ISNULL(PFC.COUNTRY_ID,0) = ISNULL(@Country_ID,0) And ISNULL(PFC.RESIDENTIAL_ID,0)=ISNULL(@Residential_ID,0) And MIT_ID=@MIT_ID	
			ORDER BY PFC_ID DESC					
					
			SELECT Calc_PerqDt_From As LOCKINGDATE  FROM CompanyParameters	
		END
		END			
	END TRY
	BEGIN CATCH	
		RETURN 0
	END CATCH

	SET NOCOUNT OFF;

END
GO
