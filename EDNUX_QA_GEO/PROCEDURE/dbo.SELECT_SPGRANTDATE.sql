/****** Object:  StoredProcedure [dbo].[SELECT_SPGRANTDATE]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SELECT_SPGRANTDATE]
GO
/****** Object:  StoredProcedure [dbo].[SELECT_SPGRANTDATE]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SELECT_SPGRANTDATE]
(
	@DDEMPVALUE VARCHAR(30)  = NULL,
	@DDSCHEMEVALUE VARCHAR(30) = NULL	
)
AS
BEGIN
	DECLARE @RESULT VARCHAR(100)
	DECLARE @FINALQUERY VARCHAR(800)
	SET @RESULT = NULL
	if ((UPPER(@DDEMPVALUE) = 'ALL EMPLOYEES') AND (UPPER(@DDSCHEMEVALUE) = 'ALL SCHEMES'))
	BEGIN
		SET @RESULT = ' '		
	END
	else if((UPPER(@DDEMPVALUE) != 'ALL EMPLOYEES') AND (UPPER(@DDSCHEMEVALUE) != 'ALL SCHEMES'))
	BEGIN
		SET @RESULT = 'WHERE EMPLOYEEID ='''+@DDEMPVALUE+''' AND SCHEMEID IN ('''+@DDSCHEMEVALUE+''')'		
	END	
	else if ((UPPER(@DDEMPVALUE) = 'ALL EMPLOYEES'))
	BEGIN
		SET @RESULT = 'WHERE SchemeId='''+@DDSCHEMEVALUE+''''
	END
	else if ((UPPER(@DDSCHEMEVALUE) = 'ALL SCHEMES'))
	BEGIN
		SET @RESULT = 'WHERE EmployeeId ='''+@DDEMPVALUE+''''
	END
	
	PRINT @RESULT
	
	IF(@RESULT IS NOT NULL)
	BEGIN
			SET @FINALQUERY = '	SELECT DISTINCT REPLACE(CONVERT(VARCHAR(11), GRANTDATE, 106), '' '', ''/'') AS GRANTDATE 
							    FROM GRANTREGISTRATION   
								WHERE GRANTREGISTRATIONID IN 
								( SELECT DISTINCT GRANTREGISTRATIONID FROM GRANTOPTIONS '
			SET @FINALQUERY = @FINALQUERY + '' + @RESULT +')'
			
			EXEC (@FINALQUERY)
	END
END
GO
