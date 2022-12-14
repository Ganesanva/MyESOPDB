/****** Object:  StoredProcedure [dbo].[PROC_GetPUPValueReportData]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GetPUPValueReportData]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GetPUPValueReportData]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[PROC_GetPUPValueReportData]
AS
BEGIN
SET NOCOUNT ON
 DECLARE @ApplyBonusTo CHAR = (SELECT ApplyBonusTo FROM BonusSplitPolicy),
		@ApplySplitTo CHAR = (SELECT ApplySplitTo FROM BonusSplitPolicy)
		
 --PRINT @ApplyBonusTo + @ApplySplitTo
 SELECT
		GL.SchemeId,
		GOP.EmployeeId,
		EM.EmployeeName,
		CASE WHEN EM.DATEOfTermination IS NULL THEN 'Live' ELSE 'Separated' END [Status],
		ISNULL(GR.GrantDate,'1900-01-01') AS GrantDate,		
		GL.GrantLegId ,
		GR.GrantRegistrationId ,
		GL.GrantOptionId,
		GL.Parent,
		CASE WHEN GL.VestingType ='T' THEN 'Time Based' ELSE 'Performance Based' END VestingType,
		ISNULL(GL.FinalVestingDate,'1900-01-01') AS VestingDate,		
		CASE WHEN (SC.DisplayExpDate = 1) 
				THEN GL.FinalExpirayDate
				ELSE NULL 
			END ExpiryDate,
		CASE WHEN (SC.DisplayExPrice = 1) THEN GR.ExercisePrice ELSE 0.00 END ExercisePrice,
		CASE WHEN @ApplyBonusTo = 'V'
			THEN (CASE WHEN @ApplySplitTo ='V' THEN  GL.GrantedQuantity   ELSE  GL.SplitQuantity END)
			ELSE  GL.BonusSplitQuantity
			END	GrantedOptions ,		
		CASE WHEN (GL.IsPerfBased='N' AND CONVERT(DATE, GL.FinalVestingDate) <= CONVERT(DATE,GETDATE()) AND GL.VestingType='T') 
				THEN GL.ExercisableQuantity 
			 WHEN (GL.IsPerfBased='1' AND CONVERT(DATE, GL.FinalVestingDate) <= CONVERT(DATE,GETDATE()) AND GL.VestingType='P') 
				THEN GL.ExercisableQuantity 
				ELSE 0 
			 END VestedOptions,
		CASE WHEN (GL.IsPerfBased='N' AND CONVERT(DATE, GL.FinalVestingDate) > CONVERT(DATE,GETDATE()) AND GL.VestingType='T') 
				THEN GL.ExercisableQuantity
			 WHEN (GL.IsPerfBased='N' AND (CONVERT(DATE,GL.FinalVestingDate) > CONVERT(DATE,GETDATE()) 
					OR  CONVERT(DATE, GL.FinalVestingDate) <= CONVERT(DATE,GETDATE()))  AND GL.VestingType='P') 
				THEN GL.GrantedQuantity
				ELSE 0 
			 END UnvestedUnits,		
		CASE WHEN @ApplyBonusTo = 'V' THEN (CASE WHEN @ApplySplitTo ='V' THEN GL.ExercisedQuantity  ELSE GL.SplitExercisedQuantity END)
			ELSE  GL.BonusSplitExercisedQuantity
			END	ExercisedQuantity,
		CASE WHEN @ApplyBonusTo = 'V' THEN (CASE WHEN @ApplySplitTo ='V' THEN GL.CancelledQuantity  ELSE GL.SplitCancelledQuantity END)
			ELSE  GL.BonusSplitCancelledQuantity
			END	CancelledQuantity,		
		CASE 
			WHEN(GL.ExercisedQuantity > 0) 
				THEN (ISNULL(ShTD.AmountPaid,0.00)) 
				ELSE 0.00 
			END ValOfPaidUnits, -- Amount Paid from ShTransaction details.
		CASE 
			WHEN(GL.ExercisedQuantity > 0 AND SC.DisplayPerqVal=1) 
				THEN (ISNULL(Ex.PerqstValue,0.00))  
			ELSE 0 END PerqstValue,
		CASE 
			WHEN(GL.ExercisedQuantity > 0 AND SC.DisplayPerqTax=1) 
				THEN (ISNULL(Ex.PerqstPayable,0.00)) 
			ELSE 0 END PerqstPayable,
		CASE 
			WHEN(GL.ExercisedQuantity > 0) 
				THEN ISNULL(Ex.ExercisedDate,'1900-01-01') 
				ELSE '1900-01-01' 
			END PayoutDate,				
		SC.IsPUPEnabled,
		SC.DisplayExPrice,
		SC.DisplayExpDate,
		SC.DisplayPerqVal,
		SC.DisplayPerqTax,
		GL.LastUpdatedBy
		--CASE WHEN(GL.ExercisedQuantity > 0) THEN  Ex.LastUpdatedOn ELSE GL.LastUpdatedOn END LastUpdatedOn
 INTO #TEMP
 FROM GrantLeg GL
		INNER JOIN GrantOptions GOP
			ON GOP.GrantOptionId = GL.GrantOptionId
		INNER JOIN GrantRegistration GR
			ON GOP.GrantRegistrationId = GR.GrantRegistrationId
		INNER JOIN Scheme SC
			ON SC.SchemeId = GR.SchemeId and SC.IsPUPEnabled = 1
		INNER JOIN EmployeeMaster EM
			ON Em.EmployeeID = GOP.EmployeeId
		LEFT JOIN Exercised ex
			ON ex.GrantLegSerialNumber = GL.Id and Ex.Cash = 'PUP'
		LEFT JOIN ShTransactionDetails ShTD
			ON ShTD.ExerciseNo = Ex.ExercisedId
ORDER BY GL.GrantOptionId,GL.GrantLegId			
-------------------------------------------------------------------------------
 SELECT  
		ROW_NUMBER() 
        OVER (ORDER BY SchemeId,GrantOptionId,GrantLegId) AS  TempId,
		SchemeId,
		EmployeeId,
		EmployeeName,
		[Status],
		REPLACE(CONVERT(VARCHAR(11), GrantDate, 106), ' ', '-') AS GrantDate,
		GrantLegId AS VestId,
		GrantRegistrationId AS GrantRegId,
		GrantOptionId AS GrantOptId,
		VestingType AS VestingType,
		REPLACE(CONVERT(VARCHAR(11), VestingDate, 106), ' ', '-') AS VestingDate,	
		CASE WHEN DisplayExPrice='1' THEN REPLACE(CONVERT(VARCHAR(11),ExpiryDate, 106), ' ', '-') ELSE ' ' END ExpiryDate ,	
		ExercisePrice AS ExercisePrice,	
		SUM(GrantedOptions) AS GrantedUnit,	
		SUM(VestedOptions) AS VestedUnits,	
		SUM(UnvestedUnits) AS UnVestedUnits,
		SUM(ExercisedQuantity) AS PaidOutUnits,	
		SUM(CancelledQuantity) AS CancelledUnits,	
		SUM(ValOfPaidUnits) AS ValOfPaidUnits,	
		CAST(SUM(PerqstValue) as decimal(18,2))  AS PerqstValue,
		CAST(SUM(PerqstPayable) as decimal(18,2))  AS PerqstPayable,
		REPLACE(CONVERT(VARCHAR(11), MAX(PayoutDate), 106), ' ', '-') AS PayoutDate,			
		IsPUPEnabled,	
		DisplayExPrice,	
		DisplayExpDate,	
		DisplayPerqVal,	
		DisplayPerqTax	
 FROM #TEMP
 GROUP BY 
		SchemeId,
		EmployeeId,
		EmployeeName,
		[Status],
		GrantDate,
		GrantLegId ,
		GrantRegistrationId,
		GrantOptionId ,
		VestingType,
		VestingDate,			
		ExercisePrice,	
		IsPUPEnabled,	
		DisplayExPrice,	
		DisplayExpDate,	
		DisplayPerqVal,	
		DisplayPerqTax,
		ExpiryDate	
ORDER BY GrantOptionId,GrantLegId 
-------------------------------------------------------------------------------
--Drop temp table
    IF Exists(
			SELECT *        
			FROM tempdb.dbo.sysobjects        
			WHERE ID in (OBJECT_ID(N'tempdb..#TEMP')))
	BEGIN
		DROP TABLE 	#TEMP
	END
SET NOCOUNT OFF	

END --Stored Proc End Loop .
GO
