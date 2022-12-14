/****** Object:  StoredProcedure [dbo].[AccVestingAuditTrail]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[AccVestingAuditTrail]
GO
/****** Object:  StoredProcedure [dbo].[AccVestingAuditTrail]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================
-- Author      : omprakash katre                                                        =
-- Description : This procedure will return Accelerated vesing audit trail data         =
-- EXEC AccVestingAuditTrail	
-- ======================================================================================

CREATE PROCEDURE [dbo].[AccVestingAuditTrail]
   
AS
BEGIN
  SELECT Replace(CONVERT(VARCHAR(11), av.acceleratedvestingdate, 106), ' ', '-')AS 
         AcceleratedVestingDate, 
         av.lastupdatedby, 
       CASE 
         WHEN ar.arlevel = 1 THEN 'Scheme' 
         WHEN ar.arlevel = 2 THEN 'Grant' 
         WHEN ar.arlevel = 3 THEN 'Employee' 
         ELSE NULL 
       END  AS level, 
       
       CASE 
         WHEN ar.arlevel = 1 THEN av.schemeid 
         WHEN ar.arlevel = 2 THEN ar.argrantregid 
         WHEN ar.arlevel = 3 THEN ar.aremployeeid 
         ELSE NULL 
       END  AS levelParticular 
       
FROM   acceleratedvesting av 
       INNER JOIN acceleratedremarks ar 
               ON av.acceleratedvestingid = ar.aracceleratedvestingid 
WHERE  ar.arisshadow = 'N' 
ORDER  BY ar.arlevel ASC 


END
GO
