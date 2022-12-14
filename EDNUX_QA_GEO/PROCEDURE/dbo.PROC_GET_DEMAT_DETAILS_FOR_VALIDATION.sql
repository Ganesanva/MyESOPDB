/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_DETAILS_FOR_VALIDATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DEMAT_DETAILS_FOR_VALIDATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DEMAT_DETAILS_FOR_VALIDATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_GET_DEMAT_DETAILS_FOR_VALIDATION]
(
	@EmployeeId VARCHAR(20) NULL,
	@ActionName VARCHAR(20) NULL	
)
AS
BEGIN

	SET NOCOUNT ON;
	IF(@ActionName = 'EmployeeList')
	BEGIN
	   IF(ISNULL(@EmployeeId,'') = '')
	   BEGIN
	      SELECT DISTINCT EM.EmployeeId, EM.EmployeeName FROM EMPLOYEEMASTER EM INNER JOIN Employee_UserDematDetails EUD ON EM.EmployeeID = EUD.EmployeeID 
		  WHERE EM.deleted = 0 AND ApproveStatus='P' AND EUD.IsActive = 1		  
	   END
	   ELSE
	   BEGIN
		  SELECT EmployeeId, EmployeeName, EmployeeEmail, SecondaryEmailID, ( SELECT CompanyEmailID FROM CompanyParameters) AS CompanyEmailID FROM EMPLOYEEMASTER 
		  WHERE deleted = 0 AND EmployeeID = @EmployeeId
	   END
	END

	BEGIN TRY

	IF(@ActionName = 'DEMATDETAILS')
	BEGIN
		IF(ISNULL(@EmployeeId,'') IS NOT NULL AND @EmployeeId <> '')
		BEGIN
	    SELECT ED.EmployeeDematId, EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(50),ISNULL(ED.EmployeeDematId,0)) AS [Demat Id],
					CASE 
					   WHEN ED.DepositoryName='N' THEN 'NSDL'
					   WHEN ED.DepositoryName='C' THEN 'CDSL'
					   ELSE '' 
					END AS [Depository Name],
					CASE 
					   WHEN ED.DematAccountType='R' THEN 'Repatriable'
					   WHEN ED.DematAccountType='N' OR ED.DematAccountType='NR' THEN 'Non-Repatriable'
					   WHEN ED.DematAccountType='A' THEN 'Not Applicable'
					   ELSE '' 
					END AS [Account Type], ED.DepositoryParticipantName AS [DP Name],ED.DepositoryIDNumber AS [DP Id],
					ED.ClientIDNumber AS [Client Id], ED.DPRecord AS [Name as in DP records],	
					CASE 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 1 THEN 'V' 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 0 THEN 'I'
					ELSE '' 
					END 
						AS [Is Valid Demat Acc],
                    ED.CMLCOPY,
					ED.UPDATED_ON			
	
					FROM 
						EmployeeMaster EM
					INNER JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1					
					WHERE EM.deleted =0 AND ED.EmployeeID = @EmployeeId AND ED.ApproveStatus = 'P'
					ORDER BY EM.EmployeeID ASC
		END
		ELSE
		BEGIN
			SELECT ED.EmployeeDematId, EM.EmployeeID, EM.EmployeeName, CONVERT(NVARCHAR(50),ISNULL(ED.EmployeeDematId,0)) AS [Demat Id],
					CASE 
					   WHEN ED.DepositoryName='N' THEN 'NSDL'
					   WHEN ED.DepositoryName='C' THEN 'CDSL'
					   ELSE '' 
					END AS [Depository Name],
					CASE 
					   WHEN ED.DematAccountType='R' THEN 'Repatriable'
					   WHEN ED.DematAccountType='N' OR ED.DematAccountType='NR' THEN 'Non-Repatriable'
					   WHEN ED.DematAccountType='A' THEN 'Not Applicable'
					   ELSE '' 
					END AS [Account Type], ED.DepositoryParticipantName AS [DP Name],ED.DepositoryIDNumber AS [DP Id],
					ED.ClientIDNumber AS [Client Id], ED.DPRecord AS [Name as in DP records],	
					CASE 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 1 THEN 'V' 
						WHEN 
							ISNULL(ED.IsValidDematAcc,'') = 0 THEN 'I'
					ELSE '' 
					END 
						AS [Is Valid Demat Acc],
						ED.CMLCOPY,
						ED.UPDATED_ON		
	
					FROM 
						EmployeeMaster EM
					INNER JOIN Employee_UserDematDetails ED ON EM.EmployeeID=ED.EmployeeID AND ED.IsActive=1					
					WHERE EM.deleted =0 AND ED.ApproveStatus = 'P'
					ORDER BY EM.EmployeeID ASC
		END
	END
	END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE() AS ErrorMsg
	END CATCH

	SET NOCOUNT OFF;
END
GO
