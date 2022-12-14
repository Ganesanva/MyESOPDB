/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_ENABLE_STATUS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_OGA_ENABLE_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_OGA_ENABLE_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_GET_OGA_ENABLE_STATUS]
(
    @CompanyName varchar(100)
	
)
AS
    BEGIN
		DECLARE @IS_EGRANTS_ENABLED bit, @Result INT

    	SET @IS_EGRANTS_ENABLED = (SELECT IS_EGRANTS_ENABLED FROM COMPANYMASTER WHERE COMPANYID=@COMPANYNAME);
	
        IF(@IS_EGRANTS_ENABLED > 0)
			BEGIN
			   SET @Result = 1;
			END
		ELSE
			BEGIN
			   SET @Result = 0;
		    END
	  SELECT @Result AS 'IS_EGRANTS_ENABLED'
    END
GO
