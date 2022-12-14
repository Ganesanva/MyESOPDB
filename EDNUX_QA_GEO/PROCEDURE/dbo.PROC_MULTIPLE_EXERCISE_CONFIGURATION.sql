/****** Object:  StoredProcedure [dbo].[PROC_MULTIPLE_EXERCISE_CONFIGURATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_MULTIPLE_EXERCISE_CONFIGURATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_MULTIPLE_EXERCISE_CONFIGURATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_MULTIPLE_EXERCISE_CONFIGURATION]
(
	@MIT_ID INT
)
AS
BEGIN
	SET NOCOUNT ON;

SELECT 
   ES.MinNoOfExeOpt, ES.MultipleForExeOpt, ES.isExeriseAtOneGo, ES.isExeSeparately,ES.APPLY_FIFO,CP.ListedYN ,ES.EXERCISE_COMPLETE_VEST,CP.IsSinglePayModeAllowed
FROM 
   CompanyParameters CP INNER JOIN EXERCISE_SETTING ES 
ON
   CP.CompanyID=ES.CompanyID AND ES.MIT_ID= @MIT_ID
   SET NOCOUNT OFF;
END
GO
