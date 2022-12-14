/****** Object:  StoredProcedure [dbo].[GetEmployeeGrantDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetEmployeeGrantDetails]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeGrantDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================
-- Author      : omprakash katre                                                        =
-- Description : This procedure will return employee grant details based on employeeid  =
-- EXEC GetEmployeeGrantDetails	'5000000002'	
-- ======================================================================================

CREATE PROCEDURE [dbo].[GetEmployeeGrantDetails]
   @Employeeid VARCHAR(20)	
AS
BEGIN
	SELECT s.schemetitle, 
       gr.schemeid, 
       REPLACE(CONVERT(VARCHAR(11), gr.grantdate, 106), ' ', '/') as grantdate,
       gr.grantregistrationid, 
       gl.grantoptionid, 
       Sum(gl.grantedoptions) AS grantedoptions, 
       em.employeename,
       (select ApprovalDate from ShareHolderApproval sha where sha.ApprovalId = s.ApprovalId) as ApprovalDate,
	   (select ValidUptoDate from ShareHolderApproval sha where sha.ApprovalId = s.ApprovalId) as ValidUptoDate
FROM   grantleg gl 
       INNER JOIN grantoptions gop 
               ON gop.grantoptionid = gl.grantoptionid 
       INNER JOIN grantregistration gr 
               ON gr.grantregistrationid = gop.grantregistrationid 
       INNER JOIN scheme s 
               ON s.schemeid = gr.schemeid 
       INNER JOIN employeemaster em 
               ON gop.employeeid = em.employeeid             
WHERE  gop.employeeid = @Employeeid 
        AND gop.grantoptionid  not in (Select ArGrantoptionid from AcceleratedRemarks accR where accR.ArGrantoptionid=gop.GrantOptionId )
        AND gl.FinalVestingDate>GETDATE()
   --      AND s.SchemeId  not in (Select SchemeId from AcceleratedVesting) 
   --      AND s.SchemeId not in 
   --      (
			--Select sa.SchemeId from ShAcceleratedVesting sa
			--inner join AcceleratedRemarks ar
			--on sa.AcceleratedVestingId=ar.ArAcceleratedVestingId
			--where ar.ArLevel=1
   --      ) 
GROUP  BY em.employeename, 
          s.schemetitle, 
          gr.schemeid, 
          gr.grantdate, 
          gr.grantregistrationid, 
          gl.grantoptionid,
          s.ApprovalId
END

GO
