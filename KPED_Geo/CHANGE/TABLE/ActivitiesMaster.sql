IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF__Activitie__IsAct__20ACD28B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ActivitiesMaster] ADD  Constraint [DF__Activitie__IsAct__20ACD28B] DEFAULT ((0)) FOR [IsActive]
END
GO


--Data patch for alredy existing records 
If exists (select 'X' from ActivitiesMaster with(nolock) where IsActive is null )
begin

Update ActivitiesMaster
set IsActive = 0
where IsActive is null

end

