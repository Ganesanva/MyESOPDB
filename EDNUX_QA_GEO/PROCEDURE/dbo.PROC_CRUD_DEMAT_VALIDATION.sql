/****** Object:  StoredProcedure [dbo].[PROC_CRUD_DEMAT_VALIDATION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_CRUD_DEMAT_VALIDATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_CRUD_DEMAT_VALIDATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_CRUD_DEMAT_VALIDATION]
(	
	@TYPE_DEMAT_DETAILS dbo.TYPE_DEMAT_DETAILS READONLY
)
AS
BEGIN
   BEGIN TRY
        CREATE TABLE #TYPE_DEMAT_DETAILS
		(
			EmployeeDematId BIGINT NULL,
			EmployeeID VARCHAR(20) NULL,				
			
			Validate bit NULL,
			ApproveStatus VARCHAR(5) NULL
		)
		--=== Insert into temp table
		INSERT INTO #TYPE_DEMAT_DETAILS(EmployeeDematId, EmployeeID, Validate, ApproveStatus)
			SELECT EmployeeDematId, EmployeeID, Validate, ApproveStatus
		    FROM @TYPE_DEMAT_DETAILS
        
		--=== Update demat data 
        UPDATE dbo.Employee_UserDematDetails
			SET 
				IsValidDematAcc = X.Validate,
				ApproveStatus = X.ApproveStatus
			FROM dbo.Employee_UserDematDetails 
			JOIN #TYPE_DEMAT_DETAILS X ON X.EmployeeDematId = Employee_UserDematDetails.EmployeeDematId
       
	     IF(@@ROWCOUNT > 0)
		 BEGIN
		     SELECT 1
		 END
   END TRY
   BEGIN CATCH
         BEGIN
				SELECT 'ERROR WHILE INSERTING INTO TEMP TABLE FROM TYPE RECORD' AS REMARK, ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, 
				ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage
				--GOTO ERROR
		 END
   END CATCH
END
GO
