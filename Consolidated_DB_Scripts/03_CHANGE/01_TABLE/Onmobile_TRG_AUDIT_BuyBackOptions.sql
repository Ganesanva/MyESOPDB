
If exists (
select 'X'
from sys.triggers 
where name = 'TRG_AUDIT_BuyBackOptions'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRG_AUDIT_BuyBackOptions
ON [dbo].BuyBackOptions
end
