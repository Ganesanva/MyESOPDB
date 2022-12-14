/****** Object:  StoredProcedure [dbo].[PROC_UpdateGrantStatus]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateGrantStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateGrantStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UpdateGrantStatus] 
	@IsGLGenerated BIT,
	@LetterAcceptanceStatus CHAR(1),
	@MailSentStatus BIT,
	@LetterCode VARCHAR(100),
	@EmployeeID VARCHAR(50),
	@LastUpdatedBy VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF((SELECT ACSID FROM OGA_CONFIGURATIONS) = 3)
	BEGIN
	    SET @LetterAcceptanceStatus='A'
	END
	  
	  Declare @GLGenrated int	 
	  /*
		 1) Get Current IsGLGenerated value for specific Employee.  
		 2) If IsGLGenerated is 0 then it set to 1 in GrantAccMassUpload for specific Employee at the time of Mail sending without attachment.
	  */
	 SELECT @GLGenrated= ISNULL(IsGLGenerated,0) FROM GrantAccMassUpload WHERE LetterCode = @LetterCode AND EmployeeID = @EmployeeID  	  
	  
	If(@IsGLGenerated = 0)
	BEGIN
		
		IF(@GLGenrated=1)
		SET @IsGLGenerated=1		
	
		UPDATE GrantAccMassUpload 
		SET 
			IsGLGenerated = @IsGLGenerated,
			GLGeneratedDate = GETDATE(),
			LetterAcceptanceStatus = @LetterAcceptanceStatus,
			MailSentStatus = @MailSentStatus,
			MailSentDate = GETDATE(),
			LastUpdatedBy = @LastUpdatedBy,
			LastUpdatedOn = GETDATE(),
			LetterAcceptanceDate = CASE WHEN @LetterAcceptanceStatus = 'P' THEN NULL ELSE LetterAcceptanceDate END
		WHERE
			LetterCode = @LetterCode AND
			EmployeeID = @EmployeeID 
	END	
	ELSE
	BEGIN
		UPDATE GrantAccMassUpload 
		SET 
			IsGLGenerated = @IsGLGenerated,
			GLGeneratedDate = GETDATE(),
			LetterAcceptanceStatus = @LetterAcceptanceStatus,
			MailSentStatus = @MailSentStatus,
			MailSentDate = CASE WHEN @MailSentStatus = 1 THEN GETDATE() ELSE NULL END,
			LastUpdatedBy = @LastUpdatedBy,
			LastUpdatedOn = GETDATE()
		WHERE
			LetterCode = @LetterCode AND
			EmployeeID = @EmployeeID 	
	END
	SET NOCOUNT OFF;
    
END
GO
