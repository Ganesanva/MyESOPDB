If exists (
select 'X' from sys.columns where object_id = object_id('GrantRegistration') and name = 'ExercisePrice'
and scale=2
)
BEGIN
ALTER TABLE [dbo].GrantRegistration
ALTER COLUMN    [ExercisePrice]  NUMERIC (18, 9) NULL
END
