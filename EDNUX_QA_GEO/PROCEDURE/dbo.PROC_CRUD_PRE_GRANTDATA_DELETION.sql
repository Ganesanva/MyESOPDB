/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_PRE_GRANTDATA_DELETION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_PRE_GRANTDATA_DELETION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create  PROCEDURE [dbo].[PROC_CRUD_PRE_GRANTDATA_DELETION]
(
	@LetterCode dbo.PRE_GRANTDATA_DELETION READONLY,
	@Flag INT = NULL 
)
AS
BEGIN

	IF(@Flag = 0)
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION

			DELETE 
				GAMUD 
			FROM 
				GrantAccMassUploadDet AS GAMUD 
				INNER JOIN GrantAccMassUpload AS GAMU ON GAMU.LetterCode = GAMUD.LetterCode
			WHERE 
				GAMU.LetterCode IN (SELECT Letter_Code FROM @LetterCode)

			DELETE FROM GrantAccMassUpload WHERE LetterCode IN (SELECT Letter_Code FROM @LetterCode)
		
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
		END CATCH
	END
	ELSE IF(@Flag = 1)
	BEGIN
		UPDATE 
			GrantAccMassUpload  
		SET 
			IsGlGenerated         =   0,
			LetterAcceptanceStatus=   NUll,
			MailSentStatus        =   NULL,
			MailSentDate          =   NULL,
			GlGeneratedDate       =   NULL 
		WHERE 
			LetterCode IN (SELECT Letter_Code FROM @LetterCode  )
	END
END
GO
