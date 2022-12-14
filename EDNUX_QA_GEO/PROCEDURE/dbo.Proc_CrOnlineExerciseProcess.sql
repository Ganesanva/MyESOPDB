/****** Object:  StoredProcedure [dbo].[Proc_CrOnlineExerciseProcess]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[Proc_CrOnlineExerciseProcess]
GO
/****** Object:  StoredProcedure [dbo].[Proc_CrOnlineExerciseProcess]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 
-- =============================================
CREATE PROCEDURE [dbo].[Proc_CrOnlineExerciseProcess]
(
 @INSTRUMENT_ID INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
	DECLARE @PaymentMode CHAR(1)
	DECLARE @PayModeName VARCHAR(50)    
    DECLARE @RowCount INT;
	DECLARE @MIT_ID INT;
    
    -- Insert statements for procedure here
	-- Create table for Collect payment mode detail 
	-- Method is used to insert default data for which "Exercise form required form payment mode"
	
	DECLARE @PaymentModes TABLE
	(
		RowID INT NOT NULL,
		PaymentMode CHAR(1),
		PayModeName VARCHAR (50)    
	)

	INSERT INTO @PaymentModes (RowID, PaymentMode, PayModeName)
	SELECT ROW_NUMBER() OVER (ORDER BY id) AS Row, PaymentMode, PayModeName FROM PaymentMaster WHERE (Exerciseform_Submit ='Y') AND (PaymentMode NOT IN ('O','C','A','P'))

	DECLARE @i int
	SELECT @i = min(RowID) FROM @PaymentModes
	DECLARE @max int
	SELECT @max = max(RowID) FROM @PaymentModes

	WHILE @i <= @max BEGIN
	
		SELECT @PaymentMode = PaymentMode, @PayModeName = PayModeName FROM @PaymentModes WHERE RowID = @i		
		
		SELECT @RowCount = Count(MIT_ID) from MST_INSTRUMENT_TYPE
		WHILE @RowCount > 0
		BEGIN
		   SELECT @MIT_ID = INSTRUMENT_TYPES.MIT_ID FROM (SELECT ROW_NUMBER() OVER (ORDER BY MIT_ID DESC) AS ROW_ID, MIT_ID from MST_INSTRUMENT_TYPE) INSTRUMENT_TYPES
           WHERE INSTRUMENT_TYPES.ROW_ID = @RowCount 
		
			-- 1 FOR CHEQUE
			IF (UPPER(@PaymentMode) = 'Q')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			-- 2 FOR DD
			IF (UPPER(@PaymentMode) = 'D')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			-- 3 FOR WIRE TANSFER
			IF (UPPER(@PaymentMode) = 'W')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			--4 FOR NEFT / RTGS
			IF (UPPER(@PaymentMode) = 'R')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			-- 5 FOR ONLINE
			IF (UPPER(@PaymentMode) = 'N')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			-- 6 FOR DIRECT DEBIT
			IF (UPPER(@PaymentMode) = 'I')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			-- 7 FOR FUNDING
			IF (UPPER(@PaymentMode) = 'F')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			-- 8 FOR NOT APPLICABLE MODE(X)
			IF (UPPER(@PaymentMode) = 'X')
			BEGIN
				IF NOT EXISTS(SELECT 1 AS RESULT FROM ExerciseProcessSetting WHERE (UPPER(PaymentMode) = @PaymentMode) AND MIT_ID = @MIT_ID)
					BEGIN
						INSERT INTO ExerciseProcessSetting (PaymentMode, TrustRecOfEXeForm, NTrustsRecOfEXeForm, MIT_ID, LastUpdatedBy, LastUpdatedOn) VALUES (@PaymentMode, 'Y', 'Y', @MIT_ID, 'Admin', GETDATE())
					END
			END
			
			SET @RowCount = @RowCount - 1;
			
		 END
			
		SET @i = @i + 1
	
	END

	SELECT 
	( CASE 
		   WHEN UPPER(EP.PaymentMode) = 'Q' THEN 'Cheque'
		   WHEN UPPER(EP.PaymentMode) = 'D' THEN 'Demand Draft'
		   WHEN UPPER(EP.PaymentMode) = 'W' THEN 'Wire Transfer'
		   WHEN UPPER(EP.PaymentMode) = 'R' THEN 'NEFT/RTGS'
		   WHEN UPPER(EP.PaymentMode) = 'N' THEN 'Online'
		   WHEN UPPER(EP.PaymentMode) = 'I' THEN 'Direct Debit'
		   WHEN UPPER(EP.PaymentMode) = 'F' THEN 'Funding'
		   WHEN UPPER(EP.PaymentMode) = 'A' THEN 'Cashless'
		   WHEN UPPER(EP.PaymentMode) = 'X' THEN 'Not Applicable'
		   WHEN UPPER(EP.PaymentMode) = 'P' THEN 'Cashless - Sell To Cover'
		   WHEN UPPER(EP.PaymentMode) = 'A' THEN 'Cashless - Sell-All'
	END) AS cPaymentMode, EP.PaymentMode,
	EP.TrustRecOfEXeForm, EP.NTrustsRecOfEXeForm, EP.TrustDepositOfPayInstrument, EP.NTrustDepositOfPayInstrument, EP.TrustPayRecConfirmation, EP.NTrustPayRecConfirmation, 
	EP.TrustGenShareTransList, EP.NTrustGenShareTransList FROM ExerciseProcessSetting AS EP
	INNER JOIN PaymentMaster AS PM ON PM.PaymentMode = EP.PaymentMode WHERE EP.MIT_ID = ISNULL(@INSTRUMENT_ID, 1)					
END

GO
