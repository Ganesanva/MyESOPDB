select object_name(object_id) as tablename, * 
from sys.indexes where type_desc = 'NONCLUSTERED'
and object_id =1904725838

select *
from sys.tables 
where name = 'GrantLetterTemplate'

select *
from sys.objects 
where type in('pk','uQ','F')
and name like '%UQ__GrantLet__BCA8489F764C846B%'

select object_name(a.object_id) as tablename, * 
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'NONCLUSTERED'
and  a.is_unique =0
and a.is_primary_key = 0
and a.index_id<>0
and b.is_ms_shipped  = 0

select object_name(a.object_id) as tablename, * 
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'CLUSTERED'


select object_name(a.object_id) as tablename, * 
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'HEAP'



select  object_name(a.object_id) as tablename,*
--into #tmp
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'NONCLUSTERED'
and object_name(a.object_id) ='FN_ACC_SPLITSTRING'
union
select distinct object_name(a.object_id) as tablename
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'CLUSTERED'
and object_name(a.object_id) ='FN_ACC_SPLITSTRING'
union
select distinct object_name(a.object_id) as tablename
from sys.indexes a 
	 inner join
	 sys.objects b
	 on(a.object_id= b.object_id)
where b.schema_id <>4
and   a.type_desc = 'HEAP'
and object_name(a.object_id) ='FN_ACC_SPLITSTRING'
intersect 
select name
from sys.objects 
where type = 'U'

select *
from sys.objects 
where type = 'U'
and  name in ('FN_ACC_SPLITSTRING')

select *
from #tmp
where tablename like 'fn%'