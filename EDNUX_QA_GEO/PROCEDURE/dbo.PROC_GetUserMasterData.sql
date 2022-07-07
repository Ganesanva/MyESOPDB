/****** Object:  StoredProcedure [dbo].[PROC_GetUserMasterData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetUserMasterData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetUserMasterData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GetUserMasterData] 
AS
BEGIN
	SET NOCOUNT ON;   
	SELECT UserId AS CCRName, PhoneNo, EmailId FROM UserMaster WHERE ISFUNDINGCCR=1;
END
GO
