/****** Object:  StoredProcedure [dbo].[PROC_GET_DeferredCashGrantDetails]    Script Date: 7/6/2022 1:40:54 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[PROC_GET_DeferredCashGrantDetails]
GO
/****** Object:  StoredProcedure [dbo].[PROC_GET_DeferredCashGrantDetails]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PROC_GET_DeferredCashGrantDetails]

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT '' as [Action],Id as 'Cashgrant Serial Id',	EmployeeId	,EmployeeNAme as 'EmployeeName' ,	SchemeName,	GrantFinancialYear	,GrantID,	PayoutTranchId,
	REPLACE(CONVERT(NVARCHAR,GrantDate, 106), ' ', '/') AS GrantDate,	GrantAmount	,Currency	,
	
	REPLACE(CONVERT(NVARCHAR,PayOutdueDate, 106), ' ', '/') AS PayOutdueDate
	,PayOutDistribution	,PayOutCategory	,GrossPayoutAmount,	TaxDeducted,	NetPayoutAmount,
	
	CASE WHEN( PayOutDate = '01/Jan/1900') then null else
	REPLACE(CONVERT(NVARCHAR,PayOutDate, 106), ' ', '/') end AS PayOutDate


	,PayOutRevesion As PayOutRevision,
	
	CASE WHEN( DateOfRevision = '01/Jan/1900') then null else
		REPLACE(CONVERT(NVARCHAR,DateOfRevision, 106), ' ', '/') end AS DateOfRevision 		
	,ReasoForRevision As 'ReasonForRevision' FROM DeferredCashGrant
	
	SET NOCOUNT OFF;
END


GO
