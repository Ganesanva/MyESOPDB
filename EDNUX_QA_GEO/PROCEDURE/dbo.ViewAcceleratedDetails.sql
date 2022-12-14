/****** Object:  StoredProcedure [dbo].[ViewAcceleratedDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ViewAcceleratedDetails]
GO
/****** Object:  StoredProcedure [dbo].[ViewAcceleratedDetails]    Script Date: 7/6/2022 1:40:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================
-- Author      : omprakash katre                                                        =
-- Description : This procedure will return Accelerated data for approval process       =
-- EXEC ViewAcceleratedDetails 85	
-- ======================================================================================

CREATE PROCEDURE [dbo].[ViewAcceleratedDetails]
   @AccVestingId int
AS

BEGIN
  declare @arLevel int
  set @arLevel=(select ArLevel from AcceleratedRemarks where ArAcceleratedVestingId=@AccVestingId)
  
  --schemeLevel
   IF @arLevel=1
   BEGIN
     SELECT s.SchemeTitle,  REPLACE(CONVERT(VARCHAR(11), shA.AcceleratedVestingDate, 106), ' ', '/') as AcceleratedVestingDate,
            AR.ArLevel ,AR.ArRemarks FROM ShAcceleratedVesting shA
     INNER JOIN AcceleratedRemarks AR
        ON shA.AcceleratedVestingId=AR.ArAcceleratedVestingId
     INNER JOIN scheme s 
        ON s.schemeid = shA.SchemeId
     WHERE AR.ArLevel=1 AND AR.ArAcceleratedVestingId=@AccVestingId AND AR.ArIsShadow='Y'
   END
   
   --Grant Level
   ELSE IF @arLevel=2
   BEGIN
     SELECT s.SchemeTitle,  AR.ArRemarks,AR.ArGrantRegid, AR.ArLevel,
     REPLACE(CONVERT(VARCHAR(11), shA.AcceleratedVestingDate, 106), ' ', '/') as AcceleratedVestingDate,
     REPLACE(CONVERT(VARCHAR(11), AR.ArGrantDate, 106), ' ', '/') as ArGrantDate 
            FROM ShAcceleratedVesting shA
     INNER JOIN AcceleratedRemarks AR
        ON shA.AcceleratedVestingId=AR.ArAcceleratedVestingId
     INNER JOIN scheme s 
        ON s.schemeid = shA.SchemeId
     WHERE AR.ArLevel=2 AND AR.ArAcceleratedVestingId=@AccVestingId AND AR.ArIsShadow='Y'
   END
   
   --Employee Level
   ELSE IF @arLevel=3
   BEGIN
     SELECT s.SchemeTitle, AR.ArRemarks,AR.ArGrantRegid,AR.ArGrantoptionid,AR.ArEmployeeId,em.EmployeeName,AR.ArLevel, sum(gl.GrantedOptions) as GrantedOptions,
     REPLACE(CONVERT(VARCHAR(11), shA.AcceleratedVestingDate, 106), ' ', '/') as AcceleratedVestingDate,
     REPLACE(CONVERT(VARCHAR(11), AR.ArGrantDate, 106), ' ', '/') as ArGrantDate 
            FROM ShAcceleratedVesting shA
     INNER JOIN AcceleratedRemarks AR
        ON shA.AcceleratedVestingId=AR.ArAcceleratedVestingId
     INNER JOIN scheme s 
        ON s.schemeid = shA.SchemeId
     INNER JOIN EmployeeMaster em
        ON em.EmployeeID= AR.ArEmployeeId 
     INNER JOIN grantleg gl
        ON gl.GrantOptionId=AR.ArGrantoptionid
     WHERE AR.ArLevel=3 AND AR.ArAcceleratedVestingId=@AccVestingId AND AR.ArIsShadow='Y'
     
     GROUP  BY gl.GrantOptionId,
               s.SchemeTitle,
               AR.ArRemarks,
               AR.ArGrantRegid,
               AR.ArGrantoptionid,
               AR.ArEmployeeId,
               em.EmployeeName,
               shA.AcceleratedVestingDate,
               AR.ArLevel,
               AR.ArGrantDate
   END
END
GO
