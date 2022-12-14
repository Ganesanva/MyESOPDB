/****** Object:  View [dbo].[VW_GrantLegDetails]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_GrantLegDetails]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[VW_GrantLegDetails] 
AS
	SELECT 
		GOPT.EmployeeId, GL.GrantApprovalId, GL.ID, GL.GrantLegId, GL.VestingType, GL.SeperationCancellationDate, GL.SeparationPerformed, 
		GL.GrantedOptions, GL.GrantedQuantity, GL.SplitQuantity, GL.BonusSplitQuantity, GL.CancelledQuantity, GL.SplitCancelledQuantity, 
		GL.BonusSplitCancelledQuantity, GL.ExercisedQuantity, GL.SplitExercisedQuantity, GL.BonusSplitExercisedQuantity, GL.ExercisableQuantity, 
		GL.LapsedQuantity, GL.UnapprovedExerciseQuantity, GL.FinalVestingDate, GL.FinalExpirayDate, GL.ExpiryPerformed, GL.GrantOptionId, GL.IsPerfBased, 
		EM.DateOfTermination, UM.IsUserActive, GOPT.ApprovalStatus, GL.[Status], GL.SchemeId, GL.VestingDate, UM.EmailId as EmployeeEmail,LWD, EM.EmployeeName, UM.UserId
	FROM  
		GrantOptions AS GOPT
		INNER JOIN GrantLeg AS GL ON GOPT.GrantOptionId = GL.GrantOptionId
		INNER JOIN EmployeeMaster AS EM ON GOPT.EmployeeId = EM.EmployeeID
		INNER JOIN UserMaster AS UM ON EM.EmployeeID = UM.EmployeeId
	WHERE GOPT.ApprovalStatus = ''A''
' 
GO
