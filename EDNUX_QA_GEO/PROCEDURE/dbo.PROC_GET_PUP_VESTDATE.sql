/****** Object:  StoredProcedure [dbo].[PROC_GET_PUP_VESTDATE]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_PUP_VESTDATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_PUP_VESTDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_PUP_VESTDATE]
AS
BEGIN
SELECT VestingDate, YearDate,GrantDate FROM
(     
	SELECT '---ALL---' AS VestingDate, '---ALL---' AS YearDate, '---ALL---' AS GrantDate
	UNION 
	SELECT  DISTINCT REPLACE(CONVERT(NVARCHAR,CAST(FinalVestingDate AS DATETIME), 106), ' ', '-') AS VestingDate,
            REPLACE(CONVERT(NVARCHAR(10),FinalVestingDate,111),'/','-') AS YearDate,
            CONVERT(NVARCHAR,CONVERT(DATE,GR.GrantDate)) AS GrantDate
      FROM GrantLeg GL
            INNER JOIN Scheme SC 
                  ON SC.SchemeId = GL.SchemeId 
            INNER JOIN GrantRegistration GR
                  ON GL.GrantRegistrationId = GR.GrantRegistrationId
      WHERE IsPUPEnabled='1' 
)
FINALTABLE
ORDER BY YearDate DESC
END
GO
