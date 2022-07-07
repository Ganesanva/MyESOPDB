/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_CONFIGURATIONS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OGA_CONFIGURATIONS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_CONFIGURATIONS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_OGA_CONFIGURATIONS]

AS  
BEGIN
	SET NOCOUNT ON;
	
	SELECT IsReminderMail ,DaysBefore,IsTillLastDate,ACSID
	FROM OGA_CONFIGURATIONS
	

	SELECT CompanyEmailDisplayName As 'EmailDisplayName'
	FROM CompanyParameters
	
	
END
GO
