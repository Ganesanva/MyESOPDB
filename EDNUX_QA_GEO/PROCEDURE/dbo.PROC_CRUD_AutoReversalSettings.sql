/****** Object:  StoredProcedure [dbo].[PROC_CRUD_AutoReversalSettings]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_AutoReversalSettings]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_AutoReversalSettings]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_AutoReversalSettings] 
	@IsExceptionActivated  BIT, 
	@TotalAmount NUMERIC(18, 6), 
	@CreatedBy  VARCHAR(50), 
	@retValue  INT output 
AS 
  BEGIN 
      DECLARE @Count INT 

      SET @Count = (SELECT Count(IsExceptionActivated) 
                    FROM   [AUTOREVERSALCONFIGMASTER]) 
      SET nocount ON; 

      IF( @Count = 0 ) 
        BEGIN 
            -- Insert statements for procedure here 
            INSERT INTO [AUTOREVERSALCONFIGMASTER] 
                        (IsExceptionActivated, 
                         ExceptionActivatedToAmount, 
                         CreatedBy, 
                         CreatedOn) 
            VALUES      (@IsExceptionActivated, 
                         @TotalAmount, 
                         @CreatedBy, 
                         Getdate()) 

            SET @retValue = @@ROWCOUNT; 
        END 
      ELSE 
        BEGIN 
        IF(@IsExceptionActivated = 0)
			BEGIN
				SET @TotalAmount = 0;
			END
        
            UPDATE [AUTOREVERSALCONFIGMASTER] 
            SET    IsExceptionActivated = @IsExceptionActivated, 
                   ExceptionActivatedToAmount = @TotalAmount, 
                   LastUpdatedBy = @CreatedBy, 
                   LastUpdatedOn = GETDATE() 

            SET @retValue = @@ROWCOUNT; 
        END 
        
  END  
GO
