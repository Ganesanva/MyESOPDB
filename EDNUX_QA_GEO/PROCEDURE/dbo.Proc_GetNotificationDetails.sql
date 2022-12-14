/****** Object:  StoredProcedure [dbo].[Proc_GetNotificationDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_GetNotificationDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetNotificationDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_GetNotificationDetails]
( 
		@UserId VarChar(20),
		@PageNumber int =1
)
AS
BEGIN
	 SET NOCOUNT ON;
	
	  BEGIN
		  DECLARE @NotificationCount nvarchar(10)
		  DECLARE @UnReadCount nvarchar(10)		
		
		  SELECT UND.UND_ID as NotificationId, NTF.NTF_TITLE  as Title, UND.NTF_DESCRIPTION as [Description] , NTFE.NTF_EVENT as [Event] 
		  , NTFT.NTF_TYPE as EventType, NSH.NTF_EVT_START_DATE as StartDate,  NSH.NTF_EVT_END_DATE as EndDate, UND.UND_RECEIVE_DATE as ReceiveDate, UND.UND_VIEW_DATE as ReadDate,	
		  (case when NTFT.NTF_TYPE_ID = '1' then 'Demat' when NTFT.NTF_TYPE_ID = '2' then 'E-Grant' when NTFT.NTF_TYPE_ID = '3' then 'Nomination' 
		   when NTFT.NTF_TYPE_ID = '4' or  NTFT.NTF_TYPE_ID = '5' then 'Exercise' else '' end) as NotificationName 
		  FROM UserNotificationDetails  UND
		  LEFT JOIN NotificationSchedule  NSH on NSH.NTF_SCH_ID = UND.NTF_SCH_ID
		  LEFT JOIN InstrumentwiseNotification INTF on INTF.MIT_NTF_ID = NSH.MIT_NTF_ID
		  LEFT JOIN NotificationDetails NTF on NTF.NTF_ID = INTF.NTF_ID
		  LEFT JOIN NotificationEvent NTFE on NTFE.NTF_EVT_ID = NSH.NTF_EVT_ID
		  LEFT JOIN NotificationType NTFT on NTFT.NTF_TYPE_ID = NTF.NTF_TYPE_ID
		  WHERE UND.UserId = @UserId AND NTF.NTF_ACTIVE =1 AND UND.UND_STATUS =1 
		  order by UND.UND_ID desc
		  OFFSET ISNULL(((10 * @PageNumber) -10),1) rows
		  FETCH NEXT 10 ROWS ONLY

		  SELECT  @NotificationCount = Count(*)  FROM UserNotificationDetails  WHERE UserId = @UserId AND UND_STATUS =1
		  SELECT  ISNULL(@NotificationCount,0) as TotalNotificationCount

		  SELECT  @UnReadCount = Count(*)  FROM UserNotificationDetails  WHERE UserId = @UserId AND UND_STATUS =1 AND UND_VIEW_DATE IS NULL
		  SELECT  ISNULL(@UnReadCount,0) as UnReadCount
		  
	 END
	 SET NOCOUNT OFF;	
END
GO
