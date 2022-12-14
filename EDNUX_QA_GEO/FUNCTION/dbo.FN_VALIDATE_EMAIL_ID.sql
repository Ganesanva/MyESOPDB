/****** Object:  UserDefinedFunction [dbo].[FN_VALIDATE_EMAIL_ID]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_VALIDATE_EMAIL_ID]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_VALIDATE_EMAIL_ID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
ref from : https://www.mssqltips.com/sqlservertip/6519/valid-email-address-check-with-tsql/
SELECT dbo.FN_VALIDATE_EMAIL_ID('chetan.chopkar@esopdirect.com') 
*/

CREATE FUNCTION [dbo].[FN_VALIDATE_EMAIL_ID](@EMAIL NVARCHAR(100)) RETURNS BIT AS
BEGIN     
  
  DECLARE @EmailText NVARCHAR(100)
  DECLARE @bitEmailVal AS BIT
  
  SET @EmailText=LTRIM(RTRIM(ISNULL(@EMAIL,'')))

  SET @bitEmailVal = CASE WHEN @EmailText = '' THEN 0
                          WHEN @EmailText LIKE '% %' THEN 0
                          WHEN @EmailText LIKE ('%["(),:;<>\]%') THEN 0
                          WHEN SUBSTRING(@EmailText, CHARINDEX('@',@EmailText), LEN(@EmailText)) LIKE ('%[!#$%&*+/=?^`_{|]%') THEN 0
                          WHEN (LEFT(@EmailText,1) LIKE ('[-_.+]') OR RIGHT(@EmailText,1) LIKE ('[-_.+]')) THEN 0                                                                                    
                          WHEN (@EmailText LIKE '%[%' OR @EmailText LIKE '%]%') THEN 0
                          WHEN @EmailText LIKE '%@%@%' THEN 0
                          WHEN @EmailText NOT LIKE '_%@_%._%' THEN 0
                          ELSE 1 
                      END
  RETURN @bitEmailVal
END 
GO
