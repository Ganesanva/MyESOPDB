IF not exists 
(
Select 'X'
from sys.indexes 
where name = '<NonClusterIndx, GrantOptionIDLapseDate>'
and OBJECT_NAME(object_id) = 'LapseTrans'
)
begin
/****** Object:  Index [<NonClusterIndx, GrantOptionIDLapseDate>]    Script Date: 19-07-2022 12:27:28 ******/
CREATE NONCLUSTERED INDEX [<NonClusterIndx, GrantOptionIDLapseDate>] ON [dbo].[LapseTrans]
(
	[GrantLegID] ASC
)
INCLUDE([GrantOptionID],[LapseDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
end
GO

