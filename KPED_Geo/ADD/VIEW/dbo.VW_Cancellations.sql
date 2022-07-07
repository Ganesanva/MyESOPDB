
IF OBJECT_ID('dbo.VW_Cancellations', 'V') IS  NULL
BEGIN
Exec ('
-- =============================================
-- Author:		Vidyadhar
-- Create date: 18-11-2021
-- Description:	Create VW_Cancellations 
-- =============================================
CREATE       VIEW [dbo].[VW_Cancellations]
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
,''PAN NUMBER'' as ''PAN Number''
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

    ')

END
