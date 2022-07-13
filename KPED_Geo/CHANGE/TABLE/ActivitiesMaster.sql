IF NOT EXISTS (SELECT 'X' 
				FROM sys.default_constraints
				where parent_object_id = object_id('ActivitiesMaster')
			  )
BEGIN
--ALTER TABLE [dbo].[ActivitiesMaster] ADD  Constraint [DF__Activitie__IsAct__20ACD28B] DEFAULT ((0)) FOR [IsActive]
ALTER TABLE [dbo].[ActivitiesMaster] ADD  DEFAULT ((0)) FOR [IsActive]
END
GO


--Data patch for alredy existing records 
If exists (select 'X' from ActivitiesMaster with(nolock) where IsActive is null )
begin

Update ActivitiesMaster
set IsActive = 0
where IsActive is null

end



