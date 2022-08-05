IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns a
		INNER JOIN sys.types b ON (a.user_type_id = b.user_type_id)
		WHERE a.object_id = object_id('CompanyParameters')
			AND a.name = 'IsPrimaryEmailIDForLive'
			AND b.name = 'bit'
		)
BEGIN
	ALTER TABLE dbo.CompanyParameters

	ALTER COLUMN [IsPrimaryEmailIDForLive] BIT NULL
END

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns a
		INNER JOIN sys.types b ON (a.user_type_id = b.user_type_id)
		WHERE a.object_id = object_id('CompanyParameters')
			AND a.name = 'IsSecondaryEmailIDForLive'
			AND b.name = 'bit'
		)
BEGIN
	ALTER TABLE dbo.CompanyParameters

	ALTER COLUMN [IsSecondaryEmailIDForLive] BIT NULL
END

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns a
		INNER JOIN sys.types b ON (a.user_type_id = b.user_type_id)
		WHERE a.object_id = object_id('CompanyParameters')
			AND a.name = 'IsPrimaryEmailIDForSep'
			AND b.name = 'bit'
		)
BEGIN
	ALTER TABLE dbo.CompanyParameters

	ALTER COLUMN [IsPrimaryEmailIDForSep] BIT NULL
END

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.columns a
		INNER JOIN sys.types b ON (a.user_type_id = b.user_type_id)
		WHERE a.object_id = object_id('CompanyParameters')
			AND a.name = 'IsSecondaryEmailIDForSep'
			AND b.name = 'bit'
		)
BEGIN
	ALTER TABLE dbo.CompanyParameters

	ALTER COLUMN [IsSecondaryEmailIDForSep] BIT NULL
END