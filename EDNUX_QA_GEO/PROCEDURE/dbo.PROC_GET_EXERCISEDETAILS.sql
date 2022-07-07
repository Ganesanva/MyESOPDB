/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISEDETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISEDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISEDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EXERCISEDETAILS]  
 @EXERCISENO INT = NULL ,      
 @EXERCISEID INT = NULL       
AS      
BEGIN      
 SET NOCOUNT ON;       
            
  IF(@EXERCISEID IS NOT NULL)  
   
    BEGIN       
        print '14444444'     
     SELECT SCH.MIT_ID,SH.EmployeeID,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativeFMVPrice,SH.FMVPrice),'FMV')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.FMVPrice ELSE '0' END AS FMVPrice,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativePerqstPayable,SH.PerqstPayable)      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstPayable ELSE '0' END AS PerqstPayable,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativePerqstValue,SH.PerqstValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstValue ELSE '0' END AS PerqValue,
	 CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentShareAriseApprValue,SH.ShareAriseApprValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.ShareAriseApprValue ELSE '0' END AS Stock_value
	 ,GR.GrantDate,GL.FinalVestingDate,sh.ExerciseDate,SH.ExerciseNo,      
     dbo.FN_GET_EVENTOFINCIDENCE(SCH.MIT_ID,sh.ExerciseDate) AS EVENT_OF_INCIDENCE, SCH.SchemeTitle,GL.GrantOptionId,SH.ExerciseId AS GrantLegId ,GrantLegSerialNumber AS TAX_SEQUENCENO      
     FROM   ShExercisedOptions SH       
     INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
     INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GL.GrantRegistrationId       
     INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
     WHERE SH.ExerciseNo=@ExerciseNo AND SH.ExerciseId=@EXERCISEID           
     UNION      
     SELECT SCH.MIT_ID,(Select EmployeeID From GrantOptions Where GrantOptionId=GL.GrantOptionId ) AS EmployeeID ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativeFMVPrice,SH.FMVPrice),'FMV')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.FMVPrice ELSE '0' END AS FMVPrice,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativePerqstPayable,SH.PerqstPayable)      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstPayable ELSE '0' END AS PerqstPayable,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativePerqstValue,SH.PerqstValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstValue ELSE '0' END AS PerqValue ,
	 CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentShareAriseApprValue,SH.ShareAriseApprValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.ShareAriseApprValue ELSE '0' END AS Stock_value
	 ,GR.GrantDate,GL.FinalVestingDate,sh.ExercisedDate,SH.ExerciseNo,      
     dbo.FN_GET_EVENTOFINCIDENCE(SCH.MIT_ID,sh.ExercisedDate) AS EVENT_OF_INCIDENCE, SCH.SchemeTitle,GL.GrantOptionId,SH.ExercisedId AS GrantLegId ,GrantLegSerialNumber AS TAX_SEQUENCENO      
     FROM   EXERCISED SH       
     INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
     INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GL.GrantRegistrationId       
     INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
     WHERE       
     SH.ExerciseNo=@ExerciseNo AND SH.ExercisedId=@EXERCISEID      
     /* GEt Tax details*/      
           
           
      /* Resident data*/      
           
      SELECT * FROM (      
            
      SELECT Tax_Title AS TAX_HEADING ,TAX_RATE ,RT.[Description] AS RESIDENT_STATUS       
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT),'TAXVALUE') END AS TAX_AMOUNT      
      ,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV      
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')    
      ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE      
       , 0 AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO,GRANTLEGSERIALNO AS TEMP_EXERCISEID ,ETD.FROM_DATE,ETD.TO_DATE,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice
	  FROM EXERCISE_TAXRATE_DETAILS ETD       
      INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO         
      INNER JOIN ResidentialType RT ON ETD.RESIDENT_ID=RT.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)>0       
              
      UNION  
      SELECT  Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) AS TAX_RATE ,'' AS RESIDENT_STATUS ,       
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT)) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT)) ,'TAXVALUE') END AS TAX_AMOUNT,      
      CM.CountryName AS Country ,'' AS [STATE] ,BASISOFTAXATION ,            
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV,      
      --SUM(CASE WHEN ISNULL(PERQVALUE,0)=0 THEN TENTATIVEPERQVALUE ELSE PERQVALUE END) AS TOTAL_PERK_VALUE ,      
      SUM(CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') 
      ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end) AS TOTAL_PERK_VALUE,      
      CM.ID AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO,GRANTLEGSERIALNO AS TEMP_EXERCISEID ,MAX(ETD.FROM_DATE) AS FROM_DATE,MAX(ETD.TO_DATE) AS TO_DATE  
      ,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice
      FROM EXERCISE_TAXRATE_DETAILS ETD      
      INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO         
      INNER JOIN CountryMaster CM ON ETD.COUNTRY_ID=CM.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)>0 AND ISNULL(RESIDENT_ID,0)=0      
      GROUP BY Tax_Title, TAX_RATE ,CM.CountryName ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE, CM.ID ,GRANTLEGSERIALNO,SH.CALCULATE_TAX,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,SH.TentativeSettlmentPrice,SH.SettlmentPrice        
            
         UNION            
      SELECT  Tax_Title AS TAX_HEADING ,TAX_RATE ,'' AS RESIDENT_STATUS       
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT) ,'TAXVALUE') END AS TAX_AMOUNT     
      ,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV      
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE      
      , 0 AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO,GRANTLEGSERIALNO AS TEMP_EXERCISEID , ISNULL(CONVERT(VARCHAR(20),FROM_DATE,101),GETDATE()) AS FROM_DATE, TO_DATE,TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice
      FROM EXERCISE_TAXRATE_DETAILS      
      INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=EXERCISE_TAXRATE_DETAILS.EXERCISE_NO       
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId        
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)=0      
            
      UNION      
            
      SELECT Tax_Title AS TAX_HEADING ,TAX_RATE ,RT.[Description] AS RESIDENT_STATUS       
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT),'TAXVALUE') END AS TAX_AMOUNT      
      ,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV      
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')    
      ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE      
       , 0 AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO,GRANTLEGSERIALNO AS TEMP_EXERCISEID ,ETD.FROM_DATE,ETD.TO_DATE,ETD.TAXCALCULATION_BASEDON ,GL.GrantOptionId,
	    CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice
      FROM EXERCISE_TAXRATE_DETAILS ETD       
      INNER JOIN EXERCISED SH ON SH.ExercisedId=ETD.EXERCISE_NO         
      INNER JOIN ResidentialType RT ON ETD.RESIDENT_ID=RT.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)>0      
              
         UNION      
           
      SELECT  Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) AS TAX_RATE ,'' AS RESIDENT_STATUS ,       
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT)) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT)) ,'TAXVALUE') END AS TAX_AMOUNT,      
      CM.CountryName AS Country ,'' AS [STATE] ,BASISOFTAXATION ,            
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV,      
      --SUM(CASE WHEN ISNULL(PERQVALUE,0)=0 THEN TENTATIVEPERQVALUE ELSE PERQVALUE END) AS TOTAL_PERK_VALUE ,      
      SUM(CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE') 
   	  ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end) AS TOTAL_PERK_VALUE,      
      CM.ID AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO ,GRANTLEGSERIALNO AS TEMP_EXERCISEID ,MAX(ETD.FROM_DATE) AS FROM_DATE,MAX(ETD.TO_DATE) AS TO_DATE,
      ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice       
      FROM EXERCISE_TAXRATE_DETAILS ETD      
      INNER JOIN EXERCISED SH ON SH.ExercisedId=ETD.EXERCISE_NO         
      INNER JOIN CountryMaster CM ON ETD.COUNTRY_ID=CM.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)>0 AND ISNULL(RESIDENT_ID,0)=0      
      GROUP BY Tax_Title, TAX_RATE ,CM.CountryName ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE, CM.ID ,GRANTLEGSERIALNO,SH.CALCULATE_TAX , ETD.TAXCALCULATION_BASEDON ,GL.GrantOptionId,SH.TentativeSettlmentPrice,SH.SettlmentPrice           
            
         UNION      
            
      SELECT  Tax_Title AS TAX_HEADING ,TAX_RATE ,'' AS RESIDENT_STATUS       
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVETAXAMOUNT,TAX_AMOUNT) ,'TAXVALUE') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TAX_AMOUNT,TENTATIVETAXAMOUNT) ,'TAXVALUE') END AS TAX_AMOUNT     
      ,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV      
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEPERQVALUE,PERQVALUE),'TAXVALUE') ELSE CASE WHEN ISNULL(PERQVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEPERQVALUE,'TAXVALUE')    
      ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(PERQVALUE,'TAXVALUE')  END end AS TOTAL_PERK_VALUE      
      , 0 AS COUNTRY_ID ,GRANTLEGSERIALNO AS TAX_SEQUENCENO,GRANTLEGSERIALNO AS TEMP_EXERCISEID , ISNULL(CONVERT(VARCHAR(20),FROM_DATE,101),GETDATE()) AS FROM_DATE, TO_DATE,TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice      
      FROM EXERCISE_TAXRATE_DETAILS      
      INNER JOIN EXERCISED SH ON SH.ExercisedId=EXERCISE_TAXRATE_DETAILS.EXERCISE_NO       
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId        
      WHERE EXERCISE_NO=@EXERCISEID AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)=0            
                 
     ) AS  T       
     ORDER BY  T.TAX_HEADING      
           
    END      
    ELSE
    BEGIN 
	print '2333333'       
     SELECT SCH.MIT_ID,SH.EmployeeID,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativeFMVPrice,SH.FMVPrice),'FMV')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.FMVPrice ELSE '0' END AS FMVPrice,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativePerqstPayable,SH.PerqstPayable)      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstPayable ELSE '0' END AS PerqstPayable,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentativePerqstValue,SH.PerqstValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.PerqstValue ELSE '0' END AS PerqValue ,
	 CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(SH.TentShareAriseApprValue,SH.ShareAriseApprValue),'TAXVALUE')      
     WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN SH.ShareAriseApprValue ELSE '0' END AS Stock_value
	 ,GR.GrantDate,GL.FinalVestingDate,sh.ExerciseDate,SH.ExerciseNo,      
     dbo.FN_GET_EVENTOFINCIDENCE(SCH.MIT_ID,sh.ExerciseDate) AS EVENT_OF_INCIDENCE, SCH.SchemeTitle,GL.GrantOptionId,SH.ExerciseId AS GrantLegId ,SH.TAX_SEQUENCENO AS TAX_SEQUENCENO       
     FROM   ShExercisedOptions SH       
     INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
     INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GL.GrantRegistrationId       
     INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
     WHERE SH.ExerciseNo=@ExerciseNo      
     /* Get Tax details*/      
           
           
     SELECT * FROM (      
      SELECT ETD.Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) as TAX_RATE ,RT.[Description] AS RESIDENT_STATUS       
      ,CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL( dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE'),0) 
	  ELSE ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TAX_AMOUNT,0)) ,'TAXVALUE'),0) END AS TAX_AMOUNT,      
      '' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV,  
	      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
	  THEN ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum(ISNULL(TENTATIVEPERQVALUE,0)),'TAXVALUE'),0) 
	  ELSE CASE  
	  WHEN SH.CALCULATE_TAX = 'rdoActualTax' 
	  THEN  dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum( ISNULL(PERQVALUE,0)),'TAXVALUE')  END end AS TOTAL_PERK_VALUE,  
       0 AS COUNTRY_ID
	   --GRANTLEGSERIALNO
	   , ETD.TAX_SEQ_NO AS TAX_SEQUENCENO,ETD.TAX_SEQ_NO AS TEMP_EXERCISEID ,ISNULL(CONVERT(VARCHAR(20),MAX(ETD.FROM_DATE)),GETDATE()) AS FROM_DATE,ISNULL(CONVERT(VARCHAR(20),MAX(ETD.TO_DATE)),GETDATE()) AS TO_DATE,ETD.TAXCALCULATION_BASEDON ,GL.GrantOptionId,
	    CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice      
      FROM EXERCISE_TAXRATE_DETAILS ETD      
      INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO       
      INNER JOIN ResidentialType RT ON ETD.RESIDENT_ID=RT.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId    
      WHERE SH.EXERCISENO=@EXERCISENO AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)>0      
      GROUP BY ETD.Tax_Title, TAX_RATE ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE, SH.CALCULATE_TAX,FMVVALUE,  TENTATIVEFMVVALUE,ETD.TAX_SEQ_NO, SH.TentativeSettlmentPrice,SH.SettlmentPrice,      
      RT.[Description],ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId         
      UNION      
            
      SELECT ETD.Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) AS TAX_RATE ,'' AS RESIDENT_STATUS ,       
     CASE 
	  WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL( dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE'),0) 
	  ELSE ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TAX_AMOUNT,0)) ,'TAXVALUE'),0) END AS TAX_AMOUNT,      
      CM.CountryName AS Country ,'' AS [STATE] ,BASISOFTAXATION ,            
       CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' 
	  THEN ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum(ISNULL(TENTATIVEPERQVALUE,0)),'TAXVALUE'),0)
	   ELSE CASE  WHEN SH.CALCULATE_TAX = 'rdoActualTax' 
	   THEN      dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum( ISNULL(PERQVALUE,0)),'TAXVALUE')  END END  AS TOTAL_PERK_VALUE,          
      CM.ID AS COUNTRY_ID 
	  , ETD.TAX_SEQ_NO AS TAX_SEQUENCENO,ETD.TAX_SEQ_NO AS TEMP_EXERCISEID ,ISNULL(CONVERT(VARCHAR(20),MAX(ETD.FROM_DATE)),GETDATE()) AS FROM_DATE,ISNULL(CONVERT(VARCHAR(20),MAX(ETD.TO_DATE)),GETDATE()) AS TO_DATE,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,
	   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice       
      FROM EXERCISE_TAXRATE_DETAILS ETD      
      INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO         
      INNER JOIN CountryMaster CM ON ETD.COUNTRY_ID=CM.id      
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId      
      WHERE SH.EXERCISENO=@EXERCISENO AND ISNULL(COUNTRY_ID,0)>0 AND ISNULL(RESIDENT_ID,0)=0      
      GROUP BY ETD.Tax_Title, TAX_RATE ,CM.CountryName ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE, CM.ID,ETD.TAX_SEQ_NO ,SH.CALCULATE_TAX,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,SH.TentativeSettlmentPrice,SH.SettlmentPrice       
            
      UNION      
                             
       SELECT ETD.Tax_Title AS TAX_HEADING ,dbo.FN_PQ_TAX_ROUNDING(TAX_RATE) as TAX_RATE ,'' AS RESIDENT_STATUS ,                               
       CASE 
	  WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL( dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TENTATIVETAXAMOUNT,0)) ,'TAXVALUE'),0) 
	  ELSE ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(SUM( ISNULL(TAX_AMOUNT,0)) ,'TAXVALUE'),0) END AS TAX_AMOUNT
      ,'' AS Country ,'' AS [STATE] ,BASISOFTAXATION ,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN dbo.FN_GET_COMPANY_DECIMAL_SETTING(ISNULL(TENTATIVEFMVVALUE,FMVVALUE),'FMV') ELSE CASE WHEN ISNULL(FMVVALUE,0)=0 THEN     dbo.FN_GET_COMPANY_DECIMAL_SETTING(TENTATIVEFMVVALUE,'FMV') ELSE dbo.FN_GET_COMPANY_DECIMAL_SETTING(FMVVALUE,'FMV')  END end AS FMV,      
      CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum(ISNULL(TENTATIVEPERQVALUE,0)),'TAXVALUE'),0)
	   ELSE CASE  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN   
       dbo.FN_GET_COMPANY_DECIMAL_SETTING(Sum( ISNULL(PERQVALUE,0)),'TAXVALUE')  END end AS TOTAL_PERK_VALUE,        
      0 AS COUNTRY_ID
	  , ETD.TAX_SEQ_NO AS TAX_SEQUENCENO,ETD.TAX_SEQ_NO AS TEMP_EXERCISEID ,ISNULL(CONVERT(VARCHAR(20),MAX(ETD.FROM_DATE),101),GETDATE()) AS FROM_DATE,MAX(ETD.TO_DATE) AS TO_DATE,ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,
		   CASE WHEN SH.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SH.TentativeSettlmentPrice,0)  WHEN SH.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SH.SettlmentPrice,0) ELSE '0' END AS SettlmentPrice         
      FROM EXERCISE_TAXRATE_DETAILS ETD INNER JOIN ShExercisedOptions SH ON SH.ExerciseId=ETD.EXERCISE_NO       
      INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
      INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId     
      WHERE SH.EXERCISENO=@EXERCISENO AND ISNULL(COUNTRY_ID,0)=0 AND ISNULL(RESIDENT_ID,0)=0      
      GROUP BY ETD.Tax_Title, TAX_RATE ,BASISOFTAXATION ,FMVVALUE, TENTATIVEFMVVALUE, ETD.TAX_SEQ_NO,SH.CALCULATE_TAX,FMVVALUE,  TENTATIVEFMVVALUE, ETD.TAXCALCULATION_BASEDON,GL.GrantOptionId,SH.TentativeSettlmentPrice,SH.SettlmentPrice       ) AS  T
      ORDER BY  T.TAX_HEADING      
            
       
  
    END      
            
         
 SET NOCOUNT OFF;         
END
GO
