IF EXISTS (
		SELECT 'X'
		FROM sys.key_constraints
		WHERE name = 'PK_FMVSharePrices'
			AND parent_object_id = object_id('FMVSharePricesTest')
		)
BEGIN
	ALTER TABLE [dbo].[FMVSharePricesTest]

	DROP CONSTRAINT [PK_FMVSharePrices];
END
GO

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.key_constraints
		WHERE name = 'PK_FMVSharePrices'
			AND parent_object_id = object_id('FMVSharePrices')
		)
BEGIN
	ALTER TABLE [dbo].[FMVSharePrices] ADD CONSTRAINT [PK_FMVSharePrices] PRIMARY KEY CLUSTERED ([FMVPriceID] ASC)
		WITH (
				PAD_INDEX = OFF
				,STATISTICS_NORECOMPUTE = OFF
				,SORT_IN_TEMPDB = OFF
				,IGNORE_DUP_KEY = OFF
				,ONLINE = OFF
				,ALLOW_ROW_LOCKS = ON
				,ALLOW_PAGE_LOCKS = ON
				,FILLFACTOR = 90
				,OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
				) ON [PRIMARY]
END
GO

