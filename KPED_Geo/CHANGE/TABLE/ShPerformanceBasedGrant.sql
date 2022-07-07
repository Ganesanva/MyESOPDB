If exists (
select 'X' from sys.default_constraints
where name = 'DF__ShPerform__Befor__6B99EBCE'
) 
BEGIN

ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT [DF__ShPerform__Befor__6B99EBCE]

end
go

If exists (
select 'X' from sys.default_constraints
where name = 'DF__ShPerform__SendP__6C8E1007'
) 
BEGIN

ALTER TABLE ShPerformanceBasedGrant 
DROP CONSTRAINT [DF__ShPerform__SendP__6C8E1007]

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

