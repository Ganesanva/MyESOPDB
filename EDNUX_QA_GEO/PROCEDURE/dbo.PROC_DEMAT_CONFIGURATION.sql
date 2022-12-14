/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_CONFIGURATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DEMAT_CONFIGURATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DEMAT_CONFIGURATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DEMAT_CONFIGURATION]    
( 
 @UserId             NVARCHAR(50)     ,
 @IsDematValidation	 BIT			  NULL,
 @IsAllowToEditDemat BIT			  NULL,
 @IsRemainderMail    BIT			  NULL,
 @FrequencyInDays	 NVARCHAR(10)     NULL,
 @SendIntimation	 NVARCHAR(MAX)    NULL
 
)    
AS    
BEGIN
    
     
    IF NOT EXISTS(SELECT TOP 1 IsDematValidation FROM DematConfiguration)
    BEGIN
  		INSERT INTO DematConfiguration (IsDematValidation, IsAllowToEditDemat, IsRemainderMail, FrequencyInDays, SendIntimation, CREATED_BY, CREATED_ON, UPDATED_BY, UPDATED_ON)
  		VALUES(@IsDematValidation, @IsAllowToEditDemat, @IsRemainderMail,@FrequencyInDays, @SendIntimation, @UserId, GetDate(), Null, Null)
  			IF(@@Rowcount>0)
  			BEGIN
  				SELECT 1
  			END
    END 
	ELSE
	BEGIN
	   UPDATE DematConfiguration SET IsDematValidation = @IsDematValidation, IsAllowToEditDemat = @IsAllowToEditDemat, 
	          IsRemainderMail =@IsRemainderMail, FrequencyInDays =@FrequencyInDays, SendIntimation = @SendIntimation,
	          UPDATED_BY = @UserId, UPDATED_ON = GetDate()
			IF(@@Rowcount>0)
  			BEGIN
  				SELECT 1
  			END
	END
	  
END
GO
