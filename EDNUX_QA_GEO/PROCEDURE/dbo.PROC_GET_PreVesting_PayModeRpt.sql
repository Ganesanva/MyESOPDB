/****** Object:  StoredProcedure [dbo].[PROC_GET_PreVesting_PayModeRpt]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PreVesting_PayModeRpt]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PreVesting_PayModeRpt]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_PreVesting_PayModeRpt]
 AS
 BEGIN
	SET NOCOUNT ON;
 	
  	SELECT
  		(CASE WHEN( ISNULL(CIM.INS_DISPLY_NAME,'') = '') THEN MAX (MST.INSTRUMENT_NAME) ELSE MAX (CIM.INS_DISPLY_NAME) END) AS 'INSTRUMENT_NAME', 
  		 SCH.SchemeTitle, EMP.EmployeeID, EM.EmployeeName, GR.GrantDate AS [Grant Date], GR.GrantRegistrationId, GL.GrantOptionId,
  		 GL.VestingDate  AS [Vesting Date], EMP.ExercisedQuantity, PM.Id AS [Payment Mode Id], PM.PayModeName AS [Payment Mode Name], 
  		 CONVERT(DATE, EMP.createdOn,103) AS [Date Of Selection], REPLACE(CONVERT(VARCHAR(50), GR.GrantDate, 106), ' ', '-') AS [GRANT DATE], 
  		 REPLACE(CONVERT(VARCHAR(50), GL.VestingDate, 106), ' ', '-') AS [VESTING DATE]
  	FROM 
         EmpPrePaySelection AS EMP	 		
 		 INNER JOIN GrantLeg 	 	 	    	AS GL  ON Emp.GrantLegSerialNumber = GL.ID
 		 INNER JOIN EmployeeMaster 		 		AS EM  ON Emp.EmployeeId = EM.EmployeeId  
 		 INNER JOIN GrantRegistration		 	AS GR  ON GL.GrantRegistrationId = GR.GrantRegistrationId  
		 INNER JOIN SCHEME 		  	 			AS SCH ON GL.SchemeId = SCH.SchemeId  
		 INNER JOIN COMPANY_INSTRUMENT_MAPPING  AS CIM ON SCH.MIT_ID = CIM.MIT_ID
         INNER JOIN MST_INSTRUMENT_TYPE         AS MST ON CIM.MIT_ID = MST.MIT_ID    
         INNER JOIN PaymentMaster			    AS PM  ON EMP.PaymentMode = PM.Id         
	GROUP BY 
		 CIM.INS_DISPLY_NAME, SCH.SchemeTitle, EMP.EmployeeID, EM.EmployeeName, GR.GrantDate, GR.GrantRegistrationId,
		 GL.GrantOptionId, GL.VestingDate, EMP.ExercisedQuantity, PM.Id, PM.PayModeName, EMP.createdOn
	SET NOCOUNT OFF;
END
GO
