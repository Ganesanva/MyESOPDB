/****** Object:  StoredProcedure [dbo].[SP_GETUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GETUSERDEMATDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[SP_GETUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GETUSERDEMATDETAILS]
	-- Add the parameters for the stored procedure here
	(@EmployeeDematId AS VARCHAR (50))
AS
	
BEGIN
		SET NOCOUNT ON;
SELECT 
		EmployeeDematId,
		EmployeeID,
		ISNULL(DepositoryName,'') AS DepositoryName,
		ISNULL(DepositoryParticipantName,'') AS DepositoryParticipantName,
		ISNULL(ClientIDNumber,'') AS ClientIDNumber,
		ISNULL(DematAccountType,'') AS DematAccountType,
		ISNULL(DepositoryIDNumber,'') AS DepositoryIDNumber,	
		ISNULL(DPRecord,'') AS DPRecord,	
		ISNULL(AccountName,'') AS AccountName,
		ISNULL(CMLCopy,'') AS CMLCopy,
		ISNULL(CMLUploadStatus,'') AS CMLUploadStatus,
		ISNULL(CMLUploadDate,'') AS CMLUploadDate,
		ISNULL(CMLCopyDisplayName,'') AS CMLCopyDisplayName
		
FROM 
		Employee_UserDematDetails 
WHERE
	 EmployeeDematId=@EmployeeDematId
	 AND IsActive = 1

	SET NOCOUNT OFF;
    
	
END



GO
