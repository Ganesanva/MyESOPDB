/****** Object:  StoredProcedure [dbo].[PROC_GET_FUTURE_DUE_PERFORMANCE_DATA]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_FUTURE_DUE_PERFORMANCE_DATA]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_FUTURE_DUE_PERFORMANCE_DATA]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_FUTURE_DUE_PERFORMANCE_DATA]
AS
BEGIN
	
	SELECT EmployeeId AS [EmployeeId],SchemeId,GrantOptionId AS [GrantOptionID],GrantLegId AS [GrantLegId],CancellationDate,REPLACE(CONVERT(VARCHAR,CancellationDate,106), ' ','-') AS [Dateofvesting],CancelledOptions,CancelledQuantity,CancelledPercentage,CancellationReason,
		   Counter,AvailableOptionsPer,NumberOfOptionsAvailable,NumberOfOptionsGranted,Action,TransferToGrantLegId,NumberOfOptionsTransferred ,
		   CASE WHEN CONVERT(DATE,CANCELLATIONDATE) <= CONVERT(DATE,GETDATE()) THEN 1 ELSE 0 END  AS ENABLECHKBOX  
	FROM   SHPERFORMANCEBASEDGRANT 
	WHERE  ISNULL(ISAPPROVED,0) = 1 AND CONVERT(DATE,CANCELLATIONDATE) <= CONVERT(DATE,GETDATE())		

	 SELECT  DISTINCT CONVERT(DATE,ISNULL(EMP.DateOfTermination,null)) AS DateOfTermination ,GOP.GrantOptionId,EMP.EmployeeID 
	 FROM    EmployeeMaster EMP
			INNER JOIN GrantOptions GOP ON EMP.EmployeeID = GOP.EmployeeId
		    AND EMP.DateOfTermination IS NOT NULL 

	 SELECT  DISTINCT   GrLg.GrantLegId,GOP.GrantOptionID,GOP.EmployeeId,GrLg.VestingType,
			  (GrLg.GrantedOptions - (GrLg.CancelledQuantity + GrLg.LapsedQuantity + GrLg.ExercisableQuantity + GrLg.ExercisedQuantity  + GrLg.UnapprovedExerciseQuantity) ) as Exercissable
	 FROM    GrantOptions GOP
		     INNER JOIN GrantLeg GrLg  ON GrLg.GrantOptionId = GOP.GrantOptionId
	         LEFT JOIN EmployeeMaster EMP ON EMP.EmployeeID = GOP.EmployeeId  AND EMP.DateOfTermination IS NOT NULL
	 
  
END

 
GO
