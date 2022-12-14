/****** Object:  StoredProcedure [dbo].[PROC_UPLOAD_GOP_ASSOCIATION]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPLOAD_GOP_ASSOCIATION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPLOAD_GOP_ASSOCIATION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPLOAD_GOP_ASSOCIATION]
	@Action						CHAR(1),
	@V_Type_GOP_Association		dbo.TYPE_GOP_ASSOCIATION READONLY,
	@BaseGrantOptionId			VARCHAR(250) = NULL,
	@GrantLegId					INT = NULL,
	@CreatedBy					VARCHAR(100) = NULL,
	@Result						INT OUT
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN TRY
		
		DECLARE 
		@InsertedSuccessfully		INT  = 1,
		@ErrorOccured				INT  = 0
		
		IF @Action = 'V'
		BEGIN
			CREATE TABLE #ERRORS
			(
				ERROR_NO		INT IDENTITY(1,1),
				ERROR_MESSAGES	VARCHAR(MAX)
			)
			
			/*  CHECK 'Grant Option ID' IS EXISTS IN TABLE  */
			IF @GrantLegId = 0
			BEGIN

				IF EXISTS(SELECT DISTINCT [Base Grant Option Id] FROM @V_Type_GOP_Association WHERE [Base Grant Option Id] NOT IN (SELECT DISTINCT GrantOptionId FROM GrantLeg))
				BEGIN
					INSERT INTO #ERRORS
					SELECT DISTINCT 'INVALID BASE GRANT OPTION ID|' + [Base Grant Option Id] FROM @V_Type_GOP_Association WHERE [Base Grant Option Id] NOT IN (SELECT DISTINCT GrantOptionId FROM GrantLeg)
				END
			END
		
			/*  CHECK 'Grant Option ID' AND 'Grant Leg ID' COMBINATON PRESENT IN TABLE  */
			SELECT * INTO #TEMP_GRANTOPTION_IDs FROM
			(
				SELECT [Base Grant Option Id] AS GrantOptionId, [Association To Vest Id] AS	GrantLegID FROM @V_Type_GOP_Association WHERE [Association To Vest Id] IS NOT NULL
			)AS TEMP_GRANTOPTION_IDs
			
			SELECT * INTO #TEMP_GRANTOPTION_IDs_COMBINATION FROM 
			(
				SELECT GL.GrantOptionId FROM GrantLeg AS GL
				INNER JOIN #TEMP_GRANTOPTION_IDs AS TGI ON GL.GrantOptionId = TGI.GrantOptionId AND GL.GrantLegId = TGI.GrantLegID
			)AS TEMP_GRANTOPTION_IDs_COMBINATION
			
			DECLARE 
					@ORIGNAL_COUNT INT = (SELECT COUNT(GrantOptionId) FROM #TEMP_GRANTOPTION_IDs),
					@COMBINATION_COUNT INT = (SELECT COUNT(GrantOptionId) FROM #TEMP_GRANTOPTION_IDs_COMBINATION)

			IF (@ORIGNAL_COUNT <> @COMBINATION_COUNT)
			BEGIN
				INSERT INTO #ERRORS
				SELECT 'INVALID ASSOCIATION TO VEST ID|' + GrantOptionId FROM #TEMP_GRANTOPTION_IDs WHERE GrantOptionId NOT IN (SELECT GrantOptionId FROM #TEMP_GRANTOPTION_IDs_COMBINATION)
			END
			
			/*  CHECK DUPLICATE 'Grant Option ID' PRESENT IN EXCEL */
			INSERT INTO #ERRORS
			SELECT 
				'DUPLICATE BASE GRANT OPTION ID|' + GOPA1.[Base Grant Option Id] 
			FROM 
				@V_Type_GOP_Association GOPA1 INNER JOIN @V_Type_GOP_Association GOPA2 ON GOPA1.[Base Grant Option Id] = GOPA2.[Base Grant Option Id]
			WHERE 
				GOPA1.[Associated Grant Option Id] IS NULL
			GROUP BY GOPA1.[Base Grant Option Id]
			HAVING COUNT(GOPA1.[Base Grant Option Id]) > 1

			/*  GET ERRORS */
			SELECT ERROR_MESSAGES AS [Base grant option id] FROM #ERRORS
			
		END
		ELSE IF @Action = 'C'
		BEGIN
			
			TRUNCATE TABLE GrantOptionIdAssociation
			
			INSERT INTO GrantOptionIdAssociation 
			(BaseGrantOptionId, AssociatedGrantOptionId, AssociationToVestId, AssociatedGrantOptionQty, SharePriceAsOnDateOfGrant, CreatedOn, CreatedBy)
			SELECT [Base Grant Option Id], [Associated Grant Option Id], [Association To Vest Id], [Additional Quantity], [Share Price As On Date Of Grant], getdate(), @CreatedBy FROM @V_Type_GOP_Association
			
			SET @Result = @InsertedSuccessfully
			
		END
	END TRY
	BEGIN CATCH
	SELECT ERROR_MESSAGE()
		SET @Result = @ErrorOccured;
		
	END CATCH
	
	SET NOCOUNT OFF;
END
GO
