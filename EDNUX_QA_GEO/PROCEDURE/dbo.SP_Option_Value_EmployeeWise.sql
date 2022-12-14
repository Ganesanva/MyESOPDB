/****** Object:  StoredProcedure [dbo].[SP_Option_Value_EmployeeWise]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_Option_Value_EmployeeWise]
GO
/****** Object:  StoredProcedure [dbo].[SP_Option_Value_EmployeeWise]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Option_Value_EmployeeWise](
	@AsOnDate datetime,
	@Scheme varchar(50)=null, 
	@GrantDateFrom datetime=null,
	@GrantDateTo datetime=null,
	@Employee varchar(20)=null,
	@VestDateFrom datetime=null,
	@VestDateTo datetime=null,
	@Status varchar(20)=null
	)			 	
AS
	
BEGIN 

--report 1 code start here 
	declare @TotalVesting int
	declare @SharePrice float
	declare @sqlstring varchar(max)
	
	--SET @todate = GETDATE();
		BEGIN
		  --Total Vesting Date shows that how much vesting happens till date
			Select @TotalVesting =COUNT( distinct  vestingDate) from GrantLeg where VestingDate<=@AsOnDate
      	    
      	    Select  @SharePrice = ClosePrice from SharePrices 
      	     where PriceDate =(Select MAX(PriceDate) from SharePrices where PriceDate <=@AsOnDate) 
      	     
			SELECT DISTINCT 
                      GrantOptions.EmployeeId, EmployeeMaster.EmployeeName, EmployeeMaster.DateOfTermination, GrantRegistration.ExercisePrice, GrantLeg.VestingDate, 
                      GrantRegistration.GrantDate, DATEPART(year, GrantRegistration.GrantDate) AS Year, sum( GrantLeg.GrantedOptions) AS GrantedOptions, 
                      SUM(GrantLeg.CancelledQuantity) AS CancelledQuantity, isnull(SUM(exed.qty),0) as ExercisedQuantity,
                      isnull(SUM(exed.qty ),0) * (@SharePrice- GrantRegistration.ExercisePrice) As SumOfExerciseOptions,
                      ( sum(GrantLeg.GrantedOptions)- isnull(SUM(exed.qty),0)-SUM(GrantLeg.CancelledQuantity))   * (@SharePrice- GrantRegistration.ExercisePrice) As SumOfUnExerciseOptions,GrantRegistration.GrantRegistrationId
FROM         GrantOptions INNER JOIN
                      GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId INNER JOIN
                      EmployeeMaster ON GrantOptions.EmployeeId = EmployeeMaster.EmployeeID INNER JOIN
                      GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId left outer join
                      (select sum(ex.ExercisedQuantity) qty, ex.GrantLegSerialNumber from Exercised ex where ex.ExercisedDate<=@AsOnDate  group by ex.GrantLegSerialNumber) exed on GrantLeg.ID = exed.GrantLegSerialNumber
Where  GrantRegistration.GrantDate<=@AsOnDate and (Grantleg.CancellationDate<=@AsOnDate or grantleg.CancellationDate is null) and  grantleg.GrantedOptions >0 and 
Grantoptions.SchemeId  =CASE  WHEN @Scheme IS NULL  THEN Grantoptions.SchemeId ELSE @Scheme END   And
GrantRegistration.GrantDate   >=CASE  WHEN @GrantDateFrom IS NULL THEN GrantRegistration.GrantDate   ELSE @GrantDateFrom END   And
GrantRegistration.GrantDate  <=CASE  WHEN @GrantDateTo  IS NULL THEN GrantRegistration.GrantDate  ELSE @GrantDateTo END   And
Grantoptions.EmployeeId =CASE  WHEN @Employee IS NULL THEN Grantoptions.EmployeeId  ELSE @Employee END  And
Grantleg.VestingDate  >=CASE  WHEN @VestDateFrom  IS NULL THEN grantleg.VestingDate   ELSE @VestDateFrom  END  And
Grantleg.VestingDate  <=CASE  WHEN @VestDateTo   IS NULL THEN grantleg.VestingDate   ELSE @VestDateTo   END 
/*and 
EmployeeMaster.DateOfTermination = case when @Status is null then EmployeeMaster.DateOfTermination 
										when @Status = 'Live' then NULL when @Status = 'Separated' then '01-01-1900' end*/

                    
GROUP BY GrantOptions.EmployeeId, EmployeeMaster.EmployeeName, GrantRegistration.GrantDate,GrantRegistration.ExercisePrice, GrantLeg.VestingDate,  EmployeeMaster.DateOfTermination,  GrantRegistration.GrantRegistrationId
Order by GrantOptions.EmployeeId, GrantRegistration.GrantDate,GrantRegistration.ExercisePrice, GrantLeg.VestingDate,          GrantRegistration.GrantRegistrationId
                      
                      
          SELECT DISTINCT 
                       GrantLeg.VestingDate
