/****** Object:  UserDefinedFunction [dbo].[FN_GET_STATES_BY_COUNTRY]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_STATES_BY_COUNTRY]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_STATES_BY_COUNTRY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_STATES_BY_COUNTRY]
(
      @CountryID INT
)
RETURNS NVARCHAR(500)

AS      
BEGIN
		
	 DECLARE @States AS VARCHAR(Max)
	 SELECT @States = ISNULL(@States + ', ' ,'') + STATE_NAME FROM MST_STATES WHERE COUNTRY_ID = @CountryID	
			
RETURN @States 
END
GO
