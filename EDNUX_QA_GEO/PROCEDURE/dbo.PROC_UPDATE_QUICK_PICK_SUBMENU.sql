/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_QUICK_PICK_SUBMENU]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_QUICK_PICK_SUBMENU]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_QUICK_PICK_SUBMENU]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_UPDATE_QUICK_PICK_SUBMENU]
(
	
	@EHD_ID INT,
	@SHOW INT
)
AS
BEGIN

	SET NOCOUNT ON;
	IF(@EHD_ID != 0)
	BEGIN
		UPDATE EMPLOYEEHOMEBOXES_DETAILS SET SHOW = @SHOW WHERE EHD_ID = @EHD_ID
	END
	
	ELSE IF (@EHD_ID = 0)
	BEGIN
		UPDATE EMPLOYEEHOMEBOXES_DETAILS SET SHOW = 0
	END
	
    SET NOCOUNT OFF;
END
GO
