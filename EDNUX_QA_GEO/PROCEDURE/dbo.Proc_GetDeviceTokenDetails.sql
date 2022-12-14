/****** Object:  StoredProcedure [dbo].[Proc_GetDeviceTokenDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_GetDeviceTokenDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_GetDeviceTokenDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Proc_GetDeviceTokenDetails]
( 
		@UserId VarChar(20) 	
)
AS
BEGIN
	 SET NOCOUNT ON;	
	 BEGIN
	  SELECT UserId, DeviceTokenKey FROM DeviceTokenInfo WHERE UserId = @UserId AND IsActive =1
	 END
	 SET NOCOUNT OFF;	
END
GO
