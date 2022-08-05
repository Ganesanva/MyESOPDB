
If exists (
select 'X'
from sys.triggers 
where name = 'TRG_AUDIT_BuyBackConfigurations'
and is_disabled = 1
)
begin
Enable TRIGGER [dbo].TRG_AUDIT_BuyBackConfigurations
ON [dbo].[BuyBackConfigurations]
end
