/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_ACTIVITY_DETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_ALL_ACTIVITY_DETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_ALL_ACTIVITY_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_ALL_ACTIVITY_DETAILS]
(
	@USER_ID		VARCHAR(20)	
)
AS
BEGIN    
	SET NOCOUNT ON; 
		
	SELECT * ,CASE 
		 WHEN  CreateDate  >= GETDATE() THEN 'Upcoming' 
		 ELSE 'Past' 
		 END AS ActivityStatus
	 FROM ActivitiesMaster 
	 WHERE EmployeeID=@USER_ID
        
	 SET NOCOUNT OFF;    
END
GO
