/****** Object:  StoredProcedure [dbo].[st_CancellationDetails_Data_DB]    Script Date: 7/6/2022 1:40:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[st_CancellationDetails_Data_DB]
GO
/****** Object:  StoredProcedure [dbo].[st_CancellationDetails_Data_DB]    Script Date: 7/6/2022 1:40:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create st_CancellationDetails_Data
-- =============================================

CREATE     PROCEDURE [dbo].[st_CancellationDetails_Data_DB]
	@CancellationYear INT=0
,	@SchemeTitle	 INT=0
,	@FlipkartYN VARCHAR(1)='N'
AS
BEGIN
	;WITH M_Cancellations As
	(
	SELECT *
	FROM VW_Cancellations
	UNION ALL
	SELECT GrantOptionId
	, CONVERT(VARCHAR(500),0.0)								as ExercisePrice
	, ''												as CurrencyName
	, CONVERT(VARCHAR(500),GrantDate,106)						as GrantDate
	, ''												as VestID
	, CONVERT(VARCHAR(500),FinalVestingDate,106)					as FinalVestingDate
	, CONVERT(VARCHAR(500),FinalExpirayDate,106)					as FinalExpirayDate
	, CONVERT(VARCHAR(500),CancelledDate,106)					as CancelledDate
	, Expr2												as CancellationReason2
	, PS.EmployeeID
	, PS.EmployeeName
	, PS.PANNumber
	, CONVERT(VARCHAR(500),ISNULL(PS.DateOfTermination,''))		as DateOfTermination
	, CONVERT(VARCHAR(500),(CancelledQuantity))			as FinalCancelledQuantity
	, SchemeTitle
	, GrantRegistrationId
	, CONVERT(VARCHAR(500),(CancelledQuantity))			as CancelledQuantity
	, CancellationReason
	, PS.Status
	, VestedUnVested
	, CONVERT(VARCHAR(500),OptionsCancelled) as OptionsCancelled
	, CONVERT(VARCHAR(500),GETDATE()) as Todate
	, 1 as ID
	FROM CancellationDetails_rpt CD
	INNER JOIN PersonalStatus_rpt PS 
	ON CD.EmployeeID = PS.EmployeeID
	WHERE YEAR(GrantDate) NOT IN (CASE WHEN @FlipkartYN ='N' THEN '1900' ELSE  @CancellationYear END)
	AND SchemeTitle NOT IN (CASE WHEN  @FlipkartYN ='N'  THEN 'ALL' ELSE  (CASE WHEN @SchemeTitle = 1 THEN 'Flipkart Stock Option Scheme 2012 A'  END) eND)
	)
	SELECT *
	INTO ##MCancellations_DB
	FROM M_Cancellations
	ORDER BY ID
END
GO
