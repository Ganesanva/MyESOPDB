/****** Object:  StoredProcedure [dbo].[GetApproveDisapproveData]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetApproveDisapproveData]
GO
/****** Object:  StoredProcedure [dbo].[GetApproveDisapproveData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================
-- Author      : omprakash katre                                                        =
-- Description : This procedure will return employee grant details based on employeeid  =
-- EXEC GetApproveDisapproveData	
-- ======================================================================================

CREATE PROCEDURE [dbo].[GetApproveDisapproveData]
   
AS
BEGIN
   
SELECT   AR.ArAcceleratedVestingId as AccVestingId,
         REPLACE(CONVERT(VARCHAR(11), shA.AcceleratedVestingDate, 106), ' ', '/') as AcceleratedVestingDate,
         REPLACE(CONVERT(VARCHAR(11), shA.LastUpdatedOn, 106), ' ', '/') as LastUpdatedOn,
         
         CASE 
           WHEN AR.ArLevel =1 THEN  'Scheme' 
           WHEN AR.ArLevel=2 THEN 'Grant'
           WHEN AR.ArLevel=3 THEN  'Employee' 
           ELSE NULL 
         END AS level,
         
         
         CASE WHEN AR.ArLevel =1 THEN  s.SchemeTitle 
              WHEN AR.ArLevel=2 THEN AR.ArGrantRegid
              WHEN AR.ArLevel=3 THEN  AR.ArEmployeeId +' and '+em.EmployeeName 
              ELSE NULL 
          END AS levelParticular ,
         
         shA.LastUpdatedBy,s.SchemeTitle,
         AR.ArGrantRegid,AR.ArEmployeeId,AR.ArLevel
         
  FROM   ShAcceleratedVesting shA
  INNER JOIN AcceleratedRemarks AR
  ON AR.ArAcceleratedVestingId=shA.AcceleratedVestingId
  INNER JOIN Scheme s
  ON s.SchemeId=shA.SchemeId
  LEFT OUTER JOIN EmployeeMaster em
        ON em.EmployeeID= AR.ArEmployeeId 
  WHERE AR.ArIsShadow='Y'      
  order by ArLevel asc

END
GO
