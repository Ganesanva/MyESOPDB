If exists (
Select 'X'
from sys.objects 
where name ='TEMP_FMV_DETAILS'
)
begin
IF not exists (
Select 'X'
from sys.columns  a 
	 inner join
	 sys.types b 
on(a.user_type_id = b.user_type_id)
where a.object_id = object_id('TEMP_FMV_DETAILS')
and   a.name='GRANTOPTIONID'
and   b.name = 'varchar'
and   a.max_length = 100
)
begin 
Alter table TEMP_FMV_DETAILS
alter column [GRANTOPTIONID]  VARCHAR (100)  NULL
end 
end