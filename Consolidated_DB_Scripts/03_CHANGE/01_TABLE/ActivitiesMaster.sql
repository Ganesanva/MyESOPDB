IF NOT EXISTS (
		SELECT 'X'
		FROM sys.default_constraints
		WHERE parent_object_id = object_id('ActivitiesMaster')
		)
BEGIN
	--ALTER TABLE [dbo].[ActivitiesMaster] ADD  Constraint [DF__Activitie__IsAct__20ACD28B] DEFAULT ((0)) FOR [IsActive]
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