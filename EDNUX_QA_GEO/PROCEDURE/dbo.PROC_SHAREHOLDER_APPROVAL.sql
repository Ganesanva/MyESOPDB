/****** Object:  StoredProcedure [dbo].[PROC_SHAREHOLDER_APPROVAL]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_SHAREHOLDER_APPROVAL]
GO
/****** Object:  StoredProcedure [dbo].[PROC_SHAREHOLDER_APPROVAL]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_SHAREHOLDER_APPROVAL] (@CompanyId VARCHAR(50) = NULL)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

	SET NOCOUNT ON;
	
	-- CREATE TEMP TABLE FOR COLLECT EMPLOYEE EXPIRYIES DETAILS	
	
	BEGIN
		
		CREATE TABLE #TEMP_SHAREHOLDER_APPROVAL
		(
			ApprovalId VARCHAR(50)
		)

		INSERT INTO #TEMP_SHAREHOLDER_APPROVAL 	
		(	
			ApprovalId
		)
		SELECT ApprovalId FROM ShareHolderApproval WHERE [Status] = 'A' AND (CONVERT(DATE,GETDATE()) > CONVERT(DATE,ValidUptoDate))

	END
	
	SELECT ApprovalId FROM #TEMP_SHAREHOLDER_APPROVAL
	
	
	IF((SELECT COUNT(ApprovalId) AS ROW_COUNT FROM #TEMP_SHAREHOLDER_APPROVAL) > 0)
		BEGIN
			BEGIN TRY
				
				UPDATE SHA SET SHA.[Status] = 'E', SHA.LastUpdatedBy = 'ADMIN', SHA.LastUpdatedOn = GETDATE() FROM ShareHolderApproval AS SHA
				INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TEMP ON TEMP.ApprovalId = SHA.ApprovalId
				
				UPDATE SC SET SC.[Status] = 'E', SC.LastUpdatedBy = 'ADMIN', SC.LastUpdatedOn = GETDATE() FROM SCHEME AS SC
				INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TEMP ON TEMP.ApprovalId = SC.ApprovalId
				
				UPDATE GR SET GR.ApprovalStatus = 'E', GR.LastUpdatedBy = 'ADMIN', GR.LastUpdatedOn = GETDATE() FROM GrantRegistration AS GR
				INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TEMP ON TEMP.ApprovalId = GR.ApprovalId
				
				UPDATE GA SET GA.ApprovalStatus = 'E', GA.LastUpdatedBy = 'ADMIN', GA.LastUpdatedOn = GETDATE() FROM GrantApproval AS GA
				INNER JOIN #TEMP_SHAREHOLDER_APPROVAL AS TEMP ON TEMP.ApprovalId = GA.ApprovalId
				
			END TRY
			BEGIN CATCH
					
				IF @@TRANCOUNT > 0
					ROLLBACK TRANSACTION
				
				SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
				
			END CATCH
		END
	ELSE
		BEGIN
			PRINT 'NO DATA AVAILABLE EXPIRY SHAREHOLDER'
		END

	SET NOCOUNT OFF;
END
GO
