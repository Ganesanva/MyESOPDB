/****** Object:  StoredProcedure [dbo].[PROC_DeassociateCompany]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DeassociateCompany]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DeassociateCompany]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_DeassociateCompany]  
@Result	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET @Result=0
	
	BEGIN TRANSACTION Trans
	
		BEGIN TRY   
			UPDATE CompanyMaster SET ISFUNDINGALLOWED=0	

			UPDATE UserMaster SET ISFUNDINGCCR=0 WHERE ISFUNDINGCCR=1

			INSERT INTO CompanyInfoHistory( CompanyID,CompanyName,CompanyAddress,CompanyURL, 
					CompanyEmail,AdminEmail,StockExchange,StockExchangeCode,UpdatedDate, 
					UpdatedTime,LastUpdatedBy,LastUpdatedOn,MaxLoginAttempts,ISFUNDINGALLOWED)	   
			SELECT TOP 1 CompanyID,CompanyName,CompanyAddress,CompanyURL,CompanyEmail,AdminEmail,StockExchange,
				StockExchangeCode,UpdatedDate,UpdatedTime,LastUpdatedBy,LastUpdatedOn,MaxLoginAttempts,ISFUNDINGALLOWED 
			FROM CompanyInfoHistory ORDER BY LastUpdatedOn DESC
			
			SET @Result=1
		END TRY
		BEGIN CATCH    	
			SET @Result=0          
			ROLLBACK TRANSACTION Trans  
		END CATCH
		
	COMMIT TRANSACTION Trans
	
	SELECT  @Result AS Result
END
GO
