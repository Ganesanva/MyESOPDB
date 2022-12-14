/****** Object:  UserDefinedFunction [dbo].[FN_GET_EMPLOYEE_INSTRUMENT_LIST]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_EMPLOYEE_INSTRUMENT_LIST]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_EMPLOYEE_INSTRUMENT_LIST]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_EMPLOYEE_INSTRUMENT_LIST]
(    
      @LoginID NVARCHAR(100) 
)
RETURNS @INSTRUMENT_LIST TABLE (
      INSTRUMENT_ID INT
)
AS
BEGIN        
        DECLARE @DisplayAs CHAR(1)
		DECLARE @DisplaySplit CHAR(1)		
		DECLARE @VestingDate DATETIME = convert(date, GETDATE())
		DECLARE @GrantLegParent1 NVARCHAR(10)		
		DECLARE @GrantLegParent2 NVARCHAR(10)
		
		SELECT @DisplayAs = DisplayAs, @DisplaySplit = DisplaySplit FROM BonusSplitPolicy		

		IF((@DisplayAs = 'S' AND @DisplaySplit = 'S') OR (@DisplayAs = 'C' AND @DisplaySplit = 'C'))
		BEGIN
		    INSERT INTO @INSTRUMENT_LIST(INSTRUMENT_ID)
			SELECT DISTINCT Scheme.MIT_ID 
			FROM GrantOptions 
				INNER JOIN VestingPeriod ON GrantOptions.grantregistrationid = VestingPeriod.grantregistrationid  
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId = Vestingperiod.vestingperiodno  
				INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId 
				INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
				INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId     
			WHERE EM.LoginId = @LoginID  
				AND @VestingDate >= GrantLeg.FinalVestingDate and @VestingDate <= GrantLeg.FinalExpirayDate  
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0  AND GrantLeg.Status = 'A' 
				AND ( GrantLeg.ExercisableQuantity > 0  or GrantLeg.UnapprovedExerciseQuantity >0 ) 
				AND Scheme.IsPUPEnabled <> 1
		END
		ELSE IF((@DisplayAs = 'C' AND @DisplaySplit = 'S') OR (@DisplayAs = 'S' AND @DisplaySplit = 'C'))
		BEGIN
			IF(@DisplayAs = 'C' AND @DisplaySplit = 'S')
			BEGIN					
				 SET @GrantLegParent1 = 'N,B'					
				 SET @GrantLegParent2 = 'S,B'					 
			END
			ELSE IF(@DisplayAs = 'S' AND @DisplaySplit = 'C')
			BEGIN				    
				 SET @GrantLegParent1 = 'N,S'					 
				 SET @GrantLegParent2 = 'B,S'					
			END 
	
	        INSERT INTO @INSTRUMENT_LIST(INSTRUMENT_ID)
			SELECT DISTINCT Scheme.MIT_ID
			FROM GrantOptions 
				INNER JOIN VestingPeriod ON GrantOptions.grantregistrationid = VestingPeriod.grantregistrationid
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId = Vestingperiod.vestingperiodno
				INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
				INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
				INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
			WHERE EM.LoginId = @LoginID
				AND @VestingDate >= GrantLeg.FinalVestingDate and @VestingDate <= GrantLeg.FinalExpirayDate
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
				AND GrantLeg.Status = 'A' 
				AND GrantLeg.Parent in (SELECT * FROM FN_SPLIT_STRING(@GrantLegParent1, ','))
				AND GrantLeg.IsOriginal = 'Y'                                         
				AND ( GrantLeg.ExercisableQuantity > 0  or GrantLeg.UnapprovedExerciseQuantity > 0 )  
				AND Scheme.IsPUPEnabled <> 1
				
			UNION
			
			SELECT DISTINCT Scheme.MIT_ID
			FROM GrantOptions 
				INNER JOIN VestingPeriod ON GrantOptions.grantregistrationid = VestingPeriod.grantregistrationid
				INNER JOIN GrantLeg ON GrantLeg.GrantOptionId = GrantOptions.GrantOptionId and GrantLeg.GrantLegId = Vestingperiod.vestingperiodno
				INNER JOIN EmployeeMaster EM ON GrantOptions.EmployeeId = EM.EmployeeId
				INNER JOIN GrantRegistration ON GrantLeg.GrantRegistrationId = GrantRegistration.GrantRegistrationId
				INNER JOIN Scheme ON GrantLeg.SchemeId = Scheme.SchemeId
			WHERE EM.LoginId = @LoginID
				AND @VestingDate >= GrantLeg.FinalVestingDate and @VestingDate <= GrantLeg.FinalExpirayDate
				AND GrantLeg.GrantedOptions - GrantLeg.UnapprovedExerciseQuantity >= 0
				AND GrantLeg.Status = 'A' 
				AND GrantLeg.Parent in (select * from FN_SPLIT_STRING(@GrantLegParent2, ','))				
				AND 'Y' = CASE WHEN (@DisplayAs = 'C' AND @DisplaySplit = 'S') THEN GrantLeg.IsSplit ELSE GrantLeg.IsBonus END	
				AND (GrantLeg.ExercisableQuantity > 0  or GrantLeg.UnapprovedExerciseQuantity > 0) 
				AND Scheme.IsPUPEnabled <> 1
				
		END      
      
      RETURN
END
GO
