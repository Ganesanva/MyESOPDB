/****** Object:  StoredProcedure [dbo].[InsertFormulaMaintain]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[InsertFormulaMaintain]
GO
/****** Object:  StoredProcedure [dbo].[InsertFormulaMaintain]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*--------------------------------------------------------------------------------------
Create By: Chetan Kumare Tembhre
Create Date: 08-Feb-2013
Description: Insert formula in Formula maintain table
  if return =1 then success,2 then alise name alredy exists,3 then formula already exists,0 then failure
exec InsertFormulaMaintain ' ExercisePrice + OptionsExercised','Eclerx','R','T2','CHETAN'
--------------------------------------------------------------------------------------*/
CREATE PROC [dbo].[InsertFormulaMaintain]
@Formula VARCHAR(2000),
@CompanyID VARCHAR(50),
@ResidentalStatus VARCHAR(10), 
@AliseName VARCHAR(50),
@LastUpdateeBy VARCHAR(50)
AS
BEGIN
    DECLARE @Result INT
    SET @Result=0
	IF EXISTS(SELECT 1 FROM FORMULA_MAINTAIN WHERE FORMULA=@Formula)
	BEGIN
		SET @Result=3 
		
	END
	ELSE IF EXISTS(SELECT 1 FROM FORMULA_MAINTAIN WHERE ALIAS_NAME=@AliseName)
	BEGIN
		SET @Result=2
	END
	ELSE 
	BEGIN
	BEGIN TRY
    INSERT INTO FORMULA_MAINTAIN(FORMULA,COMPANYID,RESI_STATUS,ALIAS_NAME,LASTUPDATEDBY,LASTUPDATEDON)	
    VALUES(@Formula,@CompanyID,@ResidentalStatus,@AliseName,@LastUpdateeBy,GETDATE())
    SET @Result=1
    END TRY
    BEGIN CATCH
    SET @Result=0
    END CATCH
	END
	SELECT  @Result AS Result
END
GO
