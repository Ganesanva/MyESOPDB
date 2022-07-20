Set NOCOUNT ON

Declare @string varchar(max) = ''
 
select @string = @string +'Alter table ACC_CURRENCY_MASTER drop CONSTRAINT '+name+'; '
from sys.indexes 
where object_id = object_id('ACC_CURRENCY_MASTER')
and   fill_factor = 95

exec (@string)

Set NOCOUNT OFF


