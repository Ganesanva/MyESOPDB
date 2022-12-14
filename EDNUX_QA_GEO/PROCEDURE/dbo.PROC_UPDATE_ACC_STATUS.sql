/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_ACC_STATUS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_ACC_STATUS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_ACC_STATUS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_ACC_STATUS]
AS  
	BEGIN

SET NOCOUNT ON;
	DECLARE @ACSID INT	,@ACC_STATUS INT
	SET @ACSID = (SELECT ACSID FROM OGA_CONFIGURATIONS)
	
	BEGIN TRY
		BEGIN TRANSACTION
			IF @ACSID = 2 OR @ACSID =3
			  BEGIN				
				UPDATE GrantAccMassUpload
				SET 
				LetterAcceptanceDate=CreatedOn,
				LetterAcceptanceStatus = 'A',
				LastUpdatedBy = 'Admin',
				LastUpdatedOn=GETDATE()
				WHERE LastAcceptanceDate <= GETDATE() 
				AND LetterAcceptanceStatus = 'P'
				 
			  END
	    	 SET @ACC_STATUS = @@ROWCOUNT		  
	   COMMIT TRANSACTION
		
		IF(@ACC_STATUS > 0)
			BEGIN
				RETURN 1
			END
		ELSE
			BEGIN
				RETURN 0
			END		
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RETURN 0
	END CATCH
	
SET NOCOUNT OFF;
END
GO
