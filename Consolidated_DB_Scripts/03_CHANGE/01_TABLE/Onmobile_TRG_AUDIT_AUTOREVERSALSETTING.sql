
If exists (
select 'X'
from sys.triggers 
where name = 'TRG_AUDIT_AUTOREVERSALSETTING'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].[TRG_AUDIT_AUTOREVERSALSETTING]
ON [dbo].[AUTOREVERSALCONFIGMASTER]
end