DROP PROCEDURE [dbo].[PROC_INSERTNOMINEEDETAILS]
GO

/****** Object:  StoredProcedure [dbo].[PROC_INSERTNOMINEEDETAILS]    Script Date: 18-07-2022 17:13:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PROC_INSERTNOMINEEDETAILS]
	-- Add the parameters for the stored procedure here
	(
			@EmployeeID AS VARCHAR(20),
            @NomineeName AS VARCHAR(50),
            @NomineeDOB AS VARCHAR(50),
            @PercentageOfShare AS VARCHAR(50),
            @NomineeAddress AS VARCHAR(500),
            @NameOfGuardian AS VARCHAR(50),
            @AddressOfGuardian AS VARCHAR(500),
            @GuardianDateOfBirth VARCHAR(50),
			@RelationOf_Nominee AS VARCHAR(50),
			@Nominee_PANNumber AS VARCHAR(12),
			@Nominee_EmailId AS VARCHAR(50),
			@Nominee_ContactNumber AS VARCHAR(50), 
			@Nominee_ADHARNumber NVARCHAR(12),
			@Nominee_SIDNumber AS NVARCHAR(50),
			@Nominee_Other1 AS NVARCHAR(50),
			@Nominee_Other2 AS NVARCHAR(50),
			@Nominee_Other3 AS NVARCHAR(50),
			@Nominee_Other4 AS NVARCHAR(50),			
			@RelationOf_Guardian AS VARCHAR(50),
			@Guardian_PANNumber AS VARCHAR(12),
			@Guardian_EmailId AS VARCHAR(50),
			@Guardian_ContactNumber AS VARCHAR(50),
			@Guardian_ADHARNumber NVARCHAR(12),
			@Guardian_SIDNumber AS NVARCHAR(50),
			@Guardian_Other1 AS NVARCHAR(50),
			@Guardian_Other2 AS NVARCHAR(50),
			@Guardian_Other3 AS NVARCHAR(50),
			@Guardian_Other4 AS NVARCHAR(50),
			@IsActive AS BIT,
			@SUCCESSFUL BIT=NULL OUTPUT
			
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE   @TotalSumPercentageOfShare AS INT,
	          @IsNomineeAutoApproval BIT
    -- Insert statements for procedure here
	SELECT @EmployeeID = EmployeeID FROM EmployeeMaster WHERE LoginId = @EmployeeID AND Deleted = 0
	--Add validation nominee entires upto 10 limit with respect to EmployeeId
	Declare @NomineeCount INT
	SET @NomineeCount = (Select Count(NomineeId) from NomineeDetails where UserId in(@EmployeeID))	
	
	IF (@NomineeCount >= 10)	
		BEGIN
		SELECT @EmployeeID,
					   @NomineeName,
					   @NomineeDOB,
					   @PercentageOfShare,
					   @NomineeAddress,
					   @NameOfGuardian,
					   @AddressOfGuardian,
					   @GuardianDateOfBirth,
					   'You have to reach nominee limit.' AS msg
		SET @SUCCESSFUL=1
		return 
		END

	BEGIN TRY
		BEGIN TRANSACTION
		    SET @IsActive = 'true'

			INSERT INTO [dbo].[NomineeDetails]
					   ([UserID],
					   [NomineeName],
					   [NomineeDOB],
					   [PercentageOfShare],
					   [NomineeAddress],
					   [NameOfGuardian],
					   [AddressOfGuardian],
					   [GuardianDateOfBirth],
					   [RelationOf_Nominee],
					   [Nominee_PANNumber],
					   [Nominee_EmailId],
					   [Nominee_ContactNumber],
					   [Nominee_ADHARNumber], 
					   [Nominee_SIDNumber], 
					   [Nominee_Other1],
					   [Nominee_Other2],
					   [Nominee_Other3],
					   [Nominee_Other4],
					   [RelationOf_Guardian], 
					   [Guardian_PANNumber], 
					   [Guardian_EmailId],
					   [Guardian_ContactNumber],
					   [Guardian_ADHARNumber], 
					   [Guardian_SIDNumber],
					   [Guardian_Other1],
					   [Guardian_Other2],
					   [Guardian_Other3],
					   [Guardian_Other4],
					   [IsActive],
					   ApprovalStatus,
					   DateOfSubmissionOfForm,
					   [CREATED_BY],
					   [CREATED_ON],
					   [UPDATED_BY],
					   [UPDATED_ON])
				 VALUES
					   (@EmployeeID,
						@NomineeName,
						@NomineeDOB,
						@PercentageOfShare,
						@NomineeAddress,
						@NameOfGuardian,
						@AddressOfGuardian,
						@GuardianDateOfBirth,
						@RelationOf_Nominee,
						@Nominee_PANNumber,
						@Nominee_EmailId,
						@Nominee_ContactNumber,
						@Nominee_ADHARNumber, 
						@Nominee_SIDNumber, 
						@Nominee_Other1,
						@Nominee_Other2,
						@Nominee_Other3,
						@Nominee_Other4,
						@RelationOf_Guardian, 
						@Guardian_PANNumber, 
						@Guardian_EmailId,
						@Guardian_ContactNumber,
						@Guardian_ADHARNumber, 
						@Guardian_SIDNumber,
						@Guardian_Other1,
						@Guardian_Other2,
						@Guardian_Other3,
						@Guardian_Other4,
						@IsActive,
						NULL,
					    NULL,
						@EmployeeID,
						GetDate(),
						@EmployeeID,
						GetDate())

			SET @SUCCESSFUL=1
			IF(@SUCCESSFUL=1)
			BEGIN
				SELECT [UserID],
					   [NomineeName],
					   [NomineeDOB],
					   [PercentageOfShare],
					   [NomineeAddress],
					   [NameOfGuardian],
					   [AddressOfGuardian],
					   [GuardianDateOfBirth],
					   [RelationOf_Nominee],
					   [Nominee_PANNumber],
					   [Nominee_EmailId],
					   [Nominee_ContactNumber],
					   [Nominee_ADHARNumber], 
					   [Nominee_SIDNumber], 
					   [Nominee_Other1],
					   [Nominee_Other2],
					   [Nominee_Other3],
					   [Nominee_Other4],
					   [RelationOf_Guardian], 
					   [Guardian_PANNumber], 
					   [Guardian_EmailId],
					   [Guardian_ContactNumber],
					   [Guardian_ADHARNumber], 
					   [Guardian_SIDNumber],
					   [Guardian_Other1],
					   [Guardian_Other2],
					   [Guardian_Other3],
					   [Guardian_Other4],
					   [IsActive],
					   ApprovalStatus,
					   DateOfSubmissionOfForm,
					   [CREATED_BY],
					   [CREATED_ON],
					   [UPDATED_BY],
					   [UPDATED_ON],
					   'Nominee added successfully.' As Msg

				FROM  
					NomineeDetails 
				WHERE 
					UserID=@EmployeeID
					
             SELECT @TotalSumPercentageOfShare= SUM(convert (int,PercentageOfShare)) FROM  
					NomineeDetails 
				WHERE 
					UserID=@EmployeeID 
					SELECT @IsNomineeAutoApproval= IsNomineeAutoApproval FROM CompanyParameters
					IF(@IsNomineeAutoApproval=1 AND @TotalSumPercentageOfShare>=100 )
						BEGIN
							UPDATE  NomineeDetails SET ApprovalStatus='A',DateOfSubmissionOfForm=GETDATE() WHERE 
							UserID=@EmployeeID
						END
					ELSE
						BEGIN
							UPDATE  NomineeDetails SET ApprovalStatus='P',DateOfSubmissionOfForm=NULL WHERE 
							UserID=@EmployeeID
						END
			END
  
			
		COMMIT TRANSACTION
     END TRY
	 BEGIN CATCH
		ROLLBACK TRANSACTION
		set @SUCCESSFUL=0
	 END CATCH	
END
GO


