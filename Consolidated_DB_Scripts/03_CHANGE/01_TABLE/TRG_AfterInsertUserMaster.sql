IF EXISTS (
		SELECT 'X'
		FROM sys.triggers
		WHERE name = 'TRG_AfterInsertUserMaster'
		)
BEGIN
	DROP TRIGGER dbo.TRG_AfterInsertUserMaster
END