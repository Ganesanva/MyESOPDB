/****** Object:  StoredProcedure [dbo].[PROC_CRUDExerciseDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUDExerciseDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUDExerciseDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUDExerciseDetails]
	@Type				VARCHAR(10), 
    @ExerciseId			NUMERIC(18,0) = 0,
    @ExerciseNo			NUMERIC(18,0) = 0,
    @FMVPrice			NUMERIC(18,6) = 0,
    @PerqusiteTax		NUMERIC(18,6) = 0, 
    @PerqusiteValue		NUMERIC(18,6) = 0,
    --@CapitalGainTax		NUMERIC(18,6) = 0,
    @PerqusiteTaxRate	NUMERIC(18,6)=0,
    @LastUpdatedBy		VARCHAR(50)   = NULL    
AS 
  BEGIN 
     SET NOCOUNT ON

     DECLARE @ReturnMessage VARCHAR(200) = NULL,
			  @Result		CHAR,
			  @PAN			VARCHAR(12),	
			  @EmployeeId	VARCHAR(20)
			  
   IF @Type='R'
	   BEGIN
			SELECT @Result AS Result,
				   ExerciseId,FMVPrice,
				   PerqstPayable,PerqstValue,
				   --CapitalGainTax,
				   Perq_Tax_rate			    
			FROM ShExercisedOptions 
			WHERE ExerciseNo=@ExerciseNo
			
			IF(@@ROWCOUNT >0)
				BEGIN
					SET @Result='R'
				END
	   END
   
   ELSE IF @Type = 'U' 
		BEGIN
		--PRINT @Type
			IF(LEN(RTRIM(LTRIM(@ExerciseId))) <> 0) 
				BEGIN
					INSERT INTO AuditTrailForPostExerciseDetails
						(	ExerciseId, PreviousFMVPrice, CurrentFMVPrice, PreviousPQTax, CurrentPQTax, 
							PreviousPQValue, CurrentPQValue,PreviousPQTaxRate,CurrentPQTaxRate,	
							--PreviousCGT, CurrentCGT,
							PreviousLastUpdatedBy, CurrentLastUpdatedBy, PreviousLastUpdatedOn, 
							CurrentLastUpdatedOn)
					SELECT 
							ExerciseId, FMVPrice, @FMVPrice, PerqstPayable, @PerqusiteTax, PerqstValue,  
							@PerqusiteValue, Perq_Tax_rate,@PerqusiteTaxRate,
							--CapitalGainTax, @CapitalGainTax, 
							LastUpdatedBy, @LastUpdatedBy, LastUpdatedOn, GETDATE()
					FROM ShExercisedOptions WHERE ExerciseId=@ExerciseId
					
					UPDATE ShExercisedOptions SET FMVPrice=@FMVPrice,PerqstPayable=@PerqusiteTax,PerqstValue=@PerqusiteValue,Perq_Tax_rate=@PerqusiteTaxRate,LastUpdatedBy = @LastUpdatedBy, LastUpdatedOn = GETDATE() WHERE ExerciseId=@ExerciseId
					
					--UPDATE ShExercisedOptions SET CapitalGainTax=@CapitalGainTax WHERE ExerciseNo=@ExerciseNo
					
					SET @EmployeeId = (SELECT DISTINCT CGT_EMP.EmployeeID 
													 FROM CGTEmployeeTax CGT_EMP,ShExercisedOptions SH_EX 
													 WHERE CGT_EMP.EmployeeID=SH_EX.EmployeeID AND SH_EX.ExerciseNo=@ExerciseNo)
					
					SET @PAN=(SELECT PANNumber FROM EmployeeMaster 
								WHERE EMPLOYEEID = @EmployeeId)
					
					--IF(@PAN IS NOT NULL AND @PAN <>'')
					--	BEGIN
					--		UPDATE CGTEmployeeTax SET 
					--		CGTWithPAN=@CapitalGainTax
					--		WHERE EmployeeID=@EmployeeId
					--	END
					--ELSE
					--	BEGIN
					--		UPDATE CGTEmployeeTax SET 
					--		CGTWithoutPAN=@CapitalGainTax
					--		WHERE EmployeeID=@EmployeeId
					--	END
					
					IF(@@ROWCOUNT > 0)
					BEGIN
						SET @Result='U'
						SET @ReturnMessage = 'Data Updated Successfully.'
					END
					ELSE
						SET @ReturnMessage = 'Error occured while updating record.'
					
				END
			 ELSE
				SET @ReturnMessage='Exercise Id should not be blank'
		SELECT @Result AS Result, @ReturnMessage AS ReturnMessage 
	END
   --CSDC:- CHECK SEND DATA TO CASHLESS
   ELSE IF @Type='CSDC'
   BEGIN
		SELECT ExNo FROM SentExercised WHERE ExNo=@ExerciseNo
			IF(@@ROWCOUNT >0)
			BEGIN
				SET @ReturnMessage='Send data to cashless already done for Exercise No'
			END
   END
	SET NOCOUNT OFF
END
GO
