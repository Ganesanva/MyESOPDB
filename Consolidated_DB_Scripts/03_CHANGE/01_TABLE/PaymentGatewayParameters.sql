DECLARE @lastcolumnname VARCHAR(100)
	,@last_prev_columname VARCHAR(100)

SELECT TOP 1 @lastcolumnname = name
FROM sys.columns
WHERE object_id = object_id('PaymentGatewayParameters')
ORDER BY column_id DESC

SELECT TOP 1 @last_prev_columname = name
FROM sys.columns
WHERE object_id = object_id('PaymentGatewayParameters')
	AND name <> @lastcolumnname
ORDER BY column_id DESC

--SELECT @lastcolumnname,@last_prev_columname

IF (
		@lastcolumnname <> 'IS_TRANS_REVERSAL_MAIL_ENABLED'
		OR @last_prev_columname <> 'BLOCK_HRS'
		)
BEGIN
	SELECT *
	INTO PaymentGatewayParameters_backup
	FROM PaymentGatewayParameters

	IF NOT EXISTS (
			SELECT column_id
			FROM sys.columns
			WHERE object_id = object_id('PaymentGatewayParameters')
				AND name = 'BLOCK_HRS_bk'
			)
	BEGIN
		ALTER TABLE [dbo].PaymentGatewayParameters ADD [BLOCK_HRS_bk] INT
	END

	IF NOT EXISTS (
			SELECT column_id
			FROM sys.columns
			WHERE object_id = object_id('PaymentGatewayParameters')
				AND name = 'IS_TRANS_REVERSAL_MAIL_ENABLED_bk'
			)
	BEGIN
		ALTER TABLE [dbo].PaymentGatewayParameters ADD [IS_TRANS_REVERSAL_MAIL_ENABLED_bk] CHAR(1)
	END

	IF EXISTS (
			SELECT column_id
			FROM sys.columns
			WHERE object_id = object_id('PaymentGatewayParameters')
				AND name = 'BLOCK_HRS_bk'
			)
	BEGIN
		DECLARE @text VARCHAR(max)

		SELECT @text = 'Update PaymentGatewayParameters
	set [BLOCK_HRS_bk] = [BLOCK_HRS],
		[IS_TRANS_REVERSAL_MAIL_ENABLED_bk]=[IS_TRANS_REVERSAL_MAIL_ENABLED]'

		EXEC (@text)
	END

	IF NOT EXISTS (
			SELECT [BLOCK_HRS]
				,[IS_TRANS_REVERSAL_MAIL_ENABLED]
			FROM PaymentGatewayParameters_backup
			
			EXCEPT
			
			SELECT [BLOCK_HRS_bk]
				,[IS_TRANS_REVERSAL_MAIL_ENABLED_bk]
			FROM PaymentGatewayParameters
			)
	BEGIN
		DECLARE @defaultcons_name1 VARCHAR(max)
			,@defaultcons_name2 VARCHAR(max)

		SELECT @defaultcons_name1 = 'ALTER TABLE PaymentGatewayParameters
DROP CONSTRAINT ' + NAme
		FROM sys.default_constraints
		WHERE parent_object_id = object_id('PaymentGatewayParameters')
			AND parent_column_id IN (
				SELECT column_id
				FROM sys.columns
				WHERE object_id = object_id('PaymentGatewayParameters')
					AND name = 'BLOCK_HRS'
				)
			AND type = 'D'

		SELECT @defaultcons_name2 = 'ALTER TABLE PaymentGatewayParameters
DROP CONSTRAINT ' + NAme
		FROM sys.default_constraints
		WHERE parent_object_id = object_id('PaymentGatewayParameters')
			AND parent_column_id IN (
				SELECT column_id
				FROM sys.columns
				WHERE object_id = object_id('PaymentGatewayParameters')
					AND name = 'IS_TRANS_REVERSAL_MAIL_ENABLED'
				)
			AND type = 'D'

		--select @defaultcons_name1,@defaultcons_name2
		EXEC (@defaultcons_name1)

		EXEC (@defaultcons_name2)

		ALTER TABLE PaymentGatewayParameters

		DROP COLUMN [BLOCK_HRS]

		ALTER TABLE PaymentGatewayParameters

		DROP COLUMN [IS_TRANS_REVERSAL_MAIL_ENABLED]

		EXEC sp_rename 'PaymentGatewayParameters.BLOCK_HRS_bk'
			,'BLOCK_HRS';

		EXEC sp_rename 'PaymentGatewayParameters.IS_TRANS_REVERSAL_MAIL_ENABLED_bk'
			,'IS_TRANS_REVERSAL_MAIL_ENABLED';

		DROP TABLE PaymentGatewayParameters_backup

		IF NOT EXISTS (
				SELECT 'X'
				FROM sys.default_constraints
				WHERE parent_object_id = object_id('PaymentGatewayParameters')
					AND parent_column_id IN (
						SELECT column_id
						FROM sys.columns
						WHERE object_id = object_id('PaymentGatewayParameters')
							AND name = 'BLOCK_HRS'
						)
					AND type = 'D'
				)
		BEGIN
			ALTER TABLE [dbo].[PaymentGatewayParameters] ADD DEFAULT((0))
			FOR [BLOCK_HRS]
		END

		IF NOT EXISTS (
				SELECT 'X'
				FROM sys.default_constraints
				WHERE parent_object_id = object_id('PaymentGatewayParameters')
					AND parent_column_id IN (
						SELECT column_id
						FROM sys.columns
						WHERE object_id = object_id('PaymentGatewayParameters')
							AND name = 'IS_TRANS_REVERSAL_MAIL_ENABLED'
						)
					AND type = 'D'
				)
		BEGIN
			ALTER TABLE [dbo].[PaymentGatewayParameters] ADD DEFAULT((0))
			FOR [IS_TRANS_REVERSAL_MAIL_ENABLED]
		END

		--Data patch for alredy existing records 
		IF EXISTS (
				SELECT 'X'
				FROM PaymentGatewayParameters WITH (NOLOCK)
				WHERE BLOCK_HRS IS NULL
				)
		BEGIN
			UPDATE PaymentGatewayParameters
			SET BLOCK_HRS = 0
			WHERE BLOCK_HRS IS NULL
		END

		IF EXISTS (
				SELECT 'X'
				FROM PaymentGatewayParameters WITH (NOLOCK)
				WHERE IS_TRANS_REVERSAL_MAIL_ENABLED IS NULL
				)
		BEGIN
			UPDATE PaymentGatewayParameters
			SET IS_TRANS_REVERSAL_MAIL_ENABLED = 0
			WHERE IS_TRANS_REVERSAL_MAIL_ENABLED IS NULL
		END
	END
END