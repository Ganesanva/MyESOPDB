IF NOT EXISTS (
		SELECT 'X'
		FROM sys.default_constraints dc
		JOIN sys.objects o ON o.object_id = dc.parent_object_id
		JOIN sys.columns c ON o.object_id = c.object_id
			AND c.column_id = dc.parent_column_id
		WHERE o.name = 'ActivitiesMaster'
			AND c.name = 'IsActive'
		)
BEGIN
	ALTER TABLE [dbo].[ActivitiesMaster] ADD DEFAULT((0))
	FOR [IsActive]
END
GO

--Data patch for already existing records 
IF EXISTS (
		SELECT 'X'
		FROM ActivitiesMaster WITH (NOLOCK)
		WHERE IsActive IS NULL
		)
BEGIN
	UPDATE ActivitiesMaster
	SET IsActive = 0
	WHERE IsActive IS NULL
END