/****** Object:  UserDefinedFunction [dbo].[FN_GET_FINAL_FMV]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP FUNCTION IF EXISTS [dbo].[FN_GET_FINAL_FMV]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_FINAL_FMV]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FN_GET_FINAL_FMV] 
(	
    @FMV NUMERIC(18,9) NULL,
	@RatioMultiplier BIGINT,    
    @RatioDivisor BIGINT,
	@OPTIONEXERCISED NUMERIC(18,9),
    @ParameterType VARCHAR (50)
)
RETURNS NUMERIC(18,9)
AS
BEGIN
  DECLARE @@FINAL_FMV NUMERIC(18,9)

     IF(@ParameterType = 'FMV') --FOR FMV AND SETTLMENT PRICE --
	  BEGIN
			SET @@FINAL_FMV =   (@FMV/@RatioDivisor * @RatioMultiplier) * @OPTIONEXERCISED
	  END
	   ELSE IF(@ParameterType = 'SHAAV') -- --- FOR SHARE ARISING APPRICIATION VALUE--
	  BEGIN
			SET @@FINAL_FMV =   (@OPTIONEXERCISED/@RatioDivisor * @RatioMultiplier)
	  END

  RETURN @@FINAL_FMV
END

GO
