IF NOT EXISTS (
		SELECT 'X'
		FROM sys.database_role_members AS rm
		INNER JOIN sys.database_principals AS r ON r.principal_id = rm.role_principal_id
		INNER JOIN sys.database_principals AS m ON m.principal_id = rm.member_principal_id
		WHERE r.name = 'db_owner'
			AND m.name = '[MyESOPsEncDB\SuperUser]'
		)
BEGIN
	ALTER ROLE [db_owner] ADD MEMBER [MyESOPsEncDB\SuperUser];
END