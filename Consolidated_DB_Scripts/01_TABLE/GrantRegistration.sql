IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns
		WHERE object_id = object_id('GrantRegistration')
			AND name = 'ExercisePrice'
			AND precision = 18
			AND scale = 9
		)
BEGIN
	IF EXISTS (
			SELECT 'X'
			FROM sys.indexes
			WHERE name = 'GrantRegistration_ExercisePrice_NCINDEX'
			)
	BEGIN
		DROP INDEX GrantRegistration.GrantRegistration_ExercisePrice_NCINDEX
	END

	ALTER TABLE [dbo].GrantRegistration

	ALTER COLUMN [ExercisePrice] NUMERIC(18, 9) NULL

	IF NOT EXISTS (
			SELECT 'X'
			FROM sys.indexes
			WHERE name = 'GrantRegistration_ExercisePrice_NCINDEX'
			)
	BEGIN
		CREATE NONCLUSTERED INDEX [GrantRegistration_ExercisePrice_NCINDEX] ON [dbo].[GrantRegistration] (
			[SchemeId] ASC
			,[GrantDate] ASC
			) INCLUDE ([ExercisePrice])
			WITH (
					PAD_INDEX = OFF
					,STATISTICS_NORECOMPUTE = OFF
					,SORT_IN_TEMPDB = OFF
					,DROP_EXISTING = OFF
					,ONLINE = OFF
					,ALLOW_ROW_LOCKS = ON
					,ALLOW_PAGE_LOCKS = ON
					,FILLFACTOR = 95
					,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
					) ON [PRIMARY]
	END
END