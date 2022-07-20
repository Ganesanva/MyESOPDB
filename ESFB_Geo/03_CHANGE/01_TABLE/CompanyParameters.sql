IF exists (
  select 'X'
  from sys.columns  a 
	   inner join 
	   sys.types b 
  on(a.user_type_id = b.user_type_id)
  where a.object_id = object_id('CompanyParameters') 
  and a.name = 'IsPrimaryEmailIDForLive'
  and b.name = 'int'
)
Begin
Alter table dbo.CompanyParameters
alter column [IsPrimaryEmailIDForLive] BIT NULL
end

IF exists (
  select 'X'
  from sys.columns  a 
	   inner join 
	   sys.types b 
  on(a.user_type_id = b.user_type_id)
  where a.object_id = object_id('CompanyParameters') 
  and a.name = 'IsSecondaryEmailIDForLive'
  and b.name = 'int'
)
Begin
Alter table dbo.CompanyParameters
alter column [IsSecondaryEmailIDForLive]  BIT  NULL
end

IF exists (
  select 'X'
  from sys.columns  a 
	   inner join 
	   sys.types b 
  on(a.user_type_id = b.user_type_id)
  where a.object_id = object_id('CompanyParameters') 
  and a.name = 'IsPrimaryEmailIDForSep'
  and b.name = 'int'
)
Begin

Alter table dbo.CompanyParameters
alter column [IsPrimaryEmailIDForSep] BIT NULL
end
IF exists (
  select 'X'
  from sys.columns  a 
	   inner join 
	   sys.types b 
  on(a.user_type_id = b.user_type_id)
  where a.object_id = object_id('CompanyParameters') 
  and a.name = 'IsSecondaryEmailIDForSep'
  and b.name = 'int'
)
Begin

Alter table dbo.CompanyParameters
alter column  [IsSecondaryEmailIDForSep] BIT NULL
end

  