FROM         GrantOptions INNER JOIN
                      GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId INNER JOIN
                      EmployeeMaster ON GrantOptions.EmployeeId = EmployeeMaster.EmployeeID INNER JOIN
                      GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId left outer join
                      (select sum(ex.ExercisedQuantity) qty, ex.GrantLegSerialNumber from Exercised ex where ex.ExercisedDate<=@AsOnDate  group by ex.GrantLegSerialNumber) exed on GrantLeg.ID = exed.GrantLegSerialNumber
Where  GrantRegistration.GrantDate<=@AsOnDate and (Grantleg.CancellationDate<=@AsOnDate or grantleg.CancellationDate is null) and  grantleg.GrantedOptions >0 and 
Grantoptions.SchemeId  =CASE  WHEN @Scheme IS NULL  THEN Grantoptions.SchemeId ELSE @Scheme END   And
GrantRegistration.GrantDate   >=CASE  WHEN @GrantDateFrom IS NULL THEN GrantRegistration.GrantDate   ELSE @GrantDateFrom END   And
GrantRegistration.GrantDate  <=CASE  WHEN @GrantDateTo  IS NULL THEN GrantRegistration.GrantDate  ELSE @GrantDateTo END   And
Grantoptions.EmployeeId =CASE  WHEN @Employee IS NULL THEN Grantoptions.EmployeeId  ELSE @Employee END  And
Grantleg.VestingDate  >=CASE  WHEN @VestDateFrom  IS NULL THEN grantleg.VestingDate   ELSE @VestDateFrom  END  And
Grantleg.VestingDate  <=CASE  WHEN @VestDateTo   IS NULL THEN grantleg.VestingDate   ELSE @VestDateTo   END 
/*and 
EmployeeMaster.DateOfTermination = case when @Status is null then EmployeeMaster.DateOfTermination 
										when @Status = 'Live' then NULL when @Status = 'Separated' then '01-01-1900' end*/

                    
GROUP BY GrantOptions.EmployeeId, EmployeeMaster.EmployeeName,GrantRegistration.GrantDate, GrantLeg.VestingDate,  EmployeeMaster.DateOfTermination, GrantRegistration.ExercisePrice,
                      GrantRegistration.GrantRegistrationId
Order by   GrantLeg.VestingDate


 
                    
          Select   ClosePrice from SharePrices 
      	     where PriceDate =(Select MAX(PriceDate) from SharePrices where PriceDate <=@AsOnDate) 
      	     
     if(@Status ='Live') 	     
  SELECT DISTINCT 
                      GrantOptions.EmployeeId
FROM         GrantOptions INNER JOIN
                      GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId INNER JOIN
                      EmployeeMaster ON GrantOptions.EmployeeId = EmployeeMaster.EmployeeID INNER JOIN
                      GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId Left outer JOIN
                      Exercised ON GrantLeg.ID = Exercised.GrantLegSerialNumber left outer join
(select sum(ex.ExercisedQuantity) qty, ex.GrantLegSerialNumber from Exercised ex where ex.ExercisedDate<=@AsOnDate  group by ex.GrantLegSerialNumber) exed on GrantLeg.ID = exed.GrantLegSerialNumber
Where  GrantRegistration.GrantDate<=@AsOnDate and (Grantleg.CancellationDate<=@AsOnDate or grantleg.CancellationDate is null) and  grantleg.GrantedOptions >0 and 

Grantoptions.SchemeId  =CASE  WHEN @Scheme IS NULL  THEN Grantoptions.SchemeId ELSE @Scheme END   And
GrantRegistration.GrantDate   >=CASE  WHEN @GrantDateFrom IS NULL THEN GrantRegistration.GrantDate   ELSE @GrantDateFrom END   And
GrantRegistration.GrantDate  <=CASE  WHEN @GrantDateTo  IS NULL THEN GrantRegistration.GrantDate  ELSE @GrantDateTo END   And
Grantoptions.EmployeeId =CASE  WHEN @Employee IS NULL THEN Grantoptions.EmployeeId  ELSE @Employee END  And
Grantleg.VestingDate  >=CASE  WHEN @VestDateFrom  IS NULL THEN grantleg.VestingDate   ELSE @VestDateFrom  END  And
Grantleg.VestingDate  <=CASE  WHEN @VestDateTo   IS NULL THEN grantleg.VestingDate   ELSE @VestDateTo   END    and
EmployeeMaster.DateOfTermination is null            
GROUP BY GrantOptions.EmployeeId, EmployeeMaster.EmployeeName, GrantLeg.VestingDate,  EmployeeMaster.DateOfTermination, GrantRegistration.ExercisePrice,
                      GrantRegistration.GrantDate
