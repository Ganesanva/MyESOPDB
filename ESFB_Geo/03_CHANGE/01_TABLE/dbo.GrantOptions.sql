
IF not exists 
(
Select 'X'
from sys.indexes 
where name = '<NonCIndesx, GopIDEmpD>'
and OBJECT_NAME(object_id) = 'GrantOptions'

)
begin
/****** Object:  Index [<NonCIndesx, GopIDEmpD>]    Script Date: 19-07-2022 12:37:09 ******/
CREATE NONCLUSTERED INDEX [<NonCIndesx, GopIDEmpD>] ON [dbo].[GrantOptions]
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
end
GO


