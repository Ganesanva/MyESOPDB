/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_SETTINGS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_EXERCISE_SETTINGS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_EXERCISE_SETTINGS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_EXERCISE_SETTINGS]
   @MIT_ID INT
AS
BEGIN
	SET NOCOUNT ON;

		SELECT 
		     Multiple_Grant_Exercise,Multiple_Vest_Exercise,Exercise_Complete_Vest,MIT_ID
		 FROM 
		    EXERCISE_SETTING
			WHERE 
			MIT_ID = @MIT_ID

	SET NOCOUNT OFF;
END


GO
