/****** Object:  StoredProcedure [dbo].[PROC_InProcessExerciseDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_InProcessExerciseDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_InProcessExerciseDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_InProcessExerciseDetails] 
	(
		@Employeeid VARCHAR(50)
	)			 	
AS

BEGIN
 
SELECT SHEX.ExerciseNo,
max(DATENAME(DD, SHEX.ExerciseDate)+'-'+DATENAME(MM, SHEX.ExerciseDate)+'-'+DATENAME(YYYY,SHEX.ExerciseDate)) as ExerciseDate,
--max(SHEX.ExerciseDate) as ExerciseDate,
  sum(cast(SHEX.ExercisedQuantity as decimal(10,2))) as ExercisedQuantity,
  --sum(SHEX.ExercisedQuantity) as ExercisedQuantity,
 ((sum(SHEX.ExercisedQuantity)) * sum(SHEX.ExercisePrice) + sum(SHEX.PerqstPayable)) as TotalAmount
   ,SCH.SchemeTitle,instrument.MIT_ID,instrument.IS_ENABLED,instrument.INS_DISPLY_NAME as INSTRUMENT_NAME,currency.CurrencyAlias
   ,SHEX.IsAutoExercised,SHEX.IsAllotmentGenerated,paymentm.PayModeName
   ,'1' as SelectPayment,'0' as DetailsUpdated,'0' as GenerateForm,'0' as UploadForm
   FROM shexercisedoptions SHEX				
				  INNER JOIN COMPANY_INSTRUMENT_MAPPING instrument
                   ON SHEX.MIT_ID = instrument.MIT_ID 
				    INNER JOIN PaymentMaster paymentm
				   ON SHEX.PaymentMode = paymentm.PaymentMode 
				   INNER JOIN CurrencyMaster currency
				   ON instrument.CurrencyID = currency.CurrencyID
				   INNER JOIN grantleg GL 
					 ON shex.grantlegserialnumber = GL.id 
				   INNER JOIN scheme SCH 
					 ON GL.schemeid = SCH.schemeid				   
				   INNER JOIN grantoptions GOP 
					 ON GL.grantoptionid = GOP.grantoptionid 
				   INNER JOIN employeemaster EM 
					 ON GOP.employeeid = EM.employeeid        
					 AND EM.loginid = @Employeeid AND instrument.IS_ENABLED = '1'
					GROUP BY SHEX.ExerciseNo,SCH.SchemeTitle,instrument.MIT_ID,instrument.IS_ENABLED,instrument.INS_DISPLY_NAME ,currency.CurrencyAlias					
					,SHEX.IsAutoExercised,SHEX.IsAllotmentGenerated,paymentm.PayModeName			
    	

END
GO
