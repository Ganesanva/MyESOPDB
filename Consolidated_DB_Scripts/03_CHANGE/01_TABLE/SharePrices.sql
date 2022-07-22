IF NOT EXISTS (
		SELECT 'X'
		FROM sys.key_constraints
		WHERE name = 'PK_SharePrices'
			AND parent_object_id = object_id('SharePrices')
		)
BEGIN
	ALTER TABLE [dbo].[SharePrices] ADD CONSTRAINT [PK_SharePrices] PRIMARY KEY CLUSTERED ([PriceID] ASC)
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.key_constraints
		WHERE name = 'IX_SharePrices'
			AND parent_object_id = object_id('SharePrices')
		)
BEGIN
	ALTER TABLE [dbo].[SharePrices] ADD CONSTRAINT [IX_SharePrices] UNIQUE NONCLUSTERED ([PriceDate] ASC)
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

