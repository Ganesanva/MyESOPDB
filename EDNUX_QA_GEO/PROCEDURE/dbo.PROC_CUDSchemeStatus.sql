/****** Object:  StoredProcedure [dbo].[PROC_CUDSchemeStatus]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CUDSchemeStatus]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CUDSchemeStatus]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[PROC_CUDSchemeStatus]
(	
	@SchemeId	VARCHAR(100),
	@TrustType	VARCHAR(50),
	@Result		INT OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON
		DECLARE @SQLQuery VARCHAR(MAX),
				@Count INT = 0,
				@Error INT = 1 -- default value of error is '1' means no error.
		
		--Try/Catch block implement in sql query.		
		BEGIN TRY
			SELECT @Count = Count(1) FROM Scheme WHERE SchemeId=@SchemeId
			IF(@Count > 0)
			BEGIN
				SELECT @SQLQuery = 'UPDATE Scheme SET   TrustType = '''+@TrustType+'''  WHERE SchemeId = '''+@SchemeId+''''			
				EXEC(@SQLQuery)			
			END
			ELSE 
				SELECT @Error = 0
		END TRY
		BEGIN CATCH
			SELECT @Error = 0
		END CATCH
		
		--IF Record updated successfully it returns '1' ELSE it return '0'
		SELECT @Result = CASE WHEN (@Error=0) THEN 0 ELSE 1 END
		
	SET NOCOUNT OFF
END
GO
