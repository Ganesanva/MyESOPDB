DECLARE @Default1 VARCHAR(255)
	,@var1 VARCHAR(255)

SELECT @Default1 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id('ShPerformanceBasedGrant')
	AND parent_column_id IN (
		SELECT column_id
		FROM sys.columns
		WHERE object_id = object_id('ShPerformanceBasedGrant')
			AND name = 'BeforePerfVestDateYN'
		)

SELECT @var1 = 'ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT ' + @Default1

IF EXISTS (
		SELECT 'X'
		FROM sys.default_constraints
		WHERE name = @Default1
		)
BEGIN
	EXEC (@var1)
END
GO

DECLARE @Default2 VARCHAR(255)
	,@var2 VARCHAR(255)

SELECT @Default2 = name
FROM sys.default_constraints
WHERE parent_object_id = object_id('ShPerformanceBasedGrant')
	AND parent_column_id IN (
		SELECT column_id
		FROM sys.columns
		WHERE object_id = object_id('ShPerformanceBasedGrant')
			AND name = 'SendPerfVestAlertYN'
		)

SELECT @var2 = 'ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT ' + @Default2

IF EXISTS (
		SELECT 'X'
		FROM sys.default_constraints
		WHERE name = @Default2
		)
BEGIN
	EXEC (@var2)
END
GO

IF EXISTS (
		SELECT 'X'
		FROM sys.columns
		WHERE object_id = object_id('ShPerformanceBasedGrant')
			AND name = 'BeforePerfVestDateYN'
		)
BEGIN
	ALTER TABLE [dbo].ShPerformanceBasedGrant

	DROP COLUMN BeforePerfVestDateYN
END
GO

IF EXISTS (
		SELECT 'X'
		FROM sys.columns
		WHERE object_id = object_id('ShPerformanceBasedGrant')
			AND name = 'SendPerfVestAlertYN'
		)
BEGIN
	ALTER TABLE [dbo].ShPerformanceBasedGrant

	DROP COLUMN SendPerfVestAlertYN
END
GO

