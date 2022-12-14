/****** Object:  StoredProcedure [dbo].[PROC_Get_PUP_PayoutDate]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_Get_PUP_PayoutDate]
GO
/****** Object:  StoredProcedure [dbo].[PROC_Get_PUP_PayoutDate]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_Get_PUP_PayoutDate]
AS
BEGIN
SELECT PayoutDate, YearDate,GrantDate,VestDate FROM
(
	  SELECT '---ALL---' AS PayoutDate, '---ALL---' AS YearDate, '---ALL---' AS GrantDate, '---ALL---' AS VestDate
	  UNION 
	  SELECT DISTINCT REPLACE(CONVERT(NVARCHAR,CAST(SharesIssuedDate AS DATETIME), 106), ' ', '-') AS PayoutDate,
			 CONVERT(NVARCHAR,CONVERT(DATE,SharesIssuedDate)) AS YearDate,
			 CONVERT(NVARCHAR,CONVERT(DATE,GR.GrantDate)) AS GrantDate,
			 CONVERT(NVARCHAR,CONVERT(DATE,GL.VestingDate)) AS VestDate
	  FROM  Exercised Ex
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
