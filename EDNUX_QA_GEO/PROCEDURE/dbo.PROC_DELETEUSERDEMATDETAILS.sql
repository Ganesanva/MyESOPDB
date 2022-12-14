/****** Object:  StoredProcedure [dbo].[PROC_DELETEUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_DELETEUSERDEMATDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_DELETEUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_DELETEUSERDEMATDETAILS] 
	-- Add the parameters for the stored procedure here
	(
		    @EmployeeDematId AS INT		    
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here

	DELETE
	FROM 
		[dbo].[Employee_UserDematDetails] 
	WHERE 
		EmployeeDematId = @EmployeeDematId

	SET NOCOUNT OFF;

END

GO
