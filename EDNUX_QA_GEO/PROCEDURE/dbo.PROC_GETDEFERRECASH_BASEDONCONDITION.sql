/****** Object:  StoredProcedure [dbo].[PROC_GETDEFERRECASH_BASEDONCONDITION]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GETDEFERRECASH_BASEDONCONDITION]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GETDEFERRECASH_BASEDONCONDITION]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GETDEFERRECASH_BASEDONCONDITION]

     @GrantDateFrom datetime,
	 @GrandDateTo datetime,
	 @PayoutDateFrom datetime,
	 @PayoutDateTo datetime,
	 @Payoutduedatefrom datetime,
	 @PayoutduedateTo datetime,
	 @Payoutstaus varchar(50),
	 @Consider INT
AS
BEGIN
    
	SET NOCOUNT ON;

IF (@Consider = 0) -- NO DATE
BEGIN
if(@Payoutstaus ='Pending')
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus

	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	 )
END
ELSE IF(@Payoutstaus = 'Paid')
BEGIN 
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	)
END
ELSE
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus

	 ) AS DEFERDATA
	
END	
END
ELSE IF(@Consider = 1) -- GRANT DATE
BEGIN
if(@Payoutstaus ='Pending')
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	  (DC.GrantDate >= @GrantDateFrom AND DC.GrantDate <= @GrandDateTo)
  
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	 )
END
ELSE IF(@Payoutstaus = 'Paid')
BEGIN 
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	  (DC.GrantDate >= @GrantDateFrom AND DC.GrantDate <= @GrandDateTo)
    
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	)
END
ELSE
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	  (DC.GrantDate >= @GrantDateFrom AND DC.GrantDate <= @GrandDateTo)
    
	 ) AS DEFERDATA
	
END
	   
END
ELSE IF (@Consider = 2) -- PAY OUT DATE
BEGIN
if(@Payoutstaus ='Pending')
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 

    (DC.PayOutDate >= @PayoutDateFrom AND DC.PayOutDate <= @PayoutDateTo)
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	 )
END
ELSE IF(@Payoutstaus = 'Paid')
BEGIN 
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	
      (DC.PayOutDate >= @PayoutDateFrom AND DC.PayOutDate <= @PayoutDateTo)
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	)
END
ELSE
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 	 
     (DC.PayOutDate >= @PayoutDateFrom AND DC.PayOutDate <= @PayoutDateTo)
	 ) AS DEFERDATA
	
END
	   
END
ELSE IF(@Consider = 3) -- PAYOUT DUE DATE
BEGIN
if(@Payoutstaus ='Pending')
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	 
      (DC.PayOutdueDate >= @Payoutduedatefrom AND DC.PayOutdueDate <= @PayoutduedateTo)
 
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	 )
END
ELSE IF(@Payoutstaus = 'Paid')
BEGIN 
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	
      (DC.PayOutdueDate >= @Payoutduedatefrom AND DC.PayOutdueDate <= @PayoutduedateTo)
    
	 ) AS DEFERDATA
	 WHERE
	( (DEFERDATA.Payoutstaus = @Payoutstaus )
	)
END
ELSE
BEGIN
SELECT * FROM(
	
	SELECT
		DC.EmployeeId,DC.EmployeeNAme,SchemeName,GrantID,PayoutTranchId ,	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS  GrantDate	,GrantAmount
		,Currency,	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate ,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,
		TaxDeducted,NetPayoutAmount,
		case when( PayOutDate = '01/Jan/1900') THEN NULL else
		REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/')  end AS PayOutDate
		
		,PayOutRevesion,
		case when( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
		,ReasoForRevision   
		,EM.PANNumber,EM.Entity,EM.SBU, EM.COST_CENTER,EM.Department,EM.Grade,EM.EmployeeDesignation,
		RT.[Description] AS ResidentialStatus,
		EM.LWD,
		SR.Reason AS ReasonForTermination,		
		(CASE WHEN EM.ReasonForTermination IS NULL THEN 'Live'WHEN  EM.ReasonForTermination IS NOT NULL
	    AND CONVERT(DATE, EM.LWD) > CONVERT(DATE, GETDATE()) THEN 'Live' ELSE 'Separated' END)	AS [Status] ,

	CASE WHEN	((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) < 0 
	THEN 0
	ELSE ((Isnull(GrantAmount,0)-ISnull(GrossPayoutAmount,0)-isnull(PayOutRevesion,0)) ) end
	AS PayOutDue,
		
		CASE WHEN   (DC.PayOutDate IS NULL OR DC.PayOutDate = '01/Jan/1900') THEN 'Pending'
		ELSE  'Paid'
		END AS 'Payoutstaus'
			
		FROM DeferredCashGrant as DC
		INNER JOIN  EmployeeMaster as EM	
		ON EM.EmployeeID = DC.EmployeeId
		LEFT JOIN SeperationRule AS SR
		ON SR.SeperationRuleId = EM.ReasonForTermination
		LEFT JOIN ResidentialType AS RT
		ON RT.ResidentialStatus = EM.ResidentialStatus
		
	WHERE 
	 
      (DC.PayOutdueDate >= @Payoutduedatefrom AND DC.PayOutdueDate <= @PayoutduedateTo)
    
	 ) AS DEFERDATA
	
END
	   
END

	SET NOCOUNT OFF;
END



GO
