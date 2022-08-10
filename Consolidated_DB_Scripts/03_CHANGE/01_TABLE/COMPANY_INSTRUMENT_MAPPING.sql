DECLARE @lastcolumnname VARCHAR(100)
	,@last_prev_columname VARCHAR(100)
	
SELECT TOP 1 @lastcolumnname = name
FROM sys.columns
WHERE object_id = object_id('COMPANY_INSTRUMENT_MAPPING')
ORDER BY column_id DESC

SELECT TOP 1 @last_prev_columname = name
FROM sys.columns
WHERE object_id = object_id('COMPANY_INSTRUMENT_MAPPING')
	AND name <> @lastcolumnname
ORDER BY column_id DESC

--Select @lastcolumnname,@last_prev_columname
IF (
		@lastcolumnname <> 'IsTaxApplicable'
		)
BEGIN
	SELECT *
	INTO COMPANY_INSTRUMENT_MAPPING_backup
	FROM COMPANY_INSTRUMENT_MAPPING;

	
	ALTER TABLE COMPANY_INSTRUMENT_MAPPING ADD [IsNonResident_bk]  INT      NULL;
	ALTER TABLE COMPANY_INSTRUMENT_MAPPING ADD [IsForeignNational_bk]   INT    NULL;
	ALTER TABLE COMPANY_INSTRUMENT_MAPPING ADD [IsTaxApplicable_bk] VARCHAR(500)  NULL;





    
	DECLARE @text VARCHAR(max)

	SELECT @text = 'Update COMPANY_INSTRUMENT_MAPPING
	set [IsNonResident_bk] = [IsNonResident], [IsForeignNational_bk]=[IsForeignNational],[IsTaxApplicable_bk]=[IsTaxApplicable]'

	EXEC (@text)

	IF NOT EXISTS (
			SELECT CIM_ID
				,IsNonResident
				,IsForeignNational
				,IsTaxApplicable
			FROM COMPANY_INSTRUMENT_MAPPING_backup
			
			EXCEPT
			
			SELECT CIM_ID
				,IsNonResident_bk
				,IsForeignNational_bk
				,IsTaxApplicable_bk
			FROM COMPANY_INSTRUMENT_MAPPING
			)
	BEGIN
		ALTER TABLE COMPANY_INSTRUMENT_MAPPING
		DROP COLUMN IsNonResident

		ALTER TABLE COMPANY_INSTRUMENT_MAPPING
		DROP COLUMN IsForeignNational

		ALTER TABLE COMPANY_INSTRUMENT_MAPPING
		DROP COLUMN IsTaxApplicable

		EXEC sp_rename 'COMPANY_INSTRUMENT_MAPPING.IsNonResident_bk'
			,'IsNonResident';

		EXEC sp_rename 'COMPANY_INSTRUMENT_MAPPING.IsForeignNational_bk'
	        ,'IsForeignNational';

		EXEC sp_rename 'COMPANY_INSTRUMENT_MAPPING.IsTaxApplicable_bk'
	       ,'IsTaxApplicable';

	DROP TABLE COMPANY_INSTRUMENT_MAPPING_backup
	END
END