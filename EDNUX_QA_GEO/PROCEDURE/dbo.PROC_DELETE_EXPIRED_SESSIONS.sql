/****** Object:  StoredProcedure [dbo].[PROC_DELETE_EXPIRED_SESSIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DELETE_EXPIRED_SESSIONS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DELETE_EXPIRED_SESSIONS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DELETE_EXPIRED_SESSIONS]
AS

BEGIN

	SET NOCOUNT ON;
	
	DELETE FROM UserSessions WHERE ExpireOn < GETDATE()
		
	SET NOCOUNT OFF;

END
GO
