/****** Object:  Table [dbo].[Cancelled]    Script Date: 7/6/2022 1:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Cancelled](
	[CancelledId] [numeric](18, 0) NOT NULL,
	[GrantLegSerialNumber] [numeric](18, 0) NOT NULL,
	[CancelledQuantity] [numeric](18, 0) NOT NULL,
	[SplitCancelledQuantity] [numeric](18, 0) NOT NULL,
	[BonusSplitCancelledQuantity] [numeric](18, 0) NOT NULL,
	[CancelledTransID] [numeric](18, 0) NULL,
	[CancelledDate] [datetime] NULL,
	[CancelledPrice] [numeric](10, 2) NOT NULL,
	[VestingType] [char](1) NOT NULL,
	[GrantLegId] [decimal](10, 0) NOT NULL,
	[CancellationType] [char](1) NOT NULL,
	[Status] [char](1) NOT NULL,
	[LastUpdatedBy] [varchar](20) NOT NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Cancelled] PRIMARY KEY CLUSTERED 
(
	[CancelledId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Index [<NonCIndexCan, CancelledInx,>]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND name = N'<NonCIndexCan, CancelledInx,>')
CREATE NONCLUSTERED INDEX [<NonCIndexCan, CancelledInx,>] ON [dbo].[Cancelled]
(
	[GrantLegSerialNumber] ASC
)
INCLUDE([CancelledQuantity],[SplitCancelledQuantity],[BonusSplitCancelledQuantity]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Cancelled_BonusSplitCancelledQuantity]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND name = N'Cancelled_BonusSplitCancelledQuantity')
CREATE NONCLUSTERED INDEX [Cancelled_BonusSplitCancelledQuantity] ON [dbo].[Cancelled]
(
	[BonusSplitCancelledQuantity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Cancelled_CancelledDate]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND name = N'Cancelled_CancelledDate')
CREATE NONCLUSTERED INDEX [Cancelled_CancelledDate] ON [dbo].[Cancelled]
(
	[CancelledDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Cancelled_CancelledQuantity]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND name = N'Cancelled_CancelledQuantity')
CREATE NONCLUSTERED INDEX [Cancelled_CancelledQuantity] ON [dbo].[Cancelled]
(
	[CancelledQuantity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [Cancelled_SplitCancelledQuantity]    Script Date: 7/6/2022 1:57:37 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Cancelled]') AND name = N'Cancelled_SplitCancelledQuantity')
CREATE NONCLUSTERED INDEX [Cancelled_SplitCancelledQuantity] ON [dbo].[Cancelled]
(
	[SplitCancelledQuantity] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cancelled_CancelledTrans]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cancelled]'))
ALTER TABLE [dbo].[Cancelled]  WITH NOCHECK ADD  CONSTRAINT [FK_Cancelled_CancelledTrans] FOREIGN KEY([CancelledTransID])
REFERENCES [dbo].[CancelledTrans] ([CancelledTransID])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cancelled_CancelledTrans]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cancelled]'))
ALTER TABLE [dbo].[Cancelled] CHECK CONSTRAINT [FK_Cancelled_CancelledTrans]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cancelled_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cancelled]'))
ALTER TABLE [dbo].[Cancelled]  WITH CHECK ADD  CONSTRAINT [FK_Cancelled_GrantLeg] FOREIGN KEY([GrantLegSerialNumber])
REFERENCES [dbo].[GrantLeg] ([ID])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Cancelled_GrantLeg]') AND parent_object_id = OBJECT_ID(N'[dbo].[Cancelled]'))
ALTER TABLE [dbo].[Cancelled] CHECK CONSTRAINT [FK_Cancelled_GrantLeg]
GO
/****** Object:  Trigger [dbo].[TRIG_UPDATE_CANCELLATION_REASON]    Script Date: 7/6/2022 1:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIG_UPDATE_CANCELLATION_REASON]'))
EXEC dbo.sp_executesql @statement = N'CREATE TRIGGER [dbo].[TRIG_UPDATE_CANCELLATION_REASON] ON [dbo].[Cancelled]
AFTER DELETE
AS
BEGIN
	DECLARE @GrantOptionID VARCHAR(20),
			@CancelledTransID NUMERIC(18,0),
			@GrantLegSerialNumber NUMERIC(18,0),
			@CancellationReason VARCHAR(200)
			
	SELECT  @GrantLegSerialNumber = GrantLegSerialNumber FROM deleted

	SELECT @CancelledTransID = MAX(CancelledTransID)
	FROM Cancelled
	WHERE GrantLegSerialNumber = @GrantLegSerialNumber
		
	
	IF @CancelledTransID IS NULL
	BEGIN
		UPDATE GrantLeg SET CancellationReason = NULL WHERE ID = @GrantLegSerialNumber
	END
	ELSE
	BEGIN
		SELECT @CancellationReason = CancellationReason FROM CancelledTrans WHERE CancelledTransID = @CancelledTransID
		UPDATE GrantLeg SET CancellationReason = @CancellationReason WHERE ID = @GrantLegSerialNumber
	END
END' 
GO
ALTER TABLE [dbo].[Cancelled] ENABLE TRIGGER [TRIG_UPDATE_CANCELLATION_REASON]
GO
