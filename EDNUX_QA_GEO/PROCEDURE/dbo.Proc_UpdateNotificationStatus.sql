/****** Object:  StoredProcedure [dbo].[Proc_UpdateNotificationStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_UpdateNotificationStatus]
GO
/****** Object:  StoredProcedure [dbo].[Proc_UpdateNotificationStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_UpdateNotificationStatus]
( 
		@UserId VarChar(20),
		@NotificationId int,
		@ActionName Varchar(20) = null
)
AS
BEGIN
	 SET NOCOUNT ON;	
	 BEGIN
	    /****** Update as Read Notification ***** */
		IF(UPPER(@ActionName) = 'READ')
		BEGIN
			UPDATE  UserNotificationDetails 
			SET UND_VIEW_DATE= GETDATE(), UPDATED_BY = @UserId, UPDATED_ON = GetDate()
			WHERE UserId = @UserId AND UND_ID = @NotificationId
			IF @@ROWCOUNT > 0
			SELECT '1' AS STATUS, 'Notification read successfully.' AS MESSAGE
		END

		 /****** Update as Sent Notification ***** */
  --      IF(UPPER(@ActionName) = 'SENT')
		--BEGIN
		--	UPDATE  UserNotificationDetails 
		--	SET UND_STATUS = 2, UPDATED_BY = @UserId, UPDATED_ON = GetDate()
		--	WHERE UserId = @UserId AND UND_ID = @NotificationId
		--	IF @@ROWCOUNT > 0
		--	SELECT '1' AS STATUS, 'Notification sent successfully.' AS MESSAGE
		--END
	 END
	 SET NOCOUNT OFF;	
END
GO
