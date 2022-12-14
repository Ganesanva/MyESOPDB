/****** Object:  StoredProcedure [dbo].[proc_getExercsieDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[proc_getExercsieDetails]
GO
/****** Object:  StoredProcedure [dbo].[proc_getExercsieDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[proc_getExercsieDetails] @ExercsieNo numeric (18,0)
As
Begin

---getting maximum nuber of options exercisable at the time of exercise
select * into #temp1 from (
		select GrantDate,GrantOptionid,FinalVestingDate,SUM(ExerciableQuantity) as ExercisableOptions
							from ExerciseableData where exerciseno = @ExercsieNo group by FinalVestingDate,GrantOptionid,GrantDate
							
						 ) as ex				 
---getting grnated options
select * into #temp2 from(
				select GrantOptionId,SUM(grantedoptions)AS optionsgranted  from GrantLeg 
						where GrantOptionId in (select GrantOptionId FROM   grantleg WHERE  id 
												IN (SELECT grantlegserialnumber FROM   shexercisedoptions WHERE  exerciseno =@ExercsieNo))
			   group by GrantOptionId )as gr
----getting exercise info & tax details  
select * into #temp3 from(           			
SELECT GrantRegistration.GrantDate,
		grantleg.GrantOptionId,
    	grantleg.finalvestingdate,
		SUM(shexercisedoptions.ExercisedQuantity) AS ExercisedQuantity, 
        shexercisedoptions.exerciseprice, 
        SUM(shexercisedoptions.ExercisedQuantity)*shexercisedoptions.ExercisePrice as totalamtpaid,
        MAX(Isnull(fmvprice, 0))      AS fmv, 
        equperqtax= CASE 
                     WHEN SUM(Isnull(perqstpayable, 0)) > 0 THEN 
                     SUM(Isnull(perqstpayable, 0)) / sum(shexercisedoptions.ExercisedQuantity)
                     ELSE 0 
                   END, 
       SUM(Isnull(perqstpayable, 0)) AS perqstpayable 
FROM   shexercisedoptions 
       INNER JOIN grantleg
        
         ON shexercisedoptions.grantlegserialnumber = grantleg.id  
       INNER JOIN GrantRegistration 
       on GrantLeg.GrantRegistrationId =GrantRegistration.GrantRegistrationId
    where shexercisedoptions.exerciseno=@ExercsieNo
  group by grantleg.finalvestingdate,shexercisedoptions.exerciseprice,grantleg.grantoptionid,GrantRegistration.GrantDate
  
  )as exdt
  
  
  select #temp3.GrantOptionId,#temp3.GrantDate,#temp3.FinalVestingDate as vestingdate,#temp3.ExercisedQuantity,
		  #temp3.ExercisePrice,#temp3.totalamtpaid,#temp3.fmv as fmvprice,#temp3.equperqtax,#temp3.perqstpayable,#temp1.ExercisableOptions,#temp2.optionsgranted as NoOfgrantedoptions
				 from #temp3 inner join #temp1
				on #temp3.GrantDate=#temp1.GrantDate AND #temp3.GrantOptionId=#temp1.GrantoptionID AND #temp3.FinalVestingDate=#temp1.FinalVestingDate
				inner join #temp2
				on #temp3.GrantOptionId=#temp2.GrantOptionId


END
GO
