/****** Object:  StoredProcedure [dbo].[PROC_GET_TaxDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_TaxDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_TaxDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[PROC_GET_TaxDetails] 
    
	@ExerciseNo INT ,
	@Employeeid varchar(20)
	
AS
BEGIN	
		
		 DECLARE @FaceValue VARCHAR(10)
		 SELECT @FaceValue=FaceVaue FROM   COMPANYPARAMETERS cp 

		 SELECT X.ExerciseDate,X.INS_DISPLY_NAME AS INSTRUMENT_NAME, X.MIT_ID,X.PaymentMode,X.ExerciseAmount, X.ExercisedQuantity,
		 X.PerqusiteTax as TAXAmount, SUM(X.ExerciseAmount + X.PerqusiteTax) AS TotalAmount,X.StockApprValue,x.ShareAriseApprValue,X.NETCashPayout
		 FROM(
		 SELECT SHE.MIT_ID,SHE.PaymentMode,SHE.ExerciseDate,INS_DISPLY_NAME,SUM(she.ExercisedQuantity) as ExercisedQuantity,SUM(ShareAriseApprValue) as ShareAriseApprValue,
		 CASE WHEN SCHE.MIT_ID = 6 then ISNULL(SUM(SHE.CashPayoutValue),0)else 0 end as NETCashPayout,
				CASE WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoTentativeTax' THEN (ISNULL(SUM(she.TentShareAriseApprValue),SUM(she.ShareAriseApprValue)) * @FaceValue )                
                WHEN SCHE.MIT_ID = 6 AND SCHE.CALCULATE_TAX = 'rdoActualTax' THEN ISNULL(SUM(she.ShareAriseApprValue),0) * @FaceValue 	 ELSE 	                 
                SUM(she.ExercisePrice*she.ExercisedQuantity) END  as  ExerciseAmount,
				sum(isnull( (CASE WHEN SHE.CALCULATE_TAX = 'rdoTentativeTax' AND (SHE.PaymentMode = 'A' OR SHE.PaymentMode = 'P' OR SHE.PaymentMode = 'W')
				AND SHE.IsAutoExercised=2 AND ISNULL(SCHE.CALCUALTE_TAX_PRIOR_DAYS,0)= ISNULL(SHE.CALCUALTE_TAX_PRIOR_DAYS,0)  THEN ISNULL(SHE.TentativePerqstPayable,0)
				   WHEN SHE.CALCULATE_TAX = 'rdoActualTax' AND  CONVERT(DATE, GETDATE()) < CONVERT(DATE,SHE.ExerciseDate) THEN ISNULL(SHE.TentativePerqstPayable,SHE.PerqstPayable)
				   WHEN SHE.CALCULATE_TAX = 'rdoTentativeTax' AND SHE.TentativeFMVPrice IS NOT NULL THEN ISNULL(SHE.TentativePerqstPayable,SHE.PerqstPayable)
                   WHEN SHE.CALCULATE_TAX = 'rdoActualTax' AND SHE.FMVPrice IS NOT NULL THEN SHE.PerqstPayable ELSE NULL END), 0)) as PerqusiteTax,
				   CASE WHEN SHE.CALCULATE_TAX = 'rdoTentativeTax' THEN ISNULL(SUM(SHE.TentativeStockApprValue),0)
				   WHEN SHE.CALCULATE_TAX = 'rdoActualTax' THEN SUM(SHE.StockApprValue) ELSE 0 END AS StockApprValue
    	 FROM SHEXERCISEDOPTIONS SHE
		 	 INNER JOIN GRANTLEG GL ON SHE.GrantlegSerialNumber = GL.ID 			  
			 INNER JOIN SCHEME SCHE ON GL.SCHEMEID = SCHE.SCHEMEID 
			 INNER JOIN MST_INSTRUMENT_TYPE ON MST_INSTRUMENT_TYPE.MIT_ID=SHE.MIT_ID
		     INNER JOIN COMPANY_INSTRUMENT_MAPPING CIM ON CIM.MIT_ID = SHE.MIT_ID
         WHERE SHE.EXERCISENO=@ExerciseNo 
         GROUP BY SCHE.MIT_ID,SCHE.CALCULATE_TAX,SHE.CALCULATE_TAX,SHE.ExerciseDate ,INS_DISPLY_NAME,SHE.MIT_ID,SHE.PaymentMode)X
		 GROUP BY X.ExerciseAmount,X.PerqusiteTax,X.ExerciseDate,X.INS_DISPLY_NAME,X.MIT_ID,X.PaymentMode,X.ExercisedQuantity,X.StockApprValue,X.ShareAriseApprValue,X.NETCashPayout
		  		  
		 EXEC PROC_GET_EXERCISEDETAILS @ExerciseNo,NULL

		 SELECT DISTINCT SH.* ,GL.GrantOptionId  ,ISNULL(GM.Parent,'N') as Parent
		 FROM   ShExercisedOptions SH       
		 INNER JOIN GrantLeg GL ON GL.ID=SH.GrantLegSerialNumber      
		 INNER JOIN GrantRegistration GR ON GR.GrantRegistrationId=GL.GrantRegistrationId       
		 INNER JOIN  Scheme AS SCH on SCH.SchemeId = GL.SchemeId  
		 LEFT JOIN GrantMappingOnExNow AS GM ON GM.GrantOptionId =GL.GrantOptionId  
		 WHERE SH.ExerciseNo=@ExerciseNo 
  END
GO
