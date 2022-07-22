IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE name = '<NonClusterIndx, GrantOptionIDLapseDate>'
			AND OBJECT_NAME(object_id) = 'LapseTrans'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [<NonClusterIndx, GrantOptionIDLapseDate>] ON [dbo].[LapseTrans] ([GrantLegID] ASC) INCLUDE (
		[GrantOptionID]
		,[LapseDate]
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
GO

