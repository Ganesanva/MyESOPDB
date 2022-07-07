If exists (SELECT 'X' 
FROM sys.triggers
where name = 'TrgDeleteDynamicTables' 
and is_disabled  = 1 )
begin 
exec ('
ENABLE TRIGGER [dbo].[TrgDeleteDynamicTables]
ON [dbo].[GrantLeg]')

end
