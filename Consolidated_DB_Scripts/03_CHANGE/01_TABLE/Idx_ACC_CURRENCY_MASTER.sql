DECLARE @string VARCHAR(max) = ''

SELECT @string = @string + 'Alter table ACC_CURRENCY_MASTER drop CONSTRAINT ' + name + '; '
FROM sys.indexes
WHERE object_id = object_id('ACC_CURRENCY_MASTER')
	AND fill_factor = 95
	and is_unique_constraint = 1
	and type =2 

exec (@string)


If not exists (
select 'X' from sys.tables as t
inner join sys.columns as c
    on  t.object_id = c.object_id
inner join sys.index_columns as ic 
    on c.column_id = ic.column_id and c.object_id = ic.object_id
inner join sys.indexes as i
    on ic.index_id = i.index_id and ic.object_id = i.object_id
where t.name = 'ACC_CURRENCY_MASTER' and c.name = 'CURRENCY_NAME'
)
begin
ALTER TABLE [dbo].[ACC_CURRENCY_MASTER] ADD UNIQUE NONCLUSTERED 
(
	[CURRENCY_NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

end


If not exists (
select 'X' from sys.tables as t
inner join sys.columns as c
    on  t.object_id = c.object_id
inner join sys.index_columns as ic 
    on c.column_id = ic.column_id and c.object_id = ic.object_id
inner join sys.indexes as i
    on ic.index_id = i.index_id and ic.object_id = i.object_id
where t.name = 'ACC_CURRENCY_MASTER' and c.name = 'CURRENCY_ALIAS'
)
begin

ALTER TABLE [dbo].[ACC_CURRENCY_MASTER] ADD UNIQUE NONCLUSTERED 
(
	[CURRENCY_ALIAS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]


end
