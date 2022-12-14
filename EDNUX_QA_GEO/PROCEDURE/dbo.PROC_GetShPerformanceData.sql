/****** Object:  StoredProcedure [dbo].[PROC_GetShPerformanceData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetShPerformanceData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetShPerformanceData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetShPerformanceData] 
 
AS
BEGIN
	
	CREATE TABLE #TEMP (FinalVestingDate Datetime,GrantOptionId VARCHAR(100),GrantLegId Decimal (10,0),VestingType CHAR(5))
	INSERT INTO #TEMP (FinalVestingDate ,GrantOptionId,GrantLegId,VestingType)
	Select Distinct FinalVestingDate,GrantOptionId,GrantLegId,VestingType from GrantLeg GL 
 
	SELECT   EmployeeId,SH.SchemeId,SH.GrantOptionId,SH.GrantLegId,SH.CancellationDate,CancelledOptions,SH.CancelledQuantity,CancelledPercentage,SH.CancellationReason,SH.Counter,AvailableOptionsPer,NumberOfOptionsAvailable,NumberOfOptionsGranted,Action,TransferToGrantLegId,NumberOfOptionsTransferred,
	CASE WHEN CONVERT(DATE, SH.CancellationDate) <= CONVERT(DATE, GETDATE()) THEN 1 ELSE 0 END AS EnableChkBox ,
	CASE WHEN(GL.FinalVestingDate >= sh.CancellationDate AND sh.CancellationDate <= GETDATE()) Then 'ImmediateUpload' 
	WHEN(GL.FinalVestingDate= sh.CancellationDate AND sh.CancellationDate >= GETDATE()) THen 'OnVestingDate' END AS ImpactExecution 
	from ShPerformanceBasedGrant SH 
	INNER JOIN #TEMP GL ON GL.GrantOptionId = sh.GrantOptionId AND GL.GrantLegId = sh.GrantLegId 
    WHERE IsMassUpload = 'Y' AND ISNULL(IsApproved,0) = 0 AND Gl.VestingType ='P'
	
	DROP table #TEMP
	
	SET NOCOUNT OFF;
END
GO
