/****** Object:  StoredProcedure [dbo].[PROC_GETDDLFOREDIT]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETDDLFOREDIT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETDDLFOREDIT]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GETDDLFOREDIT]
(	
	@ID			INT = NULL	
)
AS
BEGIN
	SET NOCOUNT ON;
		SELECT 
			EmployeeField, Datafield, DISPLAY_NAME 
		FROM 
			ConfigurePersonalDetails 
		WHERE 
			ID=@ID
	SET NOCOUNT OFF;
	
END
GO
