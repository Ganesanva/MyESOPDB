/****** Object:  StoredProcedure [dbo].[SelectEmpCGTFormulaDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SelectEmpCGTFormulaDetails]
GO
/****** Object:  StoredProcedure [dbo].[SelectEmpCGTFormulaDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectEmpCGTFormulaDetails]     
@ExerciseID VARCHAR(MAX),      
@Result VARCHAR(MAX) OUTPUT    
AS      
BEGIN    
 --SET NOCOUNT ON added to prevent extra result sets from      
 SET NOCOUNT ON;   
 SET @Result=''
 
 DECLARE @CGT_SETTINGS_At VARCHAR(50),
  @MAX INT,
  @MIN INT,
  @EMP NVARCHAR(1000)
  CREATE TABLE #Temp       
		( 
			Idt INT Identity(1,1),
			EmpId NVARCHAR(1000),			
			ErrorStatus VARCHAR(1000)    
		)
	IF  EXISTS (SELECT 1 FROM CGT_SETTINGS)
		BEGIN 	
				SELECT TOP 1 @CGT_SETTINGS_At=CGT_SETTINGS_At 
					   FROM CGT_SETTINGS 
					   WHERE CONVERT(DATE,APPLICABLE_FROM)<=CONVERT(DATE,GETDATE()) ORDER BY lastupdated_on DESC    
				--Print @CGT_SETTINGS_At
				IF @CGT_SETTINGS_At='E'
					BEGIN
						INSERT INTO #Temp(EmpId)
							SELECT DISTINCT EMPLOYEEID FROM ShExercisedOptions WHERE ExerciseId IN(SELECT PARAM FROM fn_MVParam(@ExerciseID,','))
						SELECT	@MIN=MIN(#Temp.Idt),@MAX=MAX(#Temp.Idt) 
								FROM	#Temp
						WHILE (@MIN <= @MAX)
							BEGIN
						SELECT	@EMP = #Temp.EmpId 
						FROM	#Temp 
						WHERE	#Temp.Idt = @MIN
						
						--PRINT @EMP
						
						IF(@EMP != '' OR @EMP IS NOT NULL)
						BEGIN
							IF NOT EXISTS(SELECT 1 FROM CGTEmployeeTax WHERE EmployeeID = @EMP)
							 BEGIN
								SET @Result+= (@EMP+',')
							 END    
						END			
						
					  SET @MIN = @MIN + 1  	
					END
					END
				ELSE IF @CGT_SETTINGS_At='C'
					BEGIN
					SET @Result=''
					END
				ELSE 
					BEGIN
					SET @Result= 'CGT Employee Tax Data Not Found Within the Date Range'
					END
					
				-- Dispose Temp object
				IF EXISTS        
				 (        
					SELECT *        
					FROM tempdb.dbo.sysobjects        
					WHERE ID = OBJECT_ID(N'tempdb..#Temp')        
				 )        
				 BEGIN        
					DROP TABLE #Temp   
				 END
	  END  
	ELSE 
		BEGIN 
	    SET @Result= 'CGT Employee Tax Data Not Found.'
	    END 
	END	 


GO
