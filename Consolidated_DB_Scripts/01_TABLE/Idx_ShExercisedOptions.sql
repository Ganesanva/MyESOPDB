IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = '<NonShindxIndex, Shexindex,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [<NonShindxIndex, Shexindex,>] ON [dbo].[ShExercisedOptions] (
		[IsMassUpload] ASC
		,[Action] ASC
		,[Cash] ASC
		) INCLUDE (
		[GrantLegSerialNumber]
		,[ExercisedQuantity]
		,[ExercisePrice]
		,[ExerciseDate]
		,[ExerciseNo]
		,[PerqstValue]
		,[PerqstPayable]
		,[FMVPrice]
		,[PaymentMode]
		,[isFormGenerate]
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'IndexShEx, ShIndex,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [IndexShEx, ShIndex,>] ON [dbo].[ShExercisedOptions] ([GrantLegSerialNumber] ASC)
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonCIndexShEx, ShExIndx,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonCIndexShEx, ShExIndx,>] ON [dbo].[ShExercisedOptions] ([GrantLegId] ASC) INCLUDE (
		[GrantLegSerialNumber]
		,[ExercisedQuantity]
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonShExerciseIndex, Shexindex1,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonShExerciseIndex, Shexindex1,>] ON [dbo].[ShExercisedOptions] ([GrantLegId] ASC) INCLUDE (
		[GrantLegSerialNumber]
		,[ExercisedQuantity]
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonShexIndex2, ShexerIndexExNo,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonShexIndex2, ShexerIndexExNo,>] ON [dbo].[ShExercisedOptions] ([ExerciseNo] ASC)
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonShexIndex3, ShExerciedIndex,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonShexIndex3, ShExerciedIndex,>] ON [dbo].[ShExercisedOptions] ([GrantLegSerialNumber] ASC) INCLUDE (
		[ExercisedQuantity]
		,[SplitExercisedQuantity]
		,[ExercisePrice]
		,[ExerciseDate]
		,[EmployeeID]
		,[ValidationStatus]
		,[Action]
		,[ExerciseNo]
		,[LotNumber]
		,[PerqstValue]
		,[PerqstPayable]
		,[FMVPrice]
		,[Perq_Tax_rate]
		,[PaymentMode]
		,[ExerciseFormReceived]
		,[ReceivedDate]
		,[ExerciseSARid]
		,[IsPaymentDeposited]
		,[PaymentDepositedDate]
		,[IsPaymentConfirmed]
		,[PaymentConfirmedDate]
		,[IsExerciseAllotted]
		,[ExerciseAllotedDate]
		,[IsAllotmentGenerated]
		,[AllotmentGenerateDate]
		,[IsAllotmentGeneratedReversed]
		,[AllotmentGeneratedReversedDate]
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonShexIndex3, ShGrantLegSIndx,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonShexIndex3, ShGrantLegSIndx,>] ON [dbo].[ShExercisedOptions] ([GrantLegId] ASC) INCLUDE (
		[GrantLegSerialNumber]
		,[ExercisedQuantity]
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

IF NOT EXISTS (
		SELECT 'X'
		FROM sys.indexes
		WHERE object_id = OBJECT_ID('ShExercisedOptions')
			AND name = 'NonShexIndexExNo, ExerNoIndex,>'
		)
BEGIN
	CREATE NONCLUSTERED INDEX [NonShexIndexExNo, ExerNoIndex,>] ON [dbo].[ShExercisedOptions] (
		[EmployeeID] ASC
		,[ExerciseNo] ASC
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

