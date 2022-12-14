/****** Object:  UserDefinedFunction [dbo].[FN_ACC_SPLITSTRING]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_ACC_SPLITSTRING]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_ACC_SPLITSTRING]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_ACC_SPLITSTRING]
(
   @REPPARAM NVARCHAR(MAX), 
   @DELIM CHAR(1)= ','
) 

RETURNS @VALUES TABLE ([PARAM] NVARCHAR(4000))AS 

BEGIN 
   DECLARE @STARTINDEX INT, @ENDINDEX INT
 
      SET @STARTINDEX = 1
      IF SUBSTRING(@REPPARAM, LEN(@REPPARAM) - 1, LEN(@REPPARAM)) <> @DELIM
      BEGIN
            SET @REPPARAM = @REPPARAM + @DELIM
      END
 
      WHILE CHARINDEX(@DELIM, @REPPARAM) > 0
      BEGIN
            SET @ENDINDEX = CHARINDEX(@DELIM, @REPPARAM)
           
            INSERT INTO @VALUES([PARAM])
            SELECT SUBSTRING(@REPPARAM, @STARTINDEX, @ENDINDEX - 1)
           
            SET @REPPARAM = SUBSTRING(@REPPARAM, @ENDINDEX + 1, LEN(@REPPARAM))
      END
 
      RETURN
END
GO
