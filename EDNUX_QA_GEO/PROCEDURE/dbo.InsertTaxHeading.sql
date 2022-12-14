/****** Object:  StoredProcedure [dbo].[InsertTaxHeading]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[InsertTaxHeading]
GO
/****** Object:  StoredProcedure [dbo].[InsertTaxHeading]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[InsertTaxHeading]
(
	@MIT_ID INT,
	@TaxHeading VARCHAR(100),
	@Active     INT,
	@Created_By VARCHAR(50),
	@Updated_By VARCHAR(50)
)
AS
BEGIN
    
    SET NOCOUNT ON;
    
    DECLARE @Result VARCHAR(100), @TRSC_ID INT
    SET @Result=0
    SET @TRSC_ID = 0
	
	IF EXISTS(SELECT 1 FROM MST_TAX_RATE_TITLE WHERE TAX_HEADING=@TaxHeading AND MIT_ID=@MIT_ID)
		BEGIN
			SET @Result='Tax Heading Already Exist' 
			SET @TRSC_ID = 0
		END
	ELSE 
		BEGIN
			BEGIN TRY
				
				INSERT INTO MST_TAX_RATE_TITLE
					(MIT_ID,TAX_HEADING,ACTIVE,CREATED_BY,CREATED_ON,UPDATED_BY,UPDATED_ON)	
				VALUES
					(@MIT_ID,@TaxHeading,@Active,@Created_By,GETDATE(),@Updated_By,GETDATE())

				SET @Result='Record Inserted Successfully.'
				SET @TRSC_ID = 1
			END TRY
			BEGIN CATCH
				SET @Result='Problem While Adding Record'
				SET @TRSC_ID = 0
			END CATCH
		END
	
	SELECT @Result AS Result,@TRSC_ID AS TRSC_ID
	
	SET NOCOUNT OFF;
END
GO
