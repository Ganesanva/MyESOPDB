DROP PROCEDURE IF EXISTS dbo.[PROC_GET_TEMP_CONFIG]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TEMP_CONFIG]    Script Date: 19-07-2022 12:04:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.[PROC_GET_TEMP_CONFIG]
	(	 
		@EXCERSISE_ID			INT,
		@PARAMETER_NAME NVARCHAR(50) =NULL,
		@PARAMETER_TYPE NVARCHAR(50) =NULL 		
    )
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @MITID AS INT
	DECLARE @PAYMENTMODE AS NCHAR(10)
	DECLARE @PAYMENTMASTERID AS INT	
	DECLARE @ResidentialID AS INT
	DECLARE @PAYMENTMODEBASEDON AS NVARCHAR(50)
	DECLARE @EMPLOYEEID AS NCHAR(10)
	DECLARE @TEMPLATENAME AS NVARCHAR(50)
	BEGIN TRY		
	 
	 SELECT top 1 @MITID= MIT_ID,@PAYMENTMODE= PAYMENTMODE,@EMPLOYEEID=EMPLOYEEID FROM ShExercisedOptions WHERE ExerciseId=@EXCERSISE_ID
	 SELECT @PAYMENTMASTERID =ID FROM PAYMENTMASTER WHERE PAYMENTMODE=@PAYMENTMODE
	 SELECT @ResidentialID=ID FROM ResidentialType WHERE ResidentialStatus =(SELECT  TOP 1 ResidentialStatus FROM EmployeeMaster WHERE EMPLOYEEID=@EMPLOYEEID)
	 print @PAYMENTMODE

	

	 print @PAYMENTMASTERID
	 SELECT @PAYMENTMODEBASEDON=
	         CASE PAYMENTMODE_BASED_ON  
				 WHEN UPPER('rdoCompanyLevel') THEN  'Company' 
				 WHEN UPPER('rdoResidentStatus') THEN 'Resident' 
				 WHEN UPPER('rdoCountry') THEN 'Country'	
				 --ELSE ''
			 END 	          
	 FROM COMPANY_INSTRUMENT_MAPPING WHERE MIT_ID=@MITID 
	

	 Print @PAYMENTMODEBASEDON
	 IF(UPPER(@PAYMENTMODEBASEDON)='COMPANY')
	 BEGIN
		 --SELECT 'COMPANY LEVEL'


		
		 IF(@PAYMENTMODE ='' OR @PAYMENTMODE IS NULL )
		 BEGIN			 
		 SELECT @TEMPLATENAME= TEMPLATE_NAME FROM COUNTRY_WISE_PAYMENT_MODE WHERE MIT_ID=@MITID AND COUNTRY_ID IS NOT NULL AND STATE_ID IS NOT NULL  AND RESIDENTID IS NULL
		 PRINT @TEMPLATENAME
		 SELECT MAPD.MAIPD_ID,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE,MAPD.COLUMN_NAME,MAPD.MAPPED_COLUMNS FROM MST_ADDIN_PARAMETERS MAP INNER JOIN MST_ADDIN_PARAMETERS_DETAILS MAPD ON MAP.MAIP_ID=MAPD.MAIP_ID WHERE MAP.PARAMETERTYPE='Label'
		 END
		 ELSE
		 BEGIN
		 	 
		 SELECT @TEMPLATENAME= TEMPLATE_NAME FROM COUNTRY_WISE_PAYMENT_MODE WHERE MIT_ID=@MITID AND PAYMENTMASTER_ID=@PAYMENTMASTERID AND COUNTRY_ID IS NOT NULL AND STATE_ID IS NOT NULL  AND RESIDENTID IS NULL
		 PRINT @TEMPLATENAME
		 SELECT MAPD.MAIPD_ID,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE,MAPD.COLUMN_NAME,MAPD.MAPPED_COLUMNS FROM MST_ADDIN_PARAMETERS MAP INNER JOIN MST_ADDIN_PARAMETERS_DETAILS MAPD ON MAP.MAIP_ID=MAPD.MAIP_ID WHERE MAP.PARAMETERTYPE='Label'

		 END

	 END
	 IF((UPPER(@PAYMENTMODEBASEDON)='RESIDENT') OR(UPPER(@PAYMENTMODEBASEDON)='R') )
	 BEGIN		
		
		 IF(@PAYMENTMODE ='' OR @PAYMENTMODE IS NULL )
		 BEGIN			 
		 SELECT @TEMPLATENAME= TEMPLATE_NAME FROM COUNTRY_WISE_PAYMENT_MODE WHERE MIT_ID=@MITID AND COUNTRY_ID IS NOT NULL AND STATE_ID IS NOT NULL  AND RESIDENTID IS NULL
		 PRINT @TEMPLATENAME
		 SELECT MAPD.MAIPD_ID,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE,MAPD.COLUMN_NAME,MAPD.MAPPED_COLUMNS,MAPD.DISPLAY_NAME FROM MST_ADDIN_PARAMETERS MAP INNER JOIN MST_ADDIN_PARAMETERS_DETAILS MAPD ON MAP.MAIP_ID=MAPD.MAIP_ID WHERE MAP.PARAMETERTYPE='Label'
		 END
		 ELSE
		 BEGIN
		 	 
		 SELECT @TEMPLATENAME= TEMPLATE_NAME FROM COUNTRY_WISE_PAYMENT_MODE WHERE MIT_ID=@MITID AND PAYMENTMASTER_ID=@PAYMENTMASTERID AND COUNTRY_ID IS NOT NULL AND STATE_ID IS NOT NULL  AND RESIDENTID IS NULL
		 PRINT @TEMPLATENAME
		 SELECT MAPD.MAIPD_ID,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE,MAPD.COLUMN_NAME,MAPD.MAPPED_COLUMNS,MAPD.DISPLAY_NAME FROM MST_ADDIN_PARAMETERS MAP INNER JOIN MST_ADDIN_PARAMETERS_DETAILS MAPD ON MAP.MAIP_ID=MAPD.MAIP_ID WHERE MAP.PARAMETERTYPE='Label'

		  END

	 END
	 IF(UPPER(@PAYMENTMODEBASEDON)='COUNTRY')
	 BEGIN
			--print 'd'		 
			DECLARE @EXERCISEDATE DATE
			SET @EXERCISEDATE=CONVERT(DATE,@EXERCISEDATE)

				CREATE TABLE #TEMP_ENTITY_DATA
				(
					SRNO BIGINT, FIELD NVARCHAR(100), EMPLOYEEID NVARCHAR(100), EMPLOYEENAME NVARCHAR(500), 
					EMP_STATUS NVARCHAR(50), ENTITY NVARCHAR(500), FROMDATE DATETIME, TODATE DATETIME, CREATED_ON DATE,
					EM_COUNTRYID INT,EM_JOININGDATE DATE
				)	
				INSERT INTO #TEMP_ENTITY_DATA
				(
					SRNO, FIELD, EMPLOYEEID, EMPLOYEENAME, EMP_STATUS, ENTITY, FROMDATE, TODATE, CREATED_ON
				)	
				EXEC PROC_EMP_MOVEMENT_TRANSFER 'TAX IDENTIFIER COUNTRY','ED0001'
				
				/*
				UPDATE #TEMP_ENTITY_DATA SET EM_JOININGDATE=EM.DATEOFJOINING,EM_COUNTRYID=CM.ID FROM EMPLOYEEMASTER EM
				INNER JOIN COUNTRYMASTER CM ON CM.COUNTRYALIASNAME=EM.COUNTRYNAME
				WHERE EM.EMPLOYEEID='ED0001'
				--SELECT * FROM AUDIT_TRAIL_FOR_TRACK_MASSUPLOAD
				--WHERE FIELD='TAX IDENTIFIER COUNTRY' AND EMPLOYEEID='ED0001'
				--SELECT * FROM EMPLOYEEMASTER WHERE EMPLOYEEID='ED0001'
				SELECT @EXERCISEDATE
				SELECT 'TEST', TED.*,CM.ID,CM.COUNTRYALIASNAME FROM #TEMP_ENTITY_DATA TED 
				INNER JOIN COUNTRYMASTER CM ON CM.COUNTRYNAME=TED.ENTITY
				WHERE  ( ISNULL( CONVERT(DATE,TED.FROMDATE),ISNULL(CONVERT(DATE,'01-DEC-2014'), GETDATE()))<=(CONVERT(DATE,@EXERCISEDATE)) AND (CONVERT(DATE, ISNULL(TED.TODATE, GETDATE()))) >=(CONVERT(DATE,@EXERCISEDATE)))

				SELECT * FROM #TEMP_ENTITY_DATA
				*/
				DROP TABLE #TEMP_ENTITY_DATA
				END				
				
				SELECT MATC.MATC_ID,MATC.MAIP_ID,MATC.MIT_ID,MATC.TEMPLATE_NAME,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE,CASE WHEN(MATCD.COLUMN_NAME LIKE 'COLUMN%' )THEN 'HORIZONTAL' ELSE 'VERTICAL' END AS TABLEDIRECTION
						,MATCD.COLUMN_NAME AS COLSEQUENCE,	MATCD.COLUMN_TYPE,	MATCD.HEADER_TEXT,MAPD.COLUMN_NAME,MAPD.MAPPED_COLUMNS,MAP.PARAMETER_NAME,MAP.PARAMETERTYPE
				FROM MST_ADDIN_TEMPLATE_CONFIG MATC INNER JOIN MST_ADDIN_PARAMETERS MAP
				ON MATC.MAIP_ID=MAP.MAIP_ID
				INNER JOIN MST_ADDIN_TEMPLATE_CONFIG_DETAILS MATCD ON MATCD.MATC_ID=MATC.MATC_ID
				INNER JOIN MST_ADDIN_PARAMETERS_DETAILS MAPD ON MAPD.MAIPD_ID=MATCD.MAIPD_ID
				INNER JOIN  COUNTRY_WISE_PAYMENT_MODE CWPM ON MATC.CWPM_ID=CWPM.CWPM_ID and CWPM.RESIDENTID=@ResidentialID and PAYMENTMASTER_ID=@PAYMENTMASTERID
				WHERE MATC.TEMPLATE_NAME=@TEMPLATENAME And MATC.MIT_ID= @MITID
				ORDER BY convert(int,Replace(MATCD.COLUMN_NAME,'column','0')) ASC
					
	END TRY
	BEGIN CATCH
	--	ROLLBACK TRANSACTION
		RETURN 0
	END CATCH
	SET NOCOUNT OFF;
END
GO

