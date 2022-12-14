/****** Object:  StoredProcedure [dbo].[PROC_SAVE_UPDATE_WIDGET_POSITION_BY_EMPLOYEEID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SAVE_UPDATE_WIDGET_POSITION_BY_EMPLOYEEID]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SAVE_UPDATE_WIDGET_POSITION_BY_EMPLOYEEID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[PROC_SAVE_UPDATE_WIDGET_POSITION_BY_EMPLOYEEID]
@ControlMasterID INT,
@EmployeeId NVARCHAR(20),
@x INT,
@y INT,
@height INT,
@width INT
AS
BEGIN
       IF NOT EXISTS(SELECT * FROM DASHBOARD_DASHBOARD_SAVE_WIDGET_POSITION WHERE CONTROL_MASTER_ID=@ControlMasterID AND EMPLOYEEID=@EmployeeId)
       BEGIN
              INSERT INTO DASHBOARD_DASHBOARD_SAVE_WIDGET_POSITION (CONTROL_MASTER_ID,EMPLOYEEID,X,Y,WIDTH,HEIGHT)
              VALUES(@ControlMasterID,@EmployeeId,@x,@y,@width,@height)
       END
       ELSE
       BEGIN
              UPDATE DASHBOARD_DASHBOARD_SAVE_WIDGET_POSITION
              SET CONTROL_MASTER_ID=@ControlMasterID,
              X=@x,
              Y=@y,
              HEIGHT=@height,
              WIDTH=@width
              WHERE CONTROL_MASTER_ID=@ControlMasterID AND EMPLOYEEID=@EmployeeId
       END
END
GO
