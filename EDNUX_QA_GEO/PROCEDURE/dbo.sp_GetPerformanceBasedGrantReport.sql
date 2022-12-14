/****** Object:  StoredProcedure [dbo].[sp_GetPerformanceBasedGrantReport]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_GetPerformanceBasedGrantReport]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetPerformanceBasedGrantReport]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Arpita>
-- Create date: <29.8.2012>
-- Description:	<Performance Based Grant Mass upload>
--exec sp_GetPerformanceBasedGrantReport 'GOPerformance00'
-- =============================================

CREATE PROCEDURE [dbo].[sp_GetPerformanceBasedGrantReport] 
	-- Add the parameters for the stored procedure here
	@grantoptionid varchar(max)
AS
BEGIN

SET NOCOUNT ON;

Declare @display_as char(1)
SELECT @display_as = DisplayAs from BonusSplitPolicy

if(@display_as = 'C')
	BEGIN
		SELECT GrLg.grantoptionid AS 'Grant Option Id(Mandatory)', 
			   grantlegid         AS 'Grant Leg Id(Mandatory)', 
			   NULL               AS 'Number of Options Granted', 
			   ''                 AS 'Option Performance Percentage(%)', 
			   GrOp.employeeid    AS 'Employee Id(Mandatory)', 
			   ''                 AS 'Balance options (Mandatory) (C/T)', 
			   ''                 AS 'Transfer to grant leg No.', 
			   ''                 AS 'Cancellation Date', 
			   'N'				  AS 'Counter Id' ,
			   REPLACE(CONVERT(VARCHAR(11),GrLg.FinalVestingDate,106), ' ','-')  AS VestingDate
		FROM   grantleg GrLg 
			   JOIN grantoptions GrOp 
				 ON ( GrOp.grantoptionid = GrLg.grantoptionid 
					  AND GrOp.grantoptionid IN(SELECT Param FROM fn_MVParam(@grantoptionid,','))  ) 
			   JOIN vestingperiod VePe 
				 ON GrLg.grantregistrationid = VePe.grantregistrationid 
					AND GrLg.vestingperiodid = Vepe.vestingperiodid 
		WHERE  GrLg.grantoptionid IN(SELECT Param FROM fn_MVParam(@grantoptionid,','))  
			   AND GrLg.status = 'A' 
			   AND GrLg.isperfbased = 'N' 
			   AND GrLg.vestingtype = 'P' 
			   AND GrLg.expiryperformed IS NULL
			   AND GrLg.GrantedOptions <> GrLg.CancelledQuantity 
		GROUP  BY GrLg.grantoptionid, 
				  grantlegid,          
				  GrOp.employeeid ,GrLg.FinalVestingDate
		ORDER  BY GrLg.grantoptionid,grantlegid  
	END

ELSE
	BEGIN
		SELECT GrLg.grantoptionid AS 'Grant Option Id(Mandatory)', 
			   GrLg.grantlegid    AS 'Grant Leg Id(Mandatory)', 
			   NULL               AS 'Number of Options Granted', 
			   ''                 AS 'Option Performance Percentage(%)', 
			   GrOp.employeeid    AS 'Employee Id(Mandatory)', 
			   ''                 AS 'Balance options (Mandatory) (C/T)', 
			   ''                 AS 'Transfer to grant leg No.', 
			   ''                 AS 'Cancellation Date', 
			   GrLg.parent        AS 'Counter Id' ,
			   REPLACE(CONVERT(VARCHAR(11),GrLg.FinalVestingDate,106), ' ','-')  AS VestingDate
		FROM   grantoptions GrOp 
			   JOIN grantleg GrLg 
				 ON ( GrOp.grantoptionid = GrLg.grantoptionid 
					  AND GrOp.grantoptionid IN(SELECT Param FROM fn_MVParam(@grantoptionid,','))) 
			   JOIN vestingperiod VePe 
				 ON GrOp.grantregistrationid = VePe.grantregistrationid 
					AND GrOp.grantoptionid IN(SELECT Param FROM fn_MVParam(@grantoptionid,',')) 
					AND GrLg.isperfbased = 'N' 
					AND GrLg.status = 'A' 
					AND GrLg.vestingtype = 'P' 
					AND GrLg.expiryperformed IS NULL
					AND GrLg.GrantedOptions <> GrLg.CancelledQuantity 
		WHERE  Grlg.vestingperiodid = VePe.vestingperiodid 		
		ORDER  BY GrLg.grantoptionid,grantlegid, 
				  counter 

	END   
END
GO
