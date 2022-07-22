IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns
		WHERE object_id = object_id('GrantRegistration')
			AND name = 'ExercisePrice'
			AND precision = 18
			AND scale = 9
		)
BEGIN
	ALTER TABLE [dbo].GrantRegistration

	ALTER COLUMN [ExercisePrice] NUMERIC(18, 9) NULL
END