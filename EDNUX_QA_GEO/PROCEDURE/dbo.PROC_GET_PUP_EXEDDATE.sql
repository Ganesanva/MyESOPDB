/****** Object:  StoredProcedure [dbo].[PROC_GET_PUP_EXEDDATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PUP_EXEDDATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PUP_EXEDDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_PUP_EXEDDATE]
AS
BEGIN
SELECT ExercisedDate, YearDate FROM
(
      SELECT '---ALL---' AS ExercisedDate, '---ALL---' AS YearDate
	  UNION 
      SELECT DISTINCT REPLACE(CONVERT(NVARCHAR,CAST(ExercisedDate AS DATETIME), 106), ' ', '-') AS ExercisedDate,
            CONVERT(NVARCHAR,CONVERT(DATE,ExercisedDate)) AS YearDate
      FROM Exercised Ex
            INNER JOIN GrantLeg GL
                  ON GL.ID = Ex.GrantLegSerialNumber
            INNER JOIN GrantRegistration GR
                  ON GR.GrantRegistrationId = GL.GrantRegistrationId
            INNER JOIN Scheme SC
                  ON GL.SchemeId = SC.SchemeId  
      WHERE SC.IsPUPEnabled = 1  AND Ex.Cash ='PUP'
)
FINALTABLE
ORDER BY  YearDate DESC
END



GO
