/****** Object:  StoredProcedure [dbo].[SP_GETUSERDEMATDETAILSBYID]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_GETUSERDEMATDETAILSBYID]
GO
/****** Object:  StoredProcedure [dbo].[SP_GETUSERDEMATDETAILSBYID]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GETUSERDEMATDETAILSBYID]
(
   @EmployeeId AS VARCHAR(50)
)
AS
	
BEGIN
		SET NOCOUNT ON;
		SELECT 
			EU.EmployeeDematId,
			EU.EmployeeID,
			ISNULL(EU.DepositoryName,'') AS DepositoryName,
			ISNULL(EU.DepositoryParticipantName,'') AS DepositoryParticipantName,
			ISNULL(EU.ClientIDNumber,'') AS ClientIDNumber,
			ISNULL(EU.DematAccountType,'') AS DematAccountType,
			ISNULL(EU.DepositoryIDNumber,'') AS DepositoryIDNumber,
			ISNULL(EU.DPRecord,'') AS DPRecord,
			ISNULL(EU.AccountName,'') AS AccountName,
			ISNULL(EU.IsValidDematAcc,0) AS IsValidDematAcc,
			ISNULL(EU.CMLCopy,'') AS CMLCopy,
			ISNULL(EU.CMLUploadStatus,'') AS CMLUploadStatus,
			ISNULL(EU.CMLUploadDate,'') AS CMLUploadDate,
			ISNULL(EU.CMLCopyDisplayName,'') AS CMLCopyDisplayName,
			ApproveStatus
		FROM 
			   Employee_UserDematDetails EU INNER JOIN EmployeeMaster EM ON EU.EmployeeID=EM.EmployeeID
		WHERE
			   EM.LoginID=@EmployeeID AND EM.Deleted=0 and EU.IsActive='1'
	 
	SET NOCOUNT OFF;
	
END
GO
