/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_SHARES]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_UPDATE_SHARES]
GO
/****** Object:  StoredProcedure [dbo].[PROC_UPDATE_SHARES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_UPDATE_SHARES]	
	@IS_EXCEPTIONAL_CASE BIT = 0
AS	
BEGIN

	IF(@IS_EXCEPTIONAL_CASE = 1)
		RETURN
	 
	SET NOCOUNT ON;
	DECLARE 
		@ApprovalId								AS VARCHAR(50),
		@PrevApprovalId							AS VARCHAR(50),
		@SchemeId								AS VARCHAR(50),
		@TOTAL_ROWS								AS INT, 
		@LOOP_PER_ROW							AS INT,
		@UnVestedCancelledOptions				CHAR(1),
		@VestedCancelledOptions					CHAR(1), 
		@LapsedOptions							CHAR(1),
		@ApplyBonusTo							CHAR(1),
		@ApplySplitTo							CHAR(1),
		@ShareHolderApproval_NumberOfShares		AS INT,
		@GrantApproval_NumberOfShares			AS INT,
		@UnVestedCancelledOptions_CNQty			AS INT,
		@VestedCancelledOptions_CNQty			AS INT,
		@LapsedOptions_Qty						AS INT
	
	SELECT @ApplyBonusTo = ApplyBonusTo, @ApplySplitTo = ApplySplitTo FROM BonusSplitPolicy

	CREATE TABLE #SCHEME 
		(
			SCHEME_SR INT PRIMARY KEY IDENTITY(1,1),
			ApprovalId varchar(50),
			SchemeId varchar(50),
			UnVestedCancelledOptions CHAR(1),
			VestedCancelledOptions CHAR(1),
			LapsedOptions  CHAR(1)
		)

	CREATE TABLE #TEMP_UPDATED_DATA 
		(
			SR_NO INT PRIMARY KEY,
			AvailableShares INT,
			UnvestVestedCnQty_LapseQty INT,
			ApprovalId varchar(100),
			SchemeId varchar(100)
		)

	INSERT INTO #SCHEME SELECT DISTINCT ApprovalId, SchemeId, UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions  FROM Scheme 

	SET @TOTAL_ROWS = (SELECT COUNT(SCHEME_SR) FROM #SCHEME)

	SET @LOOP_PER_ROW = 1;
	SET @PrevApprovalId = ''
	
	WHILE @LOOP_PER_ROW <= @TOTAL_ROWS
	BEGIN
		SELECT 
			@ApprovalId = ApprovalId,
			@SchemeId = SchemeId,
			@UnVestedCancelledOptions = UnVestedCancelledOptions,
			@VestedCancelledOptions = VestedCancelledOptions, 
			@LapsedOptions = LapsedOptions
			
		FROM 
			#SCHEME 
		WHERE 
			SCHEME_SR = @LOOP_PER_ROW
		
		--Fetching Total Number of Shares
		SET @ShareHolderApproval_NumberOfShares = (SELECT SUM(NumberOfShares) FROM ShareHolderApproval WHERE ApprovalId = @ApprovalId)
		
		--Fetching Total Number of Shares from GrantApproval 
		SET @GrantApproval_NumberOfShares = (SELECT SUM(NumberOfShares) FROM GrantApproval GA WHERE GA.ApprovalId = @ApprovalId AND GA.SchemeId = @SchemeId)
		--SET @GrantApproval_NumberOfShares = (SELECT CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN ISNULL(SUM(GL.GrantedQuantity),0) ELSE ISNULL(SUM(GL.SplitQuantity),0) END ELSE ISNULL(SUM(GL.BonusSplitQuantity),0)END FROM GrantLeg GL WHERE GL.ApprovalId = @ApprovalId AND GL.SchemeId = @SchemeId)
		--PRINT @GrantApproval_NumberOfShares
		
		--Fetching Total Number of Options UnVestedCancelledOptions
		BEGIN
		IF @UnVestedCancelledOptions = 'Y' 
		BEGIN
			SET @UnVestedCancelledOptions_CNQty = 
			(SELECT 	
				CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN 
					CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN 
						ISNULL(SUM(CN.CancelledQuantity),0)
					ELSE 
						ISNULL(SUM(CN.SplitCancelledQuantity),0)
					END
				ELSE
					ISNULL(SUM(CN.BonusSplitCancelledQuantity),0)
				END AS CancelledQuantity
			 FROM 
				GrantLeg GL	INNER JOIN Cancelled CN ON GL.GrantLegId = CN.GrantLegId AND CN.GrantLegSerialNumber = GL.ID
			 WHERE CN.CancelledDate < GL.VestingDate
				AND CN.CancelledQuantity > 0
				AND GL.ApprovalId = @ApprovalId
				AND GL.SchemeId = @SchemeId)			 
		END
		
		ELSE
			SET @UnVestedCancelledOptions_CNQty = 0
		END
		
		--Fetching Total Number of Options VestedCancelledOptions
		BEGIN
		IF @VestedCancelledOptions = 'Y'
		BEGIN
			SET @VestedCancelledOptions_CNQty = 			
			(SELECT 	
				CASE WHEN (SELECT ApplyBonusTo FROM BonusSplitPolicy) = 'V' THEN 
					CASE WHEN (SELECT ApplySplitTo FROM BonusSplitPolicy) = 'V' THEN 
						ISNULL(SUM(CN.CancelledQuantity),0)
					ELSE 
						ISNULL(SUM(CN.SplitCancelledQuantity),0)
					END
				ELSE
					ISNULL(SUM(CN.BonusSplitCancelledQuantity),0)
				END AS CancelledQuantity
			 FROM 
				GrantLeg GL	INNER JOIN Cancelled CN ON GL.GrantLegId = CN.GrantLegId AND CN.GrantLegSerialNumber = GL.ID
			 WHERE CN.CancelledDate >= GL.VestingDate
			 AND CN.CancelledQuantity > 0
			 AND GL.ApprovalId = @ApprovalId
			 AND GL.SchemeId = @SchemeId)
		END
		
		ELSE
			SET @VestedCancelledOptions_CNQty = 0
		END
		--PRINT @UnVestedCancelledOptions_CNQty + @VestedCancelledOptions_CNQty
		
		--Fetching Total Number of lapsed Options
		BEGIN
		IF @LapsedOptions = 'Y' 
			SET @LapsedOptions_Qty = (SELECT SUM(LapsedQuantity) FROM GrantLeg WHERE ApprovalId = @ApprovalId AND SchemeId = @SchemeId)
		ELSE
			SET @LapsedOptions_Qty = 0
		END
		--PRINT @LapsedOptions_Qty
		
		--PRINT '@PrevApprovalId=' + @PrevApprovalId
		--PRINT '@ApprovalId=' + @ApprovalId
		--PRINT (@GrantApproval_NumberOfShares + @UnVestedCancelledOptions_CNQty + @VestedCancelledOptions_CNQty + @LapsedOptions_Qty)
		--PRINT '@GrantApproval_NumberOfShares=' + CONVERT(VARCHAR, @GrantApproval_NumberOfShares)
		--PRINT '@UnVestedCancelledOptions_CNQty=' + CONVERT(VARCHAR, @UnVestedCancelledOptions_CNQty)
		--PRINT '@VestedCancelledOptions_CNQty=' + CONVERT(VARCHAR, @VestedCancelledOptions_CNQty)
		--PRINT '@LapsedOptions_Qty=' + CONVERT(VARCHAR, @LapsedOptions_Qty)
		
		IF(@PrevApprovalId = '' OR @PrevApprovalId <> @ApprovalId)
		BEGIN
			INSERT INTO #TEMP_UPDATED_DATA					
			SELECT 
				@LOOP_PER_ROW AS SR_NO,
				ISNULL(@GrantApproval_NumberOfShares,0) AS AvailableShares,
				(ISNULL(@UnVestedCancelledOptions_CNQty,0) + ISNULL(@VestedCancelledOptions_CNQty,0) + ISNULL(@LapsedOptions_Qty,0)) AS UnvestVestedCnQty_LapseQty,
				@ApprovalId AS ApprovalId,
				@SchemeId AS SchemeId
			
			SET @PrevApprovalId = @ApprovalId
		END
		
		ELSE
		BEGIN
			UPDATE 
				#TEMP_UPDATED_DATA 
			SET 
				AvailableShares = ISNULL(AvailableShares,0) + ISNULL(@GrantApproval_NumberOfShares, 0),
				UnvestVestedCnQty_LapseQty = UnvestVestedCnQty_LapseQty + @UnVestedCancelledOptions_CNQty + @VestedCancelledOptions_CNQty + @LapsedOptions_Qty
			WHERE 
				ApprovalId = @ApprovalId
				
		END
		
		SET @LOOP_PER_ROW = @LOOP_PER_ROW + 1
	END

	SET @LOOP_PER_ROW = 1	
	SET @TOTAL_ROWS = (SELECT COUNT(SR_NO) FROM #TEMP_UPDATED_DATA)
	
	-- Update available shares in ShareHolderApproval table.
	WHILE @LOOP_PER_ROW <= @TOTAL_ROWS
	BEGIN
		BEGIN TRAN
		
		IF((SELECT ((SHA.NumberOfShares - TUD.AvailableShares) + UnvestVestedCnQty_LapseQty) 
			FROM 
				#TEMP_UPDATED_DATA TUD INNER JOIN ShareHolderApproval SHA ON SHA.ApprovalId = TUD.ApprovalId
			WHERE 
				TUD.SR_NO = @LOOP_PER_ROW AND
				TUD.ApprovalId = SHA.ApprovalId) < 0
			)
		BEGIN
			UPDATE 
				ShareHolderApproval 
			SET 
				AvailableShares = 0
			FROM 
				#TEMP_UPDATED_DATA TUD INNER JOIN ShareHolderApproval SHA ON SHA.ApprovalId = TUD.ApprovalId
			WHERE 
				TUD.SR_NO = @LOOP_PER_ROW AND
				TUD.ApprovalId = SHA.ApprovalId
			
			DECLARE @MAIL_BODY AS VARCHAR(200)
			SET @MAIL_BODY = '<html><body><font face="Calibri" size="3">Negative value found in ShareHolderApproval.AvailableShares in ' + (select DB_NAME()) + ' Company for ApprovalID=' + (SELECT ApprovalId FROM #TEMP_UPDATED_DATA WHERE SR_NO = @LOOP_PER_ROW) + '</font>	</body></html>'
			EXEC msdb.dbo.sp_send_dbmail  
				@recipients = 'amin.mutawlli@esopdirect.com;narendra@esopdirect.com',												
				@body = @MAIL_BODY,
				@body_format = 'HTML',
				@subject = 'Negative Vaue Found in ShareHolderApproval',
				@from_address = 'noreply@esopdirect.com' ;
		END
		
		ELSE
		BEGIN
			UPDATE 
				ShareHolderApproval 
			SET 
				AvailableShares = ((SHA.NumberOfShares - TUD.AvailableShares) + UnvestVestedCnQty_LapseQty)
			FROM 
				#TEMP_UPDATED_DATA TUD INNER JOIN ShareHolderApproval SHA ON SHA.ApprovalId = TUD.ApprovalId
			WHERE 
				TUD.SR_NO = @LOOP_PER_ROW AND
				TUD.ApprovalId = SHA.ApprovalId
		END
		COMMIT TRAN
		SET @LOOP_PER_ROW = @LOOP_PER_ROW + 1
	END

	DROP TABLE #TEMP_UPDATED_DATA
	DROP TABLE #SCHEME

	SET NOCOUNT OFF;
END
GO
