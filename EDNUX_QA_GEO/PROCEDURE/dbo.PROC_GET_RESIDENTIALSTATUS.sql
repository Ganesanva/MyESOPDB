/****** Object:  StoredProcedure [dbo].[PROC_GET_RESIDENTIALSTATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_RESIDENTIALSTATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_RESIDENTIALSTATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_RESIDENTIALSTATUS]
	
AS
BEGIN
	SET NOCOUNT ON;	
						
		SELECT id, ResidentialStatus, Description FROM ResidentialType
		WHERE ResidentialStatus Not In ('C','O')
				
	SET NOCOUNT OFF;	
END
GO
