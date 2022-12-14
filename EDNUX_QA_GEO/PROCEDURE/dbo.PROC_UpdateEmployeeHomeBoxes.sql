/****** Object:  StoredProcedure [dbo].[PROC_UpdateEmployeeHomeBoxes]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UpdateEmployeeHomeBoxes]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UpdateEmployeeHomeBoxes]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UpdateEmployeeHomeBoxes] @Show BIT = NULL
	,@Position VARCHAR(10) = NULL
	,@BoxID INT = NULL
	,@Name VARCHAR(50) = NULL,
	@retValue INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE EmployeeHomeBoxes
	SET Show = ISNULL(@Show, Show)
		,Position = ISNULL(@Position, Position)
		,Name = ISNULL(@Name, Name)
	WHERE BoxID = @BoxID
	
	SET @retValue = @@ROWCOUNT;
	SET NOCOUNT OFF;
END
GO