Order by GrantOptions.EmployeeId 	

else if (@Status ='Separated')
    SELECT DISTINCT 
                      GrantOptions.EmployeeId
FROM         GrantOptions INNER JOIN
                      GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId INNER JOIN
                      EmployeeMaster ON GrantOptions.EmployeeId = EmployeeMaster.EmployeeID INNER JOIN
                      GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId Left outer JOIN
                      Exercised ON GrantLeg.ID = Exercised.GrantLegSerialNumber left outer join
(select sum(ex.ExercisedQuantity) qty, ex.GrantLegSerialNumber from Exercised ex where ex.ExercisedDate<=@AsOnDate  group by ex.GrantLegSerialNumber) exed on GrantLeg.ID = exed.GrantLegSerialNumber
Where  GrantRegistration.GrantDate<=@AsOnDate and (Grantleg.CancellationDate<=@AsOnDate or grantleg.CancellationDate is null) and  grantleg.GrantedOptions >0 and 

Grantoptions.SchemeId  =CASE  WHEN @Scheme IS NULL  THEN Grantoptions.SchemeId ELSE @Scheme END   And
GrantRegistration.GrantDate   >=CASE  WHEN @GrantDateFrom IS NULL THEN GrantRegistration.GrantDate   ELSE @GrantDateFrom END   And
GrantRegistration.GrantDate  <=CASE  WHEN @GrantDateTo  IS NULL THEN GrantRegistration.GrantDate  ELSE @GrantDateTo END   And
Grantoptions.EmployeeId =CASE  WHEN @Employee IS NULL THEN Grantoptions.EmployeeId  ELSE @Employee END  And
Grantleg.VestingDate  >=CASE  WHEN @VestDateFrom  IS NULL THEN grantleg.VestingDate   ELSE @VestDateFrom  END  And
Grantleg.VestingDate  <=CASE  WHEN @VestDateTo   IS NULL THEN grantleg.VestingDate   ELSE @VestDateTo   END    and
EmployeeMaster.DateOfTermination is not null
GROUP BY GrantOptions.EmployeeId, EmployeeMaster.EmployeeName, GrantLeg.VestingDate,  EmployeeMaster.DateOfTermination, GrantRegistration.ExercisePrice,
                      GrantRegistration.GrantDate
Order by GrantOptions.EmployeeId 

else 

    SELECT DISTINCT 
                      GrantOptions.EmployeeId
FROM         GrantOptions INNER JOIN
                      GrantLeg ON GrantOptions.GrantOptionId = GrantLeg.GrantOptionId INNER JOIN
                      EmployeeMaster ON GrantOptions.EmployeeId = EmployeeMaster.EmployeeID INNER JOIN
                      GrantRegistration ON GrantOptions.GrantRegistrationId = GrantRegistration.GrantRegistrationId Left outer JOIN
                      Exercised ON GrantLeg.ID = Exercised.GrantLegSerialNumber left outer join
(select sum(ex.ExercisedQuantity) qty, ex.GrantLegSerialNumber from Exercised ex where ex.ExercisedDate<=@AsOnDate  group by ex.GrantLegSerialNumber) exed on GrantLeg.ID = exed.GrantLegSerialNumber
Where  GrantRegistration.GrantDate<=@AsOnDate and (Grantleg.CancellationDate<=@AsOnDate or grantleg.CancellationDate is null) and  grantleg.GrantedOptions >0 and 

Grantoptions.SchemeId  =CASE  WHEN @Scheme IS NULL  THEN Grantoptions.SchemeId ELSE @Scheme END   And
GrantRegistration.GrantDate   >=CASE  WHEN @GrantDateFrom IS NULL THEN GrantRegistration.GrantDate   ELSE @GrantDateFrom END   And
GrantRegistration.GrantDate  <=CASE  WHEN @GrantDateTo  IS NULL THEN GrantRegistration.GrantDate  ELSE @GrantDateTo END   And
Grantoptions.EmployeeId =CASE  WHEN @Employee IS NULL THEN Grantoptions.EmployeeId  ELSE @Employee END  And
Grantleg.VestingDate  >=CASE  WHEN @VestDateFrom  IS NULL THEN grantleg.VestingDate   ELSE @VestDateFrom  END  And
Grantleg.VestingDate  <=CASE  WHEN @VestDateTo   IS NULL THEN grantleg.VestingDate   ELSE @VestDateTo   END    
GROUP BY GrantOptions.EmployeeId, EmployeeMaster.EmployeeName, GrantLeg.VestingDate,  EmployeeMaster.DateOfTermination, GrantRegistration.ExercisePrice,
                      GrantRegistration.GrantDate
Order by GrantOptions.EmployeeId 
   	                  
		end	
		
		
			
END
GO
