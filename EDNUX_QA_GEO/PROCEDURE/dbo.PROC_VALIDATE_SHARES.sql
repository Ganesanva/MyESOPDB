/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_SHARES]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_VALIDATE_SHARES]
GO
/****** Object:  StoredProcedure [dbo].[PROC_VALIDATE_SHARES]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_VALIDATE_SHARES]	
AS	
BEGIN

	
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
		@GrantLeg_NumberOfShares				AS INT,
		@UnVestedCancelledOptions_CNQty			AS INT,
		@VestedCancelledOptions_CNQty			AS INT,
		@LapsedOptions_Qty						AS INT,
		@AVAILABLESHARES_GL						AS INT,
		@AVAILABLESHARES_GA						AS INT,
		@AVAILABLESHARES_SHA					AS INT
	
	SET NOCOUNT ON;
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

	CREATE TABLE #TEMP_UPDATED_DATA_GA 
		(
			SR_NO INT PRIMARY KEY,
			AvailableShares INT,
			UnvestVestedCnQty_LapseQty INT,
			ApprovalId varchar(100),
			SchemeId varchar(100)
		)

	CREATE TABLE #TEMP_UPDATED_DATA_GL 
		(
			SR_NO_GL INT PRIMARY KEY,
			AvailableShares_GL INT,
			UnvestVestedCnQty_LapseQty_GL INT,
			ApprovalId_GL varchar(100),
			SchemeId_GL varchar(100)
		)

	INSERT INTO #SCHEME(ApprovalId,SchemeId,UnVestedCancelledOptions,VestedCancelledOptions,LapsedOptions) SELECT DISTINCT ApprovalId, SchemeId, UnVestedCancelledOptions, VestedCancelledOptions, LapsedOptions  FROM Scheme 

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
		
		--Fetching Total Number of Shares from ShareHolderApproval
		SET @ShareHolderApproval_NumberOfShares = (SELECT SUM(NumberOfShares) FROM ShareHolderApproval WHERE ApprovalId = @ApprovalId)
		
		--Fetching Total Number of Shares from GrantApproval 
		SET @GrantApproval_NumberOfShares = (SELECT SUM(NumberOfShares) FROM GrantApproval GA WHERE GA.ApprovalId = @ApprovalId AND GA.SchemeId = @SchemeId)
		
		--Fetching Total Number of Shares from GrantLeg 
		SET @GrantLeg_NumberOfShares = (SELECT CASE WHEN (@ApplyBonusTo) = 'V' THEN  CASE WHEN (@ApplySplitTo) = 'V' THEN ISNULL(SUM(GL.GrantedQuantity),0)  ELSE  ISNULL(SUM(GL.SplitQuantity),0)  END  ELSE ISNULL(SUM(GL.BonusSplitQuantity),0) END FROM GrantLeg GL WHERE GL.ApprovalId = @ApprovalId AND GL.SchemeId = @SchemeId)
		
		--Fetching Total Number of Options UnVestedCancelledOptions
		BEGIN
		IF @UnVestedCancelledOptions = 'Y' 
		BEGIN
			SET @UnVestedCancelledOptions_CNQty = 
			(SELECT 	
				CASE WHEN (@ApplyBonusTo) = 'V' THEN 
					CASE WHEN (@ApplySplitTo) = 'V' THEN 
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
				CASE WHEN (@ApplyBonusTo) = 'V' THEN 
					CASE WHEN (@ApplySplitTo) = 'V' THEN 
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
		
		--Inserting/Updating the number of shares in temp table for GrantApproval and GrantLeg respectively.		
		IF(@PrevApprovalId = '' OR (@PrevApprovalId <> @ApprovalId))
		BEGIN
			INSERT INTO #TEMP_UPDATED_DATA_GA					
			SELECT 
				@LOOP_PER_ROW AS SR_NO,
				ISNULL(@GrantApproval_NumberOfShares,0) AS AvailableShares,
				(ISNULL(@UnVestedCancelledOptions_CNQty,0) + ISNULL(@VestedCancelledOptions_CNQty,0) + ISNULL(@LapsedOptions_Qty,0)) AS UnvestVestedCnQty_LapseQty,
				@ApprovalId AS ApprovalId,
				@SchemeId AS SchemeId
			
			INSERT INTO #TEMP_UPDATED_DATA_GL					
			SELECT 
				@LOOP_PER_ROW AS SR_NO_GL,
				ISNULL(@GrantLeg_NumberOfShares,0) AS AvailableShares_GL,
				(ISNULL(@UnVestedCancelledOptions_CNQty,0) + ISNULL(@VestedCancelledOptions_CNQty,0) + ISNULL(@LapsedOptions_Qty,0)) AS UnvestVestedCnQty_LapseQty_GL,
				@ApprovalId AS ApprovalId_GL,
				@SchemeId AS SchemeId_GL
			
			SET @PrevApprovalId = @ApprovalId
		END
		
		ELSE
		BEGIN
			UPDATE 
				#TEMP_UPDATED_DATA_GA 
			SET 
				AvailableShares = ISNULL(AvailableShares,0) + ISNULL(@GrantApproval_NumberOfShares, 0),
				UnvestVestedCnQty_LapseQty = UnvestVestedCnQty_LapseQty + @UnVestedCancelledOptions_CNQty + @VestedCancelledOptions_CNQty + @LapsedOptions_Qty
			WHERE 
				ApprovalId = @ApprovalId
				
			UPDATE 
				#TEMP_UPDATED_DATA_GL 
			SET 
				AvailableShares_GL = ISNULL(AvailableShares_GL,0) + ISNULL(@GrantLeg_NumberOfShares, 0),
				UnvestVestedCnQty_LapseQty_GL = UnvestVestedCnQty_LapseQty_GL + @UnVestedCancelledOptions_CNQty + @VestedCancelledOptions_CNQty + @LapsedOptions_Qty
			WHERE 
				ApprovalId_GL = @ApprovalId
				
		END
		
		SET @LOOP_PER_ROW = @LOOP_PER_ROW + 1
	END

	SET @LOOP_PER_ROW = 1	
	SET @TOTAL_ROWS = (SELECT COUNT(SR_NO) FROM #TEMP_UPDATED_DATA_GA) 
		
	-- Now validate whether the Number of shares in Grant Approval table and Granted Quantity in Grantleg table are Equal. If not then send alert to developers.
	DECLARE @MAIL_BODY AS VARCHAR(500)
	WHILE @LOOP_PER_ROW <= @TOTAL_ROWS
	BEGIN
		SELECT
			@AVAILABLESHARES_GA = ((SHA.NumberOfShares - TUD_GA.AvailableShares) + UnvestVestedCnQty_LapseQty),
			@ApprovalId = TUD_GA.ApprovalId,
			@SchemeId = TUD_GA.SchemeId
			
		FROM 
			#TEMP_UPDATED_DATA_GA TUD_GA INNER JOIN ShareHolderApproval SHA ON SHA.ApprovalId = TUD_GA.ApprovalId
		WHERE 
			TUD_GA.SR_NO = @LOOP_PER_ROW AND
			TUD_GA.ApprovalId = SHA.ApprovalId
			
		SELECT
			@AVAILABLESHARES_GL = ((SHA.NumberOfShares - TUD_GL.AvailableShares_GL) + UnvestVestedCnQty_LapseQty_GL),
			@ApprovalId = TUD_GL.ApprovalId_GL,
			@SchemeId = TUD_GL.SchemeId_GL
		FROM 
			#TEMP_UPDATED_DATA_GL TUD_GL INNER JOIN ShareHolderApproval SHA ON SHA.ApprovalId = TUD_GL.ApprovalId_GL
		WHERE 
			TUD_GL.SR_NO_GL = @LOOP_PER_ROW AND
			TUD_GL.ApprovalId_GL = SHA.ApprovalId
			
		--PRINT @AVAILABLESHARES_GA
		--PRINT @AVAILABLESHARES_GL
		IF(@AVAILABLESHARES_GA <> @AVAILABLESHARES_GL)
		BEGIN
			
			SET @MAIL_BODY = '<html><body><font face="Calibri" size="3">
			Available shares in "GrantLeg"(i.e. PoolBanlanceReport) is ' + CONVERT(VARCHAR(100), @AVAILABLESHARES_GA) +' and "GrantApproval" table is ' + CONVERT(VARCHAR(100), @AVAILABLESHARES_GL) +' are not same for ' + (select DB_NAME()) + ' Company 
			for Approval ID : ' + @ApprovalId + ' and SchemeID : ' + @SchemeId +'</font>	</body></html>'
			
			EXEC msdb.dbo.sp_send_dbmail  
				@recipients = 'dev@esopdirect.com',												
				@body = @MAIL_BODY,
				@body_format = 'HTML',
				@subject = 'Available shares in "GrantLeg" and "GrantApproval" table are not same',
				@from_address = 'noreply@esopdirect.com' ;
		END
					
		SET @LOOP_PER_ROW = @LOOP_PER_ROW + 1
	END
	
	
	
	--PRINT @AVAILABLESHARES_GA
	--PRINT @AVAILABLESHARES_GL
	DROP TABLE #TEMP_UPDATED_DATA_GA
	DROP TABLE #TEMP_UPDATED_DATA_GL
	DROP TABLE #SCHEME
	
	SET NOCOUNT OFF;	
END
GO
