/****** Object:  StoredProcedure [dbo].[CalulateClosingBalForActionCorp]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[CalulateClosingBalForActionCorp]
GO
/****** Object:  StoredProcedure [dbo].[CalulateClosingBalForActionCorp]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CalulateClosingBalForActionCorp] 
			@ClientID VARCHAR(50),
			@TrustID INT = NULL,
			@AsOnDate DATETIME =NULL,
			@fromDate NVARCHAR(12) =NULL,
			@toDate NVARCHAR(12) =NULL
AS
BEGIN

DECLARE @MinIdt INT,
		@MaxIdt INT,
		@CalCloseBal BIGINT,  -- Added by Chetan Tembhre ,08-Nov-2012, 0003587: Buy & Sell - add New
		@OpeningBalance NUMERIC,
		@TotalSellorPurQty BIGINT,
		@TransactionDate DATETIME,
		@SellOrPurStatus INT,
		@RatioDivisor VARCHAR(10),
		@RatioMultiplier VARCHAR(10),
		@CorpActionDate DATETIME,
		@ActionType INT,
		@ClosingBalance BIGINT,
		@SharesAllotted NUMERIC,
		@fDate DATETIME,
		@tDate DATETIME,
		@NoOfShares NUMERIC,
		@TrustCreated DATETIME,
		@AllotmentStatus INT,
		@ID INT,
		@TransType VARCHAR(20)
-------------------
       
SET @fDate = CONVERT(DATETIME,@fromDate)
SET @tDate = CONVERT(DATETIME,@toDate)
--------------------------
CREATE TABLE #TEMP (Idt INT Identity(1,1),
					OpeningBalance NUMERIC,
					TrustID INT,
					TotalSellorPurQty BIGINT DEFAULT 0,
					TransactionDate DATETIME,
					SellOrPurStatus INT DEFAULT 0,
					SharesAllotted NUMERIC,
					AllottmentDate DATETIME,
					RatioDivisor VARCHAR(10) DEFAULT 0,
					RatioMultiplier VARCHAR(10) DEFAULT 0,
					CorpActionDate DATETIME,
					ActionType INT DEFAULT 0,
					ClosingBalance BIGINT DEFAULT 0,
					[Description] NVARCHAR(500),
					SharePrice DECIMAL(10,2),
					NumberofShares NUMERIC,
					[Date] DATETIME,
					AllotmentStatus INT DEFAULT 0,
					ID INT DEFAULT 0,
		            TransType VARCHAR(20)
					) 
					


INSERT INTO #TEMP (OpeningBalance, TrustID, TotalSellorPurQty, TransactionDate, SellOrPurStatus,SharesAllotted,
 AllottmentDate,RatioDivisor, RatioMultiplier, CorpActionDate, ActionType,[Description],SharePrice,[Date],AllotmentStatus,ID ,TransType )
SELECT  
---(SELECT SUM (NoOfShare) FROM Trust WHERE TrustID = @TrustID AND ClientCompany =@ClientID)
 P.OpeningBalance,P.TrustID, P.TotalSellorPurBal, P.TransactionDate, P.SellorPurStatus, P.SharesAllotted, P.AllottmentDate,P.SRT1, P.STR2, P.CropActionDate, 
 P.ActionType,P.Description,P.SharePrice,P.[Date] ,AllotmentStatus,ID,TransType 
		
----CASE WHEN P.SellorPurStatus =1 THEN P.TotalSellorPurBal ELSE 0 END + CASE WHEN P.SellorPurStatus =2  THEN P.TotalSellorPurBal ELSE 0 END Balance,
----P.TrustID, P.TotalSellorPurBal, P.TransactionDate, P.SellorPurStatus, P.SRT1, P.STR2, P.CropActionDate, P.ActionType
  FROM 
(
 -- Opening Balance
  
  SELECT 0 as  tempid, T.NoOfShare AS OpeningBalance,   T .TrustID  , 0 as TotalSellorPurBal , NULL AS TransactionDate ,NULL as SellorPurStatus 
  ,0 AS SharesAllotted,NULL AS AllottmentDate,
  '0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
  'Opening Balance' AS [Description],
  0  AS SharePrice,
  T.CreatedOn AS [Date],0 AS  AllotmentStatus,T.TrustID as ID  , 'Opening' as TransType
  
  
  From TrustGlobal T WHERE T.TrustID =@TrustID AND T.ClientCompany =@ClientID 
   
UNION

-- Purchase and Sell  Balance
  SELECT 0 as  tempid, 0 AS OpeningBalance, TC .TrustID  , SUM ( ISNULL (NumberOfShares,0)) as TotalSellorPurBal , T.CreatedOn  AS TransactionDate , T.Type as SellorPurStatus 
  ,0 AS SharesAllotted,NULL AS AllottmentDate,
  '0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
  CASE T.Type 
  WHEN 1 THEN 'Add:Shares Purchased @ Rs ' + STR(AVG(T.Price),12,2) + ''
  WHEN 2 THEN 'Less: Shares Sold @ Rs ' + STR(AVG(T.Price),12,2) + ''
  END AS [Description],
  AVG(T.Price) AS SharePrice,
  T.CreatedOn AS [Date], 0 AS AllotmentStatus,T.ID  as ID , 'SellOrPurchase' as TransType
  
  From TransactionsDetails T  INNER JOIN
  TransactionTrustClients TC ON T.ID = TC.TransactionID
  Where TC .ClientID = @ClientID  AND T.ACTIVESTATUS=1
  --AND( @fromDate IS NULL OR @toDate IS NULL OR T.CreatedOn BETWEEN @fDate AND @tDate)
  GROUP BY T.CreatedOn ,T.Type , TC.TrustID ,T.ID 

  
  UNION
---- For Bonus and Split
 SELECT 0 as  tempid,  0 AS OpeningBalance, TA.TrustId , 0 as TotalSellorPurBal, NULL as TransactionDate, 0 as SellorPurStatus,0 AS SharesAllotted,NULL AS AllottmentDate,
 SUBSTRING (C.RATIO,1,2) AS  STR1 , SUBSTRING(C.Ratio , 4,4) as STR2 , C.CreatedOn AS CropActionDate, C.ActionType, 
 CASE C.ActionType
  WHEN 1 THEN 'Bonus in the ratio of ' +  SUBSTRING (C.RATIO,1,2) + ':' + SUBSTRING(C.Ratio , 4,4) + ''
  WHEN 2 THEN 'Split in the ratio of ' + SUBSTRING (C.RATIO,1,2) + ':' +  SUBSTRING(C.Ratio , 4,4) + ''
  END AS [DESCRIPTION],
  NULL AS  SharePrice,
  C.CreatedOn AS [Date],0 AS AllotmentStatus ,C.CorpActionDetailsID as ID  --C.ActionID  as ID 
  , 'CropAction' as TransType
 FROM CorpActionDetails C INNER JOIN
 TrustCorpAction TA ON C.CorpActionDetailsID  =TA.CorpActionID
 Where TA.TrustId =@TrustID AND 
 TA.ClientId =@ClientID  AND C.ActiveStatus =1 
  --AND( @fromDate IS NULL OR @toDate IS NULL OR C.CreatedOn  BETWEEN @fDate AND @tDate)
 UNION
 
 
 -- Cashless ALLOTMENT
 
-- SELECT 0 AS OpeningBalance, TTC.TrustId , 0 as TotalSellorPurBal, NULL as TransactionDate, 0 as SellorPurStatus,SUM(ISNULL(NoOfSharesAllotted,0))  AS SharesAllotted,
-- AllotmentDate AS AllottmentDate,'0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
-- 'Allotment by Company @ Rs '   as [Description],NULL AS  SharePrice,AllotmentDate AS [Date], 1 AS AllotmentStatus
----'Allotment by Company' as [Description],dbo.GetDailyOpeningBalance(AllotmentDate,@companyId) AS 'CLOSING BALANCE' 
--FROM TrancheConsolidation TC 
--INNER JOIN tranche T on TC.trancheId = TC.trancheId and T.ExerciseMethod = 'SP' 
--INNER JOIN TransactionTrustClients TTC ON T.CompanyId = TTC.ClientID
----AND AllotmentDate  BETWEEN @fDate AND @tDate 
--WHERE T.CompanyID = @ClientID AND AllotmentStatus ='Y'  GROUP BY AllotmentDate,TTC.TrustId

 SELECT 0 as  tempid,0 AS OpeningBalance, TTC.TrustId , 0 as TotalSellorPurBal, NULL as TransactionDate, 0 as SellorPurStatus, ISNULL(NoOfSharesAllotted,0)   AS SharesAllotted,
 AllotmentDate AS AllottmentDate,'0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
 'Allotment by Company @ Rs '  + CONVERT (VARCHAR, TC.ExercisePrice)  as [Description],NULL AS  SharePrice,AllotmentDate AS [Date], 1 AS AllotmentStatus
 ,TC.TrancheConsolidationId  as ID , 'AllotmentbyCashless' as TransType
--'Allotment by Company' as [Description],dbo.GetDailyOpeningBalance(AllotmentDate,@companyId) AS 'CLOSING BALANCE' 
FROM TrancheConsolidation TC 
INNER JOIN tranche T on TC.trancheId = T.TrancheId  and T.ExerciseMethod = 'SP' 
INNER JOIN TrustGlobal TTC ON LOWER ( T.CompanyId) = LOWER ( TTC.ClientCompany)
--AND AllotmentDate  BETWEEN @fDate AND @tDate 
WHERE T.CompanyID = @ClientID AND AllotmentStatus ='Y'  --GROUP BY AllotmentDate,TTC.TrustId



-- Trust Allotment
UNION 

--SELECT  0 AS OpeningBalance, TA.TrustId , 0 as TotalSellorPurBal, NULL as TransactionDate, 0 as SellorPurStatus,ISNULL ( GT.AllotedShares,0) AS SharesAllotted, GT.AllotedDate  AS AllottmentDate,
-- '0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
--  'Share Alloted on  ' + CONVERT (VARCHAR, GT.AllotedTransDate,103) AS  [DESCRIPTION],
--  ExercisePrice  AS  SharePrice,
--  GT.AllotedTransDate AS [Date],1 AS AllotmentStatus ,GT.ShareTransferListId  as ID , 'AllotmentbyTrust' as TransType
-- FROM Trust TA,GenerateTranShareTransferDetails GT WHERE TA.TrustID =GT.TrustId AND GT.TrustId =@TrustID   AND GT.ClientID =@ClientID  AND GT.AllotedStatus ='Y'
-- get  distinct data 
  SELECT DISTINCT GT.ExerciseId  as  tempid , 0 AS OpeningBalance, TA.TrustId , 0 as TotalSellorPurBal, NULL as TransactionDate, 0 as SellorPurStatus,ISNULL ( GT.AllotedShares,0) AS SharesAllotted, GT.AllotedDate  AS AllottmentDate,
 '0' as SRT1,'0' AS STR2,NULL AS CropActionDate , 0 AS ActionType,
  'Share Alloted on  ' + CONVERT (VARCHAR, GT.AllotedTransDate,103) AS  [DESCRIPTION],
  ExercisePrice  AS  SharePrice,
  GT.AllotedTransDate AS [Date],1 AS AllotmentStatus , (SELECT TOP 1  G.ShareTransferListId  FROM GenerateTranShareTransferDetails G WHERE GT.TrustId =@TrustID    AND GT.ClientID =@ClientID AND GT.AllotedStatus ='Y' AND G.AllotedTransDate =GT.AllotedTransDate  )   as ID , 'AllotmentbyTrust' as TransType
 FROM TrustGlobal TA INNER JOIN
 GenerateTranShareTransferDetails GT ON TA.TrustID =GT.TrustId
 WHERE   GT.TrustId =@TrustID   AND GT.ClientID =@ClientID  AND GT.AllotedStatus ='Y'

) P where p.Date is not null ORDER BY [Date] ASC ---order by transaction date
 
 --select * from #TEMP
SELECT @MinIdt = MIN(Idt), @MaxIdt = MAX(Idt) FROM #TEMP
 
SELECT @OpeningBalance = OpeningBalance FROM #TEMP   WHERE Idt = @MinIdt
WHILE @MinIdt <= @MaxIdt
BEGIN
	SELECT @TotalSellorPurQty = TotalSellorPurQty,
			@TransactionDate = TransactionDate,
			@SellOrPurStatus = SellOrPurStatus,
			@RatioDivisor = RatioDivisor,
			@RatioMultiplier = RatioMultiplier,
			@CorpActionDate = CorpActionDate,
			@ActionType = ActionType,
			@SharesAllotted = SharesAllotted,
			@AllotmentStatus = AllotmentStatus,
			@ID=ID,
			@TransType =TransType 
	FROM #TEMP WHERE Idt = @MinIdt

	IF @SellOrPurStatus = 1 --- PURCHASE
	BEGIN
		SET @CalCloseBal = @OpeningBalance + @TotalSellorPurQty
		SET @OpeningBalance = @CalCloseBal
		--SET @NoOfShares = @TotalSellorPurQty
		--SELECT @NoOfShares,@TotalSellorPurQty
	END
	ELSE IF @SellOrPurStatus = 2  --SALE
	BEGIN
		SET @CalCloseBal = @OpeningBalance - @TotalSellorPurQty
		SET @OpeningBalance = @CalCloseBal
		--SET @NoOfShares = @TotalSellorPurQty
		--SELECT @NoOfShares,@TotalSellorPurQty,@OpeningBalance,@CalCloseBal
	END
	--ELSE
	--BEGIN
	--	SET @CalCloseBal = @OpeningBalance
	--END
	
	IF @ActionType = 1 --- BONUS
	BEGIN
		SET @CalCloseBal = ((@RatioMultiplier * @CalCloseBal) / @RatioDivisor) + @CalCloseBal
		SET @OpeningBalance = @CalCloseBal
		--SET @NoOfShares = @CalCloseBal
	END
	ELSE IF @ActionType = 2 --- SPLIT
	BEGIN
		
		SET @CalCloseBal = ((@RatioMultiplier * @CalCloseBal) / @RatioDivisor)
		SET @OpeningBalance = @CalCloseBal
		--SET @NoOfShares = @CalCloseBal
	END
	
	 IF @SharesAllotted  IS NOT NULL  
	 
	BEGIN 
	
		SET @CalCloseBal = @OpeningBalance - @SharesAllotted
		SET @OpeningBalance = @CalCloseBal
		
		--SET @NoOfShares = @SharesAllotted
	END 

	UPDATE #TEMP SET ClosingBalance = @CalCloseBal WHERE Idt = @MinIdt
	--UPDATE #TEMP SET  NumberofShares = @NoOfShares WHERE Idt = @MinIdt
	
	SET @OpeningBalance = @CalCloseBal
	--select @OpeningBalance as DailyOpeningBalance,@CalCloseBal as ClosingBalance
	SELECT @MinIdt = @MinIdt + 1
END

SELECT @TrustCreated = T.CreatedOn from TrustGlobal T where T.TrustID = @TrustID AND T.ClientCompany= @ClientID
 
SELECT * FROM (

SELECT  [Date] AS [DATE],ltrim(rtrim(Description)) AS [DESCRIPTION],
        case SellOrPurStatus 
		when 1 then TotalSellorPurQty 
		when 2 then TotalSellorPurQty 
		 
		ELSE 
		CASE ActionType -- for bonus and split 
		WHEN 1 THEN (select b.ClosingBalance   --get previous day's closing balance as number of shares
					 from #TEMP b where (b.Idt = (case when (a.Idt-1 < 1) then a.Idt else a.Idt-1 end) ))
		WHEN 2 THEN (select b.ClosingBalance 
					 from #TEMP b where (b.Idt = (case when (a.Idt-1 < 1) then a.Idt else a.Idt-1 end) ))
	    WHEN 0 THEN 
	    CASE AllotmentStatus 
	    WHEN 1 THEN SharesAllotted 	
	    END 		 
		END  
     	end as NumberOfShares,
		ClosingBalance AS ClosingBalance ,ID,TransType 
		
		--case ActionType
		--when 1 then 
			
		 FROM #TEMP  a 
		 WHERE CONVERT(DATE,[DATE]) BETWEEN CONVERT (DATE, @fDate) AND CONVERT (DATE, @tDate)  --ORDER BY [Date] ASC 
		 
		 UNION 
		 
		 --IF EXISTS (SELECT 1 FROM Trust T WHERE T.TrustID = @TrustID AND T.ClientCompany = @ClientID AND CONVERT(DATE,T.Createdon)=@fDate)
		 --BEGIN

		  
SELECT   TOP 1    @fDate  ,'Opening Balance' as [Description],(ClosingBalance) AS NumberOfShares,(ClosingBalance) AS ClosingBalance,ID,TransType 
					
	 FROM #TEMP   
	 --Where  #TEMP.[Date] < CONVERT(VARCHAR(10),@fDate,111) 
  --WHERE CONVERT(VARCHAR(10),[DATE],111) = CONVERT(VARCHAR(10),@fDate,111) 
  WHERE CONVERT(DATE,[DATE]) IN (SELECT TOP 1 (CONVERT(DATE,[DATE])) from #TEMP where[DATE] 
  IS NOT NULL AND CONVERT(DATE,[DATE]) < CONVERT (DATE, @fDate)  ORDER BY [Date] DESC)
   ORDER BY [Date] desc
  --END
		 
--close from 
)C   ORDER BY C.DATE ASC  --ORDER BY [Date] DESC )P --

--SELECT (CONVERT(DATE,[DATE])) from #TEMP where[DATE] 
--  IS NOT NULL AND CONVERT(DATE,[DATE]) < @fDate  ORDER BY [Date] DESC
   

END 




GO
