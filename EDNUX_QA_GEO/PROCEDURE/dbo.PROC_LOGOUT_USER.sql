/****** Object:  StoredProcedure [dbo].[PROC_LOGOUT_USER]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_LOGOUT_USER]
GO
/****** Object:  StoredProcedure [dbo].[PROC_LOGOUT_USER]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_LOGOUT_USER]
(
@USER_ID VARCHAR(100) = NULL,
@IS_LOGOUT VARCHAR(10)= NULL,
@Token nvarchar(max)=null
)
AS
IF(@IS_LOGOUT = 'Y')
BEGIN
IF EXISTS(SELECT TOP 1 ISNULL((LoginDate),GetDATE() ) AS LoginDate FROM UserLoginHistory WHERE UserId = @USER_ID ORDER BY LoginDate DESC)
BEGIN
UPDATE UserLoginHistory set LogOutDate=GETDATE() where UserId =@USER_ID and LoginDate=(select MAX(LoginDate)from UserLoginHistory where UserId=@USER_ID)
--UPDATE UserMaster SET InvalidLoginAttempt = 0 WHERE (UserId = @USER_ID)
DELETE FROM UserSessions WHERE UserId = @USER_ID

END
Insert ESOPManager..Mst_BlackListtoken(UserId,Jwt_Token,LogOutDate) values(@USER_ID,@Token,GETDATE());
DELETE FROM UserSessions WHERE UserId = @USER_ID
END
GO
