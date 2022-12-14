/****** Object:  StoredProcedure [dbo].[SP_OptionsStatusReport]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_OptionsStatusReport]
GO
/****** Object:  StoredProcedure [dbo].[SP_OptionsStatusReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Aniruddha Badawe>
-- Create date: <13 Aug 2012>
-- Modified By: <Azhar Desai>
-- Modified date: <10 Nov 2017>
-- Description:   <Procedure created to fetch data for Options Status Report as Per REQ-REF-DOC 17 for Sept Release sprint 5>  
-- EXEC SP_OptionsStatusReport 'UderwaterSAR'
-- =============================================
CREATE PROCEDURE [dbo].[SP_OptionsStatusReport]

--ADD PARAMERTER FOR STORE PROCEDURE HERE
      @SCHEME_NAME varchar(MAX)

AS
BEGIN

      SET NOCOUNT ON;
      DECLARE @FINAL_VESTING_DATE	AS DATE
      DECLARE @FIANL_EXPIRY_DATE	AS DATE
      
      DECLARE @EXERCISED_QUANTITY	AS NUMERIC(18,4) 
      DECLARE @CANCELLED_QUANTITY	AS NUMERIC(18,4) 
      DECLARE @LAPSED_QUANTITY		AS NUMERIC(18,4) 
      DECLARE @EXERCISABLE_QUANTITY AS NUMERIC(18,4) 
      DECLARE @OPTIONS_GRANTED		AS NUMERIC(18,4)
      DECLARE @UNVESTED_OPTIONS		AS NUMERIC(18,4) 
      
      SET @FINAL_VESTING_DATE = GETDATE();
      SET @FIANL_EXPIRY_DATE = GETDATE();
      
	 
      CREATE TABLE #TEMP_DATA 
            (
						
            OptionsGranted numeric(18,0), OptionsVested  numeric(18,0), OptionsExercised numeric(18,0),OptionsCancelled numeric(18,0), 
            OptionsLapsed numeric(18,0), OptionsUnVested numeric(18,0), [Pending For Approval] numeric(18,0), GrantOptionId NVARCHAR(100),
			GrantLegId numeric(18,0),SchemeId NVARCHAR(150),GrantRegistrationId NVARCHAR(150),  
			Employeeid NVARCHAR(150),employeename NVARCHAR(250), SBU NVARCHAR(100) NULL,AccountNo NVARCHAR(100) NULL,
			PANNumber NVARCHAR(100) NULL,
			Entity NVARCHAR(100) NULL, [Status] NVARCHAR(100),GrantDate DATETIME,[Vesting Type] NVARCHAR(100),
			ExercisePrice numeric(10,2),VestingDate DATETIME,
			ExpirayDate DATETIME, Parent_Note NVARCHAR(10),
			UnvestedCancelled numeric(18,0), VestedCancelled numeric(18,0),
			INSTRUMENT_NAME VARCHAR(100), CurrencyName VARCHAR(100),
		COST_CENTER VARCHAR(100),
		Department VARCHAR(100), Location VARCHAR(100),
		EmployeeDesignation VARCHAR(100), Grade Varchar(100),ResidentialStatus VARCHAR(100),
		CountryName VARCHAR(100),CurrencyAlias VARCHAR(50),MIT_ID VARCHAR(50),CancellationReason VARCHAR(500)
        
		)
           
		   
		  --- ,payrollcountry VARCHAR(100),	

	 
      ---Insert data into Temp Table
      DECLARE @TO_DATE AS VARCHAR(10)
      SET @TO_DATE = CONVERT(VARCHAR(10),(SELECT CONVERT(DATE,GETDATE())))
      INSERT INTO #TEMP_DATA Exec SP_REPORT_DATA '1900-01-01', @TO_DATE
     
      ---GET THE FINAL OUTPUT
      SELECT INSTRUMENT_NAME,MIT_ID,SUM(OptionsLapsed) AS LapsedQuantity, SUM(OptionsExercised) AS ExercisedQuantity , 
			 SUM(OptionsCancelled) AS CancelledQuantity, SUM(OptionsUnVested) AS UnvestedOptions, SUM(OptionsVested) + SUM([Pending For Approval]) AS ExercisableQuantity
      FROM #TEMP_DATA  WHERE SchemeId  IN (SELECT Param FROM fn_MVParam(@SCHEME_NAME,',')) 
	  GROUP BY INSTRUMENT_NAME, MIT_ID    
END
 --SP_REPORT_DATA '1900-01-01', '2021-01-01'
GO
