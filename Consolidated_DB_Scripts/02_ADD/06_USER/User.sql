Set NOCOUNT ON


IF not exists (
SELECT 'X'
FROM sys.database_principals
WHERE name = '[MyESOPsEncDB\SuperUser]'
)
begin 
CREATE USER [MyESOPsEncDB\SuperUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
end 
go


Set NOCOUNT OFF