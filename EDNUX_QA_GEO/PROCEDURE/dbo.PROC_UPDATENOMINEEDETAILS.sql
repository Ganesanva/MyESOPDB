/****** Object:  StoredProcedure [dbo].[PROC_UPDATENOMINEEDETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATENOMINEEDETAILS]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATENOMINEEDETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PROC_UPDATENOMINEEDETAILS] 
	-- Add the parameters for the stored procedure here
	(
		    @NomineeID AS INT,
		    @NomineeName AS VARCHAR(50),
            @NomineeDOB AS VARCHAR(50),
            @PercentageOfShare AS VARCHAR(50),
            @NomineeAddress AS VARCHAR(500),
            @NameOfGuardian AS VARCHAR(50),
            @AddressOfGuardian AS VARCHAR(500),
            @GuardianDateOfBirth AS VARCHAR(50),
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
			@EmployeeID AS VARCHAR(20),
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
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE [dbo].[NomineeDetails]
			 SET 
				 [NomineeName] =  @NomineeName, 
				 [NomineeDOB] = @NomineeDOB, 
				 [PercentageOfShare] = @PercentageOfShare,
				 [NomineeAddress] =  @NomineeAddress,
				 [NameOfGuardian] =  @NameOfGuardian,
				 [AddressOfGuardian] = @AddressOfGuardian,
				 [GuardianDateOfBirth] =  @GuardianDateOfBirth,
				 [RelationOf_Nominee] = @RelationOf_Nominee,
				 [Nominee_PANNumber] = @Nominee_PANNumber,
				 [Nominee_EmailId] = @Nominee_EmailId,
				 [Nominee_ContactNumber] = @Nominee_ContactNumber,
				 [Nominee_ADHARNumber] = @Nominee_ADHARNumber, 
				 [Nominee_SIDNumber] = @Nominee_SIDNumber, 
				 [Nominee_Other1] = @Nominee_Other1,
				 [Nominee_Other2] = @Nominee_Other2,
				 [Nominee_Other3] = @Nominee_Other3,
				 [Nominee_Other4] = @Nominee_Other4,
				 [RelationOf_Guardian] = @RelationOf_Guardian, 
				 [Guardian_PANNumber] =  @Guardian_PANNumber, 
				 [Guardian_EmailId] = 	@Guardian_EmailId,
				 [Guardian_ContactNumber] = @Guardian_ContactNumber, 
				 [Guardian_ADHARNumber] = @Guardian_ADHARNumber, 
				 [Guardian_SIDNumber] = @Guardian_SIDNumber,
				 [Guardian_Other1] = @Guardian_Other1,
				 [Guardian_Other2] = @Guardian_Other2,
				 [Guardian_Other3] = @Guardian_Other3,
				 [Guardian_Other4] = @Guardian_Other4,
				 [UPDATED_BY] = @EmployeeID,
				 [Updated_On] = GETDATE()
			WHERE 
				NomineeId =  @NomineeID
				AND IsActive = 1

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
					   [Guardian_Other4]
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
		SET @SUCCESSFUL=0
	END CATCH
		
	SET NOCOUNT OFF;

END
GO
