/****** Object:  StoredProcedure [dbo].[PROC_DELETE_USER_BROKER_ACCOUNT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DELETE_USER_BROKER_ACCOUNT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DELETE_USER_BROKER_ACCOUNT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DELETE_USER_BROKER_ACCOUNT]
(
	@BROKER_ACC_ID	BIGINT	
)
AS
BEGIN
SET NOCOUNT ON;	
		
   BEGIN		    
	   
		--UPDATE 
		--    Employee_UserBrokerDetails 
		--SET   
		--    IS_ACTIVE ='0'					     
		--WHERE 
		--    EMPLOYEE_BROKER_ACC_ID=@BROKER_ACC_ID 
				
		DELETE FROM Employee_UserBrokerDetails WHERE EMPLOYEE_BROKER_ACC_ID=@BROKER_ACC_ID 

    END	
END	
GO
