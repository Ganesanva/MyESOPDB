Set NOCOUNT ON

DROP USER IF EXISTS [MYESOPSPRDDB\karuna];

DROP USER IF EXISTS  [Vairavan];

/*
IF not exists (
SELECT 'X'
FROM sys.database_principals
WHERE name = '[MyESOPsENCDB\amit]'
)
begin 
CREATE USER [MyESOPsENCDB\amit] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
end 
go


IF not exists (
SELECT 'X'
FROM sys.database_principals
WHERE name = '[MyESOPsEncDB\SuperUser]'
)
begin 
CREATE USER [MyESOPsEncDB\SuperUser] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
end 
go
*/


Set NOCOUNT OFF