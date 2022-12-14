/****** Object:  StoredProcedure [dbo].[SP_SOR_REPORT]    Script Date: 7/8/2022 3:00:41 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_SOR_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[SP_SOR_REPORT]    Script Date: 7/8/2022 3:00:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_SOR_REPORT]
(
@EmployeeID VARCHAR(20) = '',
@EmployeeName VARCHAR(75) = '',
@SchemeId VARCHAR(50) = '',
@Department VARCHAR(200)= '',
@Grade VARCHAR(200)= ''
)
AS
BEGIN
SELECT EM.EmployeeID,
EM.EmployeeName,
EM.Department,
EM.Grade,
GL.SchemeId,
EM.Entity,
SUM(SHE.ExercisedQuantity) as TotalExercisedQuantity,
EUD.DepositoryParticipantName as DepositoryParticipantNo,
EUD.DepositoryIDNumber,
EUD.ClientIDNumber

FROM
EmployeeMaster EM INNER JOIN
ShExercisedOptions SHE ON SHE.EmployeeID = EM.EmployeeID INNER JOIN
GrantLeg GL ON GL.ID = SHE.GrantLegSerialNumber LEFT OUTER JOIN
Transaction_Details TD ON SHE.ExerciseNo = TD.Sh_ExerciseNo INNER JOIN
Scheme SCH ON GL.SchemeId = SCH.SchemeId LEFT OUTER JOIN
Employee_UserDematDetails EUD ON EM.EmployeeID = EUD.EmployeeID
WHERE
EM.EmployeeID = (CASE @EmployeeID WHEN '' THEN EM.EmployeeID ELSE @EmployeeID END) AND
EM.EmployeeName = (CASE @EmployeeName WHEN '' THEN EM.EmployeeName ELSE @EmployeeName END) AND
GL.SchemeId = (CASE @SchemeId WHEN '' THEN GL.SchemeId ELSE @SchemeId END) AND
EM.Department = (CASE @Department WHEN '' THEN EM.Department ELSE @Department END) AND
EM.Grade = (CASE @Grade WHEN '' THEN EM.Grade ELSE @Grade END) AND
SCH.IsPUPEnabled = 0

GROUP BY
EM.EmployeeID,
EM.EmployeeName,
EM.Department,
EM.Grade,
GL.SchemeId,
EUD.DepositoryParticipantName,
EUD.DepositoryIDNumber,
EUD.ClientIDNumber,
EM.Entity
END
GO
