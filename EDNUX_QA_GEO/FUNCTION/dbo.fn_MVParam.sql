/****** Object:  UserDefinedFunction [dbo].[fn_MVParam]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[fn_MVParam]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_MVParam]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_MVParam] 
   (@RepParam nvarchar(MAX), @Delim char(1)= ',') 
RETURNS @Values TABLE (Param nvarchar(4000))AS 
  BEGIN 
  DECLARE @chrind INT 
  DECLARE @Piece nvarchar(100) 
  SELECT @chrind = 1  
  WHILE @chrind > 0 
    BEGIN 
      SELECT @chrind = CHARINDEX(@Delim,@RepParam) 
      IF @chrind  > 0 
        SELECT @Piece = LEFT(@RepParam,@chrind - 1) 
      ELSE 
        SELECT @Piece = @RepParam 
      INSERT  @Values(Param) VALUES(CAST(@Piece AS VARCHAR(max))) 
      SELECT @RepParam = RIGHT(@RepParam,LEN(@RepParam) - @chrind) 
      IF LEN(@RepParam) = 0 BREAK 
    END 
  RETURN 
  END
GO
