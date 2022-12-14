/****** Object:  StoredProcedure [dbo].[Proc_InsertDeviceTokenDetails]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_InsertDeviceTokenDetails]
GO
/****** Object:  StoredProcedure [dbo].[Proc_InsertDeviceTokenDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Proc_InsertDeviceTokenDetails]
( 
		@UserId VARCHAR(20) ,
		@DeviceTokenKey NVARCHAR(500) ,	
		@IsActive TINYINT = NULL					
)
AS
BEGIN
	 SET NOCOUNT ON;
	
	 IF NOT EXISTS(select DeviceTokenKey FROM DeviceTokenInfo WHERE UserId = @UserId AND DeviceTokenKey = @DeviceTokenKey)
     BEGIN
	     INSERT INTO DeviceTokenInfo
            (UserId
            ,DeviceTokenKey
			,IsActive
			,CREATED_BY
			,CREATED_ON
			,UPDATED_BY
			,UPDATED_ON
			)
            SELECT
			@UserId
           ,@DeviceTokenKey
		   ,@IsActive
		   ,@UserId
		   ,GetDate()
		   ,@UserId
		   ,GetDate()
	 END

	 IF  @@ROWCOUNT >0
	 BEGIN
	   SELECT UserId, DeviceTokenKey, IsActive FROM DeviceTokenInfo WHERE UserId = @UserId
	 END
	 SET NOCOUNT OFF;	
END
GO
