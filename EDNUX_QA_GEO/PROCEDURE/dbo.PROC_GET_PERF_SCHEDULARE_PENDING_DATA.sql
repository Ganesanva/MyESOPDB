/****** Object:  StoredProcedure [dbo].[PROC_GET_PERF_SCHEDULARE_PENDING_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PERF_SCHEDULARE_PENDING_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PERF_SCHEDULARE_PENDING_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Sneha Pawar>
-- Create date: <04/Feb/2021>
-- Description:	<Get Pending performance data for auto execution>
--exec PROC_GET_PERF_SCHEDULARE_PENDING_DATA 
-- =============================================

CREATE PROCEDURE [dbo].[PROC_GET_PERF_SCHEDULARE_PENDING_DATA] 
	-- Add the parameters for the stored procedure here
	 
AS
BEGIN

SET NOCOUNT ON;

Declare @display_as char(1)
SELECT @display_as = DisplayAs from BonusSplitPolicy

if(@display_as = 'C')
	BEGIN
		SELECT GrLg.grantoptionid AS 'Grant Option Id ', 
			   Sh.grantlegid         AS 'Grant Leg Id ', 
			   sh.NumberOfOptionsGranted AS 'Number of Options Granted', 
			   sh.CancelledPercentage    AS 'Option Performance Percentage(%)', 
			   Sh.employeeid    AS 'Employee Id ', 
			   CASE WHEN Sh.CancellationReason IS NOT NULL THEN 'C' ELSE 'T' END   AS 'Balance options   (C/T)', 
			   sh.TransferToGrantLegId  AS 'Transfer to grant leg No.', 
			   REPLACE(CONVERT(VARCHAR(11),sh.CancellationDate ,106), ' ','-')  AS 'Cancellation Date', 
			   'N'	  AS 'Counter Id' ,
			   REPLACE(CONVERT(VARCHAR(11),GrLg.FinalVestingDate,106), ' ','-')  AS VestingDate
		FROM   ShPerformanceBasedGrant Sh  JOIN
			   grantleg GrLg 
				ON GrLg.GrantOptionId =Sh.GrantOptionId AND Grlg.GrantLegId = Sh.GrantLegId
				--AND GrLg.isperfbased = 'N'	AND GrLg.status = 'A' 
				--AND GrLg.vestingtype = 'P' 	AND GrLg.expiryperformed IS NULL
				--AND GrLg.GrantedOptions <> GrLg.CancelledQuantity 
		WHERE   ISNULL(Sh.IsApproved,0) = 1 AND 
				CONVERT(DATE, Sh.CancellationDate ) > CONVERT(DATE, GETDATE() )	
			    
		GROUP  BY GrLg.grantoptionid, 
				  Sh.grantlegid,  sh.NumberOfOptionsGranted,        
				  Sh.employeeid ,GrLg.FinalVestingDate,sh.CancelledPercentage,Sh.CancellationReason,sh.TransferToGrantLegId,sh.CancellationDate
		ORDER  BY GrLg.grantoptionid,Sh.grantlegid  
	END

ELSE
	BEGIN
		SELECT SH.grantoptionid AS 'Grant Option Id ', 
			   GrLg.grantlegid    AS 'Grant Leg Id ', 
			   sh.NumberOfOptionsGranted   AS 'Number of Options Granted', 
			   sh.CancelledPercentage                 AS 'Option Performance Percentage(%)', 
			   Sh.EmployeeId    AS 'Employee Id(Mandatory)', 
			   CASE WHEN Sh.CancellationReason IS NOT NULL THEN 'C' ELSE 'T' END AS 'Balance options   (C/T)', 
			   sh.TransferToGrantLegId  AS 'Transfer to grant leg No.', 
			   REPLACE(CONVERT(VARCHAR(11),sh.CancellationDate ,106), ' ','-')   AS 'Cancellation Date', 
			   GrLg.parent        AS 'Counter Id' ,
			   REPLACE(CONVERT(VARCHAR(11),GrLg.FinalVestingDate,106), ' ','-')  AS VestingDate
		FROM   ShPerformanceBasedGrant Sh  JOIN
			   grantleg GrLg 
				ON GrLg.GrantOptionId =Sh.GrantOptionId AND Grlg.GrantLegId = Sh.GrantLegId
				--AND GrLg.isperfbased = 'N'	AND GrLg.status = 'A' 
				--AND GrLg.vestingtype = 'P' 	AND GrLg.expiryperformed IS NULL
				--AND GrLg.GrantedOptions <> GrLg.CancelledQuantity 
		WHERE  ISNULL(Sh.IsApproved,0) = 1 AND CONVERT(DATE, Sh.CancellationDate ) > CONVERT(DATE, GETDATE() )		
		ORDER  BY GrLg.grantoptionid,Sh.GrantLegId,  
				  GrLg.counter 
				
				 
		
	END   
END
GO
