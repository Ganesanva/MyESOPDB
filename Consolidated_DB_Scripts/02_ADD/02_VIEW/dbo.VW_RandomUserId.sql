/****** Object:  View [dbo].[VW_RandomUserId]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_RandomUserId]'))
EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[VW_RandomUserId]
(UserId )
AS
	SELECT ''GDPR''+CAST((RAND() * (899999) + 100000) AS VARCHAR) AS UserId;



' 
GO
