/****** Object:  StoredProcedure [dbo].[ShowSecurityQuestion]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[ShowSecurityQuestion]
GO
/****** Object:  StoredProcedure [dbo].[ShowSecurityQuestion]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ShowSecurityQuestion] 
	@LOGIN_USER_ID VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(Select USerId from usersecurityquestion Where UserId = @LOGIN_USER_ID)
		Begin
			Select 'Yes'
		END
	ELSE
	Begin
		Select 'No'
	END



END
GO
