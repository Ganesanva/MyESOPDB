If not exists  (
				select 'X'
				from sys.columns 
				where object_id = oBJECT_ID('GrantRegistration')
				and name = 'ExercisePrice'
				and scale = 9
				)
begin 

Alter table GrantRegistration
alter column ExercisePrice NUMERIC (18, 9) NULL
 
end 