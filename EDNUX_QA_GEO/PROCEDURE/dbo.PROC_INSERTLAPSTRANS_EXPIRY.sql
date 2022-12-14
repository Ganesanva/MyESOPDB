/****** Object:  StoredProcedure [dbo].[PROC_INSERTLAPSTRANS_EXPIRY]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_INSERTLAPSTRANS_EXPIRY]
GO
/****** Object:  StoredProcedure [dbo].[PROC_INSERTLAPSTRANS_EXPIRY]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PROC_INSERTLAPSTRANS_EXPIRY] 
( 
	@SEQ_GrantLeg_ID BIGINT,
	--@LAPSE_QTY VARCHAR(MAX)
	 @GrantOptionId NVARCHAR(MAX), 
	 @GrantLegId NVARCHAR(MAX), 
	 @VestingType NVARCHAR(MAX), 
	 @Expiry_Lapse_Quantity NVARCHAR(MAX),
	 @Expiry_Lapse_Date DATETIME
	

)
	-- Add the parameters for the stored procedure here	
AS
BEGIN

DECLARE @EmployeeId NVARCHAR(250)
SET @EmployeeId=(SELECT EmployeeId FROM GrantOptions WHERE GrantOptionId=@GrantOptionId)

-----------------------------------------------------------------
	-- CHECK LAPSE TRANSE SEQUENCE ID AVAILABLE IN SEQUENCE TABLE
	-----------------------------------------------------------------
	
	IF NOT EXISTS (SELECT 1 FROM SequenceTable WHERE UPPER(Seq1) ='LAPSETRANS')
	BEGIN
		INSERT INTO SequenceTable (Seq1, Seq2, Seq3, Seq4, Seq5, SequenceNo)
		VALUES ('LapseTrans', NULL, NULL , NULL , NULL, 0)
	END
	
	-----------------------------------------------------------------
	-- GET LAST LAPSE ID FROM THE SEQUENCE TABLE OR LAPSE TRANS TABLE
	-----------------------------------------------------------------
	
	BEGIN
	
		DECLARE @SEQUENCE_LAPSE_ID BIGINT
		DECLARE @SEQ_LAPSE_ID BIGINT
		DECLARE @LAPSE_TBL_TRANS_ID BIGINT
		
		SET @SEQ_LAPSE_ID  = (SELECT ISNULL(CONVERT(BIGINT,(ISNULL(SequenceNo,0))),0) AS SequenceNo FROM SequenceTable WHERE UPPER(Seq1) = 'LAPSETRANS')
		SET @LAPSE_TBL_TRANS_ID = (SELECT ISNULL(MAX(CONVERT(BIGINT,ISNULL(LapseTransID,0))),0) AS LapseTransID from LapseTrans)
		
		IF(@SEQ_LAPSE_ID >= @LAPSE_TBL_TRANS_ID)
			BEGIN 
				SET @SEQUENCE_LAPSE_ID = @SEQ_LAPSE_ID + 1 	
			END
		ELSE
			BEGIN 
				SET @SEQUENCE_LAPSE_ID = @LAPSE_TBL_TRANS_ID + 1 	
			END
				
	END

	---- INSERT INTO LAPSE TRNSE TABLE
					
	INSERT INTO LapseTrans (LapseTransID, ApprovalStatus, GrantOptionID, GrantLegID, VestingType, LapsedQuantity, GrantLegSerialNumber, LapseDate, EmployeeID, LastUpdatedBy, LastUpdatedOn)
	VALUES(@SEQUENCE_LAPSE_ID,'A', @GrantOptionId, @GrantLegId, @VestingType, @Expiry_Lapse_Quantity,@SEQ_GrantLeg_ID,@Expiry_Lapse_Date, @EmployeeId, @EmployeeId, GETDATE())
						
	---- UPDATE SEQUENCE TABLE
					
	UPDATE SequenceTable SET SequenceNo = (SELECT MAX(CONVERT(BIGINT,ISNULL(LapseTransID,0))) AS LapseTransID FROM LapseTrans)
	WHERE UPPER(Seq1) = 'LAPSETRANS'
				
END
GO
