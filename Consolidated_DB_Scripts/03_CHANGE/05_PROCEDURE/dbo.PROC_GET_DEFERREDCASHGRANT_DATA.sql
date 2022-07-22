DROP PROCEDURE [dbo].[PROC_GET_DEFERREDCASHGRANT_DATA]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_DEFERREDCASHGRANT_DATA]     
	
	@EmployeeId VARCHAR(50)
	
AS
BEGIN	         

IF NOT EXISTS (Select 1 FROM MST_DEFERRED_CASH_GRANT WHERE UPPER(DisplayColumnName) = 'PAYOUTTRANCHEID')
BEGIN
	UPDATE MST_DEFERRED_CASH_GRANT SET DisplayColumnName = 'PayoutTrancheId' WHERE DataColumnName ='PayoutTranchId' AND DCG_ID =3
END

SELECT * INTO #Temp_DeferredCashGrant FROM
	(SELECT
	 REPLACE(REPLACE(SchemeName,CHAR(145),'&rsquo;'+''),CHAR(146),'&rsquo;'+'') AS SchemeName,
	 GrantID AS 'Grant id',
	 PayoutTranchId AS 'Payout TrancheId',	
	 CASE WHEN (GrantDate ='1900-01-01 00:00:00.000') THEN NULL
     ELSE (REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '-')) END AS 'Grant Date',
     GrantAmount AS 'Grant Amount',Currency,	
	 CASE WHEN (PayOutdueDate ='1900-01-01 00:00:00.000') THEN NULL
     ELSE (REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '-')) END AS 'PayOut due Date',
	 PayOutCategory AS 'PayOut Category',
     GrossPayoutAmount AS 'Gross Payout Amount',ISNULL(TaxDeducted,0) AS 'Tax Deducted',
	 NetPayoutAmount AS 'Net Payout Amount',     
	 CASE WHEN (PayOutDate ='1900-01-01 00:00:00.000') THEN NULL
     ELSE (REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '-')) END AS 'PayOut Date',
	 CASE WHEN  ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0
       THEN 0
       ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) END
       AS 'Payout Due',	 
	 ISNULL(PayOutRevesion,0) AS 'PayOut Revision',	 
	 CASE WHEN (DateOfRevision ='1900-01-01 00:00:00.000') THEN NULL
     ELSE (REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '-')) END AS 'Payout Revision date',
     ReasoForRevision AS 'Reason For Revision'  	
     FROM DeferredCashGrant
	 INNER JOIN UserMaster UM ON DeferredCashGrant.EmployeeId = UM.EmployeeId		
	 WHERE UM.UserId in(@EmployeeId)) AS DEFERRED

	 DECLARE @vColName varchar(max)  
	 SELECT @vColName= Coalesce(@vColName + ',', '') + Ltrim(name) FROM (
	 SELECT name FROM tempdb.sys.columns WHERE object_id = Object_id('tempdb..#Temp_DeferredCashGrant')
	 AND REPLACE(Ltrim(name), ' ', '') NOT IN(SELECT DisplayColumnName FROM MST_DEFERRED_CASH_GRANT WHERE ISACTIVE =1)) AS DeferredCashG	 
	 --Print @vColName 
	 DECLARE @qry NVARCHAR(MAX)
	 SET @qry = REPLACE('ALTER TABLE #Temp_DeferredCashGrant DROP COLUMN [' + @vColName +']', ',', '],[')
	-- Print @qry 
	 EXEC(@qry)
	 SELECT * FROM #Temp_DeferredCashGrant
	 DROP TABLE #Temp_DeferredCashGrant 

  END
GO


