/****** Object:  View [dbo].[VW_Cancellations_DB]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[VW_Cancellations_DB]'))
EXEC dbo.sp_executesql @statement = N'


-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_Cancellations 
-- =============================================
CREATE       VIEW [dbo].[VW_Cancellations_DB]
as
SELECT ''GrantOptionId''		as GrantOptionId
,''ExercisePrice''			as ExercisePrice
,''CurrencyName''				as CurrencyName
,''GrantDate''				as GrantDate
,''VestID''					as VestID
,''FinalVestingDate''			as FinalVestingDate
,''FinalExpirayDate''			as FinalExpirayDate
,''CancelledDate''			as CancelledDate
,''CancellationReason2''		as CancellationReason2
,''EmployeeID''				as EmployeeID
,''EmployeeName''				as EmployeeName
,''PANNUMBER''							as PANNUMBER
,''DateOfTermination''		as DateOfTermination
,''Final Cancelled Quantity'' as ''Final Cancelled Quantity''
,''SchemeTitle''				as SchemeTitle
,''GrantRegistrationId''		as GrantRegistrationId
,''CancelledQuantity''		as CancelledQuantity
,''CancellationReason''		as CancellationReason
,''Status''					as Status
,''VestedUnVested''			as VestedUnVested
,''OptionsCancelled''			as OptionsCancelled
,''ToDate''					as ToDate
, 0 as ID
' 
GO
