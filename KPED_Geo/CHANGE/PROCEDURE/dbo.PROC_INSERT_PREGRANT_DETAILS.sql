/****** Object:  StoredProcedure [dbo].[PROC_INSERT_PREGRANT_DETAILS]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].PROC_INSERT_PREGRANT_DETAILS
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERT_PREGRANT_DETAILS]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERT_PREGRANT_DETAILS]
	-- Add the parameters for the stored procedure here
	@EmployeeId			VARCHAR(50),
	@SchemeName			VARCHAR(100),
	@LetterCode			VARCHAR(100),
    @GrantDate			DATETIME,
	@GrantType			VARCHAR (100),
    @NoOfOptions		NUMERIC(18,0),
	@Currency			VARCHAR(50),
    @ExercisePrice		NUMERIC(18,2),
	@FirstVestDate		DATETIME,
	@NoOfVests			NUMERIC(18,0),
	@VestingFrequency	NUMERIC(18,0),
	@VestingPercentage	VARCHAR(1000),
	@Adjustment			CHAR(1),
	@CompanyName		VARCHAR(100),
	@CompanyAddress		VARCHAR(500),
	@LotNumber			VARCHAR(10),
	@LastAcceptanceDate DATETIME,
	@Field1				VARCHAR(MAX),
	@Field2				VARCHAR(MAX),
	@Field3				VARCHAR(MAX),
	@Field4				VARCHAR(MAX),
	@Field5				VARCHAR(MAX),
	@Field6				VARCHAR(MAX),
	@Field7				VARCHAR(MAX),
	@Field8				VARCHAR(MAX),
	@Field9				VARCHAR(MAX),
	@Field10			VARCHAR(MAX),
	@GrantAppDetails	GrntAccMassUpDetType READONLY,
	@CASE				VARCHAR(50),
	@UserId				VARCHAR(50),
	@VestingType		VARCHAR(2),
	@Result				INT = -1 OUT 
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTERFERING WITH SELECT STATEMENTS.
	DECLARE @Identity INT
	SET NOCOUNT ON;

    IF(UPPER(@CASE) = 'INSERT_IN_MASTER')
	BEGIN
		
		DECLARE @IS_LETTERCODE_PRESENT VARCHAR(10) = NULL, @IS_STATUS_CHANGED VARCHAR(10) = NULL
		
		SET @IS_LETTERCODE_PRESENT = (SELECT TOP 1 LetterCode FROM GrantAccMassUpload WHERE LetterCode = @LetterCode)
		
		IF (@IS_LETTERCODE_PRESENT IS NULL)
		BEGIN
			INSERT INTO GrantAccMassUpload
			(	
				EmployeeID, SchemeName, LetterCode, GrantDate, GrantType, NoOfOptions, Currency, ExercisePrice, FirstVestDate, 
				NoOfVests, VestingFrequency, VestingPercentage, Adjustment, CompanyName, CompanyAddress, LotNumber, 
				LastAcceptanceDate, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9, Field10,
				CreatedBy, CreatedOn, LastUpdatedBy, LastUpdatedOn, VestingType
			)
			VALUES
			(
				@EmployeeId, @SchemeName, @LetterCode, @GrantDate, @GrantType, @NoOfOptions, @Currency, @ExercisePrice, @FirstVestDate, 
				@NoOfVests, @VestingFrequency, @VestingPercentage, @Adjustment, @CompanyName, @CompanyAddress, @LotNumber,	
				@LastAcceptanceDate, @Field1, @Field2, @Field3, @Field4, @Field5, @Field6, @Field7, @Field8, @Field9, @Field10,
				@UserId, GETDATE(), @UserId, GETDATE(), @VestingType
			)		
			
			IF(@@ROWCOUNT > 0)
			BEGIN
				SELECT @Identity = SCOPE_IDENTITY()
				
				INSERT INTO GrantAccMassUploadDet (GAMUID,LetterCode,VestPeriod,VestingDate,NoOfOptions, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9, Field10, VestingType)
				SELECT @Identity,LetterCode,VestingPeriodId,VestingDate,NoOfOptions, Field1, Field2, Field3, Field4, Field5, Field6, Field7, Field8, Field9, Field10, VestingType  FROM @GrantAppDetails		
				
				IF (@@ROWCOUNT > 0)
					SELECT @Result = 1
				ELSE
					SELECT @Result = 0
			END	
		END
		ELSE
		BEGIN
			SET @Result = 2
			
			DECLARE @LAST_ACCEPTANCE_DATE VARCHAR(50), @ACCEPTANCE_STATUS VARCHAR(50), @GAMUID VARCHAR(20) 
			
			SET @LAST_ACCEPTANCE_DATE = (SELECT TOP 1 LastAcceptanceDate FROM GrantAccMassUpload WHERE LetterCode = @LetterCode)
			SET @ACCEPTANCE_STATUS = (SELECT TOP 1 LetterAcceptanceStatus FROM GrantAccMassUpload WHERE LetterCode = @LetterCode)
			
			IF  (@LAST_ACCEPTANCE_DATE < GETDATE() AND (@ACCEPTANCE_STATUS = 'P' OR @ACCEPTANCE_STATUS IS NULL))
			BEGIN
				SET @GAMUID = (SELECT TOP 1 GAMUID FROM GrantAccMassUpload WHERE LetterCode = @LetterCode)
				
				-- UPDATE GrantAccMassUpload TABLE
				UPDATE GrantAccMassUpload SET 
				EmployeeID = @EmployeeID, 
				SchemeName = @SchemeName, 
				LetterCode = @LetterCode, 
				GrantDate = @GrantDate, 
				GrantType = @GrantType, 
				NoOfOptions = @NoOfOptions, 
				Currency = @Currency, 
				ExercisePrice = @ExercisePrice, 
				FirstVestDate = @FirstVestDate, 
				NoOfVests = @NoOfVests, 
				VestingFrequency = @VestingFrequency, 
				VestingPercentage = @VestingPercentage, 
				Adjustment = @Adjustment, 
				CompanyName = @CompanyName, 
				CompanyAddress = @CompanyAddress, 
				LotNumber = @LotNumber, 
				LastAcceptanceDate = @LastAcceptanceDate, 
				Field1 = @Field1, 
				Field2 = @Field2, 
				Field3 = @Field3, 
				Field4 = @Field4, 
				Field5 = @Field5, 
				Field6 = @Field6, 
				Field7 = @Field7, 
				Field8 = @Field8, 
				Field9 = @Field9, 
				Field10 = @Field10,
				LastUpdatedBy = @UserId, 
				LastUpdatedOn = GETDATE(),
				VestingType = @VestingType
				
				WHERE LetterCode = @LetterCode
				
				-- UPDATE GrantAccMassUploadDet TABLE
				UPDATE GrantAccMassUploadDet SET
				LetterCode = @LetterCode,
				VestPeriod = GAP.VestingPeriodId,
				VestingDate = GAP.VestingDate,
				NoOfOptions = GAP.NoOfOptions, 
				Field1 = GAP.Field1, 
				Field2 = GAP.Field2, 
				Field3 = GAP.Field3,
				Field4 = GAP.Field4,
				Field5 = GAP.Field5,
				Field6 = GAP.Field6,
				Field7 = GAP.Field7, 
				Field8 = GAP.Field8, 
				Field9 = GAP.Field9, 
				Field10 = GAP.Field10,
				VestingType = GAP.VestingType
				
				FROM @GrantAppDetails GAP WHERE GAMUID = @GAMUID
				
				SET @Result = 3
			END
		END
	END
	SELECT @Result	
END
GO

