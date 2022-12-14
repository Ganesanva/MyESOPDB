/****** Object:  StoredProcedure [dbo].[SP_Online_Exercise_Details_Report]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_Online_Exercise_Details_Report]
GO
/****** Object:  StoredProcedure [dbo].[SP_Online_Exercise_Details_Report]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATe PROCEDURE [dbo].[SP_Online_Exercise_Details_Report]
	(
		@EMPLOYEEID VARCHAR(50)
	)
AS
BEGIN
	--Fetching data from ShexercisedOptions
	select gr.GrantDate, sch.SchemeTitle,gl.GrantOptionId,
	shex.ExercisePrice,shex.ExerciseDate,shex.ExerciseNo,shex.ExerciseId,
	ShEx.ExercisedQuantity,
	( ( Shex.exercisedquantity) * max(sch.optionratiodivisor ) / max( sch.optionratiomultiplier ) ) AS exercisablequantity,
	SUM(gl.bonussplitquantity)  AS grantedoptions  
	from GrantLeg GL
	inner join ShExercisedOptions Shex on shex.GrantLegSerialNumber=GL.ID
	inner join  GrantOptions GOP on GOP.GrantOptionId=gl.GrantOptionId
	inner join GrantRegistration GR on gr.GrantRegistrationId=gop.GrantRegistrationId
	inner join Scheme sch on sch.SchemeId=gl.SchemeId
	inner join EmployeeMaster em on em.EmployeeID=shex.EmployeeID
	And EM.LoginId = @EMPLOYEEID And shex.ismassupload='N' 
	GROUP  BY shex.exerciseid,shex.exercisedquantity,shex.exerciseno,shex.exercisedate,  
	shex.exerciseprice,gl.grantoptionid,gr.grantdate,sch.schemetitle

END
GO
