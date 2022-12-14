/****** Object:  StoredProcedure [dbo].[PROC_UPDATEAUTOREVERSALSETTINGDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATEAUTOREVERSALSETTINGDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATEAUTOREVERSALSETTINGDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UPDATEAUTOREVERSALSETTINGDETAILS] 
@IsActivated           BIT, 
@ColumnsToBeConsidered VARCHAR(max), 
@UpdatedBy VARCHAR(50), 
@retValue INT OUT 
AS 
  BEGIN 
      SET nocount ON; 

      UPDATE [dbo].[AUTOREVERSALSETTINGDETAILS] 
      SET    IsActivated = @IsActivated, 
             LastUpdatedBy = @UpdatedBy, 
             LastUpdatedOn = GETDATE() 
      WHERE  ColumnsToBeConsidered = @ColumnsToBeConsidered 

      SET @retValue = @@ROWCOUNT; 
  END 

GO
