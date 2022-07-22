IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns a
		INNER JOIN sys.types b ON (a.user_type_id = b.user_type_id)
		WHERE a.object_id = object_id('MailMessages')
			AND a.name = 'MailBody'
			AND b.name = 'varchar'
			AND a.max_length = - 1
		)
BEGIN
	ALTER TABLE [dbo].MailMessages

	ALTER COLUMN [MailBody] VARCHAR(MAX) NULL
END