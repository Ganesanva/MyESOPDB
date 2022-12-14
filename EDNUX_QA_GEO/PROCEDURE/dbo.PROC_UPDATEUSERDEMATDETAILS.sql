/****** Object:  StoredProcedure [dbo].[PROC_UPDATEUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATEUSERDEMATDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATEUSERDEMATDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATEUSERDEMATDETAILS] 	
	(
		    @EmployeeDematId AS INT,
		    @DepositoryName AS VARCHAR(20),
            @DepositoryParticipantName AS VARCHAR(150),
            @ClientIDNumber AS VARCHAR(16),
            @DematAccountType AS VARCHAR(15),
            @DepositoryIDNumber AS VARCHAR(8),
            @DPRecord AS VARCHAR(50),
            @AccountName AS NVARCHAR(256),
			@EmployeeID	AS NVARCHAR(20),
			@CMLCopy AS VARCHAR(500),
			@CMLUploadStatus AS VARCHAR(10),
			@CMLUploadDate	AS DATETIME,
			@CMLCopyDisplayName AS VARCHAR(500),
			@ApproveStatus VARCHAR(5) NULL
	)
AS
BEGIN
	
	SET NOCOUNT ON;
	    DECLARE @IsResult INT, @CMLSTATUS VARCHAR(10),@CMLDATE DATETIME

		IF NOT EXISTS(SELECT EmployeeDematId FROM Employee_UserDematDetails WHERE EmployeeDematId <> @EmployeeDematId AND EMPLOYEEID=@EmployeeID AND (@DepositoryName='N' AND (ISNULL(ClientIDNumber,'')=@ClientIDNumber AND ISNULL(DepositoryIDNumber,'')=@DepositoryIDNumber) OR (@DepositoryName='C' AND ISNULL(ClientIDNumber,'')=@ClientIDNumber)) )
		BEGIN		
		SET @CMLSTATUS = CASE WHEN @CMLCopy <> '' THEN 'Y' ELSE NULL END
		SET @CMLDATE = CASE WHEN @CMLCopy <> '' THEN GETDATE() ELSE NULL END

			UPDATE [dbo].[Employee_UserDematDetails]
			 SET 
				 [DepositoryName] = @DepositoryName, 
			     [DepositoryParticipantName] = @DepositoryParticipantName, 
				 [ClientIDNumber] = @ClientIDNumber,
				 [DematAccountType] = @DematAccountType,
				 [DepositoryIDNumber] = @DepositoryIDNumber,
				 [DPRecord] = @DPRecord,
				 [AccountName] = @AccountName,
				 [UPDATED_BY] = @EmployeeID,
				 [UPDATED_ON] = GETDATE(),
				 [CMLCopy]	= @CMLCopy,				 
				 [CMLUploadDate] = @CMLDATE,
				 [CMLUploadStatus] = @CMLSTATUS ,
				 [CMLCopyDisplayName] = @CMLCopyDisplayName,
	--			 [IsValidDematAcc] = CASE  WHEN (@ApproveStatus = 'P') THEN 0 ELSE 1 END,
				 [ApproveStatus] = @ApproveStatus

			WHERE 
				EmployeeDematId = @EmployeeDematId
				AND IsActive = 1

		    SET  @IsResult = @@ROWCOUNT
		END	

		IF (@IsResult > 0)
		BEGIN			
		    SELECT 
			 DepositoryName, DepositoryParticipantName, ClientIDNumber, DematAccountType, DepositoryIDNumber, DPRecord, AccountName,
			 CMLCopy, CMLCopyDisplayName,CMLUploadDate,CMLUploadStatus
			FROM Employee_UserDematDetails WHERE  EmployeeDematId = @EmployeeDematId AND IsActive = 1
		END
		ELSE
		BEGIN
		    SELECT 'F' AS [STATUS], CASE WHEN @@ERROR <> 0 THEN 'Error while update demat account.' ELSE 'Record already exist.' END AS [MESSAGE]
		END	
		
	SET NOCOUNT OFF;
END
GO
