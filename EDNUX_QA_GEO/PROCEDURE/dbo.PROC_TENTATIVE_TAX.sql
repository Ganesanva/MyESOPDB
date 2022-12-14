/****** Object:  StoredProcedure [dbo].[PROC_TENTATIVE_TAX]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_TENTATIVE_TAX]
GO
/****** Object:  StoredProcedure [dbo].[PROC_TENTATIVE_TAX]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_TENTATIVE_TAX]
(
	 @MIT_ID				INT = NULL,
	 @EmployeeID			VARCHAR(20) = NULL,
     @FMV					NUMERIC(18, 6) =NULL,
	 @Total_Perk_Value		NUMERIC(18, 6) =NULL,	 
	 @EVENT_OF_INCIDENCE	INT	 =NULL,
	 @GRANT_DATE			DATETIME =NULL,
	 @VESTING_DATE			DATETIME =NULL,
	 @EXERCISE_DATE			DateTime =NULL
	 --@EMPLOYEE_DETAILS  dbo.TYPE_PERQ_VALUE READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	
    DECLARE @EXCEPT_FOR_TAXRATE_VAL INT
	DECLARE @EXCEPT_FOR_TAXRATE NVARCHAR(50)
	DECLARE @IS_TAXRATE_ACTIVE INT
	DECLARE @IS_TAXRATEEXCEPTION_ACTIVE INT
	DECLARE @TAX_IDENTIFIER_COUNTRY NVARCHAR(50)
	DECLARE @TAX_IDENTIFIER_STATE NVARCHAR(50)
	DECLARE @DateOfTermination NVARCHAR(50)
	
     SELECT @EXCEPT_FOR_TAXRATE= CM.EXCEPT_FOR_TAXRATE,@EXCEPT_FOR_TAXRATE_VAL= CM.EXCEPT_FOR_TAXRATE_VAL,
			@TAX_IDENTIFIER_COUNTRY=EM.TAX_IDENTIFIER_COUNTRY,@TAX_IDENTIFIER_STATE=EM.TAX_IDENTIFIER_STATE,
			@DateOfTermination=EM.DATEOFTERMINATION
     FROM COMPANY_INSTRUMENT_MAPPING CM CROSS JOIN EmployeeMaster EM WHERE CM.MIT_ID = @MIT_ID AND EM.EmployeeID = @EmployeeID 
     --Set @EXCEPT_FOR_TAXRATE_VAL=0
     
     IF(@EXCEPT_FOR_TAXRATE_VAL ='1')
       BEGIN      
       
         Print @EXCEPT_FOR_TAXRATE
			IF(@EXCEPT_FOR_TAXRATE='R')
			BEGIN		
				/*Print @EXCEPT_FOR_TAXRATE	*/
				Declare @ResidentStatus Nvarchar(10)
				SELECT @ResidentStatus=ResidentialStatus 
				FROM EmployeeMaster
				WHERE EmployeeID=@EmployeeID
				Print @ResidentStatus
				
				IF EXISTS( SELECT TR.TRSC_ID 
				FROM   TAX_RATE_SETTING_CONFIG TR 
				INNER Join  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
				INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID AND RT.ResidentialStatus=@ResidentStatus CROSS JOIN EMPLOYEEMASTER EM 
				WHERE       TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID
				AND TR.IS_TAXRATEAPPLICABLE=1  AND TAX_RATE_STATUS_DETAILS=1 )
				BEGIN
					-- Resident status
					IF(LEN(@DateOfTermination)>0)
				BEGIN
				SELECT   MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, RT.[Description] AS RESIDENT_STATUS,
						dbo.FN_PQ_TAX_ROUNDING((TAXRATE_LIVE_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
						EM.TAX_IDENTIFIER_COUNTRY AS Country, EM.TAX_IDENTIFIER_STATE AS [STATE],CM.EXCEPT_FOR_TAXRATE AS BASISOFTAXATION,
						dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
			  		  		
				FROM        TAX_RATE_SETTING_CONFIG TR 
				INNER Join  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id
				INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
				INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID AND RT.ResidentialStatus=@ResidentStatus CROSS JOIN EmployeeMaster EM 			          
				WHERE       TR.MIT_ID = @MIT_ID AND EM.EMPLOYEEID = @EmployeeID 
				AND TR.IS_TAXRATEAPPLICABLE=1 AND TAX_RATE_STATUS_DETAILS=1
				 
		      END		       
				ELSE
				BEGIN     
					SELECT   MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,RT.[Description] AS RESIDENT_STATUS,
								EM.TAX_IDENTIFIER_COUNTRY AS Country, EM.TAX_IDENTIFIER_STATE AS [STATE],
								dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
			  		  			CM.EXCEPT_FOR_TAXRATE AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
			  		  			dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
			  		  			
						FROM        TAX_RATE_SETTING_CONFIG TR 
						INNER Join  MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
						INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID AND RT.ResidentialStatus=@ResidentStatus CROSS JOIN EMPLOYEEMASTER EM 
						WHERE       TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID
						AND TR.IS_TAXRATEAPPLICABLE=1  AND TAX_RATE_STATUS_DETAILS=1
				END	
				
				END
				ELSE
				BEGIN
					-- company level status
					SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,'' AS RESIDENT_STATUS,
						'' AS Country, '' AS [STATE],dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
  						'Company Level' AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  			
						FROM    TAX_RATE_SETTING_CONFIG TR 
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
								INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id CROSS JOIN EMPLOYEEMASTER EM 
						WHERE   TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID	AND ISNULL(TR.RESIDENTIAL_ID,0) =0 AND ISNULL(TR.COUNTRY_ID,0)=0										
				
				
				END
				
				
				
			END	
			ELSE IF(@EXCEPT_FOR_TAXRATE='C')
			BEGIN
				--change by Amit
				-- Check for employee country
				-- Get country on event of incidence of perquisite value 	
				DECLARE @Country_ID NVARCHAR(50)
				DECLARE @Country_Name NVARCHAR(250)	
				DECLARE @EventOfIncidence NVARCHAR(50)	
				DECLARE @INCIDENCEDATE DATETIME
				
				SELECT @EventOfIncidence = CODE_NAME FROM MST_COM_CODE  WHERE MCC_ID = @Event_OF_INCIDENCE
				
        
				IF(@EventOfIncidence = 'Grant Date')    
					SET  @INCIDENCEDATE = @GRANT_DATE                 
				ELSE IF(@EventOfIncidence = 'Vesting Date')     
					SET  @INCIDENCEDATE = @VESTING_DATE    
				ELSE IF(@EventOfIncidence = 'Exercise Date')    
					SET  @INCIDENCEDATE = @EXERCISE_DATE
			
				
				/*PRINT @INCIDENCEDATE	
				PRINT @EventOfIncidence
				print @Event_OF_INCIDENCE
				print @INCIDENCEDATE	
				*/				
				
				--drop table #TempMobility_Tracking
				CREATE TABLE #TempMobility_Tracking
				(	ID BIGINT,
					Country NVARCHAR(250),
					FromDate datetime,
					Todate datetime
				)		
				
				INSERT INTO #TempMobility_Tracking(ID,Country,FromDate,Todate)
				EXEC PROC_GET_MOBILITY_DETAILS @EmployeeID, @INCIDENCEDATE,@INCIDENCEDATE
				
				--SELECT * FROM #TempMobility_Tracking			
				
				IF EXISTS(SELECT * FROM #TempMobility_Tracking)							
				--IF EXISTS(SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@EmployeeID AND UPPER(Field) =UPPER('Tax Identifier Country') AND  CONVERT(date,[From Date of Movement])=CONVERT(date,@INCIDENCEDATE))
				BEGIN
					/*Print 'tracking'*/
					Select @Country_ID=ID,@Country_Name=Country From #TempMobility_Tracking 
					SELECT @Country_ID=ID,@Country_Name=CountryName FROM CountryMaster
					WHERE CountryName in(SELECT top(1) [Moved To] FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD WHERE EmployeeId=@EmployeeID AND UPPER(Field) =UPPER('Tax Identifier Country') AND  CONVERT(date,[From Date of Movement])=CONVERT(date,@INCIDENCEDATE) ORDER BY SRNO DESC )		
					Print @Country_ID
				END
				ELSE
				BEGIN	
					/*Print 'No tracking'*/
					IF EXISTS(SELECT TAX_IDENTIFIER_COUNTRY FROM EmployeeMaster WHERE EmployeeId=@EmployeeID AND Len(TAX_IDENTIFIER_COUNTRY)>0 )
					BEGIN
						print 'tax country'
						SELECT @Country_ID=TAX_IDENTIFIER_COUNTRY  FROM EmployeeMaster WHERE EmployeeId=@EmployeeID		
						print @Country_ID
						 SELECT @Country_Name=CountryName From CountryMaster
						 Where ID=@Country_ID
						
					END	
					ELSE
					BEGIN
					print 'No tax country'
						SELECT @Country_ID=ID,@Country_Name=CountryName FROM CountryMaster
						WHERE CountryAliasName in(SELECT CountryName FROM EmployeeMaster WHERE EmployeeId=@EmployeeID )	
						/*print @Country_ID*/
					END	
						
				END
				--Select @Country_ID
				/*print @Country_ID*/
				IF(@Country_ID >0)
				BEGIN
				
				--Select TRSC_ID FRom TAX_RATE_SETTING_CONFIG WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID
				
				IF EXISTS(Select TRSC_ID FRom TAX_RATE_SETTING_CONFIG WHERE COUNTRY_ID=@Country_ID AND MIT_ID=@MIT_ID)
				BEGIN	
				/*Print ' tax found'*/
						-- Set For country level
					IF(LEN(ISNULL(@DateOfTermination,0))>0)
						BEGIN
						--Live				
						print '@DateOfTermination '
						SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, '' AS RESIDENT_STATUS,
								dbo.FN_PQ_TAX_ROUNDING((TAXRATE_LIVE_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
								@Country_Name AS Country, EM.TAX_IDENTIFIER_STATE AS [STATE],'Country Level' AS BASISOFTAXATION,
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  		
						FROM        TAX_RATE_SETTING_CONFIG TR 
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID 
						INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id
						INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID CROSS JOIN EmployeeMaster EM 			          
						WHERE       TR.MIT_ID = @MIT_ID AND EM.EMPLOYEEID = @EmployeeID AND CM.ID=@Country_ID
						 
					  END		       
						ELSE
						BEGIN 
						
								SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,'' AS RESIDENT_STATUS,
										@Country_Name AS Country, EM.TAX_IDENTIFIER_STATE AS [STATE],
										dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
		  		  						'Country Level' AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
		  		  						dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  			
								FROM        TAX_RATE_SETTING_CONFIG TR 
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CIM ON TR.MIT_ID=CIM.MIT_ID 
								INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID=TR.Tax_Head_Id
								INNER JOIN  COUNTRYMASTER CM ON CM.ID=TR.COUNTRY_ID CROSS JOIN EmployeeMaster EM  
								WHERE       TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID AND CM.ID=@Country_ID
								
	   					END
				
				END					
				ELSE
				BEGIN				
						/*print 'company level'	*/					
					IF(LEN(ISNULL(@DateOfTermination,0))>0)
					BEGIN
						SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, '' AS RESIDENT_STATUS,
								dbo.FN_PQ_TAX_ROUNDING((TAXRATE_LIVE_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
								'' AS Country, '' AS [STATE],'Company Level' AS BASISOFTAXATION,
								dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  		
						FROM        TAX_RATE_SETTING_CONFIG TR 
						INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
						INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id CROSS JOIN EmployeeMaster EM 						
						WHERE       TR.MIT_ID = @MIT_ID AND EM.EMPLOYEEID = @EmployeeID  AND ISNULL(TR.RESIDENTIAL_ID,0) =0 AND ISNULL(TR.COUNTRY_ID,0)=0		
						 
					END		       
					ELSE
					BEGIN     
						
						SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,'' AS RESIDENT_STATUS,
						'' AS Country, '' AS [STATE],dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
  						'Company Level' AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  			
						FROM    TAX_RATE_SETTING_CONFIG TR 
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
								INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id CROSS JOIN EMPLOYEEMASTER EM 
						WHERE   TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID	AND ISNULL(TR.RESIDENTIAL_ID,0) =0 AND ISNULL(TR.COUNTRY_ID,0)=0										
	   				END	
							
				END --End IS Exist if
				END -- End if country Id >0
				ELSE
				BEGIN
					SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE ,'' AS RESIDENT_STATUS,
						'' AS Country, '' AS [STATE],dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,
  						'Company Level' AS BASISOFTAXATION,dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					  		  			
						FROM    TAX_RATE_SETTING_CONFIG TR 
								INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
								INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id CROSS JOIN EMPLOYEEMASTER EM 
						WHERE   TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EmployeeID	AND ISNULL(TR.RESIDENTIAL_ID,0) =0 AND ISNULL(TR.COUNTRY_ID,0)=0										
				
				
				END
			
				--End Chagne by amit
			
			
			END -- End for company check
		 --END --End for @IS_TAXRATEEXCEPTION_ACTIVE
		END		
				  
     ELSE
     BEGIN   
               
          IF(LEN( ISNULL(@DateOfTermination,0))>0)
          BEGIN
          
			  SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_LIVE_EMPLOYEE) AS TAX_RATE, '' AS RESIDENT_STATUS,
					  '' AS COUNTRY, EM.TAX_IDENTIFIER_STATE AS [STATE],
					  dbo.FN_PQ_TAX_ROUNDING((TAXRATE_LIVE_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,					  
					  'Company Level' AS BASISOFTAXATION, dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
					  dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
					   		  		
		      FROM        TAX_RATE_SETTING_CONFIG TR 
		      INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID
		      INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id CROSS JOIN EMPLOYEEMASTER EM
		      --INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID 	     
		      WHERE       TR.MIT_ID= @MIT_ID AND EM.EmployeeID = @EMPLOYEEID
		      END
		      
		   ELSE
		   BEGIN
		    
		      SELECT  MTRT.TAX_HEADING,dbo.FN_PQ_TAX_ROUNDING(TR.TAXRATE_SEPRATED_EMPLOYEE) AS TAX_RATE, '' AS RESIDENT_STATUS,
					  '' AS COUNTRY, '' AS [STATE],
					  dbo.FN_PQ_TAX_ROUNDING((TAXRATE_SEPRATED_EMPLOYEE * @Total_Perk_Value)/100)AS TAX_AMOUNT,					
			          'Company Level' AS BASISOFTAXATION, dbo.FN_PQ_TAX_ROUNDING(@FMV) AS FMV, 
			          dbo.FN_PQ_TAX_ROUNDING(@Total_Perk_Value) AS TOTAL_PERK_VALUE
			           		  		
		      FROM        TAX_RATE_SETTING_CONFIG TR 
		      INNER JOIN  COMPANY_INSTRUMENT_MAPPING CM ON TR.MIT_ID=CM.MIT_ID 
		      INNER JOIN	MST_TAX_RATE_TITLE MTRT ON MTRT.MTH_ID = TR.Tax_Head_Id
		      INNER JOIN  RESIDENTIALTYPE RT ON RT.ID=TR.RESIDENTIAL_ID CROSS JOIN EMPLOYEEMASTER EM 	      
		      WHERE       TR.MIT_ID= @MIT_ID AND EM.EMPLOYEEID = @EMPLOYEEID
		  END
		 --END
     END    
	
	SET NOCOUNT OFF;

END
GO
