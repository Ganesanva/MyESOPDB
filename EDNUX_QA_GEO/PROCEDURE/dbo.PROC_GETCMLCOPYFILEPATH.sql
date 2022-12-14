/****** Object:  StoredProcedure [dbo].[PROC_GETCMLCOPYFILEPATH]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETCMLCOPYFILEPATH]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETCMLCOPYFILEPATH]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GETCMLCOPYFILEPATH]
(
@EmployeeID AS varchar(200)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET @EmployeeId=(SELECT Employeeid FROM EmployeeMaster WHERE LoginID=@EmployeeID AND Deleted=0)
	SELECT CMLCopy,CMLCopyDisplayName,EmployeeID,EmployeeDematId,CONCAT(REPLACE((SELECT SiteUrl FROM companymaster),'Login.aspx',''),'Employee/ViewDocumentFile.aspx?Path=') AS SiteUrl FROM Employee_UserDematDetails WHERE EmployeeID= @EmployeeID And IsActive=1
	SET NOCOUNT OFF;
END


GO
