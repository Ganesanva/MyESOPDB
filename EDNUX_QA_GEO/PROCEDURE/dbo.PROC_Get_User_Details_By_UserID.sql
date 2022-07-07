/****** Object:  StoredProcedure [dbo].[PROC_Get_User_Details_By_UserID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_Get_User_Details_By_UserID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_Get_User_Details_By_UserID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_Get_User_Details_By_UserID]
@UserID VARCHAR(100)
AS
BEGIN
      SELECT * FROM
	  UserMaster
	  WHERE UserId=@UserID
END  
GO
