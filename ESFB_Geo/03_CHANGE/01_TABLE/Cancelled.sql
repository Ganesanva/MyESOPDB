IF not exists (
				SELECT 'X',*
				FROM sys.indexes 
				WHERE object_id = OBJECT_ID('Cancelled')
				AND name='<NonCIndexCan, CancelledInx,>'
		      )
BEGIN
CREATE NONCLUSTERED INDEX [<NonCIndexCan, CancelledInx,>]
    ON [dbo].[Cancelled]([GrantLegSerialNumber] ASC)
    INCLUDE([CancelledQuantity], [SplitCancelledQuantity], [BonusSplitCancelledQuantity]) WITH (FILLFACTOR = 95);
end

