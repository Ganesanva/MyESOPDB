DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERTUSERDEMATDETAILS]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PROC_INSERTUSERDEMATDETAILS]
	-- Add the parameters for the stored procedure here
	(
			@EmployeeID AS varchar(20),
            @DepositoryName AS varchar(20),
            @DepositoryParticipantName AS varchar(150),
            @ClientIDNumber AS varchar(16),
            @DematAccountType AS varchar(15),
            @DepositoryIDNumber AS varchar(8),
            @DPRecord AS varchar(50),
            @AccountName AS nvarchar(256),
			@IsActive AS bit,
			@CMLCopy as varchar(500),
			@CMLCopyDisplayName as varchar(500),
			@ApproveStatus varchar(5) NULL
			
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
			 -- Insert statements for procedure here
			DECLARE @IsResult INT
			DECLARE @EMPLOYEE_ID NVARCHAR(50)
			SELECT @EMPLOYEE_ID = EmployeeID FROM EmployeeMaster WHERE LoginId = @EmployeeID AND Deleted = 0 

			IF NOT EXISTS(SELECT EmployeeDematId FROM Employee_UserDematDetails WHERE EMPLOYEEID=@EMPLOYEE_ID AND (@DepositoryName='N' AND (ISNULL(ClientIDNumber,'')=@ClientIDNumber AND ISNULL(DepositoryIDNumber,'')=@DepositoryIDNumber) OR (@DepositoryName='C' AND ISNULL(ClientIDNumber,'')=@ClientIDNumber)) )
			BEGIN
				INSERT INTO [dbo].[Employee_UserDematDetails]
						   ([EmployeeID],
						   [DepositoryName],
						   [DepositoryParticipantName],
						   [ClientIDNumber],
						   [DematAccountType],
						   [DepositoryIDNumber],
						   [DPRecord],
						   [AccountName],
						   [IsActive],
						   [CREATED_BY],
						   [CREATED_ON],
						   [UPDATED_BY],
						   [UPDATED_ON],
						   [CMLCopy],
						   [CMLUploadStatus],
						   [CMLUploadDate],
						   [CMLCopyDisplayName],
						 --  [IsValidDematAcc],
						   ApproveStatus)
					 VALUES
						   (@EMPLOYEE_ID,
							@DepositoryName,
							@DepositoryParticipantName,
							@ClientIDNumber,
							@DematAccountType,
							@DepositoryIDNumber,
							@DPRecord,
							@AccountName,
							@IsActive,
							@EmployeeID,
							GetDate(),
							@EmployeeID,
							GetDate(),
							@CMLCopy,
							CASE WHEN @CMLCopy <> '' THEN 'Y' ELSE NULL END,	
							CASE WHEN @CMLCopy <> '' THEN GETDATE() ELSE NULL END,								
							@CMLCopyDisplayName,
							--CASE  WHEN (@ApproveStatus = 'P') THEN 0 ELSE 1 END,
							@ApproveStatus)

				  SET  @IsResult = @@ROWCOUNT
			END
			IF @IsResult > 0
			BEGIN			
			    SELECT 
				EmployeeID, DepositoryName, DepositoryParticipantName, ClientIDNumber, DematAccountType, DepositoryIDNumber, DPRecord, AccountName
				FROM Employee_UserDematDetails WHERE  EmployeeID = @EMPLOYEE_ID
			END
			ELSE
			BEGIN
			  SELECT 'F' AS [STATUS], CASE WHEN @@ERROR <> 0 THEN 'Error while save demat account.' ELSE 'Record already exist.' END AS [MESSAGE]
			END
			
END
GO


