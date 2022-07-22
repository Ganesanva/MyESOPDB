DECLARE @lastcolumnname VARCHAR(100)
	,@last_prev_columname VARCHAR(100)

SELECT TOP 1 @lastcolumnname = name
FROM sys.columns
WHERE object_id = object_id('GrantAccMassUpload')
ORDER BY column_id DESC

SELECT TOP 1 @last_prev_columname = name
FROM sys.columns
WHERE object_id = object_id('GrantAccMassUpload')
	AND name <> @lastcolumnname
ORDER BY column_id DESC

--Select @lastcolumnname,@last_prev_columname
IF (
		@lastcolumnname <> 'TEMPLATE_NAME'
		OR @last_prev_columname <> 'ISATTACHMENT'
		)
BEGIN
	SELECT *
	INTO GrantAccMassUpload_backup
	FROM GrantAccMassUpload

	ALTER TABLE GrantAccMassUpload ADD [TEMPLATE_NAME_bk] [nvarchar] (500) NULL

	DECLARE @text VARCHAR(max)

	SELECT @text = 'Update GrantAccMassUpload
	set [TEMPLATE_NAME_bk] = [TEMPLATE_NAME]'

	EXEC (@text)

	IF NOT EXISTS (
			SELECT GAMUID
				,TEMPLATE_NAME
			FROM GrantAccMassUpload_backup
			
			EXCEPT
			
			SELECT GAMUID
				,TEMPLATE_NAME_bk
			FROM GrantAccMassUpload
			)
	BEGIN
		ALTER TABLE GrantAccMassUpload

		DROP COLUMN [TEMPLATE_NAME]

		EXEC sp_rename 'GrantAccMassUpload.TEMPLATE_NAME_bk'
			,'TEMPLATE_NAME';

		DROP TABLE GrantAccMassUpload_backup
	END
END