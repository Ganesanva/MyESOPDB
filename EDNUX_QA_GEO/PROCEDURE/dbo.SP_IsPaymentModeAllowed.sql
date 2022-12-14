/****** Object:  StoredProcedure [dbo].[SP_IsPaymentModeAllowed]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_IsPaymentModeAllowed]
GO
/****** Object:  StoredProcedure [dbo].[SP_IsPaymentModeAllowed]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_IsPaymentModeAllowed]
	@RESIDENTIAL_STATUS CHAR,
	@IsAllowed BIT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE 
		@RIPERQVALUE CHAR, @RIPERQTAX CHAR, 
		@NRIPERQVALUE CHAR, @NRIPERQTAX CHAR, 
		@FNPERQVALUE CHAR, @FNPERQTAX CHAR

	SELECT 
		@RIPERQVALUE = RIPERQVALUE, @RIPERQTAX = RIPERQTAX, 
		@NRIPERQVALUE = NRIPERQVALUE, @NRIPERQTAX = NRIPERQTAX, 
		@FNPERQVALUE = FNPERQVALUE, @FNPERQTAX = FNPERQTAX 
	FROM COMPANYPARAMETERS
	
	SET @IsAllowed = 0
	
	
	--FOR FOREIGN NATIONAL
	IF(@RESIDENTIAL_STATUS = 'F')
		BEGIN
		IF(@FNPERQVALUE = 'N' AND @FNPERQTAX = 'N')
			BEGIN
				SET @IsAllowed = 1
			END
		END
		
	--FOR RESIDENT INDIAN
	ELSE IF(@RESIDENTIAL_STATUS = 'R')
		BEGIN
			IF(@RIPERQVALUE = 'N' AND @RIPERQTAX = 'N')
				BEGIN
					SET @IsAllowed = 1
				END
		END
		
	--FOR NON RESIDENT INDIAN
	ELSE IF(@RESIDENTIAL_STATUS = 'N')
		BEGIN
			IF(@NRIPERQVALUE = 'N' AND @NRIPERQTAX = 'N')
				BEGIN
					SET @IsAllowed = 1
				END
		END
END
GO
