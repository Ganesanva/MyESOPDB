/****** Object:  StoredProcedure [dbo].[PROC_GETGRANTREGSCHEME]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETGRANTREGSCHEME]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETGRANTREGSCHEME]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETGRANTREGSCHEME]
@EmployeeId VARCHAR(50)
AS
BEGIN	
	SET NOCOUNT ON;
		SELECT DISTINCT UserId, GOP.SchemeId,GOP.GrantRegistrationId,CIM.MIT_ID FROM GrantLeg AS GL
                        INNER JOIN GrantOptions AS GOP ON GL.GrantOptionId = GOP.GrantOptionId
                        INNER JOIN Scheme AS SC ON SC.SchemeId = GL.SchemeId
                        INNER JOIN COMPANY_INSTRUMENT_MAPPING AS CIM ON CIM.MIT_ID = SC.MIT_ID
                        INNER JOIN UserMaster AS UM ON GOP.EmployeeId = UM.EmployeeId
                        INNER JOIN EmployeeMaster AS EM ON EM.EmployeeID = UM.EmployeeId
						WHERE UM.UserId=@EmployeeID and EM.Deleted=0
		
	SET NOCOUNT OFF;	
END
GO
