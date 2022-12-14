/****** Object:  StoredProcedure [dbo].[PROC_GetTRCData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetTRCData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetTRCData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GetTRCData] 	
AS
BEGIN	
	SELECT * FROM
	(
		SELECT DISTINCT 
				EmployeeID, CONVERT(VARCHAR(150),ExerciseNo) AS ExerciseNo, 
				(CASE	WHEN IsForm10FReceived = 0 THEN 'N'
						WHEN IsForm10FReceived = 1 THEN 'Y'
						WHEN IsForm10FReceived = 2 THEN 'D' 
				 END) AS IsForm10FReceived, 
				 Form10FReceivedDate,
				(CASE	WHEN IsTRCFormReceived = 0 THEN 'N'
						WHEN IsTRCFormReceived = 1 THEN 'Y'
						WHEN IsTRCFormReceived = 2 THEN 'D' 
				 END) AS IsTRCFormReceived, 
				TRCFormReceivedDate, TRCFormReceivedUpdatedBy, TRCFormReceivedUpdatedOn 
			FROM 
				SHEXERCISEDOPTIONS	
			
		UNION ALL

		SELECT DISTINCT 
				GOP.EmployeeID, CONVERT(VARCHAR(150),EX.ExerciseNo) AS ExerciseNo, 
				(CASE	WHEN EX.IsForm10FReceived = 0 THEN 'N'
						WHEN EX.IsForm10FReceived = 1 THEN 'Y'
						WHEN EX.IsForm10FReceived = 2 THEN 'D' 
				 END) AS IsForm10FReceived, 
				 EX.Form10FReceivedDate,
				(CASE	WHEN EX.IsTRCFormReceived = 0 THEN 'N'
						WHEN EX.IsTRCFormReceived = 1 THEN 'Y'
						WHEN EX.IsTRCFormReceived = 2 THEN 'D' 
				 END) AS IsTRCFormReceived, 
				EX.TRCFormReceivedDate, EX.TRCFormReceivedUpdatedBy, EX.TRCFormReceivedUpdatedOn 
			FROM 
				EXERCISED EX
				INNER JOIN GRANTLEG GL ON GL.ID = EX.GrantLegSerialNumber
				INNER JOIN GRANTOPTIONS GOP ON GOP.GrantOptionId = GL.GrantOptionId
	) 
	AS FINAL_OUTPUT		
	ORDER BY TRCFormReceivedDate DESC, ExerciseNo DESC, EmployeeID	
END
GO
