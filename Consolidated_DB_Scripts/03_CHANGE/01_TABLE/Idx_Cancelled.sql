IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('Cancelled')
			AND name = '<NonCIndexCan, CancelledInx,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [<NonCIndexCan, CancelledInx,>] ON [dbo].[Cancelled] ([GrantLegSerialNumber] ASC) INCLUDE (
		[CancelledQuantity]
		,[SplitCancelledQuantity]
		,[BonusSplitCancelledQuantity]
		)
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