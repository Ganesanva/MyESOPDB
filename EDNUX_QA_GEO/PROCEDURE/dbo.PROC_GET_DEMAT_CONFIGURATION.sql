/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_CONFIGURATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DEMAT_CONFIGURATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_CONFIGURATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_DEMAT_CONFIGURATION]

AS
BEGIN

	SET NOCOUNT ON;
	 
	 SELECT 
		IsMandatory,
		IsRequired,
	    IsDematValidation,
		IsAllowToEditDemat,
		IsRemainderMail,
		FrequencyInDays,
		SendIntimation
	 FROM DematConfiguration

	SET NOCOUNT OFF;
END
GO
