DECLARE @string VARCHAR(max) = ''

SELECT @string = @string + 'Alter table ACC_CURRENCY_MASTER drop CONSTRAINT ' + name + '; '
FROM sys.indexes
WHERE object_id = object_id('ACC_CURRENCY_MASTER')
	AND fill_factor = 95

EXEC (@string)