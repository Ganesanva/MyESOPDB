If not exists (Select 'X' from sys.columns where object_id = object_id('VW_Cancellations_DB') and name ='PANNUMBER')
begin
exec ( '
alter       VIEW [dbo].[VW_Cancellations_DB]
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
)
end
GO

