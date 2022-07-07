/****** Object:  StoredProcedure [dbo].[PROC_DELETENOMINEEDETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DELETENOMINEEDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DELETENOMINEEDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_DELETENOMINEEDETAILS] 
	-- Add the parameters for the stored procedure here
	(
		 @NomineeID AS INT
		    
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	DELETE
	FROM 
		[dbo].[NomineeDetails] 
	WHERE 
		NomineeId =  @NomineeID



	SET NOCOUNT OFF;

END

GO
