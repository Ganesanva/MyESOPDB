IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE name = '<NonCIndesx, GopIDEmpD>'
			AND OBJECT_NAME(object_id) = 'GrantOptions'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [<NonCIndesx, GopIDEmpD>] ON [dbo].[GrantOptions] ([EmployeeId] ASC)
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

