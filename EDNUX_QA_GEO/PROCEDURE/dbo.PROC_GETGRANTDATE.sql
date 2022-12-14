/****** Object:  StoredProcedure [dbo].[PROC_GETGRANTDATE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETGRANTDATE]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETGRANTDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GETGRANTDATE]
AS
BEGIN
SELECT GrantDate,YearDate,SchemeID  FROM
(
	SELECT '---ALL---' AS GrantDate, '---ALL---' AS YearDate,'---ALL---' AS SchemeID
	UNION 
	SELECT 
		DISTINCT REPLACE(CONVERT(NVARCHAR,CAST(GrantDate AS DATETIME), 106), ' ', '-') AS GrantDate,
		CONVERT(NVARCHAR,CONVERT(DATE,GrantDate)) AS YearDate,
		Sc.SchemeId AS SchemeID
	FROM GrantRegistration GR
		 INNER JOIN Scheme SC 
		 ON SC.SchemeId = GR.SchemeId 
	WHERE IsPUPEnabled='1' 
)FINALTABLE
ORDER BY YearDate DESC
END
GO
