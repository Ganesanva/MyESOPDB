/****** Object:  StoredProcedure [dbo].[SP_LAPSE_REPORT_Wipro]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_LAPSE_REPORT_Wipro]
GO
/****** Object:  StoredProcedure [dbo].[SP_LAPSE_REPORT_Wipro]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
CREATE PROCEDURE [dbo].[SP_LAPSE_REPORT_Wipro] 
	@FromDate DATETIME,
	@ToDate DATETIME
AS	
BEGIN
	
	
	DECLARE @FromDate_PrevDate as DATETIME, @ToDate_PrevDate AS DATETIME
	SET @FromDate_PrevDate = @FromDate - 1
	SET @ToDate_PrevDate = @ToDate - 1
	
	DECLARE @DisplayAs AS CHAR(1)
	DECLARE @DisplaySplit AS CHAR(1)

	Select @DisplayAs = UPPER(DisplayAs), @DisplaySplit = UPPER(DisplaySplit) From BonusSplitPolicy
	
	IF(@DisplayAs = 'C' AND @DisplaySplit = 'C')
		BEGIN
			Select Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration, 
			GrantRegistration.ExercisePrice as ExercisePrice, EmployeeMaster.EmployeeId as EmployeeId, EmployeeMaster.EmployeeName as EmployeeName, 
			GrantOptions.GrantOptionId as GrantOpId, EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) as OptionsLapsed, '---' as parent, 'C' as CSFlag,
			GrantLeg.LastUpdatedOn, GrantLeg.LastUpdatedBy
			From GrantOptions Inner Join GrantRegistration On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between @FROMDATE And @TODATE)
			where 
			 CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'By Scheduler' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'By Scheduler' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'By Scheduler' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'By Scheduler' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			)
			Group By EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle, 
			GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice, 
			GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate , GrantLeg.LastUpdatedOn, GrantLeg.LastUpdatedBy 	
			Having Sum(GrantLeg.LapsedQuantity) > 0 
			Order by SchemeTitle,EmployeeId ASC, GrantOpId 	
		END
		
	ELSE IF (@DisplayAs = 'C' AND @DisplaySplit = 'S')
		BEGIN
			Select  Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration, 
			GrantRegistration.ExercisePrice as ExercisePrice, EmployeeMaster.EmployeeId as EmployeeId, EmployeeMaster.EmployeeName as EmployeeName, 
			GrantOptions.GrantOptionId as GrantOpId, EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) as OptionsLapsed, 'OB' as parent, 'S' as CSFlag
			From GrantOptions Inner Join GrantRegistration  On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
 			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
 			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
 			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between () And  ()) 
			where 
			CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			)        
			and GrantLeg.parent in ('N','B') and IsOriginal='Y'
			Group By EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle, 
			GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice, 
			GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate  	
			Having Sum(GrantLeg.LapsedQuantity) > 0 
			
			UNION ALL 

			Select  Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration, 
			GrantRegistration.ExercisePrice as ExercisePrice, EmployeeMaster.EmployeeId as EmployeeId, EmployeeMaster.EmployeeName as EmployeeName, 
			GrantOptions.GrantOptionId as GrantOpId, EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) as OptionsLapsed, 'SB' as parent, 'S' as CSFlag
			From GrantOptions Inner Join GrantRegistration On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
 			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
 			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
 			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between @FromDate And @ToDate)
			where 
			CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			)
			and GrantLeg.parent in ('S','B') and IsSplit='Y' 
			Group By EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle, 
			GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice, 
			GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate  	
			Having Sum(GrantLeg.LapsedQuantity) > 0 
			Order by SchemeTitle,EmployeeId ASC, GrantOpId 				
		END
		
	ELSE IF (@DisplayAs = 'S' AND @DisplaySplit = 'C')
		BEGIN
			Select  Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration, 
			GrantRegistration.ExercisePrice as ExercisePrice, EmployeeMaster.EmployeeId as EmployeeId, EmployeeMaster.EmployeeName as EmployeeName, 
			GrantOptions.GrantOptionId as GrantOpId, EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) as OptionsLapsed, 'OS' as parent, 'S' as CSFlag 
			From GrantOptions Inner Join GrantRegistration On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between @FromDate And @ToDate) 
			where 
			CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy)<> 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			)
			and GrantLeg.parent in ('N','S') and IsOriginal='Y' 
			Group By EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle, 
			GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice, 
			GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate  	
			Having Sum(GrantLeg.LapsedQuantity) > 0 
			
			UNION ALL 

			Select  Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, GrantRegistration.GrantRegistrationId as GrantRegistration, 
			GrantRegistration.ExercisePrice as ExercisePrice, EmployeeMaster.EmployeeId as EmployeeId, EmployeeMaster.EmployeeName as EmployeeName, 
			GrantOptions.GrantOptionId as GrantOpId, EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			Sum((GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier) as OptionsLapsed, 'BS' as parent, 'S' as CSFlag 
			From GrantOptions Inner Join GrantRegistration On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between @FromDate And @ToDate)
			where 
			CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			) 
			and GrantLeg.parent in ('S','B') and IsBonus='Y' 
			Group By EmployeeMaster.EmployeeId, EmployeeMaster.EmployeeName, Scheme.SchemeTitle, 
			GrantRegistration.GrantDate, GrantRegistration.GrantRegistrationId, GrantRegistration.ExercisePrice, 
			GrantOptions.GrantOptionId, EmployeeMaster.DateOfTermination, GrantLeg.FinalExpirayDate  	
			Having Sum(GrantLeg.LapsedQuantity) > 0 
			Order by SchemeTitle,EmployeeId ASC, GrantOpId 				 
		END
	
	ELSE 
		BEGIN
			Select Scheme.SchemeTitle as SchemeTitle, GrantRegistration.GrantDate as GrantDate, 
			GrantRegistration.GrantRegistrationId as GrantRegistration,GrantRegistration.ExercisePrice as ExercisePrice,
			EmployeeMaster.EmployeeId as EmployeeId, GrantLeg.Parent as Parent, EmployeeMaster.EmployeeName as EmployeeName,GrantOptions.GrantOptionId as GrantOpId, 
			EmployeeMaster.DateOfTermination as Status, GrantLeg.FinalExpirayDate as ExpiryDate, 
			(GrantLeg.LapsedQuantity*Scheme.OptionRatioDivisor)/Scheme.OptionRatioMultiplier as OptionsLapsed, 'S' as CSFlag 
			From 
			GrantOptions 
			Inner Join GrantRegistration On GrantOptions.GrantRegistrationId=GrantRegistration.GrantRegistrationId 
			Inner join Scheme On GrantRegistration.SchemeId=Scheme.SchemeId 
			Inner Join GrantLeg On GrantOptions.GrantOptionId=GrantLeg.GrantOptionId 
			Inner Join EmployeeMaster On GrantOptions.EmployeeId=EmployeeMaster.EmployeeId 
			--where ( GrantLeg.FinalExpirayDate Between @FromDate And @ToDate)
			where 
			CONVERT(DATE, GrantLeg.LastUpdatedOn) Between 
			( CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE, @FromDate_PrevDate)
				END) 
			And 
			(
                CASE 
					WHEN UPPER(GrantLeg.LastUpdatedBy) = 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) = 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate)
					WHEN UPPER(GrantLeg.LastUpdatedBy) <> 'ADMIN' OR UPPER(GrantLeg.LastUpdatedBy) <> 'BY SCHEDULER' THEN CONVERT(DATE,@ToDate_PrevDate)
				END  
			) 
			And GrantLeg.LapsedQuantity > 0 
			Order by SchemeTitle, EmployeeId ASC,GrantOpId ASC,Parent 				
		END
END 
	
GO
