/****** Object:  StoredProcedure [dbo].[GET_DASHBOARD_EMBEDDED_URL_MAPPING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_DASHBOARD_EMBEDDED_URL_MAPPING]
GO
/****** Object:  StoredProcedure [dbo].[GET_DASHBOARD_EMBEDDED_URL_MAPPING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GET_DASHBOARD_EMBEDDED_URL_MAPPING]
	@UserType  VARCHAR(250)
AS
BEGIN
	SET NOCOUNT ON;

			SELECT USERTYPE,URL FROM DASHBOARD_EMBEDDED_URL_MAPPING WHERE USERTYPE=@UserType
				
	SET NOCOUNT OFF;
END
GO
