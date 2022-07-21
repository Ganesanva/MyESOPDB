Declare @Default1 varchar(255),
		@var1 varchar(255)

select @Default1 = name 
from sys.default_constraints 
where parent_object_id = object_id('ShPerformanceBasedGrant')
and parent_column_id in (		
						select column_id
						from sys.columns 
						where object_id = object_id('ShPerformanceBasedGrant')
						and name = 'BeforePerfVestDateYN'
						)

select @var1 = 'ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT '+ @Default1


If exists (
select 'X' from sys.default_constraints
where name = @Default1
) 
BEGIN

EXEC(@var1)

end
go

Declare @Default2 varchar(255),
		@var2 varchar(255)

select @Default2 = name 
from sys.default_constraints 
where parent_object_id = object_id('ShPerformanceBasedGrant')
and parent_column_id in (		
						select column_id
						from sys.columns 
						where object_id = object_id('ShPerformanceBasedGrant')
						and name = 'SendPerfVestAlertYN'
						)

select @var2 = 'ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT '+ @Default2

If exists (
select 'X' from sys.default_constraints
where name = @Default2
) 
BEGIN

EXEC(@var2)

end
go


If exists (
select 'X' from sys.columns where object_id = object_id('ShPerformanceBasedGrant') and name = 'BeforePerfVestDateYN'
)
BEGIN

ALTER TABLE [dbo].ShPerformanceBasedGrant
DROP column BeforePerfVestDateYN

END
go

If exists (
select 'X' from sys.columns where object_id = object_id('ShPerformanceBasedGrant') and name = 'SendPerfVestAlertYN'
)
BEGIN

ALTER TABLE [dbo].ShPerformanceBasedGrant
DROP column SendPerfVestAlertYN

END
go

